<?php
namespace app\erp\controller;

use app\BaseController;
use app\erp\model\Employee;
use app\erp\model\Settlement;
use app\helper\CommonFun;
use app\helper\Enc;
use app\erp\model\CustomerSupplier;
use app\erp\model\Menu;
use app\erp\model\Operators;
use app\erp\model\ProvidersSales;
use app\ware\model\UnqualifiedM;
use think\facade\Db;

class Index extends BaseController
{
    public function index()
    {
        echo '庆丰裕ERP欢迎您！';
    }
    public function welInit(){
        $data = $this->request->data;
        $accName = config('parameter.database_list');
        $accName = $accName[Enc::encrypt($data['acc'],'D')];;
        $code = $this->request->code;
        $userInfo = Db::name('employee')->where('code','=',$code)->value('concat(code,name)');
        return ['status'=>1,'user_info'=>$userInfo,'acc_name'=>$accName];
    }
    public function loginInit(){
        $databaseList = config('parameter.database_list');
        return ['status'=>1,'data'=>$databaseList];
    }
    public function getMenu(){
        $menuData = Menu::getMenus($this->request->power_id_arr);
        return ['status'=>1,'menu'=>$menuData];
    }
    public function initApp(){
        $employeeData = Employee::column('name','code');
        $parameter = config('parameter');
        $sysConfig = Db::name('sys_config')->column('f_value','f_key');
        $depart = Db::name('depart')->column('dept_name','id');
        $settlement = Settlement::column('name','code');
        $inoutKind = Db::name('inout_kind')->column('kind_name','kind_id');
        return ['status'=>1,'emp'=>$employeeData,'sysParam'=>$parameter,'sysConfig'=>$sysConfig,'depart'=>$depart,'settlement'=>$settlement,'inoutKind'=>$inoutKind];
    }
    public function login(){
        return Operators::login($this->request->data);
    }
    /**
     * 验证用户身份
     */
    public function verifyPlan(){
        $data = $this->request->data;
        $data = CommonFun::ProcessingData($data,['id']);
        $processingMethod = $data['processing_method'];
        if($processingMethod == 'examContact'){
            $result = Operators::checkUserIdentity($data,$data['post_code']);
            if(!$result['status']) goto _end;
            $result = ProvidersSales::examContact($data,$result['data']);
        }elseif ($processingMethod == 'checkContact'){ //审核客户联系人
            $result = Operators::checkUserIdentity($data,$data['post_code']);
            if(!$result['status']) goto _end;
            $result = CustomerSupplier::checkContact($data,$result['data']);
        }elseif ($processingMethod == 'checkUser'){//审核客户资质
            $result = Operators::checkUserIdentity($data,$data['post_code']);
            if(!$result['status']) goto _end;
            $result = CustomerSupplier::checkUser($data,$result['data']);
        }elseif ($processingMethod == 'checkRejectReport'){//不合格药品报告审核
            $result = Operators::checkUserIdentity($data,$data['post_code']);
            if(isset($result['data'])) $result['data']['date'] = date('Y-m-d');
        }else $result = Operators::checkUserIdentity($data);
        _end:
        return $result;
    }
}
