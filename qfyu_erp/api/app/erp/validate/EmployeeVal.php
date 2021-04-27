<?php
namespace app\erp\validate;
use think\Validate;

Class EmployeeVal extends Validate{
    protected $rule = [
        'name' => ['require'],
        'card_id' => ['require'],
        'depart_name' => ['require'],
        'duties' => ['require'],
        'edu' => ['require'],
        'grad_date' => ['require','date'],
        'entry_date' => ['require','date'],
        'native_place' => ['require'],
        'profess' => ['require'],
        'phone' => ['require','regex'=>'/^1[\d+]{10}$/'],
        'urgent_phone' => ['require']
    ];
    protected $message = [
        'name' => '请输入有效的员工姓名',
        'card_id' => '请输入有效的身份证号',
        'depart' => '请选择的所在部门',
        'duties' => '请选择请选择职务',
        'edu' => '请选择学历',
        'grad_date' => '请选择有效的毕业时间',
        'entry_date' => '请选择有效的入职时间',
        'native_place' => '请输入籍贯信息',
        'profess' => '请填写专业',
        'phone' => '请填写正确的手机号',
        'urgent_phone' => '请填写紧急联系电话',
    ];
    protected $scene = [
        'all' => []
    ];
}
