<?php

namespace app\erp\validate;
use think\Validate;

class GoodsCheckAcceptDtlVal extends Validate
{
    protected $rule = [
      'goods_code' => 'max:10',
      'unit'       => 'max:10',
      'amount'     => ['regex'=>'/^[1-9]\d{0,10}|\d.\d{0,5}[1-9]|\d$/'],
      'qualified_amount'  => ['regex'=>'/^[1-9]\d{0,10}|\d.\d{0,5}[1-9]|\d$/'],
      'rejection_amount'  => ['regex'=>'/^[1-9]\d{0,10}|\d.\d{0,5}[1-9]|\d$/'],
      'spot_check_amount' => ['regex'=>'/^[1-9]\d{0,10}|\d.\d{0,5}[1-9]|\d$/'],
      'price' => ['regex'=>'/^[1-9]\d{0,10}|\d.\d{0,6}[1-9]|\d$/'],
      'money' => ['regex'=>'/^[1-9]\d{0,10}|\d.\d{0,6}[1-9]|\d$/'],
      'batch' => 'max:20',
      'sterilization_batch' => 'max:20',
      'production_date'     => 'date',
      'production_end_date' => 'date',
      'verify_report' => 'max:20',
      'pass_gate_no'  => 'max:20',
      'quality_state' => 'max:30',
      'package_state' => 'max:30',
      'label_state'   => 'max:30',
      'directions'    => 'max:30',
      'check_verdict' => 'max:30',
      'checker'  => 'max:10',
      'accepter' => 'max:10',
      'remark'   => 'max:100',
      'come_orderid'   => 'max:18',
      'rejection_type' => 'max:30',
      'storage_type'   => 'max:20',
      'traceability_code' => 'max:20',
    ];

    protected $message = [
      'goods_code.max'=>  '商品编号长度过长',
      'unit.max'      =>  '商品单位长度过长',
      'amount.regex'  =>  '商品数量格式不正确',
      'qualified_amount.regex'  =>  '合格数量格式不正确',
      'rejection_amount.regex'  =>  '不合格数量格式不正确',
      'spot_check_amount.regex' =>  '抽检数量格式不正确',
      'price.regex' =>  '商品单价格式不正确',
      'money.regex' =>  '商品金额格式不正确',
      'batch.max'   =>  '生产批号/序列号长度过常',
      'sterilization_batch.max' =>  '灭菌批号长度过常',
      'production_date'   =>  '生产日期格式不正确',
      'production_end_date' =>  '有效期至格式不正确',
      'verify_report.max' =>  '药检报告长度过常',
      'pass_gate_no.max'  =>  '通关文号长度过常',
      'quality_state.max' =>  '外观质量长度过常',
      'package_state.max' =>  '包装情况长度过常',
      'label_state.max'   =>  '标签状况长度过常',
      'directions.max'    =>  '说明书状况长度过常',
      'check_verdict.max' =>  '验收结论长度过常',
      'checker.max' =>  '验货人长度过常',
      'accepter.max'=>  '收货人长度过常',
      'remark.max'  =>  '备注信息长度过常',
      'come_orderid.max'  =>  '来源单据号长度过常',
      'rejection_type.max'=>  '不合格处理方式长度过常',
      'storage_type.max'  =>  '储存条件长度过常',
      'traceability_code.max' =>  '追溯号长度过常',
    ];

    protected $scene = [
      'all'=>[]
    ];
}
