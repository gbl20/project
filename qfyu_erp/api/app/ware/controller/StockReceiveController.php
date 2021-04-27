<?php

namespace app\ware\controller;

use app\BaseController;
use app\erp\model\Settlement;
use app\ware\model\StockReceive;
use app\ware\model\StockReceiveDetails;
use think\facade\Config;

/**
 * 验收入库、复核
 * @author wuzhonggui
 * @license 2020-10-04
 */
class StockReceiveController extends BaseController
{
  /**
   * 复核单据列表
   */
  public function stockReceiveList()
  {
    $list = StockReceive::getStockReceiveList($this->request->data);
    $result = ['status' => 1, 'msg' => 'success', 'list' => $list];
    exit(json_encode($result));
  }

  /**
   * 初始化复核单据
   */
  public function initStockReceive()
  {
    $order = StockReceive::getStockReceive($this->request->data);
    $SettList = Settlement::getSettlementList(1);
    $params['goods_status'] = Config::get('parameter.goods_status');
    $params['quality_status'] = Config::get('parameter.quality_status');
    $params['settlist'] = $SettList;
    $result = ['status' => 1, 'msg' => 'success', 'order' => $order, 'params' => $params];
    exit(json_encode($result));
  }

  /**
   * 保存
   */
  public function saveStockReceive()
  {
    $result = StockReceive::saveStockReceive($this->request->data, $this->request->code);
    exit(json_encode($result));
  }

  /**
   * 审核
   */
  public function checkStockReceive()
  {
    $result = StockReceive::checkStockReceive($this->request->data, $this->request->code, $this->request->depart);
    exit(json_encode($result));
  }

  /**
   * 还原
   */
  public function backStockReceive()
  {
    $result = StockReceive::backStockReceive($this->request->data, $this->request->code);
    exit(json_encode($result));
  }

  /**
   * 结案
   */
  public function closeStockReceive()
  {
    $result = StockReceive::closeStockReceive($this->request->data, $this->request->code);
    exit(json_encode($result));
  }

  /**
   * 设定收货仓
   */
  public function setWare()
  {
    $result = StockReceive::setWare($this->request->data);
    exit(json_encode($result));
  }


  /** 查询商品购进记录 商品入库单 条件==按商品编号查询已审核的入库明细记录 **/
  public function PurchaseRecordList()
  {
    $result = StockReceiveDetails::GoodsPurchaseRecordList($this->request->data);
    exit(json_encode($result));
  }

  /** 获取商品供货历史 **/
  public function supplyHistoryList()
  {
    $result = StockReceiveDetails::GoodsSupplyHistoryList($this->request->data);
    exit(json_encode($result));
  }
}
