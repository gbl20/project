<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\BranchVal;
use think\facade\Db;
use think\Model;

Class Branch extends Model{
    public static function branchList(){
        $BranchData = Depart::withJoin('branch', 'LEFT')->where('depart.branch_id','=',0)->select()->toArray();
        $depart = [];
        $c_id = 0;
        if($BranchData){
            $c_id = $BranchData[0]['id'];
            foreach($BranchData as $key=>$val){
                $branch = $val['branch'];
                unset($val['branch']);
                $BranchData[$key] = array_merge($branch,$val);
                $depart[$val['id']] = Depart::where('branch_id',$val['id'])->field('*')->select();
            }
        }
        $res = ['status'=>1,'company'=>$BranchData,'depart'=>$depart,'c_id'=>$c_id];
        return $res;
    }
    public static function addCompany($inputData,$uCode){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $timeDate = date('Y-m-d H:i:s',time());
        $data = $inputData['fdata'];
        $data = CommonFun::ProcessingData($data);
        $validate = new BranchVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $data['re_time'] = $timeDate;
        $reData = $data;
        $branchData['branch_id'] = $reData['id'];
        $branchData['network_num'] = $reData['network_num'];
        $branchData['tax_num'] = $reData['tax_num'];
        $branchData['business_license'] = $reData['business_license'];
        $branchData['business_license_validity'] = $reData['business_license_validity'];
        $branchData['organization'] = $reData['organization'];
        $branchData['organization_validity'] = $reData['organization_validity'];
        $branchData['drug_license'] = $reData['drug_license'];
        $branchData['drug_license_validity'] = $reData['drug_license_validity'];
        $branchData['gsp_license'] = $reData['gsp_license'];
        $branchData['gsp_license_validity'] = $reData['gsp_license_validity'];

        $DepartData['id'] = $reData['id'];
        $DepartData['code'] = $reData['code'];
        $DepartData['dept_name'] = $reData['dept_name'];
        $DepartData['address'] = $reData['address'];
        $DepartData['tel'] = $reData['tel'];
        $DepartData['fax'] = $reData['fax'];
        $DepartData['leader'] = $reData['leader'];
        $DepartData['status'] = $reData['status'];
        Db::startTrans();
        if($data['id']){
            unset($data['creator']);
            unset($data['create_time']);
            $DepartData['updater'] = $uCode;
            $DepartData['re_time'] = $timeDate;
            $re1 = Depart::update($DepartData);
            $re2 = Branch::where('branch_id','=',$reData['id'])->update($branchData);
        }else{
            unset($data['id']);
            $DepartData['creator'] = $uCode;
            $DepartData['create_time'] = $timeDate;
            $re1 = Depart::create($DepartData);
            $branchData['dep_id'] = $re1->id;
            $re2 = Branch::create($branchData);
        }
        if($re1 && $re2){
            Db::commit();
            if(!$reData['id']){
                $reData['creator'] = $uCode;
                $reData['create_time'] = $timeDate;
                $reData['id'] = $re1->id;
            }
            $reData['re_time'] = $timeDate;
            $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        }else Db::rollback();
        _end:
        return $res;
    }
}
