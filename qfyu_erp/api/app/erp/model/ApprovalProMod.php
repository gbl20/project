<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\Enc;
use think\facade\Db;
use think\Model;

Class ApprovalProMod extends Model{
    /**
     * 首营审批
     * @param $data
     * @param $user 用户编号
     * @return array
     */
    public static function adm_check_first_goods($data,$user)
    {
        $result = ['status'=>0,'msg'=>'审批失败'];
        $data = CommonFun::ProcessingData($data,['type']);
        $postTName = strip_tags($data['exam_type']);
        $where[] = ['mode_code','=',$postTName];
        $where[] = ['status','=',1];
        $postType = Db::name('extend_define')->where($where)->value('id');
        if(!$postType){
            $result = ['status'=>0,'msg'=>'提交参数有误'];
            goto _end;
        }
        $has_user = Db::name('employee')->where('code',$data['code'])->value('id');
        if(!$has_user){
            $result['msg'] = '验证用户身份失败！请重新输入。';
            goto _end;
        }
        if ($data['code']!== $user){
            $result['msg'] = '审批人与登录账户不一致，禁止审批！根据系统设置，审批首营资料必须是本人登录系统。';
            goto _end;
        }
        $hasUser = Db::name('operators')->where('emp_id',$has_user)->field('passwd,post_auth')->find();
        if(!$hasUser){
            $result['msg'] = '用户编号不正确！请重新输入。';
            goto _end;
        }
        $pwd = Enc::encrypt($data['pwd']);
        if($pwd !== $hasUser['passwd']){
            $result['msg'] = '用户登录密码不正确！请重新输入。';
            goto _end;
        }
        if($hasUser['post_auth']){
            $post_auth = unserialize($hasUser['post_auth']);
            if(!in_array($postType,$post_auth)){
                $result['msg'] = '用户没有该岗位权限！';
                goto _end;
            }
        }else{
            $result['msg'] = '用户没有该岗位权限！';
            goto _end;
        }
        $res = self::checkOrder($data,$user,$data['type']);
        if ($res['status']==1) $result = ['status'=>1,'msg'=>$res['msg']];
        else $result['msg'] = $res['msg'];
        _end:
        return $result;
    }

    public static function checkOrder($reData,$user,$type)
    {
        $result = ['status'=>0,'msg'=>'审核失败！'];
        if($type == 1) $has_check = Db::name('gsp_first_goods')->where('orderid',$reData['orderid'])->value('order_status');
        else if($type == 2) $has_check = Db::name('gsp_first_enterprise')->where('orderid',$reData['orderid'])->value('is_approval');
        else {$result['msg'] = '请求参数有误';goto _end;}
        if($has_check){
            $result['msg'] = '该订单不需要审批';
            goto _end;
        }
        $checker = Db::name('gsp_first_approval')->where('orderid',$reData['orderid'])->find();
        $prefix = 'buyer_';
        if($reData['exam_type']=='quality_depart'){
            if($checker['buyer_status']!=1){
                $result['msg'] = '采购部负责人未通过审批！';
                goto _end;
            }
            $prefix = 'qa_';
        }elseif($reData['exam_type']=='quality_director'){
            if($checker['buyer_status']!=1){
                $result['msg'] = '采购部负责人未通过审批！';
                goto _end;
            }
            if($checker['qa_status']!=1){
                $result['msg'] = '质量管理部负责人未通过审批！';
                goto _end;
            }
            $prefix = 'principal_';
        }
        $reason = empty($reData['reason'])?($reData['status']==1?'同意':'不同意'):$reData['reason'];
        $data[$prefix.'reason'] = $reason;
        $data[$prefix.'code']   = $user;
        $data[$prefix.'date']   = date("Y-m-d H:i:s");
        $data[$prefix.'status'] = $reData['status'];
        Db::startTrans();
        $res = Db::name('gsp_first_approval')->where('orderid',$reData['orderid'])->update($data);
        $res1 = true;$res2 = true;$res3 = true;
        if($res && $checker['buyer_status']==1 && $checker['qa_status']==1 && $reData['status']==1){
            if($type == 1)$res1 = Db::name('gsp_first_goods')->where('orderid',$reData['orderid'])->update(['order_status'=>1]);
            else if($type == 2){
                $res1 = Db::name('gsp_first_enterprise')->where('orderid',$reData['orderid'])->update(['is_approval'=>1]);
                $field = 'supplier_code,name,name as full_name,mnemonic_code,business_leader_code as business_leader,enterprise_type,operation_mode,legal_person,economic_nature,quality_system,business_license,drug_license,post_code,area as address,tel,fax,bank_area,bank_account,tax_code,creator,orderid as firstdeal_no,business_license,gmp_two_license,gmp_two_validity_date,gmp_three_license,gmp_three_validity_date,mana_system as quality_regime,gsp_license,gsp_validity_date,business_validity_date,drug_validity_date,apparatus_license,quality_validity_date,attorney_validity_date,organization_license,organization_validity_date,food_license,food_validity_date,health_license,health_validity_date,apparatus_validity_date,depart_name,depart_id,output_year,major_honors,quality_organization,ddkindid';
                $reEnterprise = Db::name('gsp_first_enterprise')->where('orderid',$reData['orderid'])->field($field)->find();
                $reEnterprise['creator'] = $user;
                $reEnterprise['create_date'] = date('Y-m-d H:i',time());
                if(!$reEnterprise){
                    Db::rollback();goto _end;
                }
                $res2 = Db::name('providers')->insert($reEnterprise);
                unset($where);
                $where[] = ['supplier_code','=',$res1['supplier_code']];
                $where[] = ['kind','=',0];
                $proPhoto = Db::name('enterprise_photo')->where($where)->select()->toArray();
                if($proPhoto){
                    $newPhoto = [];
                    foreach ($proPhoto as $k=>$v){
                        $v['kind'] = 1;
                        $newPhoto[$k] = $v;
                    }
                    $res3 = Db::name('enterprise_photo')->insertAll($newPhoto);
                }
            }
            else $res1 = false;
        }
        if($res && $res1 && $res2 && $res3){
            $result = ['status'=>1,'msg'=>'审批成功！'];
            Db::commit();
        }else Db::rollback();
        _end:
        return $result;
    }
}