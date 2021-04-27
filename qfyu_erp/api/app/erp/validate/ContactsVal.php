<?php
namespace app\erp\validate;
use app\helper\CheckIDCard;
use think\Validate;

Class ContactsVal extends Validate{
    protected $rule = [
        'user_name' => ['require'],
        'id_card' => ['require','checkIdCard'=>'身份证号输入有误'],
        'phone' => ['regex'=>'/^1[\d+]{10}$/'],
        'qq' => ['regex'=>'/^[\d+]{2,15}$/']
    ];
    protected $message = [
        'user_name' => '请输入姓名',
        'id_card' => '身份证号必填',
        'phone' => '手机号格式输入有误',
        'qq' => 'qq格式输入有误'
    ];
    protected $scene = [
        'all' => []
    ];
    protected function checkIdCard($value, $rule, $data = [], $name, $description)
    {
        $checkRes = CheckIDCard::isCard($value);
        if(!$checkRes){
            return $rule;
        }else {
            return true;
        }
    }
}
