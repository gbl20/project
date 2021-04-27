<?php

namespace app\erp\model;
use think\Model;

class CommodityWare extends Model
{
    //商品库位列表
    public static function wareList($goods_code)
    {
        $data = CommodityWare::where('goods_code',$goods_code)->alias('c')
            ->field('c.*,w.ware_title')
            ->join('warehouse w','w.ware_code=c.ware_code','left')
//            ->join('ware_position p','p.pos_code=c.pos_code','left')
            ->select();
        return $data;
    }
    //新增商品存放库位
    public static function addWare($data)
    {
        $result = ['status'=>0,'msg'=>'新增失败！'];
        $where[] = ['goods_code','=',$data['goods_code']];
        $where[] = ['ware_code','=',$data['ware_code']];
        $where[] = ['pos_code','=',$data['pos_code']];
        $res = CommodityWare::where($where)->find();
        if($res){
            $result['msg'] = '该库位已经存在！';goto _end;
        }
        $res1= CommodityWare::insert($data);
        if ($res1) $result = ['status'=>1,'msg'=>'Success','goods_code'=>$data['goods_code']];
        _end:
        return $result;
    }
    //删除商品库位
    public static function delWare($data)
    {
        $result = ['status'=>0,'msg'=>'删除失败！'];
        $where  = [];
        if(isset($data['goods_code']) && $data['goods_code']) $where[] = ['goods_code','=',$data['goods_code']];
        if(isset($data['ware_code']) && $data['ware_code']) $where[] = ['ware_code','=',$data['ware_code']];
        if(isset($data['pos_code']) && $data['pos_code']) $where[] = ['pos_code','=',$data['pos_code']];
        $res = CommodityWare::where($where)->delete();
        if ($res) $result = ['status'=>1,'msg'=>'删除成功！','goods_code'=>$data['goods_code']];
        return $result;
    }
}
