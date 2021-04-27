<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" :editTypeTitle="editTypeTitle" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button><span class="icon iconfont">&#xe6c0;</span>其他</Button>
          <Button @click="edit" :disabled="(formData.status || editType)?true:false"><span class="icon iconfont">&#xe791;</span>修改
          </Button>
          <Button @click="del" :disabled="(formData.status || editType)?true:false"><span
            class="icon iconfont">&#xe6a5;</span>删除
          </Button>
          <Button @click="preserve" :disabled="!editType?true:false"><span class="icon iconfont">&#xe792;</span>保存
          </Button>
          <Button @click="cancel" :disabled="!editType?true:false"><span class="icon iconfont">&#xe793;</span>取消
          </Button>
          <Divider type="vertical"/>
          <Button @click="check" :disabled="formData.status?true:false"><span class="icon iconfont">&#xe692;</span>审核
          </Button>
          <Button @click="reduction" :disabled="formData.status?false:true"><span class="icon iconfont">&#xe693;</span>还原
          </Button>
          <Divider type="vertical"/>
          <Button @click="toUrl('/SelColdStorageList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button @click="print"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form :model="formData" :label-width="80" class="w1200 padding-top" :disabled="!editType?true:false">
          <Row>
            <Col span="5">
              <FormItem label="单据编号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="登记日期">
                <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.f_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="销退单号">
                <Input v-model="formData.p_orderid" disabled></Input>
              </FormItem>
              <FormItem label="备注">
                <Input v-model="formData.remark"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="运输方式">
                <Select v-model="formData.trans_type" filterable allow-create @on-create="addTrans">
                  <Option v-for="item in cityList" :value="item.value" :key="item.value">{{ item.label }}</Option>
                </Select>
              </FormItem>
              <FormItem label="运输设备">
                <Input v-model="formData.device"></Input>
              </FormItem>
              <FormItem label="运途时间(h)">
                <Input maxlength="9" v-model="formData.transport"></Input>
              </FormItem>
              <FormItem label="客户送货人">
                <Input disabled v-model="formData.deliveryman"><Button slot="append" class="clear-btn" icon="ios-more" @click="openCustomerSales"></Button></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="送货司机">
                <Input v-model="formData.driver"></Input>
              </FormItem>
              <FormItem label="车牌号">
                <Input v-model="formData.license_plate"></Input>
              </FormItem>
              <FormItem label="特殊运输证">
                <Input v-model="formData.transport_certificate"></Input>
              </FormItem>
              <FormItem label="温度状况">
                <Input v-model="formData.temperature"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="复核员">
                <Input disabled v-model="$store.state.emp[formData.audit]"></Input>
              </FormItem>
              <FormItem label="创建者">
                <Input disabled v-model="$store.state.emp[formData.creater]"></Input>
              </FormItem>
              <FormItem label="经手人">
                <Input disabled v-model="$store.state.emp[formData.emp_no]"><Button slot="append" class="clear-btn" icon="ios-more" @click="openEmp('emp_no')"></Button></Input>
              </FormItem>
              <FormItem label="收货员">
                <Input disabled v-model="$store.state.emp[formData.shipper]"><Button slot="append" class="clear-btn" icon="ios-more" @click="openEmp('shipper')"></Button></Input>
              </FormItem>
            </Col>
            <Col span="3">
              <FormItem label="单据状态">
                <div style="text-align: center" :class="formData.status?'success-bg-text':'warning-bg-text'">
                  {{formData.status?'已审核':'未审核'}}
                </div>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table size="small" :row-class-name="rowClassName" border :columns="columns" :data="data" :height="height" @on-row-click="changeRow">
          <template slot-scope="{row,index}" slot="delivery_date">
            <DatePicker v-if="editType && index==editIndex" type="date" v-model="data[index].delivery_date"></DatePicker>
            <span v-else>{{row.delivery_date}}</span>
          </template>
          <template slot-scope="{row,index}" slot="received_date">
            <DatePicker v-if="editType && index==editIndex" type="date" v-model="data[index].received_date"></DatePicker>
            <span v-else>{{row.received_date}}</span>
          </template>
          <template slot-scope="{row}" slot="emp_name">
            <span>{{$store.state.emp[row.emp_no]}}</span>
          </template>
          <template slot-scope="{row}" slot="pay_mode_no_name">
            <span>{{$store.state.settlement[row.pay_mode_no]}}</span>
          </template>
        </Table>
      </div>
    </split-none>
    <select-customer-sales ref="selCustSalesRef" @selCustSales="selCustSales"></select-customer-sales>
    <select-employee ref="SelEmp" @selemp="selEmployee"></select-employee>
  </div>
</template>

<script>
  var _this,formData = {
    orderid:'', f_date:'', p_orderid:'', remark:'', trans_type:'', device:'', transport:'', deliveryman:'', driver:'', license_plate:'', transport_certificate:'', temperature:'', audit:'', creater:'', emp_no:'', shipper:'', status:0,
  };
  import splitNone from "@/components/public/splitNone"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectEmployee from "@/components/common/SelectEmployee"

  export default {
    name: "SelColdStorageEdit",
    components: {
      splitNone, SelectCustomerSales, SelectEmployee
    },
    data() {
      return {
        orderid: null,
        height: 0,
        Breadcrumb: [{title: '销售管理'}, {title: '冷藏药品销退收货登记明细'}],
        editIndex: -1,
        editType: 0,
        editTypeTitle: '',
        formData: {},
        columns: [
          {title:'项次',key:'item_no',width:50,minWidth:50,ellipsis:true,resizable:true},
          {title:'客户编号',key:'cust_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'客户地址',key:'address',width:180,minWidth:180,ellipsis:true,resizable:true,render:(h,params)=>{return this.custRender.renderInput(this,h,params,'address')}},
          {title:'联系电话',key:'tel',width:120,minWidth: 120,ellipsis:true,resizable:true},
          {title:'业务员',key:'emp_no',width:70,minWidth: 70,ellipsis:true,resizable:true},
          {title:'业务员姓名',slot:'emp_name',width:80,minWidth: 80,ellipsis:true,resizable:true},
          {title:'结算方式',key:'pay_mode_no',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'来货项次',key:'p_item_no',width:70,minWidth:70,ellipsis:true,resizable:true,align:'center'},
          {title:'商品编号',key:'goods_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'数量',key:'qty',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'生产批号',key:'batch_no',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'有效期至',key:'valid_date',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'发货时间',slot:'delivery_date',width:130,minWidth:130,ellipsis:true,resizable:true,align:'right'},
          {title:'发货时温度', key:'delivery_temp',width:90,minWidth:90,ellipsis:true,resizable:true,align:'right',render:(h,params)=>{return this.custRender.renderInput(this,h,params,'delivery_temp',1)}},
          {title:'到货时间', slot:'received_date',width:130,minWidth:130,ellipsis:true,resizable:true},
          {title:'到货温度', key:'received_temp',width:90,minWidth:90,ellipsis:true,resizable:true,render:(h,params)=>{return this.custRender.renderInput(this,h,params,'received_temp',1)}},
          {title:'温度运输记录文件名',key:'temp_file',width:140,minWidth:140,ellipsis:true,resizable:true,render:(h,params)=>{return this.custRender.renderInput(this,h,params,'temp_file')}},
          {title:'客户全称',key:'cust_name',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'客户名称',key:'cust_sname',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'客户采购员',key:'drug_license',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'结算方式名称',slot:'pay_mode_no_name',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'商品名称',key:'goods_name',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'通用名称',key:'name',width:80,minWidth:80,ellipsis:true},
          {title:'规格',key: 'specs',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'生产企业',key:'production',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'批准文号',key:'approval_code',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'产地',key:'origin',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'剂型',key:'dosage',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'父级编号',key:'parlevel',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'父级名称',key:'par_sname',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'供方部门',key:'cust_depart',width:80,minWidth:80,ellipsis:true,resizable:true},
        ],
        data: [],
        CustSales: 1,
        status: 0,
        cityList: [
          {value:'公路运输',label:'公路运输'},
          {value:'铁路运输',label:'铁路运输'},
          {value:'水路运输',label:'水路运输'},
          {value:'航空运输',label:'航空运输'}
        ],
        empName:''
      }
    },
    activated() {
      this.orderid = localStorage.getItem("cold_storage_orderid");
    },
    watch: {
      orderid: function (e) {
        this.orderid = e;
        if (this.orderid) this.init();
      }
    },
    mounted() {
      _this = this;
      if (!this.formData.f_date) {
        this.formData.f_date = new Date();
      }
    },
    methods: {
      inputEach: function (fun, key, index) {
        this.editIndex = index;
        if (fun == 'click') {
        } else {
          this.$set(this.data[index], key, this.custRender.KValue);
        }
      },
      rowClassName(row, index) {
        if (index === this.editIndex) {
          this.$set(this.data[index], 'isEdit', this.editType ? true : false);
          return 'ivu-table-row-highlight';
        } else this.$set(this.data[index], 'isEdit', false);
        return '';
      },
      init() {
        this.common.http({
          url: 's/getSelColdStorageDtl',
          data: {orderid: this.orderid}
        }).then(function (res) {
          if (res.status) {
            _this.formData = res.formData;
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this)
        })
      },
      edit() {
        if (this.editType) return this.modalMsg('当前正在处于编辑状态，请先保存或取消单据修改！')
        if (!this.formData.orderid) return false;
        this.editType = 1;
        this.editTypeTitle = '修改';
      },
      del() {
        if (!this.formData.orderid) return false;
        this.$Modal.confirm({
          title: '提示信息',
          content: '确定要删除当前单据吗？',
          onOk() {
            _this.common.http({
              url: 's/delSelColdStorage',
              data: {orderid: _this.orderid}
            }).then(function (res) {
              if (res.status) {
                if (res.orderid) {
                  localStorage.setItem("cold_storage_orderid", res.orderid)
                  _this.orderid = res.orderid;
                } else {
                  localStorage.removeItem("cold_storage_orderid");
                  _this.editIndex = -1;
                  _this.editType = 0;
                  _this.editTypeTitle = '';
                  _this.formData = JSON.parse(JSON.stringify(formData));
                  _this.data = [];
                }
              } else {
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this)
            })
          }
        })
      },
      //保存单据
      preserve() {
        this.common.http({
          url: 's/saveSelColdStorage',
          data: {formData: this.formData, data: this.data}
        }).then(function (res) {
          if (!res.status) {
            _this.modalMsg(res.msg);
          } else {
            _this.editIndex = -1;
            _this.editType = 0;
            _this.editTypeTitle = '';
            _this.init();
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this)
        })
      },
      cancel() {
        if (!this.editType) return false;
        this.$Modal.confirm({
          title: '提示信息',
          content: '确定要取消对当前单据所作的修改吗？',
          onOk() {
            _this.editType = 0;
            _this.editTypeTitle = '';
            _this.init();
          }
        })
      },
      check() {
        if (!this.formData.orderid) return false;
        this.$Modal.confirm({
          title: '提示信息',
          content: '确定要审核当前单据吗？',
          onOk() {
            _this.common.http({
              url: 's/checkSelColdStorage',
              data: {orderid: _this.orderid}
            }).then(function (res) {
              if (res.status) {
                _this.init();
              } else {
                setTimeout(function () {_this.modalMsg(res.msg)},300);
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this)
            })
          }
        })
      },
      reduction() {
        this.$Modal.confirm({
          title: '提示信息',
          content: '确定要还原当前已经审核过的单据吗？',
          onOk() {
            _this.common.http({
              url: 's/backSelColdStorage',
              data: {orderid: _this.orderid}
            }).then(function (res) {
              if (res.status) _this.init();
              else setTimeout(function () {_this.modalMsg(res.msg)},300);
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this)
            })
          }
        })
      },
      addTrans(val){
        this.cityList.push({
          value: val,
          label: val
        });
      },
      print() {},
      out() {
        this.delView('SelColdStorageList');
      },
      openCustomerSales() {
        if (!this.data.length) return false;
        this.$refs.selCustSalesRef.open(this.data[0].cust_no,0,true);
      },
      openEmp(name) {
        this.empName = name;
        this.$refs.SelEmp.init();
      },
      selCustSales(e) {
        if (!e.data) this.formData.deliveryman = null;
        else this.formData.deliveryman = e.data.user_name;
      },
      selEmployee(e) {
        this.formData[this.empName] = e.code;
      },
      changeRow(item, index) {
        this.editIndex = index;
      },
      DHeight(e) {
        this.height = e;
      }
    }
  }
</script>

<style lang="less">
  .padding-top {
    padding-top: 5px;
  }
</style>
