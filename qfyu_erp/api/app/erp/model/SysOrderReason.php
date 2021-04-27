<?php

namespace app\erp\model;
use think\Model;

class SysOrderReason extends Model
{
  public static function getOrderReasson()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
