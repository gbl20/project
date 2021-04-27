<?php
namespace app\erp\validate;
use think\Validate;
/**
 * 采购订单验证器类
 * @author wuzhogngui
 * @license 2020-11-28
 */
class PurchaseOrderVal extends Validate
{
    protected $rule = [
        'sup_code'=>['require'],
        'settle_type'=>['require']
    ];

    protected $message = [
        'sup_code.require'=>'请选择供应商',
        'settle_type.require'=>'请选择结算方式'
    ];

    protected $scene = [
        'all' => ['sup_code','settle_type']
    ];

}