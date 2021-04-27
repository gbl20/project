<?php
namespace app\sales\validate;
use think\Validate;

Class TransRegVal extends Validate
{
    protected $rule = [
        'ship_type' => ['require'],
        'data' => ['array']
    ];
    protected $message = [
        'ship_type' => '请选择运输方式',
        'data.array' => '产品信息选择有误'
    ];
    protected $scene = [
        'all' => []
    ];
}