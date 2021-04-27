<?php
namespace app\erp\validate;
use think\Validate;

class PriceSystem extends Validate
{
    protected $rule = [
        'name'=> 'require|max:30',
        'remark'=> 'max:50',
        'status'=> 'number|between:0,1'
    ];

    protected $message = [
        'name.require' => '请输入价格体系名称',
        'name.max' => '价格体系名称最多不能超过30个字符',
        'remark.max' => '备注最多不能超过50个字符',
        'status.number' => '状态格式有误',
        'status.between' => '状态只能是0和1',
    ];

    protected $scene = [
      'all'=>['name','remark','status']
    ];
}
