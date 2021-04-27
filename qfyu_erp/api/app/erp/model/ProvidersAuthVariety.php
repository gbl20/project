<?php
namespace app\erp\model;
use app\helper\CommonFun;
use think\facade\Db;
use think\Model;

Class ProvidersAuthVariety extends Model{
    public static function addData($data){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $data = CommonFun::ProcessingData($data);
        $where['prov_s_id'] = $data['contact_id'];
        $where['goods_code'] = $data['goods_code'];
        $where['supplier_code'] = $data['supplier_code'];
        $checkOne = self::where($where)->value('prov_s_id');
        if($checkOne){
            $res['msg'] = '该产品已添加，请勿重复添加！';
            goto _end;
        }
        $re = Db::name('providers_auth_variety')->extra('IGNORE')->insert($where);
        if($re){
            $data = self::queryProList($where['prov_s_id'],$where['goods_code']);
            $res = ['status'=>1,'msg'=>'提交成功','data'=>$data[0]];
        }
        _end:
        return $res;
    }
    public static function queryProList($provSId,$goodsCode=null){
        $where[] = ['p.prov_s_id','=',$provSId];
        if($goodsCode) $where[] =  ['p.goods_code','=',$goodsCode];
        $data = Db::name('providers_auth_variety')->alias('p')
            ->join('providers_sales s','s.id = p.prov_s_id','left')
            ->join('commodity_list c','c.goods_code = p.goods_code','left')
            ->where($where)->field('p.supplier_code,p.goods_code,s.id,s.user_name,c.goods_name,specs,production,origin,approval_code,dosage')->select()->toArray();
        return $data;
    }
}
