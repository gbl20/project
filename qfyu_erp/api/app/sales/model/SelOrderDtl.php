<?php
namespace app\sales\model;
use think\facade\Db;
use think\Model;

Class SelOrderDtl extends Model{
    /** 审核销售订单检测库存 */
    public static function checkProStock($orderId){
        $res = ['status'=>0,'msg'=>''];

        $field = 'item_no,goods_code,unit,qty';
        $orderDetails = SelOrderDtl::where('orderid',$orderId)->field($field)->select()->toArray();
        foreach($orderDetails as $v){
            $stock = Db::name('view_total_stock')->where('goods_code',$v['goods_code'])->sum('qty');
        }

        $res = ['status'=>1,'msg'=>''];
        return $res;
    }
}
