<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="openDrawer = true"><span class="icon iconfont">&#xe691;</span>筛选</Button>
          <Button><span class="icon iconfont">&#xe6a0;</span>报表</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table size="small" border :columns="columns" :data="data" :height="height-34" @on-row-dblclick="changeRow">
          <template slot-scope="{row}" slot="pay_kind">
            <span>{{row.pay_kind?'预收':'实收'}}</span>
          </template>
          <template slot-scope="{row}" slot="pay_mode_no">
            <span>{{$store.state.settlement[row.pay_mode_no]}}</span>
          </template>
          <template slot-scope="{row}" slot="yw_dept_name">
            <span>{{$store.state.depart[row.yw_dept_id]}}</span>
          </template>
          <template slot-scope="{row}" slot="pay_status">
            <div style="text-align: center;"><Checkbox :true-value="1" :false-value="0" v-model="row.pay_status" disabled></Checkbox></div>
          </template>
          <template slot-scope="{row}" slot="creater_name">
            <span>{{$store.state.emp[row.creater]}}</span>
          </template>
          <template slot-scope="{row}" slot="dept_id">
            <span>{{$store.state.depart[row.dept_id]}}</span>
          </template>
          <template slot-scope="{row}" slot="status">
            <div :class="row.status?'success-bg-text':'warning-bg-text'" style="text-align: center;">{{row.status?'已过账':'未过账'}}</div>
          </template>
        </Table>
        <div class="page-m">
          <Page size="small" show-total show-sizer :total="total" :page-size="pageSize" :page-size-opts="[25,35,50]" @on-change="changePage" @on-page-size-change="ChangePageSize"></Page>
        </div>
      </div>
    </split-none>
    <Drawer title="条件筛选" :closable="false" v-model="openDrawer" width="500">
      <Form :model="formData" :label-width="70">
        <Row>
          <Col span="12">
            <FormItem label="收款日期">
              <DatePicker format="yyyy年MM月dd日" type="date" v-model="formData.f_date"></DatePicker>
            </FormItem>
            <FormItem label="发票日期">
              <DatePicker format="yyyy年MM月dd日" type="date" v-model="formData.invoice_date"></DatePicker>
            </FormItem>
            <FormItem label="收款单号">
              <Input v-model="formData.orderid"></Input>
            </FormItem>
            <FormItem label="结算单号">
              <Input v-model="formData.settle_orderid"></Input>
            </FormItem>
            <FormItem label="客户">
              <Input v-model="formData.cust_no"><Button class="clear-btn" icon="ios-more" slot="append" @click="openCust"></Button></Input>
            </FormItem>
            <FormItem label="客户分类">
              <Select v-model="formData.custlass">
                <Option v-for="(item,key,index) in custlass" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="客户地区">
              <Input v-model="formData.area"><Button class="clear-btn" icon="ios-more" slot="append" @click="openArea"></Button></Input>
            </FormItem>
            <FormItem label="联系人">
              <Input v-model="formData.link_man2"><Button class="clear-btn" icon="ios-more" slot="append" @click="openSales(0)"></Button></Input>
            </FormItem>
            <FormItem label="送货路线">
              <Input v-model="formData.deliroute"><Button class="clear-btn" icon="ios-more" slot="append" @click="openDelivery"></Button></Input>
            </FormItem>
            <FormItem label="商品编号">
              <Input v-model="formData.goods_code"><Button class="clear-btn" icon="ios-more" slot="append" @click="openGoods"></Button></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="有效期至">
              <DatePicker format="yyyy年MM月dd日" type="date" v-model="formData.end_f_date"></DatePicker>
            </FormItem>
            <FormItem label="有效期至">
              <DatePicker format="yyyy年MM月dd日" type="date" v-model="formData.end_invoice_date"></DatePicker>
            </FormItem>
            <FormItem label="支票号">
              <Input v-model="formData.cheque_no"></Input>
            </FormItem>
            <FormItem label="发票号码">
              <Input v-model="formData.invoice_no"></Input>
            </FormItem>
            <FormItem label="复核否">
              <Select v-model="formData.status">
                <Option :value="0">未审核</Option>
                <Option :value="1">已审核</Option>
              </Select>
            </FormItem>
            <FormItem label="收款类型">
              <Select v-model="formData.pay_kind">
                <Option :value="0">实收</Option>
                <Option :value="1">预收</Option>
              </Select>
            </FormItem>
            <FormItem label="结算方式">
              <Select v-model="formData.pay_mode_no">
                <Option v-for="(item,key,index) in $store.state.settlement" :value="key" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="复核员">
              <Input v-model="formData.checker"><Button class="clear-btn" icon="ios-more" slot="append" @click="openEmp('checker')"></Button></Input>
            </FormItem>
            <FormItem label="开单人">
              <Input v-model="formData.emp_no"><Button class="clear-btn" icon="ios-more" slot="append" @click="openEmp('emp_no')"></Button></Input>
            </FormItem>
            <FormItem label="开单部门">
              <Input v-model="formData.yw_dept_id"><Button class="clear-btn" icon="ios-more" slot="append" @click="openDept"></Button></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <FormItem>
            <Button type="primary" @click="find"><span class="icon iconfont">&#xe691;</span>查询</Button>
            <Button @click="empty"><span class="icon iconfont">&#xe6a2;</span>清空条件</Button>
          </FormItem>
        </Row>
      </Form>
    </Drawer>
    <select-customer ref="SelCustomer" @selcust="selCust"></select-customer>
    <select-customer-sales ref="selSales" @selCustSales="selSales"></select-customer-sales>
    <select-depart ref="SelDepart" @seldep="selDept"></select-depart>
    <select-employee ref="SelEmp" @selemp="selEmp"></select-employee>
    <choose-goods ref="RefGoods" @selectRow="selGoods"></choose-goods>
    <select-area ref="RefArea" @selarea="selArea"></select-area>
    <select-delivery ref="RefDelivery" @seldeliv="selDelivery"></select-delivery>
  </div>
</template>

<script>
  var _this,
    formData = {
      f_date:'', invoice_date:'', orderid:'', settle_orderid:'', cust_no:'', custlass:'', area:'', link_man2:'', deliroute:'', goods_code:'', end_f_date:'', end_invoice_date:'', cheque_no:'', invoice_no:'', status:'', pay_kind:'', pay_mode_no:'', checker:'', emp_no:'', yw_dept_id:''
    };
  import splitNone from "@/components/public/splitNone"
  import SelectCustomer from "@/components/common/SelectCustomer"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectDepart from "@/components/common/SelectDepart"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import ChooseGoods from "@/components/common/ChooseGoods"
  import SelectArea from "@/components/common/SelectArea"
  import SelectDelivery from "@/components/common/SelectDelivery"
	export default {
		name: "SelPayList",
    components:{
      splitNone,SelectCustomer,SelectCustomerSales,SelectDepart,SelectEmployee,ChooseGoods,SelectArea,SelectDelivery
    },
    data:function () {
      return{
        openDrawer:false,
        height:0,
        Breadcrumb:[{title:'财务管理'},{title:'销售收款查询'}],
        editType:-1,
        editTypeTitle:'',
        formData:formData,
        custlass:[],
        columns:[
          {title:'收款单号',key:'orderid',width:160,minWidth:160,resizable:true,ellipsis:true,fixed:'left'},
          {title:'收款日期',key:'f_date',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'客户编号',key:'cust_no',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'客户名称',key:'cust_name',width:160,minWidth:160,resizable:true,ellipsis:true},
          {title:'收款类型',slot:'pay_kind',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'收款方式',key:'pay_mode_no',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'收款方式名称',slot:'pay_mode_no',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'支票号',key:'cheque_no',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'现收金额',key:'cash_amount',width:100,minWidth:100,resizable:true,ellipsis:true,align:'right'},
          {title:'折让金额',key:'discount',width:100,minWidth:100,resizable:true,ellipsis:true,align:'right'},
          {title:'本次实收',key:'paid_price',width:100,minWidth:100,resizable:true,ellipsis:true,align:'right'},
          {title:'使用结余款',slot:'pay_status',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'结余款',key:'prepay',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'部门编号',key:'yw_dept_id',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'部门名称',slot:'yw_dept_name',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'复核员',key:'checker',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'备注',key:'remark',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'创建者',key:'creater',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'创建人姓名',slot:'creater_name',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'开单部门',slot:'dept_id',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'公司地址',key:'comarea',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'仓库地址',key:'warehouse',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'客户采购员',key:'link_man',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'联系人',key:'link_ma2',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'父级编号',key:'parlevel',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'父级名称',key:'f_name',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'供方部门',key:'cust_dept',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'过账',slot:'status',width:80,minWidth:80,resizable:true,ellipsis:true,fixed:'right'}
        ],
        data:[],
        total:0,
        pageSize:25,
        page:1,
        CustSales:0,
        empName:'emp_no'
      }
    },
    mounted() {
		  _this = this;
    },
    created() {
		  this.init();
    },
    methods:{
		  init:function(){
        this.common.http({
          url:'f/getSelPayList',
          data:{page:this.page,pageSize:this.pageSize,search:this.formData}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total = res.data.total;
            _this.custlass = res.custlass;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      changeRow:function(item,index){
		    localStorage.setItem("sel_pay_orderid",item.orderid);
		    this.toUrl('/SelPayDtl');
      },
      DHeight:function (e) {
        this.height = e;
      },
      find(){
        this.init();
      },
      changePage:function(page){
        this.page = page;
        this.init();
      },
      ChangePageSize:function(pageSize){
        this.page = 1;
        this.pageSize = pageSize;
        this.init();
      },
      openCust:function(){
        this.$refs.SelCustomer.init();
      },
      selCust(e){
        this.formData.cust_no = e.id;
      },
      openSales:function(type){
        this.CustSales = type;
        if (!this.formData.cust_no) return false;
        this.$refs.selSales.open(this.formData.cust_no,type,true);
      },
      selSales:function(e){
        if (!e.data){
          this.formData.link_man2 = null;
        }else{
          if(this.CustSales==0){
            this.formData.link_man2 = e.data.user_name;
          }
        }
      },
      openDept:function(){
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
      },
      empty(){
		    this.formData = JSON.parse(JSON.stringify(formData))
      },
      openArea(){
		    this.$refs.RefArea.init();
      },
      selArea(e){
		    this.formData.area = e.area;
      },
      openDelivery(){
		    this.$refs.RefDelivery.init();
      },
      selDelivery(e){
        if (e.data) this.formData.deliroute = e.data.dname;
        else this.formData.deliroute = '';
      },
    }
	}
</script>

<style scoped>

</style>
