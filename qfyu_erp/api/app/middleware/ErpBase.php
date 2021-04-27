<?php
declare (strict_types = 1);

namespace app\middleware;

use app\helper\Enc;
use app\erp\model\PowerList;
use think\facade\Config;
use think\facade\Db;

class ErpBase
{
    /**
     * 处理请求
     * @param \think\Request $request
     * @param \Closure       $next
     * @return Response
     */
    public function handle($request, \Closure $next)
    {
        if($request->controller() === 'Upload') $data = $request->post();
        else $data = json_decode($request->getInput(),true);
        $request->code = '';
        $request->depart = null;
        if($request->action() != 'login'){
            if(!$data['token']) exit(json_encode(['status'=>401,'msg'=>'登录信息有误']));
            $token = strip_tags($data['token']);
            $acc = Enc::encrypt($data['acc'],'D');
            $loginMsg = self::checkLogin($token,$acc,$request->pathinfo());
            $request->code = $loginMsg['code'];
            $request->depart = $loginMsg['depart'];
            $request->power_id_arr = $loginMsg['power_id_arr'];
            $request->pricePower = $loginMsg['pricePowerList'];
            $request->postAuth = $loginMsg['postAuth'];
        }else if($request->action() == 'login'){
            Config::set(['default' => strip_tags($data['login_acc'])], 'database');
        }
        $request->data = $data;
        return $next($request);
    }
    public static function checkLogin($token,$acc,$pathinfo){
        Config::set(['default' => $acc], 'database');
        $where[] = ['token','=',$token];
        $where[] = ['out_time','>',time()];
        $checkLoginToken = Db::name('login_token')->where($where)->value('uid');
        if($checkLoginToken) $uid = $checkLoginToken;
        else exit(json_encode(['status'=>401,'msg'=>'登录信息有误']));
        unset($where);
        $where[] = ['o.id','=',$uid];
        $where[] = ['e.status','=',1];
        $checkUser = Db::name('operators')->alias('o')
            ->join('employee e','e.id = o.emp_id','inner')
            ->where($where)->field('o.role_ids,o.power_ids,o.id,o.emp_id,e.code,e.depart_id,o.post_auth')->find();
        if(!$checkUser){
            exit(json_encode(['status'=>401,'msg'=>'登录信息有误']));
        }
        $powerIds = [];
        if($checkUser['power_ids']) $powerIds[] = unserialize($checkUser['power_ids']);
        $pricePowerList = '';
        if($powerIds){
            $pricePowerList = implode(',',$powerIds[0][0][0]);
            unset($powerIds[0][0][0]);
        }
        unset($where);
        $rolePower = [];
        if($checkUser['role_ids']){
            $where[] = ['id','in',$checkUser['role_ids']];
            $rolePower = Db::name('role')->where($where)->column('power_ids');
            if($rolePower){
                foreach ($rolePower as $k=>$v){
                    $rolePower[$k] = unserialize($v);
                }
            }
        }
        $powerIds = array_merge($powerIds,$rolePower);
        $power_id_arr = [];
        if(!empty($powerIds)){
            foreach ($powerIds as $key=>$val) {
                if(empty($val)) continue;
                foreach ($val as $kk=>$vv){
                    if(empty($vv)) continue;
                    array_push($power_id_arr,$kk);
                    foreach($vv as $kkk=>$vvv){
                        if($vvv){
                            array_push($power_id_arr,$kkk);
                            $power_id_arr = array_merge($power_id_arr,array_values($vvv));
                        }
                    }
                }
            }
        }
        $power_id_arr = array_unique($power_id_arr);
        unset($where);
        $where1 = [['id','in',$power_id_arr],['status','=',1]];
        $where2 = [['is_control','=',0],['status','=',1]];
        $actionArr = PowerList::whereOr([$where1,$where2])->column('action');
        if($pathinfo != 'getMenu' && $pathinfo != 'welInit' && !in_array($pathinfo, $actionArr)){
            exit(json_encode(['status'=>402,'msg'=>'没有操作权限']));
        }
        $power_id_arr = implode(',',$power_id_arr);
        $post_auth = $checkUser['post_auth']?unserialize($checkUser['post_auth']):[];
        return ['code'=>$checkUser['code'],'depart'=>$checkUser['depart_id'],'power_id_arr'=>$power_id_arr,'pricePowerList'=>$pricePowerList,'postAuth'=>$post_auth];
    }
}
