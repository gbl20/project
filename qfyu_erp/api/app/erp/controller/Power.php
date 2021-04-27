<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Employee;
use app\erp\model\Operators;
use app\erp\model\PowerList;
use app\erp\model\Role;
use think\facade\Db;

Class Power extends BaseController{
    /** 权限管理初始化 */
    public function powerInit(){
        $EmployeeData = Employee::getEmployee();
        $opData = Operators::queryList();
        $RoData = Role::queryList();
        $powerList = PowerList::queryList();
        $extendDefine = Db::name('extend_define')->where('mode_id','=',1)->field('id,t_name')->select()->toArray();
        $res = ['status'=>1,'employee_data'=>$EmployeeData,'op_data'=>$opData,'ro_data'=>$RoData,'power_list'=>$powerList,'extend_define'=>$extendDefine];
        return $res;
    }
    public function setPower(){
        return PowerList::setPower($this->request->data);
    }
    /** 角色信息提交更新 */
    public function editRole(){
        return Role::editRole($this->request->data);
    }
    /** 管理员信息提交更新 */
    public function editOp(){
        return Operators::editOp($this->request->data);
    }
    /** 管理员角色变更 */
    public function setOpRole(){
        return Operators::setOpRole($this->request->data);
    }
    /** 管理员岗位权限授权 */
    public function setOpPost(){
        return Operators::setOpPost($this->request->data);
    }
}