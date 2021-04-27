<template>
	<div>
    <Modal class-name="order-modal" v-model="modal" title="选择发货数据" width="900" footer-hide :mask-closable="false">
      <Form class="form-box border-b bg-m" :model="searchData" :label-width="70">
        <Row>
          <Col span="6">
            <FormItem label="单据编号">
              <Input v-model="searchData.orderid"></Input>
            </FormItem>
            <FormItem label="客户编号">
              <Input v-model="searchData.cust_no" disabled></Input>
            </FormItem>
            <FormItem label="商品编号">
              <Input v-model="searchData.goods_code"></Input>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="单据日期">
              <DatePicker type="date" v-model="searchData.f_date"></DatePicker>
            </FormItem>
            <FormItem label="业务员">
              <Input v-model="searchData.emp_no"></Input>
            </FormItem>
            <FormItem label="建单人">
              <Input v-model="searchData.creater"></Input>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="至">
              <DatePicker type="date" v-model="searchData.end_f_date"></DatePicker>
            </FormItem>
            <FormItem label="发货超过">
              <Input v-model="searchData.time_num"></Input>
            </FormItem>
            <Row class-name="text-left">
              <span class="bg-text">天后不允许退货(0表示忽略超时条件)</span>
            </Row>
          </Col>
          <Col span="4" class-name="active-btn">
            <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe691;</span>查询</Button>
            <Button @click="confirm" icon="md-checkmark" :disabled="tabsName=='stock'?true:false">选定</Button>
            <Button @click="modal=!modal"><span class="icon iconfont">&#xe7fd;</span>关闭</Button>
          </Col>
        </Row>
      </Form>
      <Row class-name="ts"><span class="error-text">提示：鼠标点击网格最左边选择框可以多选，选定行则等于选定该单对应的所有明细。</span></Row>
      <Row class-name="table-tabs">
        <Tabs type="card" :animated="false" v-model="tabsName" @on-click="changeTabs">
          <TabPane label="发货单" name="orderList">
            <Table size="small" border :columns="columns" :data="data" height="400">
              <template slot-scope="{row,index}" slot="select">
                <Checkbox v-model="data[index].select" @on-change="changeSelect"></Checkbox>
              </template>
              <template slot-scope="{row}" slot="dept_id">
                <span>{{$store.state.depart[row.dept_id]}}</span>
              </template>
              <template slot-scope="{row}" slot="emp_name">
                <span>{{$store.state.emp[row.emp_no]}}</span>
              </template>
              <template slot-scope="{row}" slot="creater_name">
                <span>{{$store.state.emp[row.creater]}}</span>
              </template>
            </Table>
            <div style="text-align: right;padding: 5px 16px;">
              <Page size="small" transfer show-total show-sizer :total="total" :page-size="pageSize" :page-size-opts="[20,30,40,50]" @on-change="changePage" @on-page-size-change="changePageSize"></Page>
            </div>
          </TabPane>
          <TabPane label="发货明细" name="orderDtl">
            <Table size="small" border :columns="columns2" :data="data2" height="400">
              <template slot-scope="{row,index}" slot="select">
                <Checkbox v-model="data2[index].select"></Checkbox>
              </template>
              <template slot-scope="{row}" slot="gsp_type">
                <span v-if="$store.state.sysParam != {}">{{$store.state.sysParam.gsp_category[row.gsp_type]}}</span>
              </template>
              <template slot-scope="{row}" slot="is_supervise">
                <span>{{row.is_supervise?'是':'否'}}</span>
              </template>
            </Table>
          </TabPane>
          <TabPane label="出库复核记录" name="stock">
            <Table size="small" border :columns="columns3" :data="data3" height="400">
              <template slot-scope="{row}" slot="is_supervise">
                <span>{{row.is_supervise?'是':'否'}}</span>
              </template>
            </Table>
          </TabPane>
        </Tabs>
      </Row>

    </Modal>
  </div>
</template>

<script>
	export default {
		name: "SelectSelOrder",
    data(){
		  return{
        modal:false,
        searchData:{cust_no:'',orderid:'',goods_code:'',emp_no:'',creater:'',f_date:'',end_f_date:''},
        columns:[
          {title:'选择',slot:'select',width:45,align:'center'},
          {title:'单据编号',key:'orderid',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'日期',key:'f_date',width:90,minWidth:90,ellipsis:true,resizable:true},
          {title:'客户编号',key:'cust_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'客户名称',key:'cust_name',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'货品总数',key:'goods_qty',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'无税金额',key:'goods_sum',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'税款',key:'tax_sum',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'合计',key:'amount',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'部门编号',key:'dept_id',width:70,minWidth:70,ellipsis:true,resizable:true,align:'center'},
          {title:'部门名称',slot:'dept_id',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'结算方式',key:'pay_mode_no',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'业务员',key:'emp_no',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'员工姓名',slot:'emp_name',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'创建者',key:'creater',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'创建者姓名',slot:'creater_name',width:80,minWidth:80,ellipsis:true,resizable:true},
        ],
        data:[],
        columns2:[
          {title:'选择',slot:'select',width:45,align:'center'},
          {title:'单据编号',key:'orderid',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'商品编号',key:'goods_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'通用名称',key:'name',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'剂型',key:'dosage',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'单位',key:'unit',width:60,minWidth:60,ellipsis:true,resizable:true,align:'center'},
          {title:'拼音码',key:'pym',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'条码一',key:'code',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'数量',key:'qty',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'税率',key:'tax_rate',width:80,minWidth:80,ellipsis:true,resizable:true,align:'right'},
          {title:'无税单价',key:'un_tax_price',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'无税金额',key:'goods_sum',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'税款',key:'tax_sum',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'合计',key:'amount',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'赠品数量',key:'gift_qty',width:100,minWidth:100,ellipsis:true,resizable:true,align:'right'},
          {title:'生产日期',key:'prod_date',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'有效期至',key:'valid_date',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'供应商编号',key:'prov_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'已结数量',key:'settle_qty',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'生产企业',key:'production',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'批准文号',key:'approval_code',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'项次',key:'item_no',width:50,minWidth:50,ellipsis:true,resizable:true,align:'center'},
          {title:'规格',key:'specs',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'折扣%',key:'rebate',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'实际售价',key:'price',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'产地',key:'origin',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'客户商品编号',key:'cust_goods_code',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'已发数量',key:'paid_up',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'退货数量',key:'ret_qty',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'生产批号',key:'batch_no',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'发货仓库',key:'ware_title',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'仓库编号',key:'ware_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'存货库位',key:'berth_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'储存条件',key:'storage_type',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'GSP验收类型',slot:'gsp_type',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'是否监管',slot:'is_supervise',width:70,minWidth:70,ellipsis:true,resizable:true,align:'center'},
          {title:'参考成本价',key:'ref_cost_price',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'参考成本',key:'ref_cost',width:80,minWidth:80,ellipsis:true,resizable:true},
        ],
        data2:[],
        columns3:[
          {title:'单据编号',key:'orderid',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'项次',key:'item_no',width:45,align:'center'},
          {title:'商品编号',key:'goods_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'商品名称',key:'name',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'规格',key:'specs',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'剂型',key:'dosage',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'生产企业简称',key:'maker',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'拼音码',key:'pym',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'条码一',key:'code',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'批准文号',key:'dept_id',width:140,minWidth:140,ellipsis:true,resizable:true},
          {title:'单位',key:'unit',width:60,minWidth:60,ellipsis:true,resizable:true},
          {title:'数量',key:'qty',width:100,minWidth:100,ellipsis:true,resizable:true,algin:'right'},
          {title:'单价',key:'price',width:100,minWidth:100,ellipsis:true,resizable:true,algin:'right'},
          {title:'合计',key:'amount',width:100,minWidth:100,ellipsis:true,resizable:true,algin:'right'},
          {title:'生产批号',key:'batch_no',width:120,minWidth:120,ellipsis:true,resizable:true},
          {title:'供应商编号',key:'prov_no',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'生产日期',key:'prod_date',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'有效期至',key:'valid_date',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'产地',key:'origin',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'生产企业',key:'production',width:150,minWidth:150,ellipsis:true,resizable:true},
          {title:'销售/销退单号',key:'p_order_no',width:160,minWidth:160,ellipsis:true,resizable:true},
          {title:'对应项次',key:'p_item_no',width:70,minWidth:70,ellipsis:true,resizable:true},
          {title:'出货仓库',key:'ware_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'仓库名称',key:'ware_title',width:130,minWidth:130,ellipsis:true,resizable:true},
          {title:'存货仓位',key:'pos_code',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'储存条件',key:'storage_type',width:80,minWidth:80,ellipsis:true,resizable:true},
          {title:'GSP验收类型',key:'gsp_type',width:100,minWidth:100,ellipsis:true,resizable:true},
          {title:'是否监管',slot:'is_supervise',width:70,minWidth:70,ellipsis:true,resizable:true,align:'center'},
        ],
        data3:[],
        tabsName:'orderList',
        sonData:[],
        orderidStr:'',
        total:0,
        page:1,
        pageSize:20
      }
    },
    watch:{
      orderidStr(e){
        this.getOrderDtl();
        this.getOrderStock();
      }
    },
    methods:{
		  //发货单
		  init(){
        var _this = this;
        this.common.http({
          url:'s/getSelOrder',
          data:{page:this.page,pageSize:this.pageSize,search:this.searchData}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total= res.data.total;
            if (_this.data.length){
              _this.$set(_this.data[0],'select',true)
              _this.changeSelect();
            }
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      //发货明细
      getOrderDtl(type){
		    type = type || false;
        var _this = this;
        this.common.http({
          url:'s/getSelOrderDtl',
          data:{orderid:this.orderidStr}
        }).then(function (res) {
          if (res.status){
            _this.data2 = res.data;
            if (_this.data2.length) _this.$set(_this.data2[0],'select',true);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })

      },
      //出库复核记录
      getOrderStock(){
        var _this = this;
        this.common.http({
          url:'w/getSelOrderStock',
          data:{orderid:this.orderidStr}
        }).then(function (res) {
          if (res.status){
            _this.data3 = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      changeSelect(){
		    var obj=this.data,str='';
        for (let i=0;i<obj.length;i++){
          if (typeof(obj[i].select)!="undefined" && obj[i].select){
            str += str?','+obj[i].orderid:obj[i].orderid;
          }
        }
        this.orderidStr = str;
      },
      confirm(){
        if (!this.data2.length) return this.modalMsg('请选择一项数据！');
        this.modal = false;
        this.$emit('confirm',this.data2);
      },
      changeTabs(name){
		    this.tabsName = name;
      },
      open(custNo){
		    this.searchData.cust_no = custNo;
		    this.modal = true;
		    this.init();
      },
      changePage(page){
		    this.page = page;
		    this.init();
      },
      changePageSize(page_size){
        this.page = 1;
        this.pageSize = page_size;
        this.init();
      },
    }
	}
</script>

<style lang="less">
.order-modal{
  .ivu-modal-body{
    padding: 0;
  }
  .form-box{
    padding-top: 6px;
    .active-btn{
      padding-left: 50px;
      .ivu-btn{
        display: block;margin-bottom: 5px;
      }
    }
    .text-left{
      padding-left: 70px;
    }
  }
  .ts{padding: 6px;}
  .table-tabs{
    padding: 0;height:auto;overflow: hidden;
    .ivu-tabs{
      .ivu-tabs-bar{
        margin-bottom:0;
      }
    }
  }
}
</style>
