<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\ProvSelfGoodsVal;
use think\facade\Db;
use think\Model;

Class ProvidersSelfGoods extends Model{
    public static function comProduced($data){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $reData = CommonFun::ProcessingData($data['fdata'],['id']);
        $validate = new ProvSelfGoodsVal();
        $val_res = $validate->scene('all')->check($reData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $where[] = ['supplier_code','=',$reData['supplier_code']];
        $where[] = ['goods_code','=',$reData['goods_code']];
        $checkOne = ProvidersSelfGoods::where($where)->value('goods_code');
        if($checkOne){
            $res['msg'] = '当前产品已添加请勿重复添加！';
            goto _end;
        }
        $re = ProvidersSelfGoods::strict(false)->extra('IGNORE')->insertGetId($reData);
        if($re) $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        _end:
        return $res;
    }
    public static function getProduced($data){
        $res = ['status'=>0,'msg'=>'init error'];
        if(!isset($data['supplier_code'])) goto _end;
        $supplierCode = strip_tags($data['supplier_code']);
        $where[] = ['supplier_code','=',$supplierCode];
        $data = Db::name('providers_self_goods')->alias('p')
            ->join('commodity_list c','c.goods_code = p.goods_code','left')
            ->where($where)->field('p.*,c.goods_name,specs,unit,unit2,production,origin,category,function')->select()->toArray();
        if($data) $res = ['status'=>1,'data'=>$data];
        _end:
        return $res;
    }
}