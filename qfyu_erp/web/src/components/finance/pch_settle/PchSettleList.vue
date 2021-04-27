<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
             <div class="nav-menu">
                <Button @click="addOrEditRow(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button @click="addOrEditRow(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Divider type="vertical"/>
                <Button @click="refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
             </div>
          </div>
          <div slot="table-list">
              <Table ref="pchSettleListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loadding"
                 @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                 @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                 <template slot-scope="row" slot="sales_deptid">
                    <span v-if="JSON.stringify($store.state.depart)!='[]'">{{$store.state.depart[row.row.sales_deptid]}}</span>
                 </template>
                 <template slot-scope="row" slot="invoice_type">
                    <span v-if="JSON.stringify($store.state.sysParam)!='[]'">{{$store.state.sysParam.invoice_type[row.row.invoice_type]}}</span>
                 </template>
                 <template slot-scope="row" slot="check_name">
                    <span v-if="row.row.check_code">{{$store.state.emp[row.row.check_code]}}</span>
                 </template>
                 <template slot-scope="row" slot="paymode_name">
                    <span v-if="row.row.paymode">{{$store.state.settlement[row.row.paymode]}}</span>
                 </template>
                 <template slot-scope="row" slot="creater_name">
                    {{$store.state.emp[row.row.creater]}}
                 </template>
                 <template slot-scope="row" slot="ischeck">
                    <Checkbox v-model="row.row.ischeck" :true-value="1" :false-value="0" disabled></Checkbox>
                 </template>
              </Table>
          </div>
      </split-none>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  var _this=this;
  export default {
     name:"PchSettleList",
     components:{splitNone},
     data(){
        return {
            height:0,
            Breadcrumb:[{title:'财务管理'},{title:'采购结算单查询'}],
            columns:[
               {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
               {title:'结算单号',key:'orderid',fixed:'left',width:160,align:'center'},
               {title:'结算日期',key:'settle_date',width:100,align:'center'},
               {title:'货品总数',key:'goods_qty',width:120,align:'center'},
               {title:'无税金额',key:'goods_sum',width:140,align:'center'},
               {title:'税款',key:'taxsum',width:140,align:'center'},
               {title:'合计',key:'amount',width:140,align:'center'},
               {title:'业务部门',slot:'sales_deptid',minWidth:140,align:'center'},
               {title:'供应商编号',key:'sup_code',width:90,align:'center'},
               {title:'供应商名称',key:'full_name',minWidth:220},
               {title:'供方销售人员',key:'sup_sell',width:120,align:'center'},
               {title:'供方联系人',key:'sup_contact',width:120,align:'center'},
               {title:'发票抬头',key:'company_name',minWidth:200},
               {title:'发票类型',slot:'invoice_type',width:100,align:'center'},
               {title:'发票电话号码',key:'telephone',minWidth:150},
               {title:'开户行',key:'bank_name',minWidth:150},
               {title:'账号',key:'account_no',minWidth:150,align:'center'},
               {title:'税号',key:'tax_no',minWidth:150,align:'center'},
               {title:'发票日期',key:'invoice_date',width:120,align:'center'},
               {title:'发票号码',key:'invoice_no',minWidth:150},
               {title:'发票总金额',key:'invoice_amount',width:140,align:'center'},
               {title:'发票地址',key:'invoice_address',minWidth:180},
               {title:'经手人',key:'emp_no',width:90,align:'center'},
               {title:'经手人姓名',key:'emp_name',width:120,align:'center'},
               {title:'复核员',key:'check_code',width:90,align:'center'},
               {title:'审核人姓名',slot:'check_name',width:100,align:'center'},
               {title:'结算方式',key:'paymode',width:120,align:'center'},
               {title:'结算方式名称',slot:'paymode_name',width:120,align:'center'},
               {title:'凭证号',key:'proof_no',width:150,align:'center'},
               {title:'开单人',key:'creater',width:100,align:'center'},
               {title:'开单人姓名',slot:'creater_name',width:100,align:'center'},
               {title:'过账',slot:'ischeck',width:80,align:'center'},
               {title:'送货单号',key:'reforderid',width:160,align:'center'},
               {title:'备注说明',key:'remark',minWidth:250}
            ],
            list:[],
            loadding:false,
            selectIndex:0, //当前选择行
            search:{}, //查询条件
            page:1,
            pageSize:10
        }
     },
     beforeCreate:function(){
        _this=this;
     },
     created:function(){
        _this.init();
     },
     methods:{
        rowClassName(row,index) {
           if(index===_this.selectIndex){
              return 'ivu-table-row-highlight';
           }
           return '';
        },
        DHeight(e){
           _this.height = e;
        },
        refresh:function(){
           _this.init();
        },
        /**
         * 初始化列表
         */
        init:function(){
           _this.loadding=true;
           _this.common.http({url:'f/pchSettleList',data:{page:_this.page,pageSize:_this.pageSize,search:_this.search}}).then(function(res){
               _this.loadding=false;
               if(res.status==1){
                 _this.list=res.list.data;
               }
           }).catch(function(err){
               _this.common.httpErr(err.data,_this);
           });
        },
        /**
         * 点击、双击表格数据
         * @param {Object} index
         * @param {Object} type
         */
        selectRowIndex:function(index,type){
            _this.selectIndex=index;
            if(type) _this.addOrEditRow(true);
        },
        /**
         * 新增或者修改
         * @param {Object} type
         */
        addOrEditRow:function(type){
            var orderid="";
            if(type){
               if(parseInt(_this.selectIndex)<0) return _this.alertMsg('请至少选择一行后操作','error');
               orderid = _this.list[_this.selectIndex].orderid;
            }
            localStorage.setItem("pchSettleOrderId",orderid);
            _this.toUrl("/EditPchSettle");
        }
     }
  }
</script>
<style>
</style>
