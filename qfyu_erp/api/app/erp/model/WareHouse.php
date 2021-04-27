<?php
namespace app\erp\model;
use app\erp\controller\aa;
use app\helper\CommonFun;
use app\erp\validate\WarehouseVal;
use think\facade\Db;
use think\Model;
/**
 * 仓库管理模型数据类
 * @author wuzhonggui
 * @license 2020-10-27
 */
class WareHouse extends Model
{
    /**
     * 查询仓库资料列表
     * @param 请求参数
     */
    public static function getWareList($param){
        $where[]=['w.candel','=',1]; //未删除
        $field='w.*,lock.ware_code as haslock';
        $order="w.id desc";
        $lockSql=Db::name('ware_locked')->field('ware_code')->group('ware_code')->buildSql();
        $list=Db::name('warehouse')->alias('w')->field($field)
            ->join('warehouse p','p.ware_code=w.parent_code','left')
            ->join([$lockSql=> 'lock'], 'lock.ware_code = w.ware_code','left')
            ->where($where)->order($order)->select()->toArray();
        $list=self::listToTree($list);
        return $list;
    }
    /**
     * 将列表转换成树形列表
     * @param $list 数据列表
     * @param string $pk 主键字段名
     * @param string $pid 上级字段名
     * @param string $child 子集列表名称
     * @param int $root 上级字段值
     */
    private static function listToTree(&$datas,$parent_id='0'){
        $result=array();
        foreach ($datas as $k=>$data){
            if ($data['parent_code']==$parent_id){
                unset($datas[$k]);
                $data['children'] = self::listToTree($datas,$data['ware_code']);
                $result[]=$data;
            }
        }
        return $result;
    }
    /**
     * 新增、编辑仓库初始化查询
     */
    public static function wareInit(){
        //价格体系列表
        $where[]=['status','=',1];
        $pricelist=Db::name('commodity_price_system')->field('id,name')->where($where)->select()->toArray();
        $cfg['pricelist']=$pricelist;
        $result=['status'=>1,'msg'=>'success','cfg'=>$cfg];
        return $result;
    }
    /**
     * 新增、编辑保存仓库资料
     * @param $data 仓库资料数据
     * @param $user 操作用户编码
     */
    public static function saveWare($data,$user){
        $result=['status'=>0,'msg'=>'仓库资料保存失败'];
        //验证表单数据
        $validate = new WarehouseVal();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();
            goto _end;
        }
        if(!isset($data['deptid'])){
            $result['msg']="请选择所属公司";goto _end;
        }
        if(isset($data['pos_code']) && trim($data['pos_code'])){
            //校验默认货位是否正确
            $hasPos=Db::name('ware_position')->field('pos_code')->where(['pos_code'=>trim($data['pos_code'])])->find();
            if($hasPos==null){
                $result['msg']="请选择正确的默认货位";goto _end;
            }
        }
        $waredata['pos_code']=(isset($data['pos_code']) && trim($data['pos_code']))?trim(strip_tags($data['pos_code'])):'';
        $waredata['ware_title']=strip_tags($data['ware_title']);
        $waredata['ware_deptid']=$data['deptid'];
        $waredata['ware_area']=strip_tags($data['ware_area']);
        $waredata['retail_pid']=(isset($data['retail_pid']) && $data['retail_pid'])?intval($data['retail_pid']):0;
        $waredata['move_pid']=(isset($data['move_pid']) && $data['move_pid'])?intval($data['move_pid']):0;
        $waredata['limit_pid']=(isset($data['limit_pid']) && $data['limit_pid'])?intval($data['limit_pid']):0;
        $waredata['user_pid']=(isset($data['user_pid']) && $data['user_pid'])?intval($data['user_pid']):0;
        $waredata['phone']=strip_tags($data['phone']);
        $waredata['fax']=strip_tags($data['fax']);
        $waredata['ware_empid']=strip_tags($data['ware_empid']);
        $waredata['ware_examid']=strip_tags($data['ware_examid']);
        $waredata['region']=strip_tags($data['region']);
        $waredata['address']=strip_tags($data['address']);
        $waredata['remark']=strip_tags($data['remark']);
        $waredata['storage_id']=(isset($data['storage_id']) && $data['storage_id'])?intval($data['storage_id']):0;
        $waredata['type_id']=(isset($data['type_id']) && $data['type_id'])?intval($data['type_id']):0;
        $waredata['canbyonline']=(isset($data['canbyonline']) && intval($data['canbyonline'])==1)?1:0;
        $waredata['canbyonsale']=(isset($data['canbyonsale']) && intval($data['canbyonsale'])==1)?1:0;
        $waredata['cannotice']=(isset($data['cannotice']) && intval($data['cannotice'])==1)?1:0;
        $waredata['update_date']=date("Y-m-d H:i:s");
        $waredata['updater']=$user;
        $waredata['canheadoffice']=(isset($data['canheadoffice']) && intval($data['canheadoffice'])==1)?1:0;
        $waredata['canvirtual']=(isset($data['canvirtual']) && intval($data['canvirtual'])==1)?1:0;
        $waredata['cancomplete']=(isset($data['cancomplete']) && intval($data['cancomplete'])==1)?1:0;
        if(isset($data['id']) && $data['id']){
            $hasware=Db::name('warehouse')->field('canvirtual')->where(['id'=>$data['id']])->find();
            if($hasware==null){
                $result['msg']="仓库数据参数异常，修改失败";goto _end;
            }
            if($hasware['canvirtual']==0){
                unset($waredata['canheadoffice']);
                unset($waredata['canvirtual']);
                unset($waredata['cancomplete']);
            }
        }
        if(isset($data['id']) && $data['id']){ //更新仓库
            $map[]=['id','=',$data['id']];
            $res=Db::name('warehouse')->where($map)->update($waredata);
            if($res){
                $result=['status'=>1,'msg'=>'仓库修改成功'];
            }else $result=['status'=>0,'msg'=>'仓库修改失败'];
        }else{
            //验证上级仓库是否已经设置
            $parent_code='0'; //默认顶级仓库
            if(!empty($data['parent_code'])){
                $hasParentWare=Db::name('warehouse')->field('ware_code,canvirtual')->where(['ware_code'=>$data['parent_code']])->find();
                if($hasParentWare==null || $hasParentWare['canvirtual']!=1){
                    $result['msg']="不能给实物仓库增加下级仓库";goto _end;
                }
                $parent_code=$hasParentWare['ware_code'];
            }
            Db::startTrans();
            $waredata['ware_code']=CommonFun::createCode('CK');
            $waredata['parent_code']=$parent_code;
            $waredata['status']=1;
            $waredata['add_date']=$waredata['update_date'];
            $waredata['creator']=$waredata['updater'];
            $res=Db::name('warehouse')->insert($waredata);
            //创建默认库位
            if(isset($waredata['canvirtual']) && $waredata['canvirtual']==0){
                $posdata['ware_code']=$waredata['ware_code'];
                $posdata['isstock']=1;
                $res1=WarePosition::saveWarePos($posdata,$user);
            }else $res1['status']=1;
            if($res && $res1['status']){
                Db::commit();
                $result=['status'=>1,'msg'=>'仓库新增成功'];
            }else{
                Db::rollback();
                $result=['status'=>0,'msg'=>'仓库新增失败'];
            }
        }
        _end:
        return $result;
    }
    /**
     * 启用、禁用仓库信息
     * @param $data
     * @param $user
     */
    public static function setWareStatus($data,$user){

    }
}
