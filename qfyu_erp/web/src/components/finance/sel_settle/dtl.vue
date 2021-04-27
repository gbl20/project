<template>
	<div>
    <split-none :Breadcrumb="Breadcrumb" :editTypeTitle="editTypeTitle" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button><span class="icon iconfont">&#xe6c0;</span>其他</Button>
          <Button @click="add"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="edit" :disabled="(formData.is_transfer || editType)?true:false"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="del" :disabled="(formData.is_transfer || editType)?true:false"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="preserve" :disabled="!editType?true:false"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button @click="cancel" :disabled="!editType?true:false"><span class="icon iconfont">&#xe793;</span>取消</Button>
          <Divider type="vertical" />
          <Button @click="check"  :disabled="formData.is_transfer?true:false"><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Button @click="reduction"  :disabled="formData.is_transfer?false:true"><span class="icon iconfont">&#xe693;</span>还原</Button>
          <Button @click="receivePayment"  :disabled="formData.is_transfer?false:true"><span class="icon iconfont">&#xe6b2;</span>收款</Button>
          <Divider type="vertical" />
          <Button @click="toUrl('/selSettleList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button @click="print"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form :model="formData" :label-width="80" class="w1200 padding-top" :disabled="!editType?true:false">
          <Row>
            <Col span="5">
              <FormItem label="结算单号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="结算日期">
                <DatePicker type="date" v-model="formData.f_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="结算方式">
                <Select v-model="formData.pay_mode_no">
                  <Option v-for="(item,key,index) in $store.state.settlement" :value="key" :key="index">{{item}}</Option>
                </Select>
              </FormItem>
              <FormItem label="开户行">
                <Input v-model="formData.account_bank"></Input>
              </FormItem>
              <FormItem label="账号">
                <Input v-model="formData.account_no"></Input>
              </FormItem>
              <FormItem label="税号">
                <Input v-model="formData.tax_no"></Input>
              </FormItem>
            </Col>
            <Col span="7">
              <FormItem label="客户单位">
                <Row>
                  <Col span="5"><Input disabled v-model="formData.cust_no"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18"><Input disabled v-model="formData.cust_name"><Button class="border-lr" slot="append" icon="ios-more" @click="openCustomer"></Button></Input></Col>
                </Row>
              </FormItem>
              <FormItem label="采购人员">
                <Input disabled v-model="formData.link_man"><Button class="border-lr" slot="append" icon="ios-more" @click="openCustomerSales(1)"></Button></Input>
              </FormItem>
              <FormItem label="联系人">
                <Input disabled v-model="formData.contacts"><Button class="border-lr" slot="append" icon="ios-more" @click="openCustomerSales(0)"></Button></Input>
              </FormItem>
              <FormItem label="购方部门">
                <Input disabled v-model="formData.cust_depart"></Input>
              </FormItem>
              <FormItem label="经手人">
                <Row>
                  <Col span="5"><Input disabled v-model="formData.emp_no"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18"><Input disabled v-model="$store.state.emp[formData.emp_no]"><Button class="border-lr" slot="append" icon="ios-more" @click="opemEmployee"></Button></Input></Col>
                </Row>
              </FormItem>
              <FormItem label="业务部门">
                <Row>
                  <Col span="5"><Input disabled v-model="formData.yw_dept_id"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18"><Input disabled v-model="$store.state.depart[formData.yw_dept_id]"><Button class="border-lr" slot="append" icon="ios-more" @click="openDepart"></Button></Input></Col>
                </Row>
              </FormItem>
            </Col>
            <Col span="8">
              <FormItem label="发票抬头">
                <Input v-model="formData.company_name"></Input>
              </FormItem>
              <FormItem label="发票地址">
                <Input v-model="formData.address"></Input>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="发票类型">
                    <Select v-model="formData.invoice_type">
                      <Option v-for="(item,index) in sysParam['billing_type']" :value="index" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                  <FormItem label="发票日期">
                    <DatePicker type="date" v-model="formData.invoice_date"></DatePicker>
                  </FormItem>
                  <FormItem label="发票总金额">
                    <Input v-model="formData.invoice_money"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="发票号码">
                    <Input v-model="formData.invoice_no"></Input>
                  </FormItem>
                  <FormItem label="发票轨号">
                    <Input v-model="formData.invoice_id"></Input>
                  </FormItem>
                  <FormItem label="发票电话">
                    <Input v-model="formData.telephone"></Input>
                  </FormItem>
                </Col>
              </Row>
              <FormItem label="单据状态">
                <span :class="'check-status '+(formData.is_transfer==1?'success-bg-text':'warning-bg-text')">{{formData.is_transfer==1?'已审核':'未审核'}}</span>
              </FormItem>
            </Col>
            <Col span="4" class-name="bill-table">
              <Table border size="small" :columns="columns1" :data="data1"></Table>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table size="small"  :row-class-name="rowClassName" border :columns="columns" :data="data" :height="height-74" @on-row-click="changeRow">
          <template slot-scope="{row,index}" slot="item_no">
            <span>{{(row.item_no && !editType)?row.item_no:(index+1)}}</span>
          </template>
          <template slot-scope="{row}" slot="pay_done">
            <span>{{row.pay_done?'是':'否'}}</span>
          </template>
        </Table>
        <Form :label-width="70" class="padding-top bg-m border-b" :disabled="!editType?true:false">
          <Row>
            <Col span="4">
              <FormItem label="货款">
                <Input v-model="formData.goods_sum" disabled></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="税款">
            <Input v-model="formData.tax_sum" disabled></Input>
          </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="合计">
            <Input v-model="formData.amount" disabled></Input>
          </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="退补合计">
            <Input v-model="formData.makeupfor_amount" disabled></Input>
          </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="凭证号">
            <Input v-model="formData.warrant_no" disabled></Input>
          </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="8">
              <FormItem label="备注">
                <Input v-model="formData.remark"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="复核员">
                <Input v-model="formData.audit" disabled></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="创建者">
                <Input v-model="$store.state.emp[formData.creater]" disabled></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="创建时间">
                <Input v-model="formData.creat_date" disabled></Input>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
    </split-none>
    <select-customer ref="SelectCustomer" @selcust="selCustomer"></select-customer>
    <select-customer-sales ref="selCustomerSales" @selCustSales="selCustSales"></select-customer-sales>
    <select-depart ref="SelectDepart" @seldep="selDepart"></select-depart>
    <select-employee ref="SelectEmployee" @selemp="selEmployee"></select-employee>
    <select-price ref="SelectPrice" @confirm="selPrice"></select-price>
  </div>
</template>

<script>
  var _this;
  import splitNone from "@/components/public/splitNone"
  import SelectCustomer from "@/components/common/SelectCustomer"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectDepart from "@/components/common/SelectDepart"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import SelectPrice from "@/components/common/SelectPrice"
	export default {
		name: "SelSettleDtl",
    components:{
      splitNone,SelectCustomer,SelectCustomerSales,SelectDepart,SelectEmployee,SelectPrice
    },
    data(){
		  return{
		    orderid:null,
		    height:0,
        editType:0,
        editTypeTitle:'',
        Breadcrumb:[{title:'财务管理'},{title:'销售结算',url:'/selSettleList'},{title:'销售结算明细'}],
        formData:{},
        sysParam:[],
        columns:[
          {title:'项次',slot:'item_no',width:50,minWidth:50,ellipsis:true,resizable:true},
          {title:'商品编号',key:'goods_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'通用名称',key:'name',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'规格',key:'specs',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'剂型',key:'dosage',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'单位',key:'unit',width:50,minWidth:50,ellipsis:true,resizable:true},
          {title:'生产批号',key:'batch_no',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'数量',key:'qty',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'销售单价',key:'sale_price',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'结算单价',key:'price',width:120,minWidth:120,ellipsis:true,resizable:true,render: (h, params) => {return this.custRender.renderInput(this, h, params, 'price', 1)}},
          {title:'税率',key:'tax_rate',width:100,minWidth:100,ellipsis:true,resizable:true,render: (h, params) => {return this.custRender.renderInput(this, h, params, 'tax_rate', 1)}},
          {title:'无税单价',key:'un_tax_price',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'无税金额',key:'goods_sum',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'税款',key:'tax_sum',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'合计',key:'amount',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'成本价',key:'ref_cost_price',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'总成本',key:'ref_cost',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'对应单号',key:'p_order_no',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'对应项次',key:'p_item_no',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'累计付款金额',key:'paid_up',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'退补差价',key:'makeupfor_price',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'退补差价合计',key:'makeupfor_amount',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'付款完成',slot:'pay_done',width:80,minWidth:80,ellipsis:true,resizable:true,align:'center'},
          {title:'付款完成日期',key:'pay_done_date',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'备注',key:'remark',width:80,minWidth:80,ellipsis:true,resizable:true,render: (h, params) => {return this.custRender.renderInput(this, h, params, 'remark')}},
          {title:'产地',key:'origin',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'生产企业',key:'production',width:220,minWidth:220,ellipsis:true,resizable:true},
          {title:'批准文号',key:'approval_code',width:150,minWidth:150,ellipsis:true,resizable:true},
          {title:'包装规格',key:'packspecs',width:80,minWidth:80,ellipsis:true,resizable:true},
        ],
        data:[],
        columns1:[
          {title:'发票号码',key:'orderid',minWidth:100},
          {title:'发票金额',key:'orderid',minWidth:100}
        ],
        data1:[],
        CustSales:1,
        editIndex:-1
      }
    },
    activated() {
		  this.orderid = localStorage.getItem("sel_settle_orderid");
    },
    watch:{
		  orderid:function (e) {
		    this.orderid = e;
        if(this.orderid) this.init();
      }
    },
    mounted() {
		  _this = this;
    },
    methods:{
      inputEach:function(fun,key,index){
        this.editIndex = index;
        if(fun == 'click'){
          if(key == 'price') this.$refs.SelectPrice.open(this.data[index].goods_code);
        }else{
          this.$set(this.data[index],key,this.custRender.KValue);
        }
        if(fun == 'blur'){
          if(key == 'tax_rate') this.count();
        }
      },
      rowClassName(row,index){
        if (index === this.editIndex) {
          this.$set(this.data[index],'isEdit',this.editType?true:false);
          return 'ivu-table-row-highlight';
        }else this.$set(this.data[index],'isEdit',false);
        return '';
      },
		  //初始化
		  init:function () {
        this.common.http({
          url:'f/getSelSettleDtl',
          data:{orderid:this.orderid}
        }).then(function (res) {
          if (res.status){
            _this.sysParam = _this.$store.state.sysParam;
            _this.formData = res.formData;
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      openCustomer:function(){
        this.$refs.SelectCustomer.init();
      },
      selCustomer(e){
		    this.formData.cust_no = e.id;
		    this.formData.cust_name = e.name;
      },
      openCustomerSales:function(type){
		    this.CustSales = type;
		    if (!this.formData.cust_no) return false;
		    this.$refs.selCustomerSales.open(this.formData.cust_no,type,true);
      },
      selCustSales:function(e){
		    if (!e.data){
		      this.formData.link_man = null;
		      this.formData.contacts = null;
        }else{
		      if (this.CustSales==1){
            this.formData.link_man = e.data.user_name;
            if(e.is_check) this.formData.contacts = '';
          }else{
            this.formData.contacts = e.data.user_name;
          }
        }
      },
      openDepart:function(){
		    this.$refs.SelectDepart.init();
      },
      selDepart:function(e){
		    this.formData.yw_dept_id = e.id;
      },
      opemEmployee:function(){
		    this.$refs.SelectEmployee.init();
      },
      selEmployee:function(e){
        this.formData.emp_no = e.code;
      },
      //新增
      add:function(){
        this.editType = 1;
        this.editTypeTitle = '新增';
      },
      //编辑
      edit:function(){
        this.editType = 1;
        this.editTypeTitle = '修改';
      },
      //删除
      del:function(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要删除当前数据吗？',
          onOk(){
            _this.common.http({
              url:'f/delSelSettle',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status) {
                if(res.orderid) {
                  localStorage.removeItem("sel_settle_orderid");
                  _this.orderid = res.orderid;
                }else{
                  _this.toUrl('/selSettleList')
                }
              }else {
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        });
      },
      //保存
      preserve:function(){
        this.common.http({
          url:'f/saveSelSettleInfo',
          data:{formData:this.formData,data:this.data}
        }).then(function (res) {
          if (res.status){
            _this.editType = 0;
            _this.editTypeTitle = '';
          }else{
            _this.modalMsg(res.msg)
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        });
      },
      //取消
      cancel:function(){
        this.editType = 0;
        this.editTypeTitle = '';
      },
      //审核
      check:function(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要审核当前数据吗？',
          onOk(){
            _this.common.http({
              url:'f/checkSelSettle',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status) {
                _this.init(_this.orderid);
              }else{
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        });
      },
      //还原
      reduction:function(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要还原当前已经审核过的数据吗？',
          onOk(){
            _this.common.http({
              url:'f/reductionSelSettle',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status) {
                _this.init(_this.orderid);
              }else {
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        });
      },
      //收款
      receivePayment:function(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要将结算单转为收款单吗？',
          onOk(){
            _this.common.http({
              url:'f/makeSelPay',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status) {
                setTimeout(function () {
                  _this.$Modal.confirm({
                    title:'提示信息',
                    content:'<p>'+_this.orderid+'号销售结算已成功转出到</p>'+'<p>['+res.orderid+']号销售收款单，要查看该单据吗？</p>',
                    onOk(){
                      localStorage.setItem("sel_pay_orderid",res.orderid);
                      _this.toUrl('/SelPayDtl');
                    }
                  })
                },300)
              }else {
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        });
      },
      changeRow:function(item,index){
		    this.editIndex = index;
      },
      selPrice:function(e){
		    this.data[this.editIndex].price = e.price1;
		    this.count();
      },
      count:function(){
        var qty=this.data[this.editIndex].qty,
            price = this.data[this.editIndex].price,
            tax_rate=this.data[this.editIndex].tax_rate,
            un_tax_price=0,goods_sum=0,tax_sum=0,amount=0;
            tax_rate = tax_rate>0?this.formatFloat(tax_rate / 100,2)+1:1;
        amount = this.formatFloat(qty * price,6);
        un_tax_price = this.formatFloat(price / tax_rate,6);
        goods_sum = this.formatFloat(un_tax_price * qty,6);
        tax_sum   = this.formatFloat(amount - goods_sum,6);
        this.data[this.editIndex].un_tax_price = un_tax_price;
        this.data[this.editIndex].goods_sum = goods_sum;
        this.data[this.editIndex].tax_sum = tax_sum;
        this.data[this.editIndex].amount = amount;
      },
      //打印
      print:function(){
        console.log('打印')
      },
      //退出
      out:function(){
		    this.delView('SelSettleDtl');
      },
      DHeight:function (e) {
        this.height = e;
      }
    }
	}
</script>

<style lang="less">
.w1200{
  width: 1200px;
  .border-lr{
    border-left: none;border-right: none;
  }
}
.check-status{
  display: inline-block;padding: 0 15px;height:28px;line-height: 28px;text-align: center;font-size: 14px;box-sizing: border-box;border-radius: 2px;
}
.bill-table{
  padding-left: 10px;
}
.padding-top{
  padding-top: 5px;
}
</style>
