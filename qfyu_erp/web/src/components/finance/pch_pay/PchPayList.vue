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
              <Table ref="pchPayListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loadding"
                 @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                 @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                 <template slot-scope="row" slot="paykind">
                    <span v-if="JSON.stringify($store.state.sysParam)!='[]'">{{$store.state.sysParam.pay_kind[row.row.paykind]}}</span>
                 </template>
                 <template slot-scope="row" slot="sales_deptid">
                    <span v-if="JSON.stringify($store.state.depart)!='[]'">{{$store.state.depart[row.row.sales_deptid]}}</span>
                 </template>
                 <template slot-scope="row" slot="isprepay">
                    <Checkbox v-model="row.row.isprepay" :true-value="1" :false-value="0" disabled></Checkbox>
                 </template>
                 <template slot-scope="row" slot="check_name">
                    <span v-if="row.row.check_code">{{$store.state.emp[row.row.check_code]}}</span>
                 </template>
                 <template slot-scope="row" slot="creater_name">
                    {{$store.state.emp[row.row.creater]}}
                 </template>
                 <template slot-scope="row" slot="dept_id">
                    <span v-if="JSON.stringify($store.state.depart)!='[]'">{{$store.state.depart[row.row.dept_id]}}</span>
                 </template>
                 <template slot-scope="row" slot="paymode_name">
                    <span v-if="row.row.paymode">{{$store.state.settlement[row.row.paymode]}}</span>
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
     name:"PchPayList",
     components:{splitNone},
     data(){
        return {
            height:0,
            Breadcrumb:[{title:'财务管理'},{title:'采购付款单查询'}],
            columns:[
               {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
               {title:'单据编号',key:'orderid',fixed:'left',width:160,align:'center'},
               {title:'付款日期',key:'order_date',width:100,align:'center'},
               {title:'供应商编号',key:'sup_code',width:90,align:'center'},
               {title:'供应商名称',key:'full_name',minWidth:220},
               {title:'供方销售人员',key:'sup_sell',width:120,align:'center'},
               {title:'供方联系人',key:'sup_contact',width:120,align:'center'},
               {title:'付款类型',slot:'paykind',width:100,align:'center'},
               {title:'供方部门',key:'sup_dept',minWidth:140,align:'center'},
               {title:'业务部门',slot:'sales_deptid',minWidth:140,align:'center'},
               {title:'现付金额',key:'cur_pay',width:140,align:'center'},
               {title:'折让金额',key:'discount_pay',width:140,align:'center'},
               {title:'使用结余款',slot:'isprepay',width:90,align:'center'},
               {title:'本次实付',key:'paid_pay',width:140,align:'center'},
               {title:'复核员',key:'check_code',width:90,align:'center'},
               {title:'审核人姓名',slot:'check_name',width:100,align:'center'},
               {title:'过账',slot:'ischeck',width:80,align:'center'},
               {title:'开单人',key:'creator',width:100,align:'center'},
               {title:'开单人姓名',slot:'creater_name',width:100,align:'center'},
               {title:'支票号',key:'cheque_no',minWidth:150,align:'center'},
               {title:'购方部门',slot:'dept_id',minWidth:120},
               {title:'结算单号',key:'reforderid',width:160,align:'center'},
               {title:'结算方式',key:'paymode',width:120,align:'center'},
               {title:'结算方式名称',slot:'paymode_name',width:120,align:'center'},
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
           _this.common.http({url:'f/purchasePayList',data:{page:_this.page,pageSize:_this.pageSize,search:_this.search}}).then(function(res){
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
            localStorage.setItem("pchPayOrderId",orderid);
            _this.toUrl("/EditPchPay");
        }
     }
  }
</script>
<style>
</style>
