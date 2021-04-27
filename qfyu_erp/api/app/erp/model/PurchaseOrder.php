<?php
namespace app\erp\model;
use app\erp\validate\PurchaseOrderDetailVal;
use app\helper\CommonFun;
use app\erp\validate\PurchaseOrderVal;
use think\facade\Config;
use think\facade\Db;
use think\Model;
/**
 * 采购订单-业务逻辑处理类
 * @author wuzhonggui
 * @license 2020-11-20
 */
class PurchaseOrder extends Model
{
    /**
     * 查询采购订单列表
     * @param $data 查询条件
     */
    public static function getPurOrderList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?10:intval($data['pageSize']);
        $where=[];
        $field="o.*,DATE_FORMAT(o.create_date,'%Y-%m-%d %H:%i') as create_date,p.full_name";
        $order="o.create_date desc";
        $list=Db::name('purchase_order')->alias('o')->field($field)
            ->join('providers p','p.supplier_code=o.sup_code','left')
            ->where($where)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])
            ->toArray();
        return $list;
    }
    /**
     * 根据订单号，查询订单信息数据
     * @param $data 查询参数
     */
    public static function getPurOrderInfo($data){
        $order=null;
        if(empty($data['orderid'])) goto _end;
        $field="o.*,p.full_name as sup_name";
        $where[]=['orderid','=',$data['orderid']];
        $order=Db::name('purchase_order')->alias('o')->field($field)
            ->join('providers p','p.supplier_code=o.sup_code','left')
            ->where($where)->find();
        if($order!=null){
            //查询订单详情资料
            $field='c.*,c.unit as unit1,dt.*';
            $map[]=['dt.orderid','=',$data['orderid']];
            $list=Db::name('purchase_order_details')->alias('dt')->field($field)
                ->join('commodity_list c','c.goods_code=dt.goodsid','left')
                ->where($map)->select();
            $order['goodslist']=$list;
        }
        _end:
        return $order;
    }
    /**
     * 保存、修改采购订单
     * @param $data 采购单数据
     * @param $user 操作者
     * @param $deptid 开单部门
     */
    public static function savePurchaseOrder($data,$user,$deptid){
        $result=['status'=>0,'msg'=>'采购单保存失败'];
        $data=CommonFun::ProcessingData($data);
        //验证表单数据
        $validate=new PurchaseOrderVal();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();goto _end;
        }
        //验证供应商
        $supField="supplier_code,full_name,subject_dept,audit_status";
        $hassup=Db::name('providers')->field($supField)->where(['supplier_code'=>$data['sup_code']])->find();
        if($hassup==null){
            $result['msg']="请选择供应商";goto _end;
        }
        if($hassup['audit_status']!=1){
            $result['msg']="供应商：(【{$hassup['supplier_code']}】{$hassup['full_name']}) 未审核合格";
            goto _end;
        }
        //验证业务员
        $hasSales=[];
        if(isset($data['sales_code']) && $data['sales_code']){
            $hasSales=Db::name('employee')->field('code,name')->where(['code'=>$data['sales_code']])->find();
            if($hasSales==null){
                $result['msg']="请选择业务员";goto _end;
            }
        }
        //验证结算方式
        $hasSet=Db::name('settlement')->field('id,code')->where(['code'=>$data['settle_type']])->find();
        if($hasSet==null){
            $result['msg']="请选择结算方式";goto _end;
        }
        $purorder['effectivity_date']=$data['effectivity_date'];
        $purorder['invalid_date']=$data['invalid_date'];
        $purorder['delivery_date']=$data['delivery_date'];
        $purorder['sup_code']=$data['sup_code'];
        $purorder['settle_type']=$data['settle_type'];
        $purorder['contract_type']=(isset($data['contract_type']) && $data['contract_type'])?$data['contract_type']:'';
        $purorder['sales_code']=isset($hasSales['code'])?$hasSales['code']:'';
        $purorder['sales_name']=isset($hasSales['name'])?$hasSales['name']:'';
        $purorder['sup_sell']=$data['sup_sell'];
        $purorder['sup_contact']=$data['sup_contact'];
        $purorder['dept_name']=$hassup['subject_dept'];
        $purorder['pay_date']=$data['pay_date'];
        $purorder['ispay']=intval($data['ispay'])==1?1:0;
        $purorder['paymoney']=intval($data['ispay'])==1?$data['paymoney']:0;
        $purorder['sign_area']=$data['sign_area'];
        $purorder['contract_code']=$data['contract_code'];
        $purorder['sup_remark']=$data['sup_remark'];
        $purorder['delivery_type']=$data['delivery_type'];
        $purorder['transport_type']=$data['transport_type'];
        $purorder['delivery_area']=$data['delivery_area'];
        $purorder['transport_area']=$data['transport_area'];
        $purorder['remark']=$data['remark'];
        $purorder['updator']=$user;
        $purorder['update_date']=date('Y-m-d H:i:s',time());
        $orderid="";
        if(isset($data['orderid']) && $data['orderid']){
            $orderid=$data['orderid'];
            $hasOrder=Db::name('purchase_order')->field('orderid,ischeck,isclose,istrans')->where(['orderid'=>$data['orderid']])->find();
            if($hasOrder==null || $hasOrder['ischeck']==1){
                $result['msg']='该采购订单已经审核，不能再进行修改';goto _end;
            }
            if($hasOrder['isclose']==1){
                $result['msg']='该采购订单已经结案，不能再进行修改';goto _end;
            }
            if($hasOrder['istrans']==1){
                $result['msg']='该采购订单已经生成过来过登记单，不能再进行修改';goto _end;
            }
        }else{
            $purorder['orderid']=$orderid=CommonFun::createOrder('PO');
            $purorder['order_date']=date('Y-m-d',time());
            $purorder['istrans']=0;
            $purorder['isclose']=0;
            $purorder['ischeck']=0;
            $purorder['creator']=$user;
            $purorder['create_date']=$purorder['update_date'];
            $purorder['dept_id']=$deptid;
        }
        $purorder['nums']=0; //货品总数
        $purorder['payment']=0; //货款总额
        $purorder['tax_total']=0; //税款总额
        $purorder['total']=0; //合计总额
        //处理订单详情数据
        $orderDtl=[];
        if(isset($data['goodslist']) && is_array($data['goodslist']) && count($data['goodslist'])>0){
            $validate_goods=new PurchaseOrderDetailVal();
            $gcodes='';
            foreach ($data['goodslist'] as $v){
                $check_goods = $validate_goods->scene('all')->check($v);
                if (!$check_goods){
                    $result['msg']=$validate_goods->getError();
                    goto _end;
                }
                $gcodes.=$gcodes?','.$v['goods_code']:$v['goods_code'];
            }
            $gmap[]=['goods_code','in',$gcodes];
            $list = Db::name('commodity_list')->where($gmap)->column('gmp_end_date,is_buyer,unit,unit2','goods_code');
            $gmp_expired=intval(getSysConfig('gmp_pch_expired_disabled')); //GMP证书过期的商品禁止采购
            foreach($data['goodslist'] as $k=>$v){
                if(!isset($list[$v['goods_code']])){
                    $result['msg']="商品资料信息有误";goto _end;
                }
                $hasUnit2=strcasecmp(trim($v['unit']),trim($list[$v['goods_code']]['unit2'])); //辅单位是否相等
                $hasUnit=strcasecmp(trim($v['unit']),trim($list[$v['goods_code']]['unit'])); //主单位是否相等
                if($hasUnit!=0 && $hasUnit2!=0){
                    $result['msg'] = "商品明细【{$v['goods_code']}】单位与商品资料设置的单位不一致！";
                    goto _end;
                }
                if(intval($list[$v['goods_code']]['is_buyer'])==1){
                    $result['msg']="明细商品【{$v['goods_code']}】已暂停采购，不能进行采购！";
                    goto _end;
                }
                if($gmp_expired==1){
                    if(!empty($list[$v['goods_code']]['gmp_end_date']) && strtotime($list[$v['goods_code']]['gmp_end_date'])<=time()){
                        $result['msg']="明细商品【{$v['goods_code']}】GMP证书已过期，不能进行采购";
                        goto _end;
                    }
                }
                $orderDtl[$k]['item_no']=$k+1;
                $orderDtl[$k]['orderid']=$orderid;
                $orderDtl[$k]['goodsid']=$v['goods_code'];
                $orderDtl[$k]['unit']=$v['unit'];
                $orderDtl[$k]['nums']=$v['nums'];
                $orderDtl[$k]['price']=$v['price'];
                $orderDtl[$k]['discount']=$v['discount'];
                $discount=$orderDtl[$k]['discount']>0?calc([$orderDtl[$k]['discount'],'/',100],8):1;
                $orderDtl[$k]['reality_price']=calc([$orderDtl[$k]['price'],'*',$discount],6);
                $orderDtl[$k]['taxrate']=$v['taxrate'];
                $taxrate=calc([$orderDtl[$k]['taxrate'],'/',100,'+',1],8);
                $orderDtl[$k]['notax_price']=calc([$orderDtl[$k]['reality_price'],'/',$taxrate],8);
                $orderDtl[$k]['total']=calc([$orderDtl[$k]['reality_price'],'*',$orderDtl[$k]['nums']],6);
                $orderDtl[$k]['notax_total']=calc([$orderDtl[$k]['notax_price'],'*',$orderDtl[$k]['nums']],6);
                $orderDtl[$k]['tax_total']=calc([$orderDtl[$k]['total'],'-',$orderDtl[$k]['notax_total']],6);
                $goods_status=isset($v['goods_status'])?$v['goods_status']:'';
                $quality_status=isset($v['quality_status'])?$v['quality_status']:'';
                $orderDtl[$k]['goods_status']=$goods_status;
                $orderDtl[$k]['quality_status']=$quality_status;
                $orderDtl[$k]['remark']=strip_tags(trim($data['remark']));
                //计算订单总额
                $purorder['nums']=calc([$purorder['nums'],'+',$orderDtl[$k]['nums']],5);
                $purorder['payment']=calc([$purorder['payment'],'+',$orderDtl[$k]['notax_total']],6);
                $purorder['tax_total']=calc([$purorder['tax_total'],'+',$orderDtl[$k]['tax_total']],6);
                $purorder['total']=calc([$purorder['total'],'+',$orderDtl[$k]['total']],6);
            }
        }
        Db::startTrans();
        try {
            $res1=0;
            if(isset($data['orderid']) && $data['orderid']){
                $res1=Db::name('purchase_order')->where(['orderid'=>$data['orderid']])->update($purorder);
            }else{
                $res1=Db::name('purchase_order')->insert($purorder);
            }
            $res2=0;$res3=0;
            $hasDtl=Db::name('purchase_order_details')->field('item_no')->where(['orderid'=>$data['orderid']])->find();
            if($hasDtl!=null){
                $res2=Db::name('purchase_order_details')->where(['orderid'=>$data['orderid']])->delete();
            }else $res2=1;
            $res3=count($orderDtl)>0?Db::name('purchase_order_details')->insertAll($orderDtl):1;
            //判断处理结果
            if($res1 && $res2 && $res3){
                Db::commit();
                $msg=(isset($data['orderid']) && $data['orderid'])?'保存修改成功':'保存已成功';
                $result=['status'=>1,'msg'=>$msg,'orderid'=>$orderid];
            }
        }catch (\Exception $e){
            $result['msg']=$e->getMessage();
            Db::rollback();
        }
        _end:
        return $result;
    }
    /**
     * 采购订单-审核
     * @param $data 请求参数
     * @param $user 审核人
     * @param $deptid 部门
     */
    public static function checkPurOrder($data,$user,$deptid){
         $result=['status'=>0,'msg'=>'采购订单审核失败'];
         if(empty($data['orderid'])) goto _end;
         $field="ischeck,istrans,isclose,invalid_date,ispay,sup_code,sup_sell,sup_contact,dept_name,sales_code,sales_name,settle_type,total";
         $order=Db::name('purchase_order')->field($field)->where(['orderid'=>$data['orderid']])->find();
         if($order==null || $order['istrans']==1){
             $result['msg']="采购订单已结案或已转单，不能进行审核";
             goto _end;
         }
         if($order['ischeck']==1){
             $result['msg']="该采购订单已审核，不能进行审核";
             goto _end;
         }
         if(strtotime($order['invalid_date'])<=time()){
             $result['msg']="该采购订单已过期失效，不能进行审核";
             goto _end;
         }
         $nowDate=date('Y-m-d H:i:s',time());
         $checkdata['ischeck']=1;
         $checkdata['check_code']=$user;
         $checkdata['check_date']=$nowDate;
         Db::startTrans();
        try {
            $res1=1;
            if($order['ispay']==1){ //预付款，生成预付款单
                $paydata['orderid']=CommonFun::createOrder('CF');
                $paydata['reforderid']=$data['orderid'];
                $paydata['sup_code']=$order['sup_code'];
                $paydata['sup_sell']=$order['sup_sell'];
                $paydata['sup_contact']=$order['sup_contact'];
                $paydata['sup_dept']=$order['dept_name'];
                $paydata['emp_code']=$order['sales_code'];
                $paydata['emp_name']=$order['sales_name'];
                $paydata['order_date']=$nowDate;
                $paydata['paykind']=1; //预付
                $paydata['paymode']=$order['settle_type'];
                $paydata['sales_deptid']=$deptid;
                $paydata['remark']="本付款单由采购订单生成";
                $paydata['creator']=$paydata['updator']=$user;
                $paydata['create_date']=$paydata['update_date']=$nowDate;
                $paydata['account']=$paydata['cur_pay']=round($order['total'],2);
                $res1=Db::name('purchase_pay')->insert($paydata);
            }
            $res2=Db::name('purchase_order')->where(['orderid'=>$data['orderid']])->update($checkdata);
            if($res1 && $res2){
                $check=Db::name('employee')->field('code,name')->where(['code'=>$user])->find();
                $result=['status'=>1,'msg'=>'审核处理成功','check'=>$check];
                Db::commit();
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            $result['msg']=$e->getMessage();
            Db::rollback();
        }
         _end:
         return $result;
    }
    /**
     * 采购订单-还原
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function backPurOrder($data,$user){
        $result=['status'=>0,'msg'=>'还原订单失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_order')->field('ischeck,istrans,ispay')->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['ischeck']!=1){
            $result['msg']="该采购订单未审核，无需进行还原操作";
            goto _end;
        }
        if($order['istrans']==1){
            $result['msg']="该采购订单已生成过来货登记单，不能进行还原";
            goto _end;
        }
        if($order['ispay']==1){
            $result['msg']="该采购订单已生成采购预付款单，不能进行还原";
            goto _end;
        }
        $backdata['ischeck']=0;
        $backdata['updator']=$user;
        $backdata['update_date']=date('Y-m-d H:i:s',time());
        $res=Db::name('purchase_order')->where(['orderid'=>$data['orderid']])->update($backdata);
        if($res){
            $result=['status'=>1,'msg'=>'还原成功'];
        }
        _end:
        return $result;
    }
    /**
     * 采购订单-结案
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function closePurOrder($data,$user){
        $result=['status'=>0,'msg'=>'结案操作失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_order')->field('ischeck,isclose')->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['ischeck']!=1){
            $result['msg']="该采购订单尚未审核，不能进行结案。您可以选择删除来作废此单！";
            goto _end;
        }
        if($order['isclose']==1){
            $result['msg']="该采购订单已结案，不能进行结案";
            goto _end;
        }
        $closedata['isclose']=1;
        $closedata['updator']=$user;
        $closedata['update_date']=date('Y-m-d H:i:s',time());
        $res=Db::name('purchase_order')->where(['orderid'=>$data['orderid']])->update($closedata);
        if($res){
            $result=['status'=>1,'msg'=>'结案处理成功'];
        }
        _end:
        return $result;
    }
    /**
     * 采购订单-删除
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function deletePurOrder($data,$user){
        $result=['status'=>0,'msg'=>'删除操作失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_order')->field('ischeck,istrans')->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['ischeck']==1){
            $result['msg']="该采购订单已审核，不能进行删除";
            goto _end;
        }
        if($order==null || $order['istrans']==1){
            $result['msg']="该采购订单已转单，不能进行删除";
            goto _end;
        }
        Db::startTrans();
        try {
            $res1=Db::name('purchase_order')->where(['orderid'=>$data['orderid']])->delete();
            $hasDtl=Db::name('purchase_order_details')->field('item_no')->where(['orderid'=>$data['orderid']])->find();
            $res2=0;
            if($hasDtl!=null){
                $res2=Db::name('purchase_order_details')->where(['orderid'=>$data['orderid']])->delete();
            }else $res2=1;
            if($res1 && $res2){
                Db::commit();
                $result=['status'=>1,'msg'=>'删除操作成功'];
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            $result['msg']=$e->getMessage();
            Db::rollback();
        }
        _end:
        return $result;
    }
    /**
     * 转单（转来货登记单）
     * @param $data 请求参数
     * @param $user 转单人
     */
    public static function generateRegisterOrder($data,$user){
        $result=['status'=>0,'msg'=>'删除操作失败'];
        if(empty($data['orderid'])) goto _end;
        $field='orderid,ischeck,isclose,sup_code,sup_sell,sup_contact,dept_name,sup_remark,contract_code,sales_code,settle_type,nums,payment,tax_total,total';
        $order=Db::name('purchase_order')->field($field)->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['ischeck']!=1){
            $result['msg']="该采购订单尚未审核，不能进行转单";goto _end;
        }
        if($order['isclose']==1){
            $result['msg']="该采购订单已结案，不能进行转单";goto _end;
        }
        $list=Db::name('purchase_order_details')->alias('a')->field('a.*,c.abkind')
            ->join('commodity_list c','c.goods_code=a.goodsid','left')
            ->where(['orderid'=>$data['orderid']])->select();
        //来货登记单
        $regdata['orderid']=CommonFun::createOrder('PC');
        $regdata['supplier_code']=$order['sup_code'];
        $regdata['supplier_sale']=$order['sup_sell'];
        $regdata['supplier_contact']=$order['sup_contact'];
        $regdata['supplier_depart']=$order['dept_name'];
        $regdata['supplier_remark']=$order['sup_remark'];
        $regdata['receiving_date']=date('Y-m-d H:i:s',time());
        $regdata['contract_no']=$order['contract_code'];
        $regdata['salesman']=$order['sales_code'];
        $regdata['o_orderid']=$order['orderid'];
        $regdata['pay_type']=$order['settle_type'];
        $regdata['total_amount']=$order['nums'];
        $regdata['total_money']=$order['payment'];
        $regdata['taxes']=$order['tax_total'];
        $regdata['total_payprice']=$order['total'];
        $regdata['creator_code']=$user;
        $regdata['creation_date']=date('Y-m-d H:i:s',time());
        $regdata['remark']='本订单由采购订单自动生成';
        $regdata['status']=0; //未审核
        $regdata['order_status']=0; //未转单
        //来货登记详情
        $goodslist=[];
        $params=Config::get('parameter.ml_type');
        if(count($list)>0){
            foreach($list as $k=>$v){
                $goodslist[$k]['r_orderid']=$regdata['orderid'];
                $goodslist[$k]['ref_orderid']=$data['orderid'];
                $goodslist[$k]['item_no']=$v['item_no'];
                $goodslist[$k]['goods_code']=$v['goodsid'];
                $goodslist[$k]['unit']=$v['unit'];
                $goodslist[$k]['order_amount']=$v['nums'];
                $goodslist[$k]['come_amount']=$v['nums'];
                $goodslist[$k]['receipts_amout']=$v['nums'];
                $goodslist[$k]['discount']=$v['discount'];
                $goodslist[$k]['tax']=$v['taxrate'];
                $goodslist[$k]['not_tax_price']=$v['notax_price'];
                $goodslist[$k]['not_tax_money']=$v['notax_total'];
                $goodslist[$k]['tax_total']=$v['tax_total'];
                $goodslist[$k]['total_price']=$v['total'];
                $goodslist[$k]['gross_profit']=isset($params[$v['abkind']])?$params[$v['abkind']]:'';
                $goodslist[$k]['price1']=$v['reality_price'];
                $goodslist[$k]['price']=$v['reality_price'];
                $goodslist[$k]['batch']=$v['batch'];
                $goodslist[$k]['product_status']=$v['goods_status'];
                $goodslist[$k]['quality_status']=$v['quality_status'];
            }
        }
        Db::startTrans();
        try {
            $res1=Db::name('purchase_register')->insert($regdata);
            $res2=count($goodslist)>0?Db::name('purchase_register_details')->insertAll($goodslist):1;
            $transdata['istrans']=1;
            $transdata['updator']=$user;
            $transdata['update_date']=date('Y-m-d H:i:s',time());
            $res3=Db::name('purchase_order')->where(['orderid'=>$data['orderid']])->update($transdata);
            if($res1 && $res2 && $res3){
                Db::commit();
                $result=['status'=>1,'msg'=>'转单操作成功','orderid'=>$regdata['orderid']];
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            $result['msg']=$e->getMessage();
            Db::rollback();
        }
        _end:
        return $result;
    }
}
