<?php
namespace app\sales\controller;
use app\BaseController;
use app\erp\model\DbWork;
use app\sales\model\SelExport;
use app\sales\model\TransReg;
use app\sales\model\TransRegDtl;
use think\facade\Db;

Class TransRegCon extends BaseController{
    public function transRegList(){
        return TransReg::transRegList($this->request->data,$this->request->code);
    }
    /**
     * 选择需要登记的订单
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public function chooseExOrder(){
        $data = $this->request->data;
        $y_order = $data['y_order'];
        $serParam = $data['ser_param'];
        $orderids = TransRegDtl::getTransExOrder();
        $new_y_order = array_merge($orderids,$y_order);
        if($new_y_order) $serParam['y_order'] = implode(',',$new_y_order);
        $serParam['need_deliver'] = 1;
        $list = SelExport::queryList($serParam);
        $deliveryData = Db::name('delivery')->field('dname,id')->select()->toArray();
        return ['status'=>1,'list'=>$list,'delivery_data'=>$deliveryData];
    }
    public function transRegInit(){
        $inData = $this->request->data;
        $driverData = DbWork::queryList('driver');
        $CarNumData = DbWork::queryList('car_num');
        $data = null;
        if($inData['quotation_orderid']){
            $data = TransReg::queryOne($inData['quotation_orderid']);
        }
        return ['status'=>1,'driver_data'=>$driverData,'car_num_data'=>$CarNumData,'data'=>$data];
    }
    public function comTransReg(){
        return TransReg::comTransReg($this->request->data,$this->request->code);
    }
    public function auditTransReg(){
        dump($this->request->data);die;
    }
}
