<?php
namespace app\erp\model;
use app\erp\validate\EntrustVal;
use app\helper\CommonFun;
use think\Model;

Class EntrustLogistics extends Model{
    public static function entrustList(){
        $data = EntrustLogistics::select()->toArray();
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    /**
     * 保存委托物流单位信息
     * @param $inData
     * @param $uCode
     * @return array
     */
    public static function addData($inData,$uCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $reData = CommonFun::ProcessingData($inData['fdata']);
        $validate = new EntrustVal();
        $val_res = $validate->scene('all')->check($reData);
        if(!$val_res){
            $res['msg'] = $validate->getError();
            goto _end;
        }
        if($reData['id']){
            $reData['mender'] = $uCode;
            $reData['update_date'] = date('Y-m-d H:i:s',time());
            $where[] = ['id','=',$reData['id']];
            $re = EntrustLogistics::where($where)->update($reData);
        }else{
            $reData['creater'] = $uCode;
            $reData['create_date'] = date('Y-m-d H:i:s',time());
            $re = EntrustLogistics::insert($reData);
        }
        if($re){
            $res = ['status'=>1,'msg'=>'保存成功','data'=>$reData];
        }
        _end:
        return $res;
    }
}