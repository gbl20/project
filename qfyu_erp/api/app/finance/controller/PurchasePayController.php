<?php
namespace app\finance\controller;
use app\BaseController;
use app\finance\model\PurchasePay;

/**
 * 采购付款单
 * @author wuzhonggui
 * @package app\finance\controller
 */
class PurchasePayController extends BaseController
{
    /**
     * 采购付款单列表
     */
    public function purchasePayList(){
        $list=PurchasePay::getPurchasePay($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }

}