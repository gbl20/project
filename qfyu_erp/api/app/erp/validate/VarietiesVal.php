<?php
namespace app\erp\validate;
use think\Validate;

Class VarietiesVal extends Validate{
    protected $rule = [
        'goods_code' => ['require'],
        'price' => ['float'],
        'price2' => ['float'],
        'prov_goods_code' => ['alphaDash'],
        'is_valid' => 'in:0,1',
        'remark' => ['chsDash','max'=>100],
        'near_date' => 'date',
        'wtsxq_date' => 'date',
    ];
    protected $message = [
        'goods_code' => '请选择协议产品信息',
        'price' => '主单位协议价输入格式有误',
        'price2' => '幅单位协议价输入格式有误',
        'prov_goods_code' => '供方产品编号输入有误',
        'remark.chsDash' => '备注输入格式有误',
    ];
    protected $scene = [
        'all' => []
    ];
}