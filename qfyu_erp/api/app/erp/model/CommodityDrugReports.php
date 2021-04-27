<?php

namespace app\erp\model;
use app\helper\CommonFun;
use think\Model;

class CommodityDrugReports extends Model
{
  public static function getDrugReports($data)
  {
    $result = ['status'=>0,'msg'=>'查询失败！'];
    $where[] = ['d.goods_code','=',$data['goods_code']];
    $where[] = ['d.batch','=',$data['batch']];
    $where[] = ['d.supplier_code','=',$data['supplier_code']];
    $res = self::where($where)->alias('d')->field('d.*,c.goods_name')
        ->join('commodity c','c.goods_code=d.goods_code','left')
        ->find();
    if($res){
      $res = $res->toArray();
      $result = ['status'=>1,'data'=>$res,'msg'=>'Success'];
    }else{
      $result['msg'] = '该批商品没有上传药检报告！';
    }
    return $result;
  }

  public static function addDrugReports($data)
  {
    $result = ['status'=>0,'msg'=>'新增失败！'];
    if(empty($data['goods_code'])){
      $result['msg']='商品编号不能为空！';goto _end;
    }
    if(empty($data['supplier_code'])){
      $result['msg']='供应商编号不能为空！';goto _end;
    }
    if(empty($data['file_path'])){
      $result['msg']='请上传商品药检报告！';goto _end;
    }
    $newFileName = $data['goods_code'].'_'.$data['batch'].'_'.$data['supplier_code'].'_'.$data['ABType'];
    $moveFileStatus = CommonFun::moveFile($data['file_path'],'/uploads/drug_img/',$newFileName);
    if(!$moveFileStatus['status']){
      $res['msg'] = $moveFileStatus['msg'];goto _end;
    }
    $name = $data['ABType']=="A"?'file_a':'file_b';
    $data[$name] = $moveFileStatus['pic_url'];
    $sql['goods_code'] = $data['goods_code'];
    $sql['batch'] = $data['batch'];
    $sql['supplier_code'] = $data['supplier_code'];
    $sql[$name] = substr($data[$name],18);
    $where[] = ['goods_code','=',$data['goods_code']];
    $where[] = ['batch','=',$data['batch']];
    $where[] = ['supplier_code','=',$data['supplier_code']];
    $has = self::where($where)->find();
    if($has){
      $sql['update_date'] = date("Y-m-d H:i:s");
        $res = self::where($where)->update($sql);
        if ($res) $result = ['status'=>1,'msg'=>'修改成功！'];
        else $result['msg'] = '修改失败';
    }else{
        $res = self::insert($sql);
        if ($res) $result = ['status'=>1,'msg'=>'新增成功！'];
    }
    _end:
    return $result;
  }
}
