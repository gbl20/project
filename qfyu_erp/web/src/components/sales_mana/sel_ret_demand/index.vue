<template>
<div>
  <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
    <div slot="form-ser">
      <div class="nav-menu">
        <Button @click="addOrder"><span class="icon iconfont">&#xe797;</span>新增销退申请单</Button>
        <Button @click="openSearch=true"><span class="icon iconfont">&#xe691;</span>条件筛选</Button>
        <Button @click="addOrder"><span class="icon iconfont">&#xe6a0;</span>报表</Button>
      </div>
    </div>
    <div slot="table-list">
      <Table size="small" border :columns="columns" :data="data" :height="height-34" @on-row-click="(item,index)=>{changeRow(item,index,false)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,true)}">
        <template slot-scope="{row}" slot="emp_name">
          <span>{{$store.state.emp[row.emp_no]}}</span>
        </template>
        <template slot-scope="{row}" slot="creater_name">
          <span>{{$store.state.emp[row.creater]}}</span>
        </template>
        <template slot-scope="{row}" slot="audit_name">
          <span>{{$store.state.emp[row.audit]}}</span>
        </template>
        <template slot-scope="{row}" slot="depart">
          <span>{{$store.state.depart[row.depart_id]}}</span>
        </template>
        <template slot-scope="{row}" slot="status">
          <div style="text-align: center;" :class="row.status?'success-bg-text':'warning-bg-text'">{{row.status?'已过账':'未过账'}}</div>
        </template>
      </Table>
      <div class="page-m">
        <Page size="small" show-total show-sizer :total="total" :page-size="pageSize" :page-size-opts="[15,25,35,50]" @on-change="changePage" @on-page-size-change="changePageSize"></Page>
      </div>
    </div>
  </split-none>
  <Drawer title="查询条件" :closable="false" v-model="openSearch" width="500">
    <Form :model="search" :label-width="80">
      <Row>
        <Col span="12">
          <FormItem label="申请日期">
            <DatePicker type="date" format="yyyy年-MM月-dd日" v-model="search.f_date"></DatePicker>
          </FormItem>
          <FormItem label="申请单据号">
            <Input v-model="search.orderid"></Input>
          </FormItem>
          <FormItem label="原发货单号">
            <Input v-model="search.p_orderid"></Input>
          </FormItem>
          <FormItem label="合同号">
            <Input v-model="search.contract_no"></Input>
          </FormItem>
          <FormItem label="制单人">
            <Input v-model="search.creater"><Button slot="append" icon="ios-more" class="clear-btn" @click="openEmp('creater')"></Button></Input>
          </FormItem>
          <FormItem label="开单部门">
            <Input v-model="search.depart_id"><Button slot="append" icon="ios-more" class="clear-btn" @click="openDept"></Button></Input>
          </FormItem>
        </Col>
        <Col span="12">
          <FormItem label="申请日期至">
            <DatePicker type="date" format="yyyy年-MM月-dd日" v-model="search.f_edate"></DatePicker>
          </FormItem>
          <FormItem label="客户编号">
            <Input v-model="search.cust_no"><Button slot="append" icon="ios-more" class="clear-btn" @click="openCust"></Button></Input>
          </FormItem>
          <FormItem label="联系人">
            <Input v-model="search.linkman2"><Button slot="append" icon="ios-more" class="clear-btn" @click="openSales"></Button></Input>
          </FormItem>
          <FormItem label="业务员">
            <Input v-model="search.emp_no"><Button slot="append" icon="ios-more" class="clear-btn" @click="openEmp('emp_no')"></Button></Input>
          </FormItem>
          <FormItem label="审核人">
            <Input v-model="search.audit"><Button slot="append" icon="ios-more" class="clear-btn" @click="openEmp('audit')"></Button></Input>
          </FormItem>
          <FormItem label="单据状态">
            <Select v-model="search.status">
              <Option value="0">未审核</Option>
              <Option value="1">已审核</Option>
            </Select>
          </FormItem>
        </Col>
      </Row>
      <FormItem label="商品编号">
        <Row>
          <Col span="20"><Input v-model="search.goods_code"><Button slot="append" icon="ios-more" class="clear-btn" @click="openPro"></Button></Input></Col>
          <Col span="4" class-name="p-l"><Checkbox :true-value="1" :false-value="0" v-model="status">多选</Checkbox></Col>
        </Row>
      </FormItem>
      <FormItem>
        <Button @click="find"><span class="icon iconfont">&#xe691;</span>查询</Button>
      </FormItem>
    </Form>
  </Drawer>
  <select-customer ref="SelectCustomer" @selcust="selCustomer"></select-customer>
  <select-customer-sales ref="selCustomerSales" @selCustSales="selCustSales"></select-customer-sales>
  <select-employee ref="SelectEmployee" @selemp="selEmployee"></select-employee>
  <choose-goods ref="ChooseGoodsRef" @selectRow="selGoods"></choose-goods>
  <select-depart ref="SelectDepartRef" @seldep="selDept"></select-depart>
</div>
</template>

<script>
  var _this;
  import splitNone from "@/components/public/splitNone"
  import SelectCustomer from "@/components/common/SelectCustomer"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import ChooseGoods from "@/components/common/ChooseGoods"
  import SelectDepart from "@/components/common/SelectDepart"
	export default {
		name: "SelRetDemandList",
    components:{
      splitNone,SelectCustomer,SelectCustomerSales,SelectEmployee,ChooseGoods,SelectDepart
    },
    data(){
		  return{
        height:0,
        Breadcrumb:[{title:'销售管理'},{title:'销售退回管理'},{title:'销售退回申请查询'}],
        columns:[
          {title:'单据编号',key: 'orderid',width: 155,minWidth: 155, ellipsis: true, resizable: true,fixed:'left'},
          {title:'申请日期',key: 'f_date',width: 140,minWidth: 140, ellipsis: true, resizable: true,sortable:true},
          {title:'合同号',key: 'contract_no',width: 120,minWidth: 120, ellipsis: true, resizable: true},
          {title:'对应单号',key: 'p_orderid',width: 155,minWidth: 155, ellipsis: true, resizable: true},
          {title:'业务员',key: 'emp_no',width: 60,minWidth: 60, ellipsis: true, resizable: true},
          {title:'业务员姓名',slot: 'emp_name',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'复核人',key: 'audit',width: 60,minWidth: 60, ellipsis: true, resizable: true},
          {title:'复核人姓名',slot: 'audit_name',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'客户编号',key: 'cust_no',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'客户简称',key: 'cust_sname',width: 130,minWidth: 130, ellipsis: true, resizable: true},
          {title:'客户采购员',key: 'linkman',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'客户联系人',key: 'linkman2',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'货品总数',key: 'goods_qty',width: 100,minWidth: 100, ellipsis: true, resizable: true,align:'right'},
          {title:'货款',key: 'goods_sum',width: 100,minWidth: 100, ellipsis: true, resizable: true,sortable:true,align:'right'},
          {title:'税款', key: 'tax_sum',width: 100,minWidth: 100, ellipsis: true, resizable: true,sortable:true,align:'right'},
          {title:'合计', key: 'amount',width: 100,minWidth: 100, ellipsis: true, resizable: true,sortable:true,align:'right'},
          {title:'备注', key: 'remark',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'创建者', key: 'creater',width: 70,minWidth: 70, ellipsis: true, resizable: true},
          {title:'开单人', slot: 'creater_name',width: 70,minWidth: 70, ellipsis: true, resizable: true},
          {title:'开单部门', key: 'depart_id',width: 70,minWidth: 70, ellipsis: true, resizable: true},
          {title:'开单部门名称', slot: 'depart',width: 100,minWidth: 100, ellipsis: true, resizable: true},
          {title:'父级编号', key: 'parlevel',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'父级名称', key: 'parlevel_name',width: 130,minWidth: 130, ellipsis: true, resizable: true},
          {title:'供方部门', key: 'cust_depart',width: 80,minWidth: 80, ellipsis: true, resizable: true},
          {title:'过账', slot: 'status',width: 80,minWidth: 80, ellipsis: true, resizable: true,fixed:'right'},
        ],
        data:[],
        total:0,
        pageSize:25,
        page:1,
        openSearch:false,
        search:{
          f_date:'',orderid:'',contract_no:'',goods_code:'',creater:'',depart_id:'',f_edate:'',cust_no:'',linkman2:'',emp_no:'',audit:'',status:'',
        },
        empName:'',
        status:0
      }
    },
    mounted() {
		  _this = this;
    },
    created() {
		  this.init();
    },
    methods:{
		  init(){
        this.common.http({
          url:'s/getSelRetDemandList',
          data:{page:this.page,pageSize:this.pageSize,search:this.search}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total = res.data.total;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      openPro(){
        this.$refs.ChooseGoodsRef.open();
      },
      openEmp(name){
		    this.empName = name;
        this.$refs.SelectEmployee.init();
      },
      openDept(){
        this.$refs.SelectDepartRef.init();
      },
      openCust(){
        this.$refs.SelectCustomer.init();
      },
      openSales(){
        if (!this.search.cust_no) return false;
        this.$refs.selCustomerSales.open(this.search.cust_no,2,true);
      },
      selCustomer(e){
        this.search.cust_no = e.id;
      },
      selCustSales(e){
        if (!e.data){
          this.search.linkman2 = null;
        }else{
          this.search.linkman2 = e.data.user_name;
        }
      },
      selEmployee(e){
        this.search[this.empName] = e.code;
      },
      selDept(e){
        this.search.depart_id = e.id;
      },
      selGoods(e){
		    if (this.status){
          this.search.goods_code += this.search.goods_code?','+e.goods_code:e.goods_code;
        }else{
          this.search.goods_code = e.goods_code;
        }
      },
      find(){
		    this.init();
      },
      changeRow(item,index,type){
        if (type){
          localStorage.setItem("sel_demand_orderid",item.orderid);
          this.toUrl('/SelRetDemandEdit');
        }
      },
      addOrder(){
		    localStorage.removeItem("sel_demand_orderid");
        this.toUrl('/SelRetDemandEdit');
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
      DHeight(e){
        this.height = e;
      }
    }
  }
</script>

<style lang="less">
.p-l{padding-left: 5px;}
</style>
