<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\Acconline;

class Immediate extends BaseController
{
    /**
     * 即时盘点单列表
     */
    public function imlist(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $result=Acconline::getOnlineList([],$page);
        $result['status']=1;
        exit(json_encode($result));
    }
    /**
     * 新增/编辑 实物盘点单
     */
    public function edit_acconline(){
        $params=$this->request->data;
        $bill_no=isset($params['id'])?$params['id']:'';
        $item_no=isset($params['item_no'])?$params['item_no']:[]; //列表页审核时列出库存有变动的产品
        $result=Acconline::getRealInfo($bill_no,$item_no);
        if(!$result['data']){
            $result=array('status'=>0,'data'=>[],'list'=>[],'msg'=>'即时盘点单号不存在！');
        }else{
            if(empty($bill_no)) $result['data']['empno']=$this->request->code;
            $result['status']=1;
        }
        exit(json_encode($result));
    }

    /**
     * 选择产品 调出库存记录
     */
    public function stocklist(){
        $params=$this->request->data;
        $result=Acconline::getStockList($params);
        exit(json_encode($result));
    }

    /**
     * 保存新增/修改
     */
    public function upaccstock(){
        $params=$this->request->data;
        $result=Acconline::save_order($params,$this->request->depart,$this->request->code);
        exit(json_encode($result));
    }

    /**
     * 删除即时盘点单
     */
    public function del_acconline(){
        $params=$this->request->data;
        $result=Acconline::del_order($params['bill_no']);
        exit(json_encode($result));
    }

    /**
     * 审核即时盘点单
     */
    public function check_acconline(){
        $params=$this->request->data;
        $result=Acconline::check_transfer($params['bill_no'],$this->request->code);
        exit(json_encode($result));
    }

    /**
     * 审核前删除库存变动的记录
     */
    public function del_accer(){
        $params=$this->request->data;
        $result=Acconline::del_errlog($params);
        exit(json_encode($result));
    }
}