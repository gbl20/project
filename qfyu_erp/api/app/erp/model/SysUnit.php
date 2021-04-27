<?php

namespace app\erp\model;
use think\Model;

class SysUnit extends Model
{
  public static function getUnit()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
