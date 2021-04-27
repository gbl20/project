<?php
namespace app\finance\model;
use think\facade\Db;
use think\Model;
/**
 * 采购结算
 * @author wuzhonggui
 * @package app\finance\model
 */
class PurchaseSettle extends Model
{
    /**
     * 查询采购结算单列表
     * @param $data 请求参数
     */
    public static function getPurchaseSettleList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?10:intval($data['pageSize']);
        $where=[];
        $field='s.*,p.full_name';
        $order='s.create_date desc';
        $list=Db::name('purchase_settle')->alias('s')->field($field)
              ->join('providers p','p.supplier_code=s.sup_code','left')
              ->where($where)
              ->order($order)
              ->paginate(['list_rows'=>$pageSize,'page'=>$page])
              ->toArray();
        return $list;
    }
}