<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Commodity;
use app\erp\model\PurchaseLackMod;
/**
 * 采购-缺货登记管理
 * @author wuzhogngui
 * @license 2020-11-17
 */
class PurchaseLack extends BaseController
{
    /**
     * 缺货单据列表
     */
    public function lackList(){
        $list=PurchaseLackMod::getLackList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 新增、编辑初始化
     */
    public function initLackDetail(){
        $data=PurchaseLackMod::getLackOrderById($this->request->data);
        $result=['status'=>1,'msg'=>'success','data'=>$data];
        exit(json_encode($result));
    }
    /**
     * 保存
     */
    public function saveLackOrder(){
        $result=PurchaseLackMod::saveLackOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 审核
     */
    public function checkLackOrder(){
        $result=PurchaseLackMod::checkLackOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 还原
     */
    public function resetCheckLackOrder(){
        $result=PurchaseLackMod::resetCheckLackOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 删除
     */
    public function deleteLackOrder(){
        $result=PurchaseLackMod::deleteLackOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 转单（转采购计划单）
     */
    public function transPlanOrder(){
        $result=PurchaseLackMod::transPlanOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
}