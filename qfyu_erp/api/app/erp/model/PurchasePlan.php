<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\Enc;
use app\erp\validate\PurchasePlanVal;
use think\facade\Config;
use think\facade\Db;
use think\Model;
/**
 * 采购计划-模型数据操作类
 * @author wuzhogngui
 * @license 2020-11-06
 */
class PurchasePlan extends Model
{
    /**
     * 获取采购计划单列表
     * @param $where 查询条件
     */
    public static function getPlanList($search=[]){
        $where=[];
        $list=Db::name('purchaseplan_list')->where($where)->paginate(30);
        return $list;
    }
    /**
     * 通过单号，获取计划单信息数据
     * @param $data 参数
     */
    public static function getPlanOrderByOrderId($data){
        $order=null;
        $glist=[];
        if(empty($data['orderid'])) goto _end;
        $where[]=['orderid','=',$data['orderid']];
        $order=Db::name('purchaseplan_list')->where($where)->find();
        if($order==null) goto _end;
        $order['hascode']=($order['prepared_code'] && $order['prepared_name'])?1:0;
        //查询采购计划单详情
        $map[]=['de.orderid','=',$data['orderid']];
        $field='c.*,p.name as sup_name,de.sup_code,de.remark,de.unit,';
        $field.='(0+cast(de.buynum as char)) as buynum,(0+cast(de.buyprice as char)) as buyprice,(0+cast(de.taxrate as char)) as tax,
                 (0+cast(de.notaxprice as char)) as notaxprice,(0+cast(de.goodsprice as char)) as goodsprice,(0+cast(de.taxprice as char)) as taxprice,
                 (0+cast(de.totalprice as char)) as totalprice,(0+cast(de.provprice1 as char)) as provprice1,(0+cast(de.provprice2 as char)) as provprice2,
                 (0+cast(de.provprice3 as char)) as provprice3,(0+cast(de.provprice4 as char)) as provprice4,(0+cast(de.provprice5 as char)) as provprice5,
                 (0+cast(de.provprice6 as char)) as provprice6,(0+cast(de.provprice7 as char)) as provprice7,(0+cast(de.provprice8 as char)) as provprice8';
        $glist=Db::name('purchase_plan_details')->alias('de')->field($field)
            ->join('commodity_list c','c.goods_code=de.goodsid','left')
            ->join('providers p','p.supplier_code=de.sup_code','left')
            ->where($map)->group('de.goodsid')->select();
        $order['glist']=$glist;
        _end:
        return ['order'=>$order,'glist'=>$glist];
    }
    /**
     * 保存、修改采购计划单
     * @param $data 计划单数据
     * @param $user 操作用户
     */
    public static function savePlanOrder($data,$user){
        $result=['status'=>0,'msg'=>'保存失败'];
        $data=CommonFun::ProcessingData($data);
        //处理表单验证
        $validate=new PurchasePlanVal();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();
            goto _end;
        }
        //采购计划单据信息
        $odata['prepared_code']=$data['prepared_code'];
        $odata['typeid']=$data['typeid'];
        $odata['prepared_date']=$data['prepared_date'];
        $odata['invalid_date']=$data['invalid_date'];
        $odata['nums']=count($data['glist']);
        $odata['account']=$data['account'];
        $odata['remark']=$data['remark'];
        $odata['updater']=$user;
        $odata['updater_date']=date('Y-m-d H:i:s',time());
        $orderid=isset($data['orderid'])?$data['orderid']:'';
        Db::startTrans();
        try{
            $res1=0;
            if(isset($data['orderid']) && $data['orderid']){
                //如果存在订单号，则修改订单数据
                $order=Db::name('purchase_plan')->field('orderid,ischeck')->where(['orderid'=>$data['orderid']])->find();
                if($order==null || $order['ischeck']==1){
                    $result['msg']='计划单已审核，不能再进行修改';
                    goto _end;
                }
                $res1=Db::name('purchase_plan')->where(['orderid'=>$data['orderid']])->update($odata);
            }else{
                $odata['orderid']=$orderid=CommonFun::createOrder('JH');
                $odata['isclose']=$data['isclose'];
                $odata['ischeck']=0;
                $odata['istrans']=0;
                $odata['creator']=$user;
                $odata['creator_date']=$odata['updater_date'];
                $res1=Db::name('purchase_plan')->insert($odata);
            }
            $res2=0;$res3=0;
            if($res1){
                //删除以前的单据数据
                $hasDtl=Db::name('purchase_plan_details')->field('itemno')->where(['orderid'=>$orderid])->find();
                if($hasDtl!=null){
                    $res2=Db::name('purchase_plan_details')->where(['orderid'=>$orderid])->delete();
                }else $res2=1;
                //新增详情数据
                $goodslist=[];
                foreach($data['glist'] as $k=>$v) {
                    $v['itemno'] = $k + 1;
                    $v['orderid'] = $orderid;
                    array_push($goodslist,$v);
                }
                $res3=count($goodslist)>0?Db::name('purchase_plan_details')->insertAll($goodslist):1;
            }
            if($res1 && $res2 && $res3){
                Db::commit();
                $msg=(isset($data['orderid']) && $data['orderid'])?'修改保存成功':'保存成功';
                $result=['status'=>1,'msg'=>$msg,'orderid'=>$orderid];
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
     * 审核-计划单
     *（1）必须满足未审核的订单
     *（1）必须满足商品供应商信息填写
     *（2）必须满足至少有一项采购计划商品
     * @param $orderid 计划单号
     * @param $user 审核人
     */
    public static function checkOrder($orderid,$user){
        $result=['status'=>0,'msg'=>'审核失败'];
        if(empty($orderid)) goto _end;
        $order=Db::name('purchase_plan')->field('ischeck')->where(['orderid'=>$orderid])->find();
        if($order==null || $order['ischeck']==1){
            $result['msg']='该计划单已审核，请勿重复审核';
            goto _end;
        }
        //验证计划单商品有效性
        $validate=self::validatePlanGoods($orderid);
        if($validate['status']!=1){
            $result['msg']=$validate['msg'];
            goto _end;
        }
        $data['ischeck']=1;
        $data['check_code']=$user;
        $data['check_date']=date('Y-m-d H:i:s',time());
        $employee=Db::name('employee')->field('code,name,depart_id')->where(['code'=>$user])->find();
        if(empty($order['depart_id'])){
            $data['depart_id']=$employee['depart_id'];
        }
        $res=Db::name('purchase_plan')->where(['orderid'=>$orderid])->update($data);
        if($res){
            $check=['code'=>$user,'name'=>$employee['name']];
            $result=['status'=>1,'msg'=>'审核成功','check'=>$check];
        }
        _end:
        return $result;
    }
    /**
     * 还原-计划单
     * @param $orderid 计划单
     * @param $user 操作人
     */
    public static function backOrder($orderid,$user){
        $result=['status'=>0,'msg'=>'审核失败'];
        if(empty($orderid)) goto _end;
        $order=Db::name('purchase_plan')->field('ischeck')->where(['orderid'=>$orderid])->find();
        if($order==null || $order['ischeck']!=1){
            $result['msg']='计划单据未审核，不能进行还原处理';
            goto _end;
        }
        $data['istrans']=0;
        $data['ischeck']=0;
        $data['updater']=$user;
        $data['updater_date']=date('Y-m-d H:i:s',time());
        $res=Db::name('purchase_plan')->where(['orderid'=>$orderid])->update($data);
        if($res){
            $result=['status'=>1,'msg'=>'还原成功'];
        }
        _end:
        return $result;
    }
    /**
     * 结案-计划单
     * @param $orderid 计划单
     * @param $user 操作人
     */
    public static function closeOrder($orderid,$user)
    {
        $result = ['status' => 0, 'msg' => '审核失败'];
        if (empty($orderid)) goto _end;
        $order=Db::name('purchase_plan')->field('isclose')->where(['orderid' => $orderid])->find();
        if ($order == null) goto _end;
        $isclose=$order['isclose']==1?0:1;
        $data['isclose'] = $isclose;
        $data['updater'] = $user;
        $data['updater_date'] = date('Y-m-d H:i:s', time());
        $res = Db::name('purchase_plan')->where(['orderid' => $orderid])->update($data);
        if ($res) {
            $result = ['status' => 1, 'msg' => '结案成功','isclose'=>$isclose];
        }
        _end:
        return $result;
    }
    /**
     * 删除-计划单
     * @param $orderid 计划单号
     */
    public static function deleteOrder($orderid){
        $result = ['status' => 0, 'msg' => '删除失败'];
        if (empty($orderid)) goto _end;
        $order = Db::name('purchase_plan')->field('ischeck')->where(['orderid' => $orderid])->find();
        if($order == null || $order['ischeck']==1){
            $result['msg']='计划单已审核，不能再进行删除';
            goto _end;
        }
        Db::startTrans();
        $res1=Db::name('purchase_plan')->where(['orderid' => $orderid])->delete();
        $res2=0;
        if($res1){
            $hasDtl=Db::name('purchase_plan_details')->where(['orderid' => $orderid])->find();
            if($hasDtl!=null){
                $res2=Db::name('purchase_plan_details')->where(['orderid' => $orderid])->delete();
            }else $res2=1;
        }
        if($res1 && $res2){
            Db::commit();
            $result = ['status' => 1, 'msg' => '删除成功'];
        }else{
            Db::rollback();
        }
        _end:
        return $result;
    }
    /**
     * 转单处理（转采购订单）
     *（1）订单未审核或已结案，不能进行转单处理
     *（1）具备计划单中的商品有设置供应商参数
     *（2）商品的采购数量条件：至少有一项商品的采购数量满足大于0
     * (3) 计划单商品中，如果存在采购数量为0的商品，将不进行处理成采购订单商品
     */
    public static function generatePurchaseOrder($data,$user){
        $result=['status'=>0,'msg'=>'转单处理失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_plan')->where(['orderid'=>$data['orderid']])->find();
        if($order==null) goto _end;
        if($order['ischeck']!=1 || $order['isclose']==1){
            $result['msg']='计划单未审核或已结案，不能再生成采购单';
            goto _end;
        }
        $validate=self::validatePlanGoods($data['orderid']);
        if($validate['status']!=1){
            $result['msg']=$validate['msg'];
            goto _end;
        }
        $glist=$validate['glist'];
        $split_list=[]; //拆单列表
        foreach($glist as $v){
            if(bccomp($v['buynum'],'0',5)>0){
                $sup_code=trim($v['sup_code']);
                if(!isset($olist[$sup_code])){
                    $split_list[$sup_code]['nums']=0; //货品总数
                    $split_list[$sup_code]['payment']=0; //货款总额
                    $split_list[$sup_code]['taxation']=0; //税款总额
                    $split_list[$sup_code]['total']=0; //合计总额
                    $split_list[$sup_code]['glist']=[]; //商品列表
                }
                array_push($split_list[$sup_code]['glist'],$v);
                $split_list[$sup_code]['nums']=bcadd($split_list[$sup_code]['nums'],$v['buynum'],5);
                $split_list[$sup_code]['payment']=bcadd($split_list[$sup_code]['payment'],$v['goodsprice'],6);
                $split_list[$sup_code]['taxation']=bcadd($split_list[$sup_code]['taxation'],$v['taxprice'],6);
                $split_list[$sup_code]['total']=bcadd($split_list[$sup_code]['total'],$v['totalprice'],6);
            }
        }
        //计划单转单处理
        $goods_unit=Config::get('parameter.goods_unit');
        $olist=$reslist=[]; //采购单
        $detail_list=[]; //采购单明细
        $nowtime=time();
        foreach($split_list as $key=>$value){
            //订单数据
            $order_data['plan_orderid']=$data['orderid'];
            $order_data['orderid']=CommonFun::createOrder('PO');
            $order_data['effectivity_date']=date('Y-m-d',$nowtime);
            $order_data['invalid_date']=date('Y-m-d',$nowtime+7*24*3600);
            $order_data['order_date']=date('Y-m-d',$nowtime);
            $order_data['delivery_date']=date('Y-m-d',$nowtime);
            $order_data['contract_type']=0; //计划合同
            $order_data['sup_code']=$key;
            $order_data['sales_code']=$user; //业务员默认当前操作员
            $order_data['nums']=$value['nums'];
            $order_data['payment']=$value['payment'];
            $order_data['tax_total']=$value['taxation'];
            $order_data['total']=$value['total'];
            $order_data['istrans']=0;
            $order_data['isclose']=0;
            $order_data['ischeck']=0;
            $order_data['creator']=$user;
            $order_data['create_date']=date('Y-m-d H:i:s',$nowtime);
            $order_data['updator']=$user;
            $order_data['update_date']=date('Y-m-d H:i:s',$nowtime);
            $order_data['remark']='本订单由采购计划单自动生成'.$order_data['create_date'];
            array_push($olist,$order_data);
            array_push($reslist,$order_data['orderid']);
            //订单明细
            foreach($value['glist'] as $kk=>$dd){
                $goodsDtl['item_no']=$kk+1;
                $goodsDtl['orderid']=$order_data['orderid'];
                $goodsDtl['goodsid']=$dd['goodsid'];
                $goodsDtl['unit']=$dd['unit'];
                $goodsDtl['nums']=$dd['buynum'];
                $goodsDtl['price']=$dd['buyprice'];
                $goodsDtl['discount']=0;
                $goodsDtl['reality_price']=$dd['buyprice'];
                $goodsDtl['taxrate']=$dd['taxrate'];
                $goodsDtl['notax_price']=$dd['notaxprice'];
                $goodsDtl['notax_total']=$dd['goodsprice'];
                $goodsDtl['tax_total']=$dd['taxprice'];
                $goodsDtl['total']=$dd['totalprice'];
                array_push($detail_list,$goodsDtl);
            }
        }
        if(count($olist)==0 || count($detail_list)==0) goto _end;
        Db::startTrans();
        try {
            $res1=Db::name('purchase_order')->insertAll($olist);
            $res2=Db::name('purchase_order_details')->insertAll($detail_list);
            $pdata['istrans']=1;
            $pdata['updater']=$user;
            $pdata['updater_date']=date('Y-m-d H:i:s',$nowtime);
            $res3=Db::name('purchase_plan')->where(['orderid'=>$data['orderid']])->update($pdata);
            if($res1 && $res2 && $res3){
                Db::commit();
                $result=['status'=>1,'msg'=>'转单处理成功','olist'=>$reslist];
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
    /*******************其他辅助方法******************/
    /**
     * 验证采购计划单中商品数据有效性
     *（1）满足计划单明细中有选择商品
     *（2）满足至少有一项采购计划商品
     * (3) 满足计划单明细中，是否具有未指定供应商的商品
     * @param $orderid 订单编号
     */
     private static function validatePlanGoods($orderid){
         $validate=self::getPlanGoodsNums($orderid);
         $result=['status'=>1,'msg'=>'success'];
         if($validate['size']==0){
             $result=['status'=>0,'msg'=>'计划单明细中还未设置商品列表，请设置商品'];
             goto _end;
         }
         if($validate['hasNums']==0){
             $result=['status'=>0,'msg'=>'计划单明细中尚有未填写采购数量商品，请填写采购数量'];
             goto _end;
         }
         if($validate['hasSup']>0){
             $result=['status'=>0,'msg'=>'计划单明细中尚有未指定供应商的商品，请指定供应商'];
             goto _end;
         }
         $result['glist']=$validate['glist'];
         _end:
         return $result;
     }
    /**
     * 获取计划单明细总数、未设置供应商总数、已设置采购数量总数
     * @param $orderid 订单号
     */
    private static function getPlanGoodsNums($orderid){
        $field='a.*,p.supplier_code';
        $glist=Db::name('purchase_plan_details')->alias('a')->field($field)
            ->join('providers p','p.supplier_code=a.sup_code','left')
            ->join('commodity c','c.goods_code=a.goodsid','left')
            ->where(['orderid'=>$orderid])->select();
        $hasSup=0; //是否有未设置供应商资料
        $hasNums=0; //是否具有全部未设置采购数量
        foreach($glist as $v){
            if(empty($v['supplier_code'])) $hasSup++;
            if(bccomp($v['buynum'],'0',5)>0) $hasNums++;
        }
        $data['glist']=$glist;
        $data['size']=count($glist); //总采购商品数
        $data['hasSup']=$hasSup; //是否有未设置供应商
        $data['hasNums']=$hasNums; //设置采购数量商品数
        return $data;
    }
}