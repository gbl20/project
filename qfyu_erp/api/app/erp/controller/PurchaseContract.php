<?php
namespace app\erp\controller;
use app\BaseController;

/**
 * 采购合同管理
 * @author wuzhogngui
 * @license 2020-11-24
 */
class PurchaseContract extends BaseController
{
    /**
     * 选择合同列表
     */
    public function chooseContractList(){
        $list=\app\erp\model\PurchaseContract::choosePurchaseContractList($this->request->data);
        $settlement=\app\erp\model\Settlement::getSettlementList(1);
        $result=['status'=>1,'msg'=>'success','list'=>$list,'settlement'=>$settlement];
        exit(json_encode($result));
    }


    /**
     * 合同列表
     */
    public function contractList(){
        $list=\app\erp\model\PurchaseContract::getPurchaseContractList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 初始化合同资料
     */
    public function initContract(){
        $settlement=\app\erp\model\Settlement::getSettlementList(1);
        $order=\app\erp\model\PurchaseContract::getPurchaseContractByOrderId($this->request->data);
        $result=['status'=>1,'msg'=>'success','settlement'=>$settlement,'order'=>$order];
        exit(json_encode($result));
    }
    /**
     * 保存
     */
    public function saveContract(){
        $result=\app\erp\model\PurchaseContract::savePurchaseContract($this->request->data,$this->request->code);
        exit(json_encode($result));
    }





}