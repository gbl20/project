<template>
  <div>
     <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
         <div slot="form-ser">
            <div class="nav-menu">
               <Button @click="addOrEditRow"><span class="icon iconfont">&#xe791;</span>修改</Button>
               <Divider type="vertical"/>
               <Button @click="auditOrder" :disabled="list[selectIndex].is_transfer==1" v-if="list.length>0">
                  <span class="icon iconfont">&#xe692;</span>审核
               </Button>
               <Button @click="backOrder" :disabled="list[selectIndex].is_transfer!=1" v-if="list.length>0">
                  <span class="icon iconfont">&#xe693;</span>还原
               </Button>
               <Divider type="vertical"/>
               <Button @click="refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
               <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
               <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
            </div>
         </div>
         <div slot="table-list">
             <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loadding"
                @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                <template slot-scope="row" slot="in_out_kind">
                  <span v-if="JSON.stringify($store.state.inoutKind)!='[]'">{{$store.state.inoutKind[row.row.in_out_kind]}}</span>
                </template>
                <template slot-scope="row" slot="emp_name">
                  <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.emp_no]}}</span>
                </template>
                <template slot-scope="row" slot="shipper_name">
                  <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.shipper]}}</span>
                </template>
                <template slot-scope="row" slot="is_transfer">
                  <Checkbox v-model="row.row.is_transfer" :true-value="1" :false-value="0" disabled></Checkbox>
                </template>
                <template slot-scope="row" slot="audit_name">
                  <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.audit]}}</span>
                </template>
                <template slot-scope="row" slot="dept_id">
                  <span v-if="JSON.stringify($store.state.depart)!='[]'">{{$store.state.depart[row.row.dept_id]}}</span>
                </template>
                <template slot-scope="row" slot="audit2_name">
                  <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.audit2]}}</span>
                </template>
             </Table>
         </div>
     </split-none>
     <!-- 弹出操作提示 -->
     <window-tip ref="windowTipRef"></window-tip>
  </div>
</template>
<script>
  var _this;
  import splitNone from '@/components/public/splitNone'
  import windowTip from '@/components/common/WindowTip'
  export default {
      components:{splitNone,windowTip},
      name:"StockOutList",
      data(){
        return {
            height:0,
            Breadcrumb:[{title:'仓储物流'},{title:'出库登记/复核查询'}],
            selectIndex:0,
            page:1,
            total:0,
            pageSize:20,
            columns:[
               {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
               {title:'单据编号',key:'orderid',fixed:'left',width:160,align:'center'},
               {title:'单据日期',key:'f_date',width:110,align:'center'},
               {title:'客户编号',key:'cust_no',width:100,align:'center'},
               {title:'客户名称',key:'cust_name',width:200},
               {title:'仓库名称',key:'ware_title',width:150},
               {title:'出库方式',slot:'in_out_kind',width:120},
               {title:'销售/销退单号',key:'p_order_no',width:160,align:'center'},
               {title:'货品总数',key:'goods_qty',width:120,align:'center'},
               {title:'货款',key:'goods_sum',width:120,align:'center'},
               {title:'合计金额',key:'cost_sum',width:120,align:'center'},
               {title:'验货员',key:'emp_no',width:90,align:'center'},
               {title:'验货员姓名',slot:'emp_name',width:120,align:'center'},
               {title:'发货人',key:'shipper',width:90,align:'center'},
               {title:'发货人姓名',key:'shipper_name',width:120,align:'center'},
               {title:'过账',slot:'is_transfer',width:80,align:'center'},
               {title:'复核',key:'audit',width:90,align:'center'},
               {title:'复核人姓名',slot:'audit_name',width:120,align:'center'},
               {title:'创建者',key:'creater',width:90,align:'center'},
               {title:'创建时间',key:'creat_date',width:120,align:'center'},
               {title:'流水号',key:'rec_no',minWidth:140,align:'center'},
               {title:'开单部门',slot:'dept_id',minWidth:140,align:'center'},
               {title:'第二复核员',key:'audit2',width:90,align:'center'},
               {title:'第二复核员姓名',slot:'audit2_name',width:120,align:'center'},
               {title:'供方部门',key:'order_date',width:200,align:'center'},
               {title:'备注',key:'remark',width:220},
            ],
            list:[],
            loadding:false,
            search:{}
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
          init:function(){
              var data={page:_this.page,pageSize:_this.pageSize,search:_this.search};
              _this.loadding=true;
              _this.common.http({url:'w/getStockOutList',data:data}).then(function(res){
                  _this.loadding=false;
                  if(res.status==1){
                    _this.list=res.list.data;
                    _this.total = res.list.total;
                  }
              }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 修改
           * @param {Object} type
           */
          addOrEditRow:function(){
            if(_this.list.length==0 || parseInt(_this.selectIndex)<0){
              return _this.alertMsg('请至少选择一行后操作','error');
            }
            var orderid = _this.list[_this.selectIndex].orderid;
            localStorage.setItem("StockOutOrderId",orderid);
            _this.toUrl("/editStockOut");
          },
          /**
           * 表格单击、双击
           * @param {Object} index
           * @param {Object} type
           */
          selectRowIndex:function(index,type){
              _this.selectIndex=index;
              if(type) _this.addOrEditRow();
          },
          /**
           * 审核
           */
          auditOrder:function(){
             if(_this.list.length==0 || _this.list[_this.selectIndex].is_transfer==1) return false;
             var orderid=_this.list[_this.selectIndex].orderid;
             _this.$Modal.confirm({
                 title:'审核提示',
                 content:'要审核出库复核单【'+orderid+'】吗？',
                 onOk:function(){
                     _this.common.http({url:'w/auditStockOrder',data:{orderid:orderid}}).then(function(res){
                         if(res.status==1){
                             _this.init();
                             _this.$refs.windowTipRef.open({title:"审核提示",content:res.msg,issucess:true,isconfirm:false});
                         }else{
                             _this.$refs.windowTipRef.open({title:"审核提示",content:res.msg,issucess:false,isconfirm:false});
                         }
                     }).catch(function(err){
                         _this.common.httpErr(err.data,_this);
                     });
                 }
             });
          },
          /**
           * 还原
           */
          backOrder:function(){
             if(_this.list.length==0 || _this.list[_this.selectIndex].is_transfer!=1) return false;
             var orderid=_this.list[_this.selectIndex].orderid;
             _this.$Modal.confirm({
                 title:'还原提示',
                 content:'要还原出库复核单【'+orderid+'】吗？',
                 onOk:function(){
                     _this.common.http({url:'w/backStockOrder',data:{orderid:orderid}}).then(function(res){
                         if(res.status==1){
                             _this.init();
                             _this.$refs.windowTipRef.open({title:"还原提示",content:res.msg,issucess:true,isconfirm:false});
                         }else{
                             _this.$refs.windowTipRef.open({title:"还原提示",content:res.msg,issucess:false,isconfirm:false});
                         }
                     }).catch(function(err){
                         _this.common.httpErr(err.data,_this);
                     });
                 }
             });
          }
      }
  }
</script>
<style>
</style>
