<?php
namespace app\finance\controller;
use app\BaseController;
use app\finance\model\SelSettle;
use app\helper\CommonFun;

Class SelSettleCon extends BaseController{

  public function getSelSettleList()
  {
    $search = CommonFun::ProcessingData($this->request->data);
    $res = SelSettle::list($search);
    exit(json_encode($res));
  }

  public function getSelSettleDtl()
  {
    $data = $this->request->data;
    $res  = SelSettle::dtl($data['orderid']);
    exit(json_encode($res));
  }

  public function saveSelSettleInfo()
  {
    $res = SelSettle::saveSelData($this->request->data,$this->request->code);
    exit(json_encode($res));
  }

  public function checkSelSettle()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelSettle::check($data['orderid'],$this->request->code);
    exit(json_encode($res));
  }

  public function reductionSelSettle()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelSettle::reduction($data['orderid'],$this->request->code);
    exit(json_encode($res));
  }

  //删除销售结算
  public function delSelSettle()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelSettle::del($data['orderid']);
    exit(json_encode($res));
  }

  //收款
  public function makeSelPay()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelSettle::makeSelPayDtl($data['orderid'],$this->request->code,$this->request->depart);
    exit(json_encode($res));
  }


}
