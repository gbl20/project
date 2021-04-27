<?php
namespace app\erp\model;
use think\Model;

Class Delivery extends Model {
    /**
     * 获取送货线路列表
     * @param array $map 查询条件
     * @param int $page 页码
     * @param int $pageSize 每页条数
     */
    public static function getList($map=[],$page=1,$pageSize=10){
        $list=self::field('*')->where($map)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        foreach ($list['data'] as $k=>$v){
            $list['data'][$k]['send_time']=date('H:i',strtotime($v['send_time']));
        }
        return $list;
    }
}