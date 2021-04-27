<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\WholeStock;

class Whole extends BaseController
{
    /**
     * 整仓盘点单列表
     */
    public function whole_list(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $result=WholeStock::gettaklist([],$page);
        $result['status']=1;
        exit(json_encode($result));
    }

    /**
     * 新增整仓盘点单
     */
    public function add_whole(){
        $params=$this->request->data;
        $result=WholeStock::addnew_whole($params,['code'=>$this->request->code,'depart'=>$this->request->depart]);
        exit(json_encode($result));
    }

    /**
     * 编辑整仓盘点单
     */
    public function edit_whole(){
        $params=$this->request->data;
        $bill_no=isset($params['id'])?$params['id']:'';
        $result=WholeStock::getWholeInfo($bill_no);
        exit(json_encode($result));
    }

    /**
     * 保存修改盘点单
     */
    public function up_whole(){
        $params=$this->request->data;
        $result=WholeStock::save_order($params,['code'=>$this->request->code,'depart'=>$this->request->depart]);
        exit(json_encode($result));
    }

    /**
     * 整仓盘点单审核
     */
    public function check_whole(){
        $params=$this->request->data;
        $result=WholeStock::check_transfer($params['bill_no'],['code'=>$this->request->code]);
        exit(json_encode($result));
    }

    /**
     * 删除整仓盘点单
     */
    public function del_whole(){
        $params=$this->request->data;
        $result=WholeStock::del_order($params['bill_no']);
        exit(json_encode($result));
    }
}