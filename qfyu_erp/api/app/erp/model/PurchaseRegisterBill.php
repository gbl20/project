<?php

namespace app\erp\model;
use app\helper\CommonFun;
use think\Model;

class PurchaseRegisterBill extends Model
{
    /** 发票详情 **/
    public static function getBillDet($orderid)
    {
        $res = PurchaseRegisterBill::where('orderid',$orderid)->find();
        if(empty($res)){
            $res = PurchaseRegister::where('orderid',$orderid)->alias('r')
                ->field('r.orderid,concat(p.area,p.address) as address,p.full_name as title,p.tel')
                ->join('providers p','p.supplier_code=r.supplier_code')
                ->find();
            $res['bill_no'] = '';
            $res['type']    = null;
            $res['create_date'] = date("Y-m-d");
            $res['money']  = null;
            $res['track']  = '';
            $res['remark'] = '';
        }else{
            $res['money'] = (float)$res['money'];
        }
        return ['data'=>$res];
    }
    /**
     *  来货登记-发票信息
     *  新增 - 修改
     **/
    public static function editBill($data)
    {
        $result = ['status'=>0,'msg'=>'新增失败!'];
        $data = CommonFun::ProcessingData($data);
        $has_oid = PurchaseRegisterBill::where('orderid',$data['orderid'])->field('bill_no,orderid')->find();
        if(!$has_oid){//新增
            $res = PurchaseRegisterBill::insert($data);
            if ($res) $result = ['status'=>1,'msg'=>'新增成功!'];
        }else{//修改
            $res = PurchaseRegisterBill::where('orderid',$data['orderid'])->update($data);
            if ($res) $result=['status'=>1,'修改成功!'];
            else $result['msg'] = '修改失败!';
        }
        return $result;
    }
}
