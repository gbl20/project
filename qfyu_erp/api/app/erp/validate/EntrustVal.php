<?php
namespace app\erp\validate;
use app\helper\CheckIDCard;
use think\Validate;

Class EntrustVal extends Validate{
    protected $rule = [
        'company' => ['require'],
        'business_license|营业执照编号' => ['require'],
        'business_validity_date|营业执照有效期' => ['require','date'],
        'contract_validity_date|合同有效期' => ['require','date'],
        'card_id' => ['checkIdCard'=>'身份证号输入有误']
    ];
    protected $message = [
        'contact' => '请填写公司名称',
        'card_id' => '请填写联系人身份证号'
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
