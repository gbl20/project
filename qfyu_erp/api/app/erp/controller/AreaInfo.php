<?php

namespace app\erp\controller;
use app\BaseController;
use app\erp\model\AreaMgt;

class AreaInfo extends BaseController
{
  public function getAreaList()
  {
    $search = $this->request->data;
    $data = AreaMgt::getChlidArea($search['id']);
    $res  = AreaMgt::getAreaTree();
    exit(json_encode(['status'=>1,'item'=>$res,'data'=>$data]));
  }
  //新增/编辑地区
  public function editArea()
  {
    $search = $this->request->data;
    $res = AreaMgt::edit($search['data']);
    exit(json_encode($res));
  }
}
