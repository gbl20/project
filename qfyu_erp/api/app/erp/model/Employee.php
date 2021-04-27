<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\EmployeeVal;
use think\Model;

Class Employee extends Model {
    public static function employeeInit($param){
        $res = ['status'=>0,'msg'=>''];
        $type = intval($param['type']);
        $pageSize = intval($param['pageSize']);
        $page = intval($param['page']);
        $whereParam = $param['ser_data'];
        $where = [];
        if(isset($whereParam['code']) && $whereParam['code']){
            $where[] = ['code','like',strip_tags($whereParam['code'])];
        }
        if(isset($whereParam['name']) && $whereParam['name']){
            $where[] = ['name','like',strip_tags($whereParam['name'])];
        }
        if(isset($whereParam['phone']) && $whereParam['phone']){
            $where[] = ['phone','like',strip_tags($whereParam['phone'])];
        }
        if(isset($whereParam['depart']) && !empty($whereParam['depart'])){
            $where[] = ['depart_id','=',intval($whereParam['depart'])];
        }
        if(isset($whereParam['status']) && intval($whereParam['status']) != -1){
            $where[] = ['status','=',intval($whereParam['status'])];
        }
        $data = Employee::where($where)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        $duties = null;
        if($type) $duties = DbWork::queryList('duties');
        $res = ['status'=>1,'data'=>$data,'duties'=>$duties];
        return $res;
    }
    public static function getEmployee(){
        $data = Employee::field('id,concat(code,name) as u_msg')->where('status',1)->select();
        return $data;
    }
    public static function comEmployee($inputData,$uCode){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $fData = $inputData['fdata'];
        $reData = CommonFun::ProcessingData($fData,['id','edu','sex','status'],['comm_rate']);
        $validate = new EmployeeVal();
        $val_res = $validate->scene('all')->check($reData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $dateTime = date("Y-m-d H:i:s",time());
        $id = intval($fData['id']);
        if($reData['duties']) DbWork::editDbWork(['value'=>$reData['duties'],'label'=>$reData['duties']],'duties');
        $reData['re_time'] = $dateTime;
        if($id){
            $reData['id'] = $id;
            $reData['updater'] = $uCode;
            $re = Employee::strict(false)->update($reData);
        }else{
            $reData['code'] = CommonFun::createCode('PE');
            $reData['creator'] = $uCode;
            $reData['create_time'] = $dateTime;
            $re = Employee::strict(false)->insertGetId($reData);
        }
        if($re) $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        _end:
        return $res;
    }

    /**
     * 获取员工列表(弹层组件使用)
     * @param array $map 查询条件
     * @param int $page 页码
     * @param int $pageSize 每页条数
     */
    public static function getEmpList($map=[],$page=1,$pageSize=10){
        $field='e.id,e.code,e.name,e.sex,e.depart_id,e.duties,e.status,e.phone,e.remark,de.dept_name';
        $list=self::alias('e')->field($field)
            ->join('depart de','de.id=e.depart_id','LEFT')
            ->where($map)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
}
