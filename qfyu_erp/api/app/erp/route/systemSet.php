<?php

use think\facade\Route;

/**
 * 系统设置
 */
Route::group(function () {
  Route::group(function () {
    Route::post('login', 'login');
    Route::post('welInit', 'welInit');
    Route::post('getMenu', 'getMenu');
    Route::post('initApp', 'initApp');
    Route::post('verifyPlan', 'verifyPlan');
  })->prefix('index/');
  /**
   * 权限管理
   */
  Route::group(function () {
    Route::post('powerInit', 'powerInit');
    Route::post('editOp', 'editOp');
    Route::post('editRole', 'editRole');
    Route::post('setPower', 'setPower');
    Route::post('setOpRole', 'setOpRole');
    Route::post('setOpPost', 'setOpPost');
  })->prefix('power/');

  Route::group(function () {
    Route::post('getReferenceDataInit', 'getReferenceDataInit');


  })->prefix('ConfigSet/');

})->middleware('Base');
