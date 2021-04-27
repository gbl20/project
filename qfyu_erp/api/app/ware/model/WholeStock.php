<?php
namespace app\ware\model;
use app\helper\CommonFun;
use app\ware\validate\WholeValid;
use think\facade\Db;
use think\Model;

class WholeStock extends Model
{
    /**
     * 整仓盘点单列表
     */
    public static function gettaklist($map=[],$page,$order='create_date desc',$pageSize=100){
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
     * 新增整仓盘点
     */
    public static function addnew_whole($params,$request){
        $result=array('status'=>0,'msg'=>'init');
        if(!isset($params['ware_code']) || (isset($params['ware_code']) && empty($params['ware_code']))){
            $result['msg']="请选择盘点仓库";
            goto _end;
        }
        $lock_info=Db::name('ware_locked')->field('bill_no')->where('ware_code','=',$params['ware_code'])->find();
        if($lock_info){
            $result['msg']="所选仓库正在盘点，被单据{$lock_info['bill_no']}锁定";
            goto _end;
        }
        if(intval($params['atype'])>0){
            $msp[]=array('s.ware_code','=',$params['ware_code']);
            if(isset($params['pos_code']) && !empty($params['pos_code'])) $msp[]=array('s.pos_code','=',$params['pos_code']);
            if(isset($params['category_id']) && !empty($params['category_id'])) $msp[]=array('c.category_id','=',$params['category_id']);
            if(isset($params['function_id']) && !empty($params['function_id'])){
                $msp[]=array('c.function_id','=',Db::raw("{$params['category_id']} OR c.parent_fid={$params['category_id']} OR c.top_fid={$params['category_id']}"));
            }
            if(isset($params['noqty']) && intval($params['noqty'])==0) $msp[]=array('s.qty','>',0);
            $stock_list=Db::name('stock_details')->alias('s')->field('s.*,pr.price1 as selprice,pr2.price1 as rtlprice')
                ->join('commodity c','c.goods_code=s.goods_code','LEFT')
                ->join('commodity_price pr','pr.goods_code=`s`.`goods_code` and `pr`.`mode_id`=2','LEFT')
                ->join('commodity_price pr2','pr2.goods_code=`s`.`goods_code` and `pr2`.`mode_id`=3','LEFT')
                ->where($msp)->select()->toArray();
            if(!$stock_list || empty($stock_list)){
                $result['msg']='没有找到产品，不能生成结存单';
                goto _end;
            }
        }
        $adata['bill_no']=CommonFun::createOrder('TW');
        $adata['ware_code']=$params['ware_code'];
        $adata['empno']=$request['code'];
        $adata['transfer']=0;
        $adata['remark']=null;
        $adata['creater']=$request['code'];
        $adata['f_date']=$adata['create_date']=date('Y-m-d H:i:s');
        $adata['grup']=$request['depart'];
        Db::startTrans();
        if(intval($params['atype'])>0) {
            $new_stock_list = array_chunk($stock_list, 100);
            foreach ($new_stock_list as $ydetail) {
                $detail_data = array();
                foreach ($ydetail as $k => $v) {
                    $detail_data[$k]['item_no'] = $k + 1;
                    $detail_data[$k]['bill_no'] = $adata['bill_no'];
                    $detail_data[$k]['goods_code'] = $v['goods_code'];
                    $detail_data[$k]['pos_code'] = $v['pos_code'];
                    $detail_data[$k]['sup_code'] = $v['sup_code'];
                    $detail_data[$k]['batch_no'] = $v['batch_no'];
                    $detail_data[$k]['prod_date'] = $v['prod_date'];
                    $detail_data[$k]['valid_date'] = $v['valid_date'];
                    $detail_data[$k]['qty'] = $v['qty'];
                    $detail_data[$k]['unit'] = $v['unit'];
                    $detail_data[$k]['rqty'] = $v['qty'];
                    $detail_data[$k]['price'] = $v['price1'];
                    $detail_data[$k]['ramount']=$detail_data[$k]['amount'] = calc([$v['qty'],'*',$v['price1']], 6,true);
                    $detail_data[$k]['diff_qty'] =0;
                    $detail_data[$k]['diff_amount'] =0;
                    $detail_data[$k]['selprice'] = $v['selprice'];
                    $detail_data[$k]['rtlprice'] = $v['rtlprice'];
                    $detail_data[$k]['stock_id'] = $v['id'];
                }
                $res2 = Db::name('whole_stock_detail')->insertAll($detail_data);
                if (!$res2) {
                    Db::rollback();
                    $result = array('status' => 0, 'msg' => '操作失败');
                    goto _end;
                }
            }
            unset($stock_list);
            unset($new_stock_list);
        }else{
            $res2=true;
        }
        $lock_data['ware_code']=$adata['ware_code'];
        $lock_data['bill_no']=$adata['bill_no'];
        $lock_data['lock_time']=date('Y-m-d H:i:s');
        $res1=Db::name('whole_stock')->insert($adata);
        $res3=Db::name('ware_locked')->insert($lock_data);
        if($res1 && $res2 && $res3){
            Db::commit();
            $result=array('status'=>1,'bill_no'=>$adata['bill_no'],'msg'=>'操作成功');
        }else{
            Db::rollback();
            $result=array('status'=>0,'msg'=>'操作失败');
        }
        _end:
        return $result;
    }

    /**
     * 获取单条结存单信息
     */
    public static function getWholeInfo($bill_no=''){
        $result=array('status'=>0,'msg'=>'init');
        if(empty($bill_no)){
            $result['msg']='盘点单信息有误！';
            goto _end;
        }
        $field='a.*,w.ware_title';
        $result['data']=self::alias('a')->field($field)
            ->join('warehouse w','w.ware_code=a.ware_code','LEFT')
            ->where('a.bill_no','=',$bill_no)
            ->find();
        if($result['data']) $result['data']['f_date']=date('Y-m-d',strtotime($result['data']['f_date']));
        $dfield='ad.*,g.goods_name,g.specs,g.code as bar_code,g.file_name,g.pym,g.dosage,g.approval_code,g.origin,g.production,f.title as function_name,c.title as category_name,p.full_name as sup_name';
        $result['list']=Db::name('whole_stock_detail')->alias('ad')->field($dfield)
            ->join('commodity g','g.goods_code=ad.goods_code','LEFT')
            ->join('commodity_function f','f.id=g.function_id','LEFT')
            ->join('commodity_category c','c.id=g.category_id','LEFT')
            ->join('providers p','p.supplier_code=ad.sup_code','LEFT')
            ->where('ad.bill_no','=',$bill_no)->order('item_no asc')->select()->toArray();
        foreach ($result['list'] as $k=>$v){
            $result['list'][$k]['qty']=(float)$v['qty'];
            $result['list'][$k]['price']=(float)$v['price'];
            $result['list'][$k]['rqty']=(float)$v['rqty'];
            $result['list'][$k]['amount']=(float)$v['amount'];
            $result['list'][$k]['ramount']=(float)$v['ramount'];
            $result['list'][$k]['diff_qty']=(float)$v['diff_qty'];
            $result['list'][$k]['diff_amount']=(float)$v['diff_amount'];
            $result['list'][$k]['selprice']=(float)$v['selprice'];
            $result['list'][$k]['rtlprice']=(float)$v['rtlprice'];
            $result['list'][$k]['sel_amount']=calc([(float)$v['selprice'],'*',$v['rqty']],6,true);;
            $result['list'][$k]['rtl_amount']=calc([(float)$v['rtlprice'],'*',$v['rqty']],6,true);;
        }
        $result['status']=1;
        _end:
        return $result;
    }
    /**
     * 保存修改
     */
    public static function save_order($params,$request){
        $result=array('status'=>0,'msg'=>'init');
        if(!isset($params['data']['bill_no'])){
            $result['msg']='操作有误，请重试';
            goto _end;
        }
        if(empty($params['list'])){
            $result['msg']='没有盘点详情，不能保存';
            goto _end;
        }
        $validate=new WholeValid();
        $validate_res=$validate->scene('all')->check($params['data']);
        if(!$validate_res){
            $result['msg']=$validate->getError();
            goto _end;
        }
        $data['bill_no']=$params['data']['bill_no'];
        $data['empno']=$params['data']['empno'];
        $data['remark']=isset($params['data']['remark'])?$params['data']['remark']:null;
        $data['f_date']=date('Y-m-d');
        $data['ware_code']=$params['data']['ware_code'];
        $data['transfer']=0;
        $data['grup']=$request['depart'];
        $data['mender']=$request['code'];
        $data['update_date']=date('Y-m-d H:i:s');
        $list=$params['list'];
        $validate=new WholeValid();
        foreach ($list as $v){
            $validate_res=$validate->scene('exam')->check($v);
            if(!$validate_res){
                $result['msg']="序号为{$v['item_no']}的行".$validate->getError();
                goto _end;
            }
        }
        $new_list=array_chunk($list,50);
        Db::startTrans();
        foreach ($new_list as $detail){ //先处理删除 防止插入数据item_no冲突
            $item_arr='';
            unset($mdp);
            foreach ($detail as $v){
                if(!isset($v['isadd'])){
                    $item_arr.=$item_arr==''?$v['item_no']:','.$v['item_no'];
                }
            }
            $mdp[]=array('bill_no','=',$data['bill_no']);
            $mdp[]=array('item_no','not in',$item_arr);
            Db::name('whole_stock_detail')->where($mdp)->delete();//因不确定是否有删除详情，删除不做结果判断（只要下方插入时不序号不冲突即成功）
        }
        foreach ($new_list as $detail){
            $insert_data=array();
            foreach ($detail as $v){
                unset($updata);
                if(!isset($v['isadd'])){
                    $updata['pos_code']=isset($v['pos_code'])?$v['pos_code']:0;
                    $updata['price']=isset($v['price'])?floatval($v['price']):0;
                    $updata['qty']=floatval($v['qty']);
                    $updata['amount']=calc([$updata['qty'],'*',$updata['price']],6,true);
                    $updata['rqty']=floatval($v['rqty']);
                    $updata['ramount']=calc([$updata['price'],'*',$updata['rqty']],6,true);
                    $updata['diff_qty']=calc([$updata['rqty'],'-',$updata['qty']],5,true);
                    $updata['diff_amount']=calc([$updata['ramount'],'-',$updata['amount']],6,true);
                    $updata['sup_code']=isset($v['sup_code'])?$v['sup_code']:null;
                    $updata['remark']=isset($v['remark'])?$v['remark']:null;
                    $updata['batch_no']=isset($v['batch_no'])?$v['batch_no']:null;
                    $updata['prod_date']=isset($v['prod_date'])?$v['prod_date']:null;
                    $updata['valid_date']=isset($v['valid_date'])?$v['valid_date']:null;
                    $updata['update_ver']=time();
                    $updata=CommonFun::ProcessingData($updata);
                    $res=Db::name('whole_stock_detail')->where(['bill_no'=>$data['bill_no'],'item_no'=>$v['item_no']])->update($updata);
                    if(!$res){
                        Db::rollback();
                        $result['msg']='保存失败！';
                        goto _end;
                    }
                }else{
                    $idata['bill_no']=$data['bill_no'];
                    $idata['item_no']=$v['item_no'];
                    $idata['pos_code']=isset($v['pos_code'])?$v['pos_code']:null;
                    $idata['goods_code']=isset($v['goods_code'])?$v['goods_code']:null;
                    $idata['unit']=isset($v['unit'])?$v['unit']:null;
                    $idata['price']=isset($v['price'])?floatval($v['price']):0;
                    $idata['qty']=isset($v['qty'])?floatval($v['qty']):0;
                    $idata['amount']=calc([$idata['qty'],'*',$idata['price']],6,true);
                    $idata['rqty']=isset($v['rqty'])?floatval($v['rqty']):0;
                    $idata['ramount']=calc([$idata['price'],'*',$idata['rqty']],6,true);
                    $idata['diff_qty']=calc([$idata['rqty'],'-',$idata['qty']],5,true);
                    $idata['diff_amount']=calc([$idata['ramount'],'-',$idata['amount']],6,true);
                    $idata['batch_no']=isset($v['batch_no'])?$v['batch_no']:null;
                    $idata['prod_date']=isset($v['prod_date'])?$v['prod_date']:null;
                    $idata['valid_date']=isset($v['valid_date'])?$v['valid_date']:null;
                    $idata['sup_code']=isset($v['sup_code'])?$v['sup_code']:null;
                    $idata['remark']=isset($v['remark'])?$v['remark']:null;
                    $idata['selprice']=$v['selprice'];
                    $idata['rtlprice']=$v['rtlprice'];
                    $idata['stock_id']=isset($v['stock_id'])?$v['stock_id']:0;
                    $idata['update_ver']=time();
                    $insert_data[]=CommonFun::ProcessingData($idata);
                }
            }
            if(!empty($insert_data)){
                $res2=Db::name('whole_stock_detail')->insertAll($insert_data);
                if(!$res2){
                    Db::rollback();
                    $result['msg']='保存失败';
                    goto _end;
                }
            }
        }
        $res3=self::where('bill_no','=',$data['bill_no'])->update($data);
        if($res3){
            Db::commit();
            $result=array('status'=>1,'bill_no'=>$data['bill_no'],'msg'=>'保存成功');
        }else{
            Db::rollback();
            $result=array('status'=>1,'msg'=>'保存失败。');
        }
        _end:
        return $result;
    }
    /**
     * 整仓盘点单审核
     */
    public static function check_transfer($bill_no,$request){
        $result=array('status'=>0,'msg'=>'init');
        $binfo=self::field('transfer,ware_code')->where('bill_no','=',$bill_no)->find();
        if($binfo) $binfo=$binfo->toArray();
        if(!$binfo || (isset($binfo['transfer']) && $binfo['transfer']==1)){
            $result['msg']='订单已审核，请勿重复审核';
            goto _end;
        }
        if(!$binfo || (isset($binfo['ware_code']) && empty($binfo['ware_code']))){
            $result['msg']='盘点单未选择盘点仓库';
            goto _end;
        }
        $field='ad.item_no,ad.goods_code,ad.pos_code,ad.sup_code,ad.batch_no,ad.prod_date,ad.valid_date,ad.qty,ad.rqty,ad.price,ad.unit,ad.stock_id,g.is_solit,g.solit_value,sd.qty as yqty';
        $list=Db::name('whole_stock_detail')->alias('ad')->field($field)
            ->join('stock_details sd','sd.id=ad.stock_id','LEFT')
            ->join('commodity g','g.goods_code=ad.goods_code','LEFT')
            ->where('ad.bill_no','=',$bill_no)->select()->toArray();
        if (empty($list)){
            $result['msg']='没有盘点详情，不能审核';
            goto _end;
        }
        $validate=new WholeValid();
        $stock_id_arr='';
        foreach ($list as $v){
            $validate_res=$validate->scene('exam')->check($v);
            if(!$validate_res){
                $result['msg']="序号为{$v['item_no']}的行，".$validate->getError();
                goto _end;
            }
            if(intval($v['stock_id'])>0){
                $stock_id_arr.=$stock_id_arr==''?$v['stock_id']:','.$v['stock_id'];
            }
        }
        if($stock_id_arr!='') $ystock=Db::name('stock_details')->where('id','in',$stock_id_arr)->column('*','id');
        else $ystock=array();
        $map1[]=array('bill_no','=',$bill_no);
        $map1[]=array('transfer','=',0);
        $data1['auditno']=$request['code'];
        $data1['transfer']=1;
        Db::startTrans();
        $res1=self::where($map1)->update($data1);
        $insert_data=array();
        $inout_data=array();
        $now_date=date('Y-m-d H:i:s');
        foreach ($list as $v){
            unset($params);
            unset($iodata);//出入库记录
            $params=array('wareCode'=>$binfo['ware_code'],'posCode'=>$v['pos_code'],'supCode'=>$v['sup_code'],'goodsCode'=>$v['goods_code'],'batchNo'=>$v['batch_no']);
            $iodata['reforderid']=$bill_no;
            $iodata['item_no']=$v['item_no'];
            $iodata['goods_code']=$v['goods_code'];
            $iodata['order_date']=$now_date;
            $iodata['unit']=$v['unit'];
            $iodata['ware_code']=$binfo['ware_code'];
            $iodata['pos_code']=$v['pos_code'];
            $iodata['sup_code']=$v['sup_code'];
            if(intval($v['stock_id'])>0){
                if(!isset($ystock[$v['stock_id']])){
                    Db::rollback();
                    $result['msg']="序号为{$v['item_no']}的行，无法找到库存信息";
                    goto _end;
                }
                if(bccomp($v['rqty'],$v['qty'],6)==1){//盘点库存大于账面库存 (新增库存记录)
                    $iodata['inout_kind']=8;//盘盈入库
                    unset($ins);
                    $ins=$ystock[$v['stock_id']];
                    unset($ins['id']);
                    $ins['reforderid']=$bill_no;
                    $ins['inout_kind']=8;
                    $ins['item_no']=$v['item_no'];
                    $ins['qty']=bcsub($v['rqty'],$v['qty'],5);
                    $iodata['qty']=$ins['qty'];//出入库数量
                    $ins['qty1']=$v['is_solit']==1?intval($ins['qty']):$ins['qty'];
                    $ins['qty2']=$v['is_solit']==1?bcmul(bcsub($ins['qty'],$ins['qty1'],5),$v['solit_value'],5):0;
                    $ins['amount']=calc([$ins['qty'],'*',(float)$v['price']],6,true);
                    $iodata['account']=$ins['amount'];
                    $params['Qty_Num']=(float)$ins['qty'];
                    $params['Amount_Num']=(float)$ins['amount'];
                    $ins['updator']=$request['code'];
                    $ins['update_date']=$now_date;
                    $insert_data[]=$ins;
                }elseif (bccomp($v['rqty'],$v['qty'],5)==-1){//盘点库存小于账面库存 (更新库存记录)
                    $iodata['inout_kind']=58;//盘亏出库
                    unset($udata);
                    $udata['reforderid']=$bill_no;
                    $udata['item_no']=$v['item_no'];
                    $udata['qty']=$v['rqty'];
                    $iodata['qty']=bcsub($v['qty'],$v['rqty'],5);//出入库数量
                    $udata['qty1']=intval($udata['qty']);
                    $udata['qty2']=intval($v['is_solit'])==1?bcmul(bcsub($udata['qty'],$udata['qty1'],5),$v['solit_value'],5):0;
                    $udata['amount']=calc([$udata['qty'],'*',$v['price']],6,true);
                    $iodata['account']=calc([$iodata['qty'],'*',$v['price']],6,true);
                    $params['Qty_Num']=-(float)$iodata['qty'];
                    $params['Amount_Num']=(float)$iodata['account'];
                    $udata['updator']=$request['code'];
                    $udata['update_date']=$now_date;
                    $resup=Db::name('stock_details')->where('id','=',$v['stock_id'])->update($udata);
                    if(!$resup){
                        Db::rollback();
                        $result['msg']='更新库存失败，审核失败';
                        goto _end;
                    }
                }else{ //盘点库存等于账面库存
                    continue;
                }
            }else{//新增加的记录全部记为盘盈(入库)
                $iodata['inout_kind']=8;//盘盈入库
                unset($ins);
                $ins['reforderid']=$bill_no;
                $ins['item_no']=$v['item_no'];
                $ins['goods_code']=$v['goods_code'];
                $ins['inout_kind']=8;
                $ins['unit']=$v['unit'];
                $ins['batch_no']=$v['batch_no'];
                $ins['prod_date']=$v['prod_date'];
                $ins['valid_date']=$v['valid_date'];
                $ins['purch_date']=date('Y-m-d H:i:s');
                $ins['qty']=$v['rqty'];
                $iodata['qty']=$ins['qty'];//出入库数量
                $ins['qty1']=intval($v['is_solit'])==1?intval($ins['qty']):$ins['qty'];
                $ins['qty2']=intval($v['is_solit'])==1?bcmul(bcsub($ins['qty'],$ins['qty1'],5),$v['solit_value'],5):0;
                $ins['price1']=$v['price'];
                if(bccomp(floatval($ins['price1']),0,6)==1 && intval($v['is_solit'])==1) $ins['price2']=calc([$ins['price1'],'/',$v['solit_value']],6,true);
                else $ins['price2']=null;
                $ins['amount']=calc([$ins['qty'],'*',floatval($ins['price1'])],6,true);
                $iodata['account']=$ins['amount'];
                $params['Qty_Num']=(float)$ins['qty'];
                $params['Amount_Num']=(float)$ins['amount'];
                $ins['ware_code']=$binfo['ware_code'];
                $ins['pos_code']=$v['pos_code'];
                $ins['sup_code']=$v['sup_code'];
                $ins['inqty']=$ins['qty'];
                $ins['updator']=$request['code'];
                $ins['update_date']=$now_date;
                $insert_data[]=$ins;
            }
            $iodata['price']=(float)$v['price'];
            $iodata['batch_no']=$v['batch_no'];
            $iodata['prod_date']=$v['prod_date'];
            $iodata['valid_date']=$v['valid_date'];
            $iodata['creator']=$request['code'];
            $iodata['create_date']=$now_date;
            $inout_data[]=$iodata;
            $params['prodDate']=$v['prod_date'];
            $params['validDate']=$v['valid_date'];
            $params['goodsState']='';
            $params['qualityState']='';
            $params['convRatePercent']=(float)$v['solit_value'];
            $params['hasSplit']=$v['is_solit'];
            $res_tot=Db::execute('CALL insertOrUpdateStockBatch(:wareCode,:posCode,:supCode,:goodsCode,:batchNo,:Qty_Num,:Amount_Num,:prodDate,:validDate,:goodsState,:qualityState,:convRatePercent,:hasSplit)',$params);
            if(!$res_tot){
                Db::rollback();
                $result['msg']='更新库存总表失败';
                goto _end;
            }
        }
        if(!empty($insert_data)) $res2=Db::name('stock_details')->insertAll($insert_data);//库存详情
        else $res2=1;
        if(!empty($inout_data)) $res3=Db::name('stock_goodsinout')->insertAll($inout_data);//出入库记录
        else $res3=1;
        $res4=Db::name('ware_locked')->where('bill_no','=',$bill_no)->delete();
        if($res1 && $res2 && $res3 && $res4){
            Db::commit();
            $result=array('status'=>1,'msg'=>'审核成功');
        }else{
            Db::rollback();
            $result=array('status'=>0,'msg'=>'审核失败');
        }
        _end:
        return $result;
    }
    /**
     * 删除整仓盘点单
     */
    public static function del_order($bill_no){
        $result=array('status'=>0,'msg'=>'init');
        $binfo=self::field('transfer')->where('bill_no','=',$bill_no)->find();
        if($binfo){
            $binfo=$binfo->toArray();
            if(isset($binfo['transfer']) && $binfo['transfer']==1){
                $result['msg']='订单已审核，不能删除';
                goto _end;
            }
            $res=self::where('bill_no','=',$bill_no)->delete();
            if ($res) $result=array('status'=>1,'msg'=>'删除成功');
            else $result=array('status'=>0,'msg'=>'删除失败');
        }else{
            $result['msg']='订单不存在，请刷新重试';
            goto _end;
        }
        _end:
        return $result;
    }
}