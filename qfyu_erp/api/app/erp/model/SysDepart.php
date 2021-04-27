<?php

namespace app\erp\model;
use think\Model;

class SysDepart extends Model
{
  public static function getDepart()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
