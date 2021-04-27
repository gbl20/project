<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Commodity;
use think\facade\Config;
/**
 * 采购订单
 * @author wuzhonggui
 * @license 2020-11-26
 */
class PurchaseOrder extends BaseController
{
    /**
     * 采购订单列表
     */
    public function purOrderList(){
        $list=\app\erp\model\PurchaseOrder::getPurOrderList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 初始化采购资料
     */
    public function initPurOrder(){
        $order=\app\erp\model\PurchaseOrder::getPurOrderInfo($this->request->data);
        $result=['status'=>1,'msg'=>'success','order'=>$order];
        exit(json_encode($result));
    }
    /**
     * 保存
     */
    public function savePurOrder(){
        $result=\app\erp\model\PurchaseOrder::savePurchaseOrder($this->request->data,$this->request->code,$this->request->depart);
        exit(json_encode($result));
    }
    /**
     * 审核
     */
    public function checkPurOrder(){
        $result=\app\erp\model\PurchaseOrder::checkPurOrder($this->request->data,$this->request->code,$this->request->depart);
        exit(json_encode($result));
    }
    /**
     * 还原
     */
    public function backPurOrder(){
        $result=\app\erp\model\PurchaseOrder::backPurOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 结案
     */
    public function closePurOrder(){
        $result=\app\erp\model\PurchaseOrder::closePurOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 删除
     */
    public function deletePurOrder(){
        $result=\app\erp\model\PurchaseOrder::deletePurOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 转单（转来货登记单）
     */
    public function generateRegisterOrder(){
        $result=\app\erp\model\PurchaseOrder::generateRegisterOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
}