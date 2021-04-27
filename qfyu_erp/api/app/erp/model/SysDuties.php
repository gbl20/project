<?php

namespace app\erp\model;
use think\Model;

class SysDuties extends Model
{
  public static function getDuties()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
