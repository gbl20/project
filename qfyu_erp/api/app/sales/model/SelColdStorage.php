<?php

namespace app\sales\model;
use app\helper\CommonFun;
use app\sales\validate\SelColdStorageVal;
use think\facade\Db;
use think\Model;

class SelColdStorage extends Model
{
  public static function list($search)
  {
    $where = [];
    $data = self::where($where)
          ->paginate(['page'=>$search['page'],'list_rows'=>$search['pageSize']])
          ->toArray();
    return ['status'=>1,'data'=>$data];
  }

  public static function dtl($orderid)
  {
    $formData = self::where('orderid',$orderid)->find();
    if ($formData) $formData = $formData->toArray();
    $data = SelColdStorageDtl::alias('d')->field('d.*,c.sname as cust_sname,c.name as cust_name,c.parlevel,c.depart as cust_depart,cu.sname as par_sname,co.goods_name,co.name,co.specs,co.production,co.approval_code,co.origin,co.dosage')
          ->join('customer c','c.id=d.cust_no','left')
          ->join('customer cu','cu.id=c.parlevel','left')
          ->join('commodity co','co.goods_code=d.goods_code','left')
          ->where('d.orderid',$orderid)
          ->select()
          ->toArray();
    return ['status'=>1,'formData'=>$formData,'data'=>$data];
  }

  public static function saveData($data,$user)
  {
    $result = ['status'=>0,'msg'=>'保存失败！'];
    $formData = CommonFun::ProcessingData($data['formData']);
    $validate = new SelColdStorageVal();
    $checker = $validate->scene('all')->check($formData);
    if (!$checker){
      $result['msg'] = $validate->getError();goto _end;
    }
    $ColdCon['orderid'] = $formData['orderid'];
    $ColdCon['f_date']  = $formData['f_date'];
    $ColdCon['trans_type']  = $formData['trans_type'];
    $ColdCon['license_plate'] = $formData['license_plate'];
    $ColdCon['driver']  = $formData['driver'];
    $ColdCon['shipper'] = $formData['shipper'];
    $ColdCon['deliveryman'] = $formData['deliveryman'];
    $ColdCon['emp_no']      = $formData['emp_no'];
    $ColdCon['p_orderid']   = $formData['p_orderid'];
    $ColdCon['remark']      = substr($formData['remark'],0,100);
    $ColdCon['mender']      = $user;
    $ColdCon['update_date'] = date("Y-m-d H:i:s");
    $ColdCon['transport']   = $formData['transport'];
    $ColdCon['device']      = $formData['device'];
    $ColdCon['temperature'] = $formData['temperature'];
    $ColdCon['transport_certificate'] = $formData['transport_certificate'];
    $ColdDtl = [];
    if (!empty($data['data'])){
      foreach($data['data'] as $k=>$v){
        $v = CommonFun::ProcessingData($v);
        $ColdDtl[$k] = [];
        $ColdDtl[$k]['orderid'] = $v['orderid'];
        $ColdDtl[$k]['item_no'] = $k+1;
        $ColdDtl[$k]['cust_no'] = $v['cust_no'];
        $ColdDtl[$k]['address'] = substr($v['address'],0,80);
        $ColdDtl[$k]['tel']     = substr($v['tel'],0,40);
        $ColdDtl[$k]['emp_no']  = $v['emp_no'];
        $ColdDtl[$k]['pay_mode_no']   = $v['pay_mode_no'];
        $ColdDtl[$k]['p_item_no']     = $v['p_item_no'];
        $ColdDtl[$k]['goods_code']    = $v['goods_code'];
        $ColdDtl[$k]['qty']           = $v['qty'];
        $ColdDtl[$k]['batch_no']      = $v['batch_no'];
        $ColdDtl[$k]['valid_date']    = $v['valid_date'];
        $ColdDtl[$k]['delivery_date'] = $v['delivery_date'];
        $ColdDtl[$k]['delivery_temp'] = $v['delivery_temp'];
        $ColdDtl[$k]['received_date'] = $v['received_date'];
        $ColdDtl[$k]['received_temp'] = $v['received_temp'];
        $ColdDtl[$k]['temp_file']     = substr($v['temp_file'],0,255);
      }
    }
    Db::startTrans();
    $res1 = self::where('orderid',$formData['orderid'])->update($ColdCon);
    $res2 = SelColdStorageDtl::where('orderid',$formData['orderid'])->deleteInsertAll($ColdDtl);
    if ($res1 && $res2){
      Db::commit();
      $result = ['status'=>1,'msg'=>'保存成功！'];
    }else{
      Db::rollback();
    }
    _end:
    return $result;
  }

  public static function check($search,$user)
  {
    $result = ['status'=>0,'msg'=>'审核失败！'];
    $status = self::where('orderid',$search['orderid'])->value('status');
    if ($status!=0){
      $result['msg'] = '审核失败！该单据已经审核通过。';goto _end;
    }
    $coldDtl = SelColdStorageDtl::where('orderid',$search['orderid'])->select()->toArray();
    if (!empty($coldDtl)){
      foreach ($coldDtl as $k=>$v){
        if (!$v['received_date'] || !$v['received_temp']){
          $result['msg'] = "当前".$search['orderid']."号冷藏药品销退收货登记单明细，存在未填写\"到货时间\"或\"到货时温度\"。";
          goto _end;
        }
      }
    }
    $res = self::where('orderid',$search['orderid'])->update(['audit'=>$user,'status'=>1]);
    if ($res) $result = ['status'=>1,'msg'=>'审核成功！'];
    _end:
    return $result;
  }

  public static function backData($search,$user)
  {
    $result = ['status'=>0,'msg'=>'还原失败！'];
    $status = self::where('orderid',$search['orderid'])->value('status');
    if($status!=1){
      $result['msg'] = '还原失败！当前单据未审核。';goto _end;
    }
    $res = self::where('orderid',$search['orderid'])->update(['status'=>0,'mender'=>$user,'update_date'=>date("Y-m-d H:i:s")]);
    if ($res) $result = ['status'=>1,'msg'=>'还原成功！'];
    _end:
    return $result;
  }

  public static function del($search){
    $result = ['status'=>0,'msg'=>'删除失败！'];
    $status = self::where('orderid',$search['orderid'])->value('status');
    if ($status!=0){
      $result['msg'] = '删除失败！该单据已经审核通过。';
    }
    Db::startTrans();
    $res1 = self::where('orderid',$search['orderid'])->delete();
    $res2 = SelColdStorageDtl::where('orderid',$search['orderid'])->delete();
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
