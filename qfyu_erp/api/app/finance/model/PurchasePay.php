<?php
namespace app\finance\model;
use think\facade\Db;
use think\Model;
/**
 * 采购付款单
 * @author wuzhonggui
 * @package app\finance\model
 */
class PurchasePay extends Model
{
    /**
     * 查询采购付款单列表
     */
    public static function getPurchasePay($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?10:intval($data['pageSize']);
        $where=[];
        $field='a.*,p.full_name';
        $order='a.create_date desc';
        $list=Db::name('purchase_pay')->alias('a')->field($field)
            ->join('providers p','p.supplier_code=a.sup_code','left')
            ->where($where)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])
            ->toArray();
        return $list;
    }


}