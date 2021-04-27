<?php
namespace app\finance\model;
use app\erp\model\Customer;
use app\finance\validate\SelSettleVal;
use app\helper\CommonFun;
use think\Model;
use think\facade\Db;

Class SelSettle extends Model{
    public static function SelExportTransfer($selExport,$selExportDtl,$uCode,$deptId){
        $res = ['status'=>0,'msg'=>'提交失败'];
        $dateTime = date('Y-m-d H:i:s',time());
        $date = date('Y-m-d',time());
        $orderId = CommonFun::createOrder('XJ');
        $field = 'taxcode,accoutbank,bankid';
        $Customer = Customer::where('id','=',$selExport['cust_no'])->field($field)->find();
        $selSettle['orderid'] = $orderId;
        $selSettle['f_date'] = $date;
        $selSettle['in_out_kind'] = 51;
        $selSettle['cust_no'] = $selExport['cust_no'];
        $selSettle['account_bank'] = $Customer['accoutbank'];
        $selSettle['account_no'] = $Customer['bankid'];
        $selSettle['tax_no'] = $Customer['taxcode'];
        $selSettle['link_man'] = $selExport['link_man'];
        $selSettle['emp_no'] = $uCode;
        $selSettle['yw_dept_id'] = $deptId;
        $selSettle['goods_qty'] = $selExport['goods_qty'];
        $selSettle['goods_sum'] = $selExport['goods_sum'];
        $selSettle['tax_sum'] = $selExport['tax_sum'];
        $selSettle['amount'] = $selExport['amount'];
        $selSettle['pay_mode_no'] = $selExport['pay_mode_no'];
        $selSettle['pay_date'] = $selExport['pay_date'];
        $selSettle['remark'] = $selExport['remark'];
        $selSettle['creater'] = $uCode;
        $selSettle['creat_date'] = $dateTime;
        $selSettle['dept_id'] = $deptId;
        $selSettle['contacts'] = $selExport['contacts'];
        $selSettleDtl = [];
        foreach($selExportDtl as $k=>$v){
            $selSettleDtl[$k] = [];
            $settleDtl['orderid'] = $orderId;
            $settleDtl['item_no'] = $k+1;
            $settleDtl['goods_code'] = $v['goods_code'];
            $settleDtl['unit'] = $v['unit'];
            $settleDtl['batch_no'] = $v['batch_no'];
            $settleDtl['qty'] = $v['qty'];
            $settleDtl['price'] = $v['price'];
            $settleDtl['tax_rate'] = $v['tax_rate'];
            $settleDtl['un_tax_price'] = $v['un_tax_price'];
            $settleDtl['goods_sum'] = $v['goods_sum'];
            $settleDtl['tax_sum'] = $v['tax_sum'];
            $settleDtl['amount'] = $v['amount'];
            $settleDtl['ref_cost_price'] = $v['ref_cost_price'];
            $settleDtl['ref_cost'] = $v['ref_cost'];
            $settleDtl['p_order_no'] = $selExport['orderid'];
            $settleDtl['p_item_no'] = $v['item_no'];
            $selSettleDtl[$k] = $settleDtl;
        }
        $re1 = SelSettle::insert($selSettle);
        $re2 = SelSettleDtl::insertAll($selSettleDtl);
        if($re1 && $re2) $res = ['status'=>1];
        return $res;
    }

    //销售结算订单列表
    public static function list($data)
    {
      $search = CommonFun::ProcessingData($data['search']);
      $where = [];
      if(!empty($data['pageSize'])) $limit = $data['pageSize'];
      if(!empty($search['orderid']) && isset($search['orderid'])) {
        $where[] = ['s.orderid','=',$search['orderid']];
      }
      if(!empty($search['p_order_no']) && isset($search['p_order_no'])) {
        $where[] = ['d.p_order_no','=',$search['p_order_no']];
      }
      if(!empty($search['cust_no']) && isset($search['cust_no'])) {
        $where[] = ['s.cust_no','=',$search['cust_no']];
      }
      if(!empty($search['f_date']) && !empty($search['end_f_date'])) {
        $where[] = ['s.f_date','between',[$search['f_date'],$search['end_f_date']]];
      }
      if(!empty($search['f_date']) && empty($search['end_f_date'])) {
        $where[] = ['s.f_date','>',$search['f_date']];
      }
      if(empty($search['f_date']) && !empty($search['end_f_date'])) {
        $where[] = ['s.f_date','<',$search['end_f_date']];
      }
      if(!empty($search['pay_date']) && !empty($search['end_pay_date'])) {
        $where[] = ['s.pay_date','between',[$search['pay_date'],$search['end_pay_date']]];
      }
      if(!empty($search['pay_date']) && empty($search['end_pay_date'])) {
        $where[] = ['s.pay_date','>',$search['pay_date']];
      }
      if(empty($search['pay_date']) && !empty($search['end_pay_date'])) {
        $where[] = ['s.pay_date','<',$search['end_pay_date']];
      }
      if(!empty($search['invoice_date']) && !empty($search['end_invoice_date'])) {
        $where[] = ['s.invoice_date','between',[$search['invoice_date'],$search['end_invoice_date']]];
      }
      if(!empty($search['invoice_date']) && empty($search['end_invoice_date'])) {
        $where[] = ['s.invoice_date','>',$search['invoice_date']];
      }
      if(empty($search['invoice_date']) && !empty($search['end_invoice_date'])) {
        $where[] = ['s.invoice_date','<',$search['end_invoice_date']];
      }
      if(!empty($search['invoice_no']) && isset($search['invoice_no'])) {
        $where[] = ['s.invoice_no','=',$search['invoice_no']];
      }
      if(!empty($search['emp_no']) && isset($search['emp_no'])) {
        $where[] = ['s.emp_no','=',$search['emp_no']];
      }
      if(!empty($search['audit']) && isset($search['audit'])) {
        $where[] = ['s.audit','=',$search['audit']];
      }
      if(!empty($search['pay_mode_no']) && isset($search['pay_mode_no'])) {
        $where[] = ['s.pay_mode_no','=',$search['pay_mode_no']];
      }
      if(isset($search['is_transfer'])) {
        $where[] = ['s.is_transfer','=',$search['is_transfer']];
      }
      if(!empty($search['link_man']) && isset($search['link_man'])) {
        $where[] = ['s.link_man','=',$search['link_man']];
      }
      if(!empty($search['contacts']) && isset($search['contacts'])) {
        $where[] = ['s.contacts','=',$search['contacts']];
      }
      if(!empty($search['yw_dept_id']) && isset($search['yw_dept_id'])) {
        $where[] = ['s.yw_dept_id','=',$search['yw_dept_id']];
      }
      if(!empty($search['custlass']) && isset($search['custlass'])) {
        $where[] = ['c.custlass','=',$search['custlass']];
      }
      $custlass = Db::name('db_work')->where('field_name','custlass')->column('value','id');
      $field = 's.*,c.name as cust_name,c.parlevel,c.warehouse,c.depart as cust_depart,cu.name as parlevel_name,sum(d.ref_cost) as ref_cost,sum(d.paid_up) as paid_up,sum(d.amount-d.paid_up) as re_paid,d.pay_done_date,(s.goods_sum - d.ref_cost) as re_profit,round(((s.goods_sum-d.ref_cost) / s.goods_sum),2) as re_profit_val';
      $res = self::where($where)->alias('s')
          ->field($field)
          ->join('customer c','c.id=s.cust_no','left')
          ->join('customer cu','cu.id=c.parlevel','left')
          ->join('sel_settle_dtl d','d.orderid=s.orderid','left')
          ->group('s.orderid')
          ->paginate(['page'=>$data['page'],'list_rows'=>$limit])
          ->toArray();
      return ['status'=>1,'data'=>$res,'custlass'=>$custlass];
    }

    //查询销售结算明细
    public static function dtl($orderid)
    {
      $formData = self::where('s.orderid',$orderid)->alias('s')
                ->field('s.*,c.name as cust_name,c.depart as cust_depart')
                ->join('customer c','c.id=s.cust_no','left')
                ->find();
      if($formData) $formData = $formData->toArray();
      $dtlData  = SelSettleDtl::where('d.orderid',$orderid)->alias('d')
                ->field('d.*,c.name,c.specs,c.origin,c.production,c.dosage,c.approval_code,c.packspecs,e.price as sale_price')
                ->join('sel_export_dtl e','e.orderid=d.p_order_no and e.item_no=d.item_no and e.goods_code=d.goods_code')
                ->join('commodity c','c.goods_code=d.goods_code','left')
                ->select()
                ->toArray();
      return ['status'=>1,'formData'=>$formData,'data'=>$dtlData];
    }

    //保存销售结算数据
    public static function saveSelData($data,$user)
    {
      $result = ['status'=>0,'msg'=>'新增失败！'];
      $settle = CommonFun::ProcessingData($data['formData']);
      $valiDate = new SelSettleVal();
      $checker = $valiDate->scene('all')->check($settle);
      if($checker){
        $result['msg'] = $valiDate->getError();goto _end;
      }
      $status = self::where('orderid',$settle['orderid'])->field('is_transfer')->find();
      $settle['orderid'] = $status?$settle['orderid']:CommonFun::createOrder('XJ');
      if ($status) $status = $status->toArray();
      if($status['is_transfer']==1){
        $result['msg'] = '操作失败！该单据已经过账。';goto _end;
      }
      $goods_qty =0;
      $goods_sum =0;
      $tax_sum =0;
      $amount =0;
      unset($settle['cust_name']);
      unset($settle['cust_depart']);
      $sql = array();
      if(!empty($data['data'])){
        foreach ($data['data'] as $k=>$v){
          $dtl['orderid'] = $v['orderid'];
          $dtl['item_no'] = $v['item_no'];
          $dtl['goods_code']    = $v['goods_code'];
          $dtl['unit']          = $v['unit'];
          $dtl['batch_no']      = $v['batch_no'];
          $dtl['qty']           = $v['qty'];
          $dtl['price']         = $v['price'];
          $dtl['tax_rate']      = $v['tax_rate'];
          $qty = $v['qty'];
          $tax = $v['tax_rate']>0?calc([$v['tax_rate'],'/',100],2)+1:1;
          $dtl['un_tax_price']  = calc([$dtl['price'],'/',$tax],6);
          $money = calc([$dtl['qty'],'*',$dtl['price']],6);
          $dtl['goods_sum']     = calc([$dtl['un_tax_price'],'*',$dtl['qty']],6);
          $dtl['tax_sum']       = calc([$money,'-',$dtl['goods_sum']],6);
          $dtl['amount']        = $money;
          $dtl['ref_cost_price']= $v['ref_cost_price'];
          $dtl['ref_cost']      = $v['ref_cost'];
          $dtl['p_order_no']    = $v['p_order_no'];
          $dtl['p_item_no']     = $v['p_item_no'];
          $dtl['paid_up']       = $v['paid_up'];
          $dtl['pay_done']      = $v['pay_done'];
          $dtl['pay_done_date'] = $v['pay_done_date'];
          $dtl['remark']        = $v['remark'];
          $dtl['makeupfor_amount'] = $v['makeupfor_amount'];
          $dtl['makeupfor_price']  = $v['makeupfor_price'];
          $goods_qty = calc([$goods_qty,'+',$dtl['qty']],5);
          $goods_sum = calc([$goods_sum,'+',$dtl['goods_sum']],6);
          $tax_sum = calc([$tax_sum,'+',$dtl['tax_sum']],6);
          $amount = calc([$amount,'+',$dtl['amount']],6);
          array_push($sql,$dtl);
        }
      }
      $settle['goods_qty'] = $goods_qty;
      $settle['goods_sum'] = $goods_sum;
      $settle['tax_sum'] = $tax_sum;
      $settle['amount'] = $amount;
      Db::startTrans();
      if($status){
        $settle['mender'] = $user;
        $settle['update_date'] = date("Y-m-d H:i:s");
        $res = self::where('orderid',$settle['orderid'])->update($settle);
        $res1 = SelSettleDtl::where('orderid',$settle['orderid'])->deleteInsertAll($sql);
        if($res && $res1){
          Db::commit();$result = ['status'=>1,'msg'=>'修改成功！'];
        }else{
          Db::rollback();$result['msg'] = '修改失败！';
        }
      }else{
        $res  = self::insert($settle);
        $res1 = SelSettleDtl::insertAll($sql);
        if($res && $res1){
          Db::commit();$result = ['status'=>1,'msg'=>'新增成功！'];
        }else{
          Db::rollback();
        }
      }
      _end:
      return $result;
    }

    //审核销售结算
    public static function check($orderid,$user)
    {
      $result = ['status'=>0,'msg'=>'审核失败！'];
      $hasCheck = self::where('orderid',$orderid)->value('is_transfer');
      if ($hasCheck==1){
        $result['msg'] = '操作失败！当前销售结算已经审核通过。';goto _end;
      }
      $sql['audit'] = $user;
      $sql['is_transfer'] = 1;
      $res = self::where('orderid',$orderid)->update($sql);
      if ($res) $result= ['status'=>1,'msg'=>'审核成功！'];
      _end:
      return $result;
    }

    //还原销售结算
    public static function reduction($orderid,$user)
    {
      $result = ['status'=>0,'msg'=>'还原失败！'];
      $hasCheck = self::where('orderid',$orderid)->value('is_transfer');
      if ($hasCheck!=1){
        $result['msg'] = '还原失败！当前销售结算未审核通过。';goto _end;
      }
      $hasPayInfo = SelPayDtl::where('settle_orderid',$orderid)->find();
      if($hasPayInfo){
        $result['msg'] = '操作失败！此销售结算单中已有收款记录，不能还原。';goto _end;
      }
      $sql['mender'] = $user;
      $sql['update_date'] = date("Y-m-d H:i:s");
      $sql['is_transfer'] = 0;
      $res = self::where('orderid',$orderid)->update($sql);
      if ($res) $result= ['status'=>1,'msg'=>'还原成功！'];
      _end:
      return $result;
    }

    //删除销售结算
    public static function del($orderid)
    {
      $result = ['status'=>0,'msg'=>'删除失败！'];
      $hasCheck = self::where('orderid',$orderid)->value('is_transfer');
      if ($hasCheck==1){
        $result['msg'] = '删除失败！当前销售结算已经审核通过。';goto _end;
      }
      $hasPayInfo = SelPayDtl::where('settle_orderid',$orderid)->find();
      if($hasPayInfo){
        $result['msg'] = '操作失败！此销售结算单中已有收款记录，不能删除。';goto _end;
      }
      Db::startTrans();
      $res2 = SelSettleDtl::where('orderid',$orderid)->delete();
      $res = self::where('orderid',$orderid)->delete();
      if ($res && $res2){
        Db::commit();
        $where[] = ['orderid','<>',$orderid];
        $oid = self::where($where)->order('f_date','desc')->value('orderid');
        $result = ['status'=>1,'msg'=>'删除成功！','orderid'=>$oid];
      }else{
        Db::rollback();
      }
      _end:
      return $result;
    }

    //收款
    public static function makeSelPayDtl($orderid,$user,$depart)
    {
      $result = ['status'=>0,'msg'=>'转单失败'];
      $sel = self::where('orderid',$orderid)->find();
      if ($sel) $sel = $sel->toArray();
      if ($sel['is_transfer']!=1){
        $result['msg'] = '操作失败！结算单未审核。';goto _end;
      }
      $selDtl = SelSettleDtl::where('orderid',$orderid)->select()->toArray();
      if (empty($selDtl)){
        $result['msg'] = '操作失败！结算单中未存在明细。';goto _end;
      }
      $selPay = [];
      $selPayDtl = [];
      $cash_amount = 0;
      $next = true;
      foreach ($selDtl as $k=>$v){
        if(!$v['pay_done'] && $v['paid_up']!=$v['amount']){
          $next = false;
          if(!isset($selPay['orderid'])){
            $oid  = CommonFun::createOrder('XS');
            $data = date("Y-m-d");
            $dataTime = date("Y-m-d H:i:s");
            $selPay['orderid']      = $oid;
            $selPay['f_date']       = $data;
            $selPay['cust_no']      = $sel['cust_no'];
            $selPay['link_man']     = $sel['link_man'];
            $selPay['link_man2']    = $sel['contacts'];
            $selPay['yw_dept_id']   = $depart;
            $selPay['pay_mode_no']  = $sel['pay_mode_no'];
            $selPay['emp_no']       = $sel['emp_no'];
            $selPay['invoice_no']   = $sel['invoice_no'];
            $selPay['invoice_date'] = $sel['invoice_date'];
            $selPay['creater']      = $user;
            $selPay['creater_date'] = $dataTime;
            $selPay['dept_id']      = $depart;
          }
          $selPayDtl[$k] = [];
          $selPayDtl[$k]['orderid'] = $oid;
          $selPayDtl[$k]['item_no'] = $k+1;
          $selPayDtl[$k]['order_date'] = $dataTime;
          $selPayDtl[$k]['settle_orderid'] = $v['orderid'];
          $selPayDtl[$k]['settle_item_no'] = $v['item_no'];
          $selPayDtl[$k]['goods_code'] = $v['goods_code'];
          $selPayDtl[$k]['amount'] = $v['amount'];
          $selPayDtl[$k]['ppaid'] = $v['paid_up'];
          $paid_up = calc([$v['amount'],'-',$v['paid_up']],6);
          $selPayDtl[$k]['uppaid'] = $paid_up;
          $selPayDtl[$k]['paid'] = $paid_up;
          $cash_amount = calc([$cash_amount,'+',$paid_up],6);
        }
      }
      $selPay['cash_amount'] = $cash_amount;
      $selPay['paid_price']  = $cash_amount;
      if($next){
        $result['msg'] = '单据已经全部付款！';goto _end;
      }
      Db::startTrans();
      $res1 = SelPay::insert($selPay);
      $res2 = SelPayDtl::insertAll($selPayDtl);
      if ($res1 && $res2){
        Db::commit();
        $result = ['status'=>1,'msg'=>'Success','orderid'=>$oid];
      }else{
        Db::rollback();
      }
      _end:
      return $result;
    }


}
