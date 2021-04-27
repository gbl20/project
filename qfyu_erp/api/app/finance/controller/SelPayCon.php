<?php

namespace app\finance\controller;
use app\BaseController;
use app\finance\model\SelPay;
use app\helper\CommonFun;

class SelPayCon extends BaseController
{
  //获取销售收款列表
  public function getSelPayList()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelPay::List($data);
    exit(json_encode($res));
  }

  //获取明细
  public function getSelPayDtl()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelPay::dtl($data['orderid']);
    exit(json_encode($res));
  }

  //保存/修改
  public function editSelPayDtl()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelPay::edit($data['formData'],$data['data'],$this->request->code);
    exit(json_encode($res));
  }

  //删除
  public function delSelPay()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelPay::del($data['orderid']);
    exit(json_encode($res));
  }

  //审核
  public function checkSelPay()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelPay::check($data['orderid'],1,$this->request->code);
    exit(json_encode($res));
  }

  //还原
  public function backSelPay()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelPay::check($data['orderid'],0,$this->request->code);
    exit(json_encode($res));
  }

}
