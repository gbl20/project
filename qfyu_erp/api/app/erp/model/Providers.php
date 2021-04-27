<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\ZJM;
use app\erp\validate\SupplierVal;
use think\facade\Db;
use think\Model;

Class Providers extends Model{
    public static function getSupplier(){
        $data = Providers::select()->toArray();
        return $data;
    }
    /**
     * 保存供应商信息
     * @param $inputData
     * @param $code
     * @return array
     */
    public static function comSupplier($inputData,$opCode){
        $res = ['status'=>0,'msg'=>'操作失败'];
        $fData = $inputData['fdata'];
        $reData = CommonFun::ProcessingData($fData,['qc_sex','audit_status','pause','qc_year','credit','credit_days','abckind','post_code','record_varieties','quality_man_count'],['output_year']);
        $validate = new SupplierVal();
        $val_res = $validate->scene('all')->check($reData);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $reData['is_production'] = strpos($reData['enterprise_type'],'生产企业')?1:0;
        if($reData['prov_kind']) DbWork::editDbWork(['label'=>$reData['prov_kind'],'value'=>$reData['prov_kind']],'prov_kind');
        if($reData['supplier_code']){
            $reData['updater'] = $opCode;
            $reData['update_date'] = date('Y-m-d H:i:s',time());
            $where[] = ['audit_status','=',0];
            $where[] = ['supplier_code','=',$reData['supplier_code']];
            $re = Providers::where($where)->strict(false)->update($reData);
        }else{
            $code = CommonFun::createCode('FS');
            $reData['supplier_code'] = $code;
            $reData['mnemonic_code'] = ZJM::character($reData['name']);
            $reData['creator'] = $opCode;
            $reData['create_date'] = date('Y-m-d H:i:s',time());
            $re = Providers::strict(false)->insert($reData);
        }
        if($re) $res = ['status'=>1,'msg'=>'保存成功','re_data'=>$reData];
        else $res['msg'] = '保存失败';
        _end:
        return $res;
    }
    /**
     * 审核供应商资料
     */
    public static function examSupplier($data,$code){
        $res = ['status'=>0,'msg'=>'审核失败'];
        $where[] = ['supplier_code','=',strip_tags($data['supplier_code'])];
        $where[] = ['audit_status','=',0];
        $upData['audit_status'] = 1;
        $upData['auditer'] = $code;
        $upData['update_date'] = date('Y-m-d H:i',time());
        $upData['updater'] = $code;
        $re = Providers::where($where)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'审核成功'];
        return $res;
    }
    /**
     * 撤销审核供应商资料
     */
    public static function revokeSupplier($data,$code){
        $res = ['status'=>0,'msg'=>'撤销失败'];
        $where[] = ['supplier_code','=',strip_tags($data['supplier_code'])];
        $where[] = ['audit_status','=',1];
        $upData['audit_status'] = 0;
        $upData['auditer'] = null;
        $upData['update_date'] = date('Y-m-d H:i',time());
        $upData['updater'] = $code;
        $re = Providers::where($where)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'撤销成功'];
        return $res;
    }

    /*****************供应商选择处理****************/
    /**
     * 选择供应商列表
     * @param $data 查询数据
     */
    public static function chooseProvidersList($data){
        $page=isset($data['page'])?intval($data['page']):1;
        $pageSize=isset($data['pageSize'])?intval($data['pageSize']):10;
        $where[]=['audit_status','=',1];
        if(isset($data['search'])){
            $search=$data['search'];
            if(!empty($search['supplier_code'])){
                $code=trim($search['supplier_code']);
                $where[]=['p.supplier_code','exp',Db::raw("like '%{$code}%' OR p.full_name like '%{$code}%' OR p.address like '%{$code}%'")];
            }
        }
        $field='subject_dept,supplier_code,name,full_name,enterprise_type,pay_mode_no,area,address,abckind,pause,remark,audit_status,business_leader';
        $list=Providers::where($where)->field($field)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
    /**
     * 选择供方销售人员（联系人）
     */
    public static function chooseSupSalesList($data){
        $where[]=['supplier_code','=',$data['sup_code']];
        if(isset($data['kind']) && intval($data['kind'])==1) $where[]=['exam_status','=',1];
        if(isset($data['search'])) {
            $search = $data['search'];
            if(!empty($search['user_name'])){
                $name=trim($search['user_name']);
                $where[]=['user_name','exp',Db::raw("like '%{$name}%' OR phone like '%{$name}%' OR tel like '%{$name}%'")];
            }
        }
        $field="supplier_code,user_name,sex,depart,duties,tel,phone,address,remark,attorney_no,content_power,DATE_FORMAT(validity_date,'%Y-%m-%d') as validity_date,attorney_validity,exam_status";
        $list = Db::name('providers_sales')->field($field)->where($where)->select()->toArray();
        return $list;
    }
    /**
     * 检测数据（自产产品：selfgoods 结算方式：paymode 业务负责人：provsales
     * @param $data 请求参数
     */
    public static function checkProv($data){
        $result=['status'=>0,'msg'=>'检测失败'];
        if(!isset($data['type']) || empty($data['sup_code'])) goto _end;
        $type=trim($data['type']);
        switch($type){
            case "paymode": //校验结算方式
                $hasSet=Db::name('providers')->field('pay_mode_no')->where(['supplier_code'=>$data['sup_code']])->find();
                if($hasSet!=null && !empty($hasSet['pay_mode_no'])){
                    $msg="如果在供应商资料中指定了结算方式，不能修改结算方式";
                    $result=['status'=>1,'msg'=>$msg,'paymode'=>$hasSet['pay_mode_no']];
                }
                break;
            case "provsales": //校验业务负责人
                $hasLeader=Db::name('providers')->alias('a')->field('a.business_leader,e.name as business_leader_name')
                    ->join('employee e','e.code=a.business_leader','left')
                    ->where(['supplier_code'=>$data['sup_code']])->find();
                if($hasLeader!=null && !empty($hasLeader['business_leader'])){
                    $msg="如果在供应商资料中指定了负责人，不能将业务员改为其他人！";
                    $result=['status'=>1,'msg'=>$msg,'leader'=>$hasLeader];
                }
                break;
            default: //校验自产产品
                $result=['status'=>0,'msg'=>'当前所选商品不在供应商自产品种列表中'];
                if(empty($data['gcode'])) goto _end;
                $where[]=['supplier_code','=',trim($data['sup_code'])];
                $sup=Db::name('providers')->field('is_production')->where($where)->find();
                if($sup==null) goto _end;
                if(intval($sup['is_production'])==1){
                    $hasNull=Db::name('providers_self_goods')->where($where)->count('goods_code');
                    if($hasNull==0){
                        $result=['status'=>1,'msg'=>'success'];goto _end;
                    }
                    $where[]=['goods_code','=',trim($data['gcode'])];
                    $hasGoods=Db::name('providers_self_goods')->where($where)->find();
                    if($hasGoods!=null){
                        $result=['status'=>1,'msg'=>'success'];
                    }
                }else{
                    $result=['status'=>1,'msg'=>'success'];
                }
                break;
        }
        _end:
        return $result;
    }
}

