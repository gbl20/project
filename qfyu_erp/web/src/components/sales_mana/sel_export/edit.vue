<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                <Button @click="comData" :loading="subLoading" :disabled="!(isEdit && !formData.is_transfer)"><span class="icon iconfont">&#xe792;</span>保存</Button>
                <Button @click="isEdit = true" :disabled="!formData.is_transfer?isEdit:true"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button @click="init" :disabled="!(isEdit && !formData.is_transfer)"><span class="icon iconfont">&#xe6a2;</span>取消</Button>
                <Divider type="vertical"/>
                <Button :disabled="!(formData.orderid && !formData.is_transfer && !isEdit)" @click="auditOrder"><span class="icon iconfont">&#xe692;</span>审核</Button>
                <Button :disabled="!(formData.is_transfer && !isEdit)" @click="reductionOrder"><span class="icon iconfont">&#xe693;</span>还原</Button>
                <Button :disabled="!(formData.is_transfer && !isEdit)" @click="transferOrder"><span class="icon iconfont">&#xe695;</span>出库</Button>
                <Divider type="vertical"/>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>关闭</Button>
              </div>
          </div>
          <div slot="table-list">
            <div class="height_5"></div>
            <Form ref="formRef" :model="formData" :rules="ruleVal" :label-width="78" label-position="right" :disabled="!isEdit">
              <div class="form-list">
                <Row>
                  <Col span="21">
                      <Row>
                        <Col span="6">
                          <FormItem label="单据编号" :label-width="66">
                            <Input v-model="formData.orderid" placeholder="保存系统自动生成" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem label="客户编号" prop="cust_no">
                            <Input v-model="formData.cust_no" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="8">
                          <FormItem :label-width="5">
                            <Input icon="ios-more" v-model="formData.cust_name" readonly style="cursor:pointer;" @on-click="clickSelCustmoer"></Input>
                          </FormItem>
                        </Col>
                        <Col span="6 ">
                          <FormItem label="结算方式" prop="pay_mode_no">
                            <Select v-model="formData.pay_mode_no" @on-change="changePayMode">
                             <Option v-for="(item,key) in $store.state.settlement" :value="key" :key="key">{{item}} ( {{key}} )</Option>
                            </Select>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="5">
                          <FormItem label="单据日期" :label-width="66">
                            <DatePicker type="date" :editable="false" placeholder="签约日期" v-model="formData.f_date" disabled></DatePicker>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="采购人员" :label-width="66">
                            <Input icon="ios-more" v-model="formData.link_man" readonly style="cursor:pointer;" @on-click="clickSelCustmoerSales(1)"></Input>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="联系人" :label-width="60">
                            <Input icon="ios-more" v-model="formData.contacts" readonly style="cursor:pointer;" @on-click="clickSelCustmoerSales(0)"></Input>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="购方部门" :label-width="66">
                            <Input :value="cust_data.depart" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem label="货物件数" :label-width="66">
                             <Input v-model="formData.pack_qty"></Input>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="6">
                          <FormItem label="来源订单" :label-width="66">
                            <Input :value="cust_data.order_no" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="3">
                          <FormItem label="业务员" :label-width="55">
                            <Input :value="formData.emp_no" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem :label-width="5">
                             <Input icon="ios-more" :value="$store.state.emp[formData.emp_no]" readonly style="cursor:pointer;"  @on-click="chooseEmp('emp_no')"></Input>
                          </FormItem>
                        </Col>
                        <Col span="11">
                          <FormItem label="送货地址" :label-width="66">
                            <Select v-model="formData.pick_addr" >
                              <Option v-if="cust_data.warehouse" :value="cust_data.warehouse">{{cust_data.warehouse}}</Option>
                              <Option v-if="cust_data.swarehouse" :value="cust_data.swarehouse">{{cust_data.swarehouse}}</Option>
                              <Option v-if="cust_data.twarehouse" :value="cust_data.twarehouse">{{cust_data.twarehouse}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="5">
                          <FormItem label="所属部门" :label-width="66">
                            <Input v-model="formData.dept_id"></Input>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="联系电话" :label-width="66">
                            <Select v-model="formData.link_tel" >
                              <Option v-if="telPhone.tel" :value="telPhone.tel">{{telPhone.tel}}</Option>
                              <Option v-if="telPhone.phone" :value="telPhone.phone">{{telPhone.phone}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                        <Col span="3">
                          <FormItem label="拣货人" :label-width="55">
                            <Input :value="formData.pick_worker" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem :label-width="5">
                             <Input icon="ios-more" :value="$store.state.emp[formData.pick_worker]" readonly style="cursor:pointer;"  @on-click="chooseEmp('pick_worker')"></Input>
                          </FormItem>
                        </Col>
                        <Col span="3">
                          <FormItem label="装箱人" :label-width="55">
                            <Input :value="formData.pack_worker" disabled></Input>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem :label-width="5">
                             <Input icon="ios-more" :value="$store.state.emp[formData.pack_worker]" readonly style="cursor:pointer;"  @on-click="chooseEmp('pack_worker')"></Input>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="5">
                          <FormItem label="付款日期" :label-width="66">
                            <DatePicker type="date" :editable="false" placeholder="付款日期" v-model="formData.pay_date"></DatePicker>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="合同号" :label-width="55">
                            <Input v-model="formData.contract_no" readonly style="cursor:pointer;" @on-click="clickContract"></Input>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="送货线路" :label-width="66">
                            <Select v-model="formData.deliver_line" >
                              <Option v-if="cust_data.deliroute" :value="cust_data.deliroute">{{cust_data.deliroute}}</Option>
                              <Option v-if="cust_data.sdeliroute" :value="cust_data.sdeliroute">{{cust_data.sdeliroute}}</Option>
                              <Option v-if="cust_data.tdeliroute" :value="cust_data.tdeliroute">{{cust_data.tdeliroute}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="发货方式" :label-width="66">
                            <Select v-model="formData.deliver_kind" v-if="$store.state.sysParam">
                               <Option v-for="(item,index) in $store.state.sysParam['delivery_method']" :key="index" :value="item">{{item}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem label="流水号" :label-width="55">
                            {{formData.rec_no}}
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="5">
                          <FormItem label="快递公司" :label-width="66">
                            <Input v-model="formData.express_corp"></Input>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="快递单号" :label-width="66">
                            <Input v-model="formData.express_no"></Input>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="发货优先级" :label-width="85">
                            <Select v-model="formData.deliver_level" v-if="$store.state.sysParam">
                               <Option v-for="(item,index) in $store.state.sysParam['delivery_level']" :key="index" :value="item">{{item}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                        <Col span="5">
                          <FormItem label="优先发货原因" :label-width="90">
                            <Select v-model="formData.priority_reasons" filterable allow-create @on-create="handleDeliverCause">
                               <Option v-for="(item,index) in deliverCauseData" :key="index" :value="item.label">{{item.label}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                        <Col span="4">
                          <FormItem label="" :label-width="10">
                            <Checkbox v-model="formData.null" :true-value="1" :false-value="0" disabled>WMS验货完成</Checkbox>
                          </FormItem>
                        </Col>
                      </Row>
                  </Col>
                  <Col span="3">
                    <FormItem label="状态" :label-width="40">
                      <div :class="formData.is_transfer?'success-bg-text':'warning-bg-text'" style="text-align: center;">{{formData.is_transfer?'已审核':'未审核'}}</div>
                      <div class="violet-bg-text" style="text-align: center;margin-top:5px;">{{formData.is_transfer?'已结算':'未结算'}}</div>
                    </FormItem>
                    <FormItem label="" :label-width="40">
                      <Checkbox v-model="formData.fungible" :true-value="1" :false-value="0">代销发货</Checkbox>
                    </FormItem>
                    <FormItem label="" :label-width="40">
                      <Checkbox v-model="formData.need_deliver" :true-value="1" :false-value="0">需要送货</Checkbox>
                    </FormItem>
                    <FormItem label="" :label-width="40">
                      <Button type="primary" @click="chooseGoods"><span class="icon iconfont">&#xe797;</span>增加产品</Button>
                      <Button type="default" @click="removeGoods" style="margin-top:5px;"><span class="icon iconfont">&#xe793;</span>删除产品</Button>
                    </FormItem>
                  </Col>
                </Row>

              </div>
              <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height-320"
                      @on-row-click="(row,index)=>{selectGoodsIndex(index,false)}"
                      @on-row-dblclick="(row,index)=>{selectGoodsIndex(index,true)}">
                <template slot-scope="{row,index}" slot="item_no">{{(row.item_no&&!isEdit)?row.item_no:(index+1)}}</template>
                <template slot-scope="{row,index}" slot="quality_state">
                  <Select v-if="row.isEdit && JSON.stringify($store.state.sysParam) != '[]'" :value="row.quality_state" @on-change="changeSlot($event,'quality_state',index)">
                    <Option v-for="(item,index) in $store.state.sysParam['quality_status']" :value="item" :key="item">{{item}}</Option>
                  </Select>
                  <div v-else>{{row.quality_state}}</div>
                </template>
                <template slot-scope="{row,index}" slot="goods_state">
                  <Select v-if="row.isEdit && JSON.stringify($store.state.sysParam) != '[]'" :value="row.goods_state" @on-change="changeSlot($event,'goods_state',index)">
                    <Option v-for="(item,index) in $store.state.sysParam['goods_status']" :value="item" :key="item">{{item}}</Option>
                  </Select>
                  <div v-else>{{row.goods_state}}</div>
                </template>
              </Table>
              <div class="height_5"></div>
              <div class="form-list">
                <Row>
                  <Col span="4">
                    <FormItem label="货品总数" :label-width="66">
                      <Input v-model="formData.goods_qty" placeholder="货品总数" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="货款" :label-width="40">
                      <Input v-model="formData.goods_sum" placeholder="货款" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="税款" :label-width="40">
                      <Input v-model="formData.tax_sum" placeholder="税款" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="合计" :label-width="40">
                      <Input v-model="formData.amount" placeholder="合计" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="毛利" :label-width="40">
                      <Input v-model="formData.ref_profit" placeholder="毛利" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="毛利率" :label-width="55">
                      <Input v-model="formData.ref_profit_rate" placeholder="毛利率" disabled></Input>
                    </FormItem>
                  </Col>
                </Row>
                <Row>
                  <Col span="4">
                    <FormItem label="退补合计" :label-width="66">
                      <Input v-model="formData.up_amount" placeholder="退补合计" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="8">
                    <FormItem label="备注" :label-width="40">
                      <Input v-model="formData.remark" placeholder="备注"></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="创建者" :label-width="55">
                      <FormItem :label-width="5">
                        {{$store.state.emp[formData.creater]}}
                      </FormItem>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="创建日期" :label-width="66">
                      <FormItem :label-width="5">
                        {{formData.create_date}}
                      </FormItem>
                    </FormItem>
                  </Col>
                  <Col span="3">
                    <FormItem label="复核员 " :label-width="55">
                      <Input :value="$store.state.emp[formData.audit]" disabled></Input>
                    </FormItem>
                   </Col>
                </Row>
              </div>
            </Form>
          </div>
      </split-none>
      <select-customer ref="chooseCustomerRef" @selcust="confirmCustomer"></select-customer>
      <select-customer-sales ref="chooseCustomerSalesRef" @selCustSales="selCustSales"></select-customer-sales>
      <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
      <select-goods ref="selectGoodsRef" :isSignle="false" @selectRow="selectGoods"></select-goods>
      <choose-sales-contract ref="SalesContractRef" :custCode="cust_data.id" @conData="conContract"></choose-sales-contract>
      <select-price ref="selectPriceRef" @confirm="confirmSelPrice"></select-price>
      <choose-batch-no ref="chooseBatchRef" @confirm="confirmBatch"></choose-batch-no>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import selectCustomer from '@/components/common/SelectCustomer'
  import SelectCustomerSales from '@/components/common/SelectCustomerSales'
  import selectEmployee from '@/components/common/SelectEmployee'
  import selectGoods from '@/components/common/ChooseGoods'
  import ChooseSalesContract from '@/components/common/ChooseSalesContract'
  import selectPrice from '@/components/common/SelectPrice'
  import ChooseBatchNo from '@/components/common/ChooseBatchNo'
  var formD = {orderid:'',f_date:null,valid_date:'',emp_no:'',emp_name:'',audit:null,cust_no:'',cust_name:'',link_man:'',goods_sum:"",tax_sum:0,amount:0,goods_qty:0,pay_mode_no:'',is_transfer:0,is_finish:0,remark:'',print_count:0,creater:'',create_date:'',mender:'',update_date:'',contacts:'',dept_id:0,deal_mode:'',carr_kind:'',pick_addr:'',mender:null,net_order_no:'',sign_addr:'',begin_date:null,end_date:null,contract_type:'',contract_no:'',pay_date:null,pre_pay:null,deal_date:null,express_corp:'',express_no:'',link_tel:null};
  export default {
    name:'sel_export_edit',
      components:{splitNone,selectCustomer,selectEmployee,SelectCustomerSales,selectGoods,ChooseSalesContract,selectPrice,ChooseBatchNo},
      data () {
          return {
              save_lock:false,
              height:0,
              Breadcrumb:[{title:'销售管理'},{title:'销售开单',url:'sel_export'},{title:'编辑销售开单'}],
              columns:[
                {title:'项次',slot:'item_no',width:100,align:'center'},
                {title:'商品编号',key:'goods_code',width:100,align:'center',resizable:true,esllipsis :true},
                {title:'商品名称',key:'goods_name',width:150,align:'center',resizable:true,ellipsis :true},
                {title:'规格',key:'specs',width:100,align:'center'},
                {title:'单位',key:'unit',width:90,align:'center'},
                {title:'数量',key:'s_qty',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this, h, params, 's_qty', 1)}},
                {title:'单价',key:'s_o_price',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this, h, params, 's_o_price', 1)}},
                {title:'折扣%',key:'s_rebate',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this, h, params, 's_rebate', 1)}},
                {title:'实际单价',key:'s_price',width:100,align:'center'},
                {title:'税率%',key:'s_tax_rate',width:90,align:'center',resizable:true, render: (h, params) => {return this.custRender.renderInput(this, h, params, 's_tax_rate', 1)}},
                {title:'无税单价',key:'s_un_tax_price',width:100,align:'center'},
                {title:'无税金额',key:'s_goods_sum',width:100,align:'center'},
                {title:'税款',key:'s_tax_sum',width:100,align:'center'},
                {title:'合计',key:'s_amount',width:100,align:'center'},
                {title:'参考批发价',key:'s_amount',width:100,align:'center'},
                {title:'参考零售价',key:'s_amount',width:100,align:'center'},
                {title:'货品状态',key:'s_amount',width:100,align:'center'},
                {title:'参考成本',key:'ref_cost',width:100,align:'center'},
                {title:'参考毛利',key:'ref_profit',width:100,align:'center'},
                {title:'参考毛利率',key:'ref_profit_rate',width:100,align:'center'},
                {title:'参考成本价',key:'ref_cost_price',width:100,align:'center'},
                {title:'客方产品编号',key:'cust_goods_code',width:100,align:'center'},
                {title:'备注',key:'remark',width:120,resizable:true,ellipsis :true,render: (h, params) => {return this.custRender.renderInput(this, h, params, 'remark')}},
                {title:'产地',key:'origin',width:150,resizable:true,ellipsis :true},
                {title:'生产企业',key:'production',width:200,resizable:true,ellipsis :true},
                {title:'剂型',key:'dosage',width:100},
                {title:'批准文号/注册证号',key:'approval_code',width:150},
                {title:'包装规格',key:'packspecs',width:100},
                {title:'质量状况',slot:'quality_state',resizable:true,width:100,align:'center'},
                {title:'货品状态',slot:'goods_state',resizable:true,width:100,align:'center'},
                {title:'已结算数量',key:'written_qty',width:100,align:'center'},
                {title:'整件数量',key:'s_whole_qty',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this, h, params, 's_whole_qty', 1)}},
                {title:'散件数量',key:'s_bulk_qty',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this, h, params, 's_bulk_qty', 1)}},
                {title:'生产批号',key:'batch_no',width:100,align:'center',ellipsis :true},
                {title:'生产日期',key:'prod_date',width:100,align:'center'},
                {title:'有效期至',key:'valid_date',width:150,resizable:true,ellipsis :true,align:'center'},
                {title:'供应商编号',key:'prov_no',width:120,resizable:true,ellipsis :true,align:'center'},
                {title:'仓库编号',key:'ware_code',width:120,resizable:true,ellipsis :true,align:'center'},
                {title:'仓库名称',key:'ware_title',width:150,resizable:true,ellipsis :true,align:'center'},
                {title:'货位',key:'berth_no',width:100,resizable:true,ellipsis :true,align:'center'},
                {title:'对应单号',key:'p_order_no',width:180,resizable:true,ellipsis :true,align:'center'}
              ],
              data:[],
              isEdit:false,
              checkIndex:-1,
              salesType:0,
              subLoading:false,
              cust_data:[],
              deliverCauseData:[],
              formData:JSON.parse(JSON.stringify(formD)),
              ruleVal:{
                cust_no:[
                  {required:true,message:'请选择客户',trigger:'change'}
                ],
                emp_no:[
                  {required:true,message:'请选择业务员',trigger:'change'}
                ],
                pay_mode_no:[
                  {required:true,message:'请选择结算方式',trigger:'change'}
                ]
              },
              telPhone:{tel:null,phone:null},
              quotation_orderid:localStorage.getItem('sel_export_orderid'),
              empIndex:'emp_no'
          }
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          if(from.name == 'sel_order_dtl' || from.name == 'sel_export'){
            vm.quotation_orderid = localStorage.getItem('sel_export_orderid');
          }
        });
      },
      watch:{
        quotation_orderid(e){
          if(this.isEdit){
            this.$Modal.confirm({
              title:'提示',
              content:'页面正处于编辑状态，确定要放弃修改吗？',
              okText:'继续',
              onOk:()=>{
                this.init();
              }
            });
          }else this.init();
        }
      },
      created:function(){
        this.init();
      },
      methods:{
        inputEach:function(fun,key,index){
          this.checkIndex = index;
          if(fun == 'click'){
            if(key == 's_qty'){
              this.$refs.chooseBatchRef.open(this.data[index]);
            }else if(key == 's_o_price'){
              this.$refs.selectPriceRef.open(this.data[index].goods_code);
            }else if(key == 'goods_code'){
              this.chooseGoods(index);
            }
          }else {
            if(key == 's_o_price' || key == 's_rebate' || key == 's_qty' || key == 's_price' || key == 's_tax_rate'){
               this.opPrice();
            }
            this.$set(this.data[index],key,this.custRender.KValue)
          }
        },
        init:function(){
          let _this = this;
          this.loadding = true;
          this.common.http({url:'s/editSelExportInit',data:{quotation_orderid:this.quotation_orderid}}).then(function(res){
            if(res.status==1){
               _this.$refs.formRef.resetFields()
              if(res.data){
                _this.data = res.data.details;
                _this.formData = res.data.data;
                _this.cust_data = res.data.cust_data;
                _this.deliverCauseData = res.data.deliver_cause;
                _this.isEdit = false;
                _this.telPhone.tel = res.data.cust_data.mannumber;
                _this.telPhone.phone = res.data.cust_data.telephone;
              }else{
                _this.formData = JSON.parse(JSON.stringify(formD));
                _this.data = [];
                _this.isEdit = true;
              }
            }
            _this.$nextTick(()=>{
              if(!res.data) _this.$refs.chooseEmployeeRef.init();
            })
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          });
        },
        handleDeliverCause:function(val){
          let obj = {value: val,label: val};
          this.deliverCauseData.push(obj);
        },
        comData:function(){
          let _this = this;
          this.subLoading = true;
          this.$refs.formRef.validate(function(valid){
            if (valid) {
              if(_this.data.length < 1){
                _this.subLoading = false;
                return _this.modalMsg('请选择产品');
              }
              _this.common.http({
                url: 's/comSelExport',data:{fdata:_this.formData,data:_this.data}
              }).then(function (res) {
                _this.alertMsg(res.msg,res.status != 1?'error':'');
                _this.subLoading = false;
                if(res.status == 1){
                  _this.init();
                }
              }).catch(function(err){
                _this.subLoading = false;
                _this.common.httpErr(err.data,_this);
              })
            }else{
              _this.subLoading = false;
            }
          })
        },
        changeSlot:function(e,key,index){
          this.$set(this.data[index],key,e)
        },
        changePayMode:function(e){
          if(this.isEdit && this.$store.state.sysConfig['lock_sel_pay_mode']){
            this.modalMsg('如果在客户资料中指定了结算方式，销售时不能修改结算方式！提示：可以通过修改业务参数（锁定销售结算方式）来取消此限制。')
            this.formData.pay_mode_no = this.cust_data.settlemode;
          }
        },
        clickContract:function(){
          this.$refs.SalesContractRef.open();
        },
        //审核
        auditOrder:function(){
          if(this.formData.is_transfer == 1) return false;
          let _this = this;
          this.common.http({
            url: 's/auditSelExport',data:{orderid:_this.formData.orderid}
          }).then(function (res) {
            _this.modalMsg(res.msg,'',(res.status != 1?'error':'success'));
            if(res.status == 1){
              _this.formData.audit = res.audit;
              _this.formData.is_transfer = 1;
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        },
        //还原
        reductionOrder:function(){
          if(!this.formData.is_transfer) return false;
          let _this = this;
          this.common.http({
            url: 's/reductionSelExport',data:{orderid:_this.formData.orderid}
          }).then(function (res) {
            _this.modalMsg(res.msg,'',(res.status != 1?'error':'success'));
            if(res.status == 1){
              _this.formData.audit = null;
              _this.formData.is_transfer = 0;
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        },
        //转单
        transferOrder:function(){
          if(!this.formData.is_transfer) return false;
          let _this = this;
          this.common.http({
            url: 's/transferSelExport',data:{orderid:_this.formData.orderid}
          }).then(function (res) {
            if(res.status == 1){
              _this.$Modal.confirm({
                title:'提示',
                content:res.msg,
                okText:'是',
                cancelText:'否',
                onOk:()=>{

                }
              });
            }else{
              _this.modalMsg(res.msg,'','error');
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        },
        conContract:function(e){
          this.formData.contract_no = e.contract_no;
        },
        clickSelCustmoer:function(){
          if(this.isEdit) this.$refs.chooseCustomerRef.init()
        },
        confirmCustomer:function(e){
          this.cust_data = e;
          this.formData.pay_mode_no = e.settlemode;
          this.formData.cust_no = e.id;
          this.formData.cust_name = e.name;
          this.salesType = 1;
          this.$refs.chooseCustomerSalesRef.open(e.id,1)
        },
        clickSelCustmoerSales:function(type){
          if(!this.isEdit) return false;
          this.salesType = type;
          if(this.formData.cust_no.length < 1){
            return this.modalMsg('请先选择客户编号');
          }else this.$refs.chooseCustomerSalesRef.open(this.formData.cust_no,type,true)
        },
        selCustSales:function(e){
          if(!e.data){
            this.formData.link_man = null;
            this.formData.contacts = null;
            this.telPhone.tel = res.data.cust_data.mannumber;
            this.telPhone.phone = res.data.cust_data.telephone;
          }else{
            if(this.salesType==1){
              this.formData.link_man = e.data.user_name;
              this.telPhone.tel = e.data.tel;
              this.telPhone.phone = e.data.phone;
              if(e.is_check) this.formData.contacts = '';
            }else{
              this.formData.contacts = e.data.user_name;
            }
          }
        },
        chooseEmp:function(empIndex){
          this.empIndex = empIndex;
          if(this.isEdit) this.$refs.chooseEmployeeRef.init();
        },
        confirmEmployee:function(e){
          this.formData[this.empIndex] = e.code;
          if(this.empIndex == 'emp_no'){
            this.formData.emp_name = e.name;
            if(!this.formData.f_date) this.formData.f_date = this.getDateVal();
          }
        },
        chooseGoods:function(){
          if(!this.formData.cust_no) return this.modalMsg('请先选择客户编号');
          if(!this.formData.emp_no) return this.modalMsg("请先选择业务员");
          if(this.isEdit) this.$refs.selectGoodsRef.open();
        },
        selectGoods:function(e){
          let data = {};
          data.item_no = null;
          data.orderid = null;
          data.goods_code = e.goods_code;
          data.goods_name = e.goods_name;
          data.specs = e.specs;
          data.unit = e.unit;
          data.qty = null;
          let o_price = e.commodity_price[this.cust_data.priceshe].price1
          if(!o_price) o_price = e.commodity_price[2].price1
          if(o_price) o_price = this.formatFloat(o_price*this.cust_data.pricecoeff,6);
          data.s_o_price = o_price;
          data.s_rebate = null;
          data.s_price = data.s_o_price;
          data.s_tax_rate = e.tax?parseFloat(e.tax):null;
          let tax = data.s_tax_rate || 0;
          tax = parseFloat(tax + 100);
          if(o_price > 0 && e.tax) data.s_un_tax_price = this.formatFloat(o_price/tax*100,6);
          else data.s_un_tax_price = null;
          data.s_goods_sum = 0;
          data.s_tax_sum = 0;
          data.s_amount = 0;
          data.cust_goods_code = null;
          data.remark = null;
          data.origin = e.origin;
          data.production = e.production;
          data.dosage = e.dosage;
          data.approval_code = e.approval_code;
          data.packspecs = e.packspecs;
          this.data.push(data);
          this.$nextTick(()=>{
            this.selectGoodsIndex(this.data.length - 1,true)
          })
        },
        selectGoodsIndex:function(index,type){
          this.checkIndex = index;
        },
        comGoodsDet:function(e){
          this.$set(this.data,this.checkIndex,e);
          this.opPriceNum();
        },
        opPriceNum:function(){
          let goods_qty = 0;
          let goods_sum = 0;
          let tax_sum = 0;
          let amount = 0;
          for(let i=0;i<this.data.length;i++){
            if(!this.data[i].goods_sum) continue;
            goods_qty = this.formatFloat(goods_qty + this.data[i].qty,0);
            goods_sum = this.formatFloat(goods_sum + this.data[i].goods_sum,6);
            tax_sum = this.formatFloat(tax_sum + this.data[i].tax_sum,6);
            amount = this.formatFloat(amount + this.data[i].amount,6);
          }
          this.formData.goods_qty = goods_qty;
          this.formData.goods_sum = goods_sum;
          this.formData.tax_sum = tax_sum;
          this.formData.amount = amount;
        },
        removeGoods:function(){
          this.$Modal.confirm({
            title:'操作提示',
            content:'确定要移除该商品吗？',
            onOk:()=>{
              this.data.splice(this.checkIndex,1);
            }
          });
        },
       rowClassName(row,index){
         if(this.isEdit) this.$set(this.data[index],'isEdit',true);
         else this.$set(this.data[index],'isEdit',false);
         if (index === this.checkIndex) {
           return 'ivu-table-row-highlight';
         }
         return '';
       },
        DHeight(e){
          this.height = e;
        },
        confirmSelPrice:function(e){
          this.$set(this.data[this.checkIndex],'s_o_price',e.price1);
          this.opPrice();
        },
        confirmBatch:function(item){
          let obj = this.data[this.checkIndex];
          let stockList = item.stockList;
          this.$set(obj,'ware_title',stockList.ware_title)
          this.$set(obj,'batch_no',stockList.batch_no)
          this.$set(obj,'prod_date',stockList.prod_date)
          this.$set(obj,'valid_date',stockList.valid_date)
          this.$set(obj,'prov_no',stockList.prov_no)
          this.$set(obj,'ware_code',stockList.ware_code)
          this.$set(obj,'berth_no',stockList.berth_no)
          this.$set(obj,'goods_state',stockList.goods_state)
          this.$set(obj,'quality_state',stockList.quality_state)
          this.$set(obj,'s_qty',item.out_qty)
          this.opPrice();
        },
        opPrice(){
          let obj = this.data[this.checkIndex];
          let qty = obj.s_qty || 0;
          let rebate = obj.s_rebate || 100;
          let tax = obj.s_tax_rate || 0;
          tax = this.formatFloat(parseFloat(tax)+100,6);
          let price = this.formatFloat(obj.s_o_price*rebate/100,6)
          if(!price){
            obj.s_price = null;
            obj.s_un_tax_price = null
          }else{
            obj.s_price = price;
            obj.s_un_tax_price = this.formatFloat(obj.s_price/tax*100,6);
          }
          obj.s_goods_sum = this.formatFloat(obj.s_un_tax_price*qty,6);
          obj.s_amount = this.formatFloat(obj.s_price*qty,6);
          obj.s_tax_sum = this.formatFloat(obj.s_amount-obj.s_goods_sum,6);
          this.$set(this.data,this.checkIndex,obj);
          this.opTotalPrice();
        },
        opTotalPrice:function(){
          let goods_qty = 0;
          let goods_sum = 0;
          let tax_sum = 0;
          let amount = 0;
          for(let i = 0; i < this.data.length; i++) {
            goods_qty = this.formatFloat(goods_qty+this.data[i].s_qty,6);
            goods_sum = this.formatFloat(goods_sum+this.data[i].s_goods_sum,6);
            tax_sum = this.formatFloat(tax_sum+this.data[i].s_tax_sum,6);
            amount = this.formatFloat(amount+this.data[i].s_amount,6);
          }
          this.$set(this.formData,'goods_qty',goods_qty);
          this.$set(this.formData,'goods_sum',goods_sum);
          this.$set(this.formData,'tax_sum',tax_sum);
          this.$set(this.formData,'amount',amount);
        }
      }
  }
</script>
<style lang="less">
  .form-list{
    width: 1100px;padding:10px 0;
  }
</style>
