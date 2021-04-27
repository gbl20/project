<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Commodity;
use think\facade\Config;
/**
 * 采购计划管理
 * @author wuzhonggui
 * @license 2020-11-05
 */
class PurchasePlan extends BaseController
{
    /**
     * 采购计划列表
     */
    public function planList(){
        $list=\app\erp\model\PurchasePlan::getPlanList($this->request->data);
        $typelist=Config::get('parameter.plan_type'); //计划类型
        $result=['status'=>1,'msg'=>'success','list'=>$list,'typelist'=>$typelist];
        exit(json_encode($result));
    }
    /**
     * 新增、修改计划初始化
     */
    public function initAddPlan(){
        $typelist=Config::get('parameter.plan_type'); //计划类型
        $params=Commodity::getCategorySelect(); //商品常规参数
        //订单信息
        $data=\app\erp\model\PurchasePlan::getPlanOrderByOrderId($this->request->data);
        $result=['status'=>1,'msg'=>'success','params'=>$params,'typelist'=>$typelist,'order'=>$data['order'],'glist'=>$data['glist']];
        exit(json_encode($result));
    }
    /**
     * 保存-计划单
     */
    public function savePlanOrder(){
        $result=\app\erp\model\PurchasePlan::savePlanOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 审核处理
     */
    public function checkOrder(){
        $result=\app\erp\model\PurchasePlan::checkOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 还原处理
     */
    public function backOrder(){
        $data=$this->request->data;
        $result=\app\erp\model\PurchasePlan::backOrder($data['orderid'],$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 结案操作
     */
    public function closeOrder(){
        $data=$this->request->data;
        $result=\app\erp\model\PurchasePlan::closeOrder($data['orderid'],$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 删除操作
     */
    public function deleteOrder(){
        $data=$this->request->data;
        $result=\app\erp\model\PurchasePlan::deleteOrder($data['orderid']);
        exit(json_encode($result));
    }
    /**
     * 生成订单（采购订单）
     */
    public function generateOrder()
    {
        $result=\app\erp\model\PurchasePlan::generatePurchaseOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
}