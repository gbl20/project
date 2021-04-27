<?php
namespace app\sales\model;
use app\erp\model\DbWork;
use app\erp\model\Employee;
use app\helper\CommonFun;
use app\sales\validate\TransRegVal;
use think\facade\Db;
use think\Model;

Class TransReg extends Model{
    /**
     * 查询单条数据
     * @param $orderId
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function queryOne($orderId){
        $data = null;
        $transReg = TransReg::where('orderid',$orderId)->find();
        if($transReg){
            $transReg = $transReg->toArray();
            $data['data'] = $transReg;
            $data['details'] = TransRegDtl::alias('t')
                ->join('customer c','c.id = t.cust_no', 'LEFT')
                ->field('t.*,c.name as cust_name,c.deliorder,c.area')
                ->where('t.orderid',$orderId)
                ->select()->toArray();
        }
        return $data;
    }
    /**
     * 查询列表
     * @param $inData
     * @param $uCode
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function transRegList($inData,$uCode){
        $data = TransReg::select();
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    /**
     * 保存
     * @param $inData
     * @param $uCode
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function comTransReg($inData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $data = CommonFun::ProcessingData($inData['fdata'],['logistics_id']);
        $validate = new TransRegVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();
            goto _end;
        }
        $details = $inData['data'];
        $date = date('Y-m-d',time());
        $dateTime = date('Y-m-d H:i:s',time());
        $orderid = $data['orderid'];
        if(!$orderid) $orderid = CommonFun::createOrder('TR');
        $reDataDtl = [];
        $i = 1;
        $Amount = 0;
        $zPackNum = 0;
        foreach($details as $v){
            $v = CommonFun::ProcessingData($v,[],['pack_num,send_temperature']);
            $reDtl = [];
            $reDtl['item_no'] = $i++;
            $reDtl['orderid'] = $orderid;
            $reDtl['order_no'] = $v['order_no'];
            $reDtl['remark'] = $v['remark'];
            $reDtl['pack_num'] = $v['pack_num'];
            $reDtl['shipper'] = $v['shipper'];
            $reDtl['send_date'] = $v['send_date'];
            $reDtl['send_temperature'] = $v['send_temperature'];
            $reDtl['cold_storage_measures'] = $v['cold_storage_measures'];
            $reDtl['remark'] = $v['remark'];
            unset($where);
            $where[] = ['orderid','=',$v['order_no']];
            $where[] = ['need_deliver','=',1];//需要送货的订单
            $selExPort = SelExport::where($where)->field('amount,cust_no,link_man,pick_addr,is_cold_storage,contacts,deliver_line,link_tel')->find();
            if(!$selExPort){
                $res['msg'] = '项次'+$reDtl['item_no']+'订单信息选择有误!';
                goto _end;
            }
            $reDtl['link_tel'] = $selExPort['link_tel'];
            $reDtl['deliver_line'] = $selExPort['deliver_line'];
            $reDtl['cust_no'] = $selExPort['cust_no'];
            $reDtl['link_man'] = $selExPort['link_man'];
            $reDtl['addr'] = $selExPort['pick_addr'];
            $reDtl['amount'] = $selExPort['amount'];
            $reDtl['is_cold_storage'] = $selExPort['is_cold_storage'];
            $reDtl['sales_man'] = $selExPort['contacts'];
            $reDataDtl[] = $reDtl;
            $Amount = calc([$selExPort['amount'],'+',$Amount],6);
            $zPackNum = calc([$selExPort['pack_num'],'+',$zPackNum],5);
        }
        Db::startTrans();
        if(empty($data['emp_no'])) $reData['emp_no'] = $uCode;
        else $reData['emp_no'] = $data['emp_no'];
        $reData['orderid'] = $orderid;
        $reData['f_date'] = $date;
        $reData['in_out_kind'] = 51;
        $reData['amount'] = $Amount;
        $reData['pack_num'] = $zPackNum;
        $reData['ship_type'] = $data['ship_type'];
        $reData['remark'] = $data['remark'];
        $reData['driver'] = $data['driver'];
        if($reData['driver']) DbWork::editDbWork(['value'=>$reData['driver'],'label'=>$reData['driver']],'driver');
        $reData['car_num'] = $data['car_num'];
        if($reData['car_num']) DbWork::editDbWork(['value'=>$reData['car_num'],'label'=>$reData['car_num']],'car_num');
        $reData['delivery_boy'] = $data['delivery_boy'];
        $reData['shipper'] = $data['shipper'];
        $reData['logistics_id'] = $data['logistics_id'];
        $reData['logistics_unit'] = $data['logistics_unit'];
        $reData['deliver_kind'] = $data['deliver_kind'];
        $reData['wl_num'] = $data['wl_num'];
        if($data['orderid']){
            $reData['mender'] = $uCode;
            $reData['update_date'] = $dateTime;
            $where = [];
            $where[] = ['is_transfer','=',0];
            $where[] = ['orderid','=',$data['orderid']];
            $re1 = TransReg::where($where)->update($reData);
            $re2 = TransRegDtl::where('orderid','=',$data['orderid'])->deleteInsertAll($reDataDtl);
        }else{
            $reData['orderid'] = $orderid;
            $reData['f_date'] = $date;
            $depart_id = Employee::where(['code'=>$uCode])->value('depart_id');
            $reData['dept_id'] = $depart_id;
            $reData['creater'] = $uCode;
            $reData['create_date'] = $dateTime;
            $re1 = TransReg::insert($reData);
            $re2 = TransRegDtl::insertAll($reDataDtl);
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