<?php
namespace app\sales\controller;
use app\BaseController;
use app\sales\model\SelOrder;

Class SelOrderCon extends  BaseController{
    public function selOrderList(){
        $data = SelOrder::queryList($this->request->data);
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    public function editSelOrderInit(){
        $data = SelOrder::queryOne($this->request->data);
        return ['status'=>1,'data'=>$data];
    }
    public function comSelOrder(){
        return SelOrder::addData($this->request->data,$this->request->code);
    }
    public function auditSelOrder(){
        return SelOrder::auditSelOrder($this->request->data,$this->request->code);
    }
    public function reductionSelOrder(){
        return SelOrder::reductionSelOrder($this->request->data,$this->request->code);
    }
    public function transferSelOrder(){
        return SelOrder::transferSelOrder($this->request->data,$this->request->code);
    }
    public function chooseBatchNo(){
        $res = SelOrder::chooseBatchNo($this->request->data);
        return $res;
    }
}