<?php
namespace app\erp\validate;

use think\Validate;

class OperatorsVal extends Validate
{
    protected $rule = [
        'user' => ['require'],
        'passwd' => ['require', 'length'=>32,'alphaNum'],
        'login_acc' => ['require']
    ];
    protected $message = [
        'user' => '请输入有效的用户名',
        'passwd' => '请输入登录密码',
        'login_acc' => '请选择账套'
    ];
    protected $scene = [
        'all' => ['user', 'passwd', 'login_acc']
    ];
}