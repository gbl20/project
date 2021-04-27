<?php
namespace app\ware\validate;
use think\facade\Db;
use think\Validate;
/**
 * 采购入库、复核详情验证器类
 * @author wuzhogngui
 * @license 2020-12-10
 */
class StockReceiveDetailsValid extends Validate
{
    //验证规则
    protected $rule =   [
        'goods_code'=>['require','checkGoods'],
        'qty'=>'checkQty',
        'giftqty'=>['regex'=>'/^(\d{0,9}\.(\d{0,5}))$|^\d{0,9}$/'],
        'batchno'=>"require",
        'prod_date'=>'checkProDate',
        'ware_code'=>['checkWareEffective'],
        'unit'=>'require',
    ];

    //验证信息
    protected $message = [
        'goods_code.require'=>'商品资料信息不正确',
        'batchno.require'=>'请完善商品明细中的生产批号',
        'giftqty.regex'=>'请正确填写商品明细中赠品数量',
        'unit.require' => '商品明细中有未设置商品单位信息'
    ];

    //验证场景
    protected $scene = [
        'all'=>['goods_code','qty','giftqty','batchno','prod_date','ware_code','unit']
    ];

    /**
     * 检测商品资料
     * @param $value
     * @param $rules
     * @param $data
     */
    protected function checkGoods($value,$rules,$data){
        $goods=Db::name('commodity_buyer')->field('is_buyer')->where(['goods_code'=>$value])->find();
        if($goods==null){return "商品资料信息不正确";}
        if(intval($goods['is_buyer'])==1){
            return "商品明细【{$value}】已被暂停采购，操作失败";
        }
        return true;
    }
    /**
     * 校验库存数量
     * @param $value
     * @param $data
     */
    protected function checkQty($value,$rule,$data){
        $isQty='/^(\d{0,9}\.(\d{0,5}))$|^\d{0,9}$/';
        if(!preg_match($isQty,$value) || bccomp($value,'0',5)<=0){
            return "请正确完善商品明细中数量";
        }
        return true;
    }
    /**
     * 检测生产日期
     * @param $value
     * @param $data
     */
    protected function checkProDate($value,$rule,$data){
        if(empty($value) || strtotime($value)>time()){
            return "请完善商品明细中的生产日期(注意：生产日期不能大于当前日期)";
        }
        return true;
    }
    /**
     * 检测收货仓信息
     * @param $value
     * @param $data
     */
    protected function checkWareEffective($value,$rule,$data){
        if(empty($value) || empty($data['pos_code'])){return "请完善商品明细中的收货仓库";}
        $ware=Db::name('warehouse')->field('ware_code')->where(['ware_code'=>$value])->find();
        if($ware==null){return "请完善商品明细中的收货仓库";}
        $map[]=['ware_code','=',$value];
        $map[]=['pos_code','=',$data['pos_code']];
        $pos=Db::name('ware_position')->field('pos_code')->where($map)->find();
        if($pos==null){
            return "请完善商品明细收货仓库的货位";
        }
        return true;
    }
}