<?php

namespace app\erp\model;

use app\helper\CommonFun;
use app\erp\validate\PriceSystem;
use think\facade\Db;
use think\Model;

class CommodityPriceSystem extends Model
{
  public static function price_system($pricepower = '')
  {
    $result = array();
    $where[] = ['p.id', 'in', $pricepower];
    $res = CommodityPriceSystem::where($where)->alias('p')->field('p.*,d.dept_name')
      ->join('depart d', 'd.id=p.depart', 'left')
      ->order('p.id', 'asc')
      ->select()->toArray();
    $result = ['status' => 1, 'msg' => 'success', 'data' => $res];
    return $result;
  }

  /**
   * 新增-修改价格体系方案
   * $data 前端传回来需要新增或者修改的数据
   * $id string 0新增 1修改
   **/
  public static function update_system($search, $user, $depart)
  {
    $result = ['status' => 0, 'msg' => '新增失败'];
    $data = CommonFun::ProcessingData($search['data']);
    $validate = new PriceSystem();
    $checker = $validate->scene('all')->check($data);
    if (!$checker) {
      $result['msg'] = $validate->getError();
      goto _end;
    }
    $where[] = ['id', '=', $data['id']];
    $where[] = ['name', '=', $data['name']];
    $has = CommodityPriceSystem::where($where)->find();
    //判断新增还是修改
    if(!$has){
      $data['creator'] = $user;
      $data['creation_date'] = date('Y-m-d H:i:s');
      $data['depart'] = $depart;
      $res = Db::name('commodity_price_system')->insert($data);
      if ($res) $result = ['status' => 1, 'msg' => '新增成功！'];
    }else{
      unset($data['name']);
      $data['reviser'] = $user;
      $data['reviser_date'] = date('Y-m-d H:i:s');
      $res = Db::name('commodity_price_system')->where('id',$data['id'])->update($data);
      if ($res) $result = ['status' => 1, 'msg' => '修改成功！'];
      else $result['msg'] = '修改失败！';
    }
    _end:
    return $result;
  }

  /**
   *  删除价格体系方案
   *  删除条件
   *  1 判断是否为系统默认体系方案不能被删除
   *  2 判断当前操作用户是否有权限
   **/
  public static function del_system($data)
  {
    $result = ['status' => 0, 'msg' => '删除失败'];
    $has_adm = Db::name('commodity_price_system')->where('id', $data)->field('creator,depart')->find();
    if ($has_adm['creator'] == 0 || $has_adm['depart']==0) {
      $result['msg'] = '该体系是系统方案，不能删除！';
      goto _end;
    }
    $res = Db::name('commodity_price_system')->where('id', $data)->delete();
    if($res) $result = ['status' => 1, 'msg' => '删除成功！'];
    _end:
    return $result;
  }
}
