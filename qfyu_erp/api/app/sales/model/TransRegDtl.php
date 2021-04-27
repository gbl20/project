<?php
namespace app\sales\model;
use think\Model;

Class TransRegDtl extends Model{
    public static function getTransExOrder(){
        $orderIds = TransRegDtl::column('order_no');
        return $orderIds;
    }
}