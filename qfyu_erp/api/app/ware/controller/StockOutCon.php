<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\StockOut;
use app\ware\model\StockOutDtl;
use think\facade\Db;

/**
 * 出库登记、复核
 * @author wuzhonggui
 * @package app\ware\controller
 */
class StockOutCon extends BaseController
{
    /**
     * 获取出库登记复核单列表
     */
    public function getStockOutList(){
        $list=StockOut::getStockOutList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 查询出库登记复核单信息
     */
    public function getStockOutInfo(){
        $order=StockOut::getStockOutInfo($this->request->data);
        $result=['status'=>1,'msg'=>'success','order'=>$order];
        exit(json_encode($result));
    }
    /**
     * 保存
     */
    public function saveStockOut(){
        $result=StockOut::saveOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 审核
     */
    public function auditOrder(){
        $result=StockOut::auditOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }
    /**
     * 还原
     */
    public function backOrder(){
        $result=StockOut::backOrder($this->request->data,$this->request->code);
        exit(json_encode($result));
    }


    /**
     *  销售退回申请-根据发货单获取单据出库符合记录
    **/
    public function getSelOrderStock()
    {
      $result = StockOutDtl::orderStockDtl($this->request->data);
      exit(json_encode($result));
    }
}
