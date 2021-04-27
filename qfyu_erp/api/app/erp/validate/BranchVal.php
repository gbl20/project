<?php
namespace app\erp\validate;
use think\Validate;

Class BranchVal extends Validate{
    protected $rule = [
        'dept_name' => ['require'],
        'tel' => ['require', 'regex'=>'/^[\d+]{1,}([-]?[,]?[\d+]{1,})*$/'],
        'leader' => ['require'],
        'address' => ['require'],
        'business_license' => ['require']
    ];
    protected $message = [
        'dept_name' => '请填写公司名称',
        'tel' => '请输入公司联系电话',
        'leader' => '请输入公司负责人',
        'address' => '请输入公司机构地址',
        'business_license' => '请输入营业执照'
    ];
    protected $scene = [
        'all' => []
    ];
}
