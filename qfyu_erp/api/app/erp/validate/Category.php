<?php
namespace app\erp\validate;
use think\Validate;

class Category extends Validate
{
    protected $rule = [
        'id'    =>'number',
        'title' =>['require','chsAlphaNum','max:30'],
        'remark'=>'max:50'
    ];

    protected $message = [
        'id.number'     =>'请选择分类',
        'title.require' =>'请输入商品类别名称',
        'title.chsAlphaNum' =>'商品类别名称格式错误',
        'title.max'     =>'商品类别名称最多不能超过30个字符',
        'remark'        =>'备注最多不能超过50个字符'
    ];

    protected $scene = [
        'all'=>['id','title','remark']
    ];
}
