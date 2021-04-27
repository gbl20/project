<?php

namespace app\sales\model;
use app\helper\CommonFun;
use app\sales\validate\SelRetDemandVal;
use think\facade\Db;
use think\Model;

class SelRetDemand extends Model
{
  public static function list($res)
  {
    $where = [];
    $search = CommonFun::ProcessingData($res['search']);
    if (!empty($search['f_date']) && !empty($search['f_edate'])){
      $where[] = ['f_date','between',[$search['f_date'],$search['f_edate']]];
    }
    if (!empty($search['f_date']) && empty($search['f_edate'])){
      $where[] = ['f_date','<',$search['f_date']];
    }
    if (empty($search['f_date']) && !empty($search['f_edate'])){
      $where[] = ['f_date','>',$search['f_edate']];
    }
    if (!empty($search['orderid'])){
      $where[] = ['orderid','=',$search['orderid']];
    }
    if (!empty($search['p_orderid'])){
      $where[] = ['p_orderid','=',$search['p_orderid']];
    }
    if (!empty($search['contract_no'])){
      $where[] = ['contract_no','=',$search['contract_no']];
    }
    if (!empty($search['creater'])){
      $where[] = ['creater','=',$search['creater']];
    }
    if (!empty($search['depart_id'])){
      $where[] = ['depart_id','=',$search['depart_id']];
    }
    if (!empty($search['cust_no'])){
      $where[] = ['cust_no','=',$search['cust_no']];
    }
    if (!empty($search['linkman2'])){
      $where[] = ['linkman2','=',$search['linkman2']];
    }
    if (!empty($search['emp_no'])){
      $where[] = ['emp_no','=',$search['emp_no']];
    }
    if (!empty($search['audit'])){
      $where[] = ['audit','=',$search['audit']];
    }
    if (isset($search['status']) && $search['status']!=''){
      $where[] = ['status','=',$search['status']];
    }
    if (!empty($search['goods_code'])){
      $orderidIn = SelRetDemandDtl::where('goods_code','in',$search['goods_code'])->column('orderid');
      if($orderidIn) {
        $where[] = ['orderid','in',implode(',',$orderidIn)];
      }else{
        $data = [];goto _end;
      }
    }
    $data = self::where($where)->alias('s')
          ->field('s.orderid,s.f_date,s.contract_no,s.p_orderid,s.emp_no,s.audit,s.cust_no,s.linkman,s.linkman2,s.goods_qty,s.goods_sum,s.tax_sum,s.amount,s.remark,s.creater,s.depart_id,s.status,c.depart as cust_depart,c.sname as cust_sname,c.parlevel,cu.name as parlevel_name')
          ->join('customer c','c.id=s.cust_no','left')
          ->join('customer cu','cu.id=c.parlevel','left')
          ->order('s.f_date')
          ->paginate(['page'=>$res['page'],'list_rows'=>$res['pageSize']])
          ->toArray();
    _end:
    return ['status'=>1,'data'=>$data];
  }

  public static function dtl($search)
  {
    $result = ['status'=>0,'msg'=>'获取失败！'];
    $orderid = $search['orderid'];
    $selData = self::where('s.orderid',$orderid)->alias('s')
              ->field('s.*,c.name as cust_name,c.depart as cust_depart')
              ->join('customer c','c.id=s.cust_no','left')
              ->find();
    if ($selData) { $selData = $selData?$selData->toArray():$selData; }
    $field = 'd.*,c.name,c.specs,c.dosage,c.packspecs,c.gsp_type,c.origin,c.production,c.approval_code,w.storage_type,p.full_name as prov_name,p.drug_license';
    $selDtlData = SelRetDemandDtl::where('orderid',$orderid)->alias('d')
              ->field($field)
              ->join('commodity c','c.goods_code=d.goods_code','left')
              ->join('commodity_warehouse w','w.goods_code=d.goods_code','left')
              ->join('providers p','p.supplier_code=d.prov_no','left')
              ->select()
              ->toArray();
    $reData = [];
    if ($selData['o_type']==1){
      foreach ($selDtlData as $k=>$v){
        $reData[] = $v['p_id'];
      }
    }
    $result = ['status'=>1,'msg'=>'Success','selData'=>$selData,'selDtlData'=>$selDtlData,'reData'=>$reData];
    return $result;
  }

  public static function saveDemand($data,$depart,$user)
  {
    $result = ['status'=>0,'msg'=>'保存失败！'];
    $formData = CommonFun::ProcessingData($data['formData']);
    $selDtlData = $data['data'];
    $validate = new SelRetDemandVal();
    $checker  = $validate->scene('all')->check($formData);
    if (!$checker){
      $result['msg'] = $validate->getError();goto _end;
    }
    $hasOrderid = self::where('orderid',$formData['orderid'])->field('orderid,status')->find();
    if ($hasOrderid) $hasOrderid = $hasOrderid->toArray();
    if ($hasOrderid && $hasOrderid['status']==1){
      $result['msg'] = '操作失败！该单据已经审核通过。';goto _end;
    }
    $orderid = !empty($formData['orderid'])?$formData['orderid']:CommonFun::createOrder("XT");
    $SelData['orderid'] = $orderid;
    $SelData['f_date']  = $formData['f_date'];
    $SelData['contract_no'] = $formData['contract_no'];
    $SelData['emp_no']    = $formData['emp_no'];
    $SelData['cust_no']   = $formData['cust_no'];
    $SelData['linkman']   = $formData['linkman'];
    $SelData['linkman2']  = $formData['linkman2'];
    $SelData['remark']    = $formData['remark'];
    $SelData['fungible']  = $formData['fungible'];
    $SelData['creater']   = $user;
    $SelData['creater_date'] = date("Y-m-d H:i:s");
    $SelData['depart_id'] = $depart;
    $SelData['o_type']    = $data['status'];
    $goods_qty = 0;
    $goods_sum = 0;
    $tax_sum   = 0;
    $amount    = 0;
    $selDtl    = [];
    if (!empty($selDtlData)){
      foreach ($selDtlData as $k=>$v){
        $selDtl[$k] = [];
        $v = CommonFun::ProcessingData($v);
        $SelData['p_orderid']  = $v['p_orderid'];
        $selDtl[$k]['orderid'] = $orderid;
        $selDtl[$k]['p_id']    = $k+1;
        $selDtl[$k]['item_no'] = $k+1;
        $selDtl[$k]['goods_code'] = $v['goods_code'];
        $selDtl[$k]['unit'] = $v['unit'];
        $selDtl[$k]['qty']  = $v['qty'];
        $selDtl[$k]['gift_qty'] = $v['gift_qty'];
        $selDtl[$k]['o_price']  = $v['o_price'];
        $selDtl[$k]['rebate']   = $v['rebate'];
        $qty    = $v['qty']<0?abs($v['qty']):$v['qty'];
        $rebate = $v['rebate']?calc([$v['rebate'],'/',100],2):1;
        $tax    = $v['tax']?calc([$v['tax'],'/',100],2)+1:1;
        $price  = calc([$v['o_price'],'*',$rebate],6);
        $selDtl[$k]['price'] = $price;
        $money = calc([$qty,'*',$price],6);
        $goodsSum = calc([$money,'/',$tax],6);
        $taxSum = calc([$money,'-',$goodsSum],6);
        $selDtl[$k]['tax'] = $v['tax'];
        $selDtl[$k]['not_tax_price'] = calc([$price,'/',$tax],6);
        $selDtl[$k]['goods_sum']  = $goodsSum;
        $selDtl[$k]['tax_sum']    = $taxSum;
        $selDtl[$k]['amount']     = $money;
        $selDtl[$k]['prov_no']    = $v['prov_no'];
        $selDtl[$k]['batch_no']   = $v['batch_no'];
        $selDtl[$k]['pro_date']   = $v['pro_date'];
        $selDtl[$k]['valid_date'] = $v['valid_date'];
        $selDtl[$k]['remark']     = $v['remark'];
        $selDtl[$k]['p_orderid']  = $v['p_orderid'];
        $selDtl[$k]['p_item_no']  = $v['p_item_no'];
        $selDtl[$k]['p_date']     = $v['p_date'];
        $selDtl[$k]['p_qty']      = isset($v['p_qty'])?$v['p_qty']:null;
        $selDtl[$k]['p_gift_qty'] = isset($v['p_gift_qty'])?$v['p_gift_qty']:null;
        $selDtl[$k]['out_remark'] = $v['out_remark'];
        $selDtl[$k]['goods_state']   = isset($v['goods_state'])?$v['goods_state']:'';
        $selDtl[$k]['quality_state'] = isset($v['quality_state'])?$v['quality_state']:'';
        $goods_qty = calc([$goods_qty,'+',$qty],5);
        $goods_sum = calc([$goods_sum,'+',$goodsSum],6);
        $tax_sum   = calc([$tax_sum,'+',$taxSum],6);
        $amount    = calc([$amount,'+',$money],6);
      }
    }
    $SelData['goods_qty'] = $goods_qty;
    $SelData['goods_sum'] = $goods_sum;
    $SelData['tax_sum']   = $tax_sum;
    $SelData['amount']    = $amount;
    Db::startTrans();
    if (!$hasOrderid){
      //新增
      $res1 = self::insert($SelData);
      if (!empty($selDtlData)){
        $res2 = SelRetDemandDtl::insertAll($selDtl);
        if (!$res2){
          Db::rollback();goto _end;
        }
      }
      if ($res1){
        Db::commit();
        $result = ['status'=>1,'msg'=>'保存成功！','orderid'=>$orderid];
      }else{
        Db::rollback();
      }
    }else{
      //修改
      unset($SelData['f_date']);
      unset($SelData['creater']);
      unset($SelData['creater_date']);
      unset($SelData['depart_id']);
      $SelData['mender'] = $user;
      $SelData['update_date'] = date("Y-m-d H:i:s");
      $hasDtl = SelRetDemandDtl::where('orderid',$SelData['orderid'])->find();
      $res1 = self::where('orderid',$SelData['orderid'])->update($SelData);
      if ($hasDtl){
        $res2 = SelRetDemandDtl::where('orderid',$SelData['orderid'])->deleteInsertAll($selDtl);
      }else{
        if (!empty($selDtlData)){
          $res2 = SelRetDemandDtl::where('orderid',$SelData['orderid'])->insertAll($selDtl);
          if (!$res2){
            Db::rollback();goto _end;
          }
        }
      }
      if ($res1){
        Db::commit();
        $result = ['status'=>1,'msg'=>'修改成功！','orderid'=>$SelData['orderid']];
      }else{
        Db::rollback();
        $result['msg'] = '修改失败！';
      }
    }
    _end:
    return $result;
  }

  public static function check($data,$depart,$user)
  {
    $result = ['status'=>0,'msg'=>'审核失败！'];
    $selData = self::where('orderid',$data['orderid'])->find();
    $selDtlData = SelRetDemandDtl::where('orderid',$data['orderid'])->select()->toArray();
    if ($selData) $selData = $selData->toArray();
    if($selData && $selData['status']!=0){
      $result['msg'] = '操作失败！当前单据已经审核通过。';goto _end;
    }
    $orderid = CommonFun::createOrder("XD");
    $dateTime = date("Y-m-d H:i:s");
    $check['orderid'] = $orderid;
    $check['f_date']  = $dateTime;
    $check['contract_no'] = $selData['contract_no'];
    $check['p_orderid'] = $selData['orderid'];
    $check['emp_no']    = $selData['emp_no'];
    $check['cust_no']   = $selData['cust_no'];
    $check['linkman']   = $selData['linkman'];
    $check['linkman2']  = $selData['linkman2'];
    $check['goods_qty'] = $selData['goods_qty'];
    $check['goods_sum'] = $selData['goods_sum'];
    $check['tax_sum'] = $selData['tax_sum'];
    $check['amount']  = $selData['amount'];
    $check['creater'] = $user;
    $check['creater_date'] = $dateTime;
    $check['depart_id'] = $depart;
    $checkDtl = [];
    if (!empty($selDtlData)){
      foreach ($selDtlData as $k=>$v){
        if (empty($v['qty'])){
          $result['msg'] = '商品数量不能为空';goto _end;
        }
        $checkDtl[$k] = [];
        $checkDtl[$k]['orderid'] = $orderid;
        $checkDtl[$k]['item_no'] = $k+1;
        $checkDtl[$k]['goods_code'] = $v['goods_code'];
        $checkDtl[$k]['unit'] = $v['unit'];
        $checkDtl[$k]['qty'] = $v['qty'];
        $checkDtl[$k]['o_price'] = $v['o_price'];
        $checkDtl[$k]['rebate'] = $v['rebate'];
        $checkDtl[$k]['price'] = $v['price'];
        $checkDtl[$k]['tax'] = $v['tax'];
        $checkDtl[$k]['not_tax_price'] = $v['not_tax_price'];
        $checkDtl[$k]['goods_sum'] = $v['goods_sum'];
        $checkDtl[$k]['tax_sum'] = $v['tax_sum'];
        $checkDtl[$k]['amount'] = $v['amount'];
        $checkDtl[$k]['batch_no'] = $v['batch_no'];
        $checkDtl[$k]['pro_date'] = $v['pro_date'];
        $checkDtl[$k]['valid_date'] = $v['valid_date'];
        $checkDtl[$k]['prov_no'] = $v['prov_no'];
        $checkDtl[$k]['p_orderid'] = $v['p_orderid'];
        $checkDtl[$k]['p_item_no'] = $v['p_item_no'];
//        $checkDtl[$k]['cust_goods_code'] = $v[''];
        $checkDtl[$k]['gift_qty'] = $v['gift_qty'];
        $checkDtl[$k]['out_remark'] = $v['out_remark'];
        $checkDtl[$k]['goods_state'] = $v['goods_state'];
        $checkDtl[$k]['quality_state'] = $v['quality_state'];
      }
    }
    Db::startTrans();
    $res1 = self::where('orderid',$data['orderid'])->update(['audit'=>$user,'status'=>1]);
    $res2 = SelRetCheck::insert($check);
    $res3 = SelRetCheckDtl::insertAll($checkDtl);
    if ($res1 && $res2 && $res3){
      Db::commit();
      $result = ['status'=>1,'msg'=>'审核成功！','orderid'=>$orderid];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }

  public static function backData($search,$user)
  {
    $result = ['status'=>0,'msg'=>'还原失败！'];
    $search = CommonFun::ProcessingData($search);
    $status = self::where('orderid',$search['orderid'])->value('status');
    if($status!=1){
      $result['msg'] = '操作失败！当前单据未审核。';goto _end;
    }
    $hasCheck = SelRetCheck::where('p_orderid',$search['orderid'])->field('orderid')->find();
    if($hasCheck){
      $hasCheck = $hasCheck->toArray();
      $result['msg'] = '当前的销售退回申请单已经生成了销售登记单【'.$hasCheck['orderid'].'】，请先删除销售登记单再还原！';
      goto _end;
    }
    $update['mender'] = $user;
    $update['update_date'] = date("Y-m-d H:i:s");
    $update['status'] = 0;
    $res = self::where('orderid',$search['orderid'])->update($update);
    if ($res){
      $result = ['status'=>1,'msg'=>'还原成功！'];
    }
    _end:
    return $result;
  }

  public static function delDate($search)
  {
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $search = CommonFun::ProcessingData($search);
    $status = self::where('orderid',$search['orderid'])->field('status,fungible')->find();
    if ($status) $status = $status->toArray();
    if($status['status']!=0){
      $result['msg'] = '操作失败！当前单据已经审核通过。';
      goto _end;
    }
    if($status['fungible']!=0){
      $result['msg'] = '操作失败！当前单据为代销收货单根据系统设置不允许删除。';
      goto _end;
    }
    $check = SelRetCheck::where('p_orderid',$search['orderid'])->find();
    if ($check){
      $result['msg'] = '操作失败！当前单据已经生成销售退回登记单。';
      goto _end;
    }
    Db::startTrans();
    $res1 = self::where('orderid',$search['orderid'])->delete();
    $res2 = SelRetDemandDtl::where('orderid',$search['orderid'])->delete();
    if ($res1 && $res2){
      Db::commit();
      $orderid = self::where('orderid','<>',$search['orderid'])->order('f_date','desc')->value('orderid');
      $result = ['status'=>1,'msg'=>'删除成功！','orderid'=>$orderid];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }
}
