<?php
namespace app\helper;
use think\Exception;
use think\facade\Db;

Class CommonFun{
    /**
     * 生成唯一订单号
     * @param $type 单据编号类型
     * @return string|null
     */
    public static function createOrder($prefix){
        $tableName = config('rearParam.order_id_type');
        if(!isset($tableName[$prefix])) return null;
        _start:
        $ordernum = $prefix.date('ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 10);
        $data['orderid'] = $ordernum;
        $data['prefix'] = $prefix;
        $data['created_at'] = date('ymd');
        try {
            Db::name('make_orderid')->where('created_at','<',date('ymd'))->delete();
            $re = Db::name('make_orderid')->insert($data);
            if(!$re) goto _start;
        }catch (Exception $e){
            goto _start;
        }
        return $ordernum;
    }
    /**
     * 生成编号
     * @param $type 编号类型
     * @return string|null
     */
    public static function createCode($type,$orderField='id'){
        $tableName = config('rearParam.order_id_type');
        if(!isset($tableName[$type])) return null;
        $lastCode = Db::name($tableName[$type]['table_name'])->order($orderField,'desc')->value($tableName[$type]['code']);
        if($lastCode){
            $lastCode = substr($lastCode,2);
            $lastCode += 1;
            if($lastCode < 100) $Code = $type.'00'.$lastCode;
            else $Code = $type.$lastCode;
        }else $Code = $type.'001';
        return $Code;
    }

    /***
     * 处理请求数据
     * @param $InData 待处理数据
     * @param array $intData 需转整型的字段
     * @return array
     */
    public static function ProcessingData($InData,$intData=[],$floatData=[]){
        $OutData = [];
        foreach ($InData as $k=>$v){
            if(strpos($k,'_date') !== false){
                if($v == '' || !$v) $v = null;
                else $v = date('Y-m-d H:i:s',strtotime($v));
            }else if(!is_array($v)){
                if(gettype($v)=='string') $v = $v?trim(strip_tags($v)):null;
                if(in_array($k,$intData)) $v = ($v!==''&&$v!==null)?(int)$v:null;
                else if(in_array($k,$floatData)) $v = ($v!==''&&$v!==null)?(float)$v:null;
            }
            $OutData[$k] = $v;
        }
        return $OutData;
    }

    /**
     * 移动文件 并重命名
     * @param $filePath
     * @param $newFilePath
     * @return int[]
     */
    public static function moveFile($filePath,$newFilePath,$fileName=null){
        $res = ['status'=>0];
        if(!strpos($filePath, "/temp/")){
            $res = ['status'=>1,'pic_url'=>$filePath];
            goto _end;
        }
        $lastLocation = strrpos($filePath, "?");
        if($lastLocation) $filePath = substr($filePath,0,$lastLocation);
        $suffix = strstr($filePath,'.');
        if($fileName) $newFileName = $newFilePath.$fileName.$suffix;
        else $newFileName = $newFilePath.substr($filePath, strrpos($filePath,'/')+1);
        $filePath = APP_PATH.'../public'.$filePath;
        $newPath = APP_PATH.'../public'.$newFileName;
        if(!file_exists($filePath)){
            $res['msg'] = '文件信息有误，请重新上传提交！';
            goto _end;
        }
        if(!is_dir('.'.$newFilePath)) mkdir('.'.$newFilePath,777,true);
        $re = @rename($filePath,$newPath);
        if(!$re){
            $res['msg'] = '文件保存失败，请重新再试！';
            goto _end;
        }
        $res = ['status'=>1,'pic_url'=>$newFileName];
        _end:
        return $res;
    }
}
