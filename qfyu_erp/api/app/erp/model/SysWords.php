<?php

namespace app\erp\model;
use think\Model;

class SysWords extends Model
{
  public static function getWords()
  {
    $res = self::field('value,remark')->select()->toArray();
    return $res;
  }
}
