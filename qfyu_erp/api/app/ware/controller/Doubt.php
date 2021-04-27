<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\DoubtM;
use think\facade\Config;

class Doubt extends BaseController
{
    /**
     * 库存列表
     */
    public function stock_list(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $map[]=array('sd.qty','>',0);
        $map[]=array('w.flag','>=',0);
        if(!empty($params['ware_code'])) $map[]=array('sd.ware_code','=',$params['ware_code']);
        if(!empty($params['pos_code'])) $map[]=array('sd.pos_code','=',$params['pos_code']);
        if(!empty($params['goods_code'])) $map[]=array('sd.goods_code','=',$params['goods_code']);
        if(!empty($params['batch_no'])) $map[]=array('sd.batch_no','=',$params['batch_no']);
        $result=DoubtM::stocklist($map,$page);
        $result['status']=1;
        $result['cfg']['goods_status']=Config::get('parameter.goods_status');
        $result['cfg']['quality_status']=Config::get('parameter.quality_status');
        $result['cfg']['def']=array('goods_status'=>$result['cfg']['goods_status'][0],'quality_status'=>$result['cfg']['quality_status'][0]);
        exit(json_encode($result));
    }

    /**
     * 质量疑问产品列表
     */
    public function lock_list(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $map=[];
        if(!empty($params['beg']) && !empty($params['end'])){
            $map[]=array('d.fdate','between',[$params['beg'],$params['end']]);
        }elseif (!empty($params['beg'])){
            $map[]=array('d.fdate','>=',$params['beg']);
        }elseif (!empty($params['end'])){
            $map[]=array('d.fdate','<=',$params['end']);
        }
        if(!empty($params['sup_code'])) $map[]=array('d.sup_code','=',$params['sup_code']);
        if(!empty($params['goods_name'])) $map[]=array('c.goods_name','like','%'.$params['goods_name'].'%');
        if(intval($params['status']>0)) $map[]=array('d.status','=',$params['status']-1);
        $result=DoubtM::lockList($map,$page);
        $result['status']=1;
        exit(json_encode($result));
    }

    /**
     * 锁定质量疑问产品
     */
    public function lock_drug(){
        $params=$this->request->data;
        if(isset($params['lockall']) && $params['lockall']) $result=DoubtM::lockDrugAll($params,['code'=>$this->request->code]);
        else $result=DoubtM::lockDrugOne($params,['code'=>$this->request->code]);
        exit(json_encode($result));
    }

    /**
     * 待处理质量疑问锁定列表
     */
    public function deal_list(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $map[]=['d.status','=',0];//待处理
        if(!empty($params['beg']) && !empty($params['end'])){
            $map[]=array('d.fdate','between',[$params['beg'],$params['end']]);
        }elseif (!empty($params['beg'])){
            $map[]=array('d.fdate','>=',$params['beg']);
        }elseif (!empty($params['end'])){
            $map[]=array('d.fdate','<=',$params['end']);
        }
        if(!empty($params['sup_code'])) $map[]=array('d.sup_code','=',$params['sup_code']);
        if(!empty($params['goods_name'])) $map[]=array('c.goods_name','like','%'.$params['goods_name'].'%');
        $result=DoubtM::lockList($map,$page);
        $result['status']=1;
        exit(json_encode($result));
    }

    /**
     * 获取需要的配置项
     */
    public function get_cfg(){
        $cfg['detect_tache']=Config::get('parameter.detect_tache');
        $cfg['goods_status']=Config::get('parameter.goods_status');
        $cfg['quality_status']=Config::get('parameter.quality_status');
        $result=array('status'=>1,'cfg'=>$cfg);
        exit(json_encode($result));
    }

    /**
     * 处理质量疑问锁定商品
     */
    public function unlock(){
        $params=$this->request->data;
        $result=DoubtM::unlock($params,['code'=>$this->request->code]);
        _end:
        exit(json_encode($result));
    }

}