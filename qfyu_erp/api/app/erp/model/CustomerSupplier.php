<?php
namespace app\erp\model;
use think\facade\Db;
use think\Model;
Class CustomerSupplier extends Model{
    /**
     * 联系人审核
     */
    public static function checkContact($data,$userData){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $postCode = $data['post_code'];
        $id = $data['param_data']['id'];
        if(!$id) goto _end;
        $CheckContact = self::where('id','=',$id)->field('salesdepart,qcdepart')->find();
        if(!$CheckContact) goto _end;
        $nowDate = date('Y-m-d H:i:s',time());
        if($postCode == 'sales_depart'){
            $upData['salesdepart'] = $userData['code'];
            $upData['salesdepart_date'] = $nowDate;
        }elseif($postCode == 'quality_depart'){
            if(!$CheckContact['salesdepart']){
                $res['msg'] = '销售部负责人尚未审核';
                goto _end;
            }
            $upData['qcdepart'] = $userData['code'];
            $upData['qcdepart_date'] = $nowDate;
        }elseif($postCode == 'quality_director'){
            if(!$CheckContact['qcdepart']){
                $res['msg'] = '质量管理部负责人尚未审核';
                goto _end;
            }
            $upData['qcid'] = $userData['code'];
            $upData['qc_date'] = $nowDate;
            $upData['check_status'] = 1;
        }else goto _end;
        $upData['updater'] = $userData['code'];;
        $upData['re_date'] = $nowDate;
        $re = self::where('id','=',$id)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'审核成功','data'=>$upData];
        _end:
        return $res;
    }
    public static function queryList($params){
        $res = ['status'=>0,'msg'=>'init'];
        if(isset($params['cust_no']) && !empty($params['cust_no'])){
            $map[] = ['cid','=',strip_tags($params['cust_no'])];
        }else goto _end;
        if(isset($params['type']) && intval($params['type']) == 1){
            $map[] = ['check_status','=',1];
        }
        if(isset($params['keyword']) && !empty($params['keyword'])){
            $map[] = ['user_name|phone|tel','like','%'.strip_tags($params['keyword']).'%'];
        }
        $list = Db::name('customer_supplier')->field('*')->where($map)->select()->toArray();
        $res = ['status'=>1,'data'=>$list,'msg'=>'Success'];
        _end:
        return $res;
    }
    /**
     * 客户资质审核
     */
    public static function checkUser($data,$userData){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $postCode = $data['post_code'];
        $id = $data['param_data']['id'];
        if(!$id) goto _end;
        $ydata=Db::name('customer')->field('sales_man_status,quality_adm_status,quality_depart_status,quality_man_status,isvalid')->where('id','=',$id)->find();
        if(!$ydata) goto _end;
        if($ydata['isvalid']==1){
            $res['msg']='用户资质已审核，无需再次审核';
            goto _end;
        }
        $nowDate = date('Y-m-d H:i:s',time());
        $errmsg=[
            ['key'=>'sales_man_status','msg'=>'销售部负责人尚未审核'],
            ['key'=>'quality_adm_status','msg'=>'质量管理员尚未审核'],
            ['key'=>'quality_depart_status','msg'=>'质量管理部负责人尚未审核']
        ];
        $endkey=-1;
        if($postCode == 'quality_admin') $endkey=0;
        elseif($postCode == 'quality_depart') $endkey=1;
        elseif($postCode == 'quality_director') $endkey=2;
        for($i=0;$i<=$endkey;$i++){
            if($ydata[$errmsg[$i]['key']]!=1){
                $res['msg']=$errmsg[$i]['msg'];
                goto _end;
            }
        }
        if($postCode=='sales_depart'){
            $upData['sales_man_status']=1;
            $upData['sales_man']=$userData['code'];
            $upData['sales_man_date']=$nowDate;
            $upData['sales_man_remark']=empty($data['param_data']['remark'])?'同意':trim($data['param_data']['remark']);
            $ydata['sales_man_status']=1;
        }elseif ($postCode == 'quality_admin'){
            $upData['quality_adm_status']=1;
            $upData['quality_adm']=$userData['code'];
            $upData['quality_adm_date']=$nowDate;
            $upData['quality_adm_remark']=empty($data['param_data']['remark'])?'同意':trim($data['param_data']['remark']);
            $ydata['quality_adm_status']=1;
        }elseif ($postCode == 'quality_depart'){
            $upData['quality_depart_status']=1;
            $upData['quality_depart']=$userData['code'];
            $upData['quality_depart_date']=$nowDate;
            $upData['quality_depart_remark']=empty($data['param_data']['remark'])?'同意':trim($data['param_data']['remark']);
            $ydata['quality_depart_status']=1;
        }elseif ($postCode == 'quality_director'){
            $upData['quality_man_status']=1;
            $upData['quality_man']=$userData['code'];
            $upData['quality_man_date']=$nowDate;
            $upData['quality_man_remark']=empty($data['param_data']['remark'])?'同意':trim($data['param_data']['remark']);
            $ydata['quality_man_status']=1;
        }
        if($ydata['sales_man_status']==1 && $ydata['quality_adm_status']==1 && $ydata['quality_depart_status']==1 && $ydata['quality_man_status']==1) $upData['isvalid']=1;
        else $upData['isvalid']=0;
        $upData['retime'] = time();
        $re = Db::name('customer')->where('id','=',$id)->update($upData);
        unset($upData['retime']);
        foreach ($upData as $key=>$va){
            if(strpos($key,'date')!==false && !empty($va)) $upData[$key]=date('Y-m-d',strtotime($va)); //日期全部去除时分秒
        }
        if($re) $res = ['status'=>1,'msg'=>'审核成功','data'=>$upData];
        _end:
        return $res;
    }
}
