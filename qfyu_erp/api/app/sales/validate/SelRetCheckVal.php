<?php

namespace app\sales\validate;
use think\Validate;

class SelRetCheckVal extends Validate
{
  protected $rule = [
    "f_date"      => ['require'],
    "contract_no" => ['max:20'],
    "p_orderid"   => ['max:18'],
    "emp_no"      => ['require','max:10'],
    "cust_no"     => ['require','max:10'],
    "linkman"     => ['max:20'],
    "linkman2"    => ['max:20'],
    "goods_qty"   => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,4}\d$/'],
    "goods_sum"   => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,5}\d$/'],
    "tax_sum"     => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,5}\d$/'],
    "amount"      => ['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,5}\d$/'],
    "remark"      => 'max:100',
    "pay_mode_no" => 'max:10',
    "consignee1"  => 'max:10',
    "consignee2"  => 'max:10'
  ];

  protected $message  = [
    "f_date.require"  => '登记日期不能为空！',
    "contract_no.max" => '合同编号不能超过20个字符！',
    "p_orderid.max"   => '原发货单号不能超过18个字符！',
    "emp_no.require"  => '业务员不能为空！',
    "emp_no.max"      => '业务员编号不能超过10个字符！',
    "cust_no.require" => '客户不能为空！',
    "cust_no.max"     => '客户编号不能超过10个字符！',
    "linkman.max"     => '采购员不能超过20个字符！',
    "linkman2.max"    => '联系人不能超过20个字符！',
    "goods_qty.regex" => '货品总数格式不正确！',
    "goods_sum.regex" => '货款格式不正确！',
    "tax_sum.regex"   => '税款格式不正确！',
    "amount.regex"    => '合计格式不正确！',
    "remark.max"      => '备注信息不能超过100个字符！',
    "pay_mode_no.max" => '结算方式不能超过10个字符！',
    "consignee1.max"  => '第一收货人不能超过10个字符！',
    "consignee2.max"  => '第二收货人不能超过10个字符！'
  ];

  protected $scene = [
    'all'=>[]
  ];
}
