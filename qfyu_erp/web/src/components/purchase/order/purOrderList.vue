<template>
 <div>
     <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
         <div slot="form-ser">
             <div class="nav-menu">
               <Button @click="addPurOrder(false)">
                 <span class="icon iconfont">&#xe797;</span>创建
               </Button>
               <Button  @click="addPurOrder(true)">
                 <span class="icon iconfont">&#xe791;</span>修改
               </Button>
               <Button @click="deletePurOrder" :disabled="list[selectIndex].ischeck==1" v-if="list.length>0">
                  <span class="icon iconfont">&#xe6a5;</span>删除
               </Button>
               <Divider type="vertical"/>
               <Button @click="checkPurOrder" :disabled="list[selectIndex].ischeck==1" v-if="list.length>0">
                  <span class="icon iconfont">&#xe692;</span>审核
               </Button>
               <Button @click="backPurOrder" :disabled="list[selectIndex].ischeck!=1 || list[selectIndex].istrans==1 || list[selectIndex].ispay==1" v-if="list.length>0">
                  <span class="icon iconfont">&#xe692;</span>还原
               </Button>
               <Button @click="closePurOrder" :disabled="list[selectIndex].ischeck!=1 || list[selectIndex].isclose==1" v-if="list.length>0">
                  <span class="icon iconfont">&#xe692;</span>结案
               </Button>
               <Button @click="generateRegisterOrder" :disabled="list[selectIndex].ischeck!=1 || list[selectIndex].isclose==1" v-if="list.length>0">
                 <span class="icon iconfont">&#xe692;</span>转单
               </Button>
               <Divider type="vertical"/>
               <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
               <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
               <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
             </div>
         </div>
         <div slot="table-list">
             <Table ref="purOrderListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loadding"
                 @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                 @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                 <template slot-scope="row" slot="ischeck">
                      <Checkbox v-model="row.row.ischeck" :true-value="1" :false-value="0" disabled></Checkbox>
                 </template>
                 <template slot-scope="row" slot="isclose">
                      <Checkbox v-model="row.row.isclose" :true-value="1" :false-value="0" disabled></Checkbox>
                 </template>
                 <template slot-scope="row" slot="check_name">
                    <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.check_code]}}</span>
                 </template>
                 <template slot-scope="row" slot="settle_type">
                    <span v-if="JSON.stringify($store.state.settlement)!='[]'">{{$store.state.settlement[row.row.settle_type]}}</span>
                 </template>
                 <template slot-scope="row" slot="create_name">
                    <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.creator]}}</span>
                 </template>
                 <template slot-scope="row" slot="create_deptname">
                    <span v-if="JSON.stringify($store.state.depart)!='[]'">{{$store.state.depart[row.row.dept_id]}}</span>
                 </template>
             </Table>
         </div>
     </split-none>
     <!-- 弹出操作提示 -->
     <window-tip ref="windowTipRef"></window-tip>
 </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import windowTip from '@/components/common/WindowTip'
  var _this=this;
  export default {
      components:{splitNone,windowTip},
      data(){
        return {
           height:0,
           Breadcrumb:[{title:'采购管理'},{title:'采购订单'}],
           columns:[
              {title:'编号',type:'index',key:'index',width:70,fixed:'left',align:'center'},
              {title:'单据编号',key:'orderid',fixed:'left',width:160,align:'center'},
              {title:'订单日期',key:'create_date',width:130,align:'center'},
              {title:'到货日期',key:'delivery_date',width:100,align:'center'},
              {title:'生效日期',key:'effectivity_date',width:100,align:'center'},
              {title:'失效日期',key:'invalid_date',width:100,align:'center'},
              {title:'供应商编号',key:'sup_code',width:90,align:'center'},
              {title:'供应商名称',key:'full_name',minWidth:200,resizable:true,ellipsis:true},
              {title:'供方销售人',key:'sup_sell',width:100,align:'center'},
              {title:'联系人',key:'sup_contact',width:100,align:'center'},
              {title:'供方部门',key:'dept_name',width:100,align:'center'},
              {title:'业务员',key:'sales_code',width:80,align:'center'},
              {title:'业务员姓名',key:'sales_name',width:100,align:'center'},
              {title:'复核员',key:'check_code',width:80,align:'center'},
              {title:'审核员姓名',slot:'check_name',width:100,align:'center'},
              {title:'运输方式',key:'transport_type',width:160,resizable:true,ellipsis:true},
              {title:'运输到站',key:'transport_area',width:160,resizable:true,ellipsis:true},
              {title:'交货方式',key:'delivery_type',width:160,resizable:true,ellipsis:true},
              {title:'货品总数',key:'nums',width:100,align:'center'},
              {title:'无税金额',key:'payment',width:100,align:'center'},
              {title:'税款',key:'tax_total',width:100,align:'center'},
              {title:'合计',key:'total',width:100,align:'center'},
              {title:'合同号',key:'contract_code',width:160,align:'center'},
              {title:'结算方式',slot:'settle_type',width:120,align:'center'},
              {title:'付款日期',key:'pay_date',width:100,align:'center'},
              {title:'过账',slot:'ischeck',width:80,align:'center'},
              {title:'完成结案',slot:'isclose',width:80,align:'center'},
              {title:'创建者',key:'creator',width:90,align:'center'},
              {title:'开单人姓名',slot:'create_name',width:100,align:'center'},
              {title:'开单部门',key:'dept_id',width:80,align:'center'},
              {title:'部门名称',slot:'create_deptname',minWidth:120,resizable:true,ellipsis:true},
              {title:'备注',key:'remark',minWidth:220,resizable:true,ellipsis:true}
           ],
           list:[],
           loadding:false,
           selectIndex:0,
           search:{},
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
          Refresh:function(){
             _this.init();
          },
          /**
           * 初始化数据
           */
          init:function(){
              _this.loadding=true;
              _this.common.http({url:'purOrderList',data:{page:_this.page,pageSize:_this.pageSize,search:_this.search}}).then(function(res){
                  _this.loadding=false;
                  if(res.status==1){
                    _this.list=res.list.data;
                  }
              }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 列表单击、双击事件
           * @param index 索引
           * @param type true:双击修改
           */
          selectRowIndex:function(index,type){
              _this.selectIndex=index;
              if(type) _this.addPurOrder(true);
          },
          /**
           * 新增、修改
           * @param type true:修改
           */
          addPurOrder:function(type){
              var orderid="";
              if(type){
                  if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
                  orderid=_this.list[_this.selectIndex].orderid;
              }
              localStorage.setItem("pch_orderId",orderid);
              _this.toUrl("/editPurOrder");
          },
          /**
           * 删除
           */
          deletePurOrder:function(){
              if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck==1){
                  return _this.alertMsg('采购订单【'+orderid+'】已审核，不能进行删除','error');
              }
              _this.$Modal.confirm({
                  title:'删除提示',
                  content:'确定删除采购订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'deletePurOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                              _this.page=1;
                              _this.init();
                              _this.alertMsg('删除已成功');
                          }else{
                              _this.alertMsg(res.msg,'error');
                          }
                      }).catch(function(err){
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 审核
           */
          checkPurOrder:function(){
              if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck==1) return false;
              _this.$Modal.confirm({
                  title:'审核提示',
                  content:'确定审核采购订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'checkPurOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                              _this.list[_this.selectIndex].ischeck=1;
                              _this.list[_this.selectIndex].check_code=res.check.code;
                              _this.list[_this.selectIndex].check_name=res.check.name;
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
          backPurOrder:function(){
              if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var istrans=_this.list[_this.selectIndex].istrans;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck!=1){
                  return _this.alertMsg("该采购订单未审核，不能进行还原",'error');
              }
              if(istrans==1){
                 return _this.alertMsg("该采购订单已生成过来货登记单，不能进行还原",'error');
              }
              _this.common.http({url:'backPurOrder',data:{orderid:orderid}}).then(function(res){
                  var issucess=true;
                  if(res.status==1){
                      _this.list[_this.selectIndex].ischeck=0;
                  }else issucess=false;
                  _this.$refs.windowTipRef.open({title:"还原提示",content:res.msg,issucess:issucess,isconfirm:false});
              }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 结案
           */
          closePurOrder:function(){
              if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var isclose=_this.list[_this.selectIndex].isclose;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(isclose==1){
                  return _this.alertMsg("该采购订单已结案，不能进行结案",'error');
              }
              if(ischeck!=1){
                  return _this.alertMsg("该采购订单尚未审核，不能结案。您可以选择删除来作废此单！",'error');
              }
              _this.$Modal.confirm({
                 title:'操作提示',
                 content:'确定结案采购订单【'+orderid+'】吗？一旦结案该订单将不能进行转单操作！',
                 onOk:function(){
                     _this.common.http({url:'closePurOrder',data:{orderid:orderid}}).then(function(res){
                         var issucess=true;
                         if(res.status==1){
                             _this.list[_this.selectIndex].isclose=1;
                         }else issucess=false;
                         _this.$refs.windowTipRef.open({title:"操作提示",content:res.msg,issucess:issucess,isconfirm:false});
                     }).catch(function(err){
                         _this.common.httpErr(err.data,_this);
                     });
                 }
              });
          },
          /**
           * 转单（转来货登记单）
           */
          generateRegisterOrder:function(){
              if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var isclose=_this.list[_this.selectIndex].isclose;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck!=1){
                  return _this.alertMsg("该采购订单未审核，不能进行转单",'error');
              }
              if(isclose==1){
                  return _this.alertMsg("该采购订单已结案，不能进行转单",'error');
              }
              _this.$Modal.confirm({
                 title:'转单提示',
                 content:'确定要将采购订单【'+orderid+'】转为来货登记单吗？',
                 onOk:function(){
                     _this.common.http({url:'generateRegOrder',data:{orderid:orderid}}).then(function(res){
                         if(res.status==1){
                             _this.list[_this.selectIndex].istrans=1;
                             var content="<p>采购订单【"+orderid+"】已成功转出到【"+res.orderid+"】来货登记单!</p>";
                             content+='<br/><p>确定要查看该单据吗？</p>';
                             _this.$refs.windowTipRef.open({
                                    title:"转单提示",
                                    content:content,
                                    issucess:true,
                                    isconfirm:true
                             },"/registerEdit",function(){
                                localStorage.setItem("edit_register_orderid",res.orderid);
                             });
                         }else{
                             _this.$refs.windowTipRef.open({title:"转单提示",content:res.msg,issucess:false,isconfirm:false});
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
