<?php
namespace app\erp\model;
use app\erp\validate\Category;
use app\erp\validate\CustomKindsVal;
use app\erp\validate\PermitKindVal;
use think\facade\Db;
use think\Model;
use function Symfony\Component\VarDumper\Dumper\esc;

class PermitKinds extends Model{
    public static function getKinds()
    {
        $filed = 'id,title,parent_id,level,status,sort,remark';
        $data = Db::name('commodity_function')->field($filed)->select()->toArray();
        $res = self::get_kinds_list($data,0);
        return $res;
    }
    public static function getKindsLCascaber()
    {
        $field   = 'id value,title label,parent_id';
        $res = Db::name('commodity_function')
                  ->field($field)
                  ->where('status','=',1)
                  ->select()
                  ->toArray();
        $data = self::get_cascaber_list($res,0);
        return $data;
    }
    /*** 联动选择 **/
    public static function get_cascaber_list(&$datas,$parent_id=0)
    {
        $result=array();
        foreach ($datas as $k=>$data){
            if ($data['parent_id']==$parent_id){
                unset($datas[$k]);
                $data['children'] = self::get_cascaber_list($datas,$data['value']);
                $result[]=$data;
            }
        }
        return $result;
    }
    /*** 菜单递归 **/
    public static function get_kinds_list(&$datas,$parent_id=0,$option_left = '')
    {
        $result=array();
        foreach ($datas as $k=>$data){
            if ($data['parent_id']==$parent_id){
                unset($datas[$k]);
                $data['option_left'] = $option_left.'-';
                if ($parent_id){$data['option_left'] = $option_left.'-';}
                $data['children'] = self::get_kinds_list($datas,$data['id'],$data['option_left']);
                $result[]=$data;
            }
        }
        return $result;
    }
    /** 弹出层分类列表 **/
    public static function build_option(&$datas)
    {
        static $res = array();
        static $i = 0;
        foreach ($datas as $k => $data){
            unset($datas[$k]);
            $res[$i++] = ['id'=>$data['id'],'title'=>$data['option_left'].$data['title'],'parent_id'=>$data['parent_id'],'level'=>$data['level'],'status'=>$data['status'],'remark'=>$data['remark']];
            if (isset($data['children'][0])) self::build_option($data['children']);
        }
        return $res;
    }
    /**
     * 新增商品分类
     * @param $data array 前端传来需要新增的商品分类数据
    **/
    public static function set_kinds($id,$data)
    {
        $result = ['status'=>0,'msg'=>'init'];
        $validate = new Category();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg']=$validate->getError();
            goto _end;
        }
        $is_title = Db::name('commodity_function')->where('title',$data['title'])->find();
        if($is_title){$result['msg']='该分类已经存在,请勿重复添加';goto _end;}
        $sql['title'] = substr(strip_tags($data['title']),0,30);
        $sql['status'] = $data['status'];
        $sql['remark'] = substr(strip_tags($data['remark']),0,50);
        if($id==0){
            $res = Db::name('commodity_function')->where('id',$data['id'])->field('parent_id,level')->find();
            if(!$res){
                $sql['parent_id'] = 0;
                $sql['level'] = 1;
            }else{
                $sql['parent_id'] = $data['id'];
                $sql['level'] = $res['level']+1;
            }
            $return = Db::name('commodity_function')->insert($sql);
            if($return){
                $result = ['status'=>1,'msg'=>'添加成功'];
            }else{
                $result['msg'] = '添加失败';
            }
        }else{
            $res = Db::name('commodity_function')->where('id',$id)->update($sql);
            if ($res) $result = ['status'=>1,'msg'=>'修改成功'];
            else $result['msg'] = '修改失败';
        }
        _end:
        return $result;
    }
    /**
     * 删除商品分类
     * @param $data array  $data['id'] string 商品分类id
    **/
    public static function del_kinds($data)
    {
        $result = ['status'=>0,'msg'=>'init'];
        $where[] = ['parent_id','=',$data['id']];
        $has_child = Db::name('commodity_function')->where($where)->field('id')->find();
        if($has_child){
            $result['msg']='该栏目下有子栏目，请先删除栏目下的子栏目！';
            goto _end;
        }
        $pd1 = Db::name('commodity')->where('kindid',$data['id'])->field('id')->find();
        $pd2 = Db::name('commodity')->where('top_kindid',$data['id'])->field('id')->find();
        $pd3 = Db::name('commodity')->where('parent_kindid',$data['id'])->field('id')->find();
        if ($pd1 || $pd2 || $pd3){
            $result['msg']='该栏目下有产品，请先移除栏目下的产品！';
            goto _end;
        }
        $res = Db::name('commodity_function')->where('id',$data['id'])->delete();
        if ($res) $result= ['status'=>1,'msg'=>'删除成功！'];
        else $result['msg'] = '删除失败！';
        _end:
        return $result;
    }
    /**
     *  获取商品许可经营大类类别
     *  return array
     **/
    public static function get_permit_list($id=null)
    {
        $where[] = ['status','=',1];
        $where[] = ['parent_id','=',0];
        $item = [];
        $parent_id = null;
        $data = PermitKinds::where($where)->field('id,name,parent_id,remark')->select()->toArray();
        if (!empty($data)) $parent_id = $id?$id:$data[0]['id'];
        foreach($data as $k=>$v){
            $item[$v['id']] = $v;
        }
        $result = ['status'=>1,'data'=>$item,'parent_id'=>$parent_id];
        return $result;
    }
    /** 获取商品许可经营小类类别 **/
    public static function getPermitDelKinds($id)
    {
        $item = Db::name('permit_kinds')->alias('k')
            ->field('k.id,k.name,k.parent_id,k.remark,p.name as parent_name')
            ->join('permit_kinds p','k.parent_id=p.id')
            ->where([['k.parent_id','=',$id],['k.status','=',1]])
            ->select()
            ->toArray();
        return $item;
    }
    /**
     *  新增-修改商品许可经营大类
    **/
    public static function set_permit_kind($data,$user)
    {
        $result = ['status'=>0,'msg'=>'添加失败'];
        $validate = new PermitKindVal();
        $check = $validate->scene('all')->check($data);
        if(!$check){
            $result['msg'] = $validate->getError();
            goto _end;
        }
        $data['name'] = substr($data['name'],0,50);
        $data['remark'] = substr($data['remark'],0,100);
        $where[] = ['name','=',$data['name']];
        $has_name = Db::name('permit_kinds')->where($where)->field('id,status')->find();
        if($has_name){
            $data['status'] = 1;
            $data['updated_code'] = $user;
            $data['updated_date'] = date("Y-m-d H:i:s");
            $res = Db::name('permit_kinds')->where('name',$data['name'])->update($data);
            if ($res) $result = ['status'=>1,'msg'=>'修改成功！'];
            else $result['msg']='修改失败！';
        }else{
            $data['creater_code'] = $user;
            $data['creater_date'] = date("Y-m-d H:i:s");
            $data['parent_id'] = 0;
            $res = Db::name('permit_kinds')->insert($data);
            if($res) $result = ['status'=>1,'msg'=>'添加成功!'];
        }
        _end:
        return $result;
    }
    /**
     *  删除商品许可经营类别
     *  $id int 商品许可经营类别表主键id
    **/
    public static function del_permit_kinds($id)
    {
        $result = ['status'=>0,'msg'=>'删除失败'];
        $where[] = ['parent_id','=',$id];
        $where[] = ['status','=',1];
        $has_child = Db::name('permit_kinds')->where($where)->field('id')->find();
        if($has_child){
            $result['msg'] = '该分类下有子分类,请先移除该类别下的子分类';goto _end;
        }
        $res = Db::name('permit_kinds')->where('id',$id)->update(['status'=>0]);
        if($res) {
            $result = ['status'=>1,'msg'=>'删除成功!'];
        }
        _end:
        return $result;
    }
    /**
     *  修改商品许可经营类别小类
    **/
    public static function edit_small_permit_kind($data,$user)
    {
        $result = ['status'=>0,'msg'=>'修改失败!'];
        $validate = new PermitKindVal();
        $check = $validate->scene('all')->check($data);
        if (!$check){
            $result['msg'] = $validate->getError();goto _end;
        }
        if($data['id']){
            $map[] = ['id','=',$data['id']];
            unset($data['id']);
            unset($data['parent_id']);
            $data['status'] =1;
            $data['updated_code'] = $user;
            $data['updated_date'] = date("Y-m-d H:i:s");
            $res = PermitKinds::where($map)->update($data);
            if($res) $result = ['status'=>1,'msg'=>'修改成功！'];
        }else{
            unset($data['id']);
            $data['creater_code'] = $user;
            $data['creater_date'] = date("Y-m-d H:i:s");
            $res = PermitKinds::insert($data);
            if ($res) $result = ['status'=>1,'msg'=>'新增成功！'];
            else $result['msg'] = '新增失败！';
        }
        _end:
        return $result;
    }
    /**
     *  删除商品许可经营小类
     *  $id int 商品许可经营类别小类id
    **/
    public static function del_small_permit_kind($id,$user)
    {
        $result = ['status'=>0,'msg'=>'删除失败!'];
        $has_kind = Db::name('commodity')->where('kinds_id',$id)->field('kinds_id')->find();
        if ($has_kind){
            $result['msg'] = '删除失败！该类别已经被使用。';goto _end;
        }
        $res = Db::name('permit_kinds')->where('id',$id)->update(['status'=>0]);
        if($res) $result = ['status'=>1,'msg'=>'删除成功!'];
        _end:
        return $result;
    }
    /**
     *  获取自定义商品许可经营类别
    **/
    public static function get_custom_kinds()
    {
        $index = null;
        $data  = array();
        $field = 'k.top_kid,k.chlid_kid,p.name as chlid_name,pe.name as parent_name';
        $item = Db::name('custom_kinds_name')->field('id,name')->select()->toArray();
        if (!empty($item)){
            $index = $item[0]['id'];
            foreach($item as $k=>$v){
                $data[$v['id']] = Db::name('custom_kinds')->field($field)->alias('k')
                        ->join('permit_kinds p','p.id=k.chlid_kid','left')
                        ->join('permit_kinds pe','pe.id=k.top_kid','left')
                        ->where('k.kid',$v['id'])
                        ->select()
                        ->toArray();
            }
        }
        return ['status'=>1,'index'=>$index,'item'=>$item,'data'=>$data];
    }
    /** 获取新增自定义许可类别列表-多选**/
    public static function get_custom_permit_list()
    {
        $data = array();
        $item = Db::name('permit_kinds')->field('id,name,parent_id')->where('status',1)->select()->toArray();
        $res = self::get_custom_list($item,0);
        foreach ($res as $k=>$v){
            $data[$v['id']] = $v;
        }
        return ['status'=>1,'data'=>$res,'item'=>$data];
    }
    /**
     *  商品许可经营类别栏目递归
    **/
    public static function get_custom_list(&$data,$parent_id=0)
    {
        $result = array();
        foreach ($data as $k=>$v){
            $v['checkall']=false;
            $v['checkAllGroup']=[];
            $v['indeterminate']=false;
            if ($v['parent_id']==$parent_id){
                unset($data[$k]);
                $v['children'] = self::get_custom_list($data,$v['id']);
                $result[] = $v;
            }
        }
        return $result;
    }
    /**
     *  新增自定义商品许可经营类别
    **/
    public static function add_custom_kinds($data,$user)
    {
        $result = ['status'=>0,'msg'=>'新增失败！'];
        $sql = array();
        $validate = new CustomKindsVal();
        $checker = $validate->scene('all')->check($data);
        if(!$checker){
            $result['msg'] = $validate->getError();
            goto _end;
        }
        $has_name = Db::name('custom_kinds_name')->where('name',$data['name'])->find();
        $permit = Db::name('permit_kinds')->column('parent_id','id');
        $kinds = array_merge($data['parent_kid'],$data['chlid_kid']);
        $sql1['name'] = $data['name'];
        if (!$has_name){
            $sql1['creater'] = $user;
            $sql1['creater_date'] = date("Y-m-d H:i:s");
            Db::startTrans();
            $kinds_id = Db::name('custom_kinds_name')->insertGetId($sql1);
            foreach ($kinds as $k=>$v){
                $sql[$k]['kid'] = $kinds_id;
                $sql[$k]['top_kid'] = $permit[$v]?$permit[$v]:$v;
                $sql[$k]['chlid_kid'] = $v;
                $sql[$k]['creater'] = $user;
                $sql[$k]['create_date'] = date("Y-m-d H:i:s");
            }
            $res1 = Db::name('custom_kinds')->insertAll($sql);
            if ($kinds_id && $res1){
                Db::commit();
                $result = ['status'=>1,'msg'=>'新增成功！'];
            }else{
                Db::rollback();
            }
        }else{
            halt('修改数据！');
            foreach ($kinds as $k=>$v){
                $sql[$k]['name'] = $data['name'];
                $sql[$k]['parent_kid'] = $permit[$v];
                $sql[$k]['chlid_kid'] = $v;
                $sql[$k]['creater'] = $user;
                $sql[$k]['create_date'] = date("Y-m-d H:i:s");
            }
            $res = Db::name('custom_kinds')->insertAll($sql);
            if ($res) $result = ['status'=>1,'msg'=>'新增成功！'];
        }
        _end:
        return $result;
    }
    /** 获取商品大类 select列表**/
    public static function getCommodityCategory()
    {
        $res = Db::name('commodity_category')->field('id value,title label')->select()->toArray();
        return $res;
    }
    public static function getCustomKinds()
    {
        $res = Db::name('custom_kinds_name')->field('id,name')->select()->toArray();
        return $res;
    }
    /** 删除自定义许可经营小类 **/
    public static function delCustomKinds($data)
    {
        halt($data);
    }
    /**
     * 选择许可经营类别(弹出层组件)
     */
    public static function getddk($map=[],$selddk=[]){
        $field='id,parent_id,name';
        $map1=$map;
        $map1[]=array('parent_id','=',0);
        $list=self::field($field)->where($map1)->select()->toArray();
        $map[]=array('parent_id','>',0);
        $list2=self::field($field)->where($map)->select()->toArray();
        $selddk=array_flip($selddk);
        foreach ($list as $k=>$v){
            $list[$k]['checked']=isset($selddk[$v['id']])?true:false;
            foreach ($list2 as $k2=>$v2){
                $v2['checked']=isset($selddk[$v2['id']])?true:false;
                if($v2['parent_id']==$v['id']) $list[$k]['child'][]=$v2;
            }
        }
        unset($list2);
        return $list;
    }
}
