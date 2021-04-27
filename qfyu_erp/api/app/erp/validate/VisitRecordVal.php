<?php
namespace app\erp\validate;
use think\Validate;

Class VisitRecordVal extends Validate{
    protected $rule = [
        'supplier_code' => ['require'],
        'f_date' => 'date',
        'subject' => ['max'=>50],
        'visit_place' => ['max'=>100],
        'visit_man' => ['chsDash','max'=>10],
        'content' => ['max'=>2000]
    ];
    protected $message = [
        'supplier_code' => '请求参数有误',
        'f_date' => '请选择联系日期',
        'subject' => '洽谈主题输入有误',
        'visit_place' => '方式或地点输入有误',
        'visit_man' => '对方洽谈人输入有误',
        'content' => '洽谈内容输入超上限'
    ];
    protected $scene = [
        'all' => []
    ];
}