<?php
namespace app\sales\model;
use app\erp\model\DbWork;
use app\erp\model\Employee;
use app\helper\CommonFun;
use app\sales\validate\TransRegColdVal;
use think\facade\Db;
use think\Model;

Class TransRegCold extends Model{
    public static function queryOne($orderId){
        $data = null;
        $transReg = TransRegCold::where('orderid',$orderId)->find();
        if($transReg){
            $transReg = $transReg->toArray();
            $data['data'] = $transReg;
            $data['details'] = TransRegColdDtl::alias('t')
                ->join('customer u','u.id = t.cust_no', 'LEFT')
                ->join('commodity c','c.goods_code = t.goods_code','left')
                ->field('t.*,u.name as cust_name,u.deliorder,u.area,c.specs,c.approval_code,c.origin,c.production,c.goods_name')
                ->where('t.orderid',$orderId)
                ->select()->toArray();
        }
        return $data;
    }
    public static function transRegColdList($inData){
        $data = TransRegCold::select();
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    public static function queryList($inData){
        $where[] = ['d.is_cold_storage','=',1];
        $field = 'd.id,s.cust_no,s.deliver_line,s.pick_addr,s.link_tel,s.contacts,s.pay_mode_no,s.orderid as order_no,d.item_no as order_item_no,d.goods_code,d.qty,d.batch_no,d.valid_date,c.goods_name,s.link_man,c.specs,c.approval_code,c.origin,c.production,s.cust_no,u.name as cust_name,u.man as cust_receiver,u.mannumber as cust_receiver_tel';
        $data = Db::name('sel_export_dtl')->alias('d')
            ->join('sel_export s','s.orderid = d.orderid','left')
            ->join('commodity c','c.goods_code = d.goods_code','left')
            ->join('customer u','u.id = s.cust_no','left')
            ->where($where)->field($field)->select()->toArray();
        return $data;
    }
    public static function comTransRegCold($inData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $data = CommonFun::ProcessingData($inData['fdata']);
        $validate = new TransRegColdVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();
            goto _end;
        }
        $reData = [];
        $date = date('Y-m-d',time());
        $dateTime = date('Y-m-d H:i:s',time());
        $orderid = $data['orderid'];
        if(!$orderid) $orderid = CommonFun::createOrder('TC');
        $reData['ship_type'] = $data['ship_type'];
        $reData['ship_tool'] = $data['ship_tool'];
        $reData['driver'] = $data['driver'];
        if($reData['driver']) DbWork::editDbWork(['value'=>$reData['driver'],'label'=>$reData['driver']],'driver');
        $reData['car_meter_no'] = $data['car_meter_no'];
        if($reData['car_meter_no']) DbWork::editDbWork(['value'=>$reData['car_meter_no'],'label'=>$reData['car_meter_no']],'car_meter_no');
        $reData['precooling_time'] = $data['precooling_time'];
        $reData['shipper'] = $data['shipper'];
        $reData['delivery_boy'] = $data['delivery_boy'];
        $reData['emp_no'] = $data['emp_no'];
        $reData['delivery_no'] = $data['delivery_no'];
        $reData['remark'] = $data['remark'];
        $reData['in_out_kind'] = 51;
        $reData['is_transfer'] = 0;
        $details = $inData['data'];
        $reDataDtl = [];
        $i = 1;
        foreach($details as $k=>$v){
            $v = CommonFun::ProcessingData($v);
            $dtl = [];
            $dtl['orderid'] = $orderid;
            $dtl['item_no'] = $i++;
            unset($where);
            $orderNo = $v['order_no'];
            $where[] = ['d.orderid','=',$orderNo];
            $where[] = ['d.item_no','=',$v['order_item_no']];
            $where[] = ['d.is_cold_storage','=',1];
            $field = 'd.id,s.cust_no,s.deliver_line,s.emp_no,s.pick_addr,s.link_tel,s.contacts,s.pay_mode_no,s.orderid,d.item_no,d.goods_code,d.qty,d.batch_no,d.valid_date,s.link_man,s.cust_no,u.name as cust_name,u.man as cust_receiver,u.mannumber as cust_receiver_tel';
            $orderDtl = Db::name('sel_export_dtl')->alias('d')
                ->join('sel_export s','s.orderid = d.orderid','left')
                ->join('customer u','u.id = s.cust_no','left')
                ->where($where)->field($field)->find();
            if(!$orderDtl){
                $res['msg'] = '项次'.$dtl['item_no'] .'订单产品信息选择有误！';
                goto _end;
            }
            $dtl['cust_no'] = $orderDtl['cust_no'];
            $dtl['pick_addr'] = $orderDtl['pick_addr'];
            $dtl['deliver_line'] = $orderDtl['deliver_line'];
            $dtl['link_tel'] = $orderDtl['link_tel'];
            $dtl['link_man'] = $orderDtl['link_man'];
            $dtl['contacts'] = $orderDtl['contacts'];
            $dtl['send_date'] = isset($v['send_date'])?$v['send_date']:null;
            $dtl['emp_no'] = $orderDtl['emp_no'];
            $dtl['pay_mode_no'] = $orderDtl['pay_mode_no'];
            $dtl['order_no'] = $orderNo;
            $dtl['order_item_no'] = $orderDtl['item_no'];
            $dtl['goods_code'] = $orderDtl['goods_code'];
            $dtl['qty'] = $orderDtl['qty'];
            $dtl['batch_no'] = $orderDtl['batch_no'];
            $dtl['valid_date'] = $orderDtl['valid_date'];
            $dtl['send_temperature'] = isset($v['send_temperature'])?$v['send_temperature']:null;
            $dtl['arrival_date'] = isset($v['arrival_date'])?$v['arrival_date']:null;
            $dtl['arrival_temperature'] = isset($v['arrival_temperature'])?$v['arrival_temperature']:null;
            $dtl['temperature_filename'] = isset($v['temperature_filename'])?$v['temperature_filename']:null;
            $dtl['the_way_time'] = isset($v['the_way_time'])?$v['the_way_time']:null;
            $dtl['cust_receiver'] = empty($v['cust_receiver'])?$orderDtl['cust_receiver']:$v['cust_receiver'];
            $dtl['cust_receiver_tel'] = empty($v['cust_receiver_tel'])?$orderDtl['cust_receiver_tel']:$v['cust_receiver_tel'];
            $reDataDtl[] = $dtl;
        }
        if($data['orderid']){
            $reData['mender'] = $uCode;
            $reData['update_date'] = $dateTime;
            $where = [];
            $where[] = ['is_transfer','=',0];
            $where[] = ['orderid','=',$data['orderid']];
            $re1 = TransRegCold::where($where)->update($reData);
            $re2 = TransRegColdDtl::where('orderid','=',$data['orderid'])->deleteInsertAll($reDataDtl);
        }else{
            $reData['orderid'] = $orderid;
            $reData['f_date'] = $date;
            $depart_id = Employee::where(['code'=>$uCode])->value('depart_id');
            $reData['dept_id'] = $depart_id;
            $reData['creater'] = $uCode;
            $reData['create_date'] = $dateTime;
            $re1 = TransRegCold::insert($reData);
            $re2 = TransRegColdDtl::insertAll($reDataDtl);
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
}