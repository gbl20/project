<?php
namespace app\sales\validate;
use think\Validate;

Class SelOrderVal extends Validate{
    protected $rule = [
        'emp_no' => ['require'],
        'cust_no' => ['require'],
        'pay_mode_no' => ['require'],
        'begin_date' => ['require'],
        'end_date' => ['require'],
        'details' => ['array','checkDetails']
    ];
    protected $message = [
        'emp_no' => '请选择业务员',
        'cust_no' => '请选择客户信息',
        'pay_mode_no' => '请选择结算方式',
        'begin_date' => '请选择生效日期',
        'end_date' => '请选择失效日期',
        'details.array' => '产品信息选择有误'
    ];
    protected $scene = [
        'all' => []
    ];
    protected function checkDetails($value, $rule, $data = [], $name, $description)
    {
        $rule = true;
        foreach ($value as $k=>$v){
            $itemNo = $v['item_no']?$v['item_no']:($k+1);
            if(floatval($v['s_qty']) <= 0){
                $rule = '项次'.$itemNo.'的数量输入有误';
                goto _end;
            }
            if(floatval($v['s_o_price']) <= 0){
                $rule = '项次'.$itemNo.'的价格输入有误';
                goto _end;
            }
        }
        _end:
        return $rule;
    }
}
