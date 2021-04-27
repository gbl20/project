<?php

namespace app\erp\model;
use think\Model;

class SysDosage extends Model
{
  public static function getDosage()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
