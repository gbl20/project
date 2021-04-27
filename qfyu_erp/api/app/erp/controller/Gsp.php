<?php

namespace app\erp\controller;
use app\BaseController;
use app\erp\model\GoodsPhoto;
use app\erp\model\GspFirstGoods;

class Gsp extends BaseController
{
    /** 获取首营品种申请列表 **/
    public function getFirstGoodsList()
    {
        $search = $this->request->data;
        $res = GspFirstGoods::get_first_goods_list($search,$this->request->code);
        $res['dosage']  =config('parameter.dosage');
        $res['unit']    =config('parameter.goods_unit');
        $res['gsp_type']=config('parameter.gsp_category');
        $res['storage_type']=config('parameter.storage');
        exit(json_encode($res));
    }
    /** 获取组织机构-许可经营类别-商品大类-功能类别-GSP验收类型 **/
    public function getGspCategory(){
        $data = $this->request->data;
        $res = GspFirstGoods::getGspFirstGoodsInfo($data);
        exit(json_encode($res));
    }
    /** 保存-修改 首营品种资料 **/
    public function addFirstGoods()
    {
        $data = $this->request->data;
        $res  = GspFirstGoods::add_goods_info($data,$this->request->code);
        exit(json_encode($res));
    }
    /**审核首营产品资料 **/
    public function checkFirstGoods()
    {
        $data = $this->request->data;
        $res = GspFirstGoods::check_first_goods($data['orderid'],$this->request->code);
        exit(json_encode($res));
    }
    /*各部门负责人审批*/
    public function admCheckFirstGoods()
    {
        $data = $this->request->data;
        $res = GspFirstGoods::adm_check_first_goods($data,$this->request->code);
        exit(json_encode($res));
    }
    /** 上传首营品种商品证照 **/
    public function firstGoodsInfoUpload()
    {
        $data = $this->request->data;
        $res = GoodsPhoto::saveGoodsPhoto($data['data'],$this->request->code);
        exit(json_encode($res));
    }
    /** 删除商品证照 **/
    public function firstGoodsImgDel()
    {
        $data = $this->request->data;
        $res = GoodsPhoto::delPhoto($data['data'],$this->request->code);
        exit(json_encode($res));
    }
    public function comFirstGoodsList()
    {
        $res = GspFirstGoods::comFirstGoodsList();
        exit(json_encode($res));
    }
    public function getFirstGoodsPhoto()
    {
        $data = $this->request->data;
        $res = GspFirstGoods::goodsPhoto($data['goods_code']);
        exit(json_encode($res));
    }
}
