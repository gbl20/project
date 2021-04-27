<?php
namespace app\ware\controller;
use app\BaseController;
use app\helper\CommonFun;
use app\ware\model\Accstock;
use think\facade\Db;

class Inventory extends BaseController
{
    /**
     * 账面库存结存单列表
     */
    public function book_list(){
        $params=$this->request->data;
        $page=isset($params['page'])?$params['page']:1;
        $result=Accstock::getAccList([],$page);
        $result['status']=1;
        exit(json_encode($result));
    }

    /**
     * 新增/编辑 结存单
     */
    public function edit_accstock(){
        $params=$this->request->data;
        $bill_no=isset($params['id'])?$params['id']:'';
        $result=Accstock::getAccInfo($bill_no);
        if(!$result['data']){
            $result=array('status'=>0,'data'=>[],'list'=>[],'msg'=>'结存单号不存在！');
        }else{
            if(empty($bill_no)) $result['data']['empno']=$this->request->code;
            $result['status']=1;
        }
        exit(json_encode($result));
    }
    /**
     * 选择仓库后生成结存单
     */
    public function add_accstock(){
        $result=array('status'=>0,'msg'=>'init');
        $params=$this->request->data;
        if(!isset($params['ware_code']) || (isset($params['ware_code']) && empty($params['ware_code']))){
            $result['msg']="请选择盘点仓库";
            goto _end;
        }
        $lock_info=Db::name('ware_locked')->field('bill_no')->where('ware_code','=',$params['ware_code'])->find();
        if($lock_info){
            $result['msg']="所选仓库正在盘点，被单据{$lock_info['bill_no']}锁定";
            goto _end;
        }
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
        $adata['bill_no']=CommonFun::createOrder('AS');
        $adata['ware_code']=$params['ware_code'];
        $adata['empno']=$this->request->code;
        $adata['transfer']=0;
        $adata['remark']=null;
        $adata['creater']=$this->request->code;
        $adata['f_date']=$adata['create_date']=date('Y-m-d H:i:s');
        $adata['grup']=$this->request->depart;
        Db::startTrans();
        $new_stock_list=array_chunk($stock_list,100);
        foreach ($new_stock_list as $ydetail){
            $detail_data=array();
            foreach ($ydetail as $k=>$v){
                $detail_data[$k]['itemno']=$k+1;
                $detail_data[$k]['bill_no']=$adata['bill_no'];
                $detail_data[$k]['goods_code']=$v['goods_code'];
                $detail_data[$k]['pos_code']=$v['pos_code'];
                $detail_data[$k]['sup_code']=$v['sup_code'];
                $detail_data[$k]['batch_no']=$v['batch_no'];
                $detail_data[$k]['prod_date']=$v['prod_date'];
                $detail_data[$k]['valid_date']=$v['valid_date'];
                $detail_data[$k]['qty1']=$v['qty'];
                $detail_data[$k]['qty2']=$v['qty1'];
                $detail_data[$k]['price1']=$v['price1'];
                $detail_data[$k]['price2']=$v['price2'];
                $detail_data[$k]['amount']=calc([$v['qty'],'*',$v['price1']],6,true);
                $detail_data[$k]['selprice']=$v['selprice'];
                $detail_data[$k]['rtlprice']=$v['rtlprice'];
                $detail_data[$k]['stock_id']=$v['id'];
                $detail_data[$k]['dispatched']=0;
            }
            $res2=Db::name('accstock_detail')->insertAll($detail_data);
            if(!$res2){
                Db::rollback();
                $result=array('status'=>0,'msg'=>'操作失败');
                goto _end;
            }
        }
        unset($stock_list);
        unset($new_stock_list);
        $lock_data['ware_code']=$adata['ware_code'];
        $lock_data['bill_no']=$adata['bill_no'];
        $lock_data['lock_time']=date('Y-m-d H:i:s');
        $res1=Db::name('accstock')->insert($adata);
        $res3=Db::name('ware_locked')->insert($lock_data);
        if($res1 && $res2 && $res3){
            Db::commit();
            $result=array('status'=>1,'bill_no'=>$adata['bill_no'],'msg'=>'操作成功');
        }else{
            Db::rollback();
            $result=array('status'=>0,'msg'=>'操作失败');
        }
        _end:
        exit(json_encode($result));
    }

    /**
     * 更新结存单
     */
    public function up_accstock(){
        $params=$this->request->data;
        $data['empno']=$params['empno'];
        $data['remark']=$params['remark'];
        $data['mender']=$this->request->code;
        $data['update_date']=date('Y-m-d H:i:s');
        $res=Db::name('accstock')->where('bill_no','=',$params['bill_no'])->update($data);
        if($res) $result=array('status'=>1,'msg'=>'保存成功');
        else $result=array('status'=>0,'msg'=>'保存失败');
        exit(json_encode($result));
    }

    /**
     * 审核结存单
     */
    public function check_accstock(){
        $result=array('status'=>0,'msg'=>'init');
        $params=$this->request->data;
        $accinfo=Db::name('accstock')->field('transfer')->where('bill_no','=',$params['bill_no'])->find();
        if($accinfo && $accinfo['transfer']==1){
            $result['msg']='结存单已审核，请勿重复审核';
            goto _end;
        }
        $data['transfer']=1;
        $data['auditno']=$this->request->code;
        $data['mender']=$this->request->code;
        $data['update_date']=date('Y-m-d H:i:s');
        $map[]=array('bill_no','=',$params['bill_no']);
        $map[]=array('transfer','=',0);
        $res=Db::name('accstock')->where($map)->update($data);
        if($res) $result=array('status'=>1,'msg'=>'审核成功');
        else $result=array('status'=>0,'msg'=>'审核失败');
        _end:
        exit(json_encode($result));
    }

    /**
     * 删除结存单
     */
    public function del_accstock(){
        $result=array('status'=>0,'msg'=>'init');
        $params=$this->request->data;
        $accinfo=Db::name('accstock')->field('transfer')->where('bill_no','=',$params['bill_no'])->find();
        if($accinfo && $accinfo['transfer']==1){
            $result['msg']='结存单已审核，不能删除';
            goto _end;
        }
        $map[]=array('bill_no','=',$params['bill_no']);
        $map[]=array('transfer','=',0);
        $res=Db::name('accstock')->where($map)->delete();
        if($res) $result=array('status'=>1,'msg'=>'删除成功');
        else $result=array('status'=>0,'msg'=>'删除失败');
        _end:
        exit(json_encode($result));
    }

    /**
     * 分发实物盘点表
     */
    public function inv_accstock(){
        $result=array('status'=>0,'msg'=>'init');
        $params=$this->request->data;
        $transfer=Db::name('accstock')->where('bill_no','=',$params['bill_no'])->value('transfer');
        if(!$transfer){
            $result['msg']='此订单还没有审核，不能分发操作';
            goto _end;
        }
        $inv_info=Db::name('real_stocktak')->field('empno,sn1,sn2')->where('pbill_no','=',$params['bill_no'])->order('sn1 asc')->select()->toArray();
        $max_sn=Db::name('accstock_detail')->where('bill_no','=',$params['bill_no'])->max('itemno');
        $result=array('status'=>1,'data'=>$inv_info,'maxsn'=>$max_sn,'msg'=>'Success');
        _end:
        exit(json_encode($result));
    }

    /**
     * 实物盘点单 分发成实物盘点表
     */
    public function save_invaccstock(){
        $result=array('status'=>0,'msg'=>'init');
        $params=$this->request->data;
        $bill_no=$params['bill_no'];
        $fdata=$params['fdata'];
        if(empty($fdata)){
            $result['msg']='请先填写分发设置';
            goto _end;
        }
        $max_sn=Db::name('accstock_detail')->where('bill_no','=',$bill_no)->max('itemno');
        $dtl_list=Db::name('accstock_detail')->where('bill_no','=',$bill_no)->column('*','itemno');
        $accinfo=Db::name('accstock')->field('ware_code')->where('bill_no','=',$bill_no)->find();
        $detail_data=array();
        $mdata=array();
        $date=date('Y-m-d H:i:s');
        foreach ($fdata as $v){
            $dkey=0;
            $valid=false;
            $sn1=intval($v['sn1'])>$max_sn?$max_sn:intval($v['sn1']);
            $sn2=intval($v['sn2'])>$max_sn?$max_sn:intval($v['sn2']);
            if(!empty($v['empno']) && $sn1 && $sn2){
                $ar_bill_no=CommonFun::createOrder('AR');
                unset($ddata);
                if($sn2>=$sn1){
                    for ($i=$sn1;$i<=$sn2;$i++){
                        if($dtl_list[$i]['dispatched']){
                            $result['msg']='盘点分发设置值存在重叠，请重新设置！';
                            goto _end;
                        }
                        if(!isset($dtl_list[$i])) continue;
                        $dkey++;
                        $dtl_list[$i]['dispatched']=1;
                        $detail_data[]=$this->build_detail($dtl_list[$i],$dkey,$ar_bill_no,$bill_no);
                        $valid=true;
                    }
                }else{
                    for ($i=$sn1;$i>=$sn2;$i--){
                        if($dtl_list[$i]['dispatched']){
                            $result['msg']='盘点分发设置值存在重叠，请重新设置！';
                            goto _end;
                        }
                        if(!isset($dtl_list[$i])) continue;
                        $dkey++;
                        $dtl_list[$i]['dispatched']=1;
                        $detail_data[]=$this->build_detail($dtl_list[$i],$dkey,$ar_bill_no,$bill_no);
                        $valid=true;
                    }
                }
                //***************************//
                if($valid){
                    unset($fmdata);
                    $fmdata['bill_no']=$ar_bill_no;
                    $fmdata['f_date']=$date;
                    $fmdata['ware_code']=$accinfo['ware_code'];
                    $fmdata['empno']=$v['empno'];
                    $fmdata['transfer']=0;
                    $fmdata['remark']="本单盘点序号区间：{$sn1}~{$sn2}";
                    $fmdata['pbill_no']=$bill_no;
                    $fmdata['sn1']=$sn1;
                    $fmdata['sn2']=$sn2;
                    $fmdata['grup']=$this->request->depart;
                    $fmdata['opkind']=0;
                    $fmdata['creater']=$this->request->code;
                    $fmdata['create_date']=$date;
                    $mdata[]=$fmdata;
                }
            }
        }
        if(empty($mdata) || empty($detail_data)){
            $result['msg']='没有有效的分发设置';
            goto _end;
        }
        Db::startTrans();
        $res1=Db::name('real_stocktak')->insertAll($mdata);
        $res2=Db::name('real_stocktak_detail')->insertAll($detail_data);
        $res3=Db::name('accstock_detail')->where('bill_no','=',$bill_no)->deleteInsertAll($dtl_list);
        if($res1 && $res2 && $res3){
            Db::commit();
            $result=array('status'=>1,'msg'=>'已生成实物盘点单，是否打开？');
        }else{
            Db::rollback();
            $result=array('status'=>0,'msg'=>'保存失败');
        }
        _end:
        exit(json_encode($result));
    }
    private function build_detail($data,$dkey,$bill_no,$pbill_no){
        unset($ddata);
        $ddata['bill_no']=$bill_no;
        $ddata['item_no']=$dkey;
        $ddata['goods_code']=$data['goods_code'];
        $ddata['pos_code']=$data['pos_code'];
        $ddata['sup_code']=$data['sup_code'];
        $ddata['batch_no']=$data['batch_no'];
        $ddata['prod_date']=$data['prod_date'];
        $ddata['valid_date']=$data['valid_date'];
        $ddata['qty1']=$data['qty1'];
        $ddata['qty2']=$data['qty2'];
        $ddata['price1']=$data['price1'];
        $ddata['price2']=$data['price2'];
        $ddata['amount']=$data['amount'];
        $ddata['rqty1']=null;
        $ddata['rqty2']=null;
        $ddata['ramount']=null;
        $ddata['diffqty1']=null;
        $ddata['diffqty2']=null;
        $ddata['diffamount']=null;
        $ddata['selprice']=$data['selprice'];
        $ddata['rtlprice']=$data['rtlprice'];
        $ddata['pbill_no']=$pbill_no;
        $ddata['pitem_no']=$data['itemno'];
        $ddata['stock_id']=$data['stock_id'];
        return $ddata;
    }

    /**
     * 获取添加结存单所需的配置
     */
    public function get_add_ccfg(){
        $result['category']=Db::name('commodity_category')->field('id,title')->order('sort desc,id asc')->select()->toArray();
        $data=Db::name('commodity_function')->field('id,title,parent_id')->where('status','=',1)->order('parent_id asc,sort desc,id asc')->select()->toArray();
        $result['function']=$this->build_fun($data);
        $result['status']=1;
        exit(json_encode($result));
    }

    /**
     * 递归组装
     */
    private function build_fun(&$data,$parent=0){
        $result=array();
        foreach ($data as $k=>$v){
            if($v['parent_id']==$parent){
                unset($data[$k]);
                $v['children']=$this->build_fun($data,$v['id']);
                $result[]=$v;
            }
        }
        return $result;
    }
}