<?php
namespace app\erp\model;
use think\facade\Db;
use think\Model;

Class Menu extends Model{
    public static function getMenus($power_id_arr)
    {
        $menu_ids = [];
        if($power_id_arr) $menu_ids = PowerList::where('id','in',$power_id_arr)->where('menu_id','not null')->column('menu_id');
        unset($where);
        $where[] = ['status','=',1];
      //  $where[] = ['id','in',$menu_ids];
        $data = Db::name('menu')->where($where)->order('sort','desc')->select()->toArray();
        $menus = self::get_list($data,0);
        return $menus;
    }
    /*** 菜单递归*/
    public static function get_list(&$datas,$parent_id=0){
        $result=array();
        foreach ($datas as $k=>$data){
            if ($data['parent_id']==$parent_id){
                unset($datas[$k]);
                $data['next_menu'] = self::get_list($datas,$data['id']);
                $result[]=$data;
            }
        }
        return $result;
    }
}