<?php
namespace app\ware\model;
use think\facade\Db;
use think\Model;

class UnqualifiedM extends Model
{
    /**
     * 不合格药品确认报告表 列表
     */
    public static function reject_list($map=[],$page,$order='rc.f_date desc',$pageSize=100){
        $field='rc.*,w.ware_title,c.goods_name,c.specs,c.dosage,c.production,c.origin,c.approval_code,p.name as sup_name';
        $list=Db::name('reject_confirm')->alias('rc')->field($field)
            ->join('commodity c','c.goods_code=rc.goods_code','LEFT')
            ->join('warehouse w','w.ware_code=rc.ware_code','LEFT')
            ->join('providers p','p.supplier_code=rc.sup_code','LEFT')
            ->where($map)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        foreach ($list['data'] as $k=>$v){
            $list['data'][$k]['f_date']=date('Y-m-d',strtotime($v['f_date']));
            $list['data'][$k]['qty']=floatval($v['qty']);
            $list['data'][$k]['price']=floatval($v['price']);
            $list['data'][$k]['amount']=floatval($v['amount']);
            $list['data'][$k]['prod_date']=!empty($v['prod_date'])?date('Y-m-d',strtotime($v['prod_date'])):'';
            $list['data'][$k]['valid_date']=!empty($v['valid_date'])?date('Y-m-d',strtotime($v['valid_date'])):'';
            $list['data'][$k]['purch_date']=!empty($v['purch_date'])?date('Y-m-d',strtotime($v['purch_date'])):'';
            $list['data'][$k]['inqty']=floatval($v['inqty']);
            $list['data'][$k]['detec_date']=!empty($v['detec_date'])?date('Y-m-d',strtotime($v['detec_date'])):'';
            $list['data'][$k]['qc_date']=!empty($v['qc_date'])?date('Y-m-d',strtotime($v['qc_date'])):'';
            $list['data'][$k]['qcdep_date']=!empty($v['qcdep_date'])?date('Y-m-d',strtotime($v['qcdep_date'])):'';
            $list['data'][$k]['qcaudit_date']=!empty($v['qcaudit_date'])?date('Y-m-d',strtotime($v['qcaudit_date'])):'';
        }
        return $list;
    }
    /**
     * 审核不合格药品报告
     */
    public static function reject_check($params){
        $map[]=array('id','=',$params['id']);
        $data['qcsurvey']=trim($params['qcsurvey']);
        $data['qcman']=$params['qcman'];
        $data['qc_date']=empty($params['qc_date'])?null:$params['qc_date'];
        $data['qcdeptconfirm']=trim($params['qcdeptconfirm']);
        $data['qcdepman']=$params['qcdepman'];
        $data['qcdep_date']=empty($params['qcdep_date'])?null:$params['qcdep_date'];
        $data['qcaudit']=trim($params['qcaudit']);
        $data['qcauditman']=$params['qcauditman'];
        if(!empty($data['qcauditman'])) $data['check_status']=1;
        $data['qcaudit_date']=empty($params['qcaudit_date'])?null:$params['qcaudit_date'];
        $data['re_date']=date('Y-m-d H:i:s');
        if(!empty($data['qcauditman']) && (empty($data['qcman']) || empty($data['qcdepman']))){
            $result['msg']='质量管理员和质管部必须先审核';
            goto _end;
        }
        $field='id,goods_code,unit,qty,price,amount,batch_no,sup_code,prod_date,valid_date,purch_date,inqty,ware_code,pos_code,thing_descr,goods_state,quality_state';
        $info=Db::name('reject_confirm')->field($field)->where($map)->find();
        $data2['f_date']=date('Y-m-d H:i:s');
        $data2['goods_code']=$info['goods_code'];
        $data2['unit']=$info['unit'];
        $data2['qty']=$info['qty'];
        $data2['price']=$info['price'];
        $data2['amount']=$info['amount'];
        $data2['batch_no']=$info['batch_no'];
        $data2['sup_code']=$info['sup_code'];
        $data2['prod_date']=$info['prod_date'];
        $data2['valid_date']=$info['valid_date'];
        $data2['purch_date']=$info['purch_date'];
        $data2['inqty']=$info['inqty'];
        $data2['ware_code']=$info['ware_code'];
        $data2['pos_code']=$info['pos_code'];
        $data2['thing_descr']=$info['thing_descr'];
        $data2['report_id']=$info['id'];
        $data2['goods_state']=$info['goods_state'];
        $data2['quality_state']=$info['quality_state'];
        Db::startTrans();
        $res=Db::name('reject_confirm')->where($map)->update($data);
        $res2=Db::name('reject_book')->insert($data2);
        if($res && $res2){
            Db::commit();
            $result=array('status'=>1,'msg'=>'保存成功');
        }else{
            Db::rollback();
            $result=array('status'=>0,'msg'=>'保存失败');
        }
        _end:
        return $result;
    }
    /**
     * 不合格药品台账
     */
    public static function reject_book($map=[],$page,$order='rb.f_date desc',$pageSize=100){
        $field='rb.*,w.ware_title,c.goods_name,c.specs,c.dosage,c.production,c.origin,c.approval_code,p.name as sup_name';
        $list=Db::name('reject_book')->alias('rb')->field($field)
            ->join('commodity c','c.goods_code=rb.goods_code','LEFT')
            ->join('warehouse w','w.ware_code=rb.ware_code','LEFT')
            ->join('providers p','p.supplier_code=rb.sup_code','LEFT')
            ->where($map)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        foreach ($list['data'] as $k=>$v){
            $list['data'][$k]['f_date']=date('Y-m-d',strtotime($v['f_date']));
            $list['data'][$k]['qty']=floatval($v['qty']);
            $list['data'][$k]['price']=floatval($v['price']);
            $list['data'][$k]['amount']=floatval($v['amount']);
            $list['data'][$k]['prod_date']=!empty($v['prod_date'])?date('Y-m-d',strtotime($v['prod_date'])):'';
            $list['data'][$k]['valid_date']=!empty($v['valid_date'])?date('Y-m-d',strtotime($v['valid_date'])):'';
            $list['data'][$k]['purch_date']=!empty($v['purch_date'])?date('Y-m-d',strtotime($v['purch_date'])):'';
            $list['data'][$k]['inqty']=floatval($v['inqty']);
            $list['data'][$k]['detec_date']=!empty($v['detec_date'])?date('Y-m-d',strtotime($v['detec_date'])):'';
            $list['data'][$k]['qc_date']=!empty($v['qc_date'])?date('Y-m-d',strtotime($v['qc_date'])):'';
            $list['data'][$k]['qcdep_date']=!empty($v['qcdep_date'])?date('Y-m-d',strtotime($v['qcdep_date'])):'';
            $list['data'][$k]['qcaudit_date']=!empty($v['qcaudit_date'])?date('Y-m-d',strtotime($v['qcaudit_date'])):'';
        }
        return $list;
    }
}