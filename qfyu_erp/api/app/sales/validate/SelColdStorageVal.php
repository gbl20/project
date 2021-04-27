<?php
namespace app\sales\validate;
use think\Validate;

class SelColdStorageVal extends Validate
{
  protected $rule = [
    'orderid'       => ['require','max:18'],
    'f_date'        => ['date'],
    'trans_type'    => 'max:20',
    'license_plate' => 'max:40',
    'driver'        => 'max:20',
    'shipper'       => 'max:20',
    'deliveryman'   => 'max:20',
    'emp_no'        => 'max:10',
    'p_orderid'     => 'max:18',
    'remark'        => 'max:100',
    'transport'     => ['regex'=>'/^[1-9]\d{0,8}|\d.{0,2}\d$/'],
    'device'        => 'max:20',
    'temperature'   => 'max:50',
    'transport_certificate' => 'max:40',
  ];

  protected $message = [
    'orderid'       => '订单号不能为空!',
    'f_date'        => '登记日期格式不正确!',
    'trans_type'    => '运输方式长度不能超过20个字符!',
    'license_plate' => '车牌号长度不能超过40个字符!',
    'driver'        => '送货司机长度不能超过20个字符!',
    'shipper'       => '收货员长度不能超过20个字符!',
    'deliveryman'   => '客户送货人长度不能超过20个字符!',
    'emp_no'        => '经手人长度不能超过10个字符!',
    'p_orderid'     => '销退登记单号长度不能超过18个字符!',
    'remark'        => '备注长度不能超过100个字符!',
    'transport'     => '运途时间格式不正确!',
    'device'        => '运输设备长度不能超过20个字符!',
    'temperature'   => '温度状况长度不能超过50个字符!',
    'transport_certificate' => '特殊运输证长度不能超过40个字符!',
  ];

  protected $scene = [
    'all'=>[]
  ];
}
