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
                        <FormItem label="运输工具" :label-width="80" prop="ship_tool">
                          <Select v-model="formData.ship_tool" v-if="$store.state.sysParam">
                             <Option v-for="(item,index) in $store.state.sysParam['cold_storage_measures']" :key="index" :value="item">{{item}}</Option>
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
                    </Row>
                    <Row>
                      <Col span="6">
                        <FormItem label="送货登记单号">
                          <Input v-model="formData.delivery_no" placeholder="送货登记单号"></Input>
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
                      <Col span="7">
                        <FormItem label="车牌号或温度仪表编号" :label-width="85">
                          <Select v-model="formData.car_meter_no" filterable allow-create @on-create="handleCarMaterNo">
                             <Option v-for="(item,index) in CarMaterNoData" :key="index" :value="item.label">{{item.label}}</Option>
                          </Select>
                        </FormItem>
                      </Col>
                      <Col span="5">
                        <FormItem label="预冷时间">
                          <Input :value="formData.precooling_time" placeholder="预冷时间"></Input>
                        </FormItem>
                      </Col>
                    </Row>
                    <Row>
                      <Col span="6">
                        <FormItem label="登记日期">
                          <Input v-model="formData.f_date" placeholder="日期" disabled></Input>
                        </FormItem>
                      </Col>
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
                  </Col>
                  <Col span="3">
                    <FormItem label="状态" :label-width="55">
                      <div :class="formData.is_transfer?'success-bg-text':'warning-bg-text'" style="text-align: center;">{{formData.is_transfer?'已审核':'未审核'}}</div>
                    </FormItem>
                    <FormItem label="" :label-width="55">
                      <Button type="primary" @click="chooseItem"><span class="icon iconfont">&#xe797;</span>增加项</Button>
                      <Button type="default" @click="removeItem" style="margin-top:5px;"><span class="icon iconfont">&#xe793;</span>删除项</Button>
                    </FormItem>
                  </Col>
                </Row>
              </div>
              <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height-185" @on-row-click="(row,index)=>{selectRow(index,false)}">
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
      <trans-cold ref="transColdRef" @confirmItem="confirmItems"></trans-cold>
      <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import transCold from '@/components/common/ChooseTransportCold'
  import selectEmployee from '@/components/common/SelectEmployee'
  var formD = {orderid:'',ship_type:null,ship_tool:null,driver:null,delivery_no:'',shipper:'',car_meter_no:'',precooling_time:null,emp_no:null,delivery_boy:null,remark:null};
  export default {
    name:'trans_reg_cold_edit',
      components:{splitNone,transCold,selectEmployee},
      data () {
          return {
              save_lock:false,
              height:0,
              Breadcrumb:[{title:'冷藏药品运输'},{title:'冷藏药品运输登记查询',url:'trans_reg_cold'},{title:'冷藏药品运输登记'}],
              columns:[
                {title:'项次',slot:'item_no',width:100,align:'center'},
                {title:'客户编号',key:'cust_no',width:100,align:'center'},
                {title:'销售单号',key:'order_no',width:160,align:'center'},
                {title:'销售项次',key:'order_item_no',width:90,align:'center'},
                {title:'商品编号',key:'goods_code',width:120,align:'center'},
                {title:'数量',key:'qty',width:90,align:'center'},
                {title:'发货时间',key:'send_date',width:160,align:'center', render: (h, params) => {return this.custRender.renderDate(this,h,params,'send_date','datetime')}},
                {title:'发货时温度',key:'send_temperature',width:100,align:'center', render: (h, params) => {return this.custRender.renderInput(this,h,params,'send_temperature',1)}},
                {title:'到货时间',key:'arrival_date',width:160,align:'center', render: (h, params) => {return this.custRender.renderDate(this,h,params,'arrival_date','datetime')}},
                {title:'到货时温度',key:'arrival_temperature',width:100,align:'center',resizable:true,ellipsis :true, render: (h, params) => {return this.custRender.renderInput(this,h,params,'arrival_temperature',1)}},
                {title:'运输温度记录文件名',key:'temperature_filename',width:180,align:'center',resizable:true,ellipsis :true, render: (h, params) => {return this.custRender.renderInput(this,h,params,'temperature_filename')}},
                {title:'运输在途时限(小时)',key:'the_way_time',width:100,align:'center',resizable:true,ellipsis :true, render: (h, params) => {return this.custRender.renderInput(this,h,params,'the_way_time',1)}},
                {title:'客户收货人',key:'cust_receiver',width:100,align:'center',resizable:true,ellipsis :true, render: (h, params) => {return this.custRender.renderInput(this,h,params,'cust_receiver')}},
                {title:'客户收货人电话',key:'cust_receiver_tel',width:150,align:'center',resizable:true,ellipsis :true, render: (h, params) => {return this.custRender.renderInput(this,h,params,'cust_receiver_tel')}},
                {title:'送货路线',key:'deliver_line',width:90,align:'center'},
                {title:'送货地址',key:'pick_addr',width:90,align:'center',resizable:true,ellipsis :true},
                {title:'联系电话',key:'link_tel',width:90,align:'center'},
                {title:'业务员',key:'contacts',width:100,align:'center'},
                {title:'结算方式',key:'pay_mode_no',width:100,align:'center'},

                {title:'生产批号/序列号',key:'batch_no',width:160,align:'center',resizable:true,ellipsis :true},
                {title:'有效期至',key:'valid_date',width:160,align:'center'},
                {title:'客户名称',key:'cust_name',width:150,align:'center',resizable:true,ellipsis :true},
                {title:'客户采购人员',key:'link_man',width:100,align:'center'},
                {title:'商品名称',key:'goods_name',width:150,align:'center',resizable:true,ellipsis :true},
                {title:'规格',key:'specs',width:100,align:'center'},
                {title:'批准文号/注册证号',key:'approval_code',width:150,align:'center',resizable:true,ellipsis :true},
                {title:'产地',key:'origin',width:100,align:'center',resizable:true,ellipsis :true}
              ],
              data:[],
              isEdit:false,
              checkIndex:-1,
              salesType:0,
              subLoading:false,
              cust_data:[],
              driverData:[],
              CarMaterNoData:[],
              formData:JSON.parse(JSON.stringify(formD)),
              ruleVal:{
                ship_type:[
                  {required:true,message:'请选择运输方式',trigger:'change'}
                ],
                ship_tool:[
                  {required:true,message:'请选择运输工具',trigger:'change'}
                ]
              },
              quotation_orderid:localStorage.getItem('trans_reg_cold_orderid'),
              empIndex:'emp_no',
              orderids:[],
              dtlId:[]
          }
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          if(from.name == 'trans_reg_cold'){
            vm.quotation_orderid = localStorage.getItem('trans_reg_cold_orderid');
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
          this.common.http({url:'s/transRegColdInit',data:{quotation_orderid:this.quotation_orderid}}).then(function(res){
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
              _this.CarMaterNoData = res.car_meter_no;
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
                return _this.modalMsg('请选择订单产品');
              }
              _this.common.http({
                url: 's/comTransRegCold',data:{fdata:_this.formData,data:_this.data}
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
        handleCarMaterNo:function(val){
          let obj = {value: val,label: val};
          this.CarMaterNoData.push(obj);
        },
        handleDriver:function(val){
          let obj = {value: val,label: val};
          this.driverData.push(obj);
        },
        chooseItem:function(){
          this.$refs.transColdRef.open(this.orderids,this.dtlId);
        },
        confirmItems:function(e){
          for(var i=0;i<e.length;i++){
            if(this.dtlId.indexOf(e[i].id) == -1){
              this.dtlId.push(e[i].id);
              this.data.push(e[i])
            }
          }
        },
        selectRow:function(index,type){
          this.checkIndex=index;
        },
        removeItem:function(){
          if(this.checkIndex >= 0){
            let vid = this.data[this.checkIndex].id
            var index = this.dtlId.indexOf(vid);
            if (index > -1) {
              this.dtlId.splice(this.checkIndex, 1);
              this.data.splice(this.checkIndex, 1);
            }
          }
        },
        chooseEmp:function(empIndex){
          this.empIndex = empIndex;
          if(this.isEdit) this.$refs.chooseEmployeeRef.init();
        },
        confirmEmployee:function(e){
          this.formData[this.empIndex] = e.code;
        },
        auditOrder:function(){

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
