<?php
namespace app\erp\validate;
use think\Validate;

Class SupplierVal extends Validate{
    protected $rule = [
        'name' => ['require'],
        'full_name' => ['require'],
        'address' => ['require'],
        'enterprise_type' => ['require','egt'=>0],
        'operation_mode' => ['require'],
        'legal_person' => ['require'],
        'attorney_validity_date' => ['require','date'],
        'watch_no' => ['require'],
        'business_leader' => ['require'],
        'ywysqsyxq_date' => ['require','date'],
        'bank_area' => ['require'],
        'bank_account' => ['require'],
        'tax_code' => ['require'],
        'pay_mode_no' => ['require'],
        'quality_validity_date' => ['require','date'],
        'ddkindid' => ['require'],
        'business_license' => ['require'],
        'business_validity_date' => ['require','date'],
        'gsp_license' => ['require'],
        'gsp_validity_date' => ['require','date'],
        'drug_license' => ['require'],
        'drug_validity_date' => ['require','date'],
    ];
    protected $message = [
        'name' => '请填写供应商简称',
        'full_name' => '请填写供应商简称',
        'address' => '请填写详细地址',
        'enterprise_type' => '请选择企业类型',
        'operation_mode' => '请输入经营方式',
        'legal_person' => '请填写企业法人',
        'attorney_validity_date' => '请选择法人委托书有效期',
        'watch_no' => '请输入统一监管码',
        'business_leader' => '请输入业务负责人',
        'ywysqsyxxq_date' => '请选择业务授权有效期',
        'bank_area' => '请填写开户银行',
        'bank_account' => '请填写开户银行账号',
        'tax_code' => '请填写税号',
        'pay_mode_no' => '请选择结算方式',
        'quality_validity_date' => '请选择质量保证书有效期',
        'ddkindid' => '请选择许可经营类别',
        'business_license' => '请输入营业执照号码',
        'business_validity_date' => '请输入营业执照有效期',
        'gsp_license' => '请输入GSP证书编号',
        'gsp_validity_date' => '请选择GSP证书有效期',
        'drug_validity' => '请填写药品经营许可证号',
        'drug_validity_date' => '请选择药品经营许可证有效期',

    ];
    protected $scene = [
        'all' => []
    ];
}
