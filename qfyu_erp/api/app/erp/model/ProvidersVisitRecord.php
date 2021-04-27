<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\VisitRecordVal;
use think\Model;

Class ProvidersVisitRecord extends Model{
    public static function saveRecords($inputData){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $fData = CommonFun::ProcessingData($inputData['fdata']);
        $validate = new VisitRecordVal();
        $val_res = $validate->scene('all')->check($fData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $id = $fData['id'];
        $reData = $fData;
        $reData['re_date'] = date('Y-m-d H:i:s',time());
        if($id){
            $where[] = ['id','=',$id];
            $re = ProvidersVisitRecord::where($where)->update($reData);
        }else {
            $re = ProvidersVisitRecord::create($reData);
            $reData['id'] = $re->id;
        }
        $reData['f_date'] = date('Y-m-d',strtotime($reData['f_date']));
        if($re) $res = ['status'=>1,'msg'=>'保存成功','data'=>$reData];
        else $res['msg'] = '保存失败';
        _end:
        return $res;
    }
    public static function getRecords($data){
        $res = ['status'=>0,'msg'=>'init error'];
        if(!isset($data['supplier_code'])) goto _end;
        $supplierCode = strip_tags($data['supplier_code']);
        $where[] = ['supplier_code','=',$supplierCode];
        $data = ProvidersVisitRecord::where($where)->select()->toArray();
        if($data) $res = ['status'=>1,'data'=>$data];
        _end:
        return $res;
    }
}
