<?php

namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\FirstGoodsImgVal;
use think\facade\Db;
use think\Model;

class GoodsPhoto extends Model
{

    public static function photo($goods_code)
    {
        $res = GoodsPhoto::where('goods_code',$goods_code)
            ->alias('g')
            ->field('g.goods_code,g.img_name,g.file_name,g.create_date,g.validity_date,e.name as creator')
            ->join('employee e','g.creator=e.code','left')
            ->where('g.status',0)
            ->select()
            ->toArray();
        return $res;
    }

    /** 保存商品证照 **/
    public static function saveGoodsPhoto($data,$user)
    {
        $result = ['status'=>0,'msg'=>'保存失败！'];
        $data = CommonFun::ProcessingData($data);
        $validate = new FirstGoodsImgVal();
        $checker  = $validate->scene('all')->check($data);
        if (!$checker){
            $result['msg'] = $validate->getError();goto _end;
        }
        if(strtotime($data['validity_date'])< time()){
            $result['msg'] = '有效期不能小于当前日期！';goto _end;
        }
        $newFileName = $data['goods_code'].'_'.$data['img_name'];
        $moveFile = CommonFun::moveFile($data['file_name'],'/uploads/first_goods/',$newFileName);
        if (!$moveFile['status']){
            $result['msg'] = $moveFile['msg'];goto _end;
        }
        $data['file_name'] = $moveFile['pic_url'];
        $map[] = ['goods_code','=',$data['goods_code']];
        $map[] = ['img_name','=',$data['img_name']];
        $has_name = GoodsPhoto::where($map)->find();
        if($has_name){
            $data['status'] = $has_name['status']==1?0:$has_name['status'];
            $data['updated_code'] = $user;
            $data['updated_date'] = date("Y-m-d H:i:s");
            $res = GoodsPhoto::where($map)->update($data);
            if ($res) $result = ['status'=>1,'msg'=>'修改成功！'];
            else $result['msg'] = '修改失败';
        }else{
            $data['create_date'] = date("Y-m-d H:i:s");
            $data['creator'] = $user;
            $res = Db::name('goods_photo')->insert($data);
            if($res) $result = ['status'=>1,'msg'=>'保存成功！'];
        }
        _end:
        return $result;
    }

    /** 删除商品证照 **/
    public static function delPhoto($data,$user)
    {
        $result = ['status'=>0,'msg'=>'删除失败！'];
        $where[] = ['goods_code','=',$data['goods_code']];
        $where[] = ['img_name','=',$data['img_name']];
        $has = GoodsPhoto::where($where)->field('goods_code')->find()->toArray();
        if(!$has){
            $result['msg'] = '删除失败！商品证照不存在。';goto _end;
        }
        $data['updated_code'] = $user;
        $data['updated_date'] = date("Y-m-d H:i:s");
        $data['status'] = 1;
        $res = GoodsPhoto::where($where)->update($data);
        if ($res) $result = ['status'=>1,'msg'=>'删除成功！'];
        _end:
        return $result;
    }
}
