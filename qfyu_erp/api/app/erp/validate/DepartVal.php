<?php
namespace app\erp\validate;
use think\Validate;

Class DepartVal extends Validate{
    protected $rule = [
        'dept_name' => ['require'],
        'tel' => ['require', 'regex'=>'/^[\d+]{1,}([-]?[,]?[\d+]{1,})*$/'],
        'leader' => ['require']
    ];
    protected $message = [
        'dept_name' => '请填写部门名称',
        'tel' => '请输入部门联系电话',
        'leader' => '请输入部门负责人'
    ];
    protected $scene = [
        'all' => ['dept_name', 'tel', 'leader']
    ];
}