<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\ZJM;
use app\erp\validate\ContactsVal;
use app\erp\validate\EnterpriseVal;
use think\facade\Db;
use think\Model;

Class GspFirstEnterprise extends Model{
    public function depart()
    {
        return $this->hasOne(Depart::class,'id');
    }
    public static function editEnterpriseInit($orderid){
        $res = ['status'=>0,'msg'=>''];
        $edit_enter_priseData = null;
        $contactsData = [];$examData = null;
        $ddKindTxt = [];$ddKind = [];
        if($orderid){
            $where[] = ['orderid','=',strip_tags($orderid)];
            $field = 'orderid';
            $edit_enter_priseData = GspFirstEnterprise::withJoin('depart','left')->where($where)->field($field)->find()->bindAttr('depart',['dept_name'])->toArray();
            if(!$edit_enter_priseData) goto _end;
            $edit_enter_priseData['shtxd_validity_date'] = null;
            $edit_enter_priseData['SHTXD_img'] = '';
            $edit_enter_priseData['yzystp_validity_date'] = null;
            $edit_enter_priseData['YZYSTP_img'] = '';
            $photos = EnterprisePhoto::queryImgList(0,$edit_enter_priseData['supplier_code']);
            if($photos){
                foreach ($photos as $k=>$v){
                    $edit_enter_priseData[ strtolower($v['img_name']).'_validity_date'] = $v['validity_date'];
                    $edit_enter_priseData[$v['img_name'].'_img'] = $v['file_name'];
                }
            }
            $contactsData = Db::name('enterprise_supplier')->where($where)->select()->toArray();
            $examData = Db::name('gsp_first_approval')->where('orderid',$orderid)->find();
            if($edit_enter_priseData['ddkindid']){
                $ddKind = explode(',',$edit_enter_priseData['ddkindid']);
                foreach ($ddKind as $k=>$v){
                    $ddKind[$k]=(int)$v;
                }
            }
            $ddKindTxt = Customer::getcustddk($ddKind);
        }
        $res = ['status'=>1,'edit_enter_priseData'=>$edit_enter_priseData,'contacts_data'=>$contactsData,'exam_data'=>$examData,'dd_kind_txt'=>$ddKindTxt,'dd_Kind'=>$ddKind,];
        _end:
        return $res;
    }
    public static function enterpriseList(){
        $res = ['status'=>0,'msg'=>''];
        $where = [];
        $pageSize = 10;
        $field = '*';
        $data = GspFirstEnterprise::where($where)->field($field)->paginate($pageSize)->toArray();
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    public static function saveEnterprise($inputData,$opCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $fData = $inputData['fdata'];
        $reData = CommonFun::ProcessingData($fData,['tech_mans','post_code','is_quality_agreement'],['registered_capital','output_year']);
        $validate = new EnterpriseVal();
        $val_res = $validate->scene('all')->check($reData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        if($reData['orderid']){
            $reData['updater'] = $opCode;
            $reData['re_date'] = date('Y-m-d H:i:s',time());
            $where[] = ['is_audit','=',0];
            $where[] = ['orderid','=',$reData['orderid']];
            $re = GspFirstEnterprise::where($where)->strict(false)->update($reData);
        }else{
            $orderId = CommonFun::createOrder('FS');
            $code = CommonFun::createCode('FS');
            $reData['supplier_code'] = $code;
            $reData['mnemonic_code'] = ZJM::character($fData['name']);
            $reData['orderid'] = $orderId;
            $reData['creator'] = $opCode;
            $reData['create_date'] = date('Y-m-d H:i:s',time());
            $re = GspFirstEnterprise::strict(false)->insert($reData);
        }
        $reData['is_audit'] = 0;
        $reData['is_approval'] = 0;
        if($re) $res = ['status'=>1,'msg'=>'保存成功','re_data'=>$reData];
        else $res['msg'] = '保存失败';
        _end:
        return $res;
    }
    /** 保存供应商销售信息 */
    public static function saveContacts($inputData,$opCode){
        $res = ['status'=>0,'msg'=>'保存失败'];
        $fData = $inputData['fdata'];
        $validate = new ContactsVal();
        $val_res = $validate->scene('all')->check($fData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $fData = CommonFun::ProcessingData($fData,['phone','qq','id']);
        $id = $fData['id'];
        $reData = $fData;
        if($id){
            $reData['updater'] = $opCode;
            $reData['re_date'] = date('Y-m-d H:i:s',time());
            $where[] = ['id','=',$id];
            $re = Db::name('enterprise_supplier')->where($where)->update($reData);
        }else {
            $reData['creator'] = $opCode;
            $reData['create_date'] = date('Y-m-d H:i:s',time());
            $re = Db::name('enterprise_supplier')->insert($reData);
        }
        if($re) $res = ['status'=>1,'msg'=>'保存成功','re_data'=>$reData];
        else $res['msg'] = '保存失败';
        _end:
        return $res;
    }
    public static function examEnterprise($inputData,$opCode){
        $res = ['status'=>0,'msg'=>''];
        $orderid = strip_tags($inputData['orderid']);
        $where[] = ['orderid','=',$orderid];
        $isAudit = GspFirstEnterprise::where($where)->value('is_audit');
        if($isAudit){
            $res['msg'] = '单据已审核，请勿重复操作！';
            goto _end;
        }
        $where[] = ['is_audit','=',0];
        $upData['is_audit'] = 1;
        $upData['auditer'] = $opCode;
        $upData['audit_date'] = date('Y-m-d H:i',time());
        Db::startTrans();
        $re = GspFirstEnterprise::where($where)->update($upData);
        $re2 = Db::name('gsp_first_approval')->replace(true)->insert(['orderid'=>$orderid,'type'=>2]);
        if($re && $re2){
            Db::commit();
            $res = ['status'=>1,'msg'=>'审核成功'];
        }else{
            Db::rollback();
            $res['msg'] = '保存失败';
        }
        _end:
        return $res;
    }
}
