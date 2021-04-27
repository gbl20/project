<?php

namespace app\erp\validate;
use think\Validate;

class PurchaseRegisterVal extends Validate
{
    protected $rule = [
        "receiving_date"        => "date",
        "o_orderid"             => "max:20",
        "transport_type"        => "max:30",
        "transport_equipment"   => "max:20",
        "car_number"            => "max:7",
        "supplier_code"         => ['require','max:10'],
        "contract_no"           => "max:20",
        "pay_type"              => ['require','max:20'],
        "supplier_remark"       => "max:50",
        "supplier_orderid"      => "max:20",
        "transport_certificate" => "max:20",
        "serial_number"         => "max:20",
        "hours"                 => ['integer','max:10'],
        "temperature"           => "max:30",
        "supplier_depart"       => "max:10",
        "cnee_code1"            => 'max:10',
        "cnee_code2"            => "max:10",
        "total_amount"          => ['regex:/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]|\d$/'],
        "total_money"           => ['regex:/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]|\d$/'],
        "taxes"                 => ['regex:/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]|\d$/'],
        "total_payprice"        => ['regex:/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]|\d$/'],
        "remark"                => "max:50",
    ];

    protected $message = [
        "receiving_date"            => "",
        "receiving_time"            => "",
        "o_orderid.max"             => "采购订单单据编号长度超出限制",
        "transport_type.max"        => "运输方式",
        "transport_equipment.max"   => "运输设备",
        "car_number.max"            => "运输车牌号",
        "supplier_code.require"     => "请选择供应商",
        "supplier_code.max"         => "供应商编号长度超出限制",
        "contract_no.max"           => "合同号长度超出限制",
        "pay_type.require"          => "请选择结算方式",
        "pay_type.max"              => "结算方式长度过长",
        "supplier_remark.max"       => "供应商备注长度超出限制",
        "supplier_orderid.max"      => "供方销售单号长度超出限制",
        "transport_certificate.max" => "特殊品运输证长度超出限制",
        "serial_number.max"         => "流水号长度超出限制",
        "hours.integer"             => "运途时间只能是整数",
        "hours.max"                 => "运途时间长度不能超过10个字符",
        "temperature.max"           => "温度控制状况长度超出限制",
        "supplier_depart.max"       => "供方部门长度超出限制",
        "cnee_code1.max"            => "第一收货人长度超出限制",
        "cnee_code2.max"            => "第二收货人长度超出限制",
        "total_amount.regex"        => "货品总数格式错误",
        "total_money.regex"         => "货款格式错误",
        "taxes.regex"               => "税款格式错误",
        "total_payprice.regex"      => "合计格式错误",
        "remark.max"                => "备注信息长度不能超过50个字符"
    ];

    protected $scene = [
        'all'=>[]
    ];
}
