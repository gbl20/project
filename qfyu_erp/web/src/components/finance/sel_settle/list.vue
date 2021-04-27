<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="model = true"><span class="icon iconfont">&#xe691;</span>筛选</Button>
          <Button><span class="icon iconfont">&#xe6a0;</span>报表</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table size="small" border :columns="columns" :data="data" :height="height-34" @on-row-click="(item,index)=>{changeRow(item,index,false)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,true)}">
          <template slot-scope="{row}" slot="is_transfer">
            <div :class="row.is_transfer?'success-bg-text':'warning-bg-text'" style="text-align: center;">{{row.is_transfer?'已过账':'未过账'}}</div>
          </template>
          <template slot-scope="{row}" slot="yw_dept_name">
            <span>{{$store.state.depart[row.yw_dept_id]}}</span>
          </template>
          <template slot-scope="{row}" slot="dept_name">
            <span>{{$store.state.depart[row.dept_id]}}</span>
          </template>
          <template slot-scope="{row}" slot="emp_name">
            <span>{{$store.state.emp[row.emp_no]}}</span>
          </template>
          <template slot-scope="{row}" slot="audit_name">
            <span>{{$store.state.emp[row.audit]}}</span>
          </template>
          <template slot-scope="{row}" slot="creater_name">
            <span>{{$store.state.emp[row.creater]}}</span>
          </template>
          <template slot-scope="{row}" slot="pay_mode_name">
            <span>{{$store.state.settlement[row.pay_mode_no]}}</span>
          </template>
        </Table>
        <div class="page-m">
          <Page size="small" show-total show-sizer :total="total" :page-size="pageSize" :page-size-opts="[15,25,35,50]" @on-change="changePage" @on-page-size-change="changePageSize"></Page>
        </div>
      </div>
    </split-none>
    <Drawer title="条件查询" :closable="false" v-model="model" width="500">
      <Form :model="formData" :label-width="70">
        <Row>
          <Col span="12">
            <FormItem label="结算单号">
              <Input v-model="formData.orderid"></Input>
            </FormItem>
            <FormItem label="结算日期">
              <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.f_date"></DatePicker>
            </FormItem>
            <FormItem label="对应单号">
              <Input v-model="formData.p_order_no"></Input>
            </FormItem>
            <FormItem label="结算类型">
              <Select clearable v-model="formData.in_out_kind">
                <Option value="51">销售</Option>
                <Option value="22">期初应收</Option>
              </Select>
            </FormItem>
            <FormItem label="付款日期">
              <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.pay_date"></DatePicker>
            </FormItem>
            <FormItem label="发票日期">
              <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.invoice_date"></DatePicker>
            </FormItem>
            <FormItem label="发票号码">
              <Input v-model="formData.invoice_no"></Input>
            </FormItem>
            <FormItem label="经手人">
              <Input v-model="formData.emp_no"><Button class="clear-btn" slot="append" icon="ios-more" @click="openEmp('emp_no')"></Button></Input>
            </FormItem>
            <FormItem label="复核员">
              <Input v-model="formData.audit"><Button class="clear-btn" slot="append" icon="ios-more" @click="openEmp('audit')"></Button></Input>
            </FormItem>
            <FormItem label="复核否">
              <Select v-model="formData.is_transfer">
                <Option :value="0">未审核</Option>
                <Option :value="1">已审核</Option>
              </Select>
            </FormItem>
            <FormItem label="客户分类">
              <Select v-model="formData.custlass">
                <Option v-for="(item,key,index) in custlass" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="是否结清">
              <Select v-model="formData.status">
                <Option value="0">全部</Option>
                <Option value="1">已结清</Option>
                <Option value="1">部分支付</Option>
                <Option value="1">全部未支付</Option>
                <Option value="1">部分结清</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="客户单位">
              <Input v-model="formData.cust_no"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomer"></Button></Input>
            </FormItem>
            <FormItem label="有效期至">
              <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.end_f_date"></DatePicker>
            </FormItem>
            <FormItem label="采购人员">
              <Input v-model="formData.link_man"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomerSales(1)"></Button></Input>
            </FormItem>
            <FormItem label="联系人">
              <Input v-model="formData.contacts"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomerSales(0)"></Button></Input>
            </FormItem>
            <FormItem label="有效期至">
              <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.end_pay_date"></DatePicker>
            </FormItem>
            <FormItem label="有效期至">
              <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.end_invoice_date"></DatePicker>
            </FormItem>
            <FormItem label="送货路线">
              <Input v-model="formData.deliroute"></Input>
            </FormItem>
            <FormItem label="凭证号">
              <Input v-model="formData.warrant_no"></Input>
            </FormItem>
            <FormItem label="业务部门">
              <Input v-model="formData.yw_dept_id"><Button class="clear-btn" slot="append" icon="ios-more" @click="openDepart"></Button></Input>
            </FormItem>
            <FormItem label="收款方式">
              <Select clearable v-model="formData.pay_mode_no">
                <Option v-for="(item,key,index) in $store.state.settlement" :value="key" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="商品编号">
              <Input v-model="formData.goods_code"><Button class="clear-btn" slot="append" icon="ios-more" @click="openGoods"></Button></Input>
            </FormItem>
            <FormItem>
              <Checkbox :true-value="1" :false-value="0" v-model="formData.invoice_status">已开发票</Checkbox>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <FormItem>
            <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe691;</span>查询</Button>
          </FormItem>
        </Row>
      </Form>
    </Drawer>
    <select-customer ref="SelCustomer" @selcust="selCust"></select-customer>
    <select-customer-sales ref="selSales" @selCustSales="selSales"></select-customer-sales>
    <select-depart ref="SelDepart" @seldep="selDept"></select-depart>
    <select-employee ref="SelEmp" @selemp="selEmp"></select-employee>
    <choose-goods ref="RefGoods" @selectRow="selGoods"></choose-goods>
  </div>
</template>

<script>
  var _this;
  import splitNone from "@/components/public/splitNone"
  import SelectCustomer from "@/components/common/SelectCustomer"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectDepart from "@/components/common/SelectDepart"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import ChooseGoods from "@/components/common/ChooseGoods"
  export default {
    name: "selSettleList",
    components:{
      splitNone,SelectCustomer,SelectCustomerSales,SelectDepart,SelectEmployee,ChooseGoods
    },
    data(){
      return{
        model:false,
        orderid:null,
        height:0,
        Breadcrumb:[{title:'财务管理'},{title:'销售结算查询'}],
        formData:{
          orderid:'', f_date:'', end_f_date:'', pay_date:'', end_pay_date:'', p_order_no:'', invoice_date:'', end_invoice_date:'', invoice_no:'', in_out_kind:'', emp_no:'', audit:'', is_transfer:null, custlass:'', status:'', cust_no:'',link_man:'', contacts:'', deliroute:'', warrant_no:'', yw_dept_id:'', pay_mode_no:'', goods_code:'', invoice_status:0
        },
        columns:[
          {title:'结算单号',key:'orderid',width:160,minWidth:160,ellipsis:true,resizable:true,fixed:'left'},
          {title:'结算日期',key:'f_date',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'结算方式',key:'pay_mode_no',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'结算方式名称',slot:'pay_mode_name',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'业务部门',key:'yw_dept_id',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'业务部门名称',slot:'yw_dept_name',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'客户编号',key:'cust_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'客户名称',key:'cust_name',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'客户采购员',key:'link_man',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'联系人',key:'contacts',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'经手人',key:'emp_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'员工姓名',slot:'emp_name',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'复核员',key:'audit',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'审核人姓名',slot:'audit_name',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'货品总数',key:'goods_qty',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'无税金额',key:'goods_sum',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'税款',key:'tax_sum',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'合计',key:'amount',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'已收款金额',key:'paid_up',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'未收款金额',key:'re_paid',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'最后收款日期',key:'pay_done_date',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'开单人',key:'creater',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'开单人姓名',slot:'creater_name',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'开单部门',key:'dept_id',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'开单部门名称',slot:'dept_name',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'发票号码',key:'invoice_no',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'发票日期',key:'invoice_date',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'发票地址',key:'address',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'发票总金额',key:'invoice_money',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'备注',key:'remark',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'凭证号',key:'warrant_no',width:110,minWidth:110,ellipsis:true,resizable:true},
          {title:'仓库地址',key:'warehouse',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'参考成本',key:'ref_cost',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'参考毛利',key:'re_profit',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'参考毛利率',key:'re_profit_val',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'父级编号',key:'parlevel',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'父级名称',key:'parlevel_name',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'供方部门',key:'cust_depart',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'过账',slot:'is_transfer',width:80,minWidth:80,ellipsis:true,resizable:true,align:'center',fixed:'right'},
        ],
        data:[],
        Index:-1,
        total:0,
        page:1,
        pageSize:15,
        CustSales:1,
        empName:'emp_no',
        custlass:[]
      }
    },
    mounted() {
      _this = this;
    },
    created() {
      this.init();
    },
    methods:{
      init:function () {
        this.common.http({
          url:'f/getSelSettleList',
          data:{page:this.page,pageSize:this.pageSize,search:this.formData}
        }).then(function (res) {
          if (res.status){
            _this.total = res.data.total;
            _this.data  = res.data.data;
            _this.custlass  = res.custlass;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      changeRow:function(item,index,type){
        this.Index = index;
        if(type) {
          localStorage.setItem("sel_settle_orderid",item.orderid);
          this.toUrl('/selSettleDtl');
        }
      },
      DHeight:function (e) {
        this.height = e;
      },
      changePage(page){
        this.page = page;
        this.init();
      },
      changePageSize(pageSize){
        this.page = 1;
        this.pageSize = pageSize;
        this.init();
      },
      openCustomer:function(){
        this.$refs.SelCustomer.init();
      },
      selCust(e){
        this.formData.cust_no = e.id;
      },
      openCustomerSales:function(type){
        this.CustSales = type;
        if (!this.formData.cust_no) return false;
        this.$refs.selSales.open(this.formData.cust_no,type,true);
      },
      selSales:function(e){
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
        this.$refs.SelDepart.init();
      },
      selDept:function(e){
        this.formData.yw_dept_id = e.id;
      },
      openEmp:function(name){
        this.empName = name;
        this.$refs.SelEmp.init();
      },
      selEmp:function(e){
        this.formData[this.empName] = e.code;
      },
      openGoods(){
        this.$refs.RefGoods.open();
      },
      selGoods(e){
        this.formData.goods_code = e.goods_code;
      }
    }
  }
</script>

<style lang="less">
.pd-top{
  padding-top: 5px;
}
</style>
