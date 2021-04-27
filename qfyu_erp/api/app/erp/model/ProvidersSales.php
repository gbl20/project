<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\ContactsVal;
use think\facade\Db;
use think\Model;

Class ProvidersSales extends Model{
    public static function getProSales($data){
        $res = ['status'=>0,'msg'=>'init error'];
        if(!isset($data['supplier_code'])) goto _end;
        $supplierCode = strip_tags($data['supplier_code']);
        $where[] = ['supplier_code','=',$supplierCode];
        $data = ProvidersSales::where($where)->select()->toArray();
        if($data) $res = ['status'=>1,'data'=>$data];
        _end:
        return $res;
    }
    public static function saveProSales($inputData,$opCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $fData = CommonFun::ProcessingData($inputData['fdata'],['phone','qq','id','sex','exam_status','attorney_validity','status']);
        $validate = new ContactsVal();
        $val_res = $validate->scene('all')->check($fData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $id = $fData['id'];
        $reData = $fData;
        $reData['attorney_validity'] = 0;
        if($reData['validity_date'] && strtotime($reData['validity_date']) > time()) $reData['attorney_validity'] = 1;
        if($id){
            $reData['updater'] = $opCode;
            $reData['re_date'] = date('Y-m-d H:i:s',time());
            $where[] = ['id','=',$id];
            if(!$reData['qualityer']) $reData['exam_status'] = 0;
            $re = ProvidersSales::where($where)->update($reData);
        }else {
            $reData['creator'] = $opCode;
            $reData['create_date'] = date('Y-m-d H:i:s',time());
            $reData['exam_status'] = 0;
            $re = ProvidersSales::create($reData);
            $reData['id'] = $re->id;
        }
        if($re) $res = ['status'=>1,'msg'=>'保存成功','data'=>$reData];
        else $res['msg'] = '保存失败';
        _end:
        return $res;
    }
    /** 审批流 */
    public static function examContact($data,$userData){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $postCode = $data['post_code'];
        $id = $data['param_data']['id'];
        if(!$id) goto _end;
        $CheckContact = ProvidersSales::where('id','=',$id)->field('purcher,qcer')->find();
        if(!$CheckContact) goto _end;
        $nowDate = date('Y-m-d H:i:s',time());
        if($postCode == 'purch_depart'){
            $upData['purcher'] = $userData['code'];
            $upData['purch_exam_date'] = $nowDate;
        }elseif($postCode == 'quality_depart'){
            if(!$CheckContact['purcher']){
                $res['msg'] = '采购部负责人尚未审核';
                goto _end;
            }
            $upData['qcer'] = $userData['code'];
            $upData['qc_exam_date'] = $nowDate;
        }elseif($postCode == 'quality_director'){
            if(!$CheckContact['qcer']){
                $res['msg'] = '质量管理部负责人尚未审核';
                goto _end;
            }
            $upData['qualityer'] = $userData['code'];
            $upData['quality_exam_date'] = $nowDate;
            $upData['exam_status'] = 1;
        }else goto _end;
        $upData['re_date'] = $nowDate;
        $re = ProvidersSales::where('id','=',$id)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'审核成功','data'=>$upData];
        _end:
        return $res;
    }
    /** 设置默认联系人 */
    public static function setProSalesDefault($data,$uCode){
        $supplier_code = strip_tags($data['supplier_code']);
        $id = intval($data['id']);
        $res = ['status'=>0,'msg'=>'设置失败'];
        Db::startTrans();
        $nowDate = date('Y-m-d H:i:s',time());
        $where[] = ['supplier_code','=',$supplier_code];
        $upData['is_default'] = 0;
        $upData['re_date'] = $nowDate;
        $re1 = ProvidersSales::where($where)->update($upData);
        unset($where);
        $where[] = ['supplier_code','=',$supplier_code];
        $where[] = ['id','=',$id];
        $upData['is_default'] = 1;
        $re2 = ProvidersSales::where($where)->update($upData);
        if($re1 && $re2){
            Db::commit();
            $res = ['status'=>1,'msg'=>'设置成功'];
        }else Db::rollback();
        return $res;
    }
}