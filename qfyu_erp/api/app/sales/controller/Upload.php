<?php
namespace app\sales\controller;
use app\BaseController;
use think\App;

Class Upload extends BaseController{
    public function __construct(App $app)
    {
        parent::__construct($app);
        set_time_limit(0);
        ini_set('memory_limit','2048M');
    }
    public function upSalesContract(){
        $result = ['status'=>0,'img'=>'','msg'=>'error'];
        $maxSize = 10*1024*1024; //限制文件最大10M
        $img_type = array('doc','docx','pdf','docm','dot','dotm','dotx');
        $path = './uploads/sales_contract/temp/'.date('Y-m-d').'/';
        if(!is_dir($path)) mkdir($path,777);
        if(!empty($_FILES)){
            $name = $_FILES['file']['name'];
            $size = $_FILES['file']['size'];
            $name_tmp = $_FILES['file']['tmp_name'];
            $typearr = explode('.',$name);
            $type = end($typearr);
            if (empty($name)) {
                $result['msg'] = '您未选择文件！';goto _end;
            }
            if(!in_array($type,$img_type)){
                $result['msg'] = '上传的文件类型不正确！';goto _end;
            }
            if($size>$maxSize){
                $result['msg'] = '上传的文件不能大于10M';goto _end;
            }
            $pic_name = substr($name,0,strpos($name,'.')).'_'.md5_file($name_tmp).".".$type;
            $pic_url = $path . $pic_name;
            if (move_uploaded_file($name_tmp, $pic_url)){
                $result=array('status'=>1,'img'=>substr($pic_url,1),'msg'=>'Success');
            }else{
                if(is_dir($path)) $result=array('status'=>0,"msg" => "目录没权限！");
                else $result=array('status'=>0,"msg" => "上传有误，请检查服务器配置！");
            }
        }
        _end:
        exit(json_encode($result));
    }
}
