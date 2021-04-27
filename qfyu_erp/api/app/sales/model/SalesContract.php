<?php
namespace app\sales\model;
use app\helper\CommonFun;
use app\sales\validate\ContractVal;
use think\facade\Db;
use think\Model;

Class SalesContract extends Model{
    public static function addData($inputData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $timeDate = date('Y-m-d H:i:s',time());
        $data = $inputData['fdata'];
        $data = CommonFun::ProcessingData($data);
        $validate = new ContractVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        if($data['contract_no']) $contractNo = $data['contract_no'];
        else{
            $employee = Db::name('employee')->alias('e')
            ->join('depart d','d.id = e.depart_id','left')
            ->field('e.depart_id,d.dept_name')->where('e.code','=',$uCode)->find();
            if(!$employee){
                $res['msg'] = '提交信息有误，请重新再试！';
                goto _end;
            }
            $data['dept_id'] = $employee['depart_id'];
            $data['dept_name'] = $employee['dept_name'];
            $contractNo = CommonFun::createOrder('XH');
        }
        $newFilePath = '/uploads/sales_contract/'.$contractNo.'/';
        $moveFileStatus = CommonFun::moveFile($data['file_path'],$newFilePath);
        if(!$moveFileStatus['status']){
            $res['msg'] = $moveFileStatus['msg'];
            goto _end;
        }
        $data['file_path'] = $moveFileStatus['pic_url'];
        if($data['contract_no']){
            $data['updater'] = $uCode;
            $data['update_date'] = $timeDate;
            $re = SalesContract::strict(false)->where('contract_no','=',$contractNo)->update($data);
        }else{
            $data['contract_no'] = $contractNo;
            $data['create_date'] = $timeDate;
            $data['creator'] = $uCode;
            $re = SalesContract::strict(false)->extra('IGNORE')->insert($data);
        }
        if($re){
            $data = self::queryList($contractNo);
            $res = ['status'=>1,'msg'=>'保存成功','data'=>$data];
        }
        _end:
        return $res;
    }
    public static function queryList($contractNo=''){
        $where = [];
        if($contractNo) $where[] = ['contract_no','=',strip_tags($contractNo)];
        $data = Db::name('sales_contract')->where($where)->field('*')->select()->toArray();
        if($contractNo) $data = $data?$data[0]:[];
        return $data;
    }
}
