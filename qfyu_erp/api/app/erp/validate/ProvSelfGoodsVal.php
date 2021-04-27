<?php
namespace app\erp\validate;
use think\Validate;

Class ProvSelfGoodsVal extends Validate{
    protected $rule = [
        'supplier_code' => ['require'],
        'goods_code' => ['require'],
        'remark' => ['max'=>200]
    ];
    protected $message = [
        'supplier_code' => '请求参数有误',
        'goods_code' => '请选择一个产品',
        'remark' => '备注内容输入超上限'
    ];
    protected $scene = [
        'all' => []
    ];
}