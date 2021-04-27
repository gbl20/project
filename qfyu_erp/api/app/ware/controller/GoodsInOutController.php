<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\StockGoodsinout;
/**
 * 商品出入库查询-控制器类
 * @author wuzhonggui
 * @package app\ware\controller
 */
class GoodsInOutController extends BaseController
{
    /**
     * 商品入库明细列表
     */
    public function getInQtyList(){
        $list=StockGoodsinout::getInQtyList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 商品出库明细列表
     */
    public function getOutQtyList(){
        $list=StockGoodsinout::getOutQtyList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 商品库存明细列表
     */
    public function getQtyDetailList(){
        $list=StockGoodsinout::getQtyDetailList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 商品分仓库存
     */
    public function getBatchPartQtyList(){
        $list=StockGoodsinout::getBatchPartQtyList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 商品总库存列表
     */
    public function getTotalQtyList(){
        $list=StockGoodsinout::getTotalQtyList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
}