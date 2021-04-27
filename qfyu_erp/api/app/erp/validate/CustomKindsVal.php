<?php

namespace app\erp\validate;
use think\Validate;

class CustomKindsVal extends Validate
{
    protected $rule = [
        'name'          =>  ['require','chsDash','max'=>30],
        'parent_kid'    =>  ['array'],
        'chlid_kid'     =>  ['array']
    ];

    protected $message = [
        'name.require'          =>  '请填写自定义名称',
        'name.chsDash'          =>  '自定义名称只能是汉字、字母、数字和下划线_及破折号-',
        'name.max'              =>  '自定义名称不能超过30个字符',
        'parent_kid.array'      =>  '请选择许可经营大类类别',
        'chlid_kid.array'       =>  '请选择许可经营小类类别',
    ];

    protected $scene = [
      'all'=>[]
    ];
}
