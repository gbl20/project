<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\GspFirstEnterprise;

Class EditEnterprise extends BaseController{
    /** 编辑企业信息初始化 */
    public function editEnterpriseInit(){
        $data = $this->request->data;
        $res = GspFirstEnterprise::editEnterpriseInit($data['orderid']);
        return $res;
    }
    /** 首营企业信息 */
    public function enterpriseList(){
        return GspFirstEnterprise::enterpriseList();
    }
    /** 保存企业信息 */
    public function saveEnterprise(){
        return GspFirstEnterprise::saveEnterprise($this->request->data,$this->request->code);
    }
    /** 审核企业信息 */
    public function examEnterprise(){
        return GspFirstEnterprise::examEnterprise($this->request->data,$this->request->code);
    }
    /** 保存供方销售人员信息 */
    public function saveContacts(){
        return GspFirstEnterprise::saveContacts($this->request->data,$this->request->code);
    }
}
