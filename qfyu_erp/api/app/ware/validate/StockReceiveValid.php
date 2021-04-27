<?php
namespace app\ware\validate;
use think\facade\Db;
use think\Validate;
/**
 * 采购入库、复核验证器
 * @author wuzhogngui
 * @license 2020-12-09
 */

class StockReceiveValid extends Validate
{
    //验证规则
    protected $rule =   [
        'sup_code'=>['require','checkProviders'],
        'emp_no'=>['checkEmpNo'],
        'keeper1_code'=>['checkKeeper1'],
        'keeper2_code'=>['checkKeeper2']
    ];

    //验证信息
    protected $message = [
        'sup_code.require'=>'请选择供应商',
    ];

    //验证场景
    protected $scene = [
        'all'=>['sup_code','emp_no','keeper1_code','keeper2_code']
    ];

    /**
     * 检测供应商、结算方式、业务员
     * @param $value
     * @param $data
     */
    protected function checkProviders($value,$rule,$data){
        //验证供应商
        $supField="supplier_code,full_name,subject_dept,audit_status,pay_mode_no,business_leader";
        $hassup=Db::name('providers')->field($supField)->where(['supplier_code'=>$value])->find();
        if($hassup==null){
            return "请选择供应商";
        }
        if($hassup['audit_status']!=1){
            return "供应商：(【{$hassup['supplier_code']}】{$hassup['full_name']}) 未审核合格";
        }
        //验证结算方式
        $paymode=empty($hassup['pay_mode_no'])?$data['paymode']:$hassup['pay_mode_no'];
        $hasSet=Db::name('settlement')->field('id,code')->where(['code'=>$paymode])->find();
        if($hasSet==null){
            return "请选择结算方式";
        }
        //验证业务员
        $leader=empty($hassup['business_leader'])?$data['sales_code']:$hassup['business_leader'];
        $hasLeader=Db::name('employee')->field('code,name')->where(['code'=>$leader])->find();
        if($hasLeader==null){
            return "请选择业务员";
        }
        return true;
    }
    /**
     * 校验验货员
     * @param $value
     * @param $data
     */
    protected function checkEmpNo($value,$rule,$data){
        if(!empty($value)){
            $hasEmp=Db::name('employee')->where(['code'=>$value])->find();
            if($hasEmp==null || empty($data['emp_name']) || $hasEmp['name']!=$data['emp_name']){
                return "验货员信息不正确";
            }
        }
        return true;
    }
    /**
     * 校验第一保管员
     * @param $value
     * @param $data
     */
    protected function checkKeeper1($value,$rule,$data){
        if(!empty($value)){
            $hasKeeper=Db::name('employee')->where(['code'=>$value])->find();
            if($hasKeeper==null || empty($data['keeper1_name']) || $hasKeeper['name']!=$data['keeper1_name']){
                return "第一保管员信息不正确";
            }
        }
        return true;
    }
    /**
     * 校验第二保管员
     * @param $value
     * @param $data
     */
    protected function checkKeeper2($value,$rule,$data){
        if(!empty($value)){
            $hasKeeper=Db::name('employee')->where(['code'=>$value])->find();
            if($hasKeeper==null || empty($data['keeper2_name']) || $hasKeeper['name']!=$data['keeper2_name']){
                return "第二保管员信息不正确";
            }
        }
        return true;
    }

}