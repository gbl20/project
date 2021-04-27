<?php
namespace app\ware\validate;
use think\Validate;
/**
 * 复核出库详情验证
 * @author wuzhonggui
 * @package app\ware\validate
 */
class StockOutDetailVal extends Validate
{
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


}