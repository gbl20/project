<?php
namespace app\erp\model;
use think\facade\Config;
use think\Model;

Class CustomerImg extends Model {
    /**
     * 获取单个证照
     */
    public static function oneIMG($id){
        if(intval($id)>0) $res['data']=self::field('*')->where('id','=',$id)->find();
        else $res['data']=array('id'=>0);
        $res['labelarr']=Config::get('parameter.img_config.customer');
        return $res;
    }

    /**
     * 获取某个客户证照列表
     */
    public static function getList($cid){
        $labelarr=Config::get('parameter.img_config.customer');
        $map[]=array('ci.cid','=',$cid);
        $list=self::alias('ci')->field('ci.*,e.name as man_name')->join('employee e','e.code=ci.man','LEFT')->where($map)->select()->toArray();
        foreach ($list as $k=>$v){
            $list[$k]['pic_name_txt']=isset($labelarr[$v['pic_name']])?$labelarr[$v['pic_name']]:$v['pic_name'];
            $list[$k]['use_date']=date('Y-m-d',strtotime($v['use_date']));
            $list[$k]['pic_date']=date('Y-m-d H:i',strtotime($v['pic_date']));
            $picurl=explode('/',$v['pic_url']);
            $list[$k]['pic_url']=empty($picurl)?null:end($picurl);
        }
        return $list;
    }

    /**
     * 新增/修改 证件
     */
    public static function addImg($data){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $map[]=array('id','=',$data['id']);
        $proData['cid'] = $data['cid'];
        $proData['pic_name'] = $data['pic_name'];
        $proData['pic_url'] = $data['pic_url'];
        $proData['pic_date'] = date('Y-m-d H:i',time());
        $proData['use_date'] = $data['use_date'];
        $proData['man'] = $data['man'];
        $re = self::where($map)->update($proData);
        if(!$re) $re = self::replace(true)->insert($proData);
        if($re) $res = ['status'=>1,'msg'=>'保存成功'];
        return $res;
    }
}