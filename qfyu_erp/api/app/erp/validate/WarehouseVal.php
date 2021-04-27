<?php
namespace app\erp\validate;
use think\Validate;
/**
 * 仓库资料管理-验证器类
 * @author wuzhonggui
 * @license 2020-10-28
 */
class WarehouseVal extends Validate
{
    protected $rule = [
        'ware_title'=>['require'],
        'canbyonline'=>['in:0,1'],
        'canbyonsale'=>['in:0,1'],
        'canheadoffice'=>['in:0,1'],
        'canvirtual'=>['in:0,1'],
        'cancomplete'=>['in:0,1'],
        'cannotice'=>['in:0,1']
    ];

    protected $message = [
        'ware_title.require' => '请输入仓库名称！',
        'canbyonline.in'=>'请设置是否可网购',
        'canbyonsale.in'=>'请设置是否可销售',
        'canheadoffice.in'=>'请设置是否总部仓库',
        'canvirtual.in'=>'请设置是否虚拟分级仓',
        'cancomplete.in'=>'请设置是否整件仓',
        'cannotice'=>'请设置是否销售时警告'
    ];

    protected $scene = [
        'all'=>['ware_title','canbyonline','canbyonsale','canheadoffice','canvirtual','cancomplete','cannotice']
    ];
}