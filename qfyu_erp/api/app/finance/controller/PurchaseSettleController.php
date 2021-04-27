<?php
namespace app\finance\controller;
use app\BaseController;
use app\finance\model\PurchaseSettle;
/**
 * 采购结算
 * @author wuzhonggui
 * @license 2020-12-23
 */
class PurchaseSettleController  extends BaseController
{
    /**
     * 采购结算列表
     */
    public function pchSettleList(){
        $list=PurchaseSettle::getPurchaseSettleList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }


}