<?php
namespace app\erp\model;
use app\helper\CommonFun;
use think\facade\Db;
use think\Model;
/**
 * 库位管理-数据模型
 * @author wuzhogngui
 * @license 2020-10-28
 */
class WarePosition extends Model
{
    /**
     * 查询库位列表
     * @param $data 请求参数
     */
    public static function getWarePositionList($data){
        $list=[];
        if(isset($data['ware_code'])){
            $where[]=['ware_code','=',$data['ware_code']];
            if(!empty($data['search']['pos_code'])){
                $where[]=['pos_code','like','%'.trim($data['search']['pos_code']).'%'];
            }
            $field='id,pos_code,ware_code,pos_area,pos_desc,pos_deposit,remark,pos_long,pos_width,pos_height,pos_unit,pos_weight,pos_unit1,isstock,inventory_date';
            $list=Db::name('ware_position')->field($field)->where($where)->select()->toArray();
        }
       return $list;
    }
    /**
     * 新增、修改货位信息
     * @param $data 货位资料信息
     * @param $user 操作用户编码
     */
    public static function saveWarePos($data,$user){
        $result=['status'=>0,'msg'=>'货位保存失败'];
        $data=CommonFun::ProcessingData($data);
        if(empty($data['ware_code'])){
            $result['msg']="请选择仓库后创建货位";goto _end;
        }
        $posdata['pos_area']=isset($data['pos_area'])?trim(strip_tags($data['pos_area'])):'';
        $posdata['pos_desc']=isset($data['pos_desc'])?trim(strip_tags($data['pos_desc'])):'';
        $posdata['pos_deposit']=isset($data['pos_deposit'])?trim(strip_tags($data['pos_deposit'])):'';
        $posdata['remark']=isset($data['remark'])?trim(strip_tags($data['remark'])):'';
        $posdata['pos_long']=isset($data['pos_long'])?(float)$data['pos_long']:0;
        $posdata['pos_width']=isset($data['pos_width'])?(float)$data['pos_width']:0;
        $posdata['pos_height']=isset($data['pos_height'])?(float)$data['pos_height']:0;
        $posdata['pos_unit']=isset($data['pos_unit'])?trim(strip_tags($data['pos_unit'])):'';
        $posdata['pos_weight']=isset($data['pos_weight'])?(float)$data['pos_weight']:0;
        $posdata['pos_unit1']=isset($data['pos_unit1'])?trim(strip_tags($data['pos_unit1'])):'';
        $posdata['isstock']=(isset($data['isstock']) && intval($data['isstock'])==1)?1:0;
        $posdata['inventory_date']=date('Y-m-d H:i:s',time());
        if(!empty($data['inventory_date'])) $posdata['inventory_date']=trim(strip_tags($data['inventory_date']));
        $posdata['update_date']=date('Y-m-d H:i:s',time());
        $posdata['updater']=$user;
        if(isset($data['id']) && $data['id']){ //修改货位信息
            $res=Db::name('ware_position')->where(['id'=>$data['id']])->update($posdata);
            if($res){
                $result=['status'=>1,'msg'=>'货位更新成功'];
            }else $result=['status'=>0,'msg'=>'货位更新失败'];
        }else{
            $posdata['ware_code']=trim(strip_tags($data['ware_code']));
            //判断仓库是否是虚拟分级仓
            $hasWare=Db::name('warehouse')->where(['ware_code'=>$posdata['ware_code']])->find();
            if($hasWare==null || $hasWare['canvirtual']==1){
                $result['msg']="虚拟分级仓下不能建立货位";
                goto _end;
            }
            $posdata['pos_code']=CommonFun::createCode('WP');
            $posdata['create_date']=$posdata['update_date'];
            $posdata['creator']=$user;
            $res=Db::name('ware_position')->insert($posdata);
            if($res){
                $result=['status'=>1,'msg'=>'货位新增成功'];
            }else $result=['status'=>0,'msg'=>'货位新增失败'];
        }
        _end:
        return $result;
    }
}