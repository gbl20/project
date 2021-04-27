<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\CommodityPriceSystem;

class PriceSystem extends BaseController
{
    /** 获取价格体系列表 **/
    public function getList()
    {
        $data = CommodityPriceSystem::price_system($this->request->pricePower);
        exit(json_encode($data));
    }
    /** 新增-修改价格体系方案 **/
    public function updateSystem()
    {
        $search = $this->request->data;
        $res = CommodityPriceSystem::update_system($search,$this->request->code,$this->request->depart);
        exit(json_encode($res));
    }
    /** 删除价格体系 **/
    public function delSystem()
    {
        $search = $this->request->data;
        $res = CommodityPriceSystem::del_system($search['id']);
        exit(json_encode($res));
    }
}
