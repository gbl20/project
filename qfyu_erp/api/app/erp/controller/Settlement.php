<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Branch;
/**
 * 结算方式管理
 * @author wuzhonggui
 * @license 2020-11-04
 */
class Settlement extends  BaseController
{
    /**
     * 结算方式列表
     */
    public function settlementList(){
        $list=\app\erp\model\Settlement::getSettlementList();
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 新增、修改结算方式（保存）
     */
    public function saveSettlement(){
        $result=\app\erp\model\Settlement::saveSettlementData($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
}