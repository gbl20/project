<?php
namespace app\sales\model;
use app\erp\model\Customer;
use app\erp\model\DbWork;
use app\erp\model\Employee;
use app\finance\model\SelSettle;
use app\helper\CommonFun;
use app\sales\validate\SelExportVal;
use app\ware\model\StockOut;
use think\Exception;
use think\facade\Db;
use think\Model;

Class SelExport extends Model{
    /**
     * 订单列表
     * @param $inData
     * @return mixed
     */
    public static function queryList($inData){
        $where = [];
        $inData = CommonFun::ProcessingData($inData,['need_deliver']);
        if(isset($inData['need_deliver'])){
            $where[] = ['s.need_deliver','=',$inData['need_deliver']];
        }
        if(isset($inData['start_f_date']) && isset($inData['end_f_date'])){
            if($inData['start_f_date']!==null && $inData['end_f_date']!==null){
                $where[] = ['s.f_date','between',[$inData['start_f_date'],$inData['end_f_date']]];
            }elseif($inData['start_f_date']!==null){
                $where[] = ['s.f_date','>=',$inData['start_f_date']];
            }elseif($inData['end_f_date']!==null){
                $where[] = ['s.f_date','<=',$inData['end_f_date']];
            }
        }
        if(isset($inData['y_order'])){
            $where[] = ['s.orderid','not in',$inData['y_order']];
        }
        if(isset($inData['orderid'])){
            $where[] = ['s.orderid','like','%'.$inData['orderid'].'%'];
        }
        if(isset($inData['deliver_line'])){
            $where[] = ['s.deliver_line','like','%'.$inData['deliver_line'].'%'];
        }
        if(isset($inData['cust_no'])){
            $where[] = ['s.cust_no','like','%'.$inData['cust_no'].'%'];
        }
        $data = SelExport::alias('s')
            ->join('customer c','c.id = s.cust_no', 'LEFT')
            ->field('s.*,c.name as cust_name,c.deliorder,c.area')
            ->where($where)
            ->select()->toArray();
        return $data;
    }
    /**
     * 查询单个订单数据
     * @param $inData
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function queryOne($inData){
        $data = null;
        $orderId = $inData['quotation_orderid'];
        $custData = null;
        $details = null;
        $deliver_cause = null;
        if(!$orderId) goto _end;
        $data = SelExport::field('*')->where('orderid',$orderId)->find();
        if($data){
            $field = 's.*,c.goods_name,c.specs,c.origin,c.production,c.dosage,c.approval_code,c.packspecs,c.gsp_type,c.production,w.ware_title';
            $format = 's.o_price,s.price,s.goods_sum,s.tax_sum,s.un_tax_price,s.tax_rate,s.rebate,s.qty,s.amount,s.bulk_qty,s.whole_qty';
            $details = SelExportDtl::alias('s')
                ->join('commodity c','c.goods_code = s.goods_code','left')
                ->join('warehouse w','w.ware_code = s.ware_code','left')
                ->field($field,$format)->where('orderid',$orderId)->select()->toArray();
            $cust_data = Customer::getSimpleList([['id','=',$data['cust_no']]],1);
            if($cust_data){
                $custData = $cust_data['data'][0];
                $data['cust_name'] = $custData['name'];
            }else $data['cust_name'] = '';
        }
        $deliver_cause = DbWork::queryList('priority_reasons');
        _end:
        return ['data'=>$data,'details'=>$details,'cust_data'=>$custData,'deliver_cause'=>$deliver_cause];
    }
    /**
     * 审核订单
     * @param $data
     * @param $uCode
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function auditSelExport($data,$uCode){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $orderId = strip_tags($data['orderid']);
        $where[] = ['orderid','=',$orderId];
        $where[] = ['is_transfer','=',0];
        $selExport = SelExport::where($where)->field('*')->find()->toArray();
        $selExportDtl =  SelExportDtl::where('orderid','=',$orderId)->field('*')->select()->toArray();
        if(!$selExport || !$selExportDtl) goto _end;
        $deptId = Employee::where(['code'=>$uCode])->value('depart_id');
        Db::startTrans();
        try {

            $re1 = SelSettle::SelExportTransfer($selExport,$selExportDtl,$uCode,$deptId);//生成销售结算
            if(!$re1['status']){
                Db::rollback();
                goto _end;
            }
            $re2 = StockOut::StockOutTransfer($selExport,$selExportDtl,$uCode,$deptId);//生成出库登记、复核
            if(!$re2['status']){
                Db::rollback();
                goto _end;
            }
            $upD['is_transfer'] = 1;
            $upD['audit'] = $uCode;
            $upD['audit_date'] = date('Y-m-d H:i:s',time());
            $re3 = SelExport::where($where)->update($upD);
            if($re1['status'] && $re2['status'] && $re3){
                Db::commit();
                $res = ['status'=>1,'msg'=>'销售开单['.$selExport['orderid'].']已成功生成出库单['.$re2['orderIds'].']，要查看该单据吗？','orderid'=>$selExport['orderid']];
            }else Db::rollback();
        }catch (Exception $e){
            $res['msg'] = $e->getMessage();
            Db::rollback();
        }
        _end:
        return $res;
    }
    /**
     * 还原审核
     * @param $inData
     * @param $uCode
     * @return array
     */
    public static function reductionSelExport($inData,$uCode){
        $res = ['status'=>0,'msg'=>'还原失败'];

        return $res;
    }
    /**
     * 保存订单
     * @param $inData
     * @param $uCode
     * @return array
     */
    public static function comSelExport($inData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $date = date('Y-m-d',time());
        $dateTime = date('Y-m-d H:i:s',time());
        $data = CommonFun::ProcessingData($inData['fdata'],['fungible','need_deliver','is_finish','is_transfer']);
        $details = $inData['data'];
        $validate = new SelExportVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();
            goto _end;
        }
        $orderId = $data['orderid'];
        if(!$orderId) $orderId = CommonFun::createOrder('SE');
        $reOrderDtl = [];
        $orderTotal = [
            'goods_qty' => 0,//总数量
            'goods_sum' => 0,//货款
            'tax_sum' => 0,//税款
            'amount' => 0,//总价
            'ref_cost' => 0,//参考成本
            'ref_profit' => 0//参考毛利
        ];
        $DetailsStock = [];
        $i = 0;
        $is_cold_storage = 0;
        foreach($details as $k=>$vv){
            $v = CommonFun::ProcessingData($vv,[],['s_o_price','s_rebate','s_tax_rate','s_qty','s_whole_qty','s_bulk_qty']);
            $storage_type = Db::name('commodity_warehouse')->where('goods_code',$v['goods_code'])->value('storage_type');
            $v['is_cold_storage'] = 0;
            if($storage_type == '冷藏储存'){
                $is_cold_storage = 1;
                $v['is_cold_storage'] = 1;
            }
            $qty = $v['s_qty'];
            unset($where);
            $where[] = ['unit2','=',$v['unit']];
            $commodity = Db::name('commodity')->where($where)->field('unit,unit2,solit_value,is_solit,pack_specs2')->find();
            if($commodity) $qty = calc([$qty,'/',$commodity['solit_value']],5);
            if($v['ware_code'] && $v['prov_no'] && $v['berth_no'] && $v['batch_no']){
                unset($where);
                $where[] = ['ware_code','=',$v['ware_code']];
                $where[] = ['sup_code','=',$v['prov_no']];
                $where[] = ['pos_code','=',$v['berth_no']];
                $where[] = ['batch_no','=',$v['batch_no']];
                $where[] = ['goods_code','=',$v['goods_code']];
                $stockDetaiks = Db::name('stock_batchpart')->where($where)->field('id,batch_no,prod_date,valid_date,qty,price1,price2,ware_code,pos_code as berth_no,sup_code as prov_no')->find();
                if($stockDetaiks){
                    if($stockDetaiks['qty'] >= $qty){//正常分配
                        $key = $i++;
                        $assembleRes = self::assembleOrderDetails($orderId,$key,$v,$qty,$stockDetaiks,$orderTotal,$commodity);
                        $reOrderDtl[$key] = $assembleRes['re_dtl'];
                        $orderTotal = $assembleRes['order_total'];
                        continue;
                    }else if($stockDetaiks['qty'] > 0){
                        //先分完该批次
                        $key = $i++;
                        $assembleRes = self::assembleOrderDetails($orderId,$key,$v,$stockDetaiks['qty'],$stockDetaiks,$orderTotal,$commodity);
                        $reOrderDtl[$key] = $assembleRes['re_dtl'];
                        $orderTotal = $assembleRes['order_total'];
                        $qty = calc([$qty,'-',$stockDetaiks['qty']],5);
                    }
                }
            }
            //没有分配到仓库的产品重新分配
            unset($where);
            if(!isset($DetailsStock[$v['goods_code']])){
                $DetailsStock[$v['goods_code']] = [];
                if($v['ware_code'] && $v['prov_no'] && $v['berth_no'] && $v['batch_no'] && $stockDetaiks){
                    $where[] = ['id','<>',$stockDetaiks['id']];
                }
                $where[] = ['goods_code','=',$v['goods_code']];
                $where[] = ['qty','>',0];
                $DetailsStock[$v['goods_code']] = Db::name('stock_batchpart')->where($where)->field('batch_no,prod_date,valid_date,qty,price1,price2,ware_code,pos_code as berth_no,sup_code as prov_no')->select()->toArray();
            }
            if(!$DetailsStock[$v['goods_code']]){
                $res['msg'] = '项次'.($v['item_no']+1).'产品'.$v['goods_code'].'库存不足';
                goto _end;
            }
            foreach ($DetailsStock[$v['goods_code']] as $kk=>$val){
                if($val['qty'] >= $qty){
                    $key = $i++;
                    $assembleRes = self::assembleOrderDetails($orderId,$key,$v,$qty,$stockDetaiks,$orderTotal,$commodity);
                    $reOrderDtl[$key] = $assembleRes['re_dtl'];
                    $orderTotal = $assembleRes['order_total'];
                    $qty = calc([$qty,'-',$val['qty']],5);
                    $DetailsStock[$v['goods_code']][$kk]['qty'] = calc([$val['qty'],'-',$qty],5);
                    if($DetailsStock[$v['goods_code']][$kk]['qty'] <= 0) unset($DetailsStock[$v['goods_code']][$kk]);
                    break;
                }else{
                    $key = $i++;
                    $assembleRes = self::assembleOrderDetails($orderId,$key,$v,$val['qty'],$stockDetaiks,$orderTotal,$commodity);
                    $reOrderDtl[$key] = $assembleRes['re_dtl'];
                    $orderTotal = $assembleRes['order_total'];
                    $qty = calc([$qty,'-',$val['qty']],5);
                    unset($DetailsStock[$v['goods_code']][$kk]);
                }
            }
            if($qty > 0){
                $res['msg'] = '项次'.($v['item_no'] > 0).'产品'.$v['goods_code'].'库存不足';
                goto _end;
            }
        }
        $reOrderD['in_out_kind'] = 51;
        $reOrderD['is_cold_storage'] = $is_cold_storage;
        $reOrderD['order_no'] = $data['order_no'];
        $reOrderD['contract_no'] = $data['contract_no'];
        $reOrderD['emp_no'] = $data['emp_no'];
        $reOrderD['cust_no'] = $data['cust_no'];
        $reOrderD['link_man'] = $data['link_man'];
        $reOrderD['link_tel'] = $data['link_tel'];
        $reOrderD['goods_qty'] = $orderTotal['goods_qty'];
        $reOrderD['goods_sum'] = $orderTotal['goods_sum'];
        $reOrderD['tax_sum'] = $orderTotal['tax_sum'];
        $reOrderD['amount'] = $orderTotal['amount'];
        $reOrderD['pay_mode_no'] = $data['pay_mode_no'];
        $reOrderD['pay_date'] = $data['pay_date'];
        $reOrderD['need_deliver'] = $data['need_deliver'];
        $reOrderD['fungible'] = $data['fungible'];
        $reOrderD['remark'] = $data['remark'];
        $reOrderD['ref_cost'] = $orderTotal['ref_cost'];
        $reOrderD['ref_profit'] = $orderTotal['ref_profit'];
        $reOrderD['pack_worker'] = $data['pack_worker'];
        $reOrderD['express_corp'] = $data['express_corp'];
        $reOrderD['express_no'] = $data['express_no'];
        $reOrderD['pick_worker'] = $data['pick_worker'];
        $reOrderD['pick_addr'] = $data['pick_addr'];
        $reOrderD['deliver_kind'] = $data['deliver_kind'];
        $reOrderD['deliver_level'] = $data['deliver_level'];
        $reOrderD['deliver_line'] = $data['deliver_line'];
        $reOrderD['priority_reasons'] = $data['priority_reasons'];
        if($reOrderD['priority_reasons']) DbWork::editDbWork(['value'=>$reOrderD['priority_reasons'],'label'=>$reOrderD['priority_reasons']],'priority_reasons');
        $reOrderD['is_transfer'] = 0;
        $reOrderD['is_finish'] = 0;
        $reOrderD['ref_profit_rate'] = calc([ $orderTotal['ref_profit'],'/',$orderTotal['goods_sum']],5);//毛利率
        Db::startTrans();
        if($data['orderid']){
            $reOrderD['mender'] = $uCode;
            $reOrderD['update_date'] = $dateTime;
            $where = [];
            $where[] = ['is_transfer','=',0];
            $where[] = ['orderid','=',$data['orderid']];
            $re1 = SelExport::where($where)->update($reOrderD);
            $re2 = SelExportDtl::where('orderid','=',$data['orderid'])->deleteInsertAll($reOrderDtl);
        }else{
            $reOrderD['orderid'] = $orderId;
            $reOrderD['f_date'] = $date;
            $depart_id = Employee::where(['code'=>$uCode])->value('depart_id');
            $reOrderD['dept_id'] = $depart_id;
            $reOrderD['creater'] = $uCode;
            $reOrderD['create_date'] = $dateTime;
            $re1 = SelExport::insert($reOrderD);
            $re2 = SelExportDtl::insertAll($reOrderDtl);
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
    private static function assembleOrderDetails($orderId,$key,$v,$qty,$stockDetaiks,$orderTotal,$commodity){
        $reDtl['orderid'] = $orderId;
        $reDtl['item_no'] = $key;
        $reDtl['goods_code'] = $v['goods_code'];
        $reDtl['is_cold_storage'] = $v['is_cold_storage'];
        $reDtl['unit'] = $v['unit'];
        $reDtl['whole_qty'] = $v['s_whole_qty'];
        $reDtl['bulk_qty'] = $v['s_bulk_qty'];
        $reDtl['qty'] = $commodity?calc([$qty,'*',$commodity['solit_value']],6):$qty;
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
        $reDtl['batch_no'] = isset($stockDetaiks['batch_no'])?$stockDetaiks['batch_no']:null;
        $reDtl['valid_date'] = isset($stockDetaiks['valid_date'])?$stockDetaiks['valid_date']:null;
        $reDtl['prod_date'] = isset($stockDetaiks['prod_date'])?$stockDetaiks['prod_date']:null;
        $reDtl['prov_no'] = isset($stockDetaiks['prov_no'])?$stockDetaiks['prov_no']:null;
        $reDtl['ware_code'] = isset($stockDetaiks['batch_no'])?$stockDetaiks['ware_code']:null;
        $reDtl['berth_no'] = isset($stockDetaiks['berth_no'])?$stockDetaiks['berth_no']:null;
        $reDtl['quality_state'] = isset($v['quality_state'])?$v['quality_state']:null;
        $reDtl['goods_state'] = isset($v['goods_state'])?$v['goods_state']:null;
        $reDtl['ref_cost_price'] = $commodity?$stockDetaiks['price1']:($stockDetaiks['price2']?$stockDetaiks['price2']:calc([$stockDetaiks['price1'],'/',$commodity['solit_value']],6));//参考成本
        $reDtl['ref_cost'] = calc([$reDtl['ref_cost_price'],'*',$reDtl['qty']],6);//参考成本
        $reDtl['ref_profit'] = calc([$reDtl['goods_sum'],'-',$reDtl['ref_cost']],6);//参考毛利
        $reDtl['ref_profit_rate'] = calc([$reDtl['ref_profit'],'/',$reDtl['goods_sum']],5);//参考毛利率
        $orderTotal['goods_qty'] = calc([$orderTotal['goods_qty'],'+',$reDtl['qty']],5);
        $orderTotal['goods_sum'] = calc([$orderTotal['goods_sum'],'+',$reDtl['goods_sum']],6);
        $orderTotal['tax_sum'] = calc([$orderTotal['tax_sum'],'+',$reDtl['tax_sum']],6);
        $orderTotal['amount'] = calc([ $orderTotal['amount'],'+',$reDtl['amount']],6);
        return ['re_dtl'=>$reDtl,'order_total'=>$orderTotal];
    }
    /**
     * 销售订单转销售开单
     * @param $selOrder
     * @param $selOrderDtl
     * @param $uCode
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function SelOrderTransfer($selOrder,$selOrderDtl,$uCode){
        $res = ['status'=>0,'msg'=>'转单失败'];
        $date = date('Y-m-d',time());
        $dateTime = date('Y-m-d H:i:s',time());
        $DetailsStock = [];
        $selExportDtl = [];
        $i = 0;
        $orderId = CommonFun::createOrder('SE');
        $selExport['orderid'] = $orderId;
        $selExport['f_date'] = $date;
        $selExport['in_out_kind'] = 51;
        $selExport['order_no'] = $selOrder['orderid'];
        $selExport['contract_no'] = $selOrder['contract_no'];
        $selExport['emp_no'] = $selOrder['emp_no'];
        $selExport['cust_no'] = $selOrder['cust_no'];
        $selExport['link_man'] = $selOrder['link_man'];
        $selExport['remark'] = $selOrder['remark'];
        $selExport['creater'] = $uCode;
        $selExport['create_date'] = $dateTime;
        $depart_id = Employee::where(['code'=>$uCode])->value('depart_id');
        $selExport['dept_id'] = $depart_id;
        $selExport['pick_addr'] = $selOrder['pick_addr'];
        $selExport['pay_mode_no'] = $selOrder['pay_mode_no'];
        $selExport['need_deliver'] = $selOrder['need_deliver'];
        $selExport['fungible'] = $selOrder['fungible'];
        $selExport['deliver_level'] = $selOrder['deliver_level'];
        $selExport['deliver_kind'] = $selOrder['deliver_kind'];
        $selExport['priority_reasons'] = $selOrder['priority_reasons'];
        $selExport['contacts'] = $selOrder['contacts'];
        $selExport['deliver_line'] = $selOrder['deliver_line'];
        $goods_qty = 0;//总数量
        $goods_sum = 0;//货款
        $tax_sum = 0;//税款
        $amount = 0;//总价
        $ref_cost = 0;//参考成本
        $ref_profit = 0;//参考毛利
        $selOrderDtlRe = [];
        $is_cold_storage = 0;
        Db::startTrans();
        try {
            foreach($selOrderDtl as $k=>$v){
                $selOrderDtlRe[$v['item_no']] = [];
                $selOrderDtlRe[$v['item_no']]['written_qty'] = 0;
                $qty = $v['qty'];
                unset($where);
                $where[] = ['goods_code','=',$v['goods_code']];
                if(!isset($DetailsStock[$v['goods_code']])){
                    $DetailsStock[$v['goods_code']] = [];
                    $whereStock = [];
                    $whereStock[] = ['s.goods_code','=',$v['goods_code']];
                    $whereStock[] = ['s.qty','>',0];
                    $DetailsStock[$v['goods_code']] = Db::name('stock_batchpart')->alias('s')
                        ->join('commodity_warehouse c','c.goods_code = s.goods_code')
                        ->where($whereStock)->field('s.batch_no,s.prod_date,s.valid_date,s.qty,s.price1,s.price2,s.ware_code,s.pos_code as berth_no,s.sup_code,c.storage_type')->select()->toArray();
                }
                if(!$DetailsStock[$v['goods_code']]){
                    $res['msg'] = '项次'.$v['item_no'].'产品'.$v['goods_code'].'库存不足';
                    goto _end;
                }
                $where[] = ['unit2','=',$v['unit']];
                $commodity = Db::name('commodity')->where($where)->field('unit,unit2,solit_value,is_solit,pack_specs2')->find();
                if($commodity) $qty = calc([$qty,'/',$commodity['solit_value']],5);
                $isBreak = false;
                foreach ($DetailsStock[$v['goods_code']] as $key=>$val){
                    if($val['storage_type'] == '冷藏储存'){
                        $is_cold_storage = 1;
                        $ExportDtl['is_cold_storage'] = 1;
                    }else $ExportDtl['is_cold_storage'] = 0;
                    $ExportDtl['item_no'] = $i+1;
                    $ExportDtl['orderid'] = $orderId;
                    $ExportDtl['p_order_no'] = $v['orderid'];
                    $ExportDtl['p_item_no'] = $v['item_no'];
                    $ExportDtl['goods_code'] = $v['goods_code'];
                    $ExportDtl['cust_goods_code'] = $v['cust_goods_code'];
                    $ExportDtl['germicidal_no'] = $v['germicidal_no'];
                    $ExportDtl['trace_back_no'] = $v['trace_back_no'];
                    $ExportDtl['goods_state'] = $v['goods_state'];
                    $ExportDtl['unit'] = $v['unit'];
                    $ExportDtl['o_price'] = $v['o_price'];
                    $ExportDtl['rebate'] = $v['rebate'];
                    $ExportDtl['price'] = $v['price'];
                    $ExportDtl['tax_rate'] = $v['tax_rate'];
                    $ExportDtl['un_tax_price'] = $v['un_tax_price'];
                    $ExportDtl['prov_no'] = $val['sup_code'];
                    $ExportDtl['ware_code'] = $val['ware_code'];
                    $ExportDtl['berth_no'] = $val['berth_no'];
                    $ExportDtl['batch_no'] = $val['batch_no'];
                    $ExportDtl['prod_date'] = $val['prod_date'];
                    $ExportDtl['valid_date'] = $val['valid_date'];
                    $ExportDtl['ref_cost_price'] = $commodity?$val['price1']:($val['price2']?$val['price2']:calc([$val['price1'],'/',$commodity['solit_value']],6));//参考成本
                    if($val['qty']>$qty){
                        $ExportDtl['qty'] = $commodity?calc([$qty,'*',$commodity['solit_value']],5):$qty;
                        $DetailsStock[$v['goods_code']][$key]['qty'] = calc([$val['qty'],'-',$qty],5);
                        if($DetailsStock[$v['goods_code']][$key]['qty'] <= 0) unset($DetailsStock[$v['goods_code']][$key]);
                        $isBreak = true;
                    }else{
                        $ExportDtl['qty'] = $commodity?calc([$val['qty'],'*',$commodity['solit_value']],5):$val['qty'];
                        unset($DetailsStock[$v['goods_code']][$key]);
                        $qty = calc([$qty,'-',$val['qty']],5);
                        if($qty <= 0) $isBreak = true;
                    }
                    $ExportDtl['amount'] = calc([$v['price'],'*',$ExportDtl['qty']],6);
                    $ExportDtl['goods_sum'] = calc([$v['un_tax_price'],'*',$ExportDtl['qty']],6);
                    $ExportDtl['tax_sum'] =  calc([$ExportDtl['amount'],'-',$ExportDtl['goods_sum']],6);
                    $ExportDtl['ref_cost'] = calc([$ExportDtl['ref_cost_price'],'*',$ExportDtl['qty']],6);//参考成本
                    $ExportDtl['ref_profit'] = calc([$ExportDtl['goods_sum'],'-',$ExportDtl['ref_cost']],6);//参考毛利
                    $ExportDtl['ref_profit_rate'] = calc([$ExportDtl['ref_profit'],'/',$ExportDtl['goods_sum']],5);//参考毛利率
                    $ref_profit = calc([$ref_profit,'+',$ExportDtl['ref_profit']],5);
                    $ref_cost = calc([$ref_cost,'+',$ExportDtl['ref_cost']],5);
                    $goods_qty = calc([$goods_qty,'+',$ExportDtl['qty']],5);
                    $goods_sum = calc([$goods_sum,'+',$ExportDtl['goods_sum']],6);
                    $tax_sum = calc([$tax_sum,'+',$ExportDtl['tax_sum']],6);
                    $amount = calc([$amount,'+',$ExportDtl['amount']],6);
                    $selOrderDtlRe[$v['item_no']]['written_qty'] = calc([$selOrderDtlRe[$v['item_no']]['written_qty'],'+',$ExportDtl['qty']],5);
                    $selExportDtl[$i] = $ExportDtl;
                    $i++;
                    if($isBreak) break;
                }
            }
            $selExport['is_cold_storage'] = $is_cold_storage;
            $selExport['goods_qty'] = $goods_qty;
            $selExport['goods_sum'] = $goods_sum;
            $selExport['tax_sum'] = $tax_sum;
            $selExport['amount'] = $amount;
            $selExport['ref_cost'] = $ref_cost;
            $selExport['ref_profit'] = $ref_profit;
            $selExport['ref_profit_rate'] = calc([$ref_profit,'/',$goods_sum],5);//毛利率
            $re1 = SelExport::insert($selExport);
            $re2 = SelExportDtl::insertAll($selExportDtl);
            foreach ($selOrderDtlRe as $item=>$rQty){
                unset($where);
                $where[] = ['item_no','=',$item];
                $where[] = ['orderid','=',$selOrder['orderid']];
                $isUpStl = SelOrderDtl::where($where)->update(['written_qty'=>$rQty['written_qty']]);
                if(!$isUpStl) goto _endRollback;
            }
            unset($where);
            $where[] = ['orderid','=',$selOrder['orderid']];
            $where[] = ['is_pass_on','=',0];
            $re3 = SelOrder::where($where)->update(['is_pass_on'=>1]);
            if($re1 && $re2 && $re3){
                Db::commit();
                $res = ['status'=>1,'msg'=>'销售订单['.$selOrder['orderid'].']已成功转出到销售开单['.$orderId.']，要查看该单据吗？','orderid'=>$orderId];
            }else{
                _endRollback:
                Db::rollback();
                $res['msg'] = '转单失败';
            }
        }catch (Exception $e){
            Db::rollback();
            $res['msg'] = $e->getMessage();
            goto _end;
        }
        _end:
        return $res;
    }

    /** 销售退回-选择已审核的发货数据 **/
    public static function custOrder($res)
    {
      $search = CommonFun::ProcessingData($res['search']);
      if (!empty($search['cust_no']) && isset($search['cust_no'])){
        $where[] = ['s.cust_no','=',$search['cust_no']];
      }
      if (!empty($search['orderid']) && isset($search['orderid'])){
        $where[] = ['s.orderid','=',$search['orderid']];
      }
      if (!empty($search['emp_no']) && isset($search['emp_no'])){
        $where[] = ['s.emp_no','=',$search['emp_no']];
      }
      if (!empty($search['creater']) && isset($search['creater'])){
        $where[] = ['s.creater','=',$search['creater']];
      }
      if (!empty($search['f_date']) && !empty($search['end_f_date'])){
        $where[] = ['s.f_date','between',[$search['f_date'],$search['end_f_date']]];
      }
      if (!empty($search['f_date']) && empty($search['end_f_date'])){
        $where[] = ['s.f_date','>',$search['f_date']];
      }
      if (empty($search['f_date']) && !empty($search['end_f_date'])){
        $where[] = ['s.f_date','<',$search['end_f_date']];
      }
      if (!empty($search['goods_code']) && isset($search['goods_code'])){
        $oid = SelExportDtl::where('goods_code',$search['goods_code'])->column('orderid');
        $where[] = ['s.orderid','in',implode(',',$oid)];
      }
      $where[] = ['s.is_transfer','=',1];
      $field = 's.orderid,s.f_date,s.cust_no,s.goods_qty,s.goods_sum,s.tax_sum,s.amount,s.dept_id,s.pay_mode_no,s.emp_no,s.creater,c.name as cust_name';
      $data = self::where($where)->alias('s')->field($field)
        ->join('customer c','c.id = s.cust_no', 'LEFT')
        ->paginate(['list_rows'=>$res['pageSize'],'page' =>$res['page']])
        ->toArray();
      return ['status'=>1,'data'=>$data];
    }
}
