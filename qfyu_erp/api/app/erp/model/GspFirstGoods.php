<?php

namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\Enc;
use app\erp\validate\NewVarietiesVal;
use Cassandra\Date;
use think\facade\Db;
use think\Model;

class GspFirstGoods extends Model
{
    /**
     *  首营产品申请列表
     * @param $data array $data['search'] 搜索条件  page分页  page_size分页条数
     **/

    public static function get_first_goods_list($data,$user)
    {
        $where   = array();
        $search = $data['search'];
        if (!empty($search['goods_name'])){
            $where[] = ['goods_name','like','%'.$search['goods_name'].'%'];
        }
        if (!empty($search['status'])) $where[] = ['g.status','=',$search['status']];
        if (!empty($search['order_status'])) $where[] = ['g.order_status','=',$search['order_status']];
        if(!empty($data['page_size'])) $limit = $data['page_size'];
        $res = Db::name('gsp_first_goods')->alias('g')
                ->join('gsp_first_approval a','a.orderid=g.orderid','left')
                ->where($where)
                ->paginate(['list_rows'=>$limit,'page'=>$data['page']])->toArray();
        $res['next_page'] = ($res['current_page']+1) > $res['last_page'] ? 0 : $res['current_page']+1;
        $result = ['status'=>1,'data'=>$res];
        return $result;
    }
    /***
     * 公共方法 首营品种列表
    **/
    public static function comFirstGoodsList()
    {
        $where[] = ['order_status','=',1];
        $where[] = ['new_state','=',0];
        $field = 'orderid,create_date,goods_name,goods_code,name,en_name,dosage,unit,specs,description,pack_specs1,pack_specs2,quality_standards,standard_code,approval_code,approval_date,kinds_id,category_id,function_id,top_fid,parent_fid,gsp_type,origin,remark,production,gmp_code,gmp_end_date,factory_price,buyer_price,trade_price,retail_price,storage_type,license_key,license_date';
        $res = Db::name('gsp_first_goods')->field($field)->where($where)->paginate(10)->toArray();
        if (!empty($res['data'])) {
            foreach ($res['data'] as $k=>$v){
                $res['data'][$k]['function_id'] = [$v['top_fid'],$v['parent_fid'],$v['function_id']];
            }
        }
        $res['next_page'] = ($res['current_page']+1) > $res['last_page'] ? 0 : $res['current_page']+1;
        $result = ['status'=>1,'data'=>$res];
        return $result;
    }

    /**
     * 订单详情
     * @param string $oid 首营品种申请订单单据编号
    **/
    public static function getGspFirstGoodsInfo($data)
    {
        $result  = ['status'=>1,'msg'=>'Success'];
        $edit_type = 0;//默认新增
        $admData = null;
        if(!empty($data['orderid'])) {
            $edit_type = 1;
            $map[] = ['g.orderid', '=' ,$data['orderid']];
            $field = 'g.*,e.name as creator_name,em.name as reviser_name,d.dept_name as depart_name,k.name as kinds_name';
            $result['info'] = GspFirstGoods::where($map)->alias('g')
                ->field($field)
                ->join('employee e','e.code=g.creator','left')
                ->join('employee em','em.code=g.reviser','left')
                ->join('depart d','d.id=g.depart_id','left')
                ->join('permit_kinds k','k.id=g.kinds_id','left')
                ->find();
            $admData = Db::name('gsp_first_approval')->where('orderid',$data['orderid'])->find();
            if (!empty($result['info'])){
                $result['info']['function_id'] = [(int)$result['info']['top_fid'],(int)$result['info']['parent_fid'],(int)$result['info']['function_id']];
            }
        }
        $result['category'] = PermitKinds::getCommodityCategory();
        $kind = PermitKinds::get_permit_list();
        $result['custom']   = $kind['data'];
        $result['function'] = PermitKinds::getKindsLCascaber();
        $result['unit']     = config('parameter.goods_unit');
        $result['dosage']   = config('parameter.dosage');
        $result['gsp_type'] = config('parameter.gsp_category');
        $result['storage_type'] = config('parameter.storage');
        $result['type'] = $edit_type;
        $result['admData'] = $admData;
        return $result;

    }
    /**
     * 新增-修改首营产品 *
     * @param array $search 产品资料
     * @param string $search['orderid'] 首营品种申请订单单据编号，不为空的时候为编辑否则新增
     */
    public static function add_goods_info($datas,$user)
    {
        $result  = ['status'=>0,'msg'=>'新增失败！'];
        $data = CommonFun::ProcessingData($datas['data'],['kinds_id','kinds_kid']);
        $validate = new NewVarietiesVal();
        $check    = $validate->scene('all')->check($data);
        if(!$check){
            $result['msg'] = $validate->getError();
            goto _end;
        }
        $data['depart_id']  = $data['depart_id'];
        $data['goods_name'] = empty($data['goods_name'])?$data['name']:$data['goods_name'];
        $data['description']= substr($data['description'],0,255);
        $data['remark']     = substr($data['remark'],0,100);
        $fid = end($data['function_id']);
        $kinds = Db::name('commodity_function')->column('parent_id','id');
        $data['function_id'] = $fid;
        $data['parent_fid'] = $kinds[$fid];
        $data['top_fid'] = $data['parent_fid']?$kinds[$data['parent_fid']]:null;
        unset($data['depart_name']);
        unset($data['kinds_name']);
        $orderid = GspFirstGoods::where('orderid',$data['orderid'])->field('orderid')->find();
        if(!$orderid){
            //新增首营产品
            $data['orderid']    = CommonFun::createOrder('FG');
            $data['goods_code'] = CommonFun::createCode('FG','create_date');
            $data['creator']    = $user;
            $data['creator_date']= date("Y-m-d H:i:s");
            Db::startTrans();
            $res = GspFirstGoods::create($data);
            $res1 = Db::name('gsp_first_approval')->insert(['orderid'=>$data['orderid']]);
            if($res && $res1) {
                Db::commit();
                $result = ['status'=>1,'msg'=>'新增成功！','orderid'=>$data['orderid']];
            }else{
                Db::rollback();
            }
        }else{
            //修改首营产品资料
            unset($data['creator_name']);
            unset($data['reviser_name']);
            $data['reviser'] = $user;
            $data['reviser_date'] = date("Y-m-d H:i:s");
            $orderid = $datas['orderid'];
            $res = GspFirstGoods::where('orderid','=',$orderid)->update($data);
            if ($res) $result = ['status'=>1,'msg'=>'修改成功','orderid'=>$orderid];
            else $result = ['status'=>0,'msg'=>'修改失败'];
        }
        _end:
        return $result;
    }

    /** 审核首营产品资料 **/
    public static function check_first_goods($orderid,$uid)
    {
        $result = ['status'=>0,'msg'=>'审核失败'];
        if(!isset($orderid)) goto _end;
        $map[] = ['orderid','=',$orderid];
        $has_status = GspFirstGoods::where($map)->field('status')->find();
        if($has_status['status']!=0){
            $result['msg'] = '该单据不需要审核';
            goto _end;
        }
        $data['status'] = 1;
        $data['reviser'] = $uid;
        $data['reviser_date'] = date("Y-m-d H:i:s");
        $data['audit_date'] = date("Y-m-d H:i:s");
        $res = GspFirstGoods::where('orderid','=',$orderid)->update($data);
        if ($res) $result = ['status'=>1,'msg'=>'审核成功'];
        _end:
        return $result;
    }

    /** 各部门负责人首营品种审批 **/
    public static function adm_check_first_goods($data,$user)
    {
        $result = ['status'=>0,'msg'=>'审批失败'];
        $data = CommonFun::ProcessingData($data);
        $has_user = Db::name('employee')->where('code',$data['code'])->value('id');
        if(!$has_user){
            $result['msg'] = '验证用户身份失败！请重新输入。';
            goto _end;
        }
        if ($data['code']!== $user){
            $result['msg'] = '审批人与登录账户不一致，禁止审批！根据系统设置，审批首营资料必须是本人登录系统。';
            goto _end;
        }
        $has_pwd = Db::name('operators')->where('emp_id',$has_user)->value('passwd');
        $pwd = Enc::encrypt($data['pwd']);
        if($pwd !== $has_pwd){
            $result['msg'] = '用户识别密码不正确！请重新输入。';
            goto _end;
        }
        $has_check = GspFirstGoods::where('orderid',$data['orderid'])->value('order_status');
        if($has_check){
            $result['msg'] = '该订单不需要审批';
            goto _end;
        }
        $res = self::checkOrder($data,$user);
        if ($res['status']==1) $result = ['status'=>1,'msg'=>$res['msg']];
        else $result['msg'] = $res['msg'];
        _end:
        return $result;
    }

    public static function checkOrder($datas,$user)
    {
        $result = ['status'=>0,'msg'=>'审核失败！'];
        $reason = empty($datas['reason'])?($datas['status']==1?'同意':'不同意'):$datas['reason'];
        $data[$datas['prefix'].'reason'] = $reason;
        $data[$datas['prefix'].'code']   = $user;
        $data[$datas['prefix'].'date']   = date("Y-m-d H:i:s");
        $data[$datas['prefix'].'status'] = $datas['status'];
        $checker = Db::name('gsp_first_approval')->where('orderid',$datas['orderid'])->find();
        if($datas['name']=='qa_code'){
            if($checker['buyer_status']!=1){
                $result['msg'] = '采购部负责人未通过审批！';
                goto end;
            }
        }elseif($datas['name']=='principal_code'){
            if($checker['buyer_status']!=1){
                $result['msg'] = '采购部负责人未通过审批！';
                goto end;
            }
            if($checker['qa_status']!=1){
                $result['msg'] = '质量管理部负责人未通过审批！';
                goto end;
            }
        }
        $res = Db::name('gsp_first_approval')->where('orderid',$datas['orderid'])->update($data);
        if($res){
            if($checker['buyer_status']==1 && $checker['qa_status']==1 && $datas['status']==1){
                $res1 = GspFirstGoods::where('orderid',$datas['orderid'])->update(['order_status'=>1]);
                if(!$res1) $result['msg'] = '订单状态更新失败！';
            }
            $result = ['status'=>1,'msg'=>'审批成功！'];
        }
        end:
        return $result;
    }

    public static function goodsPhoto($code)
    {
        $where[] = ['goods_code','=',$code];
        $where[] = ['status','=',0];
        $result['goods_img'] = Db::name('goods_photo')->where($where)->select()->toArray();
        $result['img_item'] = config('parameter.img_config.goods');
        $result['status']=1;
        return $result;
    }
}
