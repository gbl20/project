<?php
namespace app\erp\model;
use think\facade\Db;
use think\Model;

Class Role extends Model{

    public static function queryList(){
        $data = Role::field('title,power_ids,id')->select()->toArray();
        $reData = [];
        if($data){
            foreach ($data as $v){
                $v['power_ids'] = $v['power_ids']?unserialize($v['power_ids']):null;
                $reData[$v['id']] = $v;
            }
        }
        return $reData;
    }
    public static function editRole($fData){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $time = time();
        $data['title'] = strip_tags($fData['title']);
        $data['re_time'] = $time;
        if($fData['id']){
            $data['id'] = $fData['id'];
            $re = Role::update($data);
        }else{
            $data['create_time'] = $time;
            $re = Role::create($data);
        }
        if($re){
            $reData = ['title'=>$data['title'],'id'=>($fData['id']?:$re->id)];
            $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        }
        return $res;
    }
}
