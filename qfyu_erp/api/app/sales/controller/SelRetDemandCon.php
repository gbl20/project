<?php

namespace app\sales\controller;
use app\BaseController;
use app\helper\CommonFun;
use app\sales\model\SelRetDemand;

class SelRetDemandCon extends BaseController
{
  //获取销售退回列表
  public function getSelRetDemandList()
  {
    $res = SelRetDemand::list(CommonFun::ProcessingData($this->request->data));
    exit(json_encode($res));
  }

  //获取销售退回明细
  public function getSelRetDemandDtl()
  {
    $res = SelRetDemand::dtl($this->request->data);
    exit(json_encode($res));
  }

  //保存销售退回申请单
  public function saveSelRetDemand()
  {
    $res = SelRetDemand::saveDemand($this->request->data,$this->request->depart,$this->request->code);
    exit(json_encode($res));
  }

  //审核销售退回申请单
  public function checkSelRetDemand()
  {
    $res = SelRetDemand::check($this->request->data,$this->request->depart,$this->request->code);
    exit(json_encode($res));
  }

  //还原销售退回申请单
  public function backSelRetDemand()
  {
    $res = SelRetDemand::backData($this->request->data,$this->request->code);
    exit(json_encode($res));
  }

  //删除销售退回申请单
  public function delSelRetDemand()
  {
    $res = SelRetDemand::delDate($this->request->data);
    exit(json_encode($res));
  }

}
