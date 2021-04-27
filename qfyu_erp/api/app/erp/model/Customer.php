<?php
namespace app\erp\model;
use think\facade\Config;
use think\facade\Db;
use think\Model;

Class Customer extends Model {
    /**
     * 获取客户列表
     * @param array $map 查询条件
     * @param int $page 页码
     * @param int $pageSize 每页条数
     */
    public static function getList($map=[],$page=1,$pageSize=100){
        $list=self::alias('c')->field('c.*')->where($map)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toarray();
        $custom_type=Config::get('parameter.custom_type'); //企业类型
        $price_system=Db::name('commodity_price_system')->column('name','id');//价格体系
        $settlement=Settlement::column('name','code');//结算方案
        foreach ($list['data'] as $k=>$v){
            foreach ($v as $key=>$va){
                if(strpos($key,'date')!==false && !empty($va)) $list['data'][$k][$key]=date('Y-m-d',strtotime($va)); //日期全部去除时分秒
            }
            $list['data'][$k]['typebustxt']=(!empty($v['typebus']) && isset($custom_type[$v['typebus']]))?$custom_type[$v['typebus']]:'';
            $list['data'][$k]['priceshetxt']=(!empty($v['priceshe']) && isset($price_system[$v['priceshe']]))?$price_system[$v['priceshe']]:'';
            $list['data'][$k]['settlemodetxt']=(!empty($v['settlemode']) && isset($settlement[$v['settlemode']]))?$settlement[$v['settlemode']]:'';
            $list['data'][$k]['ddkindtxt']='';
            if(!empty($v['ddkindid'])){
                unset($mpp);
                $mpp[]=array('p.parent_id','>',0);
                $mpp[]=array('p.id','in',$v['ddkindid']);
                $plist=PermitKinds::alias('p')->field('p.name,pr.name as pname')->join('permit_kinds pr','pr.id=p.parent_id','LEFT')->where($mpp)->select()->toarray();
                foreach ($plist as $k2=>$v2){
                    $list['data'][$k]['ddkindtxt'].=$list['data'][$k]['ddkindtxt']==''?$v2['name']:'，'.$v2['name']; //拼接许可经营类别
                }
            }
        }
        return $list;
    }
    /**
     * 获取已设置的用户的经营类别(中文)
     */
    public static function getcustddk($selddk,$type=false){
        $map[]=array('p.parent_id','>',0);
        $map[]=array('p.id','in',$selddk);
        $list=PermitKinds::alias('p')->field('p.name,pr.name as pname')->join('permit_kinds pr','pr.id=p.parent_id','LEFT')->where($map)->select();
        if($type) exit(json_encode(['status'=>1,'selddk_txt'=>$list]));
        else return $list;
    }
    /**
     * 获取单个客户资料
     */
    public static function getCinfo($map=[]){
        $cinfo=self::field('*')->where($map)->find();
        $cfg['area']=AreaMgt::column('area_name','id');
        if(isset($cinfo['area']) && intval($cinfo['area'])>0) $cinfo['areatxt']=isset($cfg['area'][$cinfo['area']])?$cfg['area'][$cinfo['area']]:null;
        $cinfo['dept_name']=(isset($cinfo['department']) && !empty($cinfo['department']))?Db::name('depart')->where('id','=',$cinfo['department'])->value('dept_name'):'';
        return $cinfo;
    }

    /**
     * 获取客户简单信息列表
     */
    public static function getSimpleList($map=[],$page=1,$pageSize=10){
        $field="id,sname,name,comarea,charge,man,mannumber,telephone,remark,stopuser,priceshe,pricecoeff,quota,quotadata,settlemode,depart,mannumber,warehouse,swarehouse,twarehouse,deliroute,sdeliroute,tdeliroute";
        $list=self::field($field)->where($map)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }


    public static function getSellLimmit($code)
    {
      $where = array();
      $goods_name = Commodity::where('goods_code',$code)->value('goods_name');
      $id = CommoditySellLimit::where('goods_code',$code)->column('cust_id');
      if($id) $where[] = ['id','not in',$id];
      $field = 'id as cust_id,sname as cust_name';
      $res = self::field($field)->where($where)->select()->toArray();
      return ['status'=>1,'data'=>$res,'goods_name'=>$goods_name];
    }
}
