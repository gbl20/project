<?php
namespace app\ware\model;
use think\Model;

Class StockOutDtl extends Model{
  public static function orderStockDtl($search)
  {
    $field = 'd.orderid,d.item_no,d.goods_code,d.unit,d.qty,d.price,d.amount,d.pos_code,d.prov_no,d.batch_no,d.prod_date,d.valid_date,d.p_order_no,d.p_item_no,c.name,c.code,c.pym,c.specs,c.origin,c.production,c.maker,c.dosage,c.approval_code,c.gsp_type,c.is_supervise';
    $where[] = ['d.p_order_no','in',$search];
    $data = self::where($where)->alias('d')->field($field)
          ->join('commodity c','c.goods_code=d.goods_code','left')
//          ->join('warehouse w','w.eare_code=d.ware_code','left')
          ->order('d.orderid','ASC')
          ->select()
          ->toArray();
    return ['status'=>1,'data'=>$data];
  }
}
