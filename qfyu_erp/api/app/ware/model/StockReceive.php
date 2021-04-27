<?php
namespace app\ware\model;
use app\helper\CommonFun;
use app\ware\validate\StockReceiveDetailsValid;
use app\ware\validate\StockReceiveValid;
use think\facade\Db;
use think\Model;
/**
 * 验收入库、复核
 * @author wuzhogngui
 * @license 2020-12-04
 */
class StockReceive extends Model
{
    /**
     * 查询复核单列表
     * @param $data 查询参数
     */
    public static function getStockReceiveList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?10:intval($data['pageSize']);
        $where=[];
        $field="s.*,DATE_FORMAT(s.order_date,'%Y-%m-%d %H:%i') as order_date,p.full_name as sup_name,d.dept_name as o_deptname";
        $field.=',e1.name as check_name,e2.name as emp_name,set.name as settlement_name';
        $list=Db::name('stock_receive')->alias('s')->field($field)
              ->join('providers p','s.sup_code=p.supplier_code')
              ->join('depart d','d.id=s.dept_id','left')
              ->join('employee e1','e1.code=s.check_code','left')
              ->join('employee e2','e2.code=s.emp_no','left')
              ->join('settlement set','set.code=s.paymode','left')
              ->where($where)->paginate(['list_rows'=>$pageSize,'page'=>$page])
              ->toArray();
        return $list;
    }
    /**
     * 查询复核单数据
     */
    public static function getStockReceive($data){
        $order=null;
        if(empty($data['orderid'])) goto _end;
        $where[]=['orderid','=',$data['orderid']];
        $field="s.*,DATE_FORMAT(s.order_date,'%Y-%m-%d %H:%i') as order_date,p.full_name as sup_name,d.dept_name as o_deptname";
        $field.=',e1.name as check_name,set.name as settlement_name';
        $order=Db::name('stock_receive')->alias('s')->field($field)
            ->join('providers p','s.sup_code=p.supplier_code','left')
            ->join('depart d','d.id=s.dept_id','left')
            ->join('employee e1','e1.code=s.check_code','left')
            ->join('settlement set','set.id=s.paymode','left')
            ->where($where)->find();
        if($order==null) goto _end;
        //查询订单
        $field="d.*,w.ware_title,c.goods_code,c.name,c.goods_name,c.specs,c.dosage,c.unit as unit1,c.unit2,pr5.price1 as standard_price,pr6.price1 as retail_price";
        $list=Db::name('stock_receive_details')->alias('d')->field($field)
            ->join('commodity_list c','c.goods_code=d.goods_code','left')
            ->join('warehouse w','w.ware_code=d.ware_code','left')
            ->join('commodity_price pr5','pr5.goods_code=d.goods_code and pr5.mode_id=2','left')
            ->join('commodity_price pr6','pr6.goods_code=d.goods_code and pr6.mode_id=3','left')
            ->where($where)->select()->toArray();
        foreach($list as $k=>$v){
            //计算近销差价、参考零售价合计
            $diff_price=calc([$v['retail_price'],'-',$v['price']],10);
            $list[$k]['diff_amount']=calc([$diff_price,'*',$v['qty']],6);
            $list[$k]['retail_amount']=calc([$v['qty'],'*',$v['retail_price']],6);
        }
        $order['list']=$list;
        _end:
        return $order;
    }
    /**
     * 设定收货仓
     * @param $data 请求参数
     */
    public static function setWare($data){
        $result=['status'=>0,'msg'=>'设定失败'];
        if(!isset($data['ware_code'])){
            $result['msg']='请先选择收货仓';goto _end;
        }
        $map[]=['ware_code','=',$data['ware_code']];
        $map[]=['status','=','1'];
        $map[]=['candel','=',1];
        $ware=Db::name('warehouse')->field('ware_code,ware_title,pos_code')->where($map)->find();
        if($ware==null){
            $result['msg']='请先选择收货仓';goto _end;
        }
        if(empty($data['pos_code'])) $data['pos_code']=empty($ware['pos_code'])?'':$ware['pos_code'];
        $where[]=['ware_code','=',$data['ware_code']];
        if(!empty($data['pos_code'])) $where[]=['pos_code','=',$data['pos_code']];
        $pos=Db::name('ware_position')->field('pos_code')->where($where)->find();
        if($pos==null){
            $result['msg']='该仓库还未设置货位信息';goto _end;
        }
        $ware['pos_code']=$pos['pos_code'];
        $result=['status'=>1,'msg'=>'设定成功','ware'=>$ware];
        _end:
        return $result;
    }
    /**
     * 保存
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function saveStockReceive($data,$user){
        $result=['status'=>0,'msg'=>'保存失败'];
        $data=CommonFun::ProcessingData($data);
        if(empty($data['orderid'])){
            $result['msg']="保存失败，请求参数异常";goto _end;
        }
        $order=Db::name('stock_receive')->field('isclose,ischeck')->where(['orderid'=>$data['orderid']])->find();
        if($order==null){
            $result['msg']="保存失败，请求参数异常";goto _end;
        }
        if($order['ischeck']==1 || $order['isclose']==1){
            $result['msg']="复核单据已审核或已结案，不能进行修改操作";goto _end;
        }
        $validate=new StockReceiveValid();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();
            goto _end;
        }
        if(!isset($data['list']) || !is_array($data['list']) && count($data['lsit'])==0){
            $result['msg']="暂无入库商品,请求异常";
            goto _end;
        }
        $receive_data['emp_no']=empty($data['emp_no'])?'':$data['emp_no'];
        $receive_data['emp_name']=empty($data['emp_name'])?'':$data['emp_name'];
        $receive_data['sup_code']=$data['sup_code'];
        $receive_data['sup_sell']=$data['sup_sell'];
        $receive_data['sup_contact']=$data['sup_contact'];
        $receive_data['sales_code']=$data['sales_code'];
        $receive_data['sales_name']=$data['sales_name'];
        $receive_data['paymode']=$data['paymode'];
        $receive_data['dept_name']=$data['dept_name'];
        $receive_data['fungible']=intval($data['fungible'])==1?1:0;
        $receive_data['pay_date']=$data['pay_date'];
        $receive_data['remark']=$data['remark'];
        $receive_data['updator']=$user;
        $receive_data['update_date']=date('Y-m-d H:i:s',time());
        $receive_data['keeper1_code']=empty($data['keeper1_code'])?'':$data['keeper1_code'];
        $receive_data['keeper1_name']=empty($data['keeper1_name'])?'':$data['keeper1_name'];
        $receive_data['keeper2_code']=empty($data['keeper2_code'])?'':$data['keeper2_code'];
        $receive_data['keeper2_name']=empty($data['keeper2_name'])?'':$data['keeper2_name'];
        $receive_data['goodsqty']=0;
        $receive_data['goodssum']=0;
        $receive_data['taxsum']=0;
        $receive_data['amount']=0;
        $dtl_validate=new StockReceiveDetailsValid();
        Db::startTrans();
        try {
            $su_count=0; //更新条数
            foreach($data['list'] as $k=>$v){
                $v=CommonFun::ProcessingData($v);
                $hasCheck=$dtl_validate->scene('all')->check($v);
                if (!$hasCheck){
                    Db::rollback();
                    $result['msg']=$dtl_validate->getError();
                    goto _end;
                }
                $details_list['updator']=$user;
                $details_list['update_date']=date('Y-m-d H:i:s',time());
                $details_list['unit']=$v['unit'];
                $details_list['batchno']=$v['batchno'];
                $details_list['prod_date']=$v['prod_date'];
                $details_list['valid_date']=empty($v['valid_date'])?null:$v['valid_date'];
                $details_list['ware_code']=$v['ware_code'];
                $details_list['pos_code']=$v['pos_code'];
                $details_list['sup_sellno']=$v['sup_sellno'];
                $details_list['sup_goodsid']=$v['sup_goodsid'];
                $details_list['traceback_no']=$v['traceback_no'];
                $details_list['germicidal_no']=$v['germicidal_no'];
                $details_list['goods_state']=$v['goods_state'];
                $details_list['quality_state']=$v['quality_state'];
                $details_list['remark']=strip_tags(trim($v['remark']));
                $details_list['giftqty']=bccomp($v['giftqty'],'0',5)>0?$v['giftqty']:0;
                $details_list['qty']=bccomp($v['qty'],'0',5)>0?$v['qty']:0;
                $details_list['price']=bccomp($v['price'],'0',6)>0?$v['price']:0;
                $details_list['taxrate']=bccomp($v['taxrate'],'0',2)>0?$v['taxrate']:0;
                $details_list['notax_price']=$details_list['price'];
                if(bccomp($details_list['taxrate'],'0',2)>0){
                    //计算无税单价
                    $taxrate=calc([$details_list['taxrate'],'/',100,'+',1],8);
                    $details_list['notax_price']=calc([$details_list['price'],'/',$taxrate],6);
                }
                //计算货款、税款、总额
                $details_list['goodssum']=calc([$details_list['qty'],'*',$details_list['notax_price']],6);
                $details_list['amount']=calc([$details_list['qty'],'*',$details_list['price']],6);
                $details_list['taxsum']=calc([$details_list['amount'],'-',$details_list['goodssum']],6);
                //计算单据数据
                $receive_data['goodsqty']=calc([$receive_data['goodsqty'],'+',$details_list['qty']],5);
                $receive_data['goodssum']=calc([$receive_data['goodssum'],'+',$details_list['goodssum']],6);
                $receive_data['taxsum']=calc([$receive_data['taxsum'],'+',$details_list['taxsum']],6);
                $receive_data['amount']=calc([$receive_data['amount'],'+',$details_list['amount']],6);
                //处理更新数据
                $map['id']=$v['id'];
                $map['orderid']=$data['orderid'];
                $res2=Db::name('stock_receive_details')->where($map)->update($details_list);
                if($res2) $su_count++;
            }
            //更新单据
            $res1=Db::name('stock_receive')->where(['orderid'=>$data['orderid']])->update($receive_data);
            //判断更新状态，提交事务
            if($res1 && $su_count==count($data['list'])){
                Db::commit();
                $result=['status'=>1,'msg'=>'保存处理成功'];
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
     * 审核
     * @param $data 请求参数
     * @param $user 审核人
     * @param 部门名称
     */
    public static function checkStockReceive($data,$user,$deptid){
        $result=['status'=>0,'msg'=>'审核失败'];
        if(empty($data['orderid'])) goto _end;
        $field="s.*,p.full_name,p.address,p.bank_account,p.tax_code,p.bank_area";
        $order=Db::name('stock_receive')->alias('s')->field($field)
               ->join('providers p','p.supplier_code=s.sup_code','left')
               ->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['isclose']==1 || $order['ischeck']==1){
            $result['msg']="复核单已审核或已结案，不能进行审核操作";goto _end;
        }
        if(empty($order['sup_code'])){
            $result['msg']="复核单暂未设置供应商编码";goto _end;
        }
        //获取采购商品
        $field='d.*,c.unit as main_unit,c.unit2,c.is_solit,c.solit_value';
        $list=Db::name('stock_receive_details')->alias('d')->field($field)
                ->join('commodity c','c.goods_code=d.goods_code','left')
                ->where(['d.orderid'=>$data['orderid']])->select()->toArray();
        $list_count=count($list);
        if($list_count==0){
            $result['msg']="入库复核单暂无入库商品明细";goto _end;
        }
        $nowDate=date('Y-m-d H:i:s',time());
        //采购结算单资料
        $PchSettle['orderid']=CommonFun::createOrder('CJ');
        $PchSettle['reforderid']=$data['orderid'];
        $PchSettle['sup_code']=$order['sup_code'];
        $PchSettle['dept_name']=$order['dept_name'];
        $PchSettle['sales_deptid']=$deptid;
        $PchSettle['settle_date']=$nowDate;
        $PchSettle['paymode']=$order['paymode'];
        $PchSettle['sup_sell']=$order['sup_sell'];
        $PchSettle['sup_contact']=$order['sup_contact'];
        $PchSettle['emp_no']=$order['sales_code'];
        $PchSettle['emp_name']=$order['sales_name'];
        $PchSettle['invoice_date']=$nowDate;
        $PchSettle['company_name']=$order['full_name'];
        $PchSettle['invoice_amount']=$order['amount'];
        $PchSettle['invoice_address']=$order['address'];
        $PchSettle['amount']=$order['amount'];
        $PchSettle['orig_amount']=$order['amount'];
        $PchSettle['account_no']=$order['bank_account'];
        $PchSettle['tax_no']=$order['tax_code'];
        $PchSettle['bank_name']=$order['bank_area'];
        $PchSettle['stock_amount']=$order['amount'];
        $PchSettle['creater']=$user;
        $PchSettle['create_date']=$nowDate;
        $PchSettle['updator']=$user;
        $PchSettle['update_date']=$nowDate;
        $PchSettle['dept_id']=$deptid;
        $PchSettle['goods_qty']=0;
        $PchSettle['goods_sum']=0;
        $PchSettle['taxsum']=0;
        $StockBatchDetail=[]; //商品库存总表
        $StockDetail=[]; //商品库存明细
        $GoodsInOut=[]; //商品出入库明细
        $PchSettleDetail=[]; //采购结算单明细
        $dtl_validate=new StockReceiveDetailsValid();
        foreach($list as $k=>$v){
            $hasCheck=$dtl_validate->scene('all')->check($v);
            if (!$hasCheck){
                $result['msg']=$dtl_validate->getError();
                goto _end;
            }
            $lock=Accstock::checkStockLocked($v['ware_code']);
            if($lock['status']!=1){
                $result['msg']="入库商品【{$v['goods_code']}】的仓库正在盘点，被以下盘点单据锁定:{$lock['bill_no']},不能进行还原操作";
                goto _end;
            }
            if(strcasecmp(trim($v['main_unit']),trim($v['unit2']))==0){
                $result['msg'] = "入库商品明细【{$v['goods_code']}】主单位与辅单位存在一致，不能进行入库操作";
                goto _end;
            }
            $hasSplit=intval($v['is_solit']);
            //使用辅单位入库，不允许拆零判断
            $hasUnit2=strcasecmp(trim($v['unit']),trim($v['unit2'])); //辅单位是否相等
            $hasUnit=strcasecmp(trim($v['unit']),trim($v['main_unit'])); //主单位是否相等
            if($hasUnit!=0 && $hasUnit2!=0){
                $result['msg'] = "入库商品明细【{$v['goods_code']}】单位与商品资料设置的单位不一致，不能进行入库操作";
                goto _end;
            }
            if($hasSplit!=1 && $hasUnit2==0){
                $result['msg'] = "入库商品明细【{$v['goods_code']}】不允许拆零，所以不能使用辅单位入库";
                goto _end;
            }
            $Qty=calc([$v['qty'],'+',$v['giftqty']],5); //入库数量
            $splitRate=$hasSplit==1?$v['solit_value']:1; //换算率
            //库存资料
            $StockDetail[$k]['item_no']=$v['id'];
            $StockDetail[$k]['reforderid']=$data['orderid'];
            $StockDetail[$k]['goods_code']=$v['goods_code'];
            $StockDetail[$k]['inout_kind']=1; //采购入库
            $StockDetail[$k]['unit']=$v['unit'];
            $StockDetail[$k]['batch_no']=$v['batchno'];
            $StockDetail[$k]['prod_date']=$v['prod_date'];
            $StockDetail[$k]['valid_date']=$v['valid_date'];
            $StockDetail[$k]['qty']=($hasUnit2==0 && $hasSplit==1)?calc([$Qty,'/',$splitRate],5):$Qty;
            $StockDetail[$k]['qty1']=$hasSplit==1?intval($StockDetail[$k]['qty']):$StockDetail[$k]['qty'];
            $Qty2=calc([$StockDetail[$k]['qty'],'-',$StockDetail[$k]['qty1']],5);
            $StockDetail[$k]['qty2']=$hasSplit==1?calc([$Qty2,'*',$splitRate],6):0;
            $StockDetail[$k]['price1']=calc([$v['amount'],'/',$StockDetail[$k]['qty']],6);
            $StockDetail[$k]['price2']=$hasSplit==1?calc([$StockDetail[$k]['price1'],'/',$splitRate],6):0; //辅单位单价
            $StockDetail[$k]['amount']=$v['amount'];
            $StockDetail[$k]['ware_code']=$v['ware_code'];
            $StockDetail[$k]['pos_code']=$v['pos_code'];
            $StockDetail[$k]['sup_code']=$order['sup_code'];
            $StockDetail[$k]['inqty']=$StockDetail[$k]['qty'];
            $StockDetail[$k]['goods_state']=$v['goods_state'];
            $StockDetail[$k]['quality_state']=$v['quality_state'];
            $StockDetail[$k]['updator']=$user;
            $StockDetail[$k]['update_date']=$nowDate;
            $StockDetail[$k]['purch_date']=$nowDate;
            //出入库明细
            $GoodsInOut[$k]['item_no']=$v['id'];
            $GoodsInOut[$k]['goods_code']=$v['goods_code'];
            $GoodsInOut[$k]['reforderid']=$data['orderid'];
            $GoodsInOut[$k]['order_date']=$nowDate;
            $GoodsInOut[$k]['unit']=$v['unit'];
            $GoodsInOut[$k]['ware_code']=$v['ware_code'];
            $GoodsInOut[$k]['pos_code']=$v['pos_code'];
            $GoodsInOut[$k]['sup_code']=$order['sup_code'];
            $GoodsInOut[$k]['inout_kind']=1; //采购入库
            $GoodsInOut[$k]['qty']=$Qty;
            $GoodsInOut[$k]['price']=$v['price'];
            $GoodsInOut[$k]['account']=$v['amount'];
            $GoodsInOut[$k]['batch_no']=$v['batchno'];
            $GoodsInOut[$k]['prod_date']=$v['prod_date'];
            $GoodsInOut[$k]['valid_date']=$v['valid_date'];
            $GoodsInOut[$k]['goods_state']=$v['goods_state'];
            $GoodsInOut[$k]['quality_state']=$v['quality_state'];
            $GoodsInOut[$k]['creator']=$user;
            $GoodsInOut[$k]['create_date']=$nowDate;
            //采购结算单明细
            $PchSettleDetail[$k]['orderid']=$PchSettle['orderid'];
            $PchSettleDetail[$k]['reforderid']=$data['orderid'];
            $PchSettleDetail[$k]['item_no']=$v['id'];
            $PchSettleDetail[$k]['goods_code']=$v['goods_code'];
            $PchSettleDetail[$k]['unit']=$v['unit'];
            $PchSettleDetail[$k]['giftqty']=$v['giftqty'];
            $PchSettleDetail[$k]['qty']=$StockDetail[$k]['qty'];
            $PchSettleDetail[$k]['amount']=$v['amount'];
            $PchSettleDetail[$k]['taxrate']=$v['taxrate'];
            $PchSettleDetail[$k]['price']=$v['price'];
            $PchSettleDetail[$k]['settle_price']=calc([$v['amount'],'/',$PchSettleDetail[$k]['qty']],6);
            $PchSettleDetail[$k]['notax_price']=$PchSettleDetail[$k]['settle_price'];
            if(bccomp($v['taxrate'],'0',5)>0){
                $taxtate=calc([$v['taxrate'],'/',100,'+',1],10);
                $PchSettleDetail[$k]['notax_price']=calc([$PchSettleDetail[$k]['settle_price'],'/',$taxtate],6);
            }
            $PchSettleDetail[$k]['goodssum']=calc([$PchSettleDetail[$k]['notax_price'],'*',$PchSettleDetail[$k]['qty']],6);
            $PchSettleDetail[$k]['taxsum']=calc([$v['amount'],'-',$PchSettleDetail[$k]['goodssum']],6);
            $PchSettleDetail[$k]['batchno']=$v['batchno'];
            $PchSettleDetail[$k]['prod_date']=$v['prod_date'];
            $PchSettleDetail[$k]['valid_date']=$v['valid_date'];
            $PchSettleDetail[$k]['updator']=$user;
            $PchSettleDetail[$k]['update_date']=$nowDate;
            //结算总额
            $PchSettle['goods_qty']=calc([$PchSettle['goods_qty'],'+',$PchSettleDetail[$k]['qty']],5);
            $PchSettle['goods_sum']=calc([$PchSettle['goods_sum'],'+',$PchSettleDetail[$k]['goodssum']],6);
            $PchSettle['taxsum']=calc([$PchSettle['taxsum'],'+',$PchSettleDetail[$k]['taxsum']],6);
            //整合商品库存总表
            $key=$order['sup_code'].'-'.$v['goods_code'].'-'.$v['batchno'].'-'.$v['ware_code'].'-'.$v['pos_code'];
            if(isset($StockBatchDetail[$key])){
                $StockBatchDetail[$key]['qty']=calc([$StockBatchDetail[$key]['qty'],'+',$StockDetail[$k]['qty']],5);
                $StockBatchDetail[$key]['amount']=calc([$StockBatchDetail[$key]['amount'],'+',$StockDetail[$k]['amount']],6);
            }else{
                $StockBatchDetail[$key]['ware_code']=$v['ware_code'];
                $StockBatchDetail[$key]['pos_code']=$v['pos_code'];
                $StockBatchDetail[$key]['sup_code']=$order['sup_code'];
                $StockBatchDetail[$key]['goods_code']=$v['goods_code'];
                $StockBatchDetail[$key]['batch_no']=$v['batchno'];
                $StockBatchDetail[$key]['qty']=$StockDetail[$k]['qty'];
                $StockBatchDetail[$key]['amount']=$StockDetail[$k]['amount'];
                $StockBatchDetail[$key]['convRate']=$splitRate;
                $StockBatchDetail[$key]['hasSplit']=$hasSplit;
            }
            $StockBatchDetail[$key]['prod_date']=$v['prod_date'];
            $StockBatchDetail[$key]['valid_date']=trim($v['valid_date']);
            $StockBatchDetail[$key]['goods_state']=$v['goods_state'];
            $StockBatchDetail[$key]['quality_state']=$v['quality_state'];
        }
        Db::startTrans();
        try {
            $res1=Db::name('stock_details')->insertAll($StockDetail);
            $res2=Db::name('stock_goodsinout')->insertAll($GoodsInOut);
            //更新入库单状态
            $order_data['ischeck']=1;
            $order_data['check_code']=$user;
            $order_data['check_date']=$nowDate;
            $res3=Db::name('stock_receive')->where(['orderid'=>$data['orderid']])->update($order_data);
            //判断是否需要写入采购结算单
            $res4=0;$res5=0;
            $hasPay=self::checkSettle($order['reforderid']);
            if($hasPay!=1){
                $res4=Db::name('purchase_settle')->insert($PchSettle);
                $res5=Db::name('purchase_settle_details')->insertAll($PchSettleDetail);
            }else{$res4=1;$res5=$list_count;}
            //插入库存总表
            $res6=0;
            foreach ($StockBatchDetail as $v){
                $re=Db::execute("CALL insertOrUpdateStockBatch('{$v['ware_code']}','{$v['pos_code']}','{$v['sup_code']}','{$v['goods_code']}','{$v['batch_no']}',{$v['qty']},{$v['amount']},'{$v['prod_date']}','{$v['valid_date']}','{$v['goods_state']}','{$v['quality_state']}',{$v['convRate']},{$v['hasSplit']})");
                if($re) $res6++;
            }
            if($res1==$list_count && $res2==$list_count && $res3 && $res4 && $res5==$list_count && $res6==count($StockBatchDetail)){
                Db::commit();
                $result=['status'=>1,'msg'=>'审核已成功','check_code'=>$user];
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
     * 还原
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function backStockReceive($data,$user){
        $result=['status'=>0,'msg'=>'还原失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('stock_receive')->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['ischeck']!=1 || $order['isclose']==1){
            $result['msg']='入库复核单未审核或已结案，不能进行还原';
            goto _end;
        }
        $buildSql=Db::name('stock_goodsinout')->field('stock_id')->where(['reforderid'=>$data['orderid']])->buildSql();
        $zwhere[]=['d.id','exp',Db::raw("in {$buildSql}")];
        $list=Db::name('stock_details')->alias('d')->field('d.*,c.is_solit,c.solit_value')->join('commodity c','c.goods_code=d.goods_code','left')->where($zwhere)->select()->toArray();
        if(count($list)==0){
            $result['msg']='入库单无商品入库记录，不能进行还原';
            goto _end;
        }
        foreach($list as $v){
            $lock=Accstock::checkStockLocked($v['ware_code']);
            if($lock['status']!=1){
                $result['msg']="入库商品【{$v['goods_code']}】正在盘点，被以下盘点单据锁定:{$lock['bill_no']},不能进行还原操作";
                goto _end;
            }
            if(bccomp($v['qty'],$v['inqty'],5)<0){
                $result['msg']="【{$data['orderid']}】入库单有以下商品发生了出库交易，不能进行还原:&nbsp;项次{$v['item_no']}&nbsp;&nbsp;商品{$v['goods_code']}";
                goto _end;
            }
        }
        Db::startTrans();
        try {
            //删除库存明细
            $where[]=['id','exp',Db::raw("in {$buildSql}")];
            $map[]=['','exp',Db::raw('inqty > qty')];
            $map[]=['id','exp',Db::raw("in {$buildSql}")];
            $buildSql1=Db::name('stock_details')->field('count(id) as num')->where($map)->buildSql();
            $where[]=['','exp',Db::raw("0=(select num from {$buildSql1} as temp)")];
            $wSql2[]=['reforderid','=',$data['orderid']];
            $wSql2[]=['id','exp',Db::raw("in {$buildSql}")];
            $buildSql2 = Db::name('stock_details')->field('ware_code')->where($wSql2)->buildSql();
            $where2[] = ['ware_code','exp',Db::raw("in {$buildSql2}")];
            $buildSql3=Db::name('ware_locked')->field('count(ware_code) as num')->where($where2)->buildSql();
            $where[]=['','exp',Db::raw("0 = (select num from {$buildSql3} as temp1)")];
            $res1=Db::name('stock_details')->where($where)->delete();
            //删除入库记录
            $res2=Db::name('stock_goodsinout')->where(['reforderid'=>$data['orderid']])->delete();
            //删除结算单数据
            $hasPay=self::checkSettle($order['reforderid']);
            if($hasPay!=1){
                $res3=Db::name('purchase_settle')->where(['reforderid'=>$data['orderid']])->delete();
            }else $res3=1;
            //处理入库单未审核
            $receive['ischeck']=0;
            $receive['updator']=$user;
            $receive['update_date']=date('Y-m-d H:i:s',time());
            $res4=Db::name('stock_receive')->where(['orderid'=>$data['orderid']])->update($receive);
            //扣减商品总库存
            $res5=0;
            foreach ($list as $v){
                $hasSplit=intval($v['is_solit']);
                $splitRate=intval($v['is_solit'])==1?$v['solit_value']:1;
                $re=Db::execute("CALL insertOrUpdateStockBatch('{$v['ware_code']}','{$v['pos_code']}','{$v['sup_code']}','{$v['goods_code']}','{$v['batch_no']}',-{$v['qty']},-{$v['amount']},'{$v['pro_date']}','{$v['valid_date']}','','',{$splitRate},{$hasSplit})");
                if($re) $res5++;
            }
            if($res1 && $res2 && $res3 && $res4 && count($list)==$res5){
                Db::commit();
                $result=['status'=>1,'msg'=>'还原处理已成功'];
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
     * 结案
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function closeStockReceive($data,$user){
        $result=['status'=>0,'msg'=>'结案操作失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('stock_receive')->where(['orderid'=>$data['orderid']])->find();
        if($order==null) goto _end;
        $isclose=$order['isclose']==1?0:1;
        $closedata['isclose']=$isclose;
        $closedata['updator']=$user;
        $closedata['update_date']=date('Y-m-d H:i:s',time());
        $res=Db::name('stock_receive')->where(['orderid'=>$data['orderid']])->update($closedata);
        if($res){
            $result=['status'=>1,'msg'=>'结案操作成功','isclose'=>$isclose];
        }
        _end:
        return $result;
    }
    /**
     * 检测入库通知单是否需要写入采购结算单
     * @param $reforderid 来货登记单号
     */
    private static function checkSettle($reforderid){
        $hasPay=0;
        $regorder=Db::name('purchase_register')->field('o_orderid')->where(['orderid'=>$reforderid])->find();
        if($regorder!=null && !empty($regorder['o_orderid'])){
            $hasPay=Db::name('purchase_pay')->field('orderid')->where(['reforderid'=>$regorder['o_orderid']])->find();
            if($hasPay!=null) $hasPay=1;
        }
        return $hasPay;
    }
}