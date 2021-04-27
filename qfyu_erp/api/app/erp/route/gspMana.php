<?php
use think\facade\Route;
/**
 * GSP 管理
 */
Route::group(function(){
    Route::post('enterPriseUpload', 'upload/EnterPriseUpload');
    Route::post('firstGoodsUpload','upload/firstGoodsUpload');
    Route::post('custImgUpload','upload/custImgUpload');
    Route::post('drugUoload','upload/drugUoload');
    /**
     * 首营企业管理
     */
    Route::group(function () {
        Route::post('editEnterpriseInit', 'editEnterpriseInit');
        Route::post('saveEnterprise', 'saveEnterprise');
        Route::post('enterpriseList', 'enterpriseList');
        Route::post('saveContacts', 'saveContacts');
        Route::post('examEnterprise', 'examEnterprise');
    })->prefix('editEnterprise/');
    /**
     * 首营商品管理
     */
    Route::group(function () {
        Route::post('firstGoodsInfoUpload','firstGoodsInfoUpload');
        Route::post('firstGoodsImgDel','firstGoodsImgDel');
        Route::post('getFirstGoodsList','getFirstGoodsList');
        Route::post('getGspCategory','getGspCategory');
        Route::post('addFirstGoods','addFirstGoods');
        Route::post('checkFirstGoods','checkFirstGoods');
        Route::post('admCheckFirstGoods','admCheckFirstGoods');
        Route::post('getFirstGoods','getFirstGoods');
        Route::post('getComFirstGoodsList','comFirstGoodsList');
        Route::post('getFirstGoodsPhoto','getFirstGoodsPhoto');
    })->prefix('gsp/');
    /**
     * 首营信息审批流
     */
    Route::post('approvalProExam', 'approvalProcess/exam');
    /**
     * 客户资质审核
     */
    Route::group(function () {
        Route::post('examList','exam_list');
    })->prefix('custExam/');

})->middleware('Base');
