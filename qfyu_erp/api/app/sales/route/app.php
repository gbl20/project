<?php
use think\facade\Route;
/**
 * 销售管理
 */
Route::miss(function() {return '庆丰裕ERP欢迎您!';});

Route::group(function(){
    Route::post('upSalesContract', 'upload/upSalesContract');
    /**
     * 销售合同
     */
    Route::group(function () {
        Route::post('salesContractInit','salesContractInit');
        Route::post('comSalesContract','comSalesContract');
        Route::post('selContract','selContract');
    })->prefix('ContractCon/');
    /**
     * 销售报价单
     */
    Route::group(function () {
        Route::post('selSpeerList','QuotationList');
        Route::post('editSpeerInit','editSalesInit');
        Route::post('comSelSpeer','comSalesQuotation');
        Route::post('auditSelSpeer','auditSalesOrder');
        Route::post('reductionSelSpeer','reductionOrder');
        Route::post('transferSelSpeer','transferOrder');
    })->prefix('SelSpeerCon/');
    /**
     * 销售订单
     */
    Route::group(function () {
        Route::post('selOrderList','selOrderList');
        Route::post('editSelOrderInit','editSelOrderInit');
        Route::post('auditSelOrder','auditSelOrder');
        Route::post('reductionSelOrder','reductionSelOrder');
        Route::post('transferSelOrder','transferSelOrder');
        Route::post('comSelOrder','comSelOrder');
        Route::post('chooseBatchNo','chooseBatchNo');

    })->prefix('SelOrderCon/');
    /**
     * 销售开单
     */
    Route::group(function () {
        Route::post('selExportList','selExportList');
        Route::post('editSelExportInit','editSelExportInit');
        Route::post('auditSelExport','auditSelExport');
        Route::post('reductionSelExport','reductionSelExport');
        Route::post('transferSelExport','transferSelExport');
        Route::post('comSelExport','comSelExport');
        Route::post('getSelOrder','getSelOrder');
        Route::post('getSelOrderDtl','getSelOrderDtl');

    })->prefix('SelExportCon/');
    /**
     * 销售退回申请
     */
    Route::group(function () {
        Route::post('getSelRetDemandList','getSelRetDemandList');
        Route::post('getSelRetDemandDtl','getSelRetDemandDtl');
        Route::post('saveSelRetDemand','saveSelRetDemand');
        Route::post('checkSelRetDemand','checkSelRetDemand');
        Route::post('backSelRetDemand','backSelRetDemand');
        Route::post('delSelRetDemand','delSelRetDemand');
    })->prefix('SelRetDemandCon/');
    /**
     * 销售发货运输登记
     */
    Route::group(function () {
        Route::post('transRegList','transRegList');
        Route::post('chooseExOrder','chooseExOrder');
        Route::post('comTransReg','comTransReg');
        Route::post('transRegInit','transRegInit');
        Route::post('auditTransReg','auditTransReg');
    })->prefix('TransRegCon/');
    /**
     * 销售退回登记
     */
    Route::group(function () {
        Route::post('getSelRetCheckList','getSelRetCheckList');
        Route::post('getSelRetCheckDtl','getSelRetCheckDtl');
        Route::post('saveSelRetCheck','saveSelRetCheck');
        Route::post('delSelRetCheck','delSelRetCheck');
        Route::post('checkSelRetCheck','checkSelRetCheck');
        Route::post('backSelRetCheck','backSelRetCheck');
    })->prefix('SelRetCheckCon/');
    /**
     * 冷藏药品销退收货登记
     */
    Route::group(function () {
        Route::post('getSelColdStorageList','getSelColdStorageList');
        Route::post('getSelColdStorageDtl','getSelColdStorageDtl');
        Route::post('saveSelColdStorage','saveSelColdStorage');
        Route::post('delSelColdStorage','delSelColdStorage');
        Route::post('checkSelColdStorage','checkSelColdStorage');
        Route::post('backSelColdStorage','backSelColdStorage');
    })->prefix('SelColdStorageCon/');

    /**
     * 冷藏药品运输发货登记
     */
    Route::group(function () {
        Route::post('chooseColdTransItem','chooseColdTransItem');
        Route::post('transRegColdList','transRegColdList');
        Route::post('comTransRegCold','comTransRegCold');
        Route::post('transRegColdInit','transRegColdInit');

    })->prefix('TransRegColdCon/');
})->middleware('Base');
