<?php
use think\facade\Route;
/**
 * 仓储物流
 */
Route::miss(function() {return '庆丰裕ERP欢迎您!';});
Route::group(function(){
    /**
     * 验收入库、复核
     */
    Route::group(function () {
        Route::post('stockReceiveList','stockReceiveList'); //复核单查询
        Route::post('initStockReceive','initStockReceive'); //初始化
        Route::post('saveStockReceive','saveStockReceive'); //审核
        Route::post('checkStockReceive','checkStockReceive'); //审核
        Route::post('backStockReceive','backStockReceive'); //还原
        Route::post('closeStockReceive','closeStockReceive'); //结案
        Route::post('setWare','setWare'); //设定收货仓
        Route::post('PurchaseRecordList','PurchaseRecordList'); //获取商品购进记录-已审核入库单明细
        Route::post('supplyHistoryList','supplyHistoryList'); //获取商品供货历史
    })->prefix('StockReceiveController/');

    /**
     * 库存盘点 账面结存单
     */
    Route::group(function () {
        Route::post('bookList','book_list'); //账面库存结存单列表
        Route::post('editAccstock','edit_accstock'); //编辑结存单
        Route::post('addAccstock','add_accstock'); //选择仓库 生成结存单
        Route::post('upAccstock','up_accstock'); //更新结存单
        Route::post('checkAccstock','check_accstock'); //审核结存单
        Route::post('delAccstock','del_accstock'); //删除结存单
        Route::post('invAccstock','inv_accstock'); //实物盘点单
        Route::post('saveAccstock','save_invaccstock'); //结存单分发成实物盘点单
        Route::post('getAddCfg','get_add_ccfg'); //获取发布结存单所需的配置
    })->prefix('Inventory/');

    /**
     * 库存盘点 实物盘点单
     */
    Route::group(function () {
        Route::post('realstock','real_list'); //实物盘点单列表
        Route::post('checkReal','check_real'); //实物盘点单审核
        Route::post('delRealstock','del_realstock'); //删除实物盘点单
        Route::post('editRealstock','edit_realstock'); //新增 编辑实物盘点单
        Route::post('upRealstock','up_realstock'); //保存新增/修改
    })->prefix('Realstock/');
    /**
     * 即时盘点单
     */
    Route::group(function () {
        Route::post('imList','imlist'); //即时盘点单列表
        Route::post('imStockList','stocklist'); //即时盘点单选择产品 调出库存记录
        Route::post('upAccOnline','upaccstock'); //即时盘点单选择产品 调出库存记录
        Route::post('editAcconline','edit_acconline'); //即时盘点单编辑
        Route::post('delAcconline','del_acconline'); //删除即时盘点单
        Route::post('checkAcconline','check_acconline'); //审核即时盘点单
        Route::post('delAccerr','del_accer'); //审核前删除库存变动的记录
    })->prefix('Immediate/');
    /**
     * 整仓盘点单
     */
    Route::group(function () {
        Route::post('wholeList','whole_list'); //整仓盘点单列表
        Route::post('addWhole','add_whole'); //新增整仓盘点
        Route::post('editWhole','edit_whole'); //编辑整仓盘点
        Route::post('upWhole','up_whole'); //保存整仓盘点
        Route::post('checkWhole','check_whole'); //整仓盘点单审核
        Route::post('delWhole','del_whole'); //删除整仓盘点单
    })->prefix('Whole/');

    /**
     * 商品出入库查询
     */
    Route::group(function () {
        Route::post('getInQtyList','getInQtyList'); //入库明细
        Route::post('getOutQtyList','getOutQtyList'); //出库明细
        Route::post('getQtyDetailList','getQtyDetailList'); //库存明细
        Route::post('getBatchPartQtyList','getBatchPartQtyList'); //分仓库存
        Route::post('getTotalQtyList','getTotalQtyList'); //总库存
    })->prefix('GoodsInOutController/');
    /**
     * 出库登记、复核
     */
    Route::group(function () {
        Route::post('getStockOutList','getStockOutList'); //出库登记复核单列表
        Route::post('getStockOutInfo','getStockOutInfo'); //出库登记复核单信息
        Route::post('saveStockOut','saveStockOut'); //保存
        Route::post('auditStockOrder','auditOrder'); //审核
        Route::post('backStockOrder','backOrder'); //还原
        Route::post('getSelOrderStock','getSelOrderStock');
    })->prefix('StockOutCon/');
    /**
     * 质量疑问商品
     */
    Route::group(function () {
        Route::post('stockList','stock_list');//库存列表
        Route::post('lockDrug','lock_drug');//锁定商品
        Route::post('lockList','lock_list');//锁定商品列表
        Route::post('dealList','deal_list');//待处理疑问产品列表
        Route::post('getDoubtCfg','get_cfg');//获取需要的配置项
        Route::post('unlock','unlock');//质量疑问商品解锁
    })->prefix('Doubt/');
    /**
     * 不合格药品
     */
    Route::group(function () {
        Route::post('reject','reject_list');//不合格药品报告确认表
        Route::post('checkReject','reject_check');//不合格药品报告审核
        Route::post('rejectBook','reject_book');//不合格药品台账
    })->prefix('Unqualified/');

})->middleware('Base');
