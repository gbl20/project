<?php

namespace app\finance\validate;
use think\Validate;

class SelSettleVal extends Validate
{
  protected $rule = [
    'orderid'           => ['required','max:18'],
    'f_date'            => 'date',
    'in_out_kind'       => 'integer',
    'cust_no'           => ['required','max:8'],
    'link_man'          => 'max:20',
    'company_name'      => 'max:80',
    'telephone'         => 'max:40',
    'address'           => 'max:120',
    'account_bank'      => 'max:80',
    'account_no'        => 'max:30',
    'tax_no'            => 'max:40',
    'invoice_type'      => 'integer',
    'invoice_date'      => 'date',
    'invoice_no'        => 'max:50',
    'yw_dept_id'        => 'integer',
    'emp_no'            => 'max:8',
    'goods_qty'         => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'goods_sum'         => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'tax_sum'           => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'amount'            => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'pay_mode_no'       => 'max:8',
    'pay_date'          => 'date',
    'gather_at_once'    => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'is_transfer'       => 'integer',
    'remark'            => 'max:40',
    'flag'              => 'max:20',
    'dept_id'           => 'integer',
    'makeupfor_amount'  => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'warrant_no'        => 'max:30',
    'invoice_id'        => 'max:22',
    'invoice_money'     => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,6}[1-9]|\d$/'],
    'contacts'          => 'max:20'
  ];

  protected $message = [
    'orderid'             => '销售订单号有误！',
    'f_date'              => '销售结算日期格式不正确！',
    'in_out_kind.integer' => '结算类型格式不正确！',
    'cust_no'           => '客户编号有误！',
    'link_man'          => '客户采购人员长度不能超过20个字符！',
    'company_name'      => '发票抬头长度不能超过80个字符！',
    'telephone'         => '发票电话号码长度不能超过40个字符！',
    'address'           => '发票地址长度不能超过120个字符！',
    'account_bank'      => '开户行长度不能超过80个字符！',
    'account_no'        => '帐号长度不能超过30个字符！',
    'tax_no'            => '税号长度不能超过40个字符！',
    'invoice_type'      => '发票类型格式不正确！',
    'invoice_date'      => '发票日期格式不正确！',
    'invoice_no'        => '发票号码长度不能超过50个字符！',
    'yw_dept_id'        => '业务部门格式不正确！',
    'emp_no'            => '经手人长度不能超过8个字符！',
    'goods_qty'         => '货品总数格式不正确！',
    'goods_sum'         => '无税金额（货款）格式不正确！',
    'tax_sum'           => '税款格式不正确！',
    'amount'            => '合计格式不正确！',
    'pay_mode_no'       => '付款方式长度不能超过8个字符！',
    'pay_date'          => '付款日期格式不正确！',
    'gather_at_once'    => '现收金额格式不正确！',
    'is_transfer'       => '过账格式不正确！',
    'remark'            => '备注长度不能超过40个字符！',
    'flag'              => '标志信息长度不能超过20个字符！',
    'dept_id'           => '开单部门格式不正确！',
    'makeupfor_amount'  => '退补差价合计格式不正确！',
    'warrant_no'        => '凭证号长度不能超过30个字符！',
    'invoice_id'        => '发票轨号长度不能超过22个字符！',
    'invoice_money'     => '发票总金额格式不正确！',
    'contacts'          => '联系人长度不能超过20个字符！'
  ];

  protected $scene = [
    'all'=>[]
  ];

}
