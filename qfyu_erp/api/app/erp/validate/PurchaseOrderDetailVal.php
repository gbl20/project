<?php
namespace app\erp\validate;
use think\Validate;
/**
 * 采购订单详情验证
 * @author wuzhonggui
 * @license 2020-12-21
 */
class PurchaseOrderDetailVal extends Validate
{
    protected $rule = [
        'goods_code'=>['require'],
        'nums'=>['regex'=>'/^(\d{0,9}\.(\d{0,5}))$|^\d{0,9}$/'],
        'price'=>['regex'=>'/^(\d{0,9}\.(\d{0,6})$)|^\d{0,9}$/'],
        'discount'=>['regex'=>'/^(\d{0,3}\.(\d{0,2})$)|^\d{0,3}$/'],
        'taxrate'=>['regex'=>'/^(\d{0,3}\.(\d{0,2})$)|^\d{0,3}$/'],
        'unit'=>['require']
    ];

    protected $message = [
        'goods_code.require'=>'商品资料信息有误',
        'nums.regex'=>'采购数量不正确，请检查采购数量',
        'price.regex'=>'单价格式不正确，请检查采购单价',
        'discount.regex'=>'折扣格式不正确，请检查折扣',
        'taxrate.regex'=>'税率格式不正确，请检查税率',
        'unit.require'=>'请设置明细商品单位信息'
    ];

    protected $scene = [
        'all' => ['goods_code','nums','price','discount','taxrate']
    ];
}