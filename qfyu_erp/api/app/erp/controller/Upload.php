<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\GoodsPhoto;
use app\helper\CommonFun;
use app\erp\model\EnterprisePhoto;
use think\App;
use think\facade\Db;
use think\Image;

Class Upload extends BaseController{
    public function __construct(App $app)
    {
        parent::__construct($app);
        set_time_limit(0);
        ini_set('memory_limit','2048M');
    }

    public function EnterPriseUpload(){
        $data = CommonFun::ProcessingData($this->request->data);
        $result = ['status'=>0,'img'=>'','msg'=>'error'];
        $maxSize = 3*1024*1024; //限制图片最大3M
        $img_type = array('jpg','jpeg','png','GIF','JPG','JPEG','PNG');
        $path = './uploads/first_enterprise/';
        $isAdd = 0;
        if(isset($data['is_add'])) $isAdd = $data['is_add']?0:1;
        if(!$isAdd) $path .= 'temp/'.date('Y-m-d').'/';
        if(!$data['name']){
            $result['msg'] = '请选择需要上传的图片！';goto _end;
        }
        if(!$data['validity_date']){
            $result['msg'] = '请选择过期时间！';goto _end;
        }
        if(!is_dir($path)) mkdir($path,777);
        if(!empty($_FILES)){
            $name = $_FILES['file']['name'];
            $size = $_FILES['file']['size'];
            $name_tmp = $_FILES['file']['tmp_name'];
            $typearr = explode('.',$name);
            $type = end($typearr);
            if (empty($name)) {
                $result['msg'] = '您未选择图片！';goto _end;
            }
            if(!in_array($type,$img_type)){
                $result['msg'] = '上传的图片类型不正确！';goto _end;
            }
            if($size>$maxSize){
                $result['msg'] = '上传的图片不能大于3M';goto _end;
            }
            if($isAdd) $pic_name = $data['code'].'_'.$data['name'].".".$type;
            else $pic_name = md5_file($name_tmp).".".$type;
            $pic_url = $path . $pic_name;
            if (move_uploaded_file($name_tmp, $pic_url)){
                $result=array('status'=>1,'img'=>substr($pic_url,1).'?ver'.time(),'msg'=>'Success');
                if($isAdd) EnterprisePhoto::addImg($data,$this->request->code,substr($pic_url,1));
            }else{
                if(is_dir($path)) $result=array('status'=>0,"msg" => "目录没权限！");
                else $result=array('status'=>0,"msg" => "上传有误，请检查服务器配置！");
            }
        }
        _end:
        exit(json_encode($result));

    }
    /**
     * 首营品种证照
     */
    public function firstGoodsUpload(){
        $data = CommonFun::ProcessingData($this->request->data);
        $result = ['status'=>0,'img'=>'','msg'=>'error'];
        $maxSize = 3*1024*1024; //限制图片最大3M
        $img_type = array('jpg','jpeg','png','GIF','JPG','JPEG','PNG');
        $path = './uploads/first_goods/';
        $isAdd = 0;
        if(isset($data['is_add'])) $isAdd = $data['is_add']?0:1;
        if(!$isAdd) $path .= 'temp/'.date('Y-m-d').'/';
        if (empty($data['name'])){
            $result['msg'] = '请选择需要上传的图片！';goto _end;
        }
        if(!is_dir($path)) mkdir($path,777,true);
        if(!empty($_FILES)){
            $name = $_FILES['file']['name'];
            $size = $_FILES['file']['size'];
            $name_tmp = $_FILES['file']['tmp_name'];
            $typearr = explode('.',$name);
            $type = end($typearr);
            if (empty($name)) {
                $result['msg'] = '您未选择图片！';goto _end;
            }
            if(!in_array($type,$img_type)){
                $result['msg'] = '上传的图片类型不正确！';goto _end;
            }
            if($size>$maxSize){
                $result['msg'] = '上传的图片不能大于3M';goto _end;
            }
            if($isAdd) $pic_name = $data['code'].'_'.$data['name'].".".$type;
            else $pic_name = md5_file($name_tmp).".".$type;
            $pic_url =$path . $pic_name;
            if (move_uploaded_file($name_tmp, $pic_url)){
                $result = ['status'=>1,'img'=>substr($pic_url,1).'?var='.time(),'msg'=>'Success'];
                if($isAdd) GoodsPhoto::addImg($data,$this->request->code,substr($pic_url,1));
            }else{
                if(is_dir($path)) $result=array('status'=>0,"msg" => "目录没权限！");
                else $result=array('status'=>0,"msg" => "上传有误，请检查服务器配置！");
            }
        }
        _end:
        exit(json_encode($result));
    }

    /**
     * 客户证照
     */
    public function custImgUpload(){
        $data = CommonFun::ProcessingData($this->request->data);
        $result = ['status'=>0,'img'=>'','msg'=>'error'];
        $maxSize = 3*1024*1024; //限制图片最大3M
        $img_type = array('jpg','jpeg','png','GIF','JPG','JPEG','PNG');
        $path = './uploads/customer_img/temp/'.date('Y-m-d').'/';
        if(!$data['name']){
            $result['msg'] = '请选择需要上传的图片！';goto _end;
        }
        if(!$data['use_date']){
            $result['msg'] = '请选择过期时间！';goto _end;
        }
        if(!is_dir($path)) mkdir($path,777);
        if(!empty($_FILES)){
            $name = $_FILES['file']['name'];
            $size = $_FILES['file']['size'];
            $name_tmp = $_FILES['file']['tmp_name'];
            $typearr = explode('.',$name);
            $type = end($typearr);
            if (empty($name)) {
                $result['msg'] = '您未选择图片！';
                goto _end;
            }
            if(!in_array($type,$img_type)){
                $result['msg'] = '上传的图片类型不正确！';
                goto _end;
            }
            if($size>$maxSize){
                $result['msg'] = '上传的图片不能大于3M';
                goto _end;
            }
            $pic_url = $path . md5_file($name_tmp).".".$type;;
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

    /**
     * 商品药检报告
    **/
    public function drugUoload()
    {
      $data = CommonFun::ProcessingData($this->request->data);
      $result = ['status'=>0,'img'=>'','msg'=>'error'];
      $maxSize = 10*1024*1024; //限制图片最大10M
      $img_type = array('jpg','jpeg','png','GIF','JPG','JPEG','PNG');
      $path = './uploads/drug_img/';
      $isAdd = 0;
      if(isset($data['is_add'])) $isAdd = $data['is_add']?0:1;
      if(!$isAdd) $path .= 'temp/'.date('Y-m-d').'/';
      if (empty($data['name'])){
        $result['msg'] = '请选择供应商！';goto _end;
      }
      if(!is_dir($path)) mkdir($path,777,true);
      if(!empty($_FILES)){
        $name = $_FILES['file']['name'];
        $size = $_FILES['file']['size'];
        $name_tmp = $_FILES['file']['tmp_name'];
        $typearr = explode('.',$name);
        $type = end($typearr);
        if (empty($name)) {
          $result['msg'] = '您未选择图片！';goto _end;
        }
        if(!in_array($type,$img_type)){
          $result['msg'] = '上传的图片类型不正确！';goto _end;
        }
        if($size>$maxSize){
          $result['msg'] = '上传的图片不能大于10M';goto _end;
        }
        if($isAdd) $pic_name = $data['code'].'_'.$data['name'].'_'.$data['ABType'].".".$type;
        else $pic_name = md5_file($name_tmp).".".$type;
        $pic_url =$path . $pic_name;
        if (move_uploaded_file($name_tmp, $pic_url)){
          $result = ['status'=>1,'img'=>substr($pic_url,1).'?var='.time(),'msg'=>'Success'];
        }else{
          if(is_dir($path)) $result=array('status'=>0,"msg" => "目录没权限！");
          else $result=array('status'=>0,"msg" => "上传有误，请检查服务器配置！");
        }
      }
      _end:
      exit(json_encode($result));
    }
}
