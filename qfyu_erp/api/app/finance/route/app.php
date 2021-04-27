<?php

use think\facade\Route;

/**
 * 财务管理
 */
Route::miss(function () {
  return '庆丰裕ERP欢迎您!';
});
Route::group(function () {
  /**
   * 采购结算
   */
  Route::group(function () {
    Route::post('pchSettleList', 'pchSettleList'); //采购结算列表

  })->prefix('PurchaseSettleController/');
  /**
   * 采购付款
   */
  Route::group(function () {
    Route::post('purchasePayList', 'purchasePayList'); //采购付款列表

  })->prefix('PurchasePayController/');

  Route::group(function () {
    Route::post('getSelSettleList', 'getSelSettleList'); //查询销售结算列表
    Route::post('getSelSettleDtl', 'getSelSettleDtl'); //查询销售结算明细
    Route::post('saveSelSettleInfo', 'saveSelSettleInfo'); //保存销售结算
    Route::post('checkSelSettle', 'checkSelSettle'); //审核销售结算
    Route::post('reductionSelSettle', 'reductionSelSettle'); //审核销售结算
    Route::post('delSelSettle', 'delSelSettle'); //删除销售结算
    Route::post('makeSelPay', 'makeSelPay'); //销售结算收款

  })->prefix('SelSettleCon/');

  Route::group(function (){
    Route::post('getSelPayList','getSelPayList');
    Route::post('getSelPayDtl','getSelPayDtl');
    Route::post('editSelPayDtl','editSelPayDtl');
    Route::post('delSelPay','delSelPay');
    Route::post('checkSelPay','checkSelPay');
    Route::post('backSelPay','backSelPay');

  })->prefix('SelPayCon/');


})->middleware('Base');
