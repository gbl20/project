<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\PurchaseLackVal;
use think\facade\Db;
use think\Model;
/**
 * 采购-缺货登记业务操作类
 * @author wuzhonggui
 * @license 2020-11-17
 */
class PurchaseLackMod extends Model
{
    /**
     * 查询缺货登记列表
     * @param $data 查询参数
     */
    public static function getLackList($data){
        $where=[];
        $field='pl.*,(0+cast(pl.total as char)) as total,e.name as emp_name,em.name as create_name,d.dept_name';
        $list=Db::name('purchase_lack')->alias('pl')->field($field)
                ->join('employee e','e.code=pl.emp_code','left')
                ->join('depart d','d.id=pl.deptid','left')
                ->join('employee em','em.code=pl.creator','left')
                ->select();
        return $list;
    }
    /**
     * 查询缺货登记单据资料
     * @param $data 查询条件
     */
    public static function getLackOrderById($data){
        $order=null;
        $glist=[];
        if(!isset($data['orderid'])) goto _end;
        $field='a.orderid,a.register_date,a.validity_date,a.emp_code,a.nums,a.total,a.remark,a.ischeck,a.check_code,a.istrans,a.creator,e.name as emp_name';
        $order=Db::name('purchase_lack')->alias('a')->field($field)
                ->join('employee e','e.code=a.emp_code','left')
                ->where(['orderid'=>$data['orderid']])->find();
        if($order==null) goto _end;
        //获取订单详情
        $defield='de.*,(0+cast(de.nums AS CHAR)) AS nums,(0+cast(de.already_nums AS CHAR)) AS already_nums,c.id,c.goods_code,c.name,c.goods_name,c.specs,c.dosage,c.origin,c.production,c.packspecs,c.approval_code';
        $glist=Db::name('purchase_lack_details')->alias('de')->field($defield)
              ->join('commodity_list c','c.goods_code=de.goodsid','left')
              ->where(['orderid'=>$data['orderid']])->select();
        _end:
        return ['order'=>$order,'glist'=>$glist];
    }
    /**
     * 保存缺货登记单据
     * @param $data 单据资料
     * @param $user 操作用户
     */
    public static function saveLackOrder($data,$user){
        $result=['status'=>0,'msg'=>'保存失败'];
        $data=CommonFun::ProcessingData($data);
        //处理表单验证
        $validate = new PurchaseLackVal();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();
            goto _end;
        }
        $glist=(isset($data['glist']) && is_array($data['glist']))?$data['glist']:[];
        if(!empty($data['validity_date'])){
            $lackdata['validity_date']=$data['validity_date'];
        }
        $lackdata['emp_code']=empty($data['emp_code'])?'':$data['emp_code'];
        $lackdata['nums']=count($glist);
        $lackdata['total']=isset($data['total'])?$data['total']:0;
        $lackdata['remark']=empty($data['remark'])?'':strip_tags($data['remark']);
        $lackdata['updator']=$user;
        $lackdata['update_date']=date('Y-m-d H:i:s',time());
        Db::startTrans();
        try{
            $res1=0;
            $orderid=CommonFun::createOrder('QH');
            if(isset($data['orderid']) && $data['orderid']){
                $orderid=$data['orderid'];
                $order=Db::name('purchase_lack')->field('orderid,ischeck')->where(['orderid'=>$data['orderid']])->find();
                if($order==null || $order['ischeck']==1){
                    $result['msg']='订单已审核，不能再进行编辑操作';
                    goto _end;
                }
                $res1=Db::name('purchase_lack')->where(['orderid'=>$data['orderid']])->update($lackdata);
            }else{
                $lackdata['orderid']=$orderid;
                $lackdata['register_date']=date('Y-m-d',time());
                $employee=Db::name('employee')->field('code,name,depart_id')->where(['code'=>$user])->find();
                $lackdata['deptid']=$employee['depart_id'];
                $lackdata['creator']=$user;
                $lackdata['create_date']=$lackdata['update_date'];
                $res1=Db::name('purchase_lack')->insert($lackdata);
            }
            $goodslist=[]; //详情列表
            foreach($glist as $k=>$v){
                $arr['item_no']=$k+1;
                $arr['orderid']=$orderid;
                $arr['goodsid']=$v['goodsid'];
                $arr['unit']=$v['unit'];
                $arr['nums']=$v['nums'];
                $arr['already_nums']=$v['already_nums'];
                $arr['explain']=$v['explain'];
                array_push($goodslist,$arr);
            }
            $res2=0;$res3=0;
            if($res1){
                $hasDtl=Db::name('purchase_lack_details')->field('item_no')->where(['orderid'=>$orderid])->find();
                if($hasDtl!=null){
                    $res2=Db::name('purchase_lack_details')->where(['orderid'=>$orderid])->delete();
                }else $res2=1;
                $res3=count($goodslist)>0?Db::name('purchase_lack_details')->insertAll($goodslist):1;
            }
            if($res1 && $res2 && $res3){
                Db::commit();
                $msg=(isset($data['orderid']) && $data['orderid'])?'修改保存成功':'新增保存成功';
                $result=['status'=>1,'msg'=>$msg,'orderid'=>$orderid];
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            $result['msg']=$e->getMessage();
            Db::rollback();
        }
        _end:
        return $result;
    }
    /**
     * 审核
     * @param $data 审核资料
     * @param $user 审核人
     */
    public static function checkLackOrder($data,$user){
        $result=['status'=>0,'msg'=>'审核失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_lack')->field('orderid,ischeck')->where(['orderid'=>$data['orderid']])->find();
        if($order['ischeck']==1){
            $result['msg']='订单已审核，请勿重复审核';
            goto _end;
        }
        $odata['ischeck']=1;
        $odata['check_code']=$user;
        $odata['check_date']=date('Y-m-d H:i:s',time());
        $res=Db::name('purchase_lack')->where(['orderid'=>$data['orderid']])->update($odata);
        if($res){
            $result=['status'=>1,'msg'=>'审核成功'];
        }
        _end:
        return $result;
    }
    /**
     * 还原
     */
    public static function resetCheckLackOrder($data,$user){
        $result=['status'=>0,'msg'=>'审核失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_lack')->field('orderid,ischeck,istrans')->where(['orderid'=>$data['orderid']])->find();
        if($order['ischeck']!=1){
            $result['msg']='订单未审核，无需还原操作';goto _end;
        }
        if($order['istrans']==1){
            $result['msg']='订单已转单，不能进行还原操作';goto _end;
        }
        $odata['istrans']=0;
        $odata['ischeck']=0;
        $odata['updator']=$user;
        $odata['update_date']=date('Y-m-d H:i:s',time());
        $res=Db::name('purchase_lack')->where(['orderid'=>$data['orderid']])->update($odata);
        if($res){
            $result=['status'=>1,'msg'=>'还原成功'];
        }
        _end:
        return $result;
    }
    /**
     * 删除
     * @param $data 请求信息
     * @param $user 操作人
     */
    public static function deleteLackOrder($data,$user){
        $result=['status'=>0,'msg'=>'删除失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_lack')->field('orderid,ischeck,istrans')->where(['orderid'=>$data['orderid']])->find();
        if($order==null || $order['ischeck']==1 || $order['istrans']==1){
            $result['msg']='单据已审核或已转单，不能进行删除';
            goto _end;
        }
        Db::startTrans();
        $res1=Db::name('purchase_lack')->where(['orderid'=>$data['orderid']])->delete();
        $hasDtl=Db::name('purchase_lack_details')->where(['orderid'=>$data['orderid']])->find();
        $res2=$hasDtl==null?1:Db::name('purchase_lack_details')->where(['orderid'=>$data['orderid']])->delete();
        if($res1 && $res2){
            Db::commit();
            $result=['status'=>1,'msg'=>'删除已成功'];
        }else{
            Db::rollback();
        }
        _end:
        return $result;
    }
    /**
     * 转单（转采购计划单）
     */
    public static function transPlanOrder($data,$user){
        $result=['status'=>0,'msg'=>'转单失败'];
        if(empty($data['orderid'])) goto _end;
        $order=Db::name('purchase_lack')->where(['orderid'=>$data['orderid']])->find();
        if($order['ischeck']!=1){
            $result['msg']="单据未审核，不能进行转单";goto _end;
        }
        $list=Db::name('purchase_lack_details')->where(['orderid'=>$data['orderid']])->select()->toArray();
        if(count($list)==0){
            $result['msg']="单据未设置产品明细，不能进行转单";goto _end;
        }
        $nowDate=date('Y-m-d H:i:s',time());
        $plandata['orderid']=CommonFun::createOrder('JH');
        $plandata['typeid']=1;
        $plandata['prepared_date']=$nowDate;
        $plandata['invalid_date']=date('Y-m-d H:i:s',time()+7*24*3600);
        $plandata['nums']=count($list);
        $plandata['creator']=$plandata['updater']=$user;
        $plandata['creator_date']=$plandata['updater_date']=$nowDate;
        $plandata['remark']='该订单由采购缺货登记单转入';
        $planDtl=[];
        foreach ($list as $k=>$v){
            $planDtl[$k]['itemno']=$v['item_no'];
            $planDtl[$k]['orderid']=$plandata['orderid'];
            $planDtl[$k]['goodsid']=$v['goodsid'];
            $planDtl[$k]['unit']=$v['unit'];
            $planDtl[$k]['buynum']=$v['nums'];
            $planDtl[$k]['remark']=$v['explain'];
        }
        Db::startTrans();
        try {
            $transdata['istrans']=1;
            $transdata['updator']=$user;
            $transdata['update_date']=$nowDate;
            $res1=Db::name('purchase_lack')->where(['orderid'=>$data['orderid']])->update($transdata);
            $res2=Db::name('purchase_plan')->insert($plandata);
            $res3=Db::name('purchase_plan_details')->insertAll($planDtl);
            if($res1 && $res2 && $res3){
                Db::commit();
                $result=['status'=>1,'msg'=>'转单已成功','orderid'=>$plandata['orderid']];
            }else{
                Db::rollback();
            }
        }catch (\Exception $e){
            $result['msg']=$e->getMessage();
            Db::rollback();
        }
        _end:
        return $result;
    }
}