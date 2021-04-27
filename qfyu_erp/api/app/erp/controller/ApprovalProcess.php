<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\ApprovalProMod;

Class ApprovalProcess extends BaseController{
    public function exam(){
        $res = ApprovalProMod::adm_check_first_goods($this->request->data,$this->request->code);
        return $res;
    }
}
