<?php

namespace app\erp\model;

use app\helper\CommonFun;
use think\Model;

class GoodsCheckDefault extends Model
{
  public static function getGoodsCheckDefault()
  {
    $where = [];
    $item = [];
    $res = GoodsCheckDefault::where($where)->select()->toArray();
    if ($res) {
      foreach ($res as $k => $v) {
        $item[$v['gsp_type']] = $v;
      }
    }
    return ['data' => $item, 'status' => 1];
  }

  public static function editGoodsCheckDefault($data)
  {
    $result = ['status' => 0, 'msg' => '修改失败!'];
    $data = CommonFun::ProcessingData($data);
    $has = GoodsCheckDefault::where('gsp_type', $data['gsp_type'])->field('gsp_type')->find();
    if (!$has) {
      $result['msg'] = '该设置不存在！请重新再试。';
      goto _end;
    }
    $data['update_date'] = date("Y-m-d H:i:s");
    $res = GoodsCheckDefault::where('gsp_type', $data['gsp_type'])->update($data);
    if ($res) $result = ['status' => 1, 'msg' => '修改成功！'];
    _end:
    return $result;
  }
}
