<?php
namespace app\erp\model;
use think\facade\Db;
use think\Model;

Class PowerList extends Model{
    public static function queryList(){
        $field = 'm_name as title,id';
        $where[] = ['parent_id','=',0];
        $Menu = Db::name('power_list')->where($where)->field($field)->column('m_name as title','id');
        $mList = null;
        $pitchOn = [];
        foreach($Menu as $k=>$v){
            $pitchOn[$k] = [];
            unset($where);
            $where[] = ['parent_id','=',$k];
            $where[] = ['is_control','<>',0];
            $mList[$k] =  Db::name('power_list')->where($where)->column('m_name as title','id');
            if($mList[$k]){
                foreach($mList[$k] as $key=>$item){
                    $newItem = [];
                    $newItem['title'] = $item;
                    $newItem['indeterminate'] = false;
                    $newItem['checkAll'] = false;
                    $newItem['checkAllGroup'] = [];
                    $newItem['is_show'] = false;
                    unset($where);
                    $where[] = ['parent_id','=',$key];
                    $where[] = ['is_control','<>',0];
                    $children = Db::name('power_list')->where($where)->column('m_name as title','id');
                    $groups = [];
                    if($children){
                        foreach ($children as $kk=>$vv) {
                            $groups[] = $kk.'';
                        }
                    }
                    $newItem['groups'] = $groups;
                    $newItem['children'] = $children;
                    $mList[$k][$key] = $newItem;
                    $pitchOn[$k][$key] = [];
                }
            }
        }
        $Menu[0] = '价格体系';
        $newItem = [];
        $newItem['title'] = '价格体系';
        $newItem['indeterminate'] = false;
        $newItem['checkAll'] = false;
        $newItem['checkAllGroup'] = [];
        $newItem['is_show'] = false;
        unset($where);
        $children = Db::name('commodity_price_system')->column('name as title','id');
        $groups = [];
        if($children){
            foreach ($children as $kk=>$vv) {
                $groups[] = $kk.'';
            }
        }
        $newItem['groups'] = $groups;
        $newItem['children'] = $children;
        $mList[0][0] = $newItem;
        $pitchOn[0][0] = [];
        return ['menu'=>$Menu,'mList'=>$mList,'pitchOn'=>$pitchOn];
    }
    public static function setPower($data){
        $res = ['status'=>0,'msg'=>'设置失败'];
        $roleId = intval($data['role_id']);
        $operatorsId = intval($data['operators_id']);
        $upData['power_ids'] = serialize($data['pitch']);
        $upData['re_time'] = time();
        $re = false;
        if($roleId){
            $re = Role::where('id',$roleId)->update($upData);
        }elseif($operatorsId){
            $re = Operators::where('id',$operatorsId)->update($upData);
        }
        if($re){
            $res = ['status'=>1,'msg'=>'设置成功'];
        }
        return $res;
    }
}