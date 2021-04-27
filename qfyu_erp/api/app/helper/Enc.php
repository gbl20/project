<?php
namespace app\helper;

Class Enc{
    public static $key  =  "QFyuERP202009";
    public static $keyLogin  =  "QFyuERP2020Token";
    /**
     * @param $string '需要加解密的字符串'
     * @param $operation 'D' 解密 'E' 加密
     * @return false|string|string[]
     */
    public static function encrypt($string,$operation='E',$type = 'passwd',$time = ''){
        if($type === 'passwd') $key = md5(self::$key);
        else if($type === 'token') $key = md5(self::$keyLogin.$time);
        else return false;
        $key_length = strlen($key);
        $string = $operation == 'D'?base64_decode($string):substr(md5($string.$key),0,8).$string;
        $string_length = strlen($string);
        $rndKey = $box = array();
        $result = '';
        for($i = 0;$i<= 255;$i++){
            $rndKey[$i] = ord($key[$i%$key_length]);
            $box[$i] = $i;
        }
        for($j = $i = 0;$i<256;$i++){
            $j = ($j+$box[$i]+$rndKey[$i])%256;
            $tmp = $box[$i];
            $box[$i] = $box[$j];
            $box[$j] = $tmp;
        }
        for($a = $j = $i = 0;$i<$string_length;$i++){
            $a = ($a+1)%256;
            $j = ($j+$box[$a])%256;
            $tmp = $box[$a];
            $box[$a] = $box[$j];
            $box[$j] = $tmp;
            $result.= chr(ord($string[$i])^($box[($box[$a]+$box[$j])%256]));
        }
        if($operation == 'D'){
            if(substr($result,0,8) == substr(md5(substr($result,8).$key),0,8)){
                return substr($result,8);
            }else{
                return'';
            }
        }else{
            return str_replace(' = ','',base64_encode($result));
        }
    }
}