<?php
namespace app\sales\controller;
use app\BaseController;
use app\erp\model\Settlement;
use app\sales\model\SalesContract;

Class ContractCon extends BaseController{
    public function salesContractInit(){
        $settlement = Settlement::column('name','code');
        $data = SalesContract::queryList();
        $res = ['status'=>1,'data'=>$data,'settlement'=>$settlement];
        return $res;
    }
    public function comSalesContract(){
        return SalesContract::addData($this->request->data,$this->request->code);
    }
    public function selContract(){
        $settlement = Settlement::column('name','code');
        $inData = $this->request->data;
        $cust_code = $inData['cust_code'];
        $data = SalesContract::queryList($cust_code);
        $res = ['status'=>1,'data'=>$data,'settlement'=>$settlement];
        return $res;
    }
}
