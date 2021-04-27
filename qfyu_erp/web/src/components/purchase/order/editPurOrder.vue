<template>
<div>
    <split-none @DHeight="DHeight" :editTypeTitle="editTypeTitle" :Breadcrumb="Breadcrumb">
         <div slot="form-ser">
             <div class="nav-menu">
                 <Button @click="addPurOrder" :disabled="formdata.orderid.length==0 || isedit">
                    <span class="icon iconfont">&#xe797;</span>新增
                 </Button>
                 <Button @click="editPurOrder(false)" v-if="formdata.orderid.length>0" :disabled="isedit || formdata.ischeck==1">
                    <span class="icon iconfont">&#xe791;</span>修改
                 </Button>
                 <Button @click="savePurOrder" :loading="save_loading" :disabled="formdata.ischeck==1 || (formdata.orderid.length>0 && !isedit)">
                    <span class="icon iconfont">&#xe792;</span>保存
                 </Button>
                 <Button @click="editPurOrder(true)" v-if="formdata.orderid.length>0" :disabled="formdata.ischeck==1 || !isedit">
                    <span class="icon iconfont">&#xe792;</span>取消
                 </Button>
                 <Divider type="vertical"/>
                 <template v-if="formdata.orderid.length>0">
                     <Button @click="checkPurOrder" :disabled="formdata.ischeck==1 || isedit">
                        <span class="icon iconfont">&#xe692;</span>审核
                     </Button>
                     <Button @click="closePurOrder" :disabled="formdata.ischeck!=1 || formdata.isclose==1 || isedit">
                        <span class="icon iconfont">&#xe69e;</span>结案
                     </Button>
                     <Button @click="backPurOrder" :disabled="formdata.ischeck!=1 || formdata.istrans==1 || formdata.ispay==1 || isedit">
                        <span class="icon iconfont">&#xe693;</span>还原
                     </Button>
                     <Button @click="generateRegisterOrder" :disabled="formdata.ischeck!=1 || formdata.isclose==1 || isedit">
                         <span class="icon iconfont">&#xe6a3;</span>转单
                     </Button>
                     <Divider type="vertical"/>
                     <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                     <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                 </template>
                 <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
             </div>
             <div class="ser-form">
                <Form :label-width="70" label-position="left" class="orderform" :disabled="formdata.ischeck==1 || (formdata.orderid.length>0 && !isedit)">
                    <Row>
                      <Col span="5">
                          <FormItem label="单据编号">
                               <Input v-model="formdata.orderid" placeholder="单据号(系统生成)" disabled readonly></Input>
                          </FormItem>
                          <FormItem label="订单日期">
                               <DatePicker type="date" :editable="false" :clearable="false" v-model="formdata.order_date" placeholder="订单日期" readonly disabled></DatePicker>
                          </FormItem>
                          <FormItem label="到货日期">
                               <DatePicker type="date" :editable="false" :clearable="false" v-model="formdata.delivery_date" placeholder="到货日期"></DatePicker>
                          </FormItem>
                          <FormItem label="签约地点">
                               <Input placeholder="签约地点" v-model="formdata.sign_area" maxlength="50"></Input>
                          </FormItem>
                      </Col>
                      <Col span="5" class="olsize">
                          <FormItem label="生效日期">
                               <DatePicker type="date" :editable="false" :clearable="false" v-model="formdata.effectivity_date" placeholder="生效日期"></DatePicker>
                          </FormItem>
                          <FormItem label="失效日期">
                               <DatePicker type="date" :editable="false" :clearable="false" v-model="formdata.invalid_date" placeholder="失效日期"></DatePicker>
                          </FormItem>
                          <FormItem label="合同类型">
                              <Select v-model="formdata.contract_type">
                                  <Option :value="p" :key="k" v-for="(p,k) in $store.state.sysParam['contract_type']">{{p}}</Option>
                              </Select>
                          </FormItem>
                          <FormItem label="合同号">
                              <Input icon="ios-more" v-model="formdata.contract_code" readonly style="cursor:pointer;" @on-click="clickChooseContract"></Input>
                          </FormItem>
                      </Col>
                      <Col span="7" class="olsize">
                          <FormItem label="供应商" class="order_sup_sel">
                               <Input readonly disabled class="left" v-model="formdata.sup_code"></Input>
                               <Input icon="ios-more" v-model="formdata.sup_name" readonly class="right" @on-click="clickProviders(null)"></Input>
                          </FormItem>
                          <FormItem label="业务员" class="order_sales_sel">
                              <Input readonly disabled class="left" v-model="formdata.sales_code"></Input>
                              <Input icon="ios-more" readonly class="right" v-model="formdata.sales_name" @on-click="clickSelEmployee"></Input>
                          </FormItem>
                          <FormItem label="供方销售人员" :label-width="95">
                              <Input icon="ios-more" v-model="formdata.sup_sell" readonly style="cursor:pointer;" @on-click="clickSupsales(1)"></Input>
                          </FormItem>
                          <FormItem label="付款日期" class="order_pay_sel">
                              <DatePicker type="date" v-model="formdata.pay_date" placeholder="付款日期" class="left"></DatePicker>
                              <div class="right">
                                  <Checkbox v-model="formdata.ispay" :true-value="1" :false-value="0" @on-change="changeIsPay">预付款</Checkbox>
                                  <Input class="puts" :spellcheck="true" :readonly="formdata.ispay!=1" :disabled="formdata.ispay!=1" v-model="formdata.paymoney"></Input>
                              </div>
                          </FormItem>
                      </Col>
                      <Col span="4" class="olsize">
                          <FormItem label="联系人">
                              <Input icon="ios-more" v-model="formdata.sup_contact" readonly style="cursor:pointer;" @on-click="clickSupsales(2)"></Input>
                          </FormItem>
                          <FormItem label="供方部门">
                              <Input readonly disabled v-model="formdata.dept_name"></Input>
                          </FormItem>
                          <FormItem label="结算方式">
                              <Select v-model="formdata.settle_type" @on-change="changeSettleType" :disabled="formdata.sup_code.length==0">
                                  <Option :value="k" :key="k" v-for="(p,k) in $store.state.settlement">{{p}}{{k}}</Option>
                              </Select>
                          </FormItem>
                          <FormItem label="复核员">
                               <Input readonly disabled :value="$store.state.emp[formdata.check_code]"></Input>
                          </FormItem>
                      </Col>
                      <Col span="3" class="purOrderSta olsize">
                          <div class="title title-color">状态：</div>
                          <div class="ckstatus">
                              <div :class="formdata.ischeck==1?'status success-bg-text':'status warning-bg-text'">{{formdata.ischeck==1?'已审核':'未审核'}}</div>
                              <div :class="formdata.istrans==1?'status success-bg-text':'status warning-bg-text'">{{formdata.istrans==1?'已转单':'未转单'}}</div>
                          </div>
                      </Col>
                    </Row>
                    <Row>
                      <Col span="10">
                          <FormItem label="供应商备注" :label-width="85">
                               <Input placeholder="供应商备注" v-model="formdata.sup_remark" maxlength="300"></Input>
                          </FormItem>
                      </Col>
                      <Col span="7" class="olsize">
                          <FormItem>
                               <Checkbox v-model="formdata.isclose" :true-value="1" :false-value="0" disabled>已结案</Checkbox>
                          </FormItem>
                      </Col>
                      <Col span="7" style="padding-left:25px;">
                          <div v-if="formdata.orderid.length==0  || (formdata.ischeck!=1 && formdata.orderid.length>0 && isedit)">
                              <Button type="primary" @click="addGoodsRow">新增行</Button>
                              <Button @click="removeGoodsRow">删除行</Button>
                          </div>
                      </Col>
                    </Row>
                </Form>
             </div>
         </div>
         <div slot="table-list">
              <Table size="small" stripe :columns="columns" :data="formdata.goodslist" border class="table-m"
                     :highlight-row="true" :height="height-115"
                     @on-row-click="(row,index)=>{selectRow(index,false)}"
                     @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
              </Table>
              <div class="pur_order_foot">
                 <Form :label-width="70" label-position="left" class="orderform" :disabled="formdata.ischeck==1 || (formdata.orderid.length>0 && !isedit)">
                    <Row>
                        <Col span="6">
                            <FormItem label="交货方式">
                                 <Input v-model="formdata.delivery_type" placeholder="交货方式" maxlength="50"></Input>
                            </FormItem>
                        </Col>
                        <Col span="5" class="olsize">
                            <FormItem label="货品总数">
                                 <Input v-model="formdata.nums" readonly disabled></Input>
                            </FormItem>
                        </Col>
                        <Col span="4" class="olsize">
                            <FormItem label="货款" :label-width="50">
                                 <Input v-model="formdata.payment" readonly disabled></Input>
                            </FormItem>
                        </Col>
                        <Col span="4" class="olsize">
                            <FormItem label="税款" :label-width="50">
                                 <Input v-model="formdata.tax_total" readonly disabled></Input>
                            </FormItem>
                        </Col>
                        <Col span="5" class="olsize">
                            <FormItem label="合计">
                                 <Input v-model="formdata.total" readonly disabled></Input>
                            </FormItem>
                        </Col>
                    </Row>
                    <Row>
                        <Col span="6">
                            <FormItem label="运输方式">
                                 <Input placeholder="运输方式" v-model="formdata.transport_type" maxlength="50"></Input>
                            </FormItem>
                        </Col>
                        <Col span="9" class="olsize">
                            <FormItem label="交货地点">
                                 <Input placeholder="交货地点" v-model="formdata.delivery_area" maxlength="50"></Input>
                            </FormItem>
                        </Col>
                        <Col span="9" class="olsize">
                            <FormItem label="运输到站">
                                 <Input placeholder="运输到站" v-model="formdata.transport_area" maxlength="50"></Input>
                            </FormItem>
                        </Col>
                    </Row>
                    <Row>
                        <Col span="11">
                            <FormItem label="备 注">
                                 <Input placeholder="请输入备注说明" v-model="formdata.remark" maxlength="300"></Input>
                            </FormItem>
                        </Col>
                        <Col span="4" class="olsize">
                            <FormItem label="创建者" :label-width="60">
                                 <Input disabled v-model="$store.state.emp[formdata.creator]"></Input>
                            </FormItem>
                        </Col>
                        <Col span="9" class="olsize">
                            <FormItem label="创建时间">
                                 <Input disabled v-model="formdata.create_date"></Input>
                            </FormItem>
                        </Col>
                    </Row>
                 </Form>
              </div>
         </div>
    </split-none>
    <!-- 选择供应商 -->
    <choose-providers ref="chooseProviderRef" @confirm="confirmProviders"></choose-providers>
    <!-- 选择供方销售人员以及联系人 -->
    <choose-supsales ref="chooseSupsaleRef" @confirm="confirmSupSale"></choose-supsales>
    <!-- 选择业务员 -->
    <select-employee ref="selectEmployeeRef" @selemp="confirmEmployee" ></select-employee>
    <!-- 选择合同 -->
    <choose-contract ref="chooseContractRef" @confirm="confirmContract"></choose-contract>
    <!-- 选择商品资料 -->
    <choose-good ref="chooseGoodsRef" :isSignle="false" refname="chooseGoodsRef" fun="clickProviders" @selectRow="confirmSelGoods"></choose-good>
    <!-- 编辑表格参数 -->
    <edit-ordergoods ref="editOrderGoodsRef" @confirm="confirmEditPurGoodss"></edit-ordergoods>
    <!-- 弹出操作提示 -->
    <window-tip ref="windowTipRef"></window-tip>
</div>
</template>
<script>
  var _this=this;
  var form={
    orderid:'',sup_code:'',sup_name:'',sup_sell:'',sup_contact:'',sales_code:'',sales_name:'',dept_name:'',contract_code:'',
    ischeck:0,check_code:'',istrans:0,isclose:0,ispay:0,paymoney:0,order_date:'',delivery_date:'',effectivity_date:'',invalid_date:'',
    settle_type:"",contract_type:-1,sign_area:'',sup_remark:'',delivery_type:'',transport_type:'',delivery_area:'',transport_area:'',
    remark:'',nums:0,payment:0,tax_total:0,total:0,creator:'',create_date:'',goodslist:[]
  };
  import splitNone from '@/components/public/splitNone'
  import chooseProviders from '@/components/common/ChooseProviders'
  import chooseSupsales from '@/components/common/ChooseSupsales'
  import selectEmployee from '@/components/common/SelectEmployee'
  import chooseContract from '@/components/common/ChooseContract'
  import chooseGood from '@/components/common/ChooseGoods'
  import editOrdergoods from '@/components/purchase/order/editPurOrderGoods'
  import windowTip from '@/components/common/WindowTip'
  export default {
     components:{
       splitNone,chooseProviders,chooseSupsales,selectEmployee,chooseContract,chooseGood,editOrdergoods,windowTip
     },
     data(){
        return {
            height:0,
            Breadcrumb:[{title:'采购管理'},{title:'采购订单',url:'purOrderList'},{title:'创建采购订单'}],
            editTypeTitle:'创建订单',
            formdata:JSON.parse(JSON.stringify(form)),
            columns:[
                {title:'操作',type:'index',key:'index',width:70,fixed:'left',align:'center'},
                {title:'商品编号',key:'goods_code',fixed:'left',width:100,align:'center'},
                {title:'通用名称',key:'name',minWidth:150},
                {title:'商品名称',key:'goods_name',minWidth:150},
                {title:'规格',key:'specs',minWidth:100},
                {title:'剂型',key:'dosage_name',minWidth:120},
                {title:'单位',key:'unit',minWidth:90,align:'center'},
                {title:'数量',key:'nums',minWidth:100,align:'center'},
                {title:'单价',key:'price',minWidth:100,align:'center'},
                {title:'折扣%',key:'discount',minWidth:100,align:'center'},
                {title:'实际单价',key:'reality_price',minWidth:100,align:'center'},
                {title:'税率%',key:'taxrate',minWidth:100,align:'center'},
                {title:'无税单价',key:'notax_price',minWidth:100,align:'center'},
                {title:'无税金额',key:'notax_total',minWidth:100,align:'center'},
                {title:'税款',key:'tax_total',minWidth:100,align:'center'},
                {title:'合计',key:'total',minWidth:100,align:'center'},
                {title:'已收数量',key:'received_nums',minWidth:100,align:'center'},
                {title:'供方产品编号',key:'sup_goodsid',minWidth:100,align:'center'},
                {title:'最近进价',key:'near_price',minWidth:100,align:'center'},
                {title:'最高进价',key:'high_price',minWidth:100,align:'center'},
                {title:'最低进价',key:'low_price',minWidth:100,align:'center'},
                {title:'最初进价',key:'first_price',minWidth:100,align:'center'},
                {title:'参考批发价',key:'standard_price',minWidth:100,align:'center'},
                {title:'参考零售价',key:'retail_price',minWidth:100,align:'center'},
                {title:'批准文号/注册证号',key:'approval_code',minWidth:150,align:'center'},
                {title:'生产批号/序列号',key:'batch',minWidth:120,align:'center'},
                {title:'产地',key:'origin',minWidth:150},
                {title:'生产企业',key:'production',minWidth:200},
                {title:'中包装数量',key:'pack_specs1',minWidth:120},
                {title:'大包装数量',key:'pack_specs2',minWidth:120},
                {title:'毛利率分类',key:'abkind_name',minWidth:120},
                {title:'保质期',key:'shelf_life',width:100,align:'center'},
                {title:'保质期单位',key:'shelf_unit_name',width:100,align:'center'},
                {title:'包装规格',key:'packspecs',minWidth:100},
                {title:'来货序号',key:'register_num',minWidth:100},
                {title:'条码一',key:'code',minWidth:100},
                {title:'附件名',key:'file_name',minWidth:100},
                {title:'商品匹配码1',key:'custom_code1',minWidth:100},
                {title:'商品匹配码2',key:'custom_code2',minWidth:100},
                {title:'商品匹配码3',key:'custom_code3',minWidth:100},
                {title:'货品状态',key:'goods_status',minWidth:100,align:'center'},
                {title:'质量状态',key:'quality_status',minWidth:100,align:'center'}
            ],
            kind:1, //类别 1供方销售人员 2:联系人
            contracttype:[], //合同类型
            providersIndex:null, //选择供应商
            selectIndex:-1 ,//选择商品行
            save_loading:false,
            isedit:false
        }
     },
     beforeCreate:function(){
         _this=this;
     },
     created:function(){
         var orderid=localStorage.getItem('pch_orderId');
         if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
         _this.formdata.orderid = orderid;
         if(JSON.stringify(this.$store.state.sysConfig) != '[]') _this.initDate();
     },
     beforeRouteEnter(to, from, next) {
       next(vm => {
         if(from.name == 'purOrderList'){
           var orderid=localStorage.getItem('pch_orderId');
           if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
           vm.formdata.orderid = orderid;
         }
       });
     },
     computed:{
        getOrderId:function(){
           return this.formdata.orderid;
        }
     },
     watch:{
       getOrderId:function(e){
          if(this.isedit){
            this.$Modal.confirm({
              title:'温馨提示',
              content:'页面正处于编辑状态，确定要放弃修改吗？',
              okText:'继续',
              onOk:()=>{
                this.init();
              }
            });
          }else this.init();
       },
       '$store.state.sysConfig'(){
         if(_this.formdata.orderid.length==0) _this.initDate();
       }
     },
     methods:{
        DHeight:function(e){
            _this.height=e;
        },
        initDate:function(){
            var now=new Date();
            var nowDate=now.getFullYear()+"-"+(now.getMonth()+1)+'-'+now.getDate();
            this.formdata.order_date=nowDate;
            this.formdata.delivery_date=nowDate;
            this.formdata.effectivity_date=nowDate;
            this.formdata.pay_date=nowDate;
            let invalidDays = this.$store.state.sysConfig['pch_order_plan_invalid_days']
            now.setDate(now.getDate()+invalidDays);
            this.formdata.invalid_date=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate();
        },
        Refresh:function(){
            this.init();
        },
        init:function(){
            var orderid=_this.formdata.orderid;
            _this.common.http({url:'initPurOrder',data:{orderid:orderid}}).then(function(res){
                if(res.status==1){
                    _this.editTypeTitle=res.order==null?'创建订单':'修改订单';
                    if(res.order==null){
                       _this.formdata=JSON.parse(JSON.stringify(form));
                       _this.initDate();
                    }else{
                       _this.formdata=res.order;
                    }
                }
            }).catch(function(err){
                _this.common.httpErr(err.data,_this);
            });
        },
        /********选择供应商*******/
        /**
         * 点击选择
         */
        clickProviders:function(providersIndex){
           if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
           _this.providersIndex=providersIndex;
           _this.$refs.chooseProviderRef.open();
        },
        /**
         * 选定供应商
         * @param data 回调数据
         */
        confirmProviders:function(data){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            if(_this.providersIndex!=null){
                _this.$refs[_this.providersIndex].selectProvNotify(data);
            }else{
                _this.formdata.sup_code=data.supplier_code;
                _this.formdata.sup_name=data.full_name;
                _this.formdata.sup_remark=data.remark;
                _this.formdata.dept_name=data.subject_dept;
                _this.formdata.sales_code=data.business_leader;
                _this.formdata.sales_name=_this.$store.state.emp[data.business_leader];
                _this.formdata.settle_type=data.pay_mode_no;
                _this.$refs.chooseSupsaleRef.initSup(data.supplier_code,function(res,res1){
                    if(res!=null) _this.formdata.sup_sell=res.user_name;
                    if(res1!=null) _this.formdata.sup_contact=res1.user_name;
                });
            }
        },
        /*********选择供方销售人员/联系人**********/
        /**
         * 选择供方销售人员、联系人
         * @param kind 1:供方销售人员 2联系人
         */
        clickSupsales:function(kind){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            if(_this.formdata.sup_code.length==0){
              return _this.alertMsg('请先选择供应商','error');
            }
            _this.kind=kind;
            _this.$refs.chooseSupsaleRef.open(kind,_this.formdata.sup_code);
        },
        /**
         * 确认选定
         */
        confirmSupSale:function(data){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            if(_this.kind==1) _this.formdata.sup_sell=data.user_name;
            if(_this.kind==2) _this.formdata.sup_contact=data.user_name;
        },
        /****************选择业务员***************/
        clickSelEmployee:function(){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            _this.$refs.selectEmployeeRef.init({show_self:1});
        },
        /**
         * 确认选定
         * @param data 选定数据
         */
        confirmEmployee:function(data){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            var lock_bill=_this.$store.state.sysConfig['lock_pch_emp_bill'];
            if(parseInt(lock_bill)==1){
                _this.common.http({url:'checkProv',data:{type:'provsales',sup_code:_this.formdata.sup_code}}).then(function(res){
                    if(res.status==1){
                       _this.formdata.sales_code=res.leader.business_leader;
                       _this.formdata.sales_name=res.leader.business_leader_name;
                       _this.$Modal.error({title:"温馨提示",content:res.msg});
                    }
                }).catch(function(err) {
                    _this.common.httpErr(err.data,_this);
                });
            }else{
                _this.formdata.sales_code=data.code;
                _this.formdata.sales_name=data.name;
            }
        },
        /**************选择结算方式*************/
        changeSettleType:function(value){
            if(_this.formdata.orderid.length>0 && !_this.isedit) return false;
            if(_this.formdata.sup_code.length==0){
               return _this.alertMsg('请先选择供应商','error');
            }
            var lock_paymode=_this.$store.state.sysConfig['lock_pch_pay_mode'];
            if(parseInt(lock_paymode)==1){
                _this.common.http({url:'checkProv',data:{type:'paymode',sup_code:_this.formdata.sup_code}}).then(function(res){
                    if(res.status==1){
                       _this.formdata.settle_type=res.paymode;
                       _this.$Modal.error({title:"温馨提示",content:res.msg});
                    }
                }).catch(function(err) {
                    _this.common.httpErr(err.data,_this);
                });
            }
        },
        /***********改变预付款金额***********/
        /**
         * 选择预付款，改变付款金额
         */
        changeIsPay:function(value){
            if(value!=1) _this.formdata.paymoney=0;
        },
        /************选择合同************/
        /**
         * 点击选择合同
         */
        clickChooseContract:function(){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            if(_this.formdata.sup_code.length==0){
              return _this.alertMsg('请先选择供应商','error');
            }
            _this.$refs.chooseContractRef.open(_this.formdata.sup_code);
        },
        /**
         * 确定选定
         * @param data 回调数据
         */
        confirmContract:function(data){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            _this.formdata.contract_code=data.orderid;
        },
        /***************商品列表操作**************/
        /**
         * 新增行
         */
        addGoodsRow:function(){
           if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
           if(_this.formdata.sup_code.trim().length==0){
             return _this.alertMsg("请选择供应商",'error');
           }
           _this.$refs.chooseGoodsRef.open();
        },
        /**
         * 双击编辑行
         */
        selectRow:function(index,type){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            _this.selectIndex=index;
            if(type){
                var data=_this.formdata.goodslist[_this.selectIndex];
                _this.$refs.editOrderGoodsRef.open(data);
            }
        },
        /**
         * 删除行
         */
        removeGoodsRow:function(){
            if(_this.formdata.ischeck==1) return false;
            if(_this.selectIndex<0) return _this.alertMsg("请至少选择一行数据后删除",'error');
            this.$Modal.confirm({
                title:'操作提示',
                content:'确定要移除该商品信息吗？',
                onOk:function(){
                    _this.formdata.goodslist.splice(_this.selectIndex,1);
                    _this.calcTotalPrice();
                }
            });
        },
        /**
         * 确认编辑行操作
         * @param data 行数据
         */
        confirmEditPurGoodss:function(data){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            _this.$set(_this.formdata.goodslist,_this.selectIndex,data);
            _this.calcTotalPrice();
        },
        /**
         * 确认选定
         * @param data 回调数据
         */
        confirmSelGoods:function(data){
            if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
            if(_this.formdata.sup_code.trim().length==0){
                _this.$Modal.error({title:"温馨提示",content:"请选择供应商信息"});
                return false;
            }
            if(parseInt(data.is_buyer)==1){
                _this.$Modal.error({title:"温馨提示",content:"当前所选商品已暂停采购，请选择其它商品"});
                return false;
            }
            if(data.gmp_end_date!=null && data.gmp_end_date.length>0){
              let gmptime=new Date(data.gmp_end_date);
              let nowtime=new Date().getTime();
              if(gmptime<=nowtime){
                  _this.$Modal.error({title:"温馨提示",content:"当前所选商品GMP证书已过期，不能进行采购"});
                  return false;
              }
            }
            _this.common.http({url:'checkProv',data:{type:'selfgoods',gcode:data.goods_code,sup_code:_this.formdata.sup_code}}).then(function(res){
                if(res.status==1){
                    var defaultField=[
                        {name:'sup_goodsid',default:''},
                        {name:'unit1',default:data.unit},
                        {name:'nums',default:0},
                        {name:'price',default:0},
                        {name:'discount',default:0},
                        {name:'reality_price',default:0},
                        {name:'taxrate',default:0},
                        {name:'notax_price',default:0},
                        {name:'notax_total',default:0},
                        {name:'tax_total',default:0},
                        {name:'total',default:0},
                        {name:'received_nums',default:0},
                        {name:'batch',default:''},
                        {name:'goods_status',default:""},
                        {name:'quality_status',default:""},
                        {name:'remark',default:''}
                    ];
                    defaultField.forEach(function(v){data[v.name]=v.default;});
                    _this.formdata.goodslist.push(data);
                    _this.calcTotalPrice();
                }else{
                    _this.$Modal.warning({title:"温馨提示",content:res.msg});
                }
            }).catch(function(err) {
                _this.common.httpErr(err.data,_this);
            });
        },
        /**
         * 计算单据总金额
         */
        calcTotalPrice:function(){
            _this.formdata.nums=0; //货品总数
            _this.formdata.payment=0; //货款总额
            _this.formdata.tax_total=0; //税款总额
            _this.formdata.total=0; //合计总额
            _this.formdata.goodslist.forEach(function(v){
                _this.formdata.nums=_this.formatFloat(_this.formdata.nums+v.nums,5);
                _this.formdata.payment=_this.formatFloat(_this.formdata.payment+v.notax_total,6);
                _this.formdata.tax_total=_this.formatFloat(_this.formdata.tax_total+v.tax_total,6);
                _this.formdata.total=_this.formatFloat(_this.formdata.total+v.total,6);
            });
        },
        /*******************操作按钮*****************/
        /**
         * 新增
         */
        addPurOrder:function(){
            _this.$router.push({query:{orderid:""}});
            _this.formdata=JSON.parse(JSON.stringify(form));
            _this.initDate();
            localStorage.setItem('pch_orderId',"");
            _this.isedit=false;
        },
        /**
         * 修改
         */
        editPurOrder:function(type){
           if(_this.formdata.ischeck==1) return false;
           if(type){ //取消
              if(!_this.isedit) return false;
              _this.init();
              _this.isedit=false;
           }else{
              if(_this.isedit) return false;
              _this.isedit=true;
           }
        },
        /**
         *  保存
         */
        savePurOrder:function(){
            if((_this.formdata.orderid.length>0 && !_this.isedit) || _this.save_loading) return false;
            if(_this.formdata.ischeck==1){
                return _this.alertMsg("单据已审核，不能再修改保存",'error');
            }
            if(_this.formdata.sup_code.length==0){
                return _this.alertMsg("请选择供应商信息",'error');
            }
            if(_this.formdata.sup_sell.length==0){
                return _this.alertMsg("请选择供方销售人员",'error');
            }
            if(_this.formdata.sup_contact.length==0){
                return _this.alertMsg("请选择供方联系人",'error');
            }
            if(_this.formdata.settle_type.length==0){
                return _this.alertMsg("请选择结算方式",'error');
            }
            _this.save_loading=true;
            _this.common.http({url:'savePurOrder',data:_this.formdata}).then(function(res){
                _this.save_loading=false;
                var issucess=true;
                var content=res.msg;
                if(res.status==1){
                   _this.isedit=false;
                   localStorage.setItem("pch_orderId",res.orderid);
                   _this.formdata.orderid=res.orderid;
                }else issucess=false;
                _this.$refs.windowTipRef.open({title:"操作提示",content:content,issucess:issucess,isconfirm:false});
            }).catch(function(err) {
                _this.save_loading=false;
                _this.common.httpErr(err.data,_this);
            });
        },
        /**
         * 审核
         */
        checkPurOrder:function(){
            var orderid=_this.formdata.orderid;
            if(orderid==null || orderid.length==0 || _this.isedit) return false;
            if(_this.formdata.ischeck==1){
                return _this.alertMsg("该采购订单已审核，不能进行审核",'error');
            }
            _this.$Modal.confirm({
                title:'审核提示',
                content:'确定审核采购订单【'+orderid+'】吗？',
                onOk:function(){
                    _this.common.http({url:'checkPurOrder',data:{orderid:orderid}}).then(function(res){
                        if(res.status==1){
                            _this.formdata.ischeck=1;
                            _this.formdata.check_code=res.check.code;
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
        backPurOrder:function(){
            var orderid=_this.formdata.orderid;
            if(orderid==null || orderid.length==0 ||  _this.isedit) return false;
            if(_this.formdata.ischeck!=1){
                return _this.alertMsg("该采购订单未审核，不能进行还原",'error');
            }
            if(_this.formdata.istrans==1){
               return _this.alertMsg("该采购订单已生成过来货登记单，不能进行还原",'error');
            }
            if(_this.formdata.ispay==1){
               return _this.alertMsg("该采购订单已生成过预付款单，不能进行还原",'error');
            }
            _this.common.http({url:'backPurOrder',data:{orderid:orderid}}).then(function(res){
                var issucess=true;
                if(res.status==1){
                    _this.formdata.ischeck=0;
                }else issucess=false;
                _this.$refs.windowTipRef.open({title:"还原提示",content:res.msg,issucess:issucess,isconfirm:false});
            }).catch(function(err){
                _this.common.httpErr(err.data,_this);
            });
        },
        /**
         * 结案
         */
        closePurOrder:function(){
             var orderid=_this.formdata.orderid;
             if(orderid==null || orderid.length==0 || _this.formdata.isclose==1 ||  _this.isedit) return false;
             if(_this.formdata.ischeck!=1){
                 return _this.alertMsg("该采购订单尚未审核，不能结案。您可以选择删除来作废此单！",'error');
             }
             _this.$Modal.confirm({
                title:'操作提示',
                content:'确定结案采购订单【'+orderid+'】吗？一旦结案该订单将不能进行转单操作！',
                onOk:function(){
                    _this.common.http({url:'closePurOrder',data:{orderid:orderid}}).then(function(res){
                        var issucess=true;
                        if(res.status==1){
                            _this.formdata.isclose=1;
                        }else issucess=false;
                        _this.$refs.windowTipRef.open({title:"操作提示",content:res.msg,issucess:issucess,isconfirm:false});
                    }).catch(function(err){
                        _this.common.httpErr(err.data,_this);
                    });
                }
             });
        },
        /**
         * 转单（转来货登记单）
         */
        generateRegisterOrder:function(){
            var orderid=_this.formdata.orderid;
            if(orderid==null || orderid.length==0 ||  _this.isedit) return false;
            if(_this.formdata.ischeck!=1){
                return _this.alertMsg("该采购订单未审核，不能进行转单",'error');
            }
            if(_this.formdata.isclose==1){
                return _this.alertMsg("该采购订单已结案，不能进行转单",'error');
            }
            _this.$Modal.confirm({
               title:'转单提示',
               content:'确定要将采购订单【'+orderid+'】转为来货登记单吗？',
               onOk:function(){
                   _this.common.http({url:'generateRegOrder',data:{orderid:orderid}}).then(function(res){
                       if(res.status==1){
                           _this.formdata.istrans=1;
                           var content="<p>采购订单【"+orderid+"】已成功转出到【"+res.orderid+"】来货登记单!</p>";
                           content+='<br/><p>确定要查看该单据吗？</p>';
                           _this.$refs.windowTipRef.open({
                                  title:"转单提示",
                                  content:content,
                                  issucess:true,
                                  isconfirm:true
                           },"/registerEdit",function(){
                              localStorage.setItem("edit_register_orderid",res.orderid);
                           });
                       }else{
                           _this.$refs.windowTipRef.open({title:"转单提示",content:res.msg,issucess:false,isconfirm:false});
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
.orderform{
   width:1200px;
}
.olsize{
  padding-left:15px;
}
.order_sup_sel{
   .left{width:70px;display:inline-block;float:left;}
   .right{width:190px;display:inline-block;cursor:pointer;float:left;margin-left:5px;}
}
.order_sales_sel{
   .left{width:70px;display:inline-block;float:left;}
   .right{width:190px;display:inline-block;cursor:pointer;float:left;margin-left:5px;}
}
.order_pay_sel{
   .left{width:110px;float:left;}
   .right{
     width:145px;display:inline-block;float:left;margin-left:10px;
     .puts{
        width:70px;display:inline-block;text-align:center;
     }
   }
}
.purOrderSta{
    box-sizing:border-box;
    .title{width:46px;float:left;line-height:32px;}
    .ckstatus{width:74px;float:left;}
    .status{
       height:32px;line-height:32px;text-align:center;font-size:14px;margin-bottom:10px;padding:0;
    }
}
.pur_order_foot{
    height:120px;
    padding:10px 0;
}
</style>
