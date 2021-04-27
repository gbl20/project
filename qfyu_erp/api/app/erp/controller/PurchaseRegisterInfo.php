<?php

namespace app\erp\controller;
use app\BaseController;
use app\erp\model\PurchaseRegister;
use app\erp\model\PurchaseRegisterBill;
use app\erp\model\Settlement;

class PurchaseRegisterInfo extends BaseController
{
    public function registerList()
    {
        $search = $this->request->data;
        $res = PurchaseRegister::list($search);
        exit(json_encode($res));
    }

    public function registerDel()
    {
        $search = $this->request->data;
        if(!empty($search['orderid'])) $res = PurchaseRegister::details($search['orderid']);
        $res['status'] = 1;
        exit(json_encode($res));
    }
    /**
     * 新增-编辑来货登记
     */
    public function addRegister()
    {
        $data = $this->request->data;
        $res = PurchaseRegister::edit($data['formData'],json_decode($data['data'],true),$this->request->code);
        exit(json_encode($res));
    }
    /**
     * 发票详情
    **/
    public function getBillDetail()
    {
        $data = $this->request->data;
        $res = PurchaseRegisterBill::getBillDet($data['orderid']);
        exit(json_encode($res));
    }
    public function editBill()
    {
        $data = $this->request->data;
        $res = PurchaseRegisterBill::editBill($data['data']);
        exit(json_encode($res));
    }
    /*审核来货登记单*/
    public function checkRegister()
    {
        $data = $this->request->data;
        $res = PurchaseRegister::checkOrder($data,$this->request->code,$this->request->depart);
        exit(json_encode($res));
    }
}
