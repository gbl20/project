<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Branch;
use app\erp\model\Depart;
use app\erp\model\Employee;

Class ManaData extends BaseController{
    /** 编辑企业信息 */
    public function addCompany(){
        return Branch::addCompany($this->request->data,$this->request->code);
    }
    /** 获取企业机构信息 */
    public function branchList(){
        return Branch::branchList();
    }
    /** 编辑部门信息 */
    public function comDepart(){
        return Depart::comDepart($this->request->data,$this->request->code);
    }
    /** 员工管理 初始化 */
    public function employeeInit(){
        return Employee::employeeInit($this->request->data);
    }
    /** 提交员工信息 */
    public function comEmployee(){
        return Employee::comEmployee($this->request->data,$this->request->code);
    }
}