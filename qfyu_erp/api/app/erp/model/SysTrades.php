<?php

namespace app\erp\model;
use think\Model;

class SysTrades extends Model
{
  public static function getTrades()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
