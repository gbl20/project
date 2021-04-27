<?php
namespace app\erp\model;
use think\Model;

Class CustomerGoods extends Model {
    /**
     * 客户协议品种列表
     */
    public static function getList($id){
        $map[]=array('cg.cid','=',$id);
        $field='cg.*,g.goods_name,g.specs,g.unit,g.unit2,g.production,g.origin,g.approval_code,g.dosage';
        $list=self::alias('cg')->field($field)->join('commodity g','g.goods_code=cg.goods_code','LEFT')->where($map)->select()->toArray();
        foreach ($list as $k=>$v){
            $list[$k]['price']=$v['price']==0?null:$v['price'];
            $list[$k]['price2']=$v['price2']==0?null:$v['price2'];
        }
        return $list;
    }
}