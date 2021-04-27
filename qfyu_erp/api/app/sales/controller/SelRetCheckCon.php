<?php

namespace app\sales\controller;
use app\BaseController;
use app\helper\CommonFun;
use app\sales\model\SelRetCheck;

class SelRetCheckCon extends BaseController
{
  public function getSelRetCheckList()
  {
    $res  = SelRetCheck::list(CommonFun::ProcessingData($this->request->data));
    exit(json_encode($res));
  }

  public function getSelRetCheckDtl()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelRetCheck::dtl($data['orderid']);
    exit(json_encode($res));
  }

  public function saveSelRetCheck()
  {
    $res = SelRetCheck::saveData(CommonFun::ProcessingData($this->request->data),$this->request->depart,$this->request->code);
    exit(json_encode($res));
  }

  public function delSelRetCheck()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelRetCheck::del($data['orderid']);
    exit(json_encode($res));
  }

  public function checkSelRetCheck()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelRetCheck::check($data['orderid'],$this->request->depart,$this->request->code);
    exit(json_encode($res));
  }

  public function backSelRetCheck()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = SelRetCheck::back($data['orderid'],$this->request->code);
    exit(json_encode($res));
  }

}
