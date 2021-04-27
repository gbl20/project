<template>
  <div>
     <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
         <div slot="form-ser">
            <div class="nav-menu">
               <Button :disabled="order.is_transfer==1 || isedit" @click="handleEdit">
                  <span class="icon iconfont">&#xe791;</span>修改
               </Button>
               <Button :disabled="order.is_transfer==1 || !isedit" @click="saveEdit">
                  <span class="icon iconfont">&#xe792;</span>保存
               </Button>
               <Button :disabled="order.is_transfer==1 || !isedit" @click="cancelEdit">
                  <span class="icon iconfont">&#xe792;</span>取消
               </Button>
               <Divider type="vertical"/>
               <Button :disabled="order.is_transfer==1 || isedit" @click="auditOrder">
                  <span class="icon iconfont">&#xe692;</span>审核
               </Button>
               <Button :disabled="order.is_transfer!=1 || isedit" @click="backOrder">
                  <span class="icon iconfont">&#xe693;</span>还原
               </Button>
               <Divider type="vertical"/>
               <Button @click="refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
               <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
               <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
            </div>
            <div class="ser-form">
               <Form class="stockOutForm" :label-width="80" label-position="left" :disabled="order.is_transfer==1 || !isedit">
                  <Row>
                    <Col span="5">
                        <FormItem label="单据编号">
                             <Input :value="order.orderid" disabled></Input>
                        </FormItem>
                        <FormItem label="出库日期">
                             <DatePicker type="date" :editable="false" :clearable="false" :value="order.f_date" disabled></DatePicker>
                        </FormItem>
                        <FormItem label="对应单号">
                             <Input :value="order.p_order_no" disabled></Input>
                        </FormItem>
                        <FormItem label="流水号">
                            <Input :value="order.rec_no" disabled></Input>
                        </FormItem>
                    </Col>
                    <Col span="10" class="leftCol">
                        <FormItem label="客户单位">
                            <Row>
                              <Col span="6" class="padRight">
                                  <Input :value="order.cust_no" disabled></Input>
                              </Col>
                              <Col span="18">
                                  <Input :value="order.cust_name" disabled></Input>
                              </Col>
                            </Row>
                        </FormItem>
                        <Row>
                          <Col span="12">
                              <FormItem label="出货仓库">
                                 <Row>
                                    <Col span="10" class="padRight">
                                        <Input :value="order.ware_code" disabled></Input>
                                    </Col>
                                    <Col span="14">
                                        <Input :value="order.ware_title" disabled></Input>
                                    </Col>
                                 </Row>
                              </FormItem>
                          </Col>
                          <Col span="12" class="leftCol">
                              <FormItem label="购方部门" :label-width="65">
                                 <Input v-if="JSON.stringify($store.state.depart)!='[]'" :value="$store.state.depart[order.dept_id]" disabled></Input>
                              </FormItem>
                          </Col>
                        </Row>
                        <Row>
                          <Col span="12">
                              <FormItem label="发货员">
                                 <Row>
                                   <Col span="10" class="padRight">
                                      <Input disabled :value="order.shipper"></Input>
                                   </Col>
                                   <Col span="14">
                                      <Input icon="ios-more" :value="$store.state.emp[order.shipper]" class="cursor" @on-click="clickSelShipper" readonly></Input>
                                   </Col>
                                 </Row>
                              </FormItem>
                          </Col>
                          <Col span="12" class="leftCol">
                              <FormItem label="验货员" :label-width="65">
                                 <Row>
                                   <Col span="10" class="padRight">
                                       <Input :value="order.emp_no" disabled></Input>
                                   </Col>
                                   <Col span="14">
                                      <Input :value="$store.state.emp[order.emp_no]" @on-click="clickVerifyUser(1)" icon="ios-more" class="cursor" readonly></Input>
                                   </Col>
                                 </Row>
                              </FormItem>
                          </Col>
                        </Row>
                        <FormItem label="备注说明">
                           <Input v-model="order.remark"></Input>
                        </FormItem>
                    </Col>
                    <Col span="5" class="leftCol">
                        <FormItem label="货品总数">
                            <Input :value="order.goods_qty" disabled></Input>
                        </FormItem>
                        <FormItem label="货款总额">
                            <Input :value="order.goods_sum" disabled></Input>
                        </FormItem>
                        <FormItem label="复核员">
                           <Row>
                             <Col span="10" class="padRight">
                                 <Input :value="order.audit" disabled></Input>
                             </Col>
                             <Col span="14">
                                 <Input :value="$store.state.emp[order.audit]" disabled></Input>
                             </Col>
                           </Row>
                        </FormItem>
                        <FormItem label="第二复核员">
                           <Row>
                             <Col span="10" class="padRight">
                                <Input :value="order.audit2" disabled></Input>
                             </Col>
                             <Col span="14">
                                <Input :value="$store.state.emp[order.audit2]" @on-click="clickVerifyUser(2)" icon="ios-more" class="cursor" readonly></Input>
                             </Col>
                           </Row>
                        </FormItem>
                    </Col>
                    <Col span="4" class="leftCol stockOutSta">
                        <div class="title title-color">状态：</div>
                        <div class="ckstatus">
                            <div :class="order.is_transfer==1?'status success-bg-text':'status warning-bg-text'">{{order.is_transfer==1?'已审核':'未审核'}}</div>
                        </div>
                    </Col>
                  </Row>
               </Form>
            </div>
         </div>
         <div slot="table-list">
            <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="order.list" border class="table-m"
                :height="height" @on-row-click="selectGoodsRow">
                <template slot-scope="row" slot="quality_state">
                    <span v-if="order.is_transfer==1 || !isedit">{{row.row.quality_state}}</span>
                    <Select v-model="order.list[row.index].quality_state" v-else>
                       <Option v-for="(p,k) in $store.state.sysParam['quality_status']" :key="k" :value="p">{{p}}</Option>
                    </Select>
                </template>
                <template slot-scope="row" slot="goods_state">
                    <span v-if="order.is_transfer==1 || !isedit">{{row.row.goods_state}}</span>
                    <Select v-model="order.list[row.index].goods_state" v-else>
                       <Option v-for="(p,k) in $store.state.sysParam['goods_status']" :key="k" :value="p">{{p}}</Option>
                    </Select>
                </template>
            </Table>
         </div>
      </split-none>
      <!-- 弹出操作提示 -->
      <window-tip ref="windowTipRef"></window-tip>
      <!-- 选择发货员 -->
      <select-employee ref="selectEmployeeRef" @selemp="confirmEmployeeRef"></select-employee>
      <!-- 选择复核员、验货员 -->
      <verify-user ref="verifyUserRef" @confirm="confirmVerifyUser"></verify-user>
      <!-- 选择库存货位 -->
      <choose-warepos ref="chooseWareposRef" @confirm="confirmWarePos"></choose-warepos>
  </div>
</template>
<script>
  var _this;
  import splitNone from '@/components/public/splitNone'
  import windowTip from '@/components/common/WindowTip'
  import selectEmployee from '@/components/common/SelectEmployee'
  import verifyUser from '@/components/common/VerifyUser'
  import chooseWarepos from '@/components/common/ChooseWarePosition'
  export default {
      components:{splitNone,windowTip,selectEmployee,verifyUser,chooseWarepos},
      name:"StockOutList",
      data(){
        return {
            height:0,
            Breadcrumb:[{title:'仓储物流'},{title:'出库登记/复核查询',url:'StockOutList'},{title:'出库登记/复核'}],
            isedit:false,
            orderid:"",
            order:{list:[],is_transfer:0},
            columns:[
                {title:'项次',key:'item_no',width:70,fixed:'left',align:'center'},
                {title:'商品编号',key:'goods_code',fixed:'left',width:100,align:'center'},
                {title:'商品名称',key:'goods_name',minWidth:180},
                {title:'通用名称',key:'nomal_name',minWidth:180},
                {title:'规格',key:'specs',minWidth:140,align:'center'},
                {title:'剂型',key:'dosage',minWidth:140,align:'center'},
                {title:'单位',key:'unit',width:90,align:'center'},
                {title:'数量',key:'qty',width:120,align:'center'},
                {title:'单价',key:'price',width:120,align:'center',render:(h, params)=>{return this.custRender.renderInput(this, h, params, 'price', 1)}},
                {title:'合计',key:'amount',width:120,align:'center'},
                {title:'成本金额',key:'cost',width:120,align:'center'},
                {title:'存货仓位',key:'pos_code',width:120,align:'center',render:(h,params)=>{return this.custRender.renderInput(this, h, params, 'pos_code', 0)}},
                {title:'生产批号/序列号',key:'batch_no',width:140,align:'center'},
                {title:'生产日期',key:'prod_date',width:100,align:'center'},
                {title:'有效期至',key:'valid_date',width:100,align:'center'},
                {title:'产地',key:'origin',width:120,align:'center'},
                {title:'生产企业',key:'production',minWidth:220},
                {title:'商品大类',key:'category',minWidth:140},
                {title:'大包装数量',key:'pack_specs2',minWidth:120,align:'center'},
                {title:'中包装数量',key:'pack_specs1',minWidth:120,align:'center'},
                {title:'批次',key:'group_no',width:120,align:'center'},
                {title:'质量状态',slot:'quality_state',width:100,align:'center'},
                {title:'货品状态',slot:'goods_state',width:100,align:'center'},
                {title:'对应单号',key:'p_order_no',width:160,align:'center'},
                {title:'供应商编号',key:'prov_no',width:90,align:'center'},
                {title:'供应商名称',key:'prov_name',minWidth:200,align:'center'},
                {title:'批准文号/注册证号',key:'approval_code',minWidth:150},
                {title:'参考批发价',key:'standard_price',width:120,align:'center'},
                {title:'参考零售价',key:'retail_price',width:120,align:'center'},
                {title:'原发货价',key:'orig_price',width:120,align:'center'},
                {title:'出库流水号',key:'rec_no',width:120,align:'center'},
                {title:'成本单价',key:'cost_price',width:120,align:'center'},
                {title:'追溯号',key:'trace_back_no',minWidth:150,render:(h,params)=>{return this.custRender.renderInput(this, h, params, 'trace_back_no')}},
                {title:'灭菌批号',key:'germicidal_no',minWidth:150,render:(h,params)=>{return this.custRender.renderInput(this, h, params, 'germicidal_no')}},
                {title:'储存条件',key:'storage_type',width:120,align:'center'},
                {title:'生产许可证编号',key:'license_key',minWidth:150},
                {title:'备注说明',key:'remark',minWidth:180,render:(h,params)=>{return this.custRender.renderInput(this, h, params, 'remark')}}
            ],
            selectGoodsIndex:0, //商品列表索引
            selectVerifyIndex:1, //区分复核员、验货员
        }
      },
      beforeCreate:function(){
         _this=this;
      },
      created:function(){
         var orderid=localStorage.getItem("StockOutOrderId");
         if(typeof(orderid)=='undefined' || orderid==null || orderid.length==0){
            _this.$refs.windowTipRef.open({title:"温馨提示",content:"请求参数异常",issucess:false,isconfirm:false},"",function(){
                _this.delView();
            });
            return false;
         }
         _this.orderid=orderid;
         _this.init();
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          if(from.name == 'StockOutList'){
            var orderid=localStorage.getItem('StockOutOrderId');
            if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
            vm.orderid = orderid;
          }
        });
      },
      watch:{
        orderid:function(e){
           if(this.isedit){
             this.$Modal.confirm({
               title:'温馨提示',
               content:'页面正处于编辑状态，确定要放弃修改吗？',
               okText:'继续',
               onOk:()=>{this.init();}
             });
           }else this.init();
        }
      },
      methods:{
        selectGoodsRow:function(row,index){
           _this.selectGoodsIndex=index;
        },
        rowClassName(row,index){
          if(_this.isedit) _this.$set(_this.order.list[index],'isEdit',true);
          else _this.$set(_this.order.list[index],'isEdit',false);
          if (index === _this.selectGoodsIndex) {
            return 'ivu-table-row-highlight';
          }
          return '';
        },
        inputEach:function(fun,key,index){
           if(fun=='blur' && key=="price"){
              _this.$set(_this.order.list[index],key,_this.custRender.KValue);
              var amount=_this.formatFloat(_this.custRender.KValue*_this.order.list[index].qty,6);
              _this.$set(_this.order.list[index],"amount",amount);
           }
           //选择存货仓位
           if(key=='pos_code'){
              _this.$refs.chooseWareposRef.open(_this.order.ware_code);
           }
           if(key=='trace_back_no' || key=='germicidal_no' || key=='remark'){
              _this.$set(_this.order.list[index],key,_this.custRender.KValue);
           }
        },
        /**
         * 确认选择（存货仓位）
         */
        confirmWarePos:function(data){
            _this.order.list[_this.selectGoodsIndex].pos_code=data.pos_code;
        },
        DHeight:function(e){
           _this.height = e;
        },
        refresh:function(){
           _this.init();
        },
        init:function(){
           _this.common.http({url:'w/getStockOutInfo',data:{orderid:_this.orderid}}).then(function(res){
               if(res.status==1 && res.order!=null){
                 _this.order=res.order;
               }else{
                 _this.$refs.windowTipRef.open({title:"温馨提示",content:"请求参数异常",issucess:false,isconfirm:false},"",function(){
                     _this.delView();
                 });
               }
           }).catch(function(err){
               _this.common.httpErr(err.data,_this);
           });
        },
        /*****************选择发货人***************/
        clickSelShipper:function(){
            if(_this.order.is_transfer==1 || !_this.isedit) return false;
            _this.$refs.selectEmployeeRef.init();
        },
        confirmEmployeeRef:function(data){
            if(_this.order.is_transfer==1 || !_this.isedit) return false;
            _this.order.shipper=data.code;
        },
        /***********选择复核员、验货员*************/
        clickVerifyUser:function(index){
           if(_this.order.is_transfer==1 || !_this.isedit) return false;
           _this.selectVerifyIndex=index;
           _this.$refs.verifyUserRef.open();
        },
        confirmVerifyUser:function(data){
            if(_this.order.is_transfer==1 || !_this.isedit) return false;
            if(_this.selectVerifyIndex==1) _this.order.emp_no=data.code;
            if(_this.selectVerifyIndex==2) _this.order.audit2=data.code;
        },
        /*****************按钮操作****************/
        /**
         * 修改
         */
        handleEdit:function(){
           if(_this.order.is_transfer==1 || _this.isedit) return false;
           _this.isedit=true;
        },
        /**
         * 取消
         */
        cancelEdit:function(){
          if(_this.order.is_transfer==1 || !_this.isedit) return false;
          _this.isedit=false;
        },
        /**
         * 保存
         */
        saveEdit:function(){
          if(_this.order.is_transfer==1 || !_this.isedit) return false;
          _this.common.http({url:'w/saveStockOut',data:_this.order}).then(function(res){
              if(res.status==1){
                 _this.isedit=false;
                 _this.init();
                 _this.$Modal.success({title:"温馨提示",content:"保存已成功"});
              }else{
                 _this.$Modal.error({title:"温馨提示",content:res.msg});
              }
          }).catch(function(err){
              _this.common.httpErr(err.data,_this);
          });
        },
        /**
         * 审核
         */
        auditOrder:function(){
            if(_this.order.is_transfer==1 || _this.isedit) return false;
            var orderid=_this.orderid;
            _this.$Modal.confirm({
                title:'审核提示',
                content:'要审核出库复核单【'+orderid+'】吗？',
                onOk:function(){
                    _this.common.http({url:'w/auditStockOrder',data:{orderid:orderid}}).then(function(res){
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
        backOrder:function(){
            if(_this.order.is_transfer!=1 || _this.isedit) return false;
            var orderid=_this.orderid;
            _this.$Modal.confirm({
                title:'还原提示',
                content:'要还原出库复核单【'+orderid+'】吗？',
                onOk:function(){
                    _this.common.http({url:'w/backStockOrder',data:{orderid:orderid}}).then(function(res){
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
        }
      }
  }
</script>
<style lang="less">
.stockOutForm{
    width:1200px;overflow:hidden;padding:10px 0;
    .leftCol{padding-left:20px;}
    .padRight{padding-right:5px;}
    .cursor{cursor:pointer;}
    .stockOutSta{
        box-sizing:border-box;
        .title{width:46px;float:left;line-height:32px;}
        .ckstatus{width:74px;float:left;}
        .status{
           height:32px;line-height:32px;text-align:center;font-size:14px;margin-bottom:10px;padding:0;
        }
    }
}
</style>
