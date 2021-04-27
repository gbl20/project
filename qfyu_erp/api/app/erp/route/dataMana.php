<?php
use think\facade\Route;
/**
 * 资料管理
 */
Route::group(function(){
    /**
     * 企业、员工信息
     */
    Route::group(function () {
        Route::post('addCompany', 'addCompany');
        Route::post('branchList', 'branchList');
        Route::post('comDepart', 'comDepart');
        Route::post('employeeInit', 'employeeInit');
        Route::post('comEmployee', 'comEmployee');
    })->prefix('mana_data/');
    /**
     * 商品类别管理
     */
    Route::group(function () {
        Route::post('categoryInit','categoryInit');
        Route::post('getCustomList','getCustomList');
        Route::post('setKinds','setKinds');
        Route::post('delKinds','delKinds');
        Route::post('getDelKinds','getDelKinds');
        Route::post('setPermitKinds','setPermitKinds');
        Route::post('delPermitKinds','delPermitKinds');
        Route::post('editSmallPermitKind','editSmallPermitKind');
        Route::post('delSmallPermitKind','delSmallPermitKind');
        Route::post('addCustomKinds','addCustomKinds');
        Route::post('delCustomKinds','delCustomKinds');
        Route::post('getPopupKind','getPopupKind');
        Route::post('getGoodsCategory','getGoodsCategory');
    })->prefix('goods_category/');
    /**
     * 价格体系管理
     */
    Route::group(function () {
        Route::post('getPriceSystem','getList');
        Route::post('addOrUpdatePriceSystem','updateSystem');
        Route::post('delPriceSystem','delSystem');
    })->prefix('price_system/');
    /**
     * 商品资料管理
     */
    Route::group(function () {
        Route::post('getCommodityList','getCommodityList');
        Route::post('newCommodity','newCommodity');
        Route::post('checkerCommodity','checkerCommodity');
        Route::post('getPriceList','getPriceList');
        Route::post('editPrice','editPrice');
        Route::post('getGoodsPhoto','getGoodsPhoto');
        Route::post('delGoodsPhoto','delGoodsPhoto');
        Route::post('getCommodityInfo','getCommodityInfo');
        Route::post('chooseGoodsList','chooseGoodsList');
        Route::post('getGoodsWareList','getGoodsWareList');
        Route::post('addGoodsWare','addGoodsWare');
        Route::post('delGoodsWare','delGoodsWare');
        Route::post('getSalesCategoryList','getSalesCategoryList');
        Route::post('editSalesCategory','editSalesCategory');
        Route::post('delSalesCategory','delSalesCategory');
        Route::post('getGoodsQty','getGoodsQty');
        Route::post('getGoodsSalesAreaList','getGoodsSalesAreaList');
        Route::post('editSalesArea','editSalesArea');
        Route::post('getSellLimitList','getSellLimitList');
        Route::post('addCustomerLimit','addCustomerLimit'); //新增限制销售客户列表
        Route::post('editCustomerLimit','editCustomerLimit'); //编辑限制销售客户列表
        Route::post('delCustomerLimit','delCustomerLimit'); //删除限制销售客户列表
        Route::post('getGoodsBatchList','getGoodsBatchList');
        Route::post('editGoodsBatch','editGoodsBatch');
        Route::post('delGoodsBatch','delGoodsBatch');
        Route::post('addGoodsDrugReports','addGoodsDrugReports');
        Route::post('getGoodsDrugReports','getGoodsDrugReports');
    })->prefix('commodity_info/');
    /**
     * 供应商资料
     */
    Route::group(function () {
        Route::post('checkProv','checkProv');
        Route::post('chooseProvider','chooseProvider');
        Route::post('chooseSupsales','chooseSupsales');
        Route::post('getSupplier','getSupplier');
        Route::post('comSupplier','comSupplier');
        Route::post('examSupplier','examSupplier');
        Route::post('revokeSupplier','revokeSupplier');
        Route::post('getProGoods','getProGoods');
        Route::post('comVarieties','comVarieties');
        Route::post('getProSales','getProSales');
        Route::post('saveProSales','saveProSales');
        Route::post('setProSalesDefault','setProSalesDefault');
        Route::post('getRecords','getRecords');
        Route::post('saveRecords','saveRecords');
        Route::post('comProduced','comProduced');
        Route::post('getProduced','getProduced');
        Route::post('getProvPhoto','getProvPhoto');
        Route::post('comProvPhoto','comProvPhoto');
        Route::post('getProGrant','getProGrant');
        Route::post('comProvGrant','comProvGrant');
    })->prefix('Supplier/');
    /**
     * 仓库、库位管理
     */
    Route::group(function () {
        Route::post('ware_list','wareList'); //仓库列表
        Route::post('ware_init','wareInit'); //初始化
        Route::post('ware_save','wareSave'); //保存
        Route::post('ware_set','wareSet'); //启用、禁用
        Route::post('warepos_list','wpos_list'); //货位列表
        Route::post('warepos_save','wpos_save'); //货位保存
        Route::post('wareLockList','wareLockedList'); //查询盘点锁定信息
    })->prefix('WareHouseController/');
    /**
     *  结算方式管理
     */
    Route::group(function () {
        Route::post('settlementList','settlementList'); //结算方式列表
        Route::post('saveSettlement','saveSettlement'); //新增、编辑结算方式
    })->prefix('Settlement/');
    /**
     * 客户资料
     */
    Route::group(function () {
        Route::post('customerList','clist'); //客户资料列表
        Route::post('customerEdit','cedit'); //编辑客户资料/新增客户
        Route::post('selectCustomer','selcust'); //客户列表(弹出组件选择客户)
        Route::post('selectCustomerSales','CustomerSales'); //客户联系人(弹出组件选择客户联系人)
        Route::post('selectDelivery','seldelivery'); //线路列表(弹出组件选择客户)
        Route::post('selectArea','selarea'); //线路列表(弹出组件选择客户)
        Route::post('selectEmployee','selemp'); //员工列表(弹出组件选择员工)
        Route::post('selectDepart','seldepart'); //部门列表(弹出组件选择部门)
        Route::post('selectDdkind','selddkind'); //许可经营类别列表(弹出组件选择)
        Route::post('getCustDdk','getcustddk'); //获取已选择的经营类别名称
        Route::post('saveCust','save_customer'); //保存 新增/编辑 客户资料
        Route::post('custGoodsList','goods_list'); //获取客户协议品种
        Route::post('comCustGoods','savecustgoods'); //保存客户协议品种
        Route::post('delCustGoods','delcustgoods'); //删除客户协议品种
        Route::post('contactList','contact_list'); //获取客户联系人列表
        Route::post('editContact','editcontact'); //编辑联系人
        Route::post('delCustConcat','delcontact'); //删除联系人
        Route::post('defCustConcat','defaultcontact'); //设置默认联系人
        Route::post('saveCustContact','savecontact'); //保存编辑联系人
        Route::post('negList','neg_list'); //获取客户洽谈记录列表
        Route::post('saveBusiness','savebusiness'); //保存业务联系记录
        Route::post('delBusiness','delbusiness'); //删除业务联系记录
        Route::post('getCustPhoto','getcustphoto'); //查看证照
        Route::post('comCustPhoto','comcustphoto'); //保存证照
        Route::post('delCustPhoto','delcustphoto'); //删除证照
        Route::post('cimgList','cimg_list'); //获取客户证照图片列表
        Route::post('getCustomerLimit','getCustomerLimit'); //获取限制销售客户列表

    })->prefix('CustomerCon/');

    //地区资料
    Route::group(function (){
      Route::post('getAreaList','getAreaList');
      Route::post('editArea','editArea');
    })->prefix('AreaInfo/');

    //委托物流单位
    Route::group(function (){
      Route::post('comEntrust','comEntrust');
      Route::post('entrustList','entrustList');
      Route::post('chooseTrust','chooseTrust');


    })->prefix('EntrustCon/');


})->middleware('Base');
