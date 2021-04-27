<?php
namespace app\erp\model;
use think\Model;

Class DbWork extends Model{
    /**
     * @param $fieldName 字段名
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    public static function queryList($fieldName){
        $where[] = ['field_name','=',$fieldName];
        return DbWork::field('id as value,value as label')->where($where)->select()->toArray();
    }

    /**
     * @param $valueObj 更新数据
     * @param $fieldName 字段名
     * @return int|mixed|string
     */
    public static function editDbWork($valueObj,$fieldName){
        $dbWorkId = $valueObj['value'];
        if($valueObj['value'] !== $valueObj['label'] || !$valueObj['label']) goto _end;
        $data['value'] = strip_tags($valueObj['label']);
        $data['field_name'] = $fieldName;
        $data['create_time'] = date('Y-m-d H:i',time());
        $dbWorkId = DbWork::create($data,[],true);
        $dbWorkId = $dbWorkId->id;
        _end:
        return $dbWorkId;
    }
}
