<?php

namespace app\ware\model;
use think\Model;

class StockReceiveDetails extends Model
{
    public static function GoodsPurchaseRecordList($data)
    {
      $field = 'd.orderid,d.goods_code,d.qty,d.price,d.amount,d.batchno,d.prod_date,d.valid_date,d.ware_code,d.pos_code,s.order_date,s.sales_code,s.sales_name,s.check_code,s.sup_code,s.sup_contact,w.ware_title,p.name as sup_name,p.full_name as sup_full_name';
      $where[] = ['d.goods_code','=',$data['goods_code']];
      $where[] = ['s.ischeck','=',1];
      $res = self::where($where)->alias('d')->field($field)
            ->join('stock_receive s','s.orderid=d.orderid','left')
            ->join('warehouse w','w.ware_code=d.ware_code','left')
            ->join('providers p','p.supplier_code=s.sup_code','left')
            ->order('s.order_date','asc')
            ->select()
            ->toArray();
      return ['status'=>1,'data'=>$res];
    }

    public static function GoodsSupplyHistoryList($data)
    {
      $where[] = ['d.goods_code','=',$data['goods_code']];
      $where[] = ['s.ischeck','=',1];
      $field = 'd.qty,d.unit,c.price1,s.order_date,s.sup_contact,p.name,p.full_name,p.mobile,p.tel,p.fax,p.bank_area,p.bank_account,p.address';
      $res = self::where($where)->alias('d')->field($field)
          ->join('stock_receive s','s.orderid=d.orderid','left')
          ->join('providers p','p.supplier_code=s.sup_code','left')
          ->join('commodity_price c','c.goods_code=d.goods_code and c.mode_id=8','left')
          ->group('s.sup_code')
          ->order('s.order_date','desc')
          ->select()
          ->toArray();
      return ['status'=>1,'data'=>$res];
    }
}
