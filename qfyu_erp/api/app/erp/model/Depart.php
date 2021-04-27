<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\DepartVal;
use think\Model;

Class Depart extends Model {
    public function branch()
    {
        return $this->hasOne(Branch::class,'branch_id');
    }
    public static function comDepart($inputData,$uCode){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $timeDate = date('Y-m-d H:i:s',time());
        $data = $inputData['fdata'];
        $data = CommonFun::ProcessingData($data);
        $validate = new DepartVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $data['re_time'] = $timeDate;
        $reData = $data;
        if($data['id']){
            unset($data['creator_code']);
            unset($data['create_time']);
            $data['updater'] = $uCode;
            $re = Depart::update($data);
        }else{
            unset($data['id']);
            $data['creator_code'] = $uCode;
            $data['create_time'] = $timeDate;
            $re = Depart::create($data);
        }
        if($re){
            if(!$reData['id']){
                $reData['creator_code'] = $uCode;
                $reData['create_time'] = $timeDate;
                $reData['id'] = $re->id;
            }
            $reData['re_time'] = $timeDate;
            $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        }
        _end:
        return $res;
    }

    /**
     * 部门列表(弹出组件)
     */
    public static function depList($map=[]){
        $field='id,branch_id,dept_name,tel,address';
        $map1=$map;
        $map1[]=array('branch_id','=',0);
        $list1=self::field($field)->where($map1)->select()->toArray();
        $map[]=array('branch_id','>',0);
        $list2=self::field($field)->where($map)->select()->toArray();
        $list=array();
        foreach ($list1 as $k=>$v){
            $list[]=$v;
            foreach ($list2 as $k2=>$v2){
                if($v2['branch_id']==$v['id']) $list[]=$v2;
            }
        }
        unset($list1);
        unset($list2);
        return $list;
    }
}