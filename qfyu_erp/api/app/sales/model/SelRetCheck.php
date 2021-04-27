<?php

namespace app\sales\model;
use app\erp\model\GoodsCheckAccept;
use app\erp\model\PurchaseRegister;
use app\helper\CommonFun;
use app\sales\validate\SelRetCheckVal;
use think\facade\Db;
use think\Model;

class SelRetCheck extends Model
{
  public static function list($res)
  {
    $page = $res['page'];
    $pageSize = $res['pageSize'];
    $search = CommonFun::ProcessingData($res['search']);
    $where= [];
    if (!empty($search['f_date']) && !empty($search['fend_date'])){
      $where[] = ['s.f_date','between',[$search['f_date'],$search['fend_date']]];
    }
    if (!empty($search['f_date']) && empty($search['fend_date'])){
      $where[] = ['s.f_date','<',$search['f_date']];
    }
    if (empty($search['f_date']) && !empty($search['fend_date'])){
      $where[] = ['s.f_date','>',$search['fend_date']];
    }
    if (!empty($search['orderid'])){
      $where[] = ['s.orderid','=',$search['orderid']];
    }
    if (!empty($search['contract_no'])){
      $where[] = ['s.contract_no','=',$search['contract_no']];
    }
    if (!empty($search['emp_no'])){
      $where[] = ['s.emp_no','=',$search['emp_no']];
    }
    if (!empty($search['p_orderid'])){
      $where[] = ['s.p_orderid','=',$search['p_orderid']];
    }
    if (!empty($search['audit'])){
      $where[] = ['s.audit','=',$search['audit']];
    }
    if (!empty($search['cust_no'])){
      $where[] = ['s.cust_no','=',$search['cust_no']];
    }
    if (!empty($search['linkman2'])){
      $where[] = ['s.linkman2','=',$search['linkman2']];
    }
    if (!empty($search['depart_id'])){
      $where[] = ['s.depart_id','=',$search['depart_id']];
    }
    if (!empty($search['goods_code'])){
      $oidArr = SelRetCheckDtl::where('goods_code','in',$search['goods_code'])->column('orderid');
      if ($oidArr) $where[] = ['s.orderid','in',implode(',',$oidArr)];
      else $data = [];goto _end;
    }
    if (isset($search['status']) && $search['status']!=2){
      $where[] = ['s.status','=',$search['status']];
    }
    $data = self::alias('s')->field('s.*,c.sname as cust_name,c.parlevel,c.depart as cust_depart,cu.sname as cust_sname')
          ->join('customer c','c.id=s.cust_no','left')
          ->join('customer cu','cu.id=c.parlevel','left')
          ->where($where)
          ->order('s.f_date')
          ->paginate(['page'=>$page,'list_rows'=>$pageSize])->toArray();
    _end:
    return ['status'=>1,'data'=>$data];
  }

  public static function dtl($orderid)
  {
    $result = ['status'=>0,'msg'=>'查询失败！'];
    $check = self::where('s.orderid',$orderid)->alias('s')
            ->field('s.*,c.name as cust_name,c.depart as cust_depart')
            ->join('customer c','c.id=s.cust_no','left')
            ->find();
    $data  = SelRetCheckDtl::where('orderid',$orderid)->alias('d')
            ->field('d.*,c.name,c.specs,c.dosage,c.packspecs,c.gsp_type,c.origin,c.production,c.approval_code,w.storage_type,p.full_name as prov_name,p.drug_license')
            ->join('commodity c','c.goods_code=d.goods_code','left')
            ->join('commodity_warehouse w','w.goods_code=d.goods_code','left')
            ->join('providers p','p.supplier_code=d.prov_no','left')
            ->select()
            ->toArray();
    if ($check){
      $check = $check->toArray();
      $result = ['status'=>1,'msg'=>'Success','formData'=>$check,'data'=>$data];
    }
    return $result;
  }

  public static function saveData($data,$depart,$user)
  {
    $result   = ['status'=>0,'msg'=>'保存失败！'];
    $checkData= CommonFun::ProcessingData($data['formData']);
    $validate = new SelRetCheckVal();
    $checker  = $validate->scene('all')->check($checkData);
    if (!$checker){
      $result['msg'] = $validate->getError();goto _end;
    }
    $dateTime = date("Y-m-d H:i:s");
    $orderid = !empty($checkData['orderid'])?$checkData['orderid']:CommonFun::createOrder("XD");
    $checkData['orderid'] = $orderid;
    $checkData['creater'] = !empty($checkData['creater'])?$checkData['creater']:$user;
    $checkData['creater_date']= !empty($checkData['creater_date'])?$checkData['creater_date']:$dateTime;
    $checkData['depart_id']   = !empty($checkData['orderid'])?$checkData['depart_id']:$depart;
    $checkData['mender']      = !empty($checkData['orderid'])?$user:null;
    $checkData['update_date'] = !empty($checkData['orderid'])?$dateTime:null;
    $checkData['goods_qty'] = 0;
    $checkData['goods_sum'] = 0;
    $checkData['tax_sum']   = 0;
    $checkData['amount']    = 0;
    $checkDtl = [];
    if(!empty($data['data'])){
      foreach ($data['data'] as $k=>$v){
        $v = CommonFun::ProcessingData($v);
        $checkDtl[$k] = [];
        $checkDtl[$k]['orderid']    = $orderid;
        $checkDtl[$k]['item_no']    = $k+1;
        $checkDtl[$k]['goods_code'] = $v['goods_code'];
        $checkDtl[$k]['unit']       = $v['unit'];
        $checkDtl[$k]['qty']        = $v['qty'];
        $qty    = abs($v['qty']);
        $rebate = $v['rebate']?calc([$v['rebate'],'/',100],2):1;
        $tax    = $v['tax']?calc([$v['tax'],'/',100],2)+1:1;
        $price  = calc([$v['o_price'],'*',$rebate],6);
        $amount = calc([$qty,'*',$price],6);
        $not_tax_price = calc([$price,'/',$tax],6);
        $goods_sum = calc([$not_tax_price,'*',$qty],6);
        $tax_sum   = calc([$amount,'-',$goods_sum],6);
        $checkData['goods_qty'] = calc([$checkData['goods_qty'],'+',$qty],5);
        $checkData['goods_sum'] = calc([$checkData['goods_sum'],'+',$goods_sum],6);
        $checkData['tax_sum']   = calc([$checkData['tax_sum'],'+',$tax_sum],6);
        $checkData['amount']    = calc([$checkData['amount'],'+',$amount],6);
        $checkDtl[$k]['o_price']        = $v['o_price'];
        $checkDtl[$k]['rebate']         = $v['rebate'];
        $checkDtl[$k]['price']          = $price;
        $checkDtl[$k]['tax']            = $v['tax'];
        $checkDtl[$k]['not_tax_price']  = $not_tax_price;
        $checkDtl[$k]['goods_sum']      = $goods_sum;
        $checkDtl[$k]['tax_sum']        = $tax_sum;
        $checkDtl[$k]['amount']         = $amount;
        $checkDtl[$k]['batch_no']       = $v['batch_no'];
        $checkDtl[$k]['pro_date']       = $v['pro_date'];
        $checkDtl[$k]['valid_date']     = $v['valid_date'];
        $checkDtl[$k]['prov_no']        = $v['prov_no'];
        $checkDtl[$k]['p_orderid']      = $v['p_orderid'];
        $checkDtl[$k]['p_item_no']      = $v['p_item_no'];
        $checkDtl[$k]['cust_goods_code']= $v['cust_goods_code'];
        $checkDtl[$k]['eligible_qty']   = $v['eligible_qty'];
        $checkDtl[$k]['remark']         = $v['remark'];
        $checkDtl[$k]['net_apple_no']   = $v['net_apple_no'];
        $checkDtl[$k]['net_apple_item'] = $v['net_apple_item'];
        $checkDtl[$k]['gift_qty']       = $v['gift_qty'];
        $checkDtl[$k]['out_remark']     = $v['out_remark'];
        $checkDtl[$k]['goods_state']    = $v['goods_state'];
        $checkDtl[$k]['quality_state']  = $v['quality_state'];
      }
    }
    unset($checkData['audit']);
    unset($checkData['cust_name']);
    unset($checkData['cust_depart']);
    $hasOrderid = self::where('orderid',$orderid)->find();
    Db::startTrans();
    if($hasOrderid){
      //修改
      $res1 = self::where('orderid',$orderid)->update($checkData);
      $hasDtl = SelRetCheckDtl::where('orderid',$orderid)->select()->toArray();
      if ($hasDtl) {
        $res2 = SelRetCheckDtl::where('orderid', $orderid)->deleteInsertAll($checkDtl);
      }else{
        if(!empty($data['data'])){
          $res2 = SelRetCheckDtl::insertAll($checkDtl);
          if (!$res2){
            Db::rollback();
            $result['msg'] = '修改失败！';goto _end;
          }
        }
      }
      if ($res1){
        Db::commit();
        $result = ['status'=>1,'msg'=>'修改成功！','orderid'=>$orderid];
      }else{
        Db::rollback();
      }
    }else{
      //新增
      $res1 = self::insert($checkData);
      if (!empty($checkDtl)){
        $res2 = SelRetCheckDtl::insertAll($checkDtl);
        if (!$res2){
          Db::rollback();goto _end;
        }
      }
      if ($res1){
        Db::commit();
        $result = ['status'=>1,'msg'=>'修改成功！','orderid'=>$orderid];
      }else{
        Db::rollback();
      }
    }
    _end:
    return $result;
  }

  public static function del($orderid)
  {
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $hasData = self::where('orderid',$orderid)->field('status,fungible')->find();
    if ($hasData) $hasData = $hasData->toArray();
    if ($hasData['status']!=0){
      $result['msg'] = '操作失败！当前单据已经审核通过。';goto _end;
    }
    if ($hasData['fungible']!=0){
      $result['msg'] = '操作失败！根据系统设置代销收货单不能删除。';goto _end;
    }
    Db::startTrans();
    $res1 = self::where('orderid',$orderid)->delete();
    $res2 = SelRetCheckDtl::where('orderid',$orderid)->delete();
    if ($res1 && $res2){
      Db::commit();
      $oid = self::where('orderid','<>',$orderid)->order('f_date')->value('orderid');
      $result = ['status'=>1,'msg'=>'删除成功！','orderid'=>$oid];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }
  /**
   *  审核销售退回登记单；生成销退质量验收单：按gsp验收类型进行分单；判断是否要生成冷藏药品销退收货单。
   * @param $orderid string 销退登记单单据号
   * @param $depart string 当前审核部门
   * @param $user string 当前审核人员
   * @return array
   **/
  public static function check($orderid,$depart,$user)
  {
    $result = ['status'=>0,'msg'=>'审核失败！'];
    $selData = self::alias('s')
              ->field('s.*,c.comarea,c.mannumber')
              ->join('customer c','c.id=s.cust_no','left')
              ->where('s.orderid',$orderid)
              ->find();
    if ($selData) $selData = $selData->toArray();
    if($selData['status']!=0){
      $result['msg'] = '操作失败！当前单据已经审核通过。';goto _end;
    }
    $dtlData = SelRetCheckDtl::alias('d')->field('d.*,c.gsp_type,w.storage_type')
      ->join('commodity c','c.goods_code=d.goods_code','left')
      ->join('commodity_warehouse w','w.goods_code=d.goods_code','left')
      ->where('d.orderid',$orderid)
      ->select()
      ->toArray();
    $checkDefault = Db::name('goods_check_default')->column('*','gsp_type');//质量验收默认设置
    $msg = '';
    $oid = [];//质量验收单单据号
    $sorderid   = null;//冷藏药品销退单据号
    $selCold    = [];//冷藏药品销退单
    $selColdDtl = [];//冷藏药品销退单明细
    $checkCon   = [];//质量验收单
    $checkDtl   = [];//质量验收单明细
    $dateTime   = date("Y-m-d H:i:s");
    if (!empty($dtlData)){
      foreach ($dtlData as $k=>$v){
        if($v['gsp_type']==5 && !$selData['consignee2']){
          $result['msg'] = '当前【'.$orderid.'】号销退登记单包含特殊药品，但未选择第二收货人，根据系统设置需填写第二收货人才能进行审核！';
          goto _end;
        }
        if(stristr('冷藏储存',$v['storage_type'])){
          if (!$sorderid){
            $sorderid = CommonFun::createOrder("LS");
            $selCold['orderid']      = $sorderid;
            $selCold['f_date']       = $dateTime;
            $selCold['emp_no']       = $selData['emp_no'];
            $selCold['p_orderid']    = $orderid;
            $selCold['creater']      = $user;
            $selCold['creater_date'] = $dateTime;
            $selCold['depart_id']    = $depart;
          }
          $selColdDtl[$k]['orderid'] = $sorderid;
          $selColdDtl[$k]['item_no'] = $k+1;
          $selColdDtl[$k]['cust_no'] = $selData['cust_no'];
          $selColdDtl[$k]['address'] = $selData['comarea'];
          $selColdDtl[$k]['tel']     = $selData['mannumber'];
          $selColdDtl[$k]['emp_no']  = $selData['emp_no'];
          $selColdDtl[$k]['pay_mode_no']= $selData['pay_mode_no'];
          $selColdDtl[$k]['p_item_no']  = $v['item_no'];
          $selColdDtl[$k]['goods_code'] = $v['goods_code'];
          $selColdDtl[$k]['qty']        = abs($v['qty']);
          $selColdDtl[$k]['batch_no']   = $v['batch_no'];
          $selColdDtl[$k]['valid_date'] = $v['valid_date'];
        }
        if (!isset($checkCon[$v['gsp_type']])){
          $oid[$v['gsp_type']] = CommonFun::createOrder("XY");
          $gspMsg = PurchaseRegister::getGspType($v['gsp_type']);
          $gspMsg = '<p>'.$oid[$v['gsp_type']].$gspMsg.'</p>';
          $msg .= $gspMsg;
          $checkCon[$v['gsp_type']]['orderid'] = $oid[$v['gsp_type']];
          $checkCon[$v['gsp_type']]['delivery_date'] = $dateTime;
          $checkCon[$v['gsp_type']]['accept_date']   = $dateTime;
          $checkCon[$v['gsp_type']]['depart']        = $depart;
          $checkCon[$v['gsp_type']]['come_orderid']  = $orderid;
          $checkCon[$v['gsp_type']]['supplier_code'] = $selData['cust_no'];
          $checkCon[$v['gsp_type']]['check_type']  = 8;
          $checkCon[$v['gsp_type']]['gsp_type']    = $v['gsp_type'];
          $checkCon[$v['gsp_type']]['create_code'] = $user;
          $checkCon[$v['gsp_type']]['create_date'] = $dateTime;
          $checkCon[$v['gsp_type']]['accept_code'] = $selData['emp_no'];
        }
        $checkDtl[$k]['a_orderid']  = $oid[$v['gsp_type']];
        $checkDtl[$k]['item_no']    = $k+1;
        $checkDtl[$k]['goods_code'] = $v['goods_code'];
        $checkDtl[$k]['unit']       = $v['unit'];
        $qty      = abs($v['qty']);
        $gift_qty = abs($v['gift_qty']);
        $amount   = calc([$qty,'+',$gift_qty],5);
        $money    = abs($v['amount']);
        $checkDtl[$k]['amount'] = $amount;
        $checkDtl[$k]['qualified_amount'] = $amount;
        $checkDtl[$k]['rejection_amount'] = 0;
        $checkDtl[$k]['spot_check_amount']= null;
        $checkDtl[$k]['price'] = calc([$money,'/',$amount],6);
        $checkDtl[$k]['money'] = $money;
        $checkDtl[$k]['batch'] = $v['batch_no'];
        $checkDtl[$k]['production_date']     = $v['pro_date'];
        $checkDtl[$k]['production_end_date'] = $v['valid_date'];
        $checkDtl[$k]['sterilization_batch'] = $checkDefault[$v['gsp_type']]['sterilization_batch'];
        $checkDtl[$k]['verify_report']    = $checkDefault[$v['gsp_type']]['verify_report'];
        $checkDtl[$k]['pass_gate_no']     = $checkDefault[$v['gsp_type']]['pass_gate_no'];
        $checkDtl[$k]['register_card_no'] = $checkDefault[$v['gsp_type']]['register_card_no'];
        $checkDtl[$k]['certificato']   = $checkDefault[$v['gsp_type']]['certificato'];
        $checkDtl[$k]['quality_state'] = $checkDefault[$v['gsp_type']]['quality_state'];
        $checkDtl[$k]['package_state'] = $checkDefault[$v['gsp_type']]['package_state'];
        $checkDtl[$k]['label_state']   = $checkDefault[$v['gsp_type']]['label_state'];
        $checkDtl[$k]['directions']    = $checkDefault[$v['gsp_type']]['directions'];
        $checkDtl[$k]['check_verdict'] = $checkDefault[$v['gsp_type']]['check_verdict'];
        $checkDtl[$k]['checker']       = $checkDefault[$v['gsp_type']]['checker'];
        $checkDtl[$k]['accepter']      = $checkDefault[$v['gsp_type']]['accepter'];
        $checkDtl[$k]['come_orderid']  = $v['orderid'];
        $checkDtl[$k]['p_item_no']     = $v['item_no'];
        $checkDtl[$k]['storage_type']  = $v['storage_type'];
        $checkDtl[$k]['return_reason'] = $v['out_remark'];
      }
    }
    Db::startTrans();
    if($sorderid){
      $res1 = SelColdStorage::insert($selCold);
      $res2 = SelColdStorageDtl::insertAll($selColdDtl);
      if (!$res1 || !$res2){
        Db::rollback();
        $result['msg'] = '冷藏药品销退单新增失败！';goto _end;
      }
    }
    $res3 = Db::name('goods_check_accept')->insertAll($checkCon);
    $res4 = Db::name('goods_check_accept_details')->insertAll($checkDtl);
    $res5 = self::where('orderid',$orderid)->update(['audit'=>$user,'mender'=>$user,'update_date'=>$dateTime,'status'=>1]);
    if ($res3 && $res4 && $res5){
      Db::commit();
      $result = ['status'=>1,'orderid'=>$oid,'sorderid'=>$sorderid,'msg'=>$msg];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }

  public static function back($orderid,$user)
  {
    $result = ['status'=>0,'msg'=>'还原失败！'];
    $status = self::where('orderid',$orderid)->value('status');
    if ($status!=1){
      $result['msg'] = '还原失败！当前单据未审核。';goto _end;
    }
    $hasCheck = GoodsCheckAccept::where('come_orderid',$orderid)->find();
    if ($hasCheck){
      $result['msg'] = '还原失败！当前'.$orderid.'号单据已经生成销退质量验收单。';goto _end;
    }
    $hasSold = SelColdStorage::where('p_orderid',$orderid)->find();
    if ($hasSold){
      $result['msg'] = '还原失败！当前'.$orderid.'号单据已经生成冷藏药品销退收货登记单。';goto _end;
    }
    $res = self::where('orderid',$orderid)->update(['status'=>0,'mender'=>$user,'update_date'=>date("Y-m-d H:i:s")]);
    if ($res) $result = ['status'=>1,'msg'=>'还原成功！'];
    _end:
    return $result;
  }

}
