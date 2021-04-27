<?php
namespace app\sales\controller;
use app\BaseController;
use app\sales\model\SelColdStorage;

class SelColdStorageCon extends BaseController
{
  //冷藏药品销退收货登记-列表
  public function getSelColdStorageList()
  {
    $res = SelColdStorage::list($this->request->data);
    exit(json_encode($res));
  }
  //冷藏药品销退收货登记-获取明细
  public function getSelColdStorageDtl()
  {
    $search = $this->request->data;
    $res = SelColdStorage::dtl($search['orderid']);
    exit(json_encode($res));
  }
  //冷藏药品销退收货登记-保存
  public function saveSelColdStorage()
  {
    $res = SelColdStorage::saveData($this->request->data,$this->request->code);
    exit(json_encode($res));
  }
  //冷藏药品销退收货登记-删除
  public function delSelColdStorage()
  {
    $res = SelColdStorage::del($this->request->data);
    exit(json_encode($res));
  }
  //冷藏药品销退收货登记-审核
  public function checkSelColdStorage()
  {
    $res = SelColdStorage::check($this->request->data,$this->request->code);
    exit(json_encode($res));
  }
  //冷藏药品销退收货登记-还原
  public function backSelColdStorage()
  {
    $res = SelColdStorage::backData($this->request->data,$this->request->code);
    exit(json_encode($res));
  }

}
