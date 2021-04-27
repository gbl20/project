<?php
namespace app\erp\validate;
use think\Validate;

Class CustomerVal extends Validate{
    protected $rule = [
        'sname' => ['require'],
        'name' => ['require'],
        'comarea' => ['require'],
        'typebus' => ['require'],
        'opermode' => ['require'],
        'quacontril' => ['require'],
        'accoutbank' => ['require'],
        'bankid' => ['require'],
        'taxcode' => ['require'],
    ];
    protected $message = [
        'sname' => '请填写客户简称',
        'name' => '请填写客户全称',
        'comarea' => '请填写公司地址',
        'typebus' => '请选择企业类型',
        'opermode' => '请填写经营方式',
        'quacontril' => '请填写质量管理达标情况',
        'accoutbank' => '请填写开户银行',
        'bankid' => '请填写银行账号',
        'taxcode' => '请填写税号',
    ];
    protected $scene = [
        'all' => ['sname','name','comarea','typebus','opermode','quacontril','accoutbank','bankid','taxcode']
    ];
}