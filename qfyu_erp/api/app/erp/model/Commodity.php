<?php

namespace app\erp\model;
use app\helper\CommonFun;
use app\helper\ZJM;
use app\erp\validate\NewCommodityVal;
use think\facade\Db;
use think\Model;

class Commodity extends Model
{
  public static function list($data)
  {
    $where = [];
    $search = CommonFun::ProcessingData($data['search']);
    if (!empty($search['goods_code'])) {
      $where[] = ['c.goods_code', '=', $search['goods_code']];
    }
    if (!empty($search['name'])) {
      $where[] = ['c.name', 'like', '%' . $search['name'] . '%'];
    }
    if (!empty($search['code'])) {
      $where[] = ['c.code', 'like', '%' . $search['code'] . '%'];
    }
    if (!empty($search['pym'])) {
      $where[] = ['c.pym', 'like', '%' . $search['pym'] . '%'];
    }
    if (isset($search['category_id']) && !empty($search['category_id'])) {
      $where[] = ['c.category_id', '=', $search['category_id']];
    }
    if (isset($search['gsp_type']) && $search['gsp_type'] != null) {
      $where[] = ['c.gsp_type', '=', $search['gsp_type']];
    }
    if (isset($search['storage_type']) && $search['storage_type'] != null) {
      $where[] = ['c.storage_type', '=', $search['storage_type']];
    }
    if (isset($search['dosage']) && $search['dosage'] != null) {
      $where[] = ['c.dosage', '=', $search['dosage']];
    }
    if ($search['status'] != null) {
      $where[] = ['c.status', '=', $search['status']];
    }
    if (!empty($data['pageSize'])) $pageSize = $data['pageSize'];
    $res = Db::name('commodity_list')->alias('c')
      ->field('c.*,d.dept_name')
      ->join('depart d', 'd.id=c.depart_id', 'left')
      ->where($where)
      ->paginate(['list_rows' => $pageSize, 'page' => $data['page']])
      ->toArray();
    if (!empty($res['data'])) {
      foreach ($res['data'] as $k => $v) {
        $res['data'][$k]['function_id'] = [$v['top_fid'], $v['parent_fid'], $v['function_id']];
      }
    }
    return $res;
  }

  public static function getCategorySelect()
  {
    $result['purch_type'] = config('parameter.purch_type');
    $result['tend_type'] = config('parameter.tend_type');
    $result['color_type'] = config('parameter.color_type');
    $result['storage'] = config('parameter.storage');
    $result['element_type'] = config('parameter.element_type');
    $result['level'] = config('parameter.level');
    $result['shelf_unit'] = config('parameter.shelf_unit');
    $result['unit'] = config('parameter.goods_unit');
    $result['dosage'] = config('parameter.dosage');
    $result['gsp_category'] = config('parameter.gsp_category');
    $result['billing_type'] = config('parameter.billing_type');
    $result['abc_type'] = config('parameter.abc_type');
    $result['ml_type'] = config('parameter.ml_type');
    return $result;
  }

  /**
   * ??????-?????? ????????????
   * @param  $data array ??????????????????
   * @param  $user string ?????????code
   **/
  public static function newCommodityInfo($data, $user)
  {
    $result = ['status' => 0, 'msg' => '???????????????'];
    $data = CommonFun::ProcessingData($data['data'], ['kinds_id', 'category_id', 'depart_id', 'solit_value', 'shelf_life', 'hours', 'amount', 'buyer_day', 'buyer_cycle', 'buyer_multiple', 'start_give_amount', 'give_amount','integral', 'wholesale_amount', 'retail_amount', 'sala_multiple', 'day', 'tend_day','tax','take','pifaml',
'retail']);
    $validate = new NewCommodityVal();
    $checker = $validate->scene('all')->check($data);
    if (!$checker) {
      $result['msg'] = $validate->getError();
      goto _end;
    }
    if(isset($data['unit2']) && !empty($data['unit2'])){
      if($data['unit']==$data['unit2']){
        $result['msg']='??????????????????????????????????????????';goto _end;
      }
      if ($data['solit_value']<=1){
        $result['msg'] = '?????????????????????????????????1??????????????????????????????';goto _end;
      }
    }
    if($data['solit_value']>1){
      if(isset($data['unit2']) && empty($data['unit2'])){
        $result['msg'] = '???????????????????????????';goto _end;
      }
    }
    $date_time = date("Y-m-d H:i:s");
    //????????????
    $commodity['goods_code'] = $data['goods_code'];
    $commodity['goods_name'] = $data['goods_name'] ? substr($data['goods_name'], 0, 100) : substr($data['name'], 0, 100);
    $commodity['name'] = substr($data['name'], 0, 100);
    $commodity['en_name'] = substr($data['en_name'], 0, 120);
    $commodity['code'] = $data['code'];
    $commodity['file_name'] = substr($data['file_name'], 0, 255);
    $commodity['pym'] = ZJM::character($data['name']);
    $commodity['specs'] = substr($data['specs'], 0, 30);
    $commodity['packspecs'] = substr($data['packspecs'], 0, 50);
    $commodity['electron_code'] = $data['electron_code'];
    $commodity['color_code'] = $data['color_code'];
    $commodity['kinds_id'] = $data['kinds_kid'] ? $data['kinds_kid'] : (isset($data['kinds_id']) ? $data['kinds_id'] : null);
    $commodity['category_id'] = isset($data['category_id']) ? $data['category_id'] : null;
    $fid = end($data['function_id']);
    $commodity['function_id'] = $fid;
    $kinds = Db::name('commodity_function')->column('parent_id', 'id');
    $commodity['parent_fid'] = $kinds[$fid];
    $commodity['top_fid'] = $commodity['parent_fid'] ? $kinds[$commodity['parent_fid']] : null;
    $commodity['origin'] = $data['origin'];
    $commodity['production'] = $data['production'];
    $commodity['maker'] = $data['maker'];
    $commodity['unit'] = $data['unit'];
    $commodity['unit2'] = isset($data['unit2']) ? $data['unit2'] : null;
    $commodity['is_solit'] = $data['is_solit'];
    $commodity['solit_value'] = $data['solit_value'];
    $commodity['dosage'] = $data['dosage'];
    $commodity['tax'] = $data['tax'] > 0 ? $data['tax'] : null;
    $commodity['approval_code'] = $data['approval_code'];
    $commodity['approval_date'] = $data['approval_date'];
    $commodity['shelf_life'] = $data['shelf_life'];
    $commodity['shelf_unit'] = isset($data['shelf_unit']) ? $data['shelf_unit'] : null;
    $commodity['take'] = $data['take'];
    $commodity['gsp_type'] = $data['gsp_type'];
    $commodity['standard_code'] = $data['standard_code'];
    $commodity['supervise_code'] = $data['supervise_code'];
    $commodity['pack_specs1'] = $data['pack_specs1'];
    $commodity['pack_specs2'] = $data['pack_specs2'];
    $commodity['drug'] = $data['drug'];
    $commodity['drug_unit'] = $data['drug_unit'];
    $commodity['hours'] = $data['hours'];
    $commodity['element_type'] = isset($data['element_type']) ? $data['element_type'] : null;
    $commodity['coloc_type'] = isset($data['coloc_type']) ? $data['coloc_type'] : null;
    $commodity['billing_type'] = isset($data['billing_type']) ? $data['billing_type'] : null;
    $commodity['pifaml'] = $data['pifaml'] >0 ?$data['pifaml']:null;
    $commodity['retail'] = $data['retail'] >0 ?$data['retail']:null;
    $commodity['depart_id'] = $data['depart_id'];
    $commodity['markup'] = $data['markup'];
    $commodity['is_medical'] = $data['is_medical'];
    $commodity['is_check'] = $data['is_check'];
    $commodity['is_qty'] = $data['is_qty'];
    $commodity['is_first'] = $data['is_first'];
    $commodity['is_variety'] = $data['is_variety'];
    $commodity['is_rx'] = $data['is_rx'];
    $commodity['is_shopping'] = $data['is_shopping'];
    $commodity['is_yi'] = $data['is_yi'];
    $commodity['is_yymz'] = $data['is_yymz'];
    $commodity['is_vip'] = $data['is_vip'];
    $commodity['is_supervise'] = $data['is_supervise'];
    $commodity['is_drugs'] = $data['is_drugs'];
    $commodity['is_gift'] = $data['is_gift'];
    $commodity['remark'] = $data['remark'];
    //????????????
    $extend['abc'] = isset($data['abc']) ? $data['abc'] : null;
    $extend['abkind'] = isset($data['abkind']) ? $data['abkind'] : null;
    $extend['quality_standards'] = $data['quality_standards'];
    $extend['quality_date'] = $data['quality_date'];
    $extend['exterior'] = $data['exterior'];
    $extend['brand'] = $data['brand'];
    $extend['brand_date'] = $data['brand_date'];
    $extend['level'] = isset($data['level']) ? $data['level'] : null;
    $extend['gmp_code'] = $data['gmp_code'];
    $extend['gmp_property'] = $data['gmp_property'];
    $extend['gmp_end_date'] = $data['gmp_end_date'];
    $extend['license_key'] = $data['license_key'];
    $extend['license_date'] = $data['license_date'];
    $extend['code1'] = $data['code1'];
    $extend['code1_date'] = $data['code1_date'];
    $extend['code2'] = $data['code2'];
    $extend['code2_date'] = $data['code2_date'];
    $extend['custom_name'] = $data['custom_name'];
    $extend['custom_val'] = $data['custom_val'];
    $extend['custom_code1'] = $data['custom_code1'];
    $extend['custom_code2'] = $data['custom_code2'];
    $extend['custom_code3'] = $data['custom_code3'];
    $extend['start_give_amount'] = $data['start_give_amount'];
    $extend['give_amount'] = $data['give_amount'];
    $extend['times_give'] = $data['times_give'];
    $extend['give_date'] = isset($data['give_date'])?$data['give_date']:null;
    $extend['integral'] = $data['integral'];
    //????????????
    $buyer['buyer_type'] = $data['buyer_type'];
    $buyer['is_new'] = $data['is_new'];
    $buyer['is_buyer'] = $data['is_buyer'];
    $buyer['supplier'] = $data['supplier'];
    $buyer['amount'] = $data['amount'];
    $buyer['buyer_id'] = $data['buyer_id'];
    $buyer['buyer_day'] = $data['buyer_day'];
    $buyer['buyer_cycle'] = $data['buyer_cycle'];
    $buyer['buyer_multiple'] = $data['buyer_multiple'];
    //????????????
    $sale['salesman'] = $data['salesman'];
    $sale['wholesale_amount'] = $data['wholesale_amount'];
    $sale['retail_amount'] = $data['retail_amount'];
    $sale['sala_multiple'] = $data['sala_multiple'];
    $sale['is_sale'] = $data['is_sale'];
    $sale['is_wholesale'] = $data['is_wholesale'];
    $sale['is_retail'] = $data['is_retail'];
    //????????????
    $waer['day'] = $data['day'];
    $waer['tend_type'] = isset($data['tend_type'])?$data['tend_type']:null;
    $waer['tend_day'] = $data['tend_day'];
    $waer['storage_type'] = $data['storage_type'];
    $waer['max_qty'] = $data['max_qty'] > 0 ? $data['max_qty'] : null;
    $waer['min_qty'] = $data['min_qty'] > 0 ? $data['min_qty'] : null;
    unset($data['depart_name']);
    unset($data['buyer_name']);
    unset($data['salesman_name']);
    $has = self::where('goods_code',$data['goods_code'])->field('goods_code,unit2,solit_value,status')->find();
    if($has) {
      $has = $has->toArray();
      if($has['status']==1){
        $result['msg'] = '?????????????????????????????????????????????';goto _end;
      }
      if($has['unit2']){
        if($has['unit2']!=$data['unit2']){
          $result['msg'] = '????????????????????????????????????????????????';goto _end;
        }
        if($has['solit_value']>1){
          if ($has['solit_value']!=$data['solit_value']){
            $result['msg'] = '???????????????????????????????????????????????????';goto _end;
          }
        }
      }
    }
    Db::startTrans();
    if (empty($data['goods_code'])) {
      //??????
      unset($commodity['status']);
      $goods_code = CommonFun::createCode('GD', 'goods_code');
      $commodity['goods_code'] = $goods_code;
      $buyer['goods_code'] = $goods_code;
      $waer['goods_code'] = $goods_code;
      $sale['goods_code'] = $goods_code;
      $extend['goods_code'] = $goods_code;
      $commodity['creater'] = $user;
      $commodity['creater_date'] = $date_time;
      $extend['creater_code'] = $user;
      $extend['creater_date'] = $date_time;
      $buyer['creater_code'] = $user;
      $buyer['creater_date'] = $date_time;
      $sale['creater_code'] = $user;
      $sale['creater_date'] = $date_time;
      $waer['creater_code'] = $user;
      $waer['creater_date'] = $date_time;
      $price_sql = Db::name('commodity_price_system')->field('id as mode_id,name as mode_name')->where('status', 1)->select()->toArray();
      foreach ($price_sql as $k => $v) {
        $price_sql[$k]['goods_code'] = $commodity['goods_code'];
        $price_sql[$k]['price1'] = null;
        $price_sql[$k]['price2'] = null;
        $price_sql[$k]['creater_code'] = $user;
        $price_sql[$k]['creater_date'] = $date_time;
      }
      $price_sql[0]['price1'] = $data['buyer_price'] > 0 ? $data['buyer_price'] : null;
      $price_sql[0]['price2'] = $data['buyer_price2'] > 0 ? $data['buyer_price2'] : null;
      $price_sql[1]['price1'] = $data['trade_price'] > 0 ? $data['trade_price'] : null;
      $price_sql[1]['price2'] = $data['trade_price2'] > 0 ? $data['trade_price2'] : null;
      $price_sql[2]['price1'] = $data['retail_price'] > 0 ? $data['retail_price'] : null;
      $price_sql[2]['price2'] = $data['retail_price2'] > 0 ? $data['retail_price2'] : null;
      $sql1 = Db::name('commodity')->insert($commodity);
      $sql2 = Db::name('commodity_extend')->insert($extend);
      $sql3 = Db::name('commodity_buyer')->insert($buyer);
      $sql4 = Db::name('commodity_sale')->insert($sale);
      $sql5 = Db::name('commodity_warehouse')->insert($waer);
      $sql6 = Db::name('commodity_price')->insertAll($price_sql);
      if ($sql1 && $sql2 && $sql3 && $sql4 && $sql5 && $sql6) {
        Db::commit();
        $result = ['status' => 1, 'msg' => '????????????!'];
      } else {
        Db::rollback();
      }
    } else {
      //??????
      unset($commodity['creater']);
      unset($commodity['creater_date']);
      $date = date("Y-m-d H:i:s");
      $commodity['updater_date'] = $date;
      $commodity['updater_code'] = $user;
      $extend['updater_code'] = $user;
      $extend['updater_date'] = $date;
      $buyer['updater_code'] = $user;
      $buyer['updater_date'] = $date;
      $sale['updater_code'] = $user;
      $sale['updater_date'] = $date;
      $waer['updater_code'] = $user;
      $waer['updater_date'] = $date;
      $buyer_price['price1'] = $data['buyer_price'] > 0 ? $data['buyer_price'] : null;
      $buyer_price['price2'] = $data['buyer_price2'] > 0 ? $data['buyer_price2'] : null;
      $buyer_price['updater_code'] = $user;
      $buyer_price['updater_date'] = $date;
      $trade_price['price1'] = $data['trade_price'] > 0 ? $data['trade_price'] : null;
      $trade_price['price2'] = $data['trade_price2'] > 0 ? $data['trade_price2'] : null;
      $trade_price['updater_code'] = $user;
      $trade_price['updater_date'] = $date;
      $retail_price['price1'] = $data['retail_price'] > 0 ? $data['retail_price'] : null;
      $retail_price['price2'] = $data['retail_price2'] > 0 ? $data['retail_price2'] : null;
      $retail_price['updater_code'] = $user;
      $retail_price['updater_date'] = $date;
      $map[] = ['goods_code', '=', $data['goods_code']];
      $where1[] = ['goods_code', '=', $data['goods_code']];
      $where1[] = ['mode_id', '=', 1];
      $where2[] = ['goods_code', '=', $data['goods_code']];
      $where2[] = ['mode_id', '=', 2];
      $where3[] = ['goods_code', '=', $data['goods_code']];
      $where3[] = ['mode_id', '=', 3];
      $sql1 = Db::name('commodity')->where($map)->update($commodity);
      $sql2 = Db::name('commodity_extend')->where($map)->update($extend);
      $sql3 = Db::name('commodity_buyer')->where($map)->update($buyer);
      $sql4 = Db::name('commodity_sale')->where($map)->update($sale);
      $sql5 = Db::name('commodity_warehouse')->where($map)->update($waer);
      $sql6 = Db::name('commodity_price')->where($where1)->update($buyer_price);
      $sql7 = Db::name('commodity_price')->where($where2)->update($trade_price);
      $sql8 = Db::name('commodity_price')->where($where3)->update($retail_price);
      if ($sql1 && $sql2 && $sql3 && $sql4 && $sql5 && $sql6 && $sql7 && $sql8) {
        $map[] = ['goods_code', '=', $data['goods_code']];
        $map[] = ['new_state', '=', 0];
        $updata['new_state'] = 1;
        $updata['reviser'] = $user;
        $updata['reviser_date'] = date("Y-m-d H:i:s");
        $res1 = Db::name('gsp_first_goods')->where($map)->field('orderid,goods_code')->find();
        if ($res1) {
          $sql7 = Db::name('gsp_first_goods')->where($map)->update($updata);
          if (!$sql7) {
            Db::rollback();
            goto _end;
          }
        }
        $result = ['status' => 1, 'msg' => '???????????????'];
        Db::commit();
      } else {
        $result['msg'] = '???????????????';
        Db::rollback();
      }
    }
    _end:
    return $result;
  }

  /***
   * ??????????????????
   **/
  public static function checker($data, $user)
  {
    $result = ['status' => 0, 'msg' => '???????????????'];
    $has_check = Commodity::where('goods_code', $data['goods_code'])->field('status')->find()->toArray();
    $sql['checker'] = $user;
    $sql['check_date'] = date("Y-m-d H:i:s");
    if ($data['state']) {//??????
      if (!$has_check || $has_check['status'] == 1) {
        $result['msg'] = '??????????????????????????????';
        goto _end;
      }
      $sql['status'] = 1;
      $res = Commodity::where('goods_code', $data['goods_code'])->update($sql);
      if ($res) $result = ['status' => 1, 'msg' => '???????????????'];
    } else {//????????????
      unset($sql);
      if ($has_check['status'] == 0) {
        $result['msg'] = '?????????????????????????????????????????????';
        goto _end;
      }
      $sql['status'] = 0;
      $sql['updater_code'] = $user;
      $sql['updater_date'] = date("Y-m-d H:i:s");
      $res = Commodity::where('goods_code', $data['goods_code'])->update($sql);
      if ($res) $result = ['status' => 1, 'msg' => '?????????????????????'];
      else $result['msg'] = '?????????????????????';
    }
    _end:
    return $result;
  }

  /**
   * ??????????????????-????????????
   * @param $data ????????????
   */
  public static function getChooseAllGoodsList($data)
  {
    $page = empty($data['page']) ? 1 : intval($data['page']);
    $pageSize = empty($data['pageSize']) ? 8 : intval($data['pageSize']);
    $where[] = ['a.status', '=', 1]; //????????????
    if (isset($data['search'])) {
      $search = $data['search'];
      if (!empty($search['goods_code'])) $where[] = ['a.goods_code', 'like', '%' . trim($search['goods_code']) . '%'];
      if (!empty($search['production'])) $where[] = ['a.production', 'like', '%' . trim($search['production']) . '%'];
      if (!empty($search['goods_name'])) $where[] = ['a.goods_name', 'like', '%' . trim($search['goods_name']) . '%'];
      if (!empty($search['origin'])) $where[] = ['a.origin', 'like', '%' . trim($search['origin']) . '%'];
      if (!empty($search['code'])) $where[] = ['a.code', 'like', '%' . trim($search['code']) . '%'];
      if (!empty($search['approval_code'])) $where[] = ['a.approval_code', 'like', '%' . trim($search['approval_code']) . '%'];
      if (isset($search['goodstype']) && is_array($search['goodstype'])) {
        if (isset($search['goodstype'][0])) $where[] = ['a.top_fid', '=', $search['goodstype'][0]];
        if (isset($search['goodstype'][1])) $where[] = ['a.parent_fid', '=', $search['goodstype'][1]];
        if (isset($search['goodstype'][2])) $where[] = ['a.function_id', '=', $search['goodstype'][2]];
      }
      if (!empty($search['supplier'])) $where[] = ['a.supplier', '=', $search['supplier']];
    }
    //?????? 4???????????????(low_price) 5????????????(high_price) 8???????????????(near_price) 9???????????????(first_price) 2:???????????????(standard_price) 3:???????????????(retail_price)
    $field = "a.*,p.full_name as sup_name";
    $field .= ",pr1.price1 as low_price,pr2.price1 as high_price,pr3.price1 as near_price,pr4.price1 as first_price,pr5.price1 as standard_price,pr6.price1 as retail_price";
    $list = Db::name('commodity_list')->alias('a')->field($field)
      ->join('providers p', 'p.supplier_code=a.supplier', 'left')
      ->join('commodity_price pr1', 'pr1.goods_code=a.goods_code and pr1.mode_id=4', 'left')
      ->join('commodity_price pr2', 'pr2.goods_code=a.goods_code and pr2.mode_id=5', 'left')
      ->join('commodity_price pr3', 'pr3.goods_code=a.goods_code and pr3.mode_id=8', 'left')
      ->join('commodity_price pr4', 'pr4.goods_code=a.goods_code and pr4.mode_id=9', 'left')
      ->join('commodity_price pr5', 'pr5.goods_code=a.goods_code and pr5.mode_id=2', 'left')
      ->join('commodity_price pr6', 'pr6.goods_code=a.goods_code and pr6.mode_id=3', 'left')
      ->where($where)
      ->paginate(['list_rows' => $pageSize, 'page' => $page])->toArray();
    foreach ($list['data'] as $k => $v) {
      $list['data'][$k]['commodity_price'] = Db::name('commodity_price')->where('goods_code', $v['goods_code'])->column('mode_id,price1,price2', 'mode_id');
    }
    return $list;
  }

  /** ????????????????????? ???-?????????????????????-????????????????????????-??????????????????
   *  $code string ?????? goods_code
   **/
  public static function commodityInfo($code)
  {
    $where[] = ['goods_code', '=', $code];
    $where[] = ['mode_id', '<=', 3];
    $res = CommodityPrice::where($where)->field('price1,price2')->select()->toArray();
    return $res;
  }

  public static function qtyList($code)
  {
    $field= 's.ware_code,w.ware_title,s.pos_code,s.batch_no,s.valid_date,s.qty,s.price1,s.amount';
    $data = Db::name('stock_details')->alias('s')->field($field)
          ->join('warehouse w','w.ware_code=s.ware_code','left')
          ->where('goods_code',$code)
          ->select();
    return ['status'=>1,'data'=>$data];
  }

}
