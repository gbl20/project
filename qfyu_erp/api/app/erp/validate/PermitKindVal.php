<?php

namespace app\erp\validate;
use think\Validate;

class PermitKindVal extends Validate
{
    protected $rule = [
        'name'  =>['require','max:50'],
        'remark'=>['max:100']
    ];

    protected $message = [
        'name.require' => '请输入经营类别名称！',
        'name.max'     => '经营类别名称不能超过50个字符！',
        'remark.max'   => '备注不能超过100个字符！',
    ];

    protected $scene = [
      'all'=>['name','remark']
    ];
}
