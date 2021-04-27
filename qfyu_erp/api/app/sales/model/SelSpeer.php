<?php
namespace app\sales\model;
use app\erp\model\Customer;
use app\erp\model\Employee;
use app\helper\CommonFun;
use app\sales\validate\SelSpeerVal;
use think\facade\Db;
use think\Model;

Class SelSpeer extends Model{
    public static function queryList($inData){
        $data = SelSpeer::alias('s')
            ->join('customer c','c.id = s.cust_no', 'LEFT')
            ->field('s.*,c.name as cust_name')
            ->select()->toArray();
        return $data;
    }
    public static function auditSalesOrder($inData,$uCode){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $orderId = strip_tags($inData['orderid']);
        $where['orderid'] = $orderId;
        $upData['audit'] = $uCode;
        $upData['is_transfer'] = 1;
        $upData['update_date'] = date('Y-m-d H:i:s',time());
        $re = SelSpeer::where($where)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'审核成功','audit'=>$uCode];
        return $res;
    }
    public static function reductionOrder($inData,$uCode){
        $res = ['status'=>0,'msg'=>'还原失败'];
        $orderId = strip_tags($inData['orderid']);
        $where['orderid'] = $orderId;
        $upData['audit'] = null;
        $upData['is_transfer'] = 0;
        $upData['update_date'] = date('Y-m-d H:i:s',time());
        $re = SelSpeer::where($where)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'还原成功','audit'=>$uCode];
        return $res;
    }
    public static function queryOne($inData){
        $data = null;
        $orderId = $inData['quotation_orderid'];
        $custData = null;
        $details = null;
        if(!$orderId) goto _end;
        $data = SelSpeer::field('*')->where('orderid',$orderId)->find();
        if($data){
            $details = SelSpeerDtl::alias('s')->join('commodity c','c.goods_code = s.goods_code','left')->field('s.*,c.goods_name,c.specs,c.origin,c.production,c.dosage,c.approval_code,c.packspecs')->where('orderid',$orderId)->select()->toArray();
            $cust_data = Customer::getSimpleList([['id','=',$data['cust_no']]],1);
            if($cust_data){
                $custData = $cust_data['data'][0];
                $data['cust_name'] = $custData['name'];
            }else $data['cust_name'] = '';
        }
        _end:
        return ['data'=>$data,'details'=>$details,'cust_data'=>$custData];
    }
    /** 保存销售报价单 */
    public static function addData($inData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $data = CommonFun::ProcessingData($inData['fdata'],['is_finish','is_transfer']);
        $data['details'] = $inData['data'];
        $validate = new SelSpeerVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $newTime = time();
        $details = $data['details'];
        unset($data['details']);
        $reData = $data;
        unset($data['creater']);
        unset($data['create_date']);
        unset($data['is_transfer']);
        unset($data['is_finish']);
        unset($data['f_date']);
        if($data['orderid']) $orderId = $data['orderid'];
        else $orderId = CommonFun::createOrder('SS');
        $selSpeerDtl = [];
        $goods_sum = 0;
        $tax_sum = 0;
        $amount = 0;
        $goods_qty = 0;
        foreach($details as $k=>$val){
            $v = CommonFun::ProcessingData($val,[],['o_price','rebate','tax_rate','qty']);
            $v['item_no'] = $k+1;
            $v['orderid'] = $orderId;
            if($v['rebate']) $v['price'] = calc([$v['o_price'],'*',$v['rebate'],'/',100],6);
            else $v['price'] = $v['o_price'];
            $v['amount'] = calc([$v['price'],'*',$v['qty']],6);
            $v['un_tax_price'] = calc([$v['price'],'/',calc([$v['tax_rate'],'+',100],5),'*',100],6);
            $v['goods_sum'] = calc([$v['un_tax_price'],'*',$v['qty']],6);
            $v['tax_sum'] = calc([$v['amount'],'-',$v['goods_sum']],6);
            $selSpeerDtl[$k] = $v;
            $goods_qty = calc([$goods_qty,'+',$v['qty']],3);
            $goods_sum = calc([$goods_sum,'+',$v['goods_sum']],6);
            $tax_sum = calc([$tax_sum,'+',$v['tax_sum']],6);
            $amount = calc([$amount,'+',$v['amount']],6);
        }
        $selSpeerData = $data;
        $selSpeerData['audit'] = null;
        $selSpeerData['orderid'] = $orderId;
        $selSpeerData['goods_qty'] = $goods_qty;
        $selSpeerData['goods_sum'] = $goods_sum;
        $selSpeerData['tax_sum'] = $tax_sum;
        $selSpeerData['amount'] = $amount;
        Db::startTrans();
        if(!$data['orderid']){
            $selSpeerData['f_date'] = date('Y-m-d',$newTime);
            $selSpeerData['is_transfer'] = 0;
            $selSpeerData['is_finish'] = 0;
            $selSpeerData['creater'] = $uCode;
            $selSpeerData['create_date'] = date('Y-m-d H:i:s',$newTime);
            $departId = Employee::where(['code'=>$uCode])->value('depart_id');
            $selSpeerData['dept_id'] = $departId;
            $re1 = SelSpeer::strict(false)->insert($selSpeerData);
            $re2 = SelSpeerDtl::strict(false)->insertAll($selSpeerDtl);
        }else{
            unset($selSpeerData['dept_id']);
            $selSpeerData['mender'] = $uCode;
            $selSpeerData['update_date'] = date('Y-m-d H:i:s',$newTime);
            $re1 = SelSpeer::strict(false)->where('orderid','=',$orderId)->update($selSpeerData);
            $re2 = SelSpeerDtl::strict(false)->where('orderid','=',$orderId)->deleteInsertAll($selSpeerDtl);
            $selSpeerData['f_date'] = $reData['f_date'];
            $selSpeerData['is_transfer'] = $reData['is_transfer'];
            $selSpeerData['is_finish'] = $reData['is_finish'];
            $selSpeerData['creater'] = $reData['creater'];
            $selSpeerData['create_date'] = $reData['create_date'];
        }
        if($re1 && $re2){
            Db::commit();
            $res = ['status'=>1,'msg'=>'保存成功','data'=>$selSpeerData,'details'=>$selSpeerDtl];
        }else Db::rollback();
        _end:
        return $res;
    }
    /** 转单 */
    public static function transferOrder($data,$uCode){
        $res = ['status'=>0,'msg'=>'转单失败'];
        $orderId = strip_tags($data['orderid']);
        $where[] = ['orderid','=',$orderId];
        $where[] = ['is_transfer','=',1];
        $selSpeer = SelSpeer::where($where)->field('*')->find()->toArray();
        $selSpeerDtl =  SelSpeerDtl::where('orderid','=',$orderId)->field('*')->select()->toArray();
        if(!$selSpeer || !$selSpeerDtl) goto _end;
        $res = SelOrder::speerTransfer($selSpeer,$selSpeerDtl,$uCode);
        _end:
        return $res;
    }
}