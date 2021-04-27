<?php

namespace app\sales\validate;
use think\Validate;

class SelRetDemandVal extends Validate
{
  protected $rule = [
    'f_date'      =>['require'],
    'contract_no' =>['max:20','alphaDash'],
    'p_orderid'   =>['max:18','alphaNum'],
    'emp_no'      =>['require','max:10','alphaNum'],
    'cust_no'     =>['require','max:10','alphaNum'],
    'linkman'     =>['max:20','chsAlphaNum'],
    'linkman2'    =>['max:20','chsAlphaNum'],
    'goods_qty'   =>['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,4}[1-9]|\d$/'],
    'goods_sum'   =>['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,5}[1-9]|\d$/'],
    'tax_sum'     =>['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,5}[1-9]|\d$/'],
    'amount'      =>['regex'=>'/^[1-9]\d{0,9}|\d.\d{0,5}[1-9]|\d$/'],
    'remark'      =>['max:100','chsDash'],
    'fungible'    =>'integer',
    'abated'      =>'integer',
    'depart_id'   =>'integer',
    'o_type'      =>'integer',
  ];

  protected $message = [
    'f_date'                =>'申请日期不能为空！',
    'contract_no.max'       =>'合同编号不能超过20个字符！',
    'contract_no.alphaDash' =>'合同编号只能是字母和数字；下划线_及破折号！',
    'p_orderid.max'         =>'原订单编号长度不能超过18个字符！',
    'p_orderid.alphaNum'    =>'原订单编号只能是字母和数字！',
    'emp_no.require'        =>'业务员编号不能为空！',
    'emp_no.max'            =>'业务员编号长度不能超过10个字符！',
    'emp_no.alphaNum'       =>'业务员编号只能是字母和数字！',
    'cust_no.require'       =>'客户编号不能为空！',
    'cust_no.max'           =>'客户编号长度不能超过10个字符！',
    'cust_no.alphaNum'      =>'客户编号只能是字母和数字！',
    'linkman.max'           =>'采购人员不能超过20个字符！',
    'linkman.chsAlphaNum'   =>'采购人员只能是汉字、字母和数字！',
    'linkman2.max'          =>'联系人不能超过20个字符！',
    'linkman2.chsAlphaNum'  =>'联系人只能是汉字、字母和数字！',
    'goods_qty'   =>'货品总数格式不正确！',
    'goods_sum'   =>'货款格式不正确！',
    'tax_sum'     =>'税款格式不正确！',
    'amount'      =>'合计格式不正确！',
    'remark'      =>'订单备注不能超过100个字符！',
    'fungible.integer'    =>'代销收货格式不正确！',
    'abated.integer'      =>'格式不正确！',
    'depart_id.integer'   =>'开单部门格式不正确！',
    'o_type.integer'      =>'退货方式格式不正确！',
  ];

  protected $scene = [
    'all'=>[]
  ];
}
