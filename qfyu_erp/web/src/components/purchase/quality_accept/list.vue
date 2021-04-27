<template>
	<div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Form :model="formData" :label-width="70" style="width: 1200px">
            <Row>
              <Col span="7">
                <FormItem label="验收日期">
                  <Row>
                    <Col span="11">
                        <DatePicker type="date" v-model="formData.start_date"></DatePicker>
                    </Col>
                    <Col span="2" style="text-align: center">至</Col>
                    <Col span="11">
                        <DatePicker type="date" v-model="formData.end_date"></DatePicker>
                    </Col>
                  </Row>
                </FormItem>
                <FormItem label="验收单号">
                  <Input v-model="formData.orderid" placeholder="请填写验收单号"></Input>
                </FormItem>
                <FormItem label="采购单号">
                  <Input v-model="formData.come_orderid" placeholder="请填写采购单号" @on-change="changeCorderid"></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="供应商">
                  <Input icon="ios-more" v-model="formData.supplier_code" @on-click="openProiders"></Input>
                </FormItem>
                <FormItem label="商品">
                  <Input v-model="formData.goods_code"></Input>
                </FormItem>
                <FormItem label="单据备注">
                  <Input v-model="formData.remark"></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="地区">
                  <Input v-model="formData.area"></Input>
                </FormItem>
                <FormItem label="复核员">
                  <Input icon="ios-more" v-model="formData.checker_code" @on-click="openemployee('checker_code')"></Input>
                </FormItem>
                <FormItem label="制单人">
                  <Input icon="ios-more" v-model="formData.create_code" @on-click="openemployee('create_code')"></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="验收类型">
                  <Select clearable v-model="formData.gsp_type">
                    <Option v-for="(item,key,index) in $store.state.sysParam.gsp_category" :value="key" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="审核状态">
                  <Select clearable v-model="formData.status">
                    <Option value="0">未审核</Option>
                    <Option value="1">已审核</Option>
                  </Select>
                </FormItem>
                <FormItem label="开单部门">
                  <Input icon="ios-more" v-model="formData.depart" @on-click="openDepart"></Input>
                </FormItem>
              </Col>
              <Col span="3" class-name="active-col">
                <Button @click="search" class="btn"><span class="icon iconfont">&#xe691;</span>查询</Button>
                <Button class="btn"><span class="icon iconfont">&#xe6a0;</span>报表</Button>
                <Button class="btn">详情信息</Button>
              </Col>
            </Row>
          </Form>
        </div>
      </div>
      <div slot="table-list">
        <Table border stripe highlight-row size="small" :columns="columns" :data="data" :height="height-34" @on-row-click="(item,index)=>{changeRow(item,index,true)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,false)}">
          <template slot-scope="{row}" slot="check_name">
            <span>{{row.check_type==1?'采购验收':'其他验收'}}</span>
          </template>
          <template slot-scope="{row}" slot="gsp_name">
            <span v-if="JSON.stringify($store.state.sysParam) != '[]'">{{$store.state.sysParam.gsp_category[row.gsp_type]}}</span>
          </template>
          <template slot-scope="{row}" slot="status">
            <div style="text-align: center" :class="row.status?'success-bg-text':'warning-bg-text'">{{row.status?'已审核':'未审核'}}</div>
          </template>
        </Table>
        <div class="page-m">
          <Page size="small" :total="total" :page-size="pageSize" :page-size-opts="[15,25,35,50]" show-total show-elevator show-sizer @on-change="changePage" @on-page-size-change="ChangePageSize" />
        </div>
      </div>
    </split-none>
    <choose-providers ref="proidersRef" @confirm="selProiders"></choose-providers>
    <select-employee ref="employeeRef" @selemp="selEmployee"></select-employee>
    <select-depart ref="departRef" @seldep="selDepart"></select-depart>
  </div>
</template>

<script>
  var _this,
      formData={
        start_date:'', end_date:new Date(),supplier_code:'',area:'',gsp_type:null,orderid:'', come_orderid:'', remark:'', checker_code:null, create_code:null, goods_code:'', status:'', depart:null,check_type:1
    };
  import splitNone from '@/components/public/splitNone'
  import ChooseProviders from "@/components/common/ChooseProviders"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import SelectDepart from "@/components/common/SelectDepart"
  import toUrl from "@/assets/purchase/to_type_url.js"
	export default {
		name: "list",
    components:{
      splitNone,ChooseProviders,SelectEmployee,SelectDepart
    },
    data:function () {
      return{
        gspType:1,
        Breadcrumb:[{title:'采购管理'},{title:'质量验收'},{title:'质量验收查询'}],
        height:0,
        formData:formData,
        columns:[
          {title:'单号',key:'orderid',width:160,minWidth:160,ellipsis:true,resizable:true,fixed:'left'},
          {title:'采购(销退)单号',key:'come_orderid',width:160,minWidth:160,ellipsis:true,resizable:true,fixed:'left'},
          {title:'来货日期',key:'delivery_date',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'单据类型',key:'check_type',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'单据类别',slot:'check_name',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'验收类型',key:'gsp_type',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'验收类型名称',slot:'gsp_name',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'供应商编号',key:'supplier_code',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'供应商名称',key:'supplier_name',width:200,minWidth:200,ellipsis:true,resizable:true},
          {title:'复核员编号',key:'checker_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'审核人姓名',key:'checker_name',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'开单部门',key:'depart_name',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'开单人姓名',key:'create_name',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'创建人',key:'create_code',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'创建时间',key:'create_date',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'供方部门',key:'supplier_depart',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'备注',key:'remark',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'单据状态',slot:'status',width:90,minWidth:90,ellipsis:true,resizable:true,fixed:'right'}
        ],
        data:[],
        typeItem:[],
        name:'',
        total:0,
        page:1,
        pageSize:15
      }
    },
    activated() {
		  this.formData.come_orderid = localStorage.getItem("quality_accept_orderid");
    },
    computed:{
      orderid(){
        return this.formData.come_orderid;
      }
    },
    watch:{
      orderid(e){
        if(e) this.init();
      }
    },
    mounted() {
		  _this=this;
		  var nowDate = new Date();
		  let year = nowDate.getFullYear();
		  let month = nowDate.getMonth()+1;
		  this.formData.start_date = year+'-'+month+'-'+1;
    },
    created() {
		  this.init();
    },
    methods:{
		  init:function(){
        this.common.http({
          url:'getQualityAllList',
          data:{page:this.page,pageSize:this.pageSize,search:this.formData}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total= res.data.total;
            _this.typeItem= res.gspType;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      openProiders:function(){
		    this.$refs.proidersRef.open();
      },
      selProiders:function(e){
        this.formData.supplier_code = e.supplier_code;
      },
      openemployee:function(name){
		    this.name = name;
		    this.$refs.employeeRef.init();
      },
      selEmployee:function(e){
		    this.formData[this.name] = e.code;
      },
      openDepart:function(){
		    this.$refs.departRef.init();
      },
      selDepart:function(e){
		    this.formData.depart = e.id;
      },
      changeRow:function(item,index,type){
        if (!type){
          toUrl.toTypeUrl(item.gsp_type,item.orderid,_this);
        }
      },
      changeCorderid:function(){
		    localStorage.removeItem("quality_accept_orderid");
      },
      search:function(){
		    this.init();
      },
      changePage:function(page){
        this.page = page;
        this.init();
      },
      ChangePageSize:function(page_size){
        this.page = 1;
        this.pageSize = page_size;
        this.init();
      },
      dHeight:function (e) {
        this.height = e;
      }
    }
	}
</script>

<style lang="less">
  .active-col{
    padding-left: 10px;
    .btn{
      display: block;
      margin-bottom: 4px;
    }
  }
</style>
