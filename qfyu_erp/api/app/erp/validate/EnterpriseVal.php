<?php
namespace app\erp\validate;
use app\helper\CheckIDCard;
use think\Validate;

Class EnterpriseVal extends Validate{
    protected $rule = [
        'name' => ['require'],
        'area' => ['require'],
        'business_license' => ['require'],
        'depart_name' => ['require'],
        'business_scope' => ['require'],
        'enterprise_leader' => ['require'],
        'enterprise_type' => ['require'],
        'drug_license' => ['require'],
        'drug_validity_date' => ['require','date'],
        'contact' => ['require'],
        'card_id' => ['require','checkIdCard'=>'身份证号输入有误'],
        'gsp_license' => ['require'],
        'gsp_validity_date' => ['require','date'],
        'ddkindid' => ['require'],
        'bank_area' => ['require'],
        'bank_account' => ['require'],
        'tax_code' => ['require'],
        'quality_validity_date' => ['require'],
        'contract_start_date' => ['date','requireWith:contract_end_date'],
        'contract_end_date' => ['date','requireWith:contract_start_date','gt:contract_start_date']
    ];
    protected $message = [
        'name' => '请填写企业名称',
        'area' => '请填写企业地址',
        'depart_name' => '请选择申请部门',
        'business_license' => '请填写营业执照注册号',
        'business_scope' => '请填写营业执照经营范围',
        'enterprise_leader' => '请填写企业负责人',
        'enterprise_type' => '请选择企业类型',
        'drug_license' => '请填写药品经营许可证号',
        'drug_validity_date' => '请选择药品经营许可证号有效期',
        'contact' => '请填写联系人',
        'card_id' => '请填写联系人身份证号',
        'gsp_license' => '请填写GSP证书编号',
        'gsp_validity_date' => '请选择GSP证书有效期',
        'ddkindid' => '请选择经营许可类别',
        'bank_area' => '请填写开户行',
        'bank_account' => '请填写银行账号',
        'tax_code' => '请填写税号',
        'quality_validity_date' => '请选择质量保证书有效期',
        'contract_start_date.requireWith'=>'请选择合同开始时间',
        'contract_end_date.requireWith'=>'请选择合同结束时间',
        'contract_end_date.gt'=>'合同结束时间不能小于开始时间'
    ];
    protected $scene = [
        'all' => []
    ];
    protected function checkIdCard($value, $rule, $data = [], $name, $description)
    {
        $checkRes = CheckIDCard::isCard($value);
        if(!$checkRes){
            return $rule;
        }else {
            return true;
        }
    }
}
