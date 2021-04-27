<?php
namespace app\sales\validate;
use think\Validate;

Class ContractVal extends Validate{
    protected $rule = [
        'title' => ['require'],
        'cust_code' => ['require'],
        'sign_code' => ['require'],
        'file_path' => ['require']
    ];
    protected $message = [
        'title' => '请填写合同标题',
        'cust_code' => '请选择客户',
        'sign_code' => '请选择签约人',
        'file_path' => '请上传合同附件'
    ];
    protected $scene = [
        'all' => []
    ];
}
