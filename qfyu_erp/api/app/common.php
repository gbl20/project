<?php
/**
 * @param $arr 计算式 exam: [$a,'*',$b,'+',$c,'/',$d,'-',$e]
 * @param int $fixed 保留位数
 * @param bool $isRound 默认 true 表示四舍五入  false 直接舍掉
 * @return false|float|int|string
 */
function calc($arr,$fixed=0,$isRound=true){
    $opArr = even($arr);
    $resNum = 0;
    foreach($opArr as $k=>$v){
        if(isset($arr[$v['key']-1])){
            $LOP = $arr[$v['key']-1];
            unset($arr[$v['key']-1]);
        }else $LOP = $resNum;
        if(isset($arr[$v['key']+1])) {
            $ROP = $arr[$v['key']+1];
            unset($arr[$v['key']+1]);
        }else $ROP = $resNum;
        $resNum = bcFun($LOP,$ROP,$v['op'],10);
    }
    if($resNum) $resNum = $isRound?round($resNum,$fixed):floatval($resNum);
    return $resNum;
}
function even($param){
    $opArr = [];
    $opArrC = ['+','-','*','/'];
    foreach($param as $k=>$v){
        if($k%2){
            $opArr[$k] = [];
            $opArr[$k]['key'] = $k;
            $opArr[$k]['op'] = $v;
            $opArr[$k]['index'] = array_search($v, $opArrC);
        }
    }
    $last_names = array_column($opArr,'index');
    array_multisort($last_names,SORT_DESC,$opArr);
    return $opArr;
}
function bcFun($LOP,$POP,$OP,$toFixed){
    switch ($OP){
        case '+':
            $res = bcadd($LOP,$POP,$toFixed);
            break;
        case '-':
            $res = bcsub($LOP,$POP,$toFixed);
            break;
        case '*':
            $res = bcmul($LOP,$POP,$toFixed);
            break;
        case '/':
            $res = bcdiv($LOP,$POP,$toFixed);
            break;
        default:
            $res = false;
    }
    return $res;
}
/**
 * 查询配置信息
 * @param $f_key 配置项名
 */
function getSysConfig($f_key){
    $value=\think\facade\Db::name('sys_config')->where(['f_key'=>$f_key])->value('f_value');
    return $value;
}
