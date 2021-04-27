<?php
use think\facade\Route;
/**
 * 采购管理
 */
Route::group(function(){
    /**
     * 采购-缺货登记
     */
    Route::group(function () {
        Route::post('lackList','lackList'); //缺货登记单据列表
        Route::post('initLack','initLackDetail'); //新增、修改初始化
        Route::post('saveLackOrder','saveLackOrder'); //保存
        Route::post('checkLackOrder','checkLackOrder'); //审核
        Route::post('resetLackOrder','resetCheckLackOrder'); //还原
        Route::post('deleteLackOrder','deleteLackOrder'); //删除
        Route::post('transPlanOrder','transPlanOrder'); //转单（采购计划单）
    })->prefix('PurchaseLack/');
    /**
     * 采购计划
     */
    Route::group(function () {
        Route::post('planList','planList'); //采购计划单列表
        Route::post('initPlan','initAddPlan'); //新增、编辑初始化
        Route::post('savePlanOrder','savePlanOrder'); //保存
        Route::post('checkPlanOrder','checkOrder'); //审核
        Route::post('backPlanOrder','backOrder'); //还原
        Route::post('closePlanOrder','closeOrder'); //结案
        Route::post('deletePlanOrder','deleteOrder'); //删除
        Route::post('generateOrder','generateOrder'); //生成订单
    })->prefix('PurchasePlan/');
    /**
     * 采购合同
     */
    Route::group(function () {
        Route::post('chooseContractList','chooseContractList'); //选择合同
        Route::post('initContract','initContract'); //初始化采购合同
        Route::post('contractList','contractList'); //采购合同列表
        Route::post('saveContract','saveContract'); //保存采购合同
    })->prefix('PurchaseContract/');
    /**
     * 采购订单
     */
    Route::group(function () {
        Route::post('initPurOrder','initPurOrder'); //初始化
        Route::post('purOrderList','purOrderList'); //查询
        Route::post('savePurOrder','savePurOrder'); //保存
        Route::post('checkPurOrder','checkPurOrder'); //审核
        Route::post('backPurOrder','backPurOrder'); //还原
        Route::post('closePurOrder','closePurOrder'); //还原
        Route::post('deletePurOrder','deletePurOrder'); //删除
        Route::post('generateRegOrder','generateRegisterOrder'); //转单
    })->prefix('PurchaseOrder/');

    /** 来货登记 **/
    Route::group(function (){
        Route::post('getRegisterList','registerList');//来货登记列表
        Route::post('getRegisterDel','registerDel');//来货登记明细
        Route::post('addRegister','addRegister');//来货登记明细
        Route::post('getBillDetail','getBillDetail');//来货登记发票详情
        Route::post('editBill','editBill');//来货登记发票详情
        Route::post('checkRegister','checkRegister');//来货登记发票详情
    })->prefix('PurchaseRegisterInfo/');
    /** 质量验收 **/
    Route::group(function (){
        Route::post('getGoodsCheckDefault','checkDefault');
        Route::post('getQualityAllList','getQualityAllList');
        Route::post('editGoodsCheckDefault','editcheckDefault');
        Route::post('getGoodsCheckAcceptDtl','getGoodsCheckAcceptDtl');
        Route::post('checkQuality','checkQuality');
        Route::post('editGoodsCheckAccept','editGoodsCheckAccept');
        Route::post('delGoodsCheckAccept','delGoodsCheckAccept');
        Route::post('backGoodsCheckAccept','backGoodsCheckAccept');
    })->prefix('QualityAcceptance/');
    /** 来货拒收 **/
    Route::group(function (){
        Route::post('getGoodsRejectionList','getGoodsRejectionList');
        Route::post('getGoodsRejectionDtl','getGoodsRejectionDtl');
    })->prefix('GoodsRejectionInfo/');

})->middleware('Base');
