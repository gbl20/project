<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\PurchaseContractVal;
use think\facade\Db;
use think\Model;
/**
 * 合同管理-业务模型类
 * @author wuzhonggui
 * @license 2020-11-25
 */
class PurchaseContract extends Model
{
    /**
     * 选择合同
     * @param $data 搜索条件
     */
    public static function choosePurchaseContractList($data){
        $where[]=['a.sup_code','=',$data['sup_code']];
        if(isset($data['search'])){
            $search=$data['search'];
            if(!empty($search['orderid'])){
                $orderid=trim($search['orderid']);
                $where[]=['a.orderid','exp',Db::raw("like '%{$orderid}%' OR a.title like '%{$orderid}%'")];
            }
        }
        $field="a.orderid,a.title,a.delivery,a.sign_date,a.start_date,a.validity_date,a.sign_area,a.sign_code,a.sign_name,a.pay_date,a.create_date,a.explain,st.name as settlement_name";
        $list=Db::name('purchase_contract')->alias('a')->field($field)->join('settlement st','st.id=a.settlement','left')->where($where)->select()->toArray();
        return $list;
    }


    /**
     * 根据查询条件查询合同列表数据
     * @param $data 查询数据
     */
    public static function getPurchaseContractList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?8:intval($data['pageSize']);
        $where=[];
        $field='a.*,p.full_name as sup_name,st.name as settlement_name,dt.dept_name';
        $list=Db::name('purchase_contract')->alias('a')->field($field)
            ->join('providers p','p.supplier_code=a.sup_code','left')
            ->join('settlement st','st.id=a.settlement','left')
            ->join('depart dt','dt.id=a.dept_id','left')
            ->where($where)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])
            ->toArray();
        return $list;
    }


    /**
     * 根据合同号，查询合同资料信息
     */
    public static function getPurchaseContractByOrderId($data){
        $contract=null;
        if(empty($data['orderid'])) goto _end;
        $field='a.*,p.full_name as sup_name';
        $contract=Db::name('purchase_contract')->alias('a')->field($field)
                ->join('providers p','p.supplier_code=a.sup_code','left')
                ->where(['orderid'=>$data['orderid']])
                ->find();
        _end:
        return $contract;
    }
    /**
     * 保存合同资料
     * @param $data 合同资料
     * @param $user 操作人
     */
    public static function savePurchaseContract($data,$user){
        $result=['status'=>0,'msg'=>'保存合同失败'];
        $data=CommonFun::ProcessingData($data);
        $validate=new PurchaseContractVal();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();goto _end;
        }
        //判断供应商是否有效
        $hassup=Db::name('providers')->field('supplier_code')->where(['supplier_code'=>$data['sup_code']])->find();
        if($hassup==null){
            $result['msg']="请选择供应商编号";goto _end;
        }
        //判断签约人是否正确
        $hasSign=Db::name('employee')->field('code,name')->where(['code'=>$data['sign_code']])->find();
        if($hasSign==null){
            $result['msg']="请选择签约人";goto _end;
        }
        //验证结算方式
        $hasSet=Db::name('settlement')->field('id,code')->where(['id'=>$data['settlement']])->find();
        if($hasSet==null){
            $result['msg']="请选择结算方式";goto _end;
        }
        //获取资源所属
        $employee=Db::name('employee')->field('code,name,depart_id')->where(['code'=>$user])->find();
        $condata['title']=$data['title'];
        $condata['sup_code']=$data['sup_code'];
        $condata['delivery']=$data['delivery'];
        $condata['sign_area']=$data['sign_area'];
        $condata['sign_date']=$data['sign_date'];
        $condata['sign_code']=$hasSign['code'];
        $condata['sign_name']=$hasSign['name'];
        $condata['settlement']=$hasSet['id'];
        $condata['pay_date']=$data['pay_date'];
        $condata['explain']=$data['explain'];
        $condata['filepath']=$data['filepath'];
        $condata['dept_id']=$employee['depart_id'];
        $condata['start_date']=$data['start_date'];
        $condata['validity_date']=$data['validity_date'];
        $condata['updator']=$user;
        $condata['update_date']=date('Y-m-d H:i:s',time());
        $orderid=''; //合同号
        if(isset($data['orderid']) && $data['orderid']){
            $orderid=$data['orderid'];
            $res=Db::name('purchase_contract')->where(['orderid'=>$data['orderid']])->update($condata);
            if($res) $result=['status'=>1,'msg'=>'合同修改成功','orderid'=>$orderid];
        }else{
            $orderid=$condata['orderid']=CommonFun::createOrder('CH'); //合同号
            $condata['creator']=$user;
            $condata['create_date']=$condata['update_date'];
            $res=Db::name('purchase_contract')->insert($condata);
            if($res) $result=['status'=>1,'msg'=>'合同创建成功','orderid'=>$orderid];
        }
        _end:
        return $result;
    }
}