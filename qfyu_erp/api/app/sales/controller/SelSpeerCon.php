<?php
namespace app\sales\controller;
use app\BaseController;
use app\sales\model\SelSpeer;

Class SelSpeerCon extends BaseController{
    public function QuotationList(){
        $data = SelSpeer::queryList($this->request->data);
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    public function editSalesInit(){
        $data = SelSpeer::queryOne($this->request->data);
        return ['status'=>1,'data'=>$data];
    }
    public function comSalesQuotation(){
        return SelSpeer::addData($this->request->data,$this->request->code);
    }
    public function auditSalesOrder(){
        return SelSpeer::auditSalesOrder($this->request->data,$this->request->code);
    }
    public function reductionOrder(){
        return SelSpeer::reductionOrder($this->request->data,$this->request->code);
    }
    public function transferOrder(){
        return SelSpeer::transferOrder($this->request->data,$this->request->code);
    }
}
