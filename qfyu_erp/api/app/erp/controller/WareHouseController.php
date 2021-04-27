<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\WareHouse;
use app\erp\model\WarePosition;

/**
 * 仓库管理控制器类
 * @author wuzhonggui
 * @license 2020-10-27
 */
class WareHouseController extends BaseController
{
    /***************仓库信息管理**************/
    /**
     * 仓库信息列表
     */
    public function wareList(){
        $cfg=config('warehouse');
        $list=WareHouse::getWareList($this->request->data);
        $result=['status'=>1,'msg'=>'success','cfg'=>$cfg,'list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 新增、修改初始化数据
     */
     public function wareInit(){
         $result=WareHouse::wareInit();
         exit(json_encode($result));
     }
    /**
     * 保存
     */
     public function wareSave(){
         $result=WareHouse::saveWare($this->request->data,$this->request->code);
         exit(json_encode($result));
     }
    /**
     * 启用、禁用
     */
     public function wareSet(){
         $result=WareHouse::setWareStatus($this->request->data,$this->request->code);
         exit(json_encode($result));
     }


    /***************货位信息管理**************/
    /**
     * 货位信息列表
     */
    public function wpos_list(){
        $list=WarePosition::getWarePositionList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 货位新增、编辑保存
     */
    public function wpos_save(){
        $result=WarePosition::saveWarePos($this->request->data,$this->request->code);
        exit(json_encode($result));
    }

    /******************盘点锁定信息****************/
    public function wareLockedList(){

    }
}
