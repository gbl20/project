<?php
return [
    //table_name=>表名; orderid=>订单编号,默认 ‘orderid’;code=>编号(没有则不填);
    'order_id_type'=>[
        'FG' => ['title'=>'首营品种申请','table_name'=>'gsp_first_goods','code'=>'goods_code'],
        'FS' => ['title'=>'首营企业申请','table_name'=>'gsp_first_enterprise','code'=>'supplier_code'],
        'CK' => ['title'=>'仓库编码','table_name'=>'warehouse','code'=>'ware_code'],
        'WP' => ['title'=>'货位编码','table_name'=>'ware_position','code'=>'pos_code'],
        'JS' => ['title'=>'结算方式编码','table_name'=>'settlement','code'=>'code'],
        'CR' => ['title'=>'客户编号','table_name'=>'customer','code'=>'id'],
        'GD' => ['title'=>'商品编码','table_name'=>'commodity','code'=>'goods_code'],
        'PE' => ['title'=>'员工编号','table_name'=>'employee','code'=>'code'],
        'QH' => ['title'=>'缺货登记','table_name'=>'purchase_lack'],
        'JH' => ['title'=>'采购计划','table_name'=>'purchase_plan'],
        'PO' => ['title'=>'采购订单','table_name'=>'purchase_order'],
        'CH' => ['title'=>'采购合同','table_name'=>'purchase_contract'],
        'PC' => ['title'=>'来货登记','table_name'=>'purchase_register'],
        'CY' => ['title'=>'采购质量验收','table_name'=>'goods_check_accept'],
        'XY' => ['title'=>'销退质量验收','table_name'=>'goods_check_accept'],
        'LJ' => ['title'=>'来货拒收','table_name'=>'goods_rejection'],
        'IS' => ['title'=>'商品入库单','table_name'=>'stock_receive'],
        'CJ' => ['title'=>'采购结算单','table_name'=>'purchase_settle'],
        'AS' => ['title'=>'账面库存结存单','table_name'=>'accstock'],
        'XH' => ['title'=>'销售合同','table_name'=>'sales_contract'],
        'SS' => ['title'=>'销售报价单','table_name'=>'sel_speer'],
        'SO' => ['title'=>'销售订单','table_name'=>'sel_order'],
        'SE' => ['title'=>'销售开单','table_name'=>'sel_export'],
        'XJ' => ['title'=>'销售结算','table_name'=>'stock_out'],
        'OS' => ['title'=>'出库登记/复核','table_name'=>'sel_settle'],
        'AR' => ['title'=>'实物盘点单','table_name'=>'real_stocktak'],
        'TO' => ['title'=>'即时盘点单','table_name'=>'acconline'],
        'TW' => ['title'=>'整仓盘点单','table_name'=>'whole_stock'],
        'XS' => ['title'=>'销售收款','table_name'=>'sel_pay'],
        'XT' => ['title'=>'销售退回申请','table_name'=>'sel_ret_demand'],
        'XD' => ['title'=>'销售退回登记','table_name'=>'sel_ret_checkin'],
        'DO' => ['title'=>'质量疑问商品','table_name'=>'drug_locked'],
        'LS' => ['title'=>'冷藏药品销退收货登记','table_name'=>'sel_cold_storage'],
        'TR' => ['title'=>'销售发货运输登记','table_name'=>'trans_reg'],
        'TC' => ['title'=>'冷藏药品运输登记','table_name'=>'trans_reg_cold'],
        'CL' => ['title'=>'采购冷藏药品收货登记','table_name'=>'purchase_cold_storage'],


    ]
];
