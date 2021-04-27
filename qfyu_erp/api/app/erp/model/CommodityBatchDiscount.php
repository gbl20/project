<?php

namespace app\erp\model;
use app\helper\CommonFun;
use think\Model;

class CommodityBatchDiscount extends Model
{
  public static function list($code)
  {
    $unitItem = array();
    $goods_name = Commodity::where('goods_code',$code)->value('goods_name');
    $unit = Commodity::where('goods_code',$code)->field('unit,unit2')->find();
    array_push($unitItem,$unit['unit']);
    if(!empty($unit['unit2'])) array_push($unitItem,$unit['unit2']);
    $res = self::where('goods_code',$code)->select()->toArray();
    return ['status'=>1,'data'=>$res,'goods_name'=>$goods_name,'unitItem'=>$unitItem];
  }
  public static function edit($data)
  {
    $result = ['status'=>0,'msg'=>'新增失败！'];
    $data = CommonFun::ProcessingData($data);
    if (!preg_match('/\d{0,4}\d$/',$data['min_qty'])){
      $result['msg'] = '最小批量格式有误！请重新输入。';goto _end;
    }
    if (!preg_match('/\d{0,5}/',$data['max_qty'])){
      $result['msg'] = '最大批量格式有误！请重新输入。';goto _end;
    }
    if (!preg_match('/\d{0,2}/',$data['discount'])){
      $result['msg'] = '折扣格式有误！请重新输入。';goto _end;
    }
    unset($data['goods_name']);
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['min_qty','=',$data['min_qty']];
    $where[] = ['max_qty','=',$data['max_qty']];
    $has = self::where($where)->find();
    if($has){
      $data['update_date'] = date("Y-m-d H:i:s");
      $res = self::where($where)->update($data);
      if ($res) $result = ['status'=>1,'msg'=>'更新成功！'];
      else $result['msg'] = '更新失败！';
    }else{
      $res = self::insert($data);
      if ($res) $result = ['status'=>1,'msg'=>'新增成功！'];
    }
    _end:
    return $result;
  }
  public static function del($data)
  {
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['min_qty','=',$data['min_qty']];
    $where[] = ['max_qty','=',$data['max_qty']];
    $res = self::where($where)->delete();
    if ($res) $result = ['status'=>1,'msg'=>'删除成功！'];
    return $result;
  }
}
