<?php
namespace app\sales\model;
use think\Model;

Class SelExportDtl extends Model{
  public static function custOrderDtl($data)
  {
    $field = 'd.id,d.orderid,d.goods_code,s.f_date,c.name,c.dosage,d.unit,c.pym,c.code,d.qty,d.o_price,d.tax_rate,d.un_tax_price,d.goods_sum,d.tax_sum,d.amount,d.gift_qty,d.prod_date,d.valid_date,d.prov_no,d.settle_qty,c.production,c.approval_code,d.item_no,c.specs,c.packspecs,d.rebate,d.price,c.origin,d.cust_goods_code,d.paid_up,d.ret_qty,d.batch_no,wa.ware_title,d.ware_code,d.berth_no,w.storage_type,c.gsp_type,c.is_supervise,d.ref_cost_price,d.ref_cost,p.full_name as prov_name,p.drug_license';
    $res = self::where('d.orderid','in',$data['orderid'])->alias('d')
          ->field($field)
          ->join('sel_export s','s.orderid=d.orderid','left')
          ->join('commodity c','c.goods_code=d.goods_code','left')
          ->join('commodity_warehouse w','w.goods_code=d.goods_code','left')
          ->join('warehouse wa','wa.ware_code=d.ware_code','left')
          ->join('providers p','p.supplier_code=d.prov_no','left')
          ->order('d.orderid','ASC')
          ->select()
          ->toArray();
    return ['status'=>1,'data'=>$res];
  }
}
