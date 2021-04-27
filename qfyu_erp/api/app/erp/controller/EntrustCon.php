<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\EntrustLogistics;

Class EntrustCon extends BaseController{
    public function comEntrust(){
        return EntrustLogistics::addData($this->request->data,$this->request->code);
    }
    public function entrustList(){
        return EntrustLogistics::entrustList();
    }
    public function chooseTrust(){
        return EntrustLogistics::entrustList();
    }
}
