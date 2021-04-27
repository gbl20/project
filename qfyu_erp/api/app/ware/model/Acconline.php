<?php
namespace app\ware\model;
use app\helper\CommonFun;
use app\ware\validate\AcconlineValid;
use think\facade\Db;
use think\Model;

class Acconline extends Model
{
    /**
     * 即时盘点单列表
     */
    public static function getOnlineList($map=[],$page,$order='create_date desc',$pageSize=100){
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
     * 获取单条即时盘点单信息
     */
    public static function getRealInfo($bill_no='',$item_no=[]){
        if(!empty($bill_no)){
            if(!empty($item_no)) $mdp[]=array('ad.item_no','in',$item_no);
            $mdp[]=array('ad.bill_no','=',$bill_no);
            $field='a.*,w.ware_title';
            $res['data']=self::alias('a')->field($field)
                ->join('warehouse w','w.ware_code=a.ware_code','LEFT')
                ->where('a.bill_no','=',$bill_no)
                ->find();
            if($res['data']) $res['data']['f_date']=date('Y-m-d',strtotime($res['data']['f_date']));
            $dfield='ad.*,g.goods_name,g.specs,g.code as bar_code,g.unit,g.unit2,g.file_name,g.pym,g.dosage,g.approval_code,g.origin,g.production,f.title as function_name,c.title as category_name,p.full_name as sup_name,pr.price1 as selprice,pr2.price1 as rtlprice';
            $res['list']=Db::name('acconline_detail')->alias('ad')->field($dfield)
                ->join('commodity g','g.goods_code=ad.goods_code','LEFT')
                ->join('commodity_function f','f.id=g.function_id','LEFT')
                ->join('commodity_category c','c.id=g.category_id','LEFT')
                ->join('commodity_price pr','pr.goods_code=ad.goods_code AND pr.mode_id=2','LEFT')
                ->join('commodity_price pr2','pr2.goods_code=ad.goods_code AND pr2.mode_id=3','LEFT')
                ->join('providers p','p.supplier_code=ad.sup_code','LEFT')
                ->where($mdp)->order('ad.item_no asc')->select()->toArray();
            foreach ($res['list'] as $k=>$v){
                $res['list'][$k]['sel_amount']=calc([(float)$v['selprice'],'*',$v['rqty']],6,true);
                $res['list'][$k]['rtl_amount']=calc([(float)$v['rtlprice'],'*',$v['rqty']],6,true);
            }
        }else{
            $res['data']=array('f_date'=>date('Y-m-d'));
            $res['list']=array();
        }
        return $res;
    }

    /**
     * 选择产品 调出库存记录
     */
    public static function getStockList($params){
        $map[]=array('g.goods_code','=',$params['goods_code']);
        $maxkey=intval($params['maxkey']);
        $field='s.*,g.goods_name,g.specs,g.code as bar_code,g.unit,g.unit2,g.file_name,g.pym,g.dosage,g.approval_code,g.origin,g.production,f.title as function_name,c.title as category_name,p.full_name as sup_name';
        $list_sql=Db::name('commodity')->alias('g')->field($field);
        if(isset($params['noqty']) && $params['noqty']==1) $list_sql->join('stock_details s',"g.goods_code=s.goods_code AND s.ware_code='{$params['ware_code']}'",'LEFT');
        else $list_sql->join('stock_details s',"g.goods_code=s.goods_code AND s.ware_code='{$params['ware_code']}' AND s.qty>0",'LEFT');
        $list=$list_sql->join('commodity_function f','f.id=g.function_id','LEFT')
            ->join('commodity_category c','c.id=g.category_id','LEFT')
            ->join('providers p','p.supplier_code=s.sup_code','LEFT')
            ->where($map)->order('s.item_no asc')->select()->toArray();
        $mrp[]=array('goods_code','=',$params['goods_code']);
        $mrp[]=array('mode_id','in','2,3');
        $price=Db::name('commodity_price')->where($mrp)->column('price1','mode_id');
        $new_list=array();
        foreach ($list as $k=>$v){
            $new_list[$k]['item_no']=$maxkey+$k+1;
            $new_list[$k]['pos_code']=$v['pos_code'];
            $new_list[$k]['goods_code']=$params['goods_code'];
            $new_list[$k]['goods_name']=$v['goods_name'];
            $new_list[$k]['specs']=$v['specs'];
            $new_list[$k]['qty']=$v['qty'];
            $new_list[$k]['price']=$v['price1'];
            $new_list[$k]['unit']=$v['unit'];
            $new_list[$k]['amount']=calc([$v['qty'],'*',$v['price1']],6,true);
            if(isset($params['tqty']) && $params['tqty']==1){
                $new_list[$k]['rqty']=$v['qty'];
                $new_list[$k]['ramount']=$new_list[$k]['amount'];
                $new_list[$k]['diff_qty']=0;
                $new_list[$k]['diff_amount']=0;
            }else{
                $new_list[$k]['rqty']=0;
                $new_list[$k]['ramount']=0;
                $new_list[$k]['diff_qty']=-$new_list[$k]['qty'];
                $new_list[$k]['diff_amount']=-$new_list[$k]['amount'];
            }
            $new_list[$k]['batch_no']=$v['batch_no'];
            $new_list[$k]['sup_code']=$v['sup_code'];
            $new_list[$k]['sup_name']=$v['sup_name'];
            $new_list[$k]['prod_date']=$v['prod_date'];
            $new_list[$k]['valid_date']=$v['valid_date'];
            $new_list[$k]['remark']='';
            $new_list[$k]['file_name']=$v['file_name'];
            $new_list[$k]['pym']=$v['pym'];
            $new_list[$k]['function_name']=$v['function_name'];
            $new_list[$k]['category_name']=$v['category_name'];
            $new_list[$k]['dosage']=$v['dosage'];
            $new_list[$k]['approval_code']=$v['approval_code'];
            $new_list[$k]['production']=$v['production'];
            $new_list[$k]['origin']=$v['origin'];
            $new_list[$k]['selprice']=isset($price[2])?$price[2]:0;
            $new_list[$k]['sel_amount']=calc([$new_list[$k]['qty'],'*',$new_list[$k]['selprice']],6,true);
            $new_list[$k]['rtlprice']=isset($price[3])?$price[3]:0;
            $new_list[$k]['rtl_amount']=calc([$new_list[$k]['qty'],'*',$new_list[$k]['rtlprice']],6,true);
            $new_list[$k]['stock_id']=intval($v['id']);
            $new_list[$k]['dtype']=empty($v['pos_code'])?1:null;
            $new_list[$k]['isadd']=1;
        }
        unset($list);
        $result=array('status'=>1,'list'=>$new_list);
        return $result;
    }
    /**
     * 保存新增/修改
     */
    public static function save_order($params,$grup=null,$code=null){
        $result=array('status'=>0,'msg'=>'init');
        if(empty($params['list'])){
            $result['msg']='没有盘点详情，不能保存';
            goto _end;
        }
        $validate=new AcconlineValid();
        $validate_res=$validate->scene('all')->check($params['data']);
        if(!$validate_res){
            $result['msg']=$validate->getError();
            goto _end;
        }
        $data['bill_no']=(isset($params['data']['bill_no']) && !empty($params['data']['bill_no']))?$params['data']['bill_no']:CommonFun::createOrder('TO');
        $data['empno']=$params['data']['empno'];
        $data['remark']=isset($params['data']['remark'])?$params['data']['remark']:null;
        if(!isset($params['data']['bill_no'])){
            $data['f_date']=date('Y-m-d');
            $data['ware_code']=$params['data']['ware_code'];
            $data['transfer']=0;
            $data['grup']=$grup;
            $data['creater']=$code;
            $data['create_date']=date('Y-m-d H:i:s');
        }else{
            $data['mender']=$code;
            $data['update_date']=date('Y-m-d H:i:s');
        }
        $list=$params['list'];
        $validate=new AcconlineValid();
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
            Db::name('acconline_detail')->where($mdp)->delete();//因不确定是否有删除详情，删除不做结果判断（只要下方插入时不序号不冲突即成功）
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
                    $res=Db::name('acconline_detail')->where(['bill_no'=>$data['bill_no'],'item_no'=>$v['item_no']])->update($updata);
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
                    $idata['stock_id']=isset($v['stock_id'])?$v['stock_id']:0;
                    $idata['flag']=(int)$idata['stock_id']>0?0:1;
                    $idata['update_ver']=time();
                    $insert_data[]=CommonFun::ProcessingData($idata);
                }
            }
            if(!empty($insert_data)){
                $res2=Db::name('acconline_detail')->insertAll($insert_data);
                if(!$res2){
                    Db::rollback();
                    $result['msg']='保存失败';
                    goto _end;
                }
            }
        }
        if(isset($params['data']['bill_no']) && !empty($params['data']['bill_no'])){
            $res3=self::where('bill_no','=',$data['bill_no'])->update($data);
        }else{
            $res3=self::insert($data);
        }
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
     * 删除即时盘点单
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
    /**
     * 即时盘点单审核
     */
    public static function check_transfer($bill_no,$code){
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
        $list=Db::name('acconline_detail')->alias('ad')->field($field)
            ->join('stock_details sd','sd.id=ad.stock_id','LEFT')
            ->join('commodity g','g.goods_code=ad.goods_code','LEFT')
            ->where('ad.bill_no','=',$bill_no)->select()->toArray();
        if (empty($list)){
            $result['msg']='没有盘点详情，不能审核';
            goto _end;
        }
        $validate=new AcconlineValid();
        $stock_id_arr='';
        $error_item=array();
        foreach ($list as $v){
            $validate_res=$validate->scene('exam')->check($v);
            if(!$validate_res){
                $result['msg']="序号为{$v['item_no']}的行，".$validate->getError();
                goto _end;
            }
            if(intval($v['stock_id'])>0){
                $stock_id_arr.=$stock_id_arr==''?$v['stock_id']:','.$v['stock_id'];
                if(bccomp($v['qty'],$v['yqty'],6)!=0) $error_item[]=$v['item_no'];
            }
        }
        if(!empty($error_item)){
            $result=array('status'=>2,'erritem'=>$error_item,'msg'=>'以下商品发生了出库，需删除后才能审核');
            goto _end;
        }
        if($stock_id_arr!='') $ystock=Db::name('stock_details')->where('id','in',$stock_id_arr)->column('*','id');
        else $ystock=array();
        $map1[]=array('bill_no','=',$bill_no);
        $map1[]=array('transfer','=',0);
        $data1['auditno']=$code;
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
                    $ins['updator']=$code;
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
                    $udata['updator']=$code;
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
                $ins['updator']=$code;
                $ins['update_date']=$now_date;
                $insert_data[]=$ins;
            }
            $iodata['price']=(float)$v['price'];
            $iodata['batch_no']=$v['batch_no'];
            $iodata['prod_date']=$v['prod_date'];
            $iodata['valid_date']=$v['valid_date'];
            $iodata['creator']=$code;
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
        if($res1 && $res2 && $res3){
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
     * 即时盘点单审核前  删除库存发生变动的记录
     */
    public static function del_errlog($params){
        $map[]=array('bill_no','=',$params['bill_no']);
        $map[]=array('item_no','in',$params['erritem']);
        $res=Db::name('acconline_detail')->where($map)->delete();
        if($res) $result=array('status'=>1,'msg'=>'删除成功');
        else $result=array('status'=>0,'msg'=>'删除失败');
        return $result;
    }
}