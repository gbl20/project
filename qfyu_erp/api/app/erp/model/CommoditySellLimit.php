<?php

namespace app\erp\model;
use app\helper\CommonFun;
use think\Model;

class CommoditySellLimit extends Model
{
  public static function list($code)
  {
    $res = self::where('goods_code',$code)->alias('s')
      ->field('s.*,c.sname,c.name as cust_name,c.comarea,c.typebus')
      ->join('customer c','c.id=s.cust_id','left')
      ->select()
      ->toArray();
    return  $res;
  }

  public static function add($data)
  {
    $result = ['status'=>0,'msg'=>'新增失败！'];
    $text = '/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/';
    $dtl = array();
    foreach ($data as $k=>$v){
      if($v['limit_price']){
        if(!preg_match($text,$v['limit_price'])){
          $res['msg'] = $data[$k]['goods_code'].'最低限价格式不正确！，请重新输入。';goto _end;
        }
      }
      $sql['goods_code']  = $v['goods_code'];
      $sql['cust_id']     = $v['cust_id'];
      $sql['limit_price'] = $v['limit_price'];
      array_push($dtl,$sql);
    }
    $res = self::insertAll($dtl);
    if($res) $result = ['status'=>1,'msg'=>'Success'];
    _end:
    return $result;
  }

  public static function edit($data)
  {
    $result = ['status'=>0,'msg'=>'修改失败！'];
    $data = CommonFun::ProcessingData($data);
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['cust_id','=',$data['cust_id']];
    $text = '/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/';
    if (!preg_match($text,$data['limit_price'])){
      $result['msg'] = '最低限定价格格式有误！请重新输入。';goto _end;
    }
    $res = self::where($where)->update(['limit_price'=>$data['limit_price']]);
    if($res) $result = ['status'=>1,'msg'=>'修改成功！'];
    _end:
    return $result;
  }

  public static function del($data)
  {
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['cust_id','=',$data['cust_id']];
    $res = self::where($where)->delete();
    if ($res) $result = ['status'=>1,'msg'=>'删除成功！'];
    return $result;
  }
}
