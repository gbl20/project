<template>
 <div class="recheck_box">
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
                <Button :disabled="isedit || data.ischeck==1 || data.isclose==1" @click="editHandleFun">
                   <span class="icon iconfont">&#xe791;</span>修改
                </Button>
                <Button :disabled="!isedit || data.ischeck==1 || data.isclose==1" @click="cancelHandleFun">
                   <span class="icon iconfont">&#xe792;</span>取消
                </Button>
                <Button :disabled="!isedit || data.ischeck==1 || data.isclose==1" @click="saveRecheckFun">
                   <span class="icon iconfont">&#xe792;</span>保存
                </Button>
                <Divider type="vertical"/>
                <Button :disabled="isedit || data.ischeck==1 || data.isclose==1" @click="checkRecheckOrder">
                    <span class="icon iconfont">&#xe692;</span>审核
                </Button>
                <Button :disabled="isedit || data.ischeck!=1 || data.isclose==1" @click="backRecheckOrder">
                    <span class="icon iconfont">&#xe692;</span>还原
                </Button>
                <Button :disabled="isedit" @click="closeRecheckOrder">
                    <span class="icon iconfont">&#xe69e;</span>结案
                </Button>
                <Divider type="vertical"/>
                <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
            </div>
            <div class="ser-form">
               <Form :label-width="70" class="recheck_form" label-position="left" :disabled="!isedit || data.ischeck==1 || data.isclose==1">
                    <Row>
                      <Col span="5">
                          <FormItem label="单据编号">
                               <Input v-model="data.orderid" placeholder="单据号" disabled></Input>
                          </FormItem>
                          <FormItem label="订单日期">
                               <DatePicker type="date" :editable="false" :clearable="false" v-model="data.order_date" placeholder="订单日期" disabled></DatePicker>
                          </FormItem>
                          <FormItem label="收货单号">
                               <Input v-model="data.reforderid" placeholder="收货单号" disabled></Input>
                          </FormItem>
                          <FormItem label="验货员" class="recheck_emp_sel">
                               <Input disabled class="left" v-model="data.emp_no"></Input>
                               <Input icon="ios-more" readonly class="right" @on-click="checkEmployeeFun(0)" v-model="data.emp_name"></Input>
                          </FormItem>
                      </Col>
                      <Col span="6" class="recheck_size">
                          <FormItem label="供应商" class="recheck_sup_sel">
                               <Input disabled class="left" v-model="data.sup_code"></Input>
                               <Input icon="ios-more" @on-click="selectProvFun" readonly class="right" v-model="data.sup_name"></Input>
                          </FormItem>
                          <FormItem label="结算方式" class="recheck_set_sel">
                               <div class="left">
                                  <Select v-model="data.paymode" @on-change="changePayMode" v-if="JSON.stringify(params)!='{}'">
                                      <Option value="0">请选择</Option>
                                      <Option :value="p.code" v-for="p in params.settlist" :key="p.code">{{p.name}}({{p.code}})</Option>
                                  </Select>
                               </div>
                               <div class="right">
                                   <Checkbox v-model="data.fungible" :true-value="1" :false-value="0">代销收货</Checkbox>
                               </div>
                          </FormItem>
                          <FormItem label="业务员" class="recheck_sup_sel">
                                <Input disabled class="left" v-model="data.sales_code"></Input>
                                <Input icon="ios-more" readonly class="right" @on-click="selectEmpSales" v-model="data.sales_name"></Input>
                          </FormItem>
                          <FormItem label="收货仓" class="recheck_ware_sel">
                               <Input disabled class="left_code" v-model="data.ware_code"></Input>
                               <Input icon="ios-more" readonly class="left" v-model="data.ware_name" @on-click="selectWareFun(null)"></Input>
                               <Button type="primary" class="right" @click="setGoodsWare">设定</Button>
                          </FormItem>
                      </Col>
                      <Col span="5" class="recheck_size">
                          <FormItem label="供方销售人" :label-width="85">
                              <Input icon="ios-more" @on-click="selectSupSales(1)" v-model="data.sup_sell" readonly class="cursor"></Input>
                          </FormItem>
                          <FormItem label="供方联系人" :label-width="85">
                              <Input icon="ios-more" @on-click="selectSupSales(2)" v-model="data.sup_contact" readonly class="cursor"></Input>
                          </FormItem>
                          <FormItem label="供方部门" :label-width="85">
                              <Input disabled v-model="data.dept_name"></Input>
                          </FormItem>
                          <FormItem label="付款日期" :label-width="85">
                              <DatePicker type="date" placeholder="付款日期" class="left"></DatePicker>
                          </FormItem>
                      </Col>
                      <Col span="5" class="recheck_size">
                          <FormItem label="第一保管员" class="recheck_user_sel" :label-width="85">
                              <Input disabled class="left" v-model="data.keeper1_code"></Input>
                              <Input icon="ios-more" readonly class="right" v-model="data.keeper1_name" @on-click="checkEmployeeFun(1)"></Input>
                          </FormItem>
                          <FormItem label="第二保管员" class="recheck_user_sel" :label-width="85">
                              <Input disabled class="left" v-model="data.keeper2_code"></Input>
                              <Input icon="ios-more" readonly class="right" v-model="data.keeper2_name" @on-click="checkEmployeeFun(2)"></Input>
                          </FormItem>
                          <FormItem label="复核员" :label-width="85">
                              <Input disabled></Input>
                          </FormItem>
                          <FormItem label="审核时间" :label-width="85">
                              <Input disabled></Input>
                          </FormItem>
                      </Col>
                      <Col span="3" class="recheck_sta recheck_size">
                          <div class="title title-color">状态：</div>
                          <div class="ckstatus">
                              <div :class="data.ischeck==1?'status success-bg-text':'status warning-bg-text'">{{data.ischeck==1?'已审核':'未审核'}}</div>
                              <div :class="data.isclose==1?'status success-bg-text':'status warning-bg-text'">{{data.isclose==1?'已结案':'未结案'}}</div>
                          </div>
                      </Col>
                    </Row>
               </Form>
            </div>
        </div>
        <div slot="table-list">
            <Table size="small" stripe :columns="columns" :data="data.list" border class="table-m" :height="height-80" @on-row-dblclick="selectGoodsRow">
            </Table>
            <div class="recheck_foot">
                <Form :label-width="70" class="recheck_form" label-position="left" :disabled="!isedit || data.ischeck==1 || data.isclose==1">
                    <Row>
                        <Col span="6">
                            <FormItem label="货品总数">
                                 <Input disabled v-model="data.goodsqty"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="recheck_size">
                            <FormItem label="货款">
                                 <Input disabled v-model="data.goodssum"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="recheck_size">
                            <FormItem label="税款">
                                 <Input disabled v-model="data.taxsum"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="recheck_size">
                            <FormItem label="合计">
                                 <Input disabled v-model="data.amount"></Input>
                            </FormItem>
                        </Col>
                    </Row>
                    <Row>
                        <Col span="12">
                            <FormItem label="备注说明">
                                 <Input placeholder="备注说明" maxlength="300" v-model="data.remark"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="recheck_size">
                            <FormItem label="创建者">
                                 <Input disabled v-model="data.creator"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="recheck_size">
                            <FormItem label="创建时间">
                                 <Input disabled v-model="data.create_date"></Input>
                            </FormItem>
                        </Col>
                    </Row>
                </Form>
            </div>
        </div>
    </split-none>
    <!-- 弹出操作提示 -->
    <window-tip ref="windowTipRef"></window-tip>
    <!-- 选择供应商 -->
    <choose-providers ref="chooseProvidersRef" @confirm="confirmProvData"></choose-providers>
    <!-- 校验验货员、第一保管员、第二保管员 -->
    <verify-user ref="verifyUserRef" @confirm="confirmVerifyUser"></verify-user>
    <!-- 选择供方销售人员与联系人 -->
    <choose-supsales ref="chooseSupsalesRef" @confirm="confirmSupSales"></choose-supsales>
    <!-- 选择业务员 -->
    <select-employee ref="selectEmployeeRef" @selemp="confirmEmpSales"></select-employee>
    <!-- 选择仓库 -->
    <choose-ware ref="selectWareRef" :isClear="isClear" @confirm="confirmWare" @clear="clearWare"></choose-ware>
    <!-- 选择货位 -->
    <choose-warepos ref="chooseWareposRef" @confirm="confirmWarePos"></choose-warepos>
    <!-- 编辑入库商品信息 -->
    <edit-recheck ref="editRecheckGoodsRef" :params="params" @confirm="confirmEditData"></edit-recheck>
 </div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import windowTip from '@/components/common/WindowTip'
    import chooseProviders from '@/components/common/ChooseProviders'
    import verifyUser from '@/components/common/VerifyUser'
    import chooseSupsales from '@/components/common/ChooseSupsales'
    import selectEmployee from '@/components/common/SelectEmployee'
    import chooseWare from '@/components/common/ChooseWare'
    import chooseWarepos from '@/components/common/ChooseWarePosition'
    import editRecheck from '@/components/ware/recheck/editRecheckGoods'
    export default {
        components:{splitNone,windowTip,chooseProviders,verifyUser,chooseSupsales,selectEmployee,chooseWare,editRecheck,chooseWarepos},
        name:"editReCheck",
        data(){
          return {
              height:0,
              Breadcrumb:[{title:'仓储物流'},{title:'验收入库查询',url:'recheckList'},{title:'验收入库/复核'}],
              columns:[
                 {title:'操作',type:'index',key:'index',width:70,fixed:'left',align:'center'},
                 {title:'商品编号',key:'goods_code',fixed:'left',width:100,align:'center'},
                 {title:'通用名称',key:'name',minWidth:150},
                 {title:'商品名称',key:'goods_name',minWidth:150},
                 {title:'规格',key:'specs',minWidth:100},
                 {title:'剂型',key:'dosage',minWidth:120,align:'center'},
                 {title:'单位',key:'unit',minWidth:100,align:'center'},
                 {title:'数量',key:'qty',minWidth:100,align:'center'},
                 {title:'赠品数量',key:'giftqty',minWidth:100,align:'center'},
                 {title:'税率%',key:'taxrate',minWidth:100,align:'center'},
                 {title:'实际单价',key:'price',minWidth:100,align:'center'},
                 {title:'无税单价',key:'notax_price',minWidth:100,align:'center'},
                 {title:'无税金额',key:'goodssum',minWidth:100,align:'center'},
                 {title:'税额',key:'taxsum',minWidth:100,align:'center'},
                 {title:'合计总额',key:'amount',minWidth:100,align:'center'},
                 {title:'近销差价',key:'diff_amount',minWidth:100,align:'center'},
                 {title:'参考零售价',key:'retail_price',minWidth:100,align:'center'},
                 {title:'参考零售价合计',key:'retail_amount',minWidth:100,align:'center'},
                 {title:'生产批号/序列号',key:'batchno',minWidth:120,align:'center'},
                 {title:'生产日期',key:'prod_date',minWidth:100,align:'center'},
                 {title:'有效期至',key:'valid_date',minWidth:100,align:'center'},
                 {title:'收货仓库',key:'ware_code',width:90,align:'center'},
                 {title:'收货仓库名称',key:'ware_title',minWidth:120,align:'center'},
                 {title:'货位',key:'pos_code',minWidth:120,align:'center'},
                 {title:'供方销售编号',key:'sup_sellno',minWidth:120,align:'center'},
                 {title:'供方产品编号',key:'sup_goodsid',minWidth:120,align:'center'},
                 {title:'追溯号',key:'traceback_no',minWidth:120,align:'center'},
                 {title:'灭菌批号',key:'germicidal_no',minWidth:120,align:'center'},
                 {title:'货品状态',key:'goods_state',minWidth:120,align:'center'},
                 {title:'质量状态',key:'quality_state',minWidth:120,align:'center'},
                 {title:'已入库数量',key:'inqty',minWidth:120,align:'center'},
                 {title:'备注说明',key:'remark',minWidth:200}
              ],
              data:{
                list:[],orderid:'',order_date:'',reforderid:'',ischeck:0,isclose:0,fungible:0,sup_code:'',sup_name:'',paymode:'',emp_no:'',emp_name:'',
                keeper1_code:'',keeper1_name:'',keeper2_code:'',keeper2_name:'',sup_sell:'',sup_contact:'',sales_code:'',sales_name:'',paymode:'',dept_name:'',
                create_date:'',creator:'',remark:'',goodsqty:'',goodssum:'',taxsum:'',amount:'',ware_code:'',ware_name:'',pos_code:''
              },
              selectGoodsIndex:-1, //选择商品下标
              isedit:false,
              params:{},
              checkEmpIndex:0, //校验验货员、第一保管员、第二保管员
              selectSalesIndex:1, //选择供方销售人员、供方联系人
              /*********选择仓库**********/
              isClear:true,
              selectWareIndex:null,
              /************选择仓库货位***********/
              selectWarePosIndex:null,
          }
        },
        beforeCreate:function(){
           _this=this;
        },
        activated:function(){
           var orderid=localStorage.getItem("recheck_orderid");
           if(typeof(orderid)!=="undefined"){
               _this.data.orderid=(orderid!=null && orderid.length>0)?orderid:'';
           }
           if(_this.data.orderid.length==0){
              _this.$refs.windowTipRef.open({title:"操作提示",content:"请求参数异常！",issucess:false,isconfirm:false},"",function(){
                  _this.delView();
              });
           }
        },
        computed:{
           getOrderId:function(){
              return this.data.orderid;
           }
        },
        watch:{
           getOrderId:function(e){
              this.init();
           }
        },
        methods:{
           DHeight(e){
               this.height = e;
           },
           /**
            * 初始化请求
            */
           init:function(){
              _this.common.http({url:'w/initStockReceive',data:{orderid:_this.data.orderid}}).then(function(res){
                  if(res.status==1 && res.order!=null){
                     res.order.ware_code="";
                     res.order.ware_name="";
                     res.order.pos_code="";
                     _this.data=res.order;
                     _this.params=res.params;
                  }else{
                     _this.$refs.windowTipRef.open({title:"操作提示",content:"请求参数异常！",issucess:false,isconfirm:false});
                  }
              }).catch(function(err) {
                  _this.common.httpErr(err.data,_this);
              });
           },
           /**************选择供应商**********/
           selectProvFun:function(){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              _this.$refs.chooseProvidersRef.open();
           },
           confirmProvData:function(data){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              _this.data.sup_name=data.full_name;
              _this.data.sup_code=data.supplier_code;
              _this.data.sales_code=data.business_leader;
              _this.data.sales_name=_this.$store.state.emp[data.business_leader];
              _this.data.paymode=data.pay_mode_no;
              _this.data.dept_name=data.subject_dept;
           },
           /***************改变选择结算方式***************/
           changePayMode:function(e){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1 || _this.data.sup_code.length==0){
                 return false;
              }
              var lock_paymode=_this.$store.state.sysConfig['lock_pch_pay_mode'];
              if(parseInt(lock_paymode)==1){
                 _this.common.http({url:'checkProv',data:{type:'paymode',sup_code:_this.data.sup_code}}).then(function(res){
                     if(res.status==1){
                        _this.data.paymode=res.paymode;
                        var content="如果在供应商资料中指定了结算方式，不能修改结算方式";
                        _this.$Modal.error({title:"温馨提示",content:content});
                     }
                 }).catch(function(err) {
                     _this.common.httpErr(err.data,_this);
                 });
              }
           },
           /************校验验货员、第一保管员、第二保管员**********/
           checkEmployeeFun:function(index){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              _this.checkEmpIndex=index;
              _this.$refs.verifyUserRef.open();
           },
           confirmVerifyUser:function(data){
              if(_this.checkEmpIndex==0){
                 _this.data.emp_no=data.code;
                 _this.data.emp_name=data.name;
              }
              if(_this.checkEmpIndex==1){
                 _this.data.keeper1_code=data.code;
                 _this.data.keeper1_name=data.name;
              }
              if(_this.checkEmpIndex==2){
                 _this.data.keeper2_code=data.code;
                 _this.data.keeper2_name=data.name;
              }
           },
           /**************选择供方销售人员、供方联系人************/
           /**
            * 点击供方销售人员、联系人
            * @param {Object} index
            */
           selectSupSales:function(index){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              if(_this.data.sup_code.length==0){
                 return _this.alertMsg('请先选择供应商','error');
              }
              _this.selectSalesIndex=index;
              _this.$refs.chooseSupsalesRef.open(index,_this.data.sup_code);
           },
           /**
            * 确认选定
            * @param data 回调数据
            */
           confirmSupSales:function(data){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              if(_this.selectSalesIndex==1) _this.data.sup_sell=data.user_name;
              if(_this.selectSalesIndex==2) _this.data.sup_contact=data.user_name;
           },
           /****************选择业务员**************/
           /**
            * 点击选择
            */
           selectEmpSales:function(){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              if(_this.data.sup_code.length==0){
                 return _this.alertMsg('请先选择供应商','error');
              }
              _this.$refs.selectEmployeeRef.init();
           },
           /**
            * 确定选定
            * @param data
            */
           confirmEmpSales:function(data){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1 || _this.data.sup_code.length==0){
                 return false;
              }
              _this.data.sales_code=data.code;
              _this.data.sales_name=data.name;
              _this.common.http({url:'checkProv',data:{type:'provsales',sup_code:_this.data.sup_code}}).then(function(res){
                  if(res.status==1){
                     _this.data.sales_code=res.leader.business_leader;
                     _this.data.sales_name=res.leader.business_leader_name;
                     var content="如果在供应商资料中指定了负责人，不能将业务员改为其他人！";
                     _this.$Modal.error({title:"温馨提示",content:content});
                  }
              }).catch(function(err) {
                  _this.common.httpErr(err.data,_this);
              });
           },
           /***************选择仓库***************/
           /**
            * 设定商品入库仓以及货位
            */
           setGoodsWare:function(){
              if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
              if(_this.data.ware_code==null || _this.data.ware_code.length==0){
                return _this.alertMsg('请先选择收货仓','error');
              }
              var content="确定要将所有明细中的入库仓设置为您当前选择的收货仓库吗？\
                     <div>【确定】将覆盖明细中已有的入货仓信息</div>\
                     <div>【取消】将只为未指定入库仓的明细设置入库仓</div>";
              _this.$Modal.confirm({
                 title:'温馨提示',
                 content:content,
                 onOk:function(){
                    _this.handleGoodsWare(false);
                 },
                 onCancel:function(){
                    _this.handleGoodsWare(true);
                 }
              });
           },
           handleGoodsWare:function(type){
              var data={ware_code:_this.data.ware_code,pos_code:_this.data.pos_code};
              _this.common.http({url:'w/setWare',data:data}).then(function(res){
                  if(res.status==1){
                     _this.data.list.forEach(function(v,k){
                        var isSet=true;
                        if(type && v.ware_code!=null && v.ware_code.length>0 && v.pos_code!=null && v.pos_code.length>0) isSet=false;
                        if(isSet){
                            v.ware_code=res.ware.ware_code;
                            v.ware_title=res.ware.ware_title;
                            v.pos_code=res.ware.pos_code;
                            _this.$set(_this.data.list,k,v);
                        }
                     });
                  }else{
                     return _this.alertMsg(res.msg,'error');
                  }
              }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
              });
           },
           /**
            * 点击选择
            */
           selectWareFun:function(index){
             if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
             _this.selectWareIndex=index;
             if(index!=null) _this.isClear=false;
             _this.$refs.selectWareRef.open();
           },
           /**
            * 确定选定
            */
           confirmWare:function(data){
              if(_this.selectWareIndex==null){
                 _this.data.ware_code=data.ware_code;
                 _this.data.ware_name=data.ware_title;
                 _this.data.pos_code="";
                 _this.selectWarePosFun(null);
              }else{
                 _this.$refs[_this.selectWareIndex].setWareNotify(data);
              }
           },
           /**
            * 清除选定
            */
           clearWare:function(){
              if(_this.selectWareIndex==null){
                  _this.data.ware_code="";
                  _this.data.ware_name="";
                  _this.data.pos_code="";
              }
           },
           /*****************选择仓库货位****************/
           /**
            * 点击选择
            * @param index 选择对象
            */
           selectWarePosFun:function(index){
              _this.selectWarePosIndex=index;
              var ware_code=_this.data.ware_code;
              if(_this.selectWarePosIndex!=null) ware_code=_this.$refs.editRecheckGoodsRef.getWareCode();
              if(ware_code==null || ware_code.length==0){
                  return _this.alertMsg('请先选择仓库','error');
              }
              _this.$refs.chooseWareposRef.open(ware_code);
           },
           /**
            * 确认选定
            * @param data 回调数据
            */
           confirmWarePos:function(data){
              if(_this.selectWarePosIndex==null){
                 _this.data.pos_code=data.pos_code;
              }else{
                 _this.$refs[_this.selectWarePosIndex].setWarePosNotify(data);
              }
           },
           /****************编辑入库商品资料***************/
           selectGoodsRow:function(row,index){
               if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
               _this.selectGoodsIndex=index;
               _this.$refs.editRecheckGoodsRef.open(row);
           },
           confirmEditData:function(data){
               if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
               _this.$set(_this.data.list,_this.selectGoodsIndex,data);
           },
           /**************按钮操作************/
           /**
            * 刷新
            */
           Refresh:function(){
                _this.init();
           },
           /**
            * 修改
            */
           editHandleFun:function(){
                if(_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return true;
                _this.isedit=true;
           },
           /**
            * 取消
            */
           cancelHandleFun:function(){
                if(!_this.isedit || _this.data.ischeck==1 || _this.data.isclose==1) return false;
                _this.init();
                _this.isedit=false;
           },
           /**
            * 保存
            */
           saveRecheckFun:function(){
                if(!_this.isedit) return false;
                if(_this.data.ischeck==1 || _this.data.isclose==1){
                    return _this.alertMsg('复核单据已审核或已结案，不能进行修改操作','error');
                }
                _this.common.http({url:'w/saveStockReceive',data:_this.data}).then(function(res){
                    if(res.status==1){
                        _this.isedit=false;
                        _this.init();
                        _this.$Modal.success({title:"操作提示",content:"数据保存已成功"});
                    }else{
                        _this.$Modal.error({title:"保存提示",content:res.msg});
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
           },
           /**
            * 审核
            */
           checkRecheckOrder:function(){
             if(_this.isedit){
                return _this.alertMsg('当前单据正在编辑中，请先保存操作后进行审核','error');
             }
             if(_this.data.ischeck==1){
                return _this.alertMsg('复核单据已审核，请务重复审核','error');
             }
             if(_this.data.isclose==1){
                return _this.alertMsg('复核单据已结案，不能进行审核','error');
             }
             var orderid=_this.data.orderid;
             _this.$Modal.confirm({
                 title:'审核提示',
                 content:'确定审核订单【'+orderid+'】入库吗？',
                 onOk:function(){
                     _this.common.http({url:'w/checkStockReceive',data:{orderid:orderid}}).then(function(res){
                         if(res.status==1){
                             _this.init();
                             _this.$refs.windowTipRef.open({title:"审核提示",content:res.msg,issucess:true,isconfirm:false});
                         }else{
                             _this.$refs.windowTipRef.open({title:"审核提示",content:res.msg,issucess:false,isconfirm:false});
                         }
                     }).catch(function(err){
                         _this.common.httpErr(err.data,_this);
                     });
                 }
             });
           },
           /**
            * 还原
            */
           backRecheckOrder:function(){
             if(_this.isedit) return false;
             if(_this.data.isclose==1){
                return _this.alertMsg('复核单据已结案，不能进行还原','error');
             }
             if(_this.data.ischeck!=1){
                return _this.alertMsg('复核单据未审核，不能进行还原','error');
             }
             var orderid=_this.data.orderid;
             _this.$Modal.confirm({
                 title:'还原提示',
                 content:'确定还原入库复核单【'+orderid+'】吗？还原后已入库商品库存会自动撤销',
                 onOk:function(){
                     _this.common.http({url:'w/backStockReceive',data:{orderid:orderid}}).then(function(res){
                         if(res.status==1){
                             _this.init();
                             _this.$refs.windowTipRef.open({title:"还原提示",content:res.msg,issucess:true,isconfirm:false});
                         }else{
                             _this.$refs.windowTipRef.open({title:"还原提示",content:res.msg,issucess:false,isconfirm:false});
                         }
                     }).catch(function(err){
                         _this.common.httpErr(err.data,_this);
                     });
                 }
             });
           },
           /**
            * 结案
            */
           closeRecheckOrder:function(){
               if(_this.isedit) return false;
               var orderid=_this.data.orderid;
               var txt=_this.data.isclose==1?'返结案':'结案';
               _this.$Modal.confirm({
                   title:'结案提示',
                   content:'确定'+txt+'入库单【'+orderid+'】吗？',
                   onOk:function(){
                       _this.common.http({url:'w/closeStockReceive',data:{orderid:orderid}}).then(function(res){
                           if(res.status==1){
                               _this.data.isclose=res.isclose;
                           }else{
                               _this.$refs.windowTipRef.open({title:"结案提示",content:res.msg,issucess:false,isconfirm:false});
                           }
                       }).catch(function(err){
                           _this.common.httpErr(err.data,_this);
                       });
                   }
               });
           }
        }
    }
</script>
<style lang="less">
  .recheck_box{
      .cursor{
         cursor: pointer;
      }
      .recheck_form{
         width:1200px;
         .recheck_size{
            padding-left:15px;
         }
         .recheck_emp_sel{
            .left{width:70px;display:inline-block;float:left;}
            .right{width:105px;display:inline-block;cursor:pointer;float:left;margin-left:5px;}
         }
         .recheck_sup_sel{
            .left{width:70px;display:inline-block;float:left;}
            .right{width:140px;display:inline-block;cursor:pointer;float:left;margin-left:5px;}
         }
         .recheck_set_sel{
            .left{width:120px;display:inline-block;float:left;}
            .right{width:90px;display:inline-block;cursor:pointer;float:left;margin-left:5px;text-align:right;}
         }
         .recheck_ware_sel{
            .left_code{width:65px;display:inline-block;float:left;margin-right:5px;}
            .left{width:105px;display:inline-block;float:left;cursor:pointer;}
            .right{width:34px;height:28px;line-height:28px;display:inline-block;cursor:pointer;float:left;margin-left:5px;text-align:center;font-size:12px;padding:0 4px;}
         }
         .recheck_user_sel{
            .left{width:60px;display:inline-block;float:left;}
            .right{width:85px;display:inline-block;cursor:pointer;float:left;margin-left:5px;}
         }
         .recheck_sta{
             box-sizing:border-box;
             .title{width:46px;float:left;line-height:32px;}
             .ckstatus{width:74px;float:left;}
             .status{
                height:32px;line-height:32px;text-align:center;font-size:14px;margin-bottom:10px;padding:0;
             }
         }
      }
      .recheck_foot{
         height:88px;padding:10px 0;
      }
  }
</style>
