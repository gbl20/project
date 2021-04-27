<?php

namespace app\erp\model;
use app\erp\validate\PriceVal;
use think\Model;

class CommodityPrice extends Model
{
    public static function getCommodityPriceList($goods_code='',$pricepower='')
    {
        if (!empty($goods_code)) $map[] = ['goods_code','=',$goods_code];

        $map[]=['mode_id','in',$pricepower];
        $field = 'id,goods_code,mode_id,mode_name,0+cast(price1 as char) as price1,0+cast(price2 as char) as price2,creater_code,creater_date,updater_code,updater_date';
        $res = CommodityPrice::where($map)
            ->field($field)
            ->order('id','asc')
            ->select()
            ->toArray();
        return $res;
    }

    public static function editCommodityPrice($data,$user)
    {
        $result = ['status'=>0,'msg'=>'修改失败！'];
        $validate = new PriceVal();
        $checker = $validate->scene('all')->check($data);
        if (!$checker){
            $result['msg'] = $validate->getError();goto _end;
        }
        $data['updater_code'] = $user;
        $data['updater_date'] = date("Y-m-d H:i:s");
        $res = CommodityPrice::update($data);
        if ($res) {
            $result = ['status'=>1,'msg'=>'修改成功！'];
        }
        _end:
        return $result;
    }
}
