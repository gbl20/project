<?php

namespace app\erp\controller;
use app\BaseController;
use app\erp\model\GoodsRejection;

class GoodsRejectionInfo extends BaseController
{
    //获取来货拒收列表
    public function getGoodsRejectionList()
    {
        $search = $this->request->data;
        $res = GoodsRejection::list($search);
        exit(json_encode($res));
    }
    //获取来货拒收详情
    public function getGoodsRejectionDtl()
    {
        $search = $this->request->data;
        $res = GoodsRejection::details($search['orderid']);
        exit(json_encode($res));
    }
}
