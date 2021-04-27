<?php

namespace app\erp\controller;

use app\BaseController;
use app\erp\model\SysCategory;
use app\erp\model\SysDosage;
use app\erp\model\SysDuties;
use app\erp\model\SysIllness;
use app\erp\model\SysOrderReason;
use app\erp\model\SysSalesCategory;
use app\erp\model\SysTrades;
use app\erp\model\SysUnit;
use app\erp\model\SysDepart;
use app\erp\model\SysWords;

class ConfigSet extends BaseController
{
  public function getReferenceDataInit()
  {
    $data = $this->request->data;
    $type = $data['name'];
    $category = SysCategory::getCategory();
    $unit = SysUnit::getUnit();
    $dosage = SysDosage::getDosage();
    $depart = SysDepart::getDepart();
    $duties = SysDuties::getDuties();
    $trades = SysTrades::getTrades();
    $words  = SysWords::getWords();
    $illness= SysIllness::getIllness();
    $order  = SysOrderReason::getOrderReasson();
    $salesCategory = SysSalesCategory::getCategory();
    $result = [$category,$unit,$dosage,$depart,$duties,$trades,$words,$illness,$order,$salesCategory];
    exit(json_encode(['status'=>1,'data'=>$result]));
  }
}
