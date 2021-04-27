<?php

namespace app\erp\controller;

use app\BaseController;
use app\erp\model\Commodity;
use app\erp\model\CommodityBatchDiscount;
use app\erp\model\CommodityDrugReports;
use app\erp\model\CommodityPrice;
use app\erp\model\CommoditySalesArea;
use app\erp\model\CommoditySalesCategory;
use app\erp\model\CommoditySellLimit;
use app\erp\model\CommodityWare;
use app\erp\model\GoodsPhoto;
use app\erp\model\PermitKinds;
use app\helper\CommonFun;
use think\facade\Config;

class CommodityInfo extends BaseController
{
  public function getCommodityList()
  {
    $search = $this->request->data;
    $res = Commodity::list($search);
    if (!empty($res['data'])) {
      $goods_code = $res['data'][0]['goods_code'];
    }
    exit(json_encode($result = ['status' => 1, 'msg' => 'Succss', 'data' => $res, 'goods_code' => $goods_code]));
  }

  /** 新增商品资料 **/
  public function newCommodity()
  {
    $data = $this->request->data;
    $res = Commodity::newCommodityInfo($data, $this->request->code);
    exit(json_encode($res));
  }
  /************************选择商品相关查询**********************/
  /**
   * 选择商品查询列表（分页）
   */
  public function chooseGoodsList()
  {
    $list = Commodity::getChooseAllGoodsList($this->request->data);
    $category = PermitKinds::getKindsLCascaber();
    $params = Commodity::getCategorySelect(); //商品常规参数
    $result = ['status' => 1, 'msg' => 'success', 'list' => $list, 'category' => $category, 'params' => $params];
    exit(json_encode($result));
  }
  /***********************商品存放库位管理***********************/
  //获取商品存放库位列表
  public function getGoodsWareList()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = CommodityWare::wareList($data['goods_code']);
    exit(json_encode(['status' => 1, 'msg' => 'success', 'data' => $res]));
  }

  //新增商品存放库位
  public function addGoodsWare()
  {
    $data = $this->request->data;
    $data = CommonFun::ProcessingData($data['data']);
    $res = CommodityWare::addWare($data);
    exit(json_encode($res));
  }

  //删除商品存放库位
  public function delGoodsWare()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = CommodityWare::delWare($data);
    exit(json_encode($res));
  }

  /** 审核商品资料 **/
  public function checkerCommodity()
  {
    $data = $this->request->data;
    $res = Commodity::checker($data, $this->request->code);
    exit(json_encode($res));
  }

  /** 获取商品价格 **/
  public function getPriceList()
  {
    $search = $this->request->data;
    $data['goods_code'] = $search['goods_code'];
    $res = CommodityPrice::getCommodityPriceList($data['goods_code'], $this->request->pricePower);
    exit(json_encode(['status' => 1, 'data' => $res]));
  }

  /** 修改商品价格 **/
  public function editPrice()
  {
    $data = $this->request->data;
    $res = CommodityPrice::editCommodityPrice($data['data'], $this->request->code);
    exit(json_encode($res));
  }

  /** 获取药品证照 **/
  public function getGoodsPhoto()
  {
    $data = $this->request->data;
    $res = GoodsPhoto::photo($data['goods_code']);
    exit(json_encode(['status' => 1, 'data' => $res, 'img_name' => config('parameter.img_config.goods')]));
  }

  /** 删除商品证照 **/
  public function delGoodsPhoto()
  {
    $data = $this->request->data;
    $res = GoodsPhoto::delPhoto($data['data'], $this->request->code);
    exit(json_encode($res));
  }

  /** 获取商品详情 **/
  public function getCommodityInfo()
  {
    $data = $this->request->data;
    $kinds = PermitKinds::getKindsLCascaber();
    $category = PermitKinds::getCommodityCategory();
    $permit = PermitKinds::get_permit_list();
    $custom = $permit['data'];
    $res = Commodity::commodityInfo($data['goods_code']);
    exit(json_encode(['status' => 1, 'kinds' => $kinds, 'category' => $category, 'custom' => $custom, 'price' => $res]));
  }

  //获取商品控销类别
  public function getSalesCategoryList()
  {
    $data = $this->request->data;
    $res = CommoditySalesCategory::list($data['goods_code']);
    exit(json_encode($res));
  }

  //新增/编辑控销类别
  public function editSalesCategory()
  {
    $data = $this->request->data;
    $res = CommoditySalesCategory::edit($data['data']);
    exit(json_encode($res));
  }

  //删除商品控销类别
  public function delSalesCategory()
  {
    $data = $this->request->data;
    $res = CommoditySalesCategory::del($data['data']);
    exit(json_encode($res));
  }

  //获取商品库存信息
  public function getGoodsQty()
  {
    $data = $this->request->data;
    $res = Commodity::qtyList($data['goods_code']);
    exit(json_encode($res));
  }

  //获取商品控销区域
  public function getGoodsSalesAreaList()
  {
    $data = $this->request->data;
    $res = CommoditySalesArea::list($data['goods_code']);
    exit(json_encode($res));
  }

  //新增、编辑商品控销区域
  public function editSalesArea()
  {
    $data = $this->request->data;
    $res = CommoditySalesArea::edit($data);
    exit(json_encode($res));
  }

  //获取商品销售限制
  public function getSellLimitList()
  {
    $data = $this->request->data;
    $res = CommoditySellLimit::list($data['goods_code']);
    exit(json_encode(['status' => 1, 'data' => $res]));
  }

  //
  public function addCustomerLimit()
  {
    $data = $this->request->data;
    $res = CommoditySellLimit::add($data['data']);
    exit(json_encode($res));
  }

  public function editCustomerLimit()
  {
    $data = $this->request->data;
    $res = CommoditySellLimit::edit($data['data']);
    exit(json_encode($res));
  }

  public function delCustomerLimit()
  {
    $data = $this->request->data;
    $res = CommoditySellLimit::del($data['data']);
    exit(json_encode($res));
  }

  //获取商品批量折扣
  public function getGoodsBatchList()
  {
    $data = $this->request->data;
    $res = CommodityBatchDiscount::list($data['goods_code']);
    exit(json_encode($res));
  }
  //新增-编辑商品批量折扣
  public function editGoodsBatch()
  {
    $data = $this->request->data;
    $res = CommodityBatchDiscount::edit($data['data']);
    exit(json_encode($res));
  }
  //删除商品批量折扣
  public function delGoodsBatch()
  {
    $data = $this->request->data;
    $res = CommodityBatchDiscount::del(CommonFun::ProcessingData($data['data']));
    exit(json_encode($res));
  }

  //查询药检报告
  public function getGoodsDrugReports()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = CommodityDrugReports::getDrugReports($data);
    exit(json_encode($res));
  }

  //上传药检报告
  public function addGoodsDrugReports()
  {
    $data = CommonFun::ProcessingData($this->request->data);
    $res = CommodityDrugReports::addDrugReports($data);
    exit(json_encode($res));
  }
}
