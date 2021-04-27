<?php

namespace app\erp\model;
use app\erp\validate\CommoditySaleCategoryVal;
use app\helper\CommonFun;
use think\Model;

class CommoditySalesCategory extends Model
{
  public static function list($code){
    $res = CommoditySalesCategory::where('goods_code',$code)->select()->toArray();
    return ['status'=>1,'data'=>$res];
  }

  public static function edit($data)
  {
    $result = ['status' => 0, 'msg' => '新增失败'];
    $data = CommonFun::ProcessingData($data);
    $validate = new CommoditySaleCategoryVal();
    $checker = $validate->scene('all')->check($data);
    if (!$checker){
      $result['msg'] = $validate->getError();goto _end;
    }
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['name','=',$data['name']];
    $has = CommoditySalesCategory::where($where)->find();
    if(!$has){
      $res = CommoditySalesCategory::insert($data);
      if ($res) $result = ['status'=>1,'msg'=>'新增成功'];
    }else{
      $data['update_date'] = date('Y-m-d H:i:s');
      $res = CommoditySalesCategory::where($where)->update($data);
      if ($res) $result = ['status'=>1,'msg'=>'修改成功'];
      else $result['msg'] = '修改失败';
    }
    _end:
    return $result;
  }
  public static function del($data)
  {
    $result = ['status'=>0,'msg'=>'删除失败'];
    $where[]= ['goods_code','=',$data['goods_code']];
    $where[]= ['name','=',$data['name']];
    $res = CommoditySalesCategory::where($where)->delete();
    if ($res) $result = ['status'=>1,'msg'=>'删除成功'];
    return $result;
  }
}
