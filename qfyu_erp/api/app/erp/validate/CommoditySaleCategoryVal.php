<?php

namespace app\erp\validate;
use think\Validate;

class CommoditySaleCategoryVal extends Validate
{
    protected $rule = [
      'goods_code' => 'require',
      'name'       => ['require','max:50'],
      'amount'     => 'integer',
      'start_date' => 'date',
      'end_date'   => 'date',
      'remark'     => 'max:200'
    ];

    protected $message = [
      'goods_code.require'      => '商品编号不能为空！',
      'name.require'            => '控销类别不能为空！',
      'name.max'                => '控销类别长度过长！',
      'amount.integer'          => '限购数量格式不正确！',
      'start_date.date'         => '限购开始日期格式不正确！',
      'end_date.date'           => '限购结束日期格式不正确！',
      'remark.max'              => '备注信息长度过长！'
    ];

    protected $scene = [
      'all'=>[]
    ];
}
