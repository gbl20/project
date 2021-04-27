<?php
namespace app\ware\model;
use app\helper\CommonFun;
use think\Exception;
use think\facade\Db;
use think\Model;

Class StockOut extends Model{
    public static function StockOutTransfer($selExport,$selExportDtl,$uCode,$deptId){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $dateTime = date('Y-m-d H:i:s',time());
        $date = date('Y-m-d',time());
        $out = [];
        $outDtl = [];
        $orderArr = [];
        foreach ($selExportDtl as $k=>$v){
            $ware_code = $v['ware_code'];
            if(!isset($out[$ware_code])){
                $orderId = CommonFun::createOrder('OS');
                $orderArr[] = $orderId;
                $out[$ware_code]['orderid'] = $orderId;
                $out[$ware_code]['f_date'] = $date;
                $out[$ware_code]['ware_code'] = $ware_code;
                $out[$ware_code]['cust_no'] = $selExport['cust_no'];
                $out[$ware_code]['in_out_kind'] = 51;
                $out[$ware_code]['p_order_no'] = $selExport['orderid'];
                $out[$ware_code]['remark'] = $selExport['remark'];
                $out[$ware_code]['creater'] = $uCode;
                $out[$ware_code]['creat_date'] = $dateTime;
                $out[$ware_code]['mender'] = $uCode;
                $out[$ware_code]['update_date'] = $dateTime;
                $out[$ware_code]['audit'] = $uCode;
                $out[$ware_code]['is_transfer'] = 1;
                $out[$ware_code]['goods_qty'] = 0;
                $out[$ware_code]['goods_sum'] = 0;
                $out[$ware_code]['cost_sum'] = 0;
                $out[$ware_code]['dept_id'] = $deptId;
                $itemNo[$ware_code] = 1;
            }
            $dtl['orderid'] = $out[$ware_code]['orderid'];
            $dtl['item_no'] = $itemNo[$ware_code]++;
            $dtl['goods_code'] = $v['goods_code'];
            $dtl['unit'] = $v['unit'];
            $dtl['qty'] = $v['qty'];
            $dtl['price'] = $v['un_tax_price'];
            $dtl['amount'] = $v['goods_sum'];
            $dtl['cost'] = $v['ref_cost'];
            $dtl['orig_price'] = $v['price'];
            $dtl['pos_code'] = $v['berth_no'];
            $dtl['prov_no'] = $v['prov_no'];
            $dtl['quality_state'] = $v['quality_state'];
            $dtl['batch_no'] = $v['batch_no'];
            $dtl['prod_date'] = $v['prod_date'];
            $dtl['valid_date'] = $v['valid_date'];
            $dtl['p_order_no'] = $v['orderid'];
            $dtl['p_item_no'] = $v['item_no'];
            $outDtl[$k] = $dtl;
            $out[$ware_code]['goods_qty'] = calc([$out[$ware_code]['goods_qty'],'+',$dtl['qty']],5);
            $out[$ware_code]['goods_sum'] = calc([$out[$ware_code]['goods_sum'],'+',$dtl['amount']],6);
            $out[$ware_code]['cost_sum'] = calc([$out[$ware_code]['cost_sum'],'+',$dtl['cost']],6);
        }
        $re1 = StockOut::insertAll($out);
        $re2 = StockOutDtl::insertAll($outDtl);
        if($re1 && $re2) $res = ['status'=>1,'orderIds'=>implode(',',$orderArr)];
        return $res;
    }
    /**
     * 查询出库登记复核单列表
     * @param $data 请求参数
     */
    public static function getStockOutList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?20:intval($data['pageSize']);
        $where=[];
        $order='creat_date desc';
        $list=Db::name('view_stockout')->where($where)->order($order)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
    /**
     * 查询出库登记复核单信息
     * @param $data 请求参数
     */
    public static function getStockOutInfo($data){
        $order=null;
        if(empty($data['orderid'])) goto _end;
        $where[]=['orderid','=',$data['orderid']];
        $order=Db::name('view_stockout')->where($where)->find();
        if($order==null) goto _end;
        $field="d.*,(0+cast(d.price AS CHAR)) AS price,round(d.cost/d.qty,6) as cost_price,c.goods_name,c.name as nomal_name,c.specs,c.dosage,c.origin,c.production,c.category_id,c.category,c.pack_specs1,c.pack_specs2,c.approval_code,c.storage_type,c.license_key,p.full_name as prov_name";
        $field.=',pr5.price1 as standard_price,pr6.price1 as retail_price';
        $order['list']=Db::name('stock_out_dtl')->alias('d')->field($field)
              ->join('commodity_list c','c.goods_code=d.goods_code','left')
              ->join('providers p','p.supplier_code=d.prov_no','left')
              ->join('commodity_price pr5', 'pr5.goods_code=d.goods_code and pr5.mode_id=2', 'left')
              ->join('commodity_price pr6', 'pr6.goods_code=d.goods_code and pr6.mode_id=3', 'left')
              ->where(['d.orderid'=>$data['orderid']])
              ->select()->toArray();
        _end:
        return $order;
    }
    /**
     * 保存
     * @param $data
     * @param $user
     */
    public static function saveOrder($data,$user){
        $result=['status'=>0,'msg'=>'保存失败'];
        $data=CommonFun::ProcessingData($data);
        $nowDate=date('Y-m-d H:i:s',time());
        $order_data['shipper']=$data['shipper'];
        $order_data['emp_no']=$data['emp_no'];
        $order_data['audit2']=$data['audit2'];
        $order_data['mender']=$user;
        $order_data['update_date']=$nowDate;
        if(!isset($data['list']) || !is_array($data['list']) || empty($data['list'])){
            $result['msg']="请完善商品资料信息";
            goto _end;
        }
        Db::startTrans();
        try {
            $res1=Db::name('stock_out')->where(['orderid'=>$data['orderid']])->update($order_data);
            $success=0;
            foreach($data['list'] as $k=>$v){
                $arrdata['pos_code']=$v['pos_code'];
                $arrdata['trace_back_no']=$v['trace_back_no'];
                $arrdata['germicidal_no']=$v['germicidal_no'];
                $arrdata['goods_state']=$v['goods_state'];
                $arrdata['quality_state']=$v['quality_state'];
                $arrdata['remark']=$v['remark'];
                $arrdata['price']=$v['price'];
                $arrdata['amount']=calc([$arrdata['price'],'*',$v['qty']],6);
                $arrdata['updator']=$user;
                $arrdata['update_date']=$nowDate;
                $map[]=['orderid','=',$data['orderid']];
                $map[]=['item_no','=',$v['item_no']];
                $res=Db::name('stock_out_dtl')->where($map)->update($arrdata);
                if($res) $success++;
                unset($map);
            }
            if($res1 && $success && $success==count($data['list'])){
                Db::commit();
                $result=['status'=>1,'msg'=>'保存已成功'];
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
     * @param $orderid 订单号
     * @param $user 审核人
     */
    public static function auditOrder($data,$user){
        $result=['status'=>0,'msg'=>'审核操作失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('stock_out')->where(['orderid'=>$data['orderid']])->find();
        if($order==null) goto _end;
        if($order['is_transfer']==1){
            $result['msg']='订单已经审核处理，不能进行再次审核操作';
            goto _end;
        }
        $field="d.*,c.goods_name,c.is_solit,c.solit_value,c.unit as main_unit,c.unit2";
        $list=Db::name('stock_out_dtl')->alias('d')->field($field)
            ->join('commodity c','c.goods_code=d.goods_code','left')
            ->where(['d.orderid'=>$data['orderid']])->select()->toArray();
        if(count($list)==0){
            $result['msg']='单据信息暂无产品信息，不能审核处理操作';
            goto _end;
        }
        Db::startTrans();
        try {
            $goodsInOut=[]; //出入库记录
            $nowDate=date('Y-m-d H:i:s',time());
            $sucNum=0; //执行扣减条数
            //处理扣减库存
            foreach ($list as $v){
                //判断单位扣减
                $hasUnit2=strcasecmp(trim($v['unit']),trim($v['unit2'])); //辅单位是否相等
                $hasUnit=strcasecmp(trim($v['unit']),trim($v['main_unit'])); //主单位是否相等
                if($hasUnit!=0 && $hasUnit2!=0){
                    $result['msg']="审核失败：商品【{$v['goods_code']}】单位与资料设置不一致";
                    goto _end;
                }
                $splitRate=intval($v['is_solit'])==1?$v['solit_value']:1;
                if($hasUnit2==0) $v['qty']=calc([$v['qty'],'/',$splitRate],5);
                $sql="CALL discGoodsStockOut(:warecode,:poscode,:supcode,:goodscode,:batchNo,:qtyNum,:splitRate,@stockids,@status,@error)";
                $resultSet = Db::execute($sql,[
                    'warecode'=>$order['ware_code'],
                    'poscode'=>$v['pos_code'],
                    'supcode'=>$v['prov_no'],
                    'goodscode'=>$v['goods_code'],
                    'batchNo'=>$v['batch_no'],
                    'qtyNum'=>$v['qty'],
                    'splitRate'=>$splitRate
                ]);
                $res=Db::query('select @stockids as stockids,@status as status,@error as error');
                if(empty($res[0])) throw new \Exception("操作失败：库存扣减失败");
                if(!$res[0]['status']) throw new \Exception($res[0]['error']);
                //扣减成功、处理商品出入库记录
                $stockids=explode('|',trim($res[0]['stockids'],'|'));
                $perDiscNum=0; //已扣减的总数
                foreach($stockids as $k=>$d){
                    $idArr=explode('=',trim($d,'='));
                    $perDiscNum = calc([$idArr[1],'+',$perDiscNum],5);
                    $arr['stock_id']=$idArr[0];
                    $arr['reforderid']=$data['orderid'];
                    $arr['item_no']=$v['item_no'].$k;
                    $arr['goods_code']=$v['goods_code'];
                    $arr['order_date']=$nowDate;
                    $arr['unit']=$v['unit'];
                    $arr['ware_code']=$order['ware_code'];
                    $arr['pos_code']=$v['pos_code'];
                    $arr['sup_code']=$v['prov_no'];
                    $arr['inout_kind']=51; //销售出库
                    $arr['qty']=$idArr[1]; //扣减数量
                    $arr['price']=$v['price'];
                    $arr['account']=calc([$v['price'],'*',$idArr[1]],6);
                    $arr['batch_no']=$v['batch_no'];
                    $arr['prod_date']=$v['prod_date'];
                    $arr['valid_date']=$v['valid_date'];
                    $arr['goods_state']=$v['goods_state'];
                    $arr['quality_state']=$v['quality_state'];
                    $arr['creator']=$user;
                    $arr['create_date']=$nowDate;
                    array_push($goodsInOut,$arr);
                }
                if(bccomp($perDiscNum,$v['qty'],5)!=0) throw new \Exception("操作失败：库存扣减失败");
                $sucNum++;
            }
            //写入商品出入库明细
            $res2=Db::name('stock_goodsinout')->insertAll($goodsInOut);
            //处理订单数据
            $orderdata['audit']=$user;
            $orderdata['is_transfer']=1;
            $orderdata['mender']=$user;
            $orderdata['update_date']=$nowDate;
            $res3=Db::name('stock_out')->where(['orderid'=>$data['orderid']])->update($orderdata);
            if($sucNum==count($list) && $res2 && $res3){
                Db::commit();
                $result=['status'=>1,'msg'=>'审核操作已成功'];
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            Db::rollback();
            $result['msg']=$e->getMessage();
        }
        _end:
        return $result;
    }
    /**
     * 还原
     * @param $data 请求参数
     * @param $user 操作人
     */
    public static function backOrder($data,$user){
        $result=['status'=>0,'msg'=>'还原操作失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('stock_out')->where(['orderid'=>$data['orderid']])->find();
        if($order==null) goto _end;
        if($order['is_transfer']!=1){
            $result['msg']='订单未审核，不能进行还原操作';
            goto _end;
        }
        $field='s.stock_id,s.goods_code,s.ware_code,s.pos_code,s.sup_code,s.qty,s.batch_no,c.is_solit,c.solit_value';
        $list=Db::name('stock_goodsinout')->alias('s')->field($field)
              ->join('commodity c','c.goods_code=s.goods_code','left')
              ->where(['s.reforderid'=>$data['orderid']])->select()->toArray();
        Db::startTrans();
        try {
            //还原库存数据
            $succ=0;
            foreach ($list as $v){
                $sql="CALL backGoodsStockOut(:stockId,:warecode,:poscode,:supcode,:goodscode,:batchNo,:qtyNum,:splitRate,@status)";
                $resultSet = Db::execute($sql,[
                    'stockId'=>$v['stock_id'],
                    'warecode'=>$v['ware_code'],
                    'poscode'=>$v['pos_code'],
                    'supcode'=>$v['sup_code'],
                    'goodscode'=>$v['goods_code'],
                    'batchNo'=>$v['batch_no'],
                    'qtyNum'=>$v['qty'],
                    'splitRate'=>intval($v['is_solit'])==1?$v['solit_value']:1
                ]);
                if(!$resultSet) throw new \Exception("还原失败：库存操作异常");
                $res=Db::query('select @status as status');
                if(empty($res[0]) || !$res[0]['status']) throw new \Exception("还原失败：库存操作异常");
                $succ++;
            }
            //删除出入库记录
            $res1=Db::name('stock_goodsinout')->where(['reforderid'=>$data['orderid']])->delete();
            //处理订单信息
            $orderdata['is_transfer']=0;
            $orderdata['mender']=$user;
            $orderdata['update_date']=date('Y-m-d H:i:s',time());
            $res2=Db::name('stock_out')->where(['orderid'=>$data['orderid']])->update($orderdata);
            if($res1 && $res2 && $succ==count($list)){
                Db::commit();
                $result=['status'=>1,'msg'=>'还原操作已成功'];
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            Db::rollback();
            $result['msg']=$e->getMessage();
        }
        _end:
        return $result;
    }
}