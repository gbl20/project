<?php
namespace app\erp\model;
use think\Model;
/**
 * 采购订单-业务逻辑处理类
 * @author wuzhonggui
 * @license 2020-11-20
 */
class PurchaseOrderMod extends Model
{
    /**
     * 保存、修改采购订单
     * @param $data 采购订单数据
     * @param $user 操作者
     */
    public static function savePurchaseOrder($data,$user){
        $result=['status'=>0,'msg'=>'采购订单保存失败'];


        _end:
        return $result;
    }

}