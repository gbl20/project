<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\GoodsCheckAccept;
use app\erp\model\GoodsCheckDefault;
use app\helper\CommonFun;

class QualityAcceptance extends BaseController
{
  //获取质量验收默认设置
  public function checkDefault()
  {
    $res = GoodsCheckDefault::getGoodsCheckDefault();
    exit(json_encode($res));
  }
  //修改质量验收默认设置
  public function editcheckDefault()
  {
    $data = $this->request->data;
    $res = GoodsCheckDefault::editGoodsCheckDefault($data['data']);
    exit(json_encode($res));
  }

  //质量验收列表
  public function getQualityAllList()
  {
    $res = GoodsCheckAccept::goodsAllCheckList(CommonFun::ProcessingData($this->request->data));
    exit(json_encode($res));
  }

  //获取质量验收明细
  public function getGoodsCheckAcceptDtl()
  {
    $data = $this->request->data;
    $res = GoodsCheckAccept::getDetails($data);
    exit(json_encode($res));
  }

  //保存质量验收
  public function editGoodsCheckAccept()
  {
      $data = $this->request->data;
      $res = GoodsCheckAccept::edit($data,$this->request->code);
      exit(json_encode($res));
  }

  //审核质量验收单
  public function checkQuality()
  {
    $data = $this->request->data;
    $res = GoodsCheckAccept::check($data, $this->request->code, $this->request->depart);
    exit(json_encode($res));
  }

  //删除质量验收单
  public function delGoodsCheckAccept()
  {
    $res = GoodsCheckAccept::del($this->request->data);
    exit(json_encode($res));
  }

  //还原质量验收单
  public function backGoodsCheckAccept()
  {
    $res = GoodsCheckAccept::reduction($this->request->data,$this->request->code);
    exit(json_encode($res));
  }
}
