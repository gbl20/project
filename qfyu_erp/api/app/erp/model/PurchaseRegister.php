<?php
namespace app\erp\model;
use app\helper\CommonFun;
use app\erp\validate\PurchaseRegisterVal;
use think\facade\Db;
use think\Model;

class PurchaseRegister extends Model
{
  //来货登记列表
  public static function list($search)
  {
    $where = [];
    $data = PurchaseRegister::where($where)->alias("r")
      ->field('r.*,p.full_name as supplier_name,s.name as pay_name')
      ->join('providers p', 'p.supplier_code=r.supplier_code', 'left')
      ->join('settlement s', 's.id=r.pay_type', 'left')
      ->order('r.creation_date','desc')
      ->paginate(['page' => $search['page'], 'list_rows' => $search['page_size']]);
    return $data;
  }

  /**
   * 来货登记详情页
   **/
  public static function details($orderid)
  {
    $data = PurchaseRegister::where('orderid', $orderid)->alias('r')
      ->field('r.*,p.full_name as supplier_name')
      ->join('providers p', 'p.supplier_code=r.supplier_code', 'left')
      ->find();
    if ($data) $data = $data->toArray();
    $field = 'd.*,c.name,c.en_name,c.code,c.file_name,c.dosage,c.unit,c.unit2,c.unit as unit3,c.specs,c.origin,c.remark,c.production,w.storage_type,p.price1 as near_price,pr.price1 as low_price,pc.price1 as high_price';
    $details = Db::name('purchase_register_details')->alias('d')->field($field)
      ->join('commodity c', 'c.goods_code=d.goods_code', 'left')
      ->join('commodity_warehouse w', 'w.goods_code=d.goods_code', 'left')
      ->join('commodity_price p', 'p.goods_code=d.goods_code and p.mode_id=8', 'left')
      ->join('commodity_price pr', 'pr.goods_code=d.goods_code and pr.mode_id=4', 'left')
      ->join('commodity_price pc', 'pc.goods_code=d.goods_code and pc.mode_id=5', 'left')
      ->where('d.r_orderid', $orderid)
      ->select();
    $bill = PurchaseRegisterBill::getBillDet($orderid);
    return ['form' => $data, 'data' => $details, 'bill' => $bill];
  }

  /**
   * 新增-编辑来货登记
   **/
  public static function edit($data, $data2, $creator_code)
  {
    $result = ['status' => 0, 'msg' => '保存失败!'];
    $data = CommonFun::ProcessingData($data, ['hours', 'total_amount', 'total_money', 'taxes', 'total_payprice']);
    $validate = new PurchaseRegisterVal();
    $checker = $validate->scene('all')->check($data);
    if (!$checker) {
      $result['msg'] = $validate->getError();
      goto _end;
    }
    $has_pay = Providers::checkProv(['sup_code' => $data['supplier_code'], 'type' => 'provsales']);
    if ($has_pay['status']) {
      if ($has_pay['leader']['business_leader'] !== $data['salesman']) {
        $result = ['status' => 2, 'msg' => '该供应商已经设置默认业务负责人！', 'salesman' => $has_pay['leader']['business_leader'], 'salesman_name' => $has_pay['leader']['business_leader_name']];
        goto _end;
      }
    }
    if (empty($data['orderid'])) $data['orderid'] = CommonFun::createOrder('PC');
    if (empty($data['receiving_date'])) $data['receiving_date'] = date("Y-m-d H:i:s");
    unset($data['receiving_time']);
    unset($data['ware_name']);
    unset($data['supplier_name']);
    unset($data['salesman_name']);
    unset($data['cnee_code1_name']);
    unset($data['cnee_code2_name']);
    $data['total_amount']   = 0;
    $data['total_money']    = 0;
    $data['taxes']          = 0;
    $data['total_payprice'] = 0;
    $has_orderid = PurchaseRegister::where('orderid', $data['orderid'])->field('orderid,status')->find();
    if ($has_orderid['status'] == 1) {
      $result['msg'] = '操作失败！单据已经审核。';
      goto _end;
    }
    $total_amount=0;
    $total_money=0;
    $taxes=0;
    $total_payprice=0;
    $details = [];
    if(!empty($data2)) {
      foreach ($data2 as $k => &$v) {
        $v = CommonFun::ProcessingData($v);
        $sql['item_no']           = $k+1;
        $sql['r_orderid']         = $data['orderid'];
        $sql['goods_code']        = $v['goods_code'];
        $sql['unit']              = $v['unit'];
        $sql['order_amount']      = $v['order_amount'];
        $sql['come_amount']       = $v['come_amount'];
        $sql['gift_amount']       = $v['gift_amount'];
        $sql['rejection_amount']  = $v['rejection_amount'];
        $sql['rejection_remark']  = $v['rejection_remark'];
        $sql['discount']          = $v['discount'];
        $sql['order_no']          = $v['order_no'];
        $sql['tax'] = $v['tax'];
        $discount   = $sql['discount']>0?calc([$sql['discount'],'/',100],2):1;
        $tax        = $sql['tax']>0?calc([$sql['tax'],'/',100],2)+1:1;
        $price      = calc([$v['price1'],'*',$discount],6);
        $not_tax_price = calc([$price,'/',$tax],6);
        $not_tax_money = calc([$not_tax_price,'*',$v['receipts_amout']],6);
        $total_price   = calc([$v['receipts_amout'],'*',$price],6);
        $tax_total     = calc([$total_price,'-',$not_tax_money],6);
        $sql['not_tax_price']         = $not_tax_price;
        $sql['not_tax_money']         = $not_tax_money;
        $sql['tax_total']             = $tax_total;
        $sql['total_price']           = $total_price;
        $sql['gross_profit']          = $v['gross_profit'];
        $sql['qualified_amout']       = $v['qualified_amout'];
        $sql['supplier_no']           = $v['supplier_no'];
        $sql['supplier_goods_code']   = $v['supplier_goods_code'];
        $sql['supplier_orderid']      = $v['supplier_orderid'];
        $sql['supplier_sale_orderid'] = $v['supplier_sale_orderid'];
        $sql['receipts_amout']        = $v['receipts_amout'];
        $sql['price1']                = $v['price1'];
        $sql['price']                 = $v['price'];
        $sql['batch']                 = $v['batch'];
        $sql['production_date']       = $v['production_date'] ? $v['production_date'] : null;
        $sql['production_end_date']   = $v['production_end_date'] ? $v['production_end_date'] : null;
        $sql['pifaml']                = $v['pifaml'];
        $sql['retail']                = $v['retail'];
        $sql['new_whole']             = $v['new_whole'];
        $sql['new_retail']            = $v['new_retail'];
        $sql['traceability_code']     = $v['traceability_code'];
        $sql['sterilization_batch']   = $v['sterilization_batch'];
        $sql['production_code']       = $v['production_code'];
        $sql['product_status']        = isset($v['product_status']) ? $v['product_status'] : null;
        $sql['quality_status']        = isset($v['quality_status']) ? $v['quality_status'] : null;
        $sql['del_remark']            = $v['del_remark'];
        $data['total_amount']         = calc([$data['total_amount'],'+',$v['receipts_amout']],6);
        $data['total_money']          = calc([$data['total_money'],'+',$not_tax_money],6);
        $data['taxes']                = calc([$data['taxes'],'+',$tax_total],6);
        $data['total_payprice']       = calc([$data['total_payprice'],'+',$total_price],6);
        array_push($details, $sql);
      }
    }
    // 启动事务
    Db::startTrans();
    if (!$has_orderid) {// 新增
      $data['creator_code'] = $creator_code;
      $data['creation_date'] = date("Y-m-d H:i:s");
      $res1 = PurchaseRegister::insert($data);
      if(!empty($details)) {
        $res2 = Db::name('purchase_register_details')->insertAll($details);
        if (!$res2) {
          Db::rollback();goto _end;
        }
      }
      if ($res1) {
        Db::commit();
        $result = ['status' => 1, 'msg' => '保存成功!', 'orderid' => $data['orderid']];
      } else {
        Db::rollback();
      }
    } else {//修改
      $data['checker_code'] = $creator_code;
      $data['checker_date'] = date("Y-m-d H:i:s");
      $res = PurchaseRegister::where('orderid', $data['orderid'])->update($data);
      $has_details = Db::name('purchase_register_details')->where('r_orderid', $data['orderid'])->find();
      if($has_details){
        if(!empty($details)) {
          $res2 = Db::name('purchase_register_details')->where('r_orderid',$data['orderid'])->deleteInsertAll($details);
        }else{
          $res2 = Db::name('purchase_register_details')->where('r_orderid', $data['orderid'])->delete();
        }
        if(!$res2) {
          Db::rollback();
          $result['msg'] = '修改失败!';goto _end;
        }
      }else{
        $res2 = Db::name('purchase_register_details')->insertAll($details);
      }
      if($res && $res2) {
        Db::commit();
        $result = ['status' =>1,'msg'=>'修改成功!','orderid'=>$data['orderid']];
      }else{
        Db::rollback();
        $result['msg'] = '修改失败!';
      }
    }
    _end:
    return $result;
  }

  /**
   * 审核来货登记单
   * @param $orderid string 来货登记单据号
   * @param $process string 审核流程 1是一步操作完成采购 2是走完整流程
   * @param $ware_type string 收货仓匹配方式 1仅自动匹配 2先自动匹配,然后匹配指定仓库 3直接指定收货仓库
   * @param $ware_id string 收货仓id
   * @param $checker_status string 是否自动审核入库单 true是 false否
   * @param $user string 当前登陆用户
   * @param $depart string 当前登陆用户所属部门
   **/
  public static function checkOrder($data,$user,$depart)
  {
    $result  = ['status' => 0, 'msg' => '审核失败！'];
    $orderid = $data['orderid'];
    $process = $data['process'];
    $ware_type = $data['ware_type'];
    $ware_id   = $data['ware_id'];
    $checker_status = $data['checker_status'];
    if($process == 1){//一步完成采购
      $result['msg']='功能正在开发中！';goto _end;
    }elseif($process == 2){//走完整流程
      //判断单据状态是否已审核
      $field = 'r.orderid,r.supplier_code,r.supplier_sale,r.supplier_contact,r.supplier_depart,r.salesman,r.cnee_code2,r.status,p.address,p.tel';
      $registerCon = PurchaseRegister::where('orderid',$orderid)->alias('r')
                    ->join('providers p','p.supplier_code=r.supplier_code','left')
                    ->field($field)
                    ->find();
      if($registerCon) $registerCon = $registerCon->toArray();
      if($registerCon['status']!=0) {
        $result['msg'] = '审核失败！当前单据已经审核通过。';goto _end;
      }
      $details = Db::name('purchase_register_details')->alias('d')
                ->field('d.*,c.gsp_type,w.storage_type')
                ->join('commodity c','c.goods_code=d.goods_code','left')
                ->join('commodity_warehouse w','w.goods_code=d.goods_code','left')
                ->where('r_orderid', $orderid)
                ->select()
                ->toArray();
      if(!$details) {
        $result['msg'] = '第[ '.$orderid.' ]'.'号来货登记单缺少来货明细！';goto _end;
      }
      $YIds = [];//质量验收单单据号
      $checkCon = [];//质量验收单
      $checkDtl = [];//质量验收明细数据
      $reCon = [];//来货拒收单
      $reDtl = [];//来货拒收明细数据
      $coldOid = '';
      $coldCon = [];
      $coldDtl = [];
      $msg = '';
      $re_oid = '';//来货拒收单据号
      $check_default = Db::name('goods_check_default')->column('*','gsp_type');//质量验收默认设置数据
      foreach ($details as $k => $v) {
        if ($v['receipts_amout'] <= 0) {
          $result['msg'] = '来货明细商品['.$v['goods_code'].']实收数量不能为0';
          goto _end;
        }
        if ($v['order_amount'] < $v['receipts_amout']) {
          $result['msg'] = '来货明细商品['.$v['goods_code'].']实收数量不能大于订货数量！';
          goto _end;
        }
        if ($v['price'] <= 0) {
          $result['msg'] = '来货明细商品['.$v['goods_code'].']商品单价不能为0';
          goto _end;
        }
        if($v['gsp_type']==5 && !$registerCon['cnee_code2']){
          $result['msg']='第【'.$orderid.'】号来货登记单包含特殊药品，但未填写第二收货人，根据系统设置需要填写第二收货人才能审核！';
          goto _end;
        }
        $date     = date("Y-m-d");
        $dateTime = date("Y-m-d H:i:s");
        //如果拒收数量有值则需生成来货拒收单
        if(floatval($v['rejection_amount'])>0) {
          if(!isset($reCon['orderid'])){
            $re_oid = CommonFun::createOrder('LJ');
            $msg .= '<p>'.$re_oid.'来货拒收单</p>';
            $reCon['orderid']          = $re_oid;
            $reCon['orderid_date']     = $date;
            $reCon['depart_id']        = $depart;
            $reCon['supplier_code']    = $registerCon['supplier_code'];
            $reCon['supplier_depart']  = $registerCon['supplier_depart'];
            $reCon['supplier_sale']    = $registerCon['supplier_sale'];
            $reCon['supplier_contact'] = $registerCon['supplier_contact'];
            $reCon['salesman']         = $registerCon['salesman'];
            $reCon['come_orderid']     = $orderid;
            $reCon['create_code']      = $user;
            $reCon['create_date']      = $dateTime;
            $reCon['remark']           = '*来货登记时直接拒收*';
          }
          //来货拒收明细
          $re_dtl['r_orderid']   = $re_oid;
          $re_dtl['goods_code']  = $v['goods_code'];
          $re_dtl['unit']        = $v['unit'];
          $re_dtl['come_amount'] = $v['come_amount'];
          $re_dtl['rejection_amount'] = $v['rejection_amount'];
          $re_dtl['rejection_remark'] = $v['rejection_remark'];
          $re_dtl['money'] = calc([$v['price'], '*',$v['rejection_amount']], 6);
          $re_dtl['batch'] = $v['goods_code'];
          $re_dtl['check_amount'] = $v['come_amount'];
          $re_dtl['supplier_goods_code'] = $v['supplier_goods_code'];
          $re_dtl['production_end_date'] = $v['production_end_date'];
          array_push($reDtl,$re_dtl);
        }
        if(strpos($v['storage_type'],'冷藏储存')){
          if(!isset($coldCon['orderid'])){
            $coldOid = CommonFun::createOrder("CL");
            $msg .= '<p>'.$coldOid.'冷藏药品收货登记单</p>';
            $coldCon['orderid']   = $coldOid;
            $coldCon['f_date']    = $date;
            $coldCon['emp_no']    = $registerCon['salesman'];
            $coldCon['p_orderid'] = $orderid;
            $coldCon['creater']   = $user;
            $coldCon['creater_date'] = $dateTime;
            $coldCon['depart'] = $depart;
          }
          $coldDtl[$k] = [];
          $coldDtl[$k]['orderid']     = $coldOid;
          $coldDtl[$k]['item_no']     = $k+1;
          $coldDtl[$k]['prov_no']     = $registerCon['supplier_code'];
          $coldDtl[$k]['addr']        = $registerCon['address'];
          $coldDtl[$k]['link_tel']    = $registerCon['tel'];
          $coldDtl[$k]['emp_no']      = $registerCon['salesman'];
          $coldDtl[$k]['pay_mode_no'] = $registerCon['pay_mode_no'];
          $coldDtl[$k]['p_item_no']   = $v['item_no'];
          $coldDtl[$k]['goods_code']  = $v['goods_code'];
          $coldDtl[$k]['qty'] = calc([$v['receipts_amout'],'+',$v['gift_amount']],5);
          $coldDtl[$k]['batch_no']    = $v['batch'];
          $coldDtl[$k]['valid_date']  = $v['production_end_date'];
        }
        if(floatval($v['receipts_amout'])>0 || floatval($v['gift_amount'])>0){
          if(!isset($checkCon[$v['gsp_type']])){
            $YIds[$v['gsp_type']]   = CommonFun::createOrder('CY');
            $gspTypeMsg = self::getGspType($v['gsp_type']);
            $gspTypeMsg = '<p>'.$YIds[$v['gsp_type']].$gspTypeMsg.'</p>';
            $msg .=$gspTypeMsg;
            $checkCon[$v['gsp_type']]['orderid'] = $YIds[$v['gsp_type']];
            $checkCon[$v['gsp_type']]['delivery_date'] = $date;
            $checkCon[$v['gsp_type']]['accept_date']   = $date;
            $checkCon[$v['gsp_type']]['depart']        = $depart;
            $checkCon[$v['gsp_type']]['come_orderid']  = $orderid;
            $checkCon[$v['gsp_type']]['supplier_code'] = $registerCon['supplier_code'];
            $checkCon[$v['gsp_type']]['gsp_type']      = intval($v['gsp_type']);
            $checkCon[$v['gsp_type']]['create_code']   = $user;
            $checkCon[$v['gsp_type']]['create_date']   = $dateTime;
            $checkCon[$v['gsp_type']]['accept_code']   = $registerCon['salesman'];
          }
          //质量验收明细表
          $che_dtl['a_orderid']  = $YIds[$v['gsp_type']];
          $che_dtl['item_no']    = $k+1;
          $che_dtl['goods_code'] = $v['goods_code'];
          $che_dtl['unit']       = $v['unit'];
          $amount = calc([$v['receipts_amout'],'+',$v['gift_amount']],5);
          $che_dtl['amount']           = $amount;
          $che_dtl['qualified_amount'] = $amount;
          $che_dtl['price'] = $v['receipts_amout']?calc([$v['total_price'],'/',$amount],6):0;
          $che_dtl['money'] = $v['receipts_amout']?$v['total_price']:0;
          $che_dtl['production_date']     = $v['production_date'];
          $che_dtl['production_end_date'] = $v['production_end_date'];
          $che_dtl['batch']               = $v['batch']?$v['batch']:$check_default[$v['gsp_type']]['batch'];
          $che_dtl['sterilization_batch'] = $v['sterilization_batch']?$v['sterilization_batch']:$check_default[$v['gsp_type']]['sterilization_batch'];
          $che_dtl['verify_report']       = $check_default[$v['gsp_type']]['verify_report'];
          $che_dtl['pass_gate_no']        = $check_default[$v['gsp_type']]['pass_gate_no'];
          $che_dtl['quality_state']       = $check_default[$v['gsp_type']]['quality_state'];
          $che_dtl['package_state']       = $check_default[$v['gsp_type']]['package_state'];
          $che_dtl['label_state']         = $check_default[$v['gsp_type']]['label_state'];
          $che_dtl['directions']          = $check_default[$v['gsp_type']]['directions'];
          $che_dtl['check_verdict']       = $check_default[$v['gsp_type']]['check_verdict'];
          $che_dtl['checker']             = $check_default[$v['gsp_type']]['checker'];
          $che_dtl['accepter']            = $check_default[$v['gsp_type']]['accepter'];
          $che_dtl['certificato']         = $check_default[$v['gsp_type']]['certificato'];
          $che_dtl['register_card_no']    = $check_default[$v['gsp_type']]['register_card_no'];
          $che_dtl['come_orderid']        = $orderid;
          $che_dtl['p_item_no']           = $v['item_no'];
          $che_dtl['traceability_code']   = $v['traceability_code'];
          array_push($checkDtl,$che_dtl);
        }
      }
      Db::startTrans();
      if(!empty($checkCon)){
        $res1 = Db::name('goods_check_accept')->insertAll($checkCon);//生成质量验收单
        $res2 = Db::name('goods_check_accept_details')->insertAll($checkDtl);//生成质量验收明细
        if (!$res1 || !$res2){
          Db::rollback();
          $result['msg']='质量验收单新增失败！';goto _end;
        }
      }
      if(isset($reCon['orderid']) && !empty($reCon['orderid'])){
        $res3 = Db::name('goods_rejection')->insert($reCon);//来货拒收单
        $res4 = Db::name('goods_rejection_details')->insertAll($reDtl);//来货拒收单明细
        if(!$res3 || !$res4){
          Db::rollback();
          $result['msg']='来货拒收单新增失败！';goto _end;
        }
      }
      if(isset($coldCon['orderid']) && !empty($coldCon['orderid'])){
        $res5 = PurchaseColdStorage::insert($coldCon);
        $res6 = PurchaseColdStorageDtl::insertAll($coldDtl);
        if(!$res5 || !$res6){
          Db::rollback();
          $result['msg']='冷藏药品收货登记新增失败！';goto _end;
        }
      }
      $upsql['checker_code'] = $user;
      $upsql['checker_date'] = $dateTime;
      $upsql['status'] = 1;
      $upsql['order_status'] = 1;
      $next = PurchaseRegister::where('orderid',$orderid)->update($upsql);//审核来货登记单
      if($next){
        Db::commit();
        $result = ['status'=>1,'orderid'=>$orderid,'re_orderid'=>$re_oid,'cold_orderid'=>$coldOid,'msg'=>$msg];
      }else{
        Db::rollback();
      }
    }
    _end:
    return $result;
  }

  public static function getGspType($type)
  {
    $msg = '';
    switch ($type)
    {
      case 1:
        $msg = '普通药品验收单';
        break;
      case 2:
        $msg = '进口药品验收单';
        break;
      case 3:
        $msg = '医疗器械验收单';
        break;
      case 4:
        $msg = '中药饮片验收单';
        break;
      case 5:
        $msg = '特殊药品验收单';
        break;
      default:
        $msg = '非药品验收单';
    }
    return $msg;
  }

}
