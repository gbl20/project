<?php

namespace app\erp\model;
use think\facade\Db;
use think\Model;

class GoodsRejection extends Model
{
    //来货拒收列表
    public static function list($search)
    {
        $where = [];
        $res = GoodsRejection::where($where)->alias('r')
            ->field('r.*,p.full_name as supplier_name,e.name as create_name,em.name as checker_name')
            ->join('providers p','p.supplier_code=r.supplier_code','left')
            ->join('employee e','e.code=r.create_code','left')
            ->join('employee em','em.code=r.checker_code','left')
            ->paginate(['page'=>$search['page'],'list_rows'=>$search['page_size']])
            ->toArray();
        return ['status'=>1,'data'=>$res];

    }
    public static function details($orderid)
    {
        $form = GoodsRejection::where('orderid',$orderid)->alias('r')
            ->field('r.*,p.full_name as supplier_name')
            ->join('providers p','p.supplier_code=r.supplier_code','left')
            ->find()
            ->toArray();
        $data = Db::name('goods_rejection_details')->alias('g')
            ->field('g.*,c.name,c.packspecs,c.origin,c.production,c.approval_code')
            ->join('commodity c','c.goods_code=g.goods_code','left')
            ->where('g.r_orderid',$orderid)
            ->select();
        return ['status'=>1,'form'=>$form,'data'=>$data];
    }
}
