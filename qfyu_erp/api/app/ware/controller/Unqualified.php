<?php
namespace app\ware\controller;
use app\BaseController;
use app\ware\model\UnqualifiedM;
use think\facade\Db;

class Unqualified extends BaseController
{
    /**
     * 不合格药品确认报告表
     */
    public function reject_list(){
        $params=$this->request->data;
        $page=intval($params['page'])?intval($params['page']):1;
        $search=$params['search'];
        $map=array();
        if(!empty($search['beg']) && !empty($search['end'])){
            $map[]=array('rc.f_date','>=',$search['beg']);
            $map[]=array('rc.f_date','<=',$search['end']);
        }else if(!empty($search['beg'])){
            $map[]=array('rc.f_date','>=',$search['beg']);
        }else if(!empty($search['end'])){
            $map[]=array('rc.f_date','<=',$search['end']);
        }
        if(!empty($search['sup_code'])) $map[]=array('p.supplier_code','=',$search['sup_code']);
        if(!empty($search['goods_name'])) $map[]=array('c.goods_name','like','%'.trim($search['goods_name']).'%');
        $result=array('status'=>1,'msg'=>'Success');
        $result['data']=UnqualifiedM::reject_list($map,$page);
        exit(json_encode($result));
    }

    /**
     * 不合格药品报告确认表
     */
    public function reject_check(){
        $params=$this->request->data;
        $result=UnqualifiedM::reject_check($params);
        _end:
        exit(json_encode($result));
    }

    /**
     * 不合格药品台账
     */
    public function reject_book(){
        $params=$this->request->data;
        $page=intval($params['page'])?intval($params['page']):1;
        $search=$params['search'];
        $map=array();
        if(!empty($search['beg']) && !empty($search['end'])){
            $map[]=array('rb.f_date','>=',$search['beg']);
            $map[]=array('rb.f_date','<=',$search['end']);
        }else if(!empty($search['beg'])){
            $map[]=array('rb.f_date','>=',$search['beg']);
        }else if(!empty($search['end'])){
            $map[]=array('rb.f_date','<=',$search['end']);
        }
        if(!empty($search['sup_code'])) $map[]=array('p.supplier_code','=',$search['sup_code']);
        if(!empty($search['goods_name'])) $map[]=array('c.goods_name','like','%'.trim($search['goods_name']).'%');
        if($search['bs_flag']==1 && $search['xh_flag']==1 && $search['th_flag']==1){//123
            $map[]=Db::raw('rb.bs_flag=1 OR rb.xh_flag OR rb.th_flag');
        }elseif ($search['bs_flag']==1 && $search['xh_flag']==1){//12
            $map[]=Db::raw('rb.bs_flag=1 OR rb.xh_flag');
        }elseif ($search['bs_flag']==1 && $search['th_flag']==1){//13
            $map[]=Db::raw('rb.bs_flag=1 OR rb.th_flag');
        }elseif ($search['xh_flag']==1 && $search['th_flag']==1){//23
            $map[]=Db::raw('rb.xh_flag OR rb.th_flag');
        }elseif ($search['bs_flag']==1){//1
            $map[]=array('rb.bs_flag','=',1);
        }elseif ($search['xh_flag']==1){//2
            $map[]=array('rb.xh_flag','=',1);
        }elseif ($search['th_flag']==1){//3
            $map[]=array('rb.th_flag','=',1);
        }
        $result=array('status'=>1,'msg'=>'Success');
        $result['data']=UnqualifiedM::reject_book($map,$page);
        exit(json_encode($result));
    }
}