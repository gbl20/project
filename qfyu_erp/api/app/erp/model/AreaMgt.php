<?php
namespace app\erp\model;
use app\helper\CommonFun;
use think\Model;

Class AreaMgt extends Model {
    /**
     * 获取地区管理列表 树形结构
     */
    public static function getAreaTree(){
        $list=self::field('id,parent_id,area_name as title,level')->select()->toArray();
        return self::get_alist($list);
    }
    /**
     * 地区数据递归
     */
    private static function get_alist(&$datas,$parent_id=0){
        $result=array();
        foreach ($datas as $k=>$data){
            if ($data['parent_id']==$parent_id){
                unset($datas[$k]);
                $data['children']=self::get_alist($datas,$data['id']);
                $result[]=$data;
            }
        }
        return $result;
    }
    public static function getChlidArea($id)
    {
      $where[] = ['parent_id','=',$id];
      $data = AreaMgt::where($where)->select()->toArray();
      return $data;
    }

    public static function edit($data)
    {
      $result = ['status'=>0,'msg'=>'新增失败！'];
      $data = CommonFun::ProcessingData($data);
      $data['area_name'] = substr($data['area_name'],0,60);
      $has_name = AreaMgt::where('id',$data['id'])->find();
      if($has_name){
        $res = AreaMgt::where('id',$data['id'])->update($data);
        if($res) $result = ['status'=>1,'id'=>$data['id'],'msg'=>'修改成功！'];
        else $result['msg'] = '修改失败！';
      }else{
        $level = AreaMgt::where('id',$data['parent_id'])->value('level');
        $data['level'] = $level+1;
        if($data['level']>5){
          $result['msg'] = '地区级别不能超出5级！';goto _end;
        }
        $id = AreaMgt::insertGetId($data);
        if ($id) $result = ['status'=>1,'id'=>$id,'msg'=>'新增成功！'];
      }
      _end:
      return $result;
    }
}
