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
                <Divider type="vertical"/>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>关闭</Button>
              </div>
          </div>
          <div slot="table-list">
            <div class="height_5"></div>
            <Form ref="formRef" :model="formData" :rules="ruleVal" :label-width="66" label-position="right" :disabled="!isEdit">
              <div class="form-list">
                <Row>
                  <Col span="21">
                    <Row>
                      <Col span="6">
                        <FormItem label="单号">
                          <Input v-model="formData.orderid" placeholder="保存系统自动生成" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="6">
                        <FormItem label="运输方式" :label-width="80" prop="ship_type">
                          <Select v-model="formData.ship_type">
                            <Option v-for="(item,index) in $store.state.sysParam['ship_type']" :key="index" :value="item" >{{item}}</Option>
                          </Select>
                        </FormItem>
                      </Col>
                      <Col span="6">
                        <FormItem label="送货司机">
                          <Select v-model="formData.driver" filterable allow-create @on-create="handleDriver">
                             <Option v-for="(item,index) in driverData" :key="index" :value="item.label">{{item.label}}</Option>
                          </Select>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem label="复核员" :label-width="55">
                          <Input :value="formData.audit_no" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem :label-width="5">
                           <Input :value="$store.state.emp[formData.audit_no]" disabled></Input>
                        </FormItem>
                      </Col>
                    </Row>
                    <Row>
                      <Col span="6">
                        <FormItem label="日期">
                          <Input v-model="formData.f_date" placeholder="日期" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem label="发货员" :label-width="55">
                          <Input :value="formData.shipper" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem :label-width="5">
                           <Input icon="ios-more" :value="$store.state.emp[formData.shipper]" readonly style="cursor:pointer;"  @on-click="chooseEmp('shipper')"></Input>
                        </FormItem>
                      </Col>
                      <Col span="6">
                        <FormItem label="车牌号">
                          <Select v-model="formData.car_num" filterable allow-create @on-create="handleCarNum">
                             <Option v-for="(item,index) in CarNumData" :key="index" :value="item.label">{{item.label}}</Option>
                          </Select>
                        </FormItem>
                      </Col>
                      <Col span="6">
                        <FormItem label="发货方式">
                          <Select v-model="formData.deliver_kind" v-if="$store.state.sysParam">
                             <Option v-for="(item,index) in $store.state.sysParam['delivery_method']" :key="index" :value="item">{{item}}</Option>
                          </Select>
                        </FormItem>
                      </Col>
                    </Row>
                    <Row>
                      <Col span="3">
                        <FormItem label="经手人" :label-width="55">
                          <Input :value="formData.emp_no" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem :label-width="5">
                           <Input icon="ios-more" :value="$store.state.emp[formData.emp_no]" readonly style="cursor:pointer;"  @on-click="chooseEmp('emp_no')"></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem label="送货员" :label-width="55">
                          <Input :value="formData.delivery_boy" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem :label-width="5">
                           <Input icon="ios-more" :value="$store.state.emp[formData.delivery_boy]" readonly style="cursor:pointer;"  @on-click="chooseEmp('delivery_boy')"></Input>
                        </FormItem>
                      </Col>
                      <Col span="3">
                        <FormItem label="委托物流单位" :label-width="65">
                          <Input :value="formData.logistics_id" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="4">
                        <FormItem :label-width="5">
                           <Input icon="ios-more" :value="formData.logistics_unit" readonly style="cursor:pointer;"  @on-click="chooseLogisticsUnit()"></Input>
                        </FormItem>
                      </Col>

                      <Col span="5">
                        <FormItem label="物流单号">
                          <Input v-model="formData.wl_num" placeholder="物流单号"></Input>
                        </FormItem>
                      </Col>
                    </Row>
                  </Col>
                  <Col span="3">
                    <FormItem label="状态" :label-width="40">
                      <div :class="formData.is_transfer?'success-bg-text':'warning-bg-text'" style="text-align: center;">{{formData.is_transfer?'已审核':'未审核'}}</div>
                    </FormItem>
                    <FormItem label="" :label-width="40">
                      <Button type="primary" @click="chooseOrder"><span class="icon iconfont">&#xe797;</span>选择订单</Button>
                      <Button type="default" @click="removeOrder" style="margin-top:5px;"><span class="icon iconfont">&#xe793;</span>删除订单</Button>
                    </FormItem>
                  </Col>
                </Row>
              </div>
              <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height-180" @on-row-click="(row,index)=>{selectRow(index,false)}">
                <template slot-scope="{row,index}" slot="item_no">{{(row.item_no&&!isEdit)?row.item_no:(index+1)}}</template>
                <template slot-scope="{row}" slot="is_cold_storage">
                  <Checkbox :value="row.is_cold_storage" :true-value="1" :false-value="0" disabled></Checkbox>
                </template>
                <template slot-scope="{row,index}" slot="cold_storage_measures">
                  <Select v-if="row.isEdit && JSON.stringify($store.state.sysParam) != '[]'" :value="row.cold_storage_measures" @on-change="changeSlot($event,'cold_storage_measures',index)">
                    <Option v-for="item in $store.state.sysParam['cold_storage_measures']" :value="item" :key="item">{{item}}</Option>
                  </Select>
                  <div v-else>{{row.cold_storage_measures}}</div>
                </template>
              </Table>
              <div class="height_5"></div>
              <div class="form-list">
                <Row>
                  <Col span="4">
                    <FormItem label="总金额" :label-width="66">
                      <Input v-model="formData.amount" placeholder="总金额" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="创建者" :label-width="55">
                      <FormItem :label-width="5">
                        <Input :value="$store.state.emp[formData.creater]" placeholder="创建者" disabled></Input>
                      </FormItem>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="创建日期" :label-width="66">
                      <FormItem :label-width="5">
                        <Input :value="formData.create_date" placeholder="创建日期" disabled></Input>
                      </FormItem>
                    </FormItem>
                  </Col>
                  <Col span="12">
                    <FormItem label="备注" :label-width="40">
                      <Input v-model="formData.remark" placeholder="备注"></Input>
                    </FormItem>
                  </Col>
                </Row>
              </div>
            </Form>
          </div>
      </split-none>
      <ex-order ref="ExOrderRef" @confirmOrder="confirmOrder"></ex-order>
      <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
      <choose-trust ref="chooseTrustRef" @confirm="confirmTrust"></choose-trust>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import ExOrder from '@/components/common/ChooseExOrder'
  import selectEmployee from '@/components/common/SelectEmployee'
  import chooseTrust from '@/components/common/ChooseTrust'
  var formD = {orderid:'',ship_type:null,driver:'',audit_no:'',f_date:null,shipper:'',car_num:'',deliver_kind:null,emp_no:'',delivery_boy:'',logistics_id:null,logistics_unit:'',wl_num:'',is_transfer:0,amount:null,creater:'',create_date:'',remark:''};
  export default {
    name:'trans_reg_edit',
      components:{splitNone,ExOrder,selectEmployee,chooseTrust},
      data () {
          return {
              save_lock:false,
              height:0,
              Breadcrumb:[{title:'销售发货运输'},{title:'销售发货运输登记查询',url:'trans_reg'},{title:'销售发货运输登记'}],
              columns:[
                {title:'项次',slot:'item_no',width:100,align:'center'},
                {title:'客户编号',key:'cust_no',width:100,align:'center'},
                {title:'客户名称',key:'cust_name',width:150,align:'center',resizable:true,ellipsis :true},
                {title:'送货路线',key:'deliver_line',width:90,align:'center'},
                {title:'送货顺序号',key:'deliorder',width:100,align:'center'},
                {title:'发货单号',key:'order_no',width:160,align:'center'},
                {title:'单据金额',key:'amount',width:100,align:'center'},
                {title:'备注',key:'remark',width:100,align:'center',resizable:true, render: (h, params) => {return this.custRender.renderInput(this,h,params,'remark')}},
                {title:'货物件数',key:'pack_num',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this,h,params,'pack_num',1)}},
                {title:'联系电话',key:'link_tel',width:100,align:'center'},
                {title:'送货地址',key:'addr',width:100,align:'center'},
                {title:'包含冷藏运输药品',slot:'is_cold_storage',width:120,align:'center'},
                {title:'客户采购人员',key:'link_man',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this,h,params,'link_man')}},
                {title:'业务员',key:'sales_man',width:100,align:'center'},
                {title:'结算方式',key:'pay_mode_no',width:100,align:'center'},
                {title:'提货人',key:'shipper',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this,h,params,'shipper')}},
                {title:'发货时间',key:'send_date',width:130,align:'center', render: (h, params) => {return this.custRender.renderDate(this,h,params,'send_date')}},
                {title:'发货时温度',key:'send_temperature',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this,h,params,'send_temperature',1)}},
                {title:'冷藏措施',slot:'cold_storage_measures',width:100,align:'center'}
              ],
              data:[],
              isEdit:false,
              checkIndex:-1,
              salesType:0,
              subLoading:false,
              cust_data:[],
              driverData:[],
              CarNumData:[],
              formData:JSON.parse(JSON.stringify(formD)),
              ruleVal:{
                ship_type:[
                  {required:true,message:'请选择运输方式',trigger:'change'}
                ]
              },
              quotation_orderid:localStorage.getItem('trans_reg_orderid'),
              empIndex:'emp_no',
              orderids:[]
          }
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          if(from.name == 'trans_reg'){
            vm.quotation_orderid = localStorage.getItem('trans_reg_orderid');
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
          this.$set(this.data[index],key,this.custRender.KValue)
        },
        init:function(){
          let _this = this;
          this.loadding = true;
          this.common.http({url:'s/transRegInit',data:{quotation_orderid:this.quotation_orderid}}).then(function(res){
            if(res.status==1){
               _this.$refs.formRef.resetFields()
              if(res.data){
                _this.data = res.data.details;
                _this.formData = res.data.data;
                _this.isEdit = false;
              }else{
                _this.formData = JSON.parse(JSON.stringify(formD));
                _this.formData.f_date = _this.getDateVal();
                _this.data = [];
                _this.isEdit = true;
              }
              _this.driverData = res.driver_data;
              _this.CarNumData = res.car_num_data;
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          });
        },
        changeSlot:function(e,key,index){
          this.$set(this.data[index],key,e)
        },
        comData:function(){
          let _this = this;
          this.subLoading = true;
          this.$refs.formRef.validate(function(valid){
            if (valid) {
              if(_this.data.length < 1){
                _this.subLoading = false;
                return _this.modalMsg('请选择订单信息');
              }
              _this.common.http({
                url: 's/comTransReg',data:{fdata:_this.formData,data:_this.data}
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
        chooseLogisticsUnit:function(){
          this.$refs.chooseTrustRef.open();
        },
        handleCarNum:function(val){
          let obj = {value: val,label: val};
          this.CarNumData.push(obj);
        },
        handleDriver:function(val){
          let obj = {value: val,label: val};
          this.driverData.push(obj);
        },
        chooseOrder:function(){
          this.$refs.ExOrderRef.open(this.orderids);
        },
        confirmOrder:function(e){
          if(this.orderids.indexOf(e.orderid) == -1) this.orderids.push(e.orderid);
          let data = {};
          data.cust_no = e.cust_no;
          data.cust_name = e.cust_name;
          data.deliver_line = e.deliver_line;
          data.deliorder = e.deliorder;
          data.link_man = e.link_man;
          data.link_tel = e.link_tel;
          data.addr = e.pick_addr;
          data.order_no = e.orderid;
          data.amount = e.amount;
          data.remark = e.remark;
          data.pack_num = e.goods_qty;
          data.is_cold_storage = e.is_cold_storage;
          data.sales_man = e.contacts;
          data.shipper = null;
          data.send_date = null;
          data.send_temperature = null;
          data.pay_mode_no = e.pay_mode_no;
          data.cold_storage_measures = null;
          this.data.push(data);
        },
        selectRow:function(index,type){
            this.checkIndex=index;
        },
        removeOrder:function(){
          if(this.checkIndex >= 0){
            let orderid = this.data[this.checkIndex].orderid
            var index = this.orderids.indexOf(orderid);
            if (index > -1) {
              this.orderids.splice(index, 1);
            }
            this.data.splice(this.checkIndex,1);
          }
        },
        chooseEmp:function(empIndex){
          this.empIndex = empIndex;
          if(this.isEdit) this.$refs.chooseEmployeeRef.init();
        },
        confirmEmployee:function(e){
          this.formData[this.empIndex] = e.code;
        },
        confirmTrust:function(e){
          this.formData.logistics_id = e.id;
          this.formData.logistics_unit = e.company;
        },
        auditOrder:function(){
         if(this.formData.is_transfer == 1) return false;
         let _this = this;
         this.common.http({
           url: 's/auditTransReg',data:{orderid:_this.formData.orderid}
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
        rowClassName(row,index){
          if (index === this.checkIndex) {
            if(this.isEdit) this.$set(this.data[index],'isEdit',true);
            else this.$set(this.data[index],'isEdit',false);
            return 'ivu-table-row-highlight';
          }else this.$set(this.data[index],'isEdit',false);
          return '';
        },
        DHeight(e){
          this.height = e;
        }
      }
  }
</script>
<style lang="less">
  .form-list{
    width: 1100px;padding:10px 0;
  }
</style>
