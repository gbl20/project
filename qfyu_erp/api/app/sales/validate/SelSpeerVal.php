<?php
namespace app\sales\validate;
use think\Validate;

Class SelSpeerVal extends Validate{
    protected $rule = [
        'emp_no' => ['require'],
        'cust_no' => ['require'],
        'pay_mode_no' => ['require'],
        'details' => ['array','checkDetails']
    ];
    protected $message = [
        'emp_no' => '请选择业务员',
        'cust_no' => '请选择客户信息',
        'pay_mode_no' => '请选择结算方式',
        'details.array' => '产品信息提交有误'
    ];
    protected $scene = [
        'all' => []
    ];
    protected function checkDetails($value, $rule, $data = [], $name, $description)
    {
        $rule = true;
        foreach ($value as $k=>$v){
            if(floatval($v['qty']) <= 0){
                $rule = '项次'.$v['item_no'].'的数量输入有误';
                goto _end;
            }
            if(floatval($v['o_price']) <= 0){
                $rule = '项次'.$v['item_no'].'的价格输入有误';
                goto _end;
            }
        }
        _end:
        return $rule;
    }
}
