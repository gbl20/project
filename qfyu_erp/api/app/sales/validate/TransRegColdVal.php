<?php
namespace app\sales\validate;
use think\Validate;

Class TransRegColdVal extends  Validate{
    protected $rule = [
        'ship_type' => ['require'],
        'ship_tool' => ['require'],
        'data' => ['array']
    ];
    protected $message = [
        'ship_type' => '请选择运输方式',
        'ship_tool' => '请选择运输工具',
        'data.array' => '产品信息选择有误'
    ];
    protected $scene = [
        'all' => []
    ];
}