<?php

namespace app\finance\model;
use app\helper\CommonFun;
use think\Model;
use think\facade\Db;

class SelPay extends Model
{
  public static function List($data)
  {
    $where = [];
    $search = CommonFun::ProcessingData($data['search']);
    if (!empty($search['f_date']) && !empty($search['end_f_date'])){
      $where[] = ['s.f_date','between',[$search['f_date'],$search['end_f_date']]];
    }
    if (!empty($search['f_date']) && empty($search['end_f_date'])){
      $where[] = ['s.f_date','>',$search['f_date']];
    }
    if (empty($search['f_date']) && !empty($search['end_f_date'])){
      $where[] = ['s.f_date','<',$search['end_f_date']];
    }
    if (!empty($search['invoice_date']) && !empty($search['end_invoice_date'])){
      $where[] = ['s.invoice_date','between',[$search['invoice_date'],$search['end_invoice_date']]];
    }
    if (!empty($search['invoice_date']) && empty($search['end_invoice_date'])){
      $where[] = ['s.invoice_date','>',$search['invoice_date']];
    }
    if (empty($search['invoice_date']) && !empty($search['end_invoice_date'])){
      $where[] = ['s.invoice_date','<',$search['end_invoice_date']];
    }
    if (!empty($search['orderid']) && isset($search['orderid'])){
      $where[] = ['s.orderid','=',$search['orderid']];
    }
    if (!empty($search['settle_orderid']) || !empty($search['goods_code'])){
      if (!empty($search['settle_orderid'])) $map[] = ['settle_orderid','=',$search['settle_orderid']];
      if (!empty($search['goods_code'])) $map[] = ['goods_code','=',$search['goods_code']];
      $oid = SelPayDtl::where($map)->column('orderid');
      $where[] = ['s.orderid','in',implode(',',$oid)];
    }
    if (!empty($search['cust_no']) && isset($search['cust_no'])){
      $where[] = ['s.cust_no','=',$search['cust_no']];
    }
    if (!empty($search['custlass']) && isset($search['custlass'])){
      $where[] = ['c.custlass','=',$search['custlass']];
    }
    if (!empty($search['link_man2']) && isset($search['link_man2'])){
      $where[] = ['s.link_man2','=',$search['link_man2']];
    }
    if (isset($search['pay_kind'])){
      $where[] = ['s.pay_kind','=',$search['pay_kind']];
    }
    if (!empty($search['pay_mode_no']) && isset($search['pay_mode_no'])){
      $where[] = ['s.pay_mode_no','=',$search['pay_mode_no']];
    }
    if (!empty($search['emp_no']) && isset($search['emp_no'])){
      $where[] = ['s.emp_no','=',$search['emp_no']];
    }
    if (!empty($search['cheque_no']) && isset($search['cheque_no'])){
      $where[] = ['s.cheque_no','=',$search['cheque_no']];
    }
    if (!empty($search['invoice_no']) && isset($search['invoice_no'])){
      $where[] = ['s.invoice_no','=',$search['invoice_no']];
    }
    if (!empty($search['checker']) && isset($search['checker'])){
      $where[] = ['s.checker','=',$search['checker']];
    }
    if (!empty($search['yw_dept_id']) && isset($search['yw_dept_id'])){
      $where[] = ['s.yw_dept_id','=',$search['yw_dept_id']];
    }
    if (!empty($search['area']) && isset($search['area'])){
      $where[] = ['c.area','=',$search['area']];
    }
    if (!empty($search['deliroute']) && isset($search['deliroute'])){
      $where[] = ['c.deliroute|c.sdeliroute|c.tdeliroute','=',$search['deliroute']];
    }
    if (isset($search['status'])){
      $where[] = ['s.status','=',$search['status']];
    }
    $custlass = Db::name('db_work')->where('field_name','custlass')->column('value','id');
    $field = 's.*,c.name as cust_name,c.depart as cust_dept,c.comarea,c.warehouse,c.parlevel,cu.name as f_name';
    $list = self::where($where)->alias('s')->field($field)
          ->join('customer c','c.id=s.cust_no','left')
          ->join('customer cu','cu.id=c.parlevel','left')
          ->paginate(['page'=>$data['page'],'list_rows'=>$data['pageSize']])
          ->toArray();
    return ['status'=>1,'data'=>$list,'custlass'=>$custlass];
  }

  public static function dtl($orderid)
  {
    $selPay = self::where('p.orderid',$orderid)->alias('p')->field('p.*,c.name as cust_name,c.depart cust_dept')->join('customer c','c.id=p.cust_no','left')->find();
    if(!$selPay){
      $result = ['status'=>0,'msg'=>'单据不存在！'];goto _end;
    }
    if ($selPay) $selPay = $selPay->toArray();
    $custMoney = Db::name('view_cust_prepay')->where('cust_no',$selPay['cust_no'])->value('price');
    $selPayDtl = SelPayDtl::where('d.orderid',$orderid)->alias('d')->field('d.*,p.invoice_no,p.invoice_date,c.name,c.specs,c.packspecs,c.dosage,c.origin,c.production,c.approval_code')
      ->join('sel_pay p','p.orderid=d.orderid','left')
      ->join('commodity c','c.goods_code=d.goods_code','left')
      ->select()->toArray();
    if ($selPay || $selPayDtl){
      $result = ['status'=>1,'formData'=>$selPay,'data'=>$selPayDtl,'custMoney'=>$custMoney];
    }
    _end:
    return $result;
  }

  public static function edit($sel,$selDtl,$user){
    $result = ['status'=>0,'msg'=>'保存失败！'];
    $sel = CommonFun::ProcessingData($sel);
    $status = self::where('orderid',$sel['orderid'])->value('status');
    if($status==1){
      $result['msg'] = '保存失败！该收款单已经审核。';goto _end;
    }
    $selPayDtl = array();
    foreach ($selDtl as $k=>&$v){
      $v = CommonFun::ProcessingData($v);
      $selPayDtl[$k] = array();
      $selPayDtl[$k]['orderid'] = $v['orderid'];
      $selPayDtl[$k]['item_no'] = $v['item_no'];
      $selPayDtl[$k]['order_date'] = $v['order_date'];
      $selPayDtl[$k]['settle_orderid'] = $v['settle_orderid'];
      $selPayDtl[$k]['settle_item_no'] = $v['settle_item_no'];
      $selPayDtl[$k]['goods_code'] = $v['goods_code'];
      $selPayDtl[$k]['amount'] = $v['amount'];
      $selPayDtl[$k]['ppaid'] = $v['ppaid'];
      $selPayDtl[$k]['uppaid'] = $v['uppaid'];
      $selPayDtl[$k]['paid'] = $v['paid'];
      $selPayDtl[$k]['settle'] = $v['settle'];
      $selPayDtl[$k]['remark'] = $v['remark'];
    }
    unset($sel['cust_name']);
    unset($sel['cust_dept']);
    $sel['update_code'] = $user;
    $sel['update_date'] = date("Y-m-d H:i:s");
    Db::startTrans();
    $res = self::where('orderid',$sel['orderid'])->update($sel);
    $res2 = SelPayDtl::where('orderid',$sel['orderid'])->deleteInsertAll($selPayDtl);
    if ($res && $res2){
      Db::commit();
      $result = ['status'=>1,'msg'=>'保存成功！'];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }

  public static function del($orderid)
  {
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $status = self::where('orderid',$orderid)->value('status');
    if ($status!=0){
      $result['msg'] = '操作失败！该单据已经审核。';goto _end;
    }
    Db::startTrans();
    $res = self::where('orderid',$orderid)->delete();
    $res2 = SelPayDtl::where('orderid',$orderid)->delete();
    if ($res && $res2){
      Db::commit();
      $where[] = ['orderid','<>',$orderid];
      $oid = self::where($where)->order('f_date','desc')->value('orderid');
      $result = ['status'=>1,'msg'=>'保存成功！','orderid'=>$oid];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }

  /**
   * @param $orderid string 订单编号
   * @param $type string 操作类型 1审核 0还原
   * @param $user string 操作人
  **/
  public static function check($orderid,$type,$user)
  {
    $result = ['status'=>0,'msg'=>$type?'审核失败！':'还原失败！'];
    $status = self::where('orderid',$orderid)->value('status');
    if($type){
      //审核的时候判断单据是否已审核
      if($status!=0){
        $result['msg'] = '操作失败！当前单据已经审核。';goto _end;
      }
    }else{
      //还原的时候判断单据是否未审核
      if($status!=1){
        $result['msg'] = '操作失败！当前单据未审核。';goto _end;
      }
    }
    $data = SelPay::where('d.orderid',$orderid)->alias('d')->field('p.settle_orderid,p.paid,s.*')
          ->join('sel_pay_dtl p','p.orderid=d.orderid')
          ->join('sel_settle_dtl s','s.orderid=p.settle_orderid and s.item_no=p.settle_item_no and s.goods_code=p.goods_code')
          ->select()
          ->toArray();
    $setlleDtl = array();
    $sOrderid = null;
    $itenNo = '';
    $goodsCode = '';
    $next = true;
    foreach ($data as $k=>$v){
      if(!$v['pay_done']) $next = false;
        $paid = calc([$v['paid'],'+',$v['paid_up']],6);
        $amount = floatval($v['amount']);
        $sOrderid = $v['settle_orderid'];
        $itenNo .= $itenNo?','.$v['item_no']:$v['item_no'];
        $goodsCode .= $goodsCode?','.$v['goods_code']:$v['goods_code'];
        $setlleDtl[$k] = array();
        $setlleDtl[$k]['orderid'] = $v['orderid'];
        $setlleDtl[$k]['item_no'] = $v['item_no'];
        $setlleDtl[$k]['goods_code']    = $v['goods_code'];
        $setlleDtl[$k]['unit']          = $v['unit'];
        $setlleDtl[$k]['batch_no']      = $v['batch_no'];
        $setlleDtl[$k]['qty']           = $v['qty'];
        $setlleDtl[$k]['price']         = $v['price'];
        $setlleDtl[$k]['tax_rate']      = $v['tax_rate'];
        $setlleDtl[$k]['un_tax_price']  = $v['un_tax_price'];
        $setlleDtl[$k]['goods_sum']     = $v['goods_sum'];
        $setlleDtl[$k]['tax_sum']       = $v['tax_sum'];
        $setlleDtl[$k]['amount']        = $v['amount'];
        $setlleDtl[$k]['ref_cost_price']= $v['ref_cost_price'];
        $setlleDtl[$k]['ref_cost']      = $v['ref_cost'];
        $setlleDtl[$k]['p_order_no']    = $v['p_order_no'];
        $setlleDtl[$k]['p_item_no']     = $v['p_item_no'];
        $setlleDtl[$k]['paid_up']       = $type?$paid:null;
        $setlleDtl[$k]['pay_done']      = ($type && $paid==$amount)?1:0;
        $setlleDtl[$k]['pay_done_date'] = ($type && $paid==$amount)?date("Y-m-d H:i:s"):null;
        $setlleDtl[$k]['remark']        = $v['remark'];
        $setlleDtl[$k]['makeupfor_amount'] = $v['makeupfor_amount'];
        $setlleDtl[$k]['makeupfor_price']  = $v['makeupfor_price'];
    }
    $where[] = ['orderid','=',$sOrderid];
    $where[] = ['item_no','in',$itenNo];
    $where[] = ['goods_code','in',$goodsCode];
    if($type){
      if ($next){
        $result['msg'] = '<p>当前单据明细中的应收项目已经全部收款完毕，请不要重复收款！</p><p>提示：当前收款单可以删除！</p>';goto _end;
      }
      $upData['checker'] = $user;
      $upData['checker_date'] = date("Y-m-d H:i:s");
      $upData['status'] = 1;
    }else{
      $upData['update_code'] = $user;
      $upData['update_date'] = date("Y-m-d H:i:s");
      $upData['status'] = 0;
    }
    Db::startTrans();
    $res = SelSettleDtl::where($where)->deleteInsertAll($setlleDtl);
    $res2= SelPay::where('orderid',$orderid)->update($upData);
    if($res && $res2){
      Db::commit();
      $result = ['status'=>1,'msg'=>$type?'审核成功！':'还原成功！'];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }


}
