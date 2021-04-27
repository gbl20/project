<?php
namespace app\ware\validate;
use think\Validate;

class AcconlineValid extends Validate
{
    //验证规则
    protected $rule =   [
        'empno'=>['require'],
        'ware_code'=>['require'],
        //审核验证
        'goods_code'=>['require'],
        'pos_code'=>['require'],
        'price'=>['require','egt:0'],
        'rqty'=>['require','egt:0'],
        'batch_no'=>['require'],
        'prod_date'=>['require','compareNow'],
        'sup_code'=>['require'],
    ];
    //验证信息
    protected $message = [
        'empno'=>'请选择经手人',
        'ware_code'=>'请选择盘点仓库',
        //审核验证
        'goods_code'=>'产品信息错误',
        'pos_code'=>'没有填写盘点货位',
        'price.require'=>'没有填写单价',
        'price.egt'=>'单价小于0',
        'rqty.require'=>'没有填写主单位实数',
        'rqty.egt'=>'主单位实数小于0',
        'batch_no'=>'没有填写产品批次号',
        'prod_date.require'=>'没有填写产品生产日期',
        'prod_date.compareNow'=>'生产日期大于当前日期',
        'sup_code'=>'没有填写供应商',
    ];

    //验证场景
    protected $scene = [
        'all'=>['empno','ware_code'],
        'exam'=>['goods_code','pos_code','price','qty','batch_no','sup_code','prod_date']
    ];

    /**
     * 跟当前时间比较
     * 小于等于当前时间返回true
     * 大于当前时间返回false
     */
    protected function compareNow($date){
        $time1=strtotime($date);
        $time_now=time();
        if($time1>$time_now) return false;
        else return true;
    }
}