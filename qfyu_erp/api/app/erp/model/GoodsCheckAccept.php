<?php
namespace app\erp\model;
use app\erp\validate\GoodsCheckAcceptDtlVal;
use app\helper\CommonFun;
use app\sales\model\SelRetCheck;
use app\ware\model\StockReceive;
use think\facade\Db;
use think\Model;

class GoodsCheckAccept extends Model
{
  //获取质量验收列表
  public static function goodsAllCheckList($search)
  {
    $where = CommonFun::ProcessingData($search['search']);
    $map = array();
    if (!empty($where['start_date']) && !empty($where['end_date'])) {
      $map[] = ['g.delivery_date', 'between', [$where['start_date'], $where['end_date']]];
    }
    if (!empty($where['start_date']) && empty($where['end_date'])) {
      $map[] = ['g.delivery_date', '>', $where['start_date']];
    }
    if (empty($where['start_date']) && !empty($where['end_date'])) {
      $map[] = ['g.delivery_date', '<', $where['end_date']];
    }
    if (!empty($where['goods_code'])) {
      $oid = Db::name('goods_check_accept_details')->where('goods_code', '=', $where['goods_code'])->column('a_orderid');
      if ($oid) $map[] = ['g.orderid', 'in', implode(',', $oid)];
    }
    if (!empty($where['supplier_code'])) $map[] = ['g.supplier_code', '=', $where['supplier_code']];
    if (!empty($where['orderid'])) $map[] = ['g.orderid', '=', $where['orderid']];
    if (!empty($where['come_orderid'])) $map[] = ['g.come_orderid', '=', $where['come_orderid']];
    if (!empty($where['checker_code'])) $map[] = ['g.checker_code', '=', $where['checker_code']];
    if (!empty($where['create_code'])) $map[] = ['g.create_code', '=', $where['create_code']];
    if (isset($where['gsp_type']) && !empty($where['gsp_type'])) $map[] = ['g.gsp_type', '=', $where['gsp_type']];
    if (isset($where['status']) && !empty($where['status'])) $map[] = ['g.status', '=', $where['status']];
    if (!empty($where['remark'])) $map[] = ['g.remark', '=', $where['remark']];
    if (!empty($where['check_type'])) $map[] = ['g.check_type', '=', $where['check_type']];

    $res = self::where($map)->alias('g')
      ->field('g.*,p.full_name as supplier_name,p.subject_dept as supplier_depart,c.sname as cust_name')
      ->join('providers p', 'p.supplier_code=g.supplier_code', 'left')
      ->join('customer c', 'c.id=g.supplier_code', 'left')
      ->order('g.delivery_date,g.gsp_type')
      ->paginate(['page' => $search['page'], 'list_rows' => $search['pageSize']])
      ->toArray();
    return ['status' => 1, 'data' => $res];
  }

  //获取质量验收明细
  public static function getDetails($data)
  {
    $result = ['status'=>0,'msg'=>'查询失败！该单据已经被删除。'];
    $bill = null;
    $where[] = ['a.gsp_type', '=', $data['type']];
    $where[] = ['a.orderid', '=', $data['orderid']];
    $field = 'a.*,p.full_name as supplier_name,p.subject_dept as supplier_depart,c.name as cust_name,c.depart as cust_depart,sum(d.money) as money';
    $form = Db::name('goods_check_accept')->alias('a')
      ->field($field)
      ->join('goods_check_accept_details d','d.a_orderid=a.orderid','left')
      ->join('providers p','p.supplier_code=a.supplier_code','left')
      ->join('customer c','c.id=a.supplier_code','left')
      ->where($where)
      ->group('a.orderid')
      ->find();
    if ($form) $bill = Db::name('purchase_register_bill')->where('orderid', $form['come_orderid'])->find();
    $field2 = 'g.*,c.name,c.specs,c.dosage,c.origin,c.production,c.approval_code,c.packspecs,c.code,c.file_name,e.brand,e.license_key';
    $details = Db::name('goods_check_accept_details')->alias('g')
      ->field($field2)
      ->join('commodity c', 'c.goods_code=g.goods_code', 'left')
      ->join('commodity_extend e', 'e.goods_code=g.goods_code', 'left')
      ->where('g.a_orderid',$data['orderid'])
      ->select();
    if ($form){
      $result = ['status'=>1,'form'=>$form,'details'=>$details,'bill'=>$bill];
    }
    _end:
    return $result;
  }

  //保存质量验收单
  public static function edit($data, $user)
  {
    $result = ['status' => 0, 'msg' => '保存失败！'];
    $formData = CommonFun::ProcessingData($data['formData']);
    $has = GoodsCheckAccept::where('orderid', $formData['orderid'])->field('status')->find();
    if ($has) $has = $has->toArray();
    if ($has['status'] != 0) {
      $result['msg'] = '操作失败！当前验收单已经审核。';
      goto _end;
    }
    $dateTime = date("Y-m-d H:i:s");
    $acceptCon['orderid'] = $formData['orderid'];
    $acceptCon['delivery_date'] = $formData['delivery_date'];
    $acceptCon['accept_date']   = $formData['accept_date'];
    $acceptCon['come_orderid']  = $formData['come_orderid'];
    $acceptCon['supplier_code'] = $formData['supplier_code'];
    $acceptCon['create_code']   = $formData['orderid'] ? $formData['create_code'] : $user;
    $acceptCon['create_date']   = $formData['orderid'] ? $formData['create_date'] : $dateTime;
    $acceptCon['update_code']   = $formData['orderid'] ? $user : null;
    $acceptCon['update_date']   = $formData['orderid'] ? $dateTime : null;
    $acceptCon['accept_code']   = $formData['accept_code'];
    $acceptCon['checker2']      = $formData['checker2'];
    $acceptCon['remark']        = substr($formData['remark'], 0, 100);
    $acceptDtl = [];
    if (!empty($data['dtlData'])) {
      $validate = new GoodsCheckAcceptDtlVal();
      foreach ($data['dtlData'] as $k => &$v) {
        $v = CommonFun::ProcessingData($v);
        $checker = $validate->scene('all')->check($v);
        if (!$checker) {
          $result['msg'] = $v['goods_code'] . $validate->getError();
          goto _end;
        }
        $acceptDtl[$k] = [];
        $acceptDtl[$k]['a_orderid'] = $v['a_orderid'];
        $acceptDtl[$k]['item_no']   = $v['item_no'];
        $acceptDtl[$k]['goods_code']= $v['goods_code'];
        $acceptDtl[$k]['unit']      = $v['unit'];
        $acceptDtl[$k]['amount']    = $v['amount'];
        $acceptDtl[$k]['qualified_amount'] = $v['qualified_amount'];
        $acceptDtl[$k]['rejection_amount'] = $v['rejection_amount'];
        $acceptDtl[$k]['spot_check_amount']= $v['spot_check_amount'];
        $acceptDtl[$k]['price'] = $v['price'];
        $acceptDtl[$k]['money'] = $v['money'];
        $acceptDtl[$k]['batch'] = $v['batch'];
        $acceptDtl[$k]['sterilization_batch'] = $v['sterilization_batch'];
        $acceptDtl[$k]['production_date']     = $v['production_date'];
        $acceptDtl[$k]['production_end_date'] = $v['production_end_date'];
        $acceptDtl[$k]['verify_report']       = $v['verify_report'];
        $acceptDtl[$k]['pass_gate_no']        = $v['pass_gate_no'];
        $acceptDtl[$k]['quality_state']       = $v['quality_state'];
        $acceptDtl[$k]['package_state']       = $v['package_state'];
        $acceptDtl[$k]['label_state']         = $v['label_state'];
        $acceptDtl[$k]['directions']          = $v['directions'];
        $acceptDtl[$k]['check_verdict']       = $v['check_verdict'];
        $acceptDtl[$k]['checker']             = $v['checker'];
        $acceptDtl[$k]['accepter']            = $v['accepter'];
        $acceptDtl[$k]['remark']              = $v['remark'];
        $acceptDtl[$k]['come_orderid']        = $v['come_orderid'];
        $acceptDtl[$k]['p_item_no']           = $v['p_item_no'];
        $acceptDtl[$k]['rejection_type']      = $v['rejection_type'];
        $acceptDtl[$k]['return_reason']       = $v['return_reason'];
        $acceptDtl[$k]['storage_type']        = $v['storage_type'];
        $acceptDtl[$k]['traceability_code']   = $v['traceability_code'];
        $acceptDtl[$k]['goods_state']         = $v['goods_state'];
        $acceptDtl[$k]['certificato']         = $v['certificato'];
        $acceptDtl[$k]['register_card_no']    = $v['register_card_no'];
        $acceptDtl[$k]['entry_certificate']   = isset($v['entry_certificate']) ? $v['entry_certificate'] : null;
      }
    }
    Db::startTrans();
    if ($has) {
      //修改
      $res = GoodsCheckAccept::where('orderid', $formData['orderid'])->update($acceptCon);
      $dtl = Db::name('goods_check_accept_details')->where('a_orderid', $formData['orderid'])->select();
      if ($dtl) {
        $res2 = Db::name('goods_check_accept_details')->where('a_orderid', $formData['orderid'])->deleteInsertAll($acceptDtl);
      } else {
        $res2 = Db::name('goods_check_accept_details')->insertAll($acceptDtl);
      }
      if ($res && $res2) {
        Db::commit();
        $result = ['status' => 1, 'msg' => '修改成功！'];
      } else {
        Db::rollback();
        $result = ['status' => 0, 'msg' => '修改失败！'];
      }
    } else {
      //新增
      $res = GoodsCheckAccept::insert($acceptCon);
      if (!empty($acceptDtl)) {
        $res2 = Db::name('goods_check_accept_details')->insertAll($acceptDtl);
        if (!$res2) {
          Db::rollback();
          goto _end;
        }
      }
      if ($res) {
        Db::commit();
        $result = ['status' => 1, 'msg' => '保存成功！'];
      } else {
        Db::rollback();
      }
    }
    _end:
    return $result;
  }

  /** 审核质量验收单 *
   * @param $data Array $data['orderid']质量验收单据号 $data['type'] GSP验收类型
   * @param $user string 当前登陆用户code
   * @param $depart string 当前登陆用户所属部门id
   **/
  public static function check($data, $user, $depart)
  {
    $result = ['status' => 0, 'msg' => '审核失败！'];
    $has_state = self::where('orderid', $data['orderid'])->field('come_orderid,check_type,status,accept_code')->find();
    if ($has_state) $has_state = $has_state->toArray();
    if ($has_state['status'] != 0) {
      $result['msg'] = '操作失败！该单据已经审核成功。';
      goto _end;
    }
    if (empty($has_state['accept_code'])) {
      $result['msg'] = '请选择验收员！';
      goto _end;
    }
    $dateils = Db::name('goods_check_accept_details')->where('a_orderid', $data['orderid'])->select()->toArray();
    foreach($dateils as $key=>$val){
      if ($val['spot_check_amount'] <= 0) {
        $result['msg'] = '质量验收明细商品编号【' . $val['goods_code'] . '】未填写抽样数量！';goto _end;
      }
      if ($val['spot_check_amount'] > $val['qualified_amount']) {
        $result['msg'] = '抽样数量不能超过实收数量！';goto _end;
      }
      if (empty($val['check_verdict'])){
        $result['msg'] = '请填写验收结论！';goto _end;
      }
    }
    Db::startTrans();
    $updata = ['status' => 1, 'checker_code' => $user, 'checker_date' => date("Y-m-d H:i:s")];
    //审核当前单据
    $check = self::where('orderid',$data['orderid'])->update($updata);
    if(!$check){
      Db::rollback();goto _end;
    }
    $state = Db::name('goods_check_accept')->where('come_orderid', $has_state['come_orderid'])->column('orderid', 'status');
    //判断同一来货登记单是否还有其他未审核的质量验收单
    if(array_key_exists('0',$state)){
      //还有未审核的质量验收单
      $mup[] = ['come_orderid', '=', $has_state['come_orderid']];
      $mup[] = ['orderid', '<>', $data['orderid']];
      $re_orderid = GoodsCheckAccept::where($mup)->order('status asc')->field('orderid,gsp_type')->find()->toArray();
      $result = ['status' => 1, 'orderid' => $re_orderid['orderid'], 'gsp_type' => $re_orderid['gsp_type']];
      Db::commit();goto _end;
    }else{
      /***
       * 同一来货登记单的质量验收单已全部审核完毕
       * 根据有无不合格数量生成 【采购/销退拒收单】
       * 生成【采购/销退入库通知单】
       **/
      if ($has_state['check_type'] == 8) {
        /** check_type==8 销退登记->销退质量验收->销退入库通知单 **/
        $checkCon = SelRetCheck::where('orderid', $has_state['come_orderid'])->field('orderid,contract_no,emp_no,cust_no,pay_mode_no,fungible,linkman,linkman2')->find();
        if ($checkCon) $checkCon = $checkCon->toArray();
        $field2 = 'd.come_orderid,d.a_orderid,d.goods_code,d.unit,d.amount,d.qualified_amount,d.rejection_amount,d.batch,d.production_date,d.production_end_date,d.traceability_code,d.sterilization_batch,d.return_reason,re.qty,re.rebate,re.price,re.tax,re.not_tax_price,re.gift_qty,re.goods_state,re.quality_state,re.cust_goods_code,re.goods_state,re.quality_state';
        $joinWr = 're.item_no=d.p_item_no and re.goods_code=d.goods_code and re.orderid=d.come_orderid';
        $checkDtl = Db::name('goods_check_accept_details')->alias('d')->field($field2)
          ->join('sel_ret_check_dtl re', $joinWr)
          ->where('d.come_orderid', $has_state['come_orderid'])
          ->select()
          ->toArray();
      } elseif ($has_state['check_type'] == 1) {
        /** check_type==1 采购登记->采购质量验收->入库通知单 **/
        $where[] = ['a.gsp_type', '=', $data['type']];
        $where[] = ['a.orderid', '=', $data['orderid']];
        $field1 = 'a.come_orderid,a.a_orderid,a.goods_code,a.unit,a.gift_qty,a.batch,a.production_date,a.production_end_date,a.supplier_sale_orderid,a.supplier_goods_code,a.traceability_code,a.sterilization_batch,a.return_reason,a.product_status,a.quality_status,p.recipient_status,p.supplier_sale,p.supplier_contact,p.supplier_depart,pr.business_leader,pr.pay_mode_no';
        $checkCon = self::alias('a')->field($field1)
          ->join('purchase_register p', 'p.supplier_code=a.supplier_code', 'left')
          ->join('providers pr', 'p.supplier_code=a.supplier_code', 'left')
          ->where($where)
          ->find()
          ->toArray();
        $field2 = 'ac.*,re.gift_amount,re.tax,re.price as not_tax_price,re.product_status,re.quality_status,re.supplier_sale_orderid,re.supplier_goods_code';
        $joinWr = 're.item_no=ac.item_no and re.goods_code=ac.goods_code and re.r_orderid=ac.come_orderid';
        $checkDtl = Db::name('goods_check_accept_details')->alias('ac')->field($field2)
          ->join('purchase_register_details re', $joinWr)
          ->where('ac.come_orderid', $checkCon['come_orderid'])
          ->select()
          ->toArray();
      }

      $dateTime = date("Y-m-d H:i:s");
      //商品入库通知单
      $stockOrderid = CommonFun::createOrder('IS');
      $stockCon['orderid'] = $stockOrderid;
      $stockCon['reforderid'] = $checkCon['orderid'];
      $stockCon['sup_code']   = $checkCon['cust_no'];
      $stockCon['order_date'] = $dateTime;
      $stockCon['sup_sell']   = $checkCon['linkman'];
      $stockCon['sup_contact']= $checkCon['linkman2'];
      $stockCon['sales_code'] = $checkCon['emp_no'];
      $stockCon['paymode'] = $checkCon['pay_mode_no'];
      $stockCon['fungible']= $checkCon['fungible'];
      $stockCon['pay_date']= $dateTime;
      $stockCon['goodsqty']= 0;
      $stockCon['goodssum']= 0;
      $stockCon['taxsum']  = 0;
      $stockCon['amount']  = 0;
      $stockCon['remark']  = $has_state['check_type'] == 1 ? '该订单由来货验收后转单通知入库复核' : '该订单由销退验收后转单通知入库复核';
      $stockCon['dept_id'] = $depart;
      $stockCon['creator'] = $user;
      $stockCon['create_date'] = $dateTime;
      $stockCon['updator']     = $user;
      $stockCon['update_date'] = $dateTime;
      $stockCon['o_type'] = $has_state['check_type'];
      $rejection = [];//拒收单
      $rejectionDtl = [];//拒收单明细
      if (!empty($checkDtl)) {
        foreach ($checkDtl as $k => $v) {
          $stockDtl[$k] = [];
          $date = date("Y-m-d H:i:s");
          if ($v['rejection_amount'] > 0) {
            if (!isset($rejection['orderid'])) {
              $rejectionOrderid = CommonFun::createOrder("LJ");
              $rejection['orderid'] = $rejectionOrderid;
              $rejection['orderid_date']  = $date;
              $rejection['depart_id']     = $depart;
              $rejection['supplier_code'] = $checkCon['cust_no'];
              $rejection['supplier_sale'] = $checkCon['linkman'];
              $rejection['supplier_contact'] = $checkCon['linkman2'];
              $rejection['come_orderid']= $v['come_orderid'];
              $rejection['salesman']    = $checkCon['emp_no'];
              $rejection['create_code'] = $user;
              $rejection['create_date'] = $date;
              $rejection['remark']      = '质量验收时直接拒收';
            }
            $rejectionDtl[$k] = [];
            $rejectionDtl[$k]['r_orderid']  = $rejectionOrderid;
            $rejectionDtl[$k]['goods_code'] = $v['goods_code'];
            $rejectionDtl[$k]['unit'] = $v['unit'];
            $rejectionDtl[$k]['come_amount'] = $v['amount'];
            $rejectionDtl[$k]['rejection_amount'] = $v['rejection_amount'];
            $rejectionDtl[$k]['rejection_remark'] = '不合格';
            $rejectionDtl[$k]['money'] = calc([$v['qualified_amount'], '*', $v['price']], 6);
            $rejectionDtl[$k]['batch'] = $v['batch'];
            $rejectionDtl[$k]['production_end_date'] = $v['production_end_date'];
          }
          $qty = calc([$v['qty'],'-',$v['rejection_amount']],5);
          $tax = $v['tax'] > 0 ? calc([$v['tax'], '/', 100], 2) + 1 : 1;
          $money    = calc([$qty, '*', $v['price']], 6);
          $goodsSum = calc([$qty, '*', $v['not_tax_price']], 6);
          $taxsum   = calc([$money, '-', $goodsSum], 6);
          //入库通知单明细
          $stockDtl[$k]['item_no'] = $k + 1;
          $stockDtl[$k]['orderid'] = $stockOrderid;
          $stockDtl[$k]['reforderid'] = $v['come_orderid'];
          $stockDtl[$k]['in_orderid'] = $v['a_orderid'];
          $stockDtl[$k]['goods_code'] = $v['goods_code'];
          $stockDtl[$k]['unit']       = $v['unit'];
          $stockDtl[$k]['giftqty']    = $v['gift_qty'];
          $stockDtl[$k]['qty']        = $qty;
          $stockDtl[$k]['price']      = $v['price'];
          $stockDtl[$k]['taxrate']    = $v['tax'];
          $stockDtl[$k]['notax_price']= $v['not_tax_price'];
          $stockDtl[$k]['goodssum']   = $goodsSum;
          $stockDtl[$k]['amount']     = $money;
          $stockDtl[$k]['taxsum']     = $taxsum;
          $stockDtl[$k]['batchno']    = $v['batch'];
          $stockDtl[$k]['prod_date']  = $v['production_date'];
          $stockDtl[$k]['valid_date'] = $v['production_end_date'];
          $stockDtl[$k]['traceback_no']  = $v['traceability_code'];
          $stockDtl[$k]['germicidal_no'] = $v['sterilization_batch'];
          $stockDtl[$k]['return_reason'] = $v['return_reason'];
          $stockDtl[$k]['goods_state']   = $v['goods_state'];
          $stockDtl[$k]['quality_state'] = $v['quality_state'];
          //计算订单总数量-货款-税款-合计
          $stockCon['goodsqty'] = calc([$stockCon['goodsqty'], '+', $qty], 5);
          $stockCon['goodssum'] = calc([$stockCon['goodssum'], '+', $goodsSum], 6);
          $stockCon['taxsum'] = calc([$stockCon['taxsum'], '+', $taxsum], 6);
          $stockCon['amount'] = calc([$stockCon['amount'], '+', $money], 6);
        }
        if (!empty($rejection) && !empty($rejectionDtl)){
          $reState1 = Db::name('goods_rejection')->insert($rejection);//来货拒收单
          $reState2 = Db::name('goods_rejection_details')->insertAll($rejectionDtl);//来货拒收单明细
          if (!$reState1 || !$reState2) {
            Db::rollback();
            $result['msg'] = '新增来货拒收单失败！';goto _end;
          }
        }
        $res1 = Db::name('stock_receive')->insert($stockCon);
        $res2 = Db::name('stock_receive_details')->insertAll($stockDtl);
        if ($res1 && $res2) {
          Db::commit();
          $msg = '<p>'.$data['orderid'].'号质量验收单成功验收完毕，已生成了:</p>'.'<p>'.$stockOrderid.'入库通知单</p>';
          $msg .= isset($rejection['orderid'])?'<p>'.$rejection['orderid'].'销退拒收单</p>':'';
          $msg .= '<p>要查看这些单据吗?</p>';
          $result = ['status'=>2,'orderid'=>$stockOrderid,'re_orderid'=>isset($rejection['orderid'])?$rejection['orderid']:'','msg'=>$msg];
        } else {
          Db::rollback();
        }
      }
    }
    _end:
    return $result;
  }

  /** 删除质量验收单 **/
  public static function del($search)
  {
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $status = self::where('orderid',$search['orderid'])->value('status');
    if($status!=0){
      $result['msg'] = '删除失败！该单据已经审核通过，不能删除。';goto _end;
    }
    Db::startTrans();
    $res1 = self::where('orderid',$search['orderid'])->delete();
    $res2 = Db::name('goods_check_accept_details')->where('a_orderid',$search['orderid'])->delete();
    if ($res1 && $res2){
      Db::commit();
      $where[] = ['orderid','<>',$search['orderid']];
      $where[] = ['gsp_type','=',$search['type']];
      $orderid = self::where($where)->order('delivery_date')->value('orderid');
      $result = ['status'=>1,'msg'=>'删除成功！','orderid'=>$orderid];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }

  /** 还原质量验收单 **/
  public static function reduction($search,$user)
  {
    $result = ['status'=>0,'msg'=>'还原失败！'];
    $status = self::where('orderid',$search['orderid'])->field('come_orderid,status')->find();
    if (!$status){
      $result['msg'] = '还原失败！该单据不存在！';goto _end;
    }
    if ($status) $status=$status->toArray();
    if ($status['status']!=1){
      $result['msg'] = '还原失败！当前单据未审核。';goto _end;
    }
    $stockCon = StockReceive::where('reforderid',$status['come_orderid'])->find();
    if($stockCon){
      $result['msg'] = '质量验收单已经生成入库通知单！不能进行还原。';goto _end;
    }
    $rejection = GoodsRejection::where('come_orderid',$status['come_orderid'])->find();
    if ($rejection){
      $result['msg'] = '质量验收单已经生成来货拒收单！不能进行还原。';goto _end;
    }
    $res = self::where('orderid',$search['orderid'])->update(['update_code'=>$user,'update_date'=>date("Y-m-d H:i:s"),'status'=>0]);
    if ($res){
      $result = ['status'=>1,'msg'=>'还原成功！'];
    }
    _end:
    return $result;
  }

}
