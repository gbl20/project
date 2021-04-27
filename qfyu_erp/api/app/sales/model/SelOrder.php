<?php
namespace app\sales\model;
use app\erp\model\Customer;
use app\erp\model\Employee;
use app\helper\CommonFun;
use app\sales\validate\SelOrderVal;
use think\facade\Db;
use think\Model;

Class SelOrder extends Model{
    public static function queryList($inData){
        $pageSize = isset($inData['page_size'])?intval($inData['page_size']):10;
        $page = isset($inData['page'])?intval($inData['page']):1;
        $serData = CommonFun::ProcessingData($inData['ser_data'],['depart','is_finish','is_pass_on','is_transfer']);
        $where = [];
        if($serData['orderid']!==null){
            $where[] = ['s.orderid','like','%'.$serData['orderid'].'%'];
        }
        if(isset($serData['contract_no']) && $serData['contract_no']!==null){
            $where[] = ['s.contract_no','like','%'.$serData['contract_no'].'%'];
        }
        if($serData['start_f_date']!==null && $serData['end_f_date']!==null){
            $where[] = ['s.f_date','between',[$serData['start_f_date'],$serData['end_f_date']]];
        }elseif($serData['start_f_date']!==null){
            $where[] = ['s.f_date','>=',$serData['start_f_date']];
        }elseif($serData['end_f_date']!==null){
            $where[] = ['s.f_date','<=',$serData['end_f_date']];
        }
        if($serData['phone']!==null){
            $where[] = ['c.telephone','like','%'.$serData['phone'].'%'];
        }
        if(isset($serData['depart']) && $serData['depart']!==null){
            $where[] = ['s.dept_id','=',$serData['depart']];
        }
        if(isset($serData['is_finish']) && $serData['is_finish']!==null){
            $where[] = ['s.is_finish','=',$serData['is_finish']];
        }
        if(isset($serData['is_pass_on']) && $serData['is_pass_on']!==null){
            $where[] = ['s.is_pass_on','=',$serData['is_pass_on']];
        }
        if(isset($serData['is_transfer']) && $serData['is_transfer']!==null){
            $where[] = ['s.is_transfer','=',$serData['is_transfer']];
        }
        if(isset($serData['pay_mode_no']) && $serData['pay_mode_no']!==null){
            $where[] = ['s.pay_mode_no','=',$serData['pay_mode_no']];
        }
        if(isset($serData['cust_no']) && $serData['cust_no']!==null){
            $where[] = ['s.cust_no','=',$serData['cust_no']];
        }
        if(isset($serData['creater']) && $serData['creater']!==null){
            $where[] = ['s.creater','=',$serData['creater']];
        }
        if(isset($serData['audit']) && $serData['audit']!==null){
            $where[] = ['s.audit','=',$serData['audit']];
        }
        $data = SelOrder::alias('s')
            ->join('customer c','c.id = s.cust_no', 'LEFT')
            ->field('s.*,c.name as cust_name')->where($where)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $data;
    }
    public static function queryOne($inData){
        $data = null;
        $orderId = $inData['quotation_orderid'];
        $custData = null;
        $details = null;
        if(!$orderId) goto _end;
        $data = SelOrder::field('*')->where('orderid',$orderId)->find();
        if($data){
            $field = 's.*,c.goods_name,c.specs,c.origin,c.production,c.dosage,c.approval_code,c.packspecs,c.gsp_type,c.production,w.ware_title';
            $format = 's.o_price,s.price,s.goods_sum,s.tax_sum,s.un_tax_price,s.tax_rate,s.rebate,s.qty,s.amount';
            $details = SelOrderDtl::alias('s')
                ->join('commodity c','c.goods_code = s.goods_code','left')
                ->join('warehouse w','w.ware_code = s.ware_code','left')
                ->field($field,$format)
                ->where('orderid',$orderId)
                ->select()->toArray();
            $cust_data = Customer::getSimpleList([['id','=',$data['cust_no']]],1);
            if($cust_data){
                $custData = $cust_data['data'][0];
                $data['cust_name'] = $custData['name'];
            }else $data['cust_name'] = '';
        }
        _end:
        return ['data'=>$data,'details'=>$details,'cust_data'=>$custData];
    }
    public static function addData($inData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $date = date('Y-m-d',time());
        $dateTime = date('Y-m-d H:i:s',time());
        $data = CommonFun::ProcessingData($inData['fdata'],['is_finish','is_transfer']);
        $data['details'] = $inData['data'];
        $validate = new SelOrderVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $orderId = $data['orderid'];
        if(!$orderId) $orderId = CommonFun::createOrder('SO');
        $reOrderDtl = [];
        $goods_qty = 0;//总数量
        $goods_sum = 0;//货款
        $tax_sum = 0;//税款
        $amount = 0;//总价
        foreach($data['details'] as $k=>$val){
            $v = CommonFun::ProcessingData($val,[],['s_o_price','s_rebate','s_tax_rate','s_qty']);
            $reDtl = [];
            $reDtl['orderid'] = $orderId;
            $reDtl['item_no'] = $k+1;
            $reDtl['goods_code'] = $v['goods_code'];
            $reDtl['unit'] = $v['unit'];
            $reDtl['qty'] = $v['s_qty'];
            $reDtl['o_price'] = $v['s_o_price'];
            $reDtl['rebate'] = $v['s_rebate'];
            $reDtl['price'] = $v['s_rebate']?calc([$v['s_rebate'],'*',$v['s_o_price'],'/',100],6):$v['s_o_price'];
            $reDtl['tax_rate'] = $v['s_tax_rate'];
            $taxRate = calc([$v['s_tax_rate'],'+','100'],6);
            $reDtl['un_tax_price'] = calc([$reDtl['price'],'/',$taxRate,'*',100],6);
            $reDtl['goods_sum'] = calc([$reDtl['un_tax_price'],'*',$reDtl['qty']],6);
            $reDtl['amount'] = calc([$reDtl['price'],'*',$reDtl['qty']],6);
            $reDtl['tax_sum'] = calc([$reDtl['amount'],'-',$reDtl['goods_sum']],6);
            $reDtl['remark'] = $v['remark'];
            $reDtl['cust_goods_code'] = $v['cust_goods_code'];
            $reDtl['batch_no'] = isset($v['batch_no'])?$v['batch_no']:null;
            $reDtl['valid_date'] = isset($v['valid_date'])?$v['valid_date']:null;
            $reDtl['prod_date'] = isset($v['prod_date'])?$v['prod_date']:null;
            $reDtl['prov_no'] = isset($v['prov_no'])?$v['prov_no']:null;
            $reDtl['ware_code'] = isset($v['batch_no'])?$v['ware_code']:null;
            $reDtl['berth_no'] = isset($v['berth_no'])?$v['berth_no']:null;
            $reDtl['quality_state'] = isset($v['quality_state'])?$v['quality_state']:null;
            $reDtl['goods_state'] = isset($v['goods_state'])?$v['goods_state']:null;
            $goods_qty = calc([$goods_qty,'+',$reDtl['qty']],5);
            $goods_sum = calc([$goods_sum,'+',$reDtl['goods_sum']],6);
            $tax_sum = calc([$tax_sum,'+',$reDtl['tax_sum']],6);
            $amount = calc([$amount,'+',$reDtl['amount']],6);
            $reOrderDtl[$k] = $reDtl;
        }
        $reOrderD['deal_date'] = $data['deal_date'];
        $reOrderD['sign_addr'] = $data['sign_addr'];
        $reOrderD['begin_date'] = $data['begin_date'];
        $reOrderD['end_date'] = $data['end_date'];
        $reOrderD['contract_type'] = $data['contract_type'];
        $reOrderD['contract_no'] = $data['contract_no'];
        $reOrderD['emp_no'] = $data['emp_no'];
        $reOrderD['cust_no'] = $data['cust_no'];
        $reOrderD['link_man'] = $data['link_man'];
        $reOrderD['deal_mode'] = $data['deal_mode'];
        $reOrderD['carr_kind'] = $data['carr_kind'];
        $reOrderD['carr_addr'] = $data['carr_addr'];
        $reOrderD['pick_addr'] = $data['pick_addr'];
        $reOrderD['pay_mode_no'] = $data['pay_mode_no'];
        $reOrderD['pay_date'] = $data['pay_date'];
        $reOrderD['remark'] = $data['remark'];
        $reOrderD['pre_pay'] = $data['pre_pay'];
        $reOrderD['contacts'] = $data['contacts'];
        $reOrderD['goods_qty'] = $goods_qty;
        $reOrderD['goods_sum'] = $goods_sum;
        $reOrderD['tax_sum'] = $tax_sum;
        $reOrderD['amount'] = $amount;
        Db::startTrans();
        if($data['orderid']){
            $reOrderD['mender'] = $uCode;
            $reOrderD['update_date'] = $dateTime;
            $where = [];
            $where[] = ['is_transfer','=',0];
            $where[] = ['orderid','=',$data['orderid']];
            $re1 = SelOrder::where($where)->strict(false)->update($reOrderD);
            $re2 = SelOrderDtl::where('orderid','=',$data['orderid'])->deleteInsertAll($reOrderDtl);
        }else{
            $reOrderD['orderid'] = $orderId;
            $reOrderD['f_date'] = $date;
            $depart_id = Employee::where(['code'=>$uCode])->value('depart_id');
            $reOrderD['dept_id'] = $depart_id;
            $reOrderD['creater'] = $uCode;
            $reOrderD['create_date'] = $dateTime;
            $re1 = SelOrder::strict(false)->insert($reOrderD);
            $re2 = SelOrderDtl::insertAll($reOrderDtl);
        }
        if($re1 && $re2){
            $res = ['status'=>1,'msg'=>'保存成功'];
            Db::commit();
        }else {
            Db::rollback();
        }
        _end:
        return $res;
    }
    /** 审核 */
    public static function auditSelOrder($inData,$uCode){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $orderId = strip_tags($inData['orderid']);
        $checkStock = SelOrderDtl::checkProStock($orderId);
        if(!$checkStock['status']){
            $res = $checkStock;
            goto _end;
        }
        $where['orderid'] = $orderId;
        $upData['audit'] = $uCode;
        $upData['is_transfer'] = 1;
        $upData['update_date'] = date('Y-m-d H:i:s',time());
        $re = SelOrder::where($where)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'审核成功','audit'=>$uCode];
        _end:
        return $res;
    }
    /** 还原 */
    public static function reductionSelOrder($inData,$uCode){
        $res = ['status'=>0,'msg'=>'还原失败'];
        $orderId = strip_tags($inData['orderid']);
        $where['orderid'] = $orderId;
        $upData['audit'] = null;
        $upData['is_transfer'] = 0;
        $upData['is_pass_on'] = 0;
        $upData['update_date'] = date('Y-m-d H:i:s',time());
        $re = SelOrder::where($where)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'还原成功','audit'=>$uCode];
        return $res;
    }
    public static function transferSelOrder($data,$uCode){
        $res = ['status'=>0,'msg'=>'转单失败'];
        $orderId = strip_tags($data['orderid']);
        $where[] = ['orderid','=',$orderId];
        $where[] = ['is_transfer','=',1];
        $where[] = ['is_pass_on','=',0];
        $selOrder = SelOrder::where($where)->field('*')->find()->toArray();
        $selOrderDtl =  SelOrderDtl::where('orderid','=',$orderId)->field('*')->select()->toArray();
        if(!$selOrder || !$selOrderDtl) goto _end;
        $res = SelExport::SelOrderTransfer($selOrder,$selOrderDtl,$uCode);
        _end:
        return $res;
    }
    /** 销售报价单转销售订单 */
    public static function speerTransfer($speer,$speerDtl,$uCode){
        $res = ['status'=>0,'销售订单生成失败'];
        $orderId = CommonFun::createOrder('SO');
        $NowDate = Date('Y-m-d',time());
        $NowDateTime = Date('Y-m-d H:i:s',time());
        $selOrder = [];
        $selOrderDtl = [];
        $selOrder['orderid'] = $orderId;
        $selOrder['f_date'] = $NowDate;
        $selOrder['emp_no'] = $speer['emp_no'];
        $selOrder['cust_no'] = $speer['cust_no'];
        $selOrder['link_man'] = $speer['link_man'];
        $selOrder['goods_qty'] = $speer['goods_qty'];
        $selOrder['goods_sum'] = $speer['goods_sum'];
        $selOrder['tax_sum'] = $speer['tax_sum'];
        $selOrder['amount'] = $speer['amount'];
        $selOrder['creater'] = $uCode;
        $selOrder['create_date'] = $NowDateTime;
        $selOrder['mender'] = $uCode;
        $selOrder['update_date'] = $NowDateTime;
        $depart_id = Employee::where(['code'=>$uCode])->value('depart_id');
        $selOrder['dept_id'] = $depart_id;
        $selOrder['contacts'] = $speer['contacts'];
        foreach ($speerDtl as $k=>$v){
            $selOrderDtl[$k] = [];
            $selOrderDtl[$k]['orderid'] = $orderId;
            $selOrderDtl[$k]['item_no'] = $v['item_no'];
            $selOrderDtl[$k]['goods_code'] = $v['goods_code'];
            $selOrderDtl[$k]['unit'] = $v['unit'];
            $selOrderDtl[$k]['qty'] = $v['qty'];
            $selOrderDtl[$k]['o_price'] = $v['o_price'];
            $selOrderDtl[$k]['rebate'] = $v['rebate'];
            $selOrderDtl[$k]['price'] = $v['price'];
            $selOrderDtl[$k]['tax_rate'] = $v['tax_rate'];
            $selOrderDtl[$k]['un_tax_price'] = $v['un_tax_price'];
            $selOrderDtl[$k]['goods_sum'] = $v['goods_sum'];
            $selOrderDtl[$k]['tax_sum'] = $v['tax_sum'];
            $selOrderDtl[$k]['amount'] = $v['amount'];
            $selOrderDtl[$k]['cust_goods_code'] = $v['cust_goods_code'];
        }
        Db::startTrans();
        $re1 = SelOrder::insert($selOrder);
        $re2 = SelOrderDtl::insertAll($selOrderDtl);
        if($re1 && $re2){
            Db::commit();
            $res = ['status'=>1,'msg'=>'报价单['.$speer['orderid'].']已成功转出到销售订单['.$orderId.']，要查看该单据吗？','orderid'=>$orderId];
        }else Db::rollback();
        return $res;
    }
    /** 选择产品库存 生产批号/序列号 */
    public static function chooseBatchNo($data){
        $goodsCode = strip_tags($data['goods_code']);
        $data = Db::query("call stock_usable('{$goodsCode}')");
        $newData[0]['title'] = '所有仓库';
        $newData[0]['expand'] = true;
        $newData[0]['canbyonsale'] = 1;
        $newData[0]['inventory_order_id'] = null;
        $newData[0]['cannotice'] = 0;
        if($data){
            $data = $data[0];
            $wareList = Db::name('warehouse')->alias('h')
                ->join('ware_locked l','l.ware_code = h.ware_code','left')
                ->where('h.candel',1)->field('h.cannotice,h.canbyonsale,h.status,h.ware_code,h.parent_code,h.ware_title,concat(h.ware_title,"[",h.ware_code,"]") as title,ifnull( l.bill_no, NULL ) AS inventory_order_id')->select()->toArray();
            self::getTree($wareList,$data,$reData);
            self::toSingle($reData,$newList);
            $newData[0]['stock_list'] = $data;
            foreach ($newList as $key=>$val) {
                if ($val['parent_code'] === '0') {
                    $newData[0]['next'][] = &$newList[$key];
                } elseif (isset($newList[$val['parent_code']])) {
                    $newList[$val['parent_code']]['next'][] = &$newList[$key];
                }
            }
        }
        $res = ['status'=>1,'data'=>$newData,'stock_list'=>$data];
        return $res;
    }
    private static function getTree($wareList,&$data,&$tree){
        if (!empty($wareList)){
            $newList = [];
            foreach ($wareList as $k => $v) {
                foreach($data as $key=>$stock){
                    if($stock['ware_code'] == $v['ware_code']){
                        $stock['ware_title'] = $v['ware_title'];
                        $stock['canbyonsale'] = $v['canbyonsale'];
                        $stock['cannotice'] = $v['cannotice'];
                        $stock['inventory_order_id'] = $v['inventory_order_id'];
                        $v['stock_list'][] = $stock;
                        $data[$key] = $stock;
                    }
                }
                $newList[$v['ware_code']] = $v;
            }
            foreach ($newList as $key=>$val) {
                if ($val['parent_code'] === '0') {
                    $tree[$key] = &$newList[$key];
                } elseif (isset($newList[$val['parent_code']])) {
                    $newList[$val['parent_code']]['next'][$key] = &$newList[$key];
                }
            }
        }
    }
    private static function toSingle($array,&$temp=[]){
        foreach ($array as $key=>$value )
        {
            $value['expand'] = false;
            if(!isset($value['stock_list'])) $value['stock_list'] = [];
            if(isset($value['next'])){
                $nextData = $value['next'];
                unset($value['next']);
                self::toStockList($nextData,$StockList);
                if($StockList) $value['stock_list'] = array_merge($value['stock_list'],$StockList[0]);
                $temp[$key] = $value;
                self::toSingle($nextData,$temp);
            }else $temp[$key] = $value;
        }
    }
    private static function toStockList($array,&$temp=[]){
        foreach ($array as $key=>$value )
        {
            if(isset($value['stock_list'])) $temp[] = $value['stock_list'];
            if(isset($value['next'])){
                self::toStockList($value['next'],$temp);
            }
        }
    }
}