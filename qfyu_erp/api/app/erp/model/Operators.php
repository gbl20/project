<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\Enc;
use app\erp\validate\OperatorsVal;
use think\facade\Db;
use think\Model;

Class Operators extends Model{
    /**
     * 验证用户身份
     * @param $data 表单数据
     */
    public static function checkUserIdentity($data,$postCode=null,$uCode=null){
        $result = ['status'=>0,'msg'=>'校验身份失败'];
        $postId = 0;
        if($postCode){
            $where[] = ['mode_code','=',$postCode];
            $where[] = ['status','=',1];
            $postId = Db::name('extend_define')->where($where)->value('id');
            if(!$postId) {
                $result = ['status'=>0,'msg'=>'提交参数有误'];
                goto _end;
            }
        }
        $user = Db::name('employee')->field('id,code,name')->where('code',$data['code'])->find();
        if(!$user){
            $result['msg'] = '验证用户身份失败！请重新输入';goto _end;
        }
        if ($uCode && $data['code']!== $uCode){
            $result['msg'] = '审批人与登录账户不一致，禁止审批！根据系统设置，审批首营资料必须是本人登录系统。';
            goto _end;
        }
        $hasUser = Db::name('operators')->where('emp_id',$user['id'])->field('passwd,post_auth')->find();
        if(!$hasUser){
            $result['msg'] = '用户编号不正确！请重新输入。';
            goto _end;
        }
        $pwd = Enc::encrypt($data['upass']);
        if($pwd !== $hasUser['passwd']){
            $result['msg'] = '用户登录密码不正确！请重新输入。';
            goto _end;
        }
        if($postId){
            if($hasUser['post_auth']){
                $post_auth = unserialize($hasUser['post_auth']);
                if(!in_array($postId,$post_auth)){
                    $result['msg'] = '用户没有该岗位权限！';
                    goto _end;
                }
            }else{
                $result['msg'] = '用户没有该岗位权限！';
                goto _end;
            }
        }
        $result=['status'=>1,'msg'=>'校验成功','data'=>$user];
        _end:
        return $result;
    }
    public static function login($data){
        $res = ['status'=>0,'msg'=>'登录失败'];
        $validate = new OperatorsVal();
        $val_res = $validate->scene('all')->check($data);
        if(!$val_res){
            $res['msg'] = $validate->getError();goto _end;
        }
        $passWd = Enc::encrypt($data['passwd']);
        $where[] = ['e.code','=',strip_tags($data['user'])];
        $where[] = ['e.status','=',1];
        $where[] = ['o.passwd','=',$passWd];
        $checkLogin = Db::name('operators')->alias('o')
            ->join('employee e','e.id = o.emp_id','inner')
            ->where($where)->field('o.role_ids,o.power_ids,o.id,o.emp_id')->find();
        if(!$checkLogin){
            $res['msg'] = '账号密码输入有误';goto _end;
        }
        $time = time();
        $token = md5(Enc::encrypt($checkLogin['id'],'E','token',$time));
        $rData['token'] = $token;
        $rData['uid'] = $checkLogin['id'];
        $rData['login_time'] = $time;
        $rData['out_time'] = $time + 2592000;
        $rLoginToken = Db::name('login_token')->insert($rData);
        if(!$rLoginToken) goto _end;
        $res = ['status'=>1,'msg'=>'登录成功','token'=>$token,'acc'=>Enc::encrypt($data['login_acc'],'E')];
        _end:
        return $res;
    }
    public static function queryList(){
        $field = 'o.id,e.name,e.code,e.depart_name as dept_name,o.role_ids,o.power_ids,o.emp_id,post_auth';
        $data = Db::name('operators')->alias('o')
            ->join('employee e','e.id = o.emp_id','left')
            ->field($field)->paginate(30)->each(function($item, $key){
                $role_list = [];
                if($item['role_ids']) $role_list = explode(',',$item['role_ids']);
                $item['role_list'] = $role_list;
                $item['post_auth'] = $item['post_auth']?unserialize($item['post_auth']):[];
                $item['power_ids'] = $item['power_ids']?unserialize($item['power_ids']):null;
                return $item;
            })->toArray();
        return $data;
    }
    public static function editOp($fData){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $time = time();
        $data['emp_id'] = intval($fData['emp_id']);
        $data['passwd'] = Enc::encrypt($fData['passwd']);

        $data['re_time'] = $time;
        if($fData['id']){
            $data['id'] = $fData['id'];
            $re = Operators::update($data);
        }else{
            $data['create_time'] = $time;
            $re = Operators::create($data);
        }
        if($re){
            $field = 'o.id,e.name,e.code,d.dept_name';
            $reData = Db::name('operators')->alias('o')
                ->join('employee e','e.id = o.emp_id','left')
                ->join('depart d','d.id = e.depart_id','left')
                ->where('o.emp_id',$data['emp_id'])->field($field)->find();
            $res = ['status'=>1,'msg'=>'提交成功','data'=>$reData];
        }
        return $res;
    }
    public static function setOpRole($data){
        $res = ['status'=>0,'msg'=>'操作失败'];
        $opId = intval($data['op_id']);
        $roleId = intval($data['role_id']);
        $type = intval($data['type']);
        $roleIds = Operators::where('id',$opId)->value('role_ids');
        $reRoleIds = $roleIds;
        if($roleIds){
            $roleIdArr = explode(',',$roleIds);
            if(!in_array($roleId,$roleIdArr) && $type){
                $roleIds .= ','.$roleId;
            }
            if(in_array($roleId,$roleIdArr) && !$type){
                $key = array_search($roleId ,$roleIdArr);
                array_splice($roleIdArr,$key,1);
                $roleIds = implode(',',$roleIdArr);
            }
        }else if($type) $roleIds = $roleId.'';
        if($reRoleIds == $roleIds) goto _end;
        $upData['role_ids'] = $roleIds;
        $upData['re_time'] = time();
        $re = Operators::where('id',$opId)->update($upData);
        if($re) $res = ['status'=>1,'msg'=>'操作成功','role_list'=>explode(',',$roleIds),'role_ids'=>$roleIds];
        _end:
        return $res;
    }
    public static function setOpPost($data){
        $opId = intval($data['op_id']);
        $post_auth = $data['post_auth'];
        $upData['post_auth'] = serialize($post_auth?$post_auth:[]);
        $upData['re_time'] = time();
        Operators::where('id',$opId)->update($upData);
        $post_auth = Operators::where('id',$opId)->value('post_auth');
        return $res = ['status'=>1,'msg'=>'操作成功','post_auth'=>unserialize($post_auth)];
    }
}
