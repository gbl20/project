<?php
namespace app\erp\model;
use think\facade\Db;
use think\Model;

Class EnterprisePhoto extends Model{
    public static function addImg($data,$uCode,$pic_url,$kind=0){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $proData['supplier_code'] = $data['code'];
        $proData['img_name'] = $data['name'];
        $proData['file_name'] = $pic_url;
        $proData['create_date'] = date('Y-m-d H:i:s',time());
        $proData['validity_date'] = $data['validity_date'];
        $proData['creator'] = $uCode;
        $proData['kind'] = $kind;
        $re = Db::name('enterprise_photo')->replace(true)->insert($proData);
        $proData['validity_date'] = date('Y-m-d',strtotime($proData['validity_date']));
        if($re) $res = ['status'=>1,'msg'=>'保存成功','data'=>$proData];
        return $res;
    }
    public static function queryImgList($kind,$supplierCode){
        $where[] = ['supplier_code','=',$supplierCode];
        $where[] = ['kind','=',$kind];
        $res = EnterprisePhoto::where($where)->field('img_name,file_name,validity_date,create_date,creator')->select()->toArray();
        return $res;
    }
}
