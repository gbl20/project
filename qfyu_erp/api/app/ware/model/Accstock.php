<?php
namespace app\ware\model;
use think\facade\Db;
use think\Model;

class Accstock extends Model
{
    /**
     * 账面库存结存单列表
     */
    public static function getAccList($map=[],$page,$order='create_date desc',$pageSize=100){
        $field='a.*,w.ware_title,d.dept_name';
        $list=self::alias('a')->field($field)
            ->join('warehouse w','w.ware_code=a.ware_code','LEFT')
            ->join('depart d','d.id=a.grup','LEFT')
            ->where($map)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        foreach ($list['data'] as $k=>$v){
            $list['data'][$k]['f_date']=date('Y-m-d H:i',strtotime($v['f_date']));
            $list['data'][$k]['create_date']=date('Y-m-d H:i',strtotime($v['create_date']));
            $list['data'][$k]['update_date']=empty($v['update_date'])?null:date('Y-m-d H:i',strtotime($v['update_date']));
        }
        return $list;
    }

    /**
     * 获取单条结存单信息
     */
    public static function getAccInfo($bill_no=''){
        if(!empty($bill_no)){
            $field='a.*,w.ware_title';
            $res['data']=self::alias('a')->field($field)
                ->join('warehouse w','w.ware_code=a.ware_code','LEFT')
                ->where('a.bill_no','=',$bill_no)
                ->find();
            if($res['data']) $res['data']['f_date']=date('Y-m-d',strtotime($res['data']['f_date']));
            $dfield='ad.*,g.goods_name,g.specs,g.code as bar_code,g.unit,g.unit2,g.file_name,g.pym,g.dosage,g.approval_code,g.origin,g.production,f.title as function_name,c.title as category_name,p.full_name as sup_name';
            $res['list']=Db::name('accstock_detail')->alias('ad')->field($dfield)
                ->join('commodity g','g.goods_code=ad.goods_code','LEFT')
                ->join('commodity_function f','f.id=g.function_id','LEFT')
                ->join('commodity_category c','c.id=g.category_id','LEFT')
                ->join('providers p','p.supplier_code=ad.sup_code','LEFT')
                ->where('ad.bill_no','=',$bill_no)->order('itemno asc')->select()->toArray();
            foreach ($res['list'] as $k=>$v){
                $res['list'][$k]['qty1']=(float)$v['qty1'];
                $res['list'][$k]['price1']=(float)$v['price1'];
                $res['list'][$k]['qty2']=(float)$v['qty2'];
                $res['list'][$k]['price2']=(float)$v['price2'];
                $res['list'][$k]['amount']=(float)$v['amount'];
                $res['list'][$k]['selprice']=(float)$v['selprice'];
                $res['list'][$k]['rtlprice']=(float)$v['rtlprice'];
                $res['list'][$k]['sel_amount']=calc([$v['selprice'],'*',$v['qty1']],6,true);
                $res['list'][$k]['rtl_amount']=calc([$v['rtlprice'],'*',$v['qty1']],6,true);
            }
        }else{
            $res['data']=array('f_date'=>date('Y-m-d'));
            $res['list']=array();
        }
        return $res;
    }
    /**
     * 检测仓库是否锁定状态
     * @param $data
     */
    public static function checkStockLocked($ware_code){
        $result=['status'=>1,'msg'=>'未锁定'];
        if(empty($ware_code)) goto _end;
        $lock=Db::name('ware_locked')->field('bill_no')->where(['ware_code'=>$ware_code])->find();
        if($lock!=null){
            $result=['status'=>0,'msg'=>'已锁定仓库','bill_no'=>$lock['bill_no']];
        }
        _end:
        return $result;
    }
}