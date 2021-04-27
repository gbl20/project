<?php

namespace app\erp\validate;
use think\Validate;

class PriceVal extends Validate
{
    protected $rule = [
        'price1'    =>  ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
        'price2'    =>  ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    ];

    protected $message = [
        'price1.regex'  => '商品主单位价格格式有误',
        'price2.regex'  => '商品辅单位价格格式有误',
    ];

    protected $scene = [
        'all'=>[]
    ];
}
