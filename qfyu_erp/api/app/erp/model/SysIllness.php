<?php

namespace app\erp\model;
use think\Model;

class SysIllness extends Model
{
  public static function getIllness()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
