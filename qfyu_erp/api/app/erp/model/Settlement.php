<?php
namespace app\erp\model;
use app\helper\CommonFun;
use think\facade\Db;
use think\Model;
/**
 * 结算方式模型类
 * @author wuzhogngui
 * @license 2020-11-04
 */
class Settlement extends Model
{
    /**
     * 查询结算方式列表
     * @param $effective 是否查询有效列表 1是
     */
    public static function getSettlementList($effective=0){
        $where=[];
        if(intval($effective)==1) $where['iseffective']=1;
        $field="a.id,a.code,a.name,a.overday,a.cid,a.deptid,a.remark,a.iseffective,d.dept_name";
        $list=Db::name('settlement')->alias('a')->field($field)
            ->join('depart d','d.id=a.deptid','left')
            ->where($where)->select()->toArray();
        return $list;
    }
    /**
     * 新增、修改结算方式
     * @param $data 结算方式数据
     * @param $user 操作用户编码
     */
    public static function saveSettlementData($data,$user){
        $result=['status'=>0,'msg'=>'结算方式保存失败'];
        if(empty($data['name'])){
            $result['msg']="请输入结算名称";goto _end;
        }
        $sdata['name']=strip_tags($data['name']);
        $sdata['overday']=(int)$data['overday'];
        $sdata['remark']=strip_tags($data['remark']);
        $sdata['iseffective']=1;
        $sdata['updater']=$user;
        $sdata['update_date']=date('Y-m-d H:i:s',time());
        if(!isset($data['deptid']) || empty($data['deptid'])){
            //获取默认公司部门
            $u=Db::name('employee')->field('company_id,depart_id')->where(['code'=>$user])->find();
            $sdata['deptid']=$u['depart_id'];
        }else{
            $sdata['deptid']=$data['deptid'];
        }
        if(isset($data['id']) && $data['id']){
            $res=Db::name('settlement')->where(['id'=>$data['id']])->update($sdata);
            if($res) $result=['status'=>1,'msg'=>'结算方式更新成功'];
        }else{
            $sdata['code']=CommonFun::createCode('JS');
            $sdata['creater']=$sdata['updater'];
            $sdata['create_date']=$sdata['update_date'];
            $res=Db::name('settlement')->insert($sdata);
            if($res) $result=['status'=>1,'msg'=>'结算方式新增成功'];
        }
        _end:
        return $result;
    }
    /** 来货登记 -- 选择结算方式 **/
    public static function getCommonList()
    {
        $res = Settlement::where('iseffective',1)->field('id,code,name')->select();
        return $res;
    }
}
