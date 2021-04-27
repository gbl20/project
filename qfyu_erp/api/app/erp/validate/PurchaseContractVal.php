<?php
namespace app\erp\validate;
use think\Validate;
/**
 * 采购合同-验证器
 * @author wuzhonggui
 * @license 2020-11-25
 */
class PurchaseContractVal extends Validate
{
    //验证规则
    protected $rule =   [
        'title'=>'require',
        'sup_code'=>'require',
        'settlement'=>'require',
        'sign_code'=>'require'
    ];

    //验证信息
    protected $message = [
        'title.require'=>'请输入合同标题',
        'sup_code.require'=>'请选择供应商',
        'settlement.require'=>'请选择结算方式',
        'sign_code.require'=>'请选择签约人'
    ];

    //验证场景
    protected $scene = [
        'all'=>['title','sup_code','settlement','sign_code']
    ];

}