<?php
namespace app\erp\controller;
use app\BaseController;
use app\helper\CommonFun;
use app\erp\model\DbWork;
use app\erp\model\EnterprisePhoto;
use app\erp\model\Providers;
use app\erp\model\ProvidersAuthVariety;
use app\erp\model\ProvidersGoods;
use app\erp\model\ProvidersSales;
use app\erp\model\ProvidersSelfGoods;
use app\erp\model\ProvidersVisitRecord;
use app\erp\model\Settlement;
use think\facade\Config;
use think\facade\Db;

Class Supplier extends BaseController{
    public function getSupplier(){
        $res = ['status'=>0,'msg'=>'init error'];
        $ProvidersData = Providers::getSupplier();
        $provData = DbWork::queryList('prov_kind');
        $res = ['status'=>1,'providers_data'=>$ProvidersData,'prov_data'=>$provData];
        return $res;
    }
    /** 保存供应商数据 */
    public function comSupplier(){
        return Providers::comSupplier($this->request->data,$this->request->code);
    }

    /** 撤销 */
    public function revokeSupplier(){
        return Providers::revokeSupplier($this->request->data,$this->request->code);
    }
    /** 审核 */
    public function examSupplier(){
        return Providers::examSupplier($this->request->data,$this->request->code);
    }
    /**
     * 选择供应商-列表
     */
    public function chooseProvider(){
        $list=Providers::chooseProvidersList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /**
     * 检测供应商资料信息
     */
    public function checkProv(){
        $result=Providers::checkProv($this->request->data);
        exit(json_encode($result));
    }
    /** 获取协议品种 */
    public function getProGoods(){
        return ProvidersGoods::getProGoods($this->request->data);
    }
    /** 编辑添加协议品种 */
    public function comVarieties(){
        return ProvidersGoods::comVarieties($this->request->data,$this->request->code);
    }
    /**
     * 选择供方销售人员（联系人）
     */
    public function chooseSupsales(){
        $list=Providers::chooseSupSalesList($this->request->data);
        $result=['status'=>1,'msg'=>'success','list'=>$list];
        exit(json_encode($result));
    }
    /** 查询供方联系人 */
    public function getProSales(){
        return ProvidersSales::getProSales($this->request->data);
    }
    /** 保存供方联系人信息 */
    public function saveProSales(){
        return ProvidersSales::saveProSales($this->request->data,$this->request->code);
    }
    /** 设置默认联系人 */
    public function setProSalesDefault(){
        return ProvidersSales::setProSalesDefault($this->request->data,$this->request->code);
    }
    /** 保存业务联系记录 */
    public function saveRecords(){
        return ProvidersVisitRecord::saveRecords($this->request->data,$this->request->code);
    }
    /** 业务联系记录 */
    public function getRecords(){
        return ProvidersVisitRecord::getRecords($this->request->data);
    }
    /** 自产商品列表 */
    public function getProduced(){
        return ProvidersSelfGoods::getProduced($this->request->data);
    }
    /** 保存自产商品 */
    public function comProduced(){
        return ProvidersSelfGoods::comProduced($this->request->data);
    }
    /** 证照图片 */
    public function getProvPhoto(){
        $data = CommonFun::ProcessingData($this->request->data);
        $photoList = EnterprisePhoto::queryImgList(1,$data['supplier_code']);
        return ['status'=>1,'data'=>$photoList];
    }
    /** 保存证照信息 */
    public function comProvPhoto(){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $data = $this->request->data;
        $data = CommonFun::ProcessingData($data['fdata']);
        $newFileName = $data['supplier_code'].'_'.$data['img_name'];
        $removeFileStatus = CommonFun::moveFile($data['file_name'],'/uploads/first_enterprise/',$newFileName);
        if(!$removeFileStatus['status']){
            $res['msg'] = $removeFileStatus['msg'];
            goto _end;
        }
        $picUrl = $removeFileStatus['pic_url'];
        $data['name'] = $data['img_name'];
        $data['code'] = $data['supplier_code'];
        $res = EnterprisePhoto::addImg($data,$this->request->code,$picUrl,1);
        _end:
        return $res;
    }
    /** 供方销售人员授权品种管理 */
    public function getProGrant(){
        $contacts = [];
        $paramData = CommonFun::ProcessingData($this->request->data);
        $data = [];
        $contact_id = $paramData['contact_id'];
        if($contact_id == -1){
            $viewContacts = ProvidersSales::getProSales($paramData);
            if($viewContacts['status']) $contacts = $viewContacts['data'];
            if($contacts) $contact_id = $contacts[0]['id'];
        }
        if($contact_id != -1) $data = ProvidersAuthVariety::queryProList($contact_id);
        return ['status'=>1,'contacts'=>$contacts,'data'=>$data];
    }
    /** 保存供方销售人员授权品种 */
    public function comProvGrant(){
        return ProvidersAuthVariety::addData($this->request->data);
    }
}
