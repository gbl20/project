<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\RealStocktak;

class Realstock extends BaseController
{
    /**
     * 实物盘点单
     */
    public function real_list(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $result=RealStocktak::getList([],$page);
        $result['status']=1;
        exit(json_encode($result));
    }
    /**
     * 实物盘点单 审核
     */
    public function check_real(){
        $params=$this->request->data;
        $result=RealStocktak::check_transfer($params['bill_no'],$this->request->code);
        exit(json_encode($result));
    }

    /**
     * 新增/编辑 实物盘点单
     */
    public function edit_realstock(){
        $params=$this->request->data;
        $bill_no=isset($params['id'])?$params['id']:'';
        $result=RealStocktak::getRealInfo($bill_no);
        if(!$result['data']){
            $result=array('status'=>0,'data'=>[],'list'=>[],'msg'=>'结存单号不存在！');
        }else{
            if(empty($bill_no)) $result['data']['empno']=$this->request->code;
            $result['status']=1;
        }
        exit(json_encode($result));
    }

    /**
     * 删除实物盘点单
     */
    public function del_realstock(){
        $params=$this->request->data;
        $result=RealStocktak::del_order($params['bill_no']);
        exit(json_encode($result));
    }

    /**
     * 保存新增/修改
     */
    public function up_realstock(){
        $params=$this->request->data;
        $result=RealStocktak::save_order($params,$this->request->depart,$this->request->code);
        exit(json_encode($result));
    }
}