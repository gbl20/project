<?php

namespace app\erp\model;
use think\Model;

class SysSalesCategory extends Model
{
  public static function getCategory()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
