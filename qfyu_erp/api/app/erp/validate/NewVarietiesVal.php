<?php
declare (strict_types = 1);

namespace app\erp\validate;
use think\Validate;

class NewVarietiesVal extends Validate
{
	protected $rule = [
	    'depart_id'          => ['require','integer'],//申请部门
	    'create_date'        => ['require','date'],//填报日期
        'goods_name'         => ['max'=>100],//商品名称
	    'name'               => ['require','max'=>100],//通用名称
	    'en_name'            => ['max'=>120],//英文名称
        'dosage'             => ['require','max:10'],//剂型
        'unit'               => ['require','max:10'],//单位
        'specs'              => ['require','max'=>50],//规格
        'description'        => ['require','max'=>255],//商品性能，作用描述
        'pack_specs1'        => 'max:50',//中规格包装
        'pack_specs2'        => 'max:50',//大规格包装
        'quality_standards'  => ['require','max'=>50],//质量标准
        'standard_code'      => ['require','max'=>20],//本位码
	    'approval_code'      => ['require','max'=>20],//批准文号/注册证号
	    'approval_date'      => ['require'],//批准文号/注册证号有效期
        'kinds_id'           => ['integer'],//许可经营大类
        'kinds_kid'          => ['integer'],//许可经营小类
        'category_id'        => ['integer','gt'=>0],//商品大类
        'function_id'        => 'array',//商品功能类别编码
        'gsp_type'           => ['require','integer'],//GSP验收类型
        'origin'             => 'max:50',//产地
        'remark'             => ['require','max'=>100],//申请原因
        'production'         => ['require','max'=>150],//生产企业
        'production_addr'    => ['require','max'=>255],//生产企业详细地址
        'production_mouth'   => ['require','integer','gt'=>0],//有效（使用）期
        'gmp_code'           => ['require','max'=>20],//GMP证书号
        'gmp_date'           => ['require','date'],//GMP认证时间
        'gmp_end_date'       => ['require','date','gt:gmp_date'],//GMP证书有效期
        'factory_price'      => ['regex'=>'/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]$/'],//出厂价
        'buyer_price'        => ['regex'=>'/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]$/'],//采购价
        'trade_price'        => ['regex'=>'/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]$/'],//批发价
        'retail_price'       => ['regex'=>'/^[1-9]\d{0,11}|\d.\d{0,4}[1-9]$/'],//零售价
        'storage_type'       => ['require','max:20'],//储存条件
        'book'               => 'max:50',//出厂检验报告书
        'license_key'        => ['require','max'=>20],//许可证号
        'license_date'       => ['date'],//许可证号有效期
        'business_license_no'=> ['require','max'=>20],//营业执照号
        'business_date'      => 'date',//营业执照有效期
        'ht_date'            => ['date','requireWith:ht_end_date'],//合同开始日期
        'ht_end_date'        => ['date','requireWith:ht_date','gt:ht_date'],//合同结束日期
        'sample_code'        => ['require','max'=>20],//样品批号
        'sample_date'        => 'date',//样品有效期
        'pic1'               => 'max:255',//生产企业营业执照（图片）
        'pic2'               => 'max:255',//GMP证书（图片）
        'pic3'               => 'max:255',//生产许可证（图片）
    ];

    protected $message = [
        'depart.require'            =>'请选择申请部门',
        'create_date.require'       =>'请填写填报日期',
        'goods_name.max'            =>'商品名称不能超过100个字符',
        'name.require'              =>'商品名称不能为空',
        'en_name.max'               =>'商品英文名称不能超过120个字符',
        'dosage'                    =>'请填写剂型',
        'unit'                      =>'请填写单位',
        'specs.require'             =>'请填写规格',
        'description.require'       =>'请填写商品性能成份、质量、用途疗效、副作用描述',
        'pack_specs1.max'           =>'中包装规格不能超过50个字符',
        'pack_specs2.max'           =>'大包装规格不能超过50个字符',
        'quality_standards.require' =>'请填写质量标准',
        'standard_code.require'     =>'请填写本位码',
        'approval_code.require'     =>'请填写批准文号/注册证号',
        'approval_date.require'     =>'请选择批准文号/注册证号有效期',
        'kinds_id'                  =>'许可经营大类格式不正确',
        'kinds_kid'                 =>'许可经营小类别式不正确',
        'category_id'               =>'请选择商品大类',
        'function_id.array'         =>'请选择商品功能类',
        'gsp_type'                  =>'请选择GSP验收类型',
        'origin.max'                =>'产地不能超过50字符',
        'remark.require'            =>'请填写申请原因',
        'production.require'        =>'请填写生产企业',
        'production_addr.require'   =>'请填写生产企业详细地址',
        'production_mouth.require'  =>'有效(使用)期不能为空',
        'gmp_code.require'          =>'GMP证书号不能为空',
        'gmp_date.require'          =>'请选择GMP证书认证时间',
        'gmp_end_date.require'      =>'请选择GMP证书有效期',
        'gmp_end_date.gt'           =>'GMP证书有效期必须大于认证时间',
        'factory_price.regex'       =>'出厂价格式有误',
        'buyer_price.regex'         =>'采购价格式有误',
        'trade_price.regex'         =>'批发价格式有误',
        'retail_price.regex'        =>'零售价格式有误',
        'storage_type'              =>'请选择储存条件',
        'book.max'                  =>'出厂检验报告书字段不能超过50个字符',
        'license_key.require'       =>'请填写许可证号',
        'business_license_no.require' =>'请输入营业执照号',
        'business_license_no.max'   =>'营业执照号不能超过20个字符',
        'business_date.require'     =>'请选择营业执照有效期',
        'sample_code.require'       =>'样品批号不能为空',
        'sample_date'               =>'请选择样品批号有效期',
        'pic1'                      =>'生产企业营业执照格式错误',
        'pic2'                      =>'GMP证书格式错误',
        'pic3'                      =>'生产许可证格式错误',
        'ht_date.requireWith'       =>'请选择合同开始日期',
        'ht_end_date.requireWith'   =>'请选择合同结束日期',
        'ht_end_date.gt'            =>'合同结束日期必须大于开始日期',
    ];

    protected $scene = [
        'all'=>[]
    ];
}
