<?php

namespace app\erp\validate;
use think\Validate;

class FirstGoodsImgVal extends Validate
{
    protected $rule = [
        'goods_code'    =>  ['require'],
        'img_name'      =>  ['require','max:255'],
        'file_name'     =>  ['require','max:255'],
        'validity_date' =>  ['require','date'],
    ];

    protected $message = [
        'goods_code.require'    =>  '商品编号不能为空',
        'img_name.require'      =>  '图片名称不能为空',
        'img_name.max'          =>  '图片名称超出限制',
        'file_name.require'     =>  '文件名不能为空',
        'file_name.max'         =>  '文件名超出限制',
        'validity_date.require' =>  '请选择有效期',
        'validity_date.date'    =>  '有效期格式不正确',
    ];


    protected $scene = [
        'all'=>[]
    ];

}
