<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\VarietiesVal;
use think\facade\Db;
use think\Model;

Class ProvidersGoods extends Model{
    /** 获取供应商协议品种 */
    public static function getProGoods($data){
        $res = ['status'=>0,'msg'=>'init error'];
        if(!isset($data['supplier_code'])) goto _end;
        $supplierCode = strip_tags($data['supplier_code']);
        $where[] = ['supplier_code','=',$supplierCode];
        $data = Db::name('providers_goods')->alias('p')
            ->join('commodity_list c','c.goods_code = p.goods_code','left')
            ->where($where)->field('p.*,c.goods_name,specs,unit,unit2,production,origin,category,function')->select()->toArray();
        if($data) $res = ['status'=>1,'data'=>$data];
        _end:
        return $res;
    }
    /** 提交编辑 */
    public static function comVarieties($data,$uCode){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $reData = CommonFun::ProcessingData($data['fdata'],['is_valid'],['price','price2']);
        $validate = new VarietiesVal();
        $val_res = $validate->scene('all')->check($reData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $dateTime = date("Y-m-d H:i:s",time());
        $id = intval($reData['id']);

        $reData['update_time'] = $dateTime;
        if($id){
            $reData['id'] = $id;
            $reData['updater'] = $uCode;
            $re = ProvidersGoods::strict(false)->update($reData);
        }else{
            $reData['code'] = CommonFun::createCode('PE');
            $reData['creator'] = $uCode;
            $reData['create_time'] = $dateTime;
            $re = ProvidersGoods::strict(false)->insertGetId($reData);
            $reData['id'] = $re;
        }
        if($re) $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        _end:
        return $res;
    }
}