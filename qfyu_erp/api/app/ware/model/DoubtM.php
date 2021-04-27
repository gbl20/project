<?php
namespace app\ware\model;
use app\helper\CommonFun;
use think\facade\Db;
use think\Model;

class DoubtM extends Model
{
    /**
     * 即时盘点单列表
     */
    public static function stocklist($map=[],$page,$order='sd.update_date desc',$pageSize=100){
        $field='sd.*,w.ware_title,c.goods_name,c.specs,c.dosage,c.production,c.origin,c.approval_code,p.name as sup_name';
        $list=Db::name('stock_details')->alias('sd')->field($field)
            ->join('commodity c','c.goods_code=sd.goods_code','LEFT')
            ->join('warehouse w','w.ware_code=sd.ware_code','LEFT')
            ->join('providers p','p.supplier_code=sd.sup_code','LEFT')
            ->where($map)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }

    /**
     * 锁定质量疑问产品库存 (锁定单个)
     */
    public static function lockDrugOne($params,$request){
        $result=array('status'=>0,'msg'=>'init');
        if(!isset($params['stock_id']) || !isset($params['qty']) || !isset($params['remark'])){
            $result['msg']='操作错误';
            goto _end;
        }
        $stock=Db::name('warehouse')->field('ware_code,pos_code')->where('flag','=','-1')->find();
        if(!$stock){
            $result['msg']='没有设置疑问仓，请先设置好疑问仓';
            goto _end;
        }
        if(!empty($stock['pos_code'])){
            $mop[]=array('pos_code','=',$stock['pos_code']);
            $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
            if(!$pos_code){
                $mop[]=array('ware_code','=',$stock['ware_code']);
                $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
            }
        }else{
            $mop[]=array('ware_code','=',$stock['ware_code']);
            $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
        }
        if(!$pos_code){
            $result['msg']='疑问仓没有货位，请先添加货位';
            goto _end;
        }
        $data['locked_qty']=floatval($params['qty']);
        $sotck_info=Db::name('stock_details')->alias('s')->field('s.*,g.is_solit,g.solit_value')
            ->join('commodity g','g.goods_code=s.goods_code','LEFT')
            ->where('s.id','=',$params['stock_id'])->find();
        if(!$sotck_info){
            $result['msg']='操作有误';
            goto _end;
        }
        $ware_locked=Db::name('ware_locked')->field('bill_no')->where('ware_code','=',$sotck_info['ware_code'])->find();
        if($ware_locked){
            $result['msg']="当前仓库{$sotck_info['ware_code']}被单号 {$ware_locked['bill_no']} 锁定";
            goto _end;
        }
        if(bccomp($sotck_info['qty'],$data['locked_qty'],5)==-1){
            $result['msg']='库存不足(库存：'.floatval($sotck_info['qty']).')';
            goto _end;
        }
        $data['bill_no']=CommonFun::createOrder('DO');
        $data['fdate']=date('Y-m-d H:i:s');
        $data['goods_code']=$sotck_info['goods_code'];
        $data['batch_no']=$sotck_info['batch_no'];
        $data['ware_code']=$sotck_info['ware_code'];
        $data['pos_code']=$sotck_info['pos_code'];
        $data['sup_code']=$sotck_info['sup_code'];
        $data['stock_qty']=$sotck_info['qty'];
        $data['unit']=$sotck_info['unit'];
        $data['price']=$sotck_info['price1'];
        $data['amount']=$sotck_info['amount'];
        $data['prod_date']=$sotck_info['prod_date'];
        $data['valid_date']=$sotck_info['valid_date'];
        $data['stock_id']=$sotck_info['id'];
        $data['lock_ware_code']=$stock['ware_code'];
        $data['lock_man']=$request['code'];
        $data['remark']=$params['remark'];
        $data['status']=0;
        $data['locked_amount']=calc([$data['locked_qty'],'*',$data['price']],6,true);
        $data['goods_state']=$params['goods_state'];
        $data['quality_state']=$params['quality_state'];
        $out_data=array('ginfo'=>$sotck_info,'out_num'=>$data['locked_qty'],'bill_no'=>$data['bill_no']);
        $in_data=array('ware_code'=>$stock['ware_code'],'pos_code'=>$pos_code,'goods_state'=>$data['goods_state'],'quality_state'=>$data['quality_state']);
        $params_exe['wareCode']=$stock['ware_code'];
        $params_exe['posCode']=$stock['pos_code'];
        $params_exe['supCode']=$sotck_info['sup_code'];
        $params_exe['goodsCode']=$sotck_info['goods_code'];
        $params_exe['batchNo']=$sotck_info['batch_no'];
        $params_exe['Qty_Num']=-(float)$data['locked_qty'];
        $params_exe['Amount_Num']=-(float)calc([$data['locked_qty'],'*',$data['price']],6,true);
        $params_exe['prodDate']=$data['prod_date'];
        $params_exe['validDate']=$data['valid_date'];
        $params_exe['goodsState']='';
        $params_exe['qualityState']='';
        $params_exe['convRatePercent']=(float)$sotck_info['solit_value'];
        $params_exe['hasSplit']=$sotck_info['is_solit'];
        Db::startTrans();
        $inout_res=self::goods_inout($out_data,$in_data,$request);
        $res_tot=Db::execute('CALL insertOrUpdateStockBatch(:wareCode,:posCode,:supCode,:goodsCode,:batchNo,:Qty_Num,:Amount_Num,:prodDate,:validDate,:goodsState,:qualityState,:convRatePercent,:hasSplit)',$params_exe);
        if($inout_res['status']==1 && $res_tot){
            $res=Db::name('drug_locked')->insert($data);
            if($res){
                Db::commit();
                $result=array('status'=>1,'msg'=>'操作成功');
            }else{
                Db::rollback();
                $result=array('status'=>0,'msg'=>'操作失败');
            }
        }else{
            Db::rollback();
            $result['msg']='出入库操作失败';
            $result['ymsg']=$inout_res['res'];
        }
        _end:
        return $result;
    }

    /**
     * 锁定质量疑问产品库存 (锁定当前产品 所有同批次产品)
     */
    public static function lockDrugAll($params,$request){
        if(!isset($params['stock_id'])){
            $result['msg']='操作错误';
            goto _end;
        }
        $stock_id=$params['stock_id'];
        $yinfo=Db::name('stock_details')->field('batch_no,ware_code,goods_code')->where('id','=',$stock_id)->find();
        if(!$yinfo){
            $result['msg']='操作有误';
            goto _end;
        }
        $stock=Db::name('warehouse')->field('ware_code,pos_code')->where('flag','=','-1')->find();
        if(!$stock){
            $result['msg']='没有设置疑问仓，请先设置好疑问仓';
            goto _end;
        }
        if(!empty($stock['pos_code'])){
            $mop[]=array('pos_code','=',$stock['pos_code']);
            $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
            if(!$pos_code){
                $mop[]=array('ware_code','=',$stock['ware_code']);
                $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
            }
        }else{
            $mop[]=array('ware_code','=',$stock['ware_code']);
            $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
        }
        if(!$pos_code){
            $result['msg']='疑问仓没有货位，请先添加货位';
            goto _end;
        }
        $ware_locked=Db::name('ware_locked')->field('bill_no')->where('ware_code','=',$yinfo['ware_code'])->find();
        if($ware_locked){
            $result['msg']="当前仓库{$yinfo['ware_code']}被单号 {$ware_locked['bill_no']} 锁定";
            goto _end;
        }
        $mlp[]=array('s.goods_code','=',$yinfo['goods_code']);
        $mlp[]=array('s.ware_code','=',$yinfo['ware_code']);
        $mlp[]=array('s.batch_no','=',$yinfo['batch_no']);
        $list=Db::name('stock_details')->alias('s')->field('s.*,g.is_solit,g.solit_value')
            ->join('commodity g','g.goods_code=s.goods_code','LEFT')
            ->where($mlp)->select()->toArray();
        $data=array();
        $date_time=date('Y-m-d H:i:s');
        Db::startTrans();
        foreach ($list as $v){
            unset($min_data);
            $min_data['bill_no']=CommonFun::createOrder('DO');
            $min_data['fdate']=$date_time;
            $min_data['goods_code']=$v['goods_code'];
            $min_data['batch_no']=$v['batch_no'];
            $min_data['ware_code']=$v['ware_code'];
            $min_data['pos_code']=$v['pos_code'];
            $min_data['sup_code']=$v['sup_code'];
            $min_data['stock_qty']=$v['qty'];
            $min_data['locked_qty']=$v['qty'];
            $min_data['unit']=$v['unit'];
            $min_data['price']=$v['price1'];
            $min_data['amount']=$v['amount'];
            $min_data['prod_date']=$v['prod_date'];
            $min_data['valid_date']=$v['valid_date'];
            $min_data['stock_id']=$v['id'];
            $min_data['lock_ware_code']=$stock['ware_code'];
            $min_data['lock_man']=$request['code'];
            $min_data['remark']=$params['remark'];
            $min_data['status']=0;
            $min_data['locked_amount']=calc([$min_data['locked_qty'],'*',$min_data['price']],6,true);
            $min_data['goods_state']=$params['goods_state'];
            $min_data['quality_state']=$params['quality_state'];
            $data[]=$min_data;
            $out_data=array('ginfo'=>$v,'out_num'=>$v['qty'],'bill_no'=>$min_data['bill_no']);
            $in_data=array('ware_code'=>$stock['ware_code'],'pos_code'=>$pos_code,'goods_state'=>$params['goods_state'],'quality_state'=>$params['quality_state']);
            $inout_res=self::goods_inout($out_data,$in_data,$request);
            $params_exe['wareCode']=$stock['ware_code'];
            $params_exe['posCode']=$stock['pos_code'];
            $params_exe['supCode']=$v['sup_code'];
            $params_exe['goodsCode']=$v['goods_code'];
            $params_exe['batchNo']=$v['batch_no'];
            $params_exe['Qty_Num']=-(float)$v['qty'];
            $params_exe['Amount_Num']=-(float)calc([$v['qty'],'*',$v['price1']],6,true);
            $params_exe['prodDate']=$v['prod_date'];
            $params_exe['validDate']=$v['valid_date'];
            $params_exe['goodsState']='';
            $params_exe['qualityState']='';
            $params_exe['convRatePercent']=(float)$v['solit_value'];
            $params_exe['hasSplit']=$v['is_solit'];
            $res_tot=Db::execute('CALL insertOrUpdateStockBatch(:wareCode,:posCode,:supCode,:goodsCode,:batchNo,:Qty_Num,:Amount_Num,:prodDate,:validDate,:goodsState,:qualityState,:convRatePercent,:hasSplit)',$params_exe);
            if($inout_res['status']!=1 || !$res_tot){
                Db::rollback();
                $result['msg']='出入库操作失败';
                $result['ymsg']=$inout_res['res'];
                goto _end;
            }
        }
        $res=Db::name('drug_locked')->insertAll($data);
        if($res){
            Db::commit();
            $result=array('status'=>1,'msg'=>'操作成功');
        }else{
            Db::rollback();
            $result=array('status'=>0,'msg'=>'操作失败');
        }
        _end:
        return $result;
    }

    /**
     * 疑问产品先从原库出库，再入到疑问库
     */
    private static function goods_inout($out_data,$in_data,$request){
        $result=array('status'=>0,'msg'=>'init');
        $ginfo=$out_data['ginfo'];
        $map1[]=array('id','=',$ginfo['id']);
        $map1[]=array('qty','>=',$out_data['out_num']);
        $data1['reforderid']=$out_data['bill_no'];
        $data1['qty']=Db::raw('`qty`-'.$out_data['out_num']);
        $data1['qty1']=Db::raw('floor(`qty`)');
        $data1['qty2']=$ginfo['is_solit']==1?Db::raw('round((`qty`-`qty1`)*'.$ginfo['is_solit'].',5)'):0;
        $data1['amount']=Db::raw('round(`qty`*`price1`,6)');
        $data1['updator']=$request['code'];
        $data1['update_date']=date('Y-m-d H:i:s');
        $res1=Db::name('stock_details')->where($map1)->update($data1);
        /*****************************************/
        $data3['reforderid']=$out_data['bill_no'];
        $data3['item_no']=1;
        $data3['stock_id']=$ginfo['id'];
        $data3['goods_code']=$ginfo['goods_code'];
        $data3['order_date']=date('Y-m-d H:i:s');
        $data3['unit']=$ginfo['unit'];
        $data3['ware_code']=$ginfo['ware_code'];
        $data3['pos_code']=$ginfo['pos_code'];
        $data3['sup_code']=$ginfo['sup_code'];
        $data3['inout_kind']=60;//锁定出库
        $data3['qty']=$out_data['out_num'];
        $data3['price']=$ginfo['price1'];
        $data3['account']=calc([$data3['qty'],'*',$data3['price']],6,true);
        $data3['batch_no']=$ginfo['batch_no'];
        $data3['prod_date']=$ginfo['prod_date'];
        $data3['valid_date']=$ginfo['valid_date'];
        $data3['goods_state']=$in_data['goods_state'];
        $data3['quality_state']=$in_data['quality_state'];
        $data3['creator']=$request['code'];
        $data3['create_date']=date('Y-m-d H:i:s');
        $res3=Db::name('stock_goodsinout')->insert($data3);
        /*****************************************/
        $data2['reforderid']=$out_data['bill_no'];
        $data2['item_no']=1;
        $data2['goods_code']=$ginfo['goods_code'];
        $data2['inout_kind']=16;//锁定入库
        $data2['unit']=$ginfo['unit'];
        $data2['batch_no']=$ginfo['batch_no'];
        $data2['prod_date']=$ginfo['prod_date'];
        $data2['valid_date']=$ginfo['valid_date'];
        $data2['purch_date']=$ginfo['purch_date'];
        $data2['qty']=$out_data['out_num'];
        $data2['qty1']=$ginfo['is_solit']==1?intval($data2['qty']):$data2['qty'];
        $data2['qty2']=$ginfo['is_solit']==1?bcmul(bcsub($data2['qty'],$data2['qty1'],5),$ginfo['solit_value'],5):0;
        $data2['price1']=$ginfo['price1'];
        $data2['price2']=$ginfo['price2'];
        $data2['amount']=calc([$data2['qty'],'*',$data2['price1']],6,true);
        $data2['ware_code']=$in_data['ware_code'];
        $data2['pos_code']=$in_data['pos_code'];
        $data2['sup_code']=$ginfo['sup_code'];
        $data2['inqty']=$out_data['out_num'];
        $data2['goods_state']=$in_data['goods_state'];
        $data2['quality_state']=$in_data['quality_state'];
        $data2['updator']=$request['code'];
        $data2['update_date']=date('Y-m-d H:i:s');
        $res2=Db::name('stock_details')->insertGetId($data2);
        /*****************************************/
        $data4['reforderid']=$out_data['bill_no'];
        $data4['item_no']=1;
        $data4['stock_id']=$res2;
        $data4['goods_code']=$ginfo['goods_code'];
        $data4['order_date']=date('Y-m-d H:i:s');
        $data4['unit']=$ginfo['unit'];
        $data4['ware_code']=$in_data['ware_code'];
        $data4['pos_code']=$in_data['pos_code'];
        $data4['sup_code']=$ginfo['sup_code'];
        $data4['inout_kind']=16;//锁定入库
        $data4['qty']=$out_data['out_num'];
        $data4['price']=$ginfo['price1'];
        $data4['account']=calc([$data4['qty'],'*',$data4['price']],6,true);
        $data4['batch_no']=$ginfo['batch_no'];
        $data4['prod_date']=$ginfo['prod_date'];
        $data4['valid_date']=$ginfo['valid_date'];
        $data4['goods_state']=$in_data['goods_state'];
        $data4['quality_state']=$in_data['quality_state'];
        $data4['creator']=$request['code'];
        $data4['create_date']=date('Y-m-d H:i:s');
        $res4=Db::name('stock_goodsinout')->insert($data4);
        $result['msg']="res1:{$res1} res2:{$res2} res3:{$res3} res4:$res4";
        if($res1 && $res2 && $res3 && $res4) $result['status']=1;
        return $result;
    }

    /**
     * 疑问列表
     */
    public static function lockList($map=[],$page,$order='d.fdate desc',$pageSize=100){
        $field='d.*,w.ware_title,c.goods_name,c.specs,c.dosage,c.production,c.origin,c.approval_code,p.name as sup_name';
        $list=Db::name('drug_locked')->alias('d')->field($field,'stock_qty,locked_qty,eqty,reqty')
            ->join('commodity c','c.goods_code=d.goods_code','LEFT')
            ->join('warehouse w','w.ware_code=d.ware_code','LEFT')
            ->join('providers p','p.supplier_code=d.sup_code','LEFT')
            ->where($map)
            ->order($order)
            ->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        $stock=Db::name('warehouse')->field('ware_code,ware_title')->where('flag','=','-1')->find();
        $status_arr=array(0=>'未处理',1=>'已处理');
        foreach ($list['data'] as $k=>$v){
            $list['data'][$k]['lock_ware_code']=$stock['ware_code'];
            $list['data'][$k]['lock_ware_title']=$stock['ware_title'];
            $list['data'][$k]['status_txt']=isset($status_arr[$v['status']])?$status_arr[$v['status']]:'';
        }
        return $list;
    }
    /**
     * 处理质量疑问商品  疑问商品锁定需要减总库存（调存储过程） 疑问商品解锁为合格商品需要加总库存
     */
    public static function unlock($params,$request){
        $result=array('status'=>0,'msg'=>'init');
        $stock=Db::name('warehouse')->field('ware_code,pos_code')->where('flag','=','-2')->find();
        if(!$stock){
            $result['msg']='没有设置不合格品仓库，请先设置好不合格品仓库';
            goto _end;
        }
        if(!empty($stock['pos_code'])){
            $mop[]=array('pos_code','=',$stock['pos_code']);
            $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
            if(!$pos_code){
                $mop[]=array('ware_code','=',$stock['ware_code']);
                $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
            }
        }else{
            $mop[]=array('ware_code','=',$stock['ware_code']);
            $pos_code=Db::name('ware_position')->where($mop)->value('pos_code');
        }
        $linfo=Db::name('drug_locked')->alias('s')->field('s.*,g.is_solit,g.solit_value,sd.price1,sd.price2,sd.pos_code as lock_pos_code,sd.id as lock_stock_id,sd.purch_date,sd.inqty')
            ->join('stock_details sd','sd.reforderid=s.bill_no and sd.ware_code=s.lock_ware_code','LEFT')
            ->join('commodity g','g.goods_code=s.goods_code','LEFT')
            ->where('s.bill_no','=',$params['bill_no'])->find();
        if(!$linfo){
            $result['msg']='单据信息有误';
            goto _end;
        }
        if($linfo['status']!=0){
            $result['msg']='单据不是锁定状态，请勿重复操作';
            goto _end;
        }
        $subqty=bcadd($params['eqty'],$params['reqty'],5);
        if(bccomp($subqty,$linfo['locked_qty'])!=0){
            $result['msg']='解锁数量与锁定数量不一致，请重新输入解锁数量';
            goto _end;
        }
        $data1['status']=1;
        $data1['unlock_man']=$request['code'];
        $data1['unlock_date']=date('Y-m-d H:i:s');
        $data1['eqty']=floatval($params['eqty']);
        $data1['unlock_remark']=trim($params['unlock_remark']);
        Db::startTrans();
        $res1=Db::name('drug_locked')->where('bill_no','=',$params['bill_no'])->update($data1);//质量疑问表解锁
        $map2[]=array('id','=',$linfo['lock_stock_id']);
        $map2[]=array('qty','=',$linfo['locked_qty']);
        $data2['qty']=0;
        $data2['qty1']=0;
        $data2['qty2']=0;
        $data2['amount']=0;
        $data2['updator']=$request['code'];
        $data2['update_date']=date('Y-m-d H:i:s');
        $res2=Db::name('stock_details')->where($map2)->update($data2);//疑问产品出库
        $data3['reforderid']=$linfo['bill_no'];
        $data3['item_no']=1;
        $data3['stock_id']=$linfo['lock_stock_id'];
        $data3['goods_code']=$linfo['goods_code'];
        $data3['order_date']=date('Y-m-d H:i:s');
        $data3['unit']=$linfo['unit'];
        $data3['ware_code']=$linfo['lock_ware_code'];
        $data3['pos_code']=$linfo['lock_pos_code'];
        $data3['sup_code']=$linfo['sup_code'];
        $data3['inout_kind']=59;//锁定出库
        $data3['qty']=$linfo['locked_qty'];
        $data3['price']=$linfo['price1'];
        $data3['account']=calc([$data3['qty'],'*',$data3['price']],6,true);
        $data3['batch_no']=$linfo['batch_no'];
        $data3['prod_date']=$linfo['prod_date'];
        $data3['valid_date']=$linfo['valid_date'];
        $data3['goods_state']=$linfo['goods_state'];
        $data3['quality_state']=$linfo['quality_state'];
        $data3['creator']=$request['code'];
        $data3['create_date']=date('Y-m-d H:i:s');
        $res3=Db::name('stock_goodsinout')->insert($data3);//出库记录
        $res4=1;
        $res5=1;
        $res_tot=1;
        $res6=1;
        $res7=1;
        $res8=1;
        if($params['eqty']>0){//有合格品  则入库合格品到原仓库
            $data4['reforderid']=$linfo['bill_no'];
            $data4['item_no']=1;
            $data4['goods_code']=$linfo['goods_code'];
            $data4['inout_kind']=17;//解锁入库
            $data4['unit']=$linfo['unit'];
            $data4['batch_no']=$linfo['batch_no'];
            $data4['prod_date']=$linfo['prod_date'];
            $data4['valid_date']=$linfo['valid_date'];
            $data4['purch_date']=$linfo['purch_date'];
            $data4['qty']=floatval($params['eqty']);
            $data4['qty1']=$linfo['is_solit']==1?intval($data4['qty']):$data4['qty'];
            $data4['qty2']=$linfo['is_solit']==1?bcmul(bcsub($data4['qty'],$data4['qty1'],5),$linfo['solit_value'],5):0;
            $data4['price1']=$linfo['price1'];
            $data4['price2']=$linfo['price2'];
            $data4['amount']=calc([$data4['qty'],'*',$data4['price1']],6,true);
            $data4['ware_code']=$linfo['ware_code'];
            $data4['pos_code']=$linfo['pos_code'];
            $data4['sup_code']=$linfo['sup_code'];
            $data4['inqty']=$data4['qty'];
            $data4['goods_state']=$params['goods_state'];
            $data4['quality_state']=$params['quality_state'];
            $data4['updator']=$request['code'];
            $data4['update_date']=date('Y-m-d H:i:s');
            $res4=Db::name('stock_details')->insertGetId($data4);//合格品入库
            /*****************************************/
            $data5['reforderid']=$linfo['bill_no'];
            $data5['item_no']=1;
            $data5['stock_id']=$res4;
            $data5['goods_code']=$linfo['goods_code'];
            $data5['order_date']=date('Y-m-d H:i:s');
            $data5['unit']=$linfo['unit'];
            $data5['ware_code']=$linfo['ware_code'];
            $data5['pos_code']=$linfo['pos_code'];
            $data5['sup_code']=$linfo['sup_code'];
            $data5['inout_kind']=17;//解锁入库
            $data5['qty']=floatval($params['eqty']);
            $data5['price']=$linfo['price1'];
            $data5['account']=calc([$data5['qty'],'*',$data5['price']],6,true);
            $data5['batch_no']=$linfo['batch_no'];
            $data5['prod_date']=$linfo['prod_date'];
            $data5['valid_date']=$linfo['valid_date'];
            $data5['goods_state']=$params['goods_state'];
            $data5['quality_state']=$params['quality_state'];
            $data5['creator']=$request['code'];
            $data5['create_date']=date('Y-m-d H:i:s');
            $res5=Db::name('stock_goodsinout')->insert($data5);//合格品出入库记录
            $params_exe['wareCode']=$stock['ware_code'];
            $params_exe['posCode']=$pos_code;
            $params_exe['supCode']=$linfo['sup_code'];
            $params_exe['goodsCode']=$linfo['goods_code'];
            $params_exe['batchNo']=$linfo['batch_no'];
            $params_exe['Qty_Num']=$data5['qty'];
            $params_exe['Amount_Num']=(float)calc([$data5['qty'],'*',$data5['price']],6,true);
            $params_exe['prodDate']=$linfo['prod_date'];
            $params_exe['validDate']=$linfo['valid_date'];
            $params_exe['goodsState']='';
            $params_exe['qualityState']='';
            $params_exe['convRatePercent']=(float)$linfo['solit_value'];
            $params_exe['hasSplit']=$linfo['is_solit'];
            $res_tot=Db::execute('CALL insertOrUpdateStockBatch(:wareCode,:posCode,:supCode,:goodsCode,:batchNo,:Qty_Num,:Amount_Num,:prodDate,:validDate,:goodsState,:qualityState,:convRatePercent,:hasSplit)',$params_exe);
        }
        if($params['reqty']>0){//有不合格品 则入库到不合格品仓库
            $data6['reforderid']=$linfo['bill_no'];
            $data6['item_no']=1;
            $data6['goods_code']=$linfo['goods_code'];
            $data6['inout_kind']=17;//解锁入库
            $data6['unit']=$linfo['unit'];
            $data6['batch_no']=$linfo['batch_no'];
            $data6['prod_date']=$linfo['prod_date'];
            $data6['valid_date']=$linfo['valid_date'];
            $data6['purch_date']=$linfo['purch_date'];
            $data6['qty']=floatval($params['reqty']);
            $data6['qty1']=$linfo['is_solit']==1?intval($data6['qty']):$data6['qty'];
            $data6['qty2']=$linfo['is_solit']==1?bcmul(bcsub($data6['qty'],$data6['qty1'],5),$linfo['solit_value'],5):0;
            $data6['price1']=$linfo['price1'];
            $data6['price2']=$linfo['price2'];
            $data6['amount']=calc([$data6['qty'],'*',$data6['price1']],6,true);
            $data6['ware_code']=$stock['ware_code'];
            $data6['pos_code']=$pos_code;
            $data6['sup_code']=$linfo['sup_code'];
            $data6['inqty']=$data6['qty'];
            $data6['goods_state']=$params['goods_state'];
            $data6['quality_state']=$params['quality_state'];
            $data6['updator']=$request['code'];
            $data6['update_date']=date('Y-m-d H:i:s');
            $res6=Db::name('stock_details')->insertGetId($data6);//不合格品入库
            /*****************************************/
            $data7['reforderid']=$linfo['bill_no'];
            $data7['item_no']=1;
            $data7['stock_id']=$res6;
            $data7['goods_code']=$linfo['goods_code'];
            $data7['order_date']=date('Y-m-d H:i:s');
            $data7['unit']=$linfo['unit'];
            $data7['ware_code']=$stock['ware_code'];
            $data7['pos_code']=$pos_code;
            $data7['sup_code']=$linfo['sup_code'];
            $data7['inout_kind']=17;//解锁入库
            $data7['qty']=floatval($params['reqty']);
            $data7['price']=$linfo['price1'];
            $data7['account']=calc([$data7['qty'],'*',$data7['price']],6,true);
            $data7['batch_no']=$linfo['batch_no'];
            $data7['prod_date']=$linfo['prod_date'];
            $data7['valid_date']=$linfo['valid_date'];
            $data7['goods_state']=$params['rgoods_state'];
            $data7['quality_state']=$params['rquality_state'];
            $data7['creator']=$request['code'];
            $data7['create_date']=date('Y-m-d H:i:s');
            $res7=Db::name('stock_goodsinout')->insert($data7);//不合格品出入库记录
            $data8['f_date']=date('Y-m-d H:i:s');
            $data8['goods_code']=$linfo['goods_code'];
            $data8['unit']=$linfo['unit'];
            $data8['qty']=$data7['qty'];
            $data8['price']=$data7['price'];
            $data8['amount']=$data7['account'];
            $data8['batch_no']=$data7['batch_no'];
            $data8['sup_code']=$data7['sup_code'];
            $data8['prod_date']=$data7['prod_date'];
            $data8['valid_date']=$data7['valid_date'];
            $data8['purch_date']=$linfo['purch_date'];
            $data8['inqty']=$linfo['inqty'];
            $data8['ware_code']=$stock['ware_code'];
            $data8['pos_code']=$pos_code;
            $data8['detec_date']=$linfo['fdate'];
            $data8['detec_tache']=trim($params['detect_tache']);
            $data8['creater']=$request['code'];
            $data8['src_bill_no']=$linfo['bill_no'];
            $data8['goods_state']=$params['rgoods_state'];
            $data8['quality_state']=$params['rquality_state'];
            $res8=Db::name('reject_confirm')->insert($data8);
        }
        if($res1 && $res2 && $res3 && $res4 && $res5 && $res_tot && $res6 && $res7 && $res8){
            Db::commit();
            $result=array('status'=>1,'msg'=>'解锁成功');
        }else{
            Db::rollback();
            $result=array('status'=>1,'msg'=>'解锁失败');
        }
        _end:
        return $result;
    }
}