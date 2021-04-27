<?php

namespace app\erp\model;
use app\helper\CommonFun;
use think\Model;

class CommoditySalesArea extends Model
{
  //获取商品控销区域
  public static function list($code)
  {
    $res = self::where('goods_code', $code)->alias('g')
          ->field('g.*,a.area_name')
          ->join('area_mgt a','a.id=g.area_id','left')
          ->select()
          ->toArray();
    return ['status' => 1, 'data' => $res];
  }

  //新增、编辑商品控销区域
  public static function edit($data)
  {
    $result = ['status'=>0,'msg'=>'新增失败！'];
    $data = CommonFun::ProcessingData($data['data']);
    unset($data['area_name']);
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['area_id','=',$data['area_id']];
    $has = CommoditySalesArea::where($where)->find();
    if($has){
      $res = CommoditySalesArea::where($where)->update($data);
      if ($res) $result = ['status'=>1,'msg'=>'修改成功！'];
      else $result['msg'] = '修改失败！';
    }else{
      $res = CommoditySalesArea::insert($data);
      if ($res) $result = ['status'=>1,'msg'=>'新增成功！'];
    }
    return $result;
  }

}
