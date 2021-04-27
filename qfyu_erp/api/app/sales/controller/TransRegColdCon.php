<?php
namespace app\sales\controller;
use app\BaseController;
use app\erp\model\DbWork;
use app\sales\model\TransRegCold;

Class TransRegColdCon extends BaseController{
    public function chooseColdTransItem(){
        $data = TransRegCold::queryList($this->request->data);
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    public function transRegColdList(){
        return TransRegCold::transRegColdList($this->request->data);
    }
    public function comTransRegCold(){
        return TransRegCold::comTransRegCold($this->request->data,$this->request->code);
    }
    public function transRegColdInit(){
        $inData = $this->request->data;
        $driverData = DbWork::queryList('driver');
        $CarMeterNoData = DbWork::queryList('car_meter_no');
        $data = null;
        if($inData['quotation_orderid']){
            $data = TransRegCold::queryOne($inData['quotation_orderid']);
        }
        return ['status'=>1,'driver_data'=>$driverData,'car_meter_no'=>$CarMeterNoData,'data'=>$data];
    }
}