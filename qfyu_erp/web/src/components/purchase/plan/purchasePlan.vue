<template>
<div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
              <Button @click="addPurPlan(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
              <Button @click="addPurPlan(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
              <Button @click="delPlanOrder" v-if="planlist.length>0" :disabled="planlist[selectIndex].ischeck==1">
                <span class="icon iconfont">&#xe6a5;</span>删除
              </Button>
              <Divider type="vertical"/>
              <Button @click="checkPlanOrder" v-if="planlist.length>0" :disabled="planlist[selectIndex].ischeck==1">
                  <span class="icon iconfont">&#xe692;</span>审核
              </Button>
              <Button @click="closePlanOrder"><span class="icon iconfont">&#xe69e;</span>结案</Button>
              <Button @click="generateOrder" v-if="planlist.length>0" :disabled="planlist[selectIndex].ischeck!=1 || planlist[selectIndex].isclose==1">
                  <span class="icon iconfont">&#xe6a3;</span>生成订单
              </Button>
              <Divider type="vertical"/>
              <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
              <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
            </div>
        </div>
        <div slot="table-list">
            <Table ref="planListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="planlist" border class="table-m" :height="height" :loading="loadding"
                @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                <template slot-scope="row" slot="typeid">{{typelist[row.row.typeid]}}</template>
                <template slot-scope="row" slot="ischeck">
                    <Checkbox v-model="row.row.ischeck" :true-value="1" :false-value="0" disabled></Checkbox>
                </template>
                <template slot-scope="row" slot="isclose">
                    <Checkbox v-model="row.row.isclose" :true-value="1" :false-value="0" disabled></Checkbox>
                </template>
            </Table>
        </div>
    </split-none>
    <!-- 消息提示 -->
    <window-tip ref="windowTipRef"></window-tip>
</div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import windowTip from '@/components/common/WindowTip'
  var _this;
  export default {
      components:{splitNone,windowTip},
      data () {
          return {
            Breadcrumb:[{title:'采购管理'},{title:'采购计划'}],
            height:0,
            loadding:false,
            columns:[
               {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
               {title:'单据号',key:'orderid',width:160,fixed:'left',align:'center'},
               {title:'编制日期',key:'prepared_date',width:100,align:'center'},
               {title:'失效日期',key:'invalid_date',width:100,align:'center'},
               {title:'计划类型',slot:'typeid',width:100,align:'center'},
               {title:'员工编号',key:'prepared_code',width:90,align:'center'},
               {title:'员工姓名',key:'prepared_name',minWidth:100,align:'center'},
               {title:'审核人',key:'check_code',width:90,align:'center'},
               {title:'审核人姓名',key:'check_name',minWidth:100,align:'center'},
               {title:'过账',slot:'ischeck',width:90,align:'center'},
               {title:'完成结案',slot:'isclose',width:90,align:'center'},
               {title:'货品总数',key:'nums',minWidth:90,align:'center'},
               {title:'货品总金额',key:'account',minWidth:100,align:'center'},
               {title:'创建者',key:'creator',width:90,align:'center'},
               {title:'开单人',key:'create_name',minWidth:100,align:'center'},
               {title:'所属部门',key:'id',width:100},
               {title:'备注说明',key:'remark',minWidth:250,ellipsis:true}
            ],
            planlist:[],
            selectIndex:0,
            typelist:[]
          }
      },
      created:function(){
          _this=this;
          _this.init();
      },
      methods:{
          rowClassName(row, index) {
              if (index === this.selectIndex) {
                  return 'ivu-table-row-highlight';
              }
              return '';
          },
          DHeight(e){
              this.height = e;
          },
          init:function(){
              _this.common.http({url:'planList',data:{}}).then(function(res){
                 if(res.status==1){
                    _this.typelist=res.typelist;
                    _this.planlist=res.list.data;
                 }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
          },
          selectRowIndex:function(index,type){
              _this.selectIndex=index;
              //判断是否双击编辑
              if(type) _this.addPurPlan(true);
          },
          /**
           * 新增、修改采购计划单
           */
          addPurPlan:function(type){
              var orderid="";
              if(type){
                  if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
                  orderid=_this.planlist[_this.selectIndex].orderid;
              }
              localStorage.setItem("plan_orderid",orderid);
              _this.toUrl("/editPurPlan");
          },
          /*********按钮功能操作*********/
          /**
           *  删除
           */
          delPlanOrder:function(){
              var ischeck=_this.planlist[_this.selectIndex].ischeck;
              if(ischeck==1){
                 return _this.alertMsg('单据已被审核，不能再进行删除','error');
              }
              var orderid=_this.planlist[_this.selectIndex].orderid;
              _this.$Modal.confirm({
                  title:'删除提示',
                  content:'确定要删除订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'deletePlanOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                              _this.planlist.splice(_this.selectIndex,1);
                              _this.alertMsg("删除已成功");
                          }else{
                              _this.$refs.windowTipRef.open({title:"删除提示",content:res.msg,issucess:false,isconfirm:false});
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
          checkPlanOrder:function(){
              var ischeck=_this.planlist[_this.selectIndex].ischeck;
              if(ischeck==1) return false;
              var orderid=_this.planlist[_this.selectIndex].orderid;
              _this.$Modal.confirm({
                  title:'审核提示',
                  content:'确定要审核订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'checkPlanOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                              _this.planlist[_this.selectIndex].ischeck=1;
                              _this.planlist[_this.selectIndex].check_code=res.check.code;
                              _this.planlist[_this.selectIndex].check_name=res.check.name;
                              _this.alertMsg("审核处理成功");
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
           * 结案
           */
          closePlanOrder:function(){
              var orderid=_this.planlist[_this.selectIndex].orderid;
              _this.common.http({url:'closePlanOrder',data:{orderid:orderid}}).then(function(res){
                  if(res.status==1){
                      _this.planlist[_this.selectIndex].isclose=res.isclose;
                      _this.$refs.planListRef.clearCurrentRow();
                  }else{
                      _this.alertMsg(res.msg,'error');
                  }
              }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 生成订单（采购订单）
           */
          generateOrder:function(){
              var isclose=_this.planlist[_this.selectIndex].isclose;
              var ischeck=_this.planlist[_this.selectIndex].ischeck;
              if(ischeck!=1 || isclose==1){
                  return _this.alertMsg("单据未审核或已结案，不能再生成采购订单！",'error');
              }
              var orderid=_this.planlist[_this.selectIndex].orderid;
              _this.$Modal.confirm({
                  title:'还原提示',
                  content:'确定要生成采购订单吗？',
                  onOk:function(){
                       _this.common.http({url:'generateOrder',data:{orderid:orderid}}).then(function(res){
                           if(res.status==1){
                               var content="<p>已成功生成以下采购订单：</p>";
                               res.olist.forEach(function(v){content+="<p>"+v+"</p>";});
                               content+='<br/><p>确定要查看这些单据吗？</p>';
                               _this.$refs.windowTipRef.open({
                                      title:"转单提示",
                                      content:content,
                                      issucess:true,
                                      isconfirm:true
                               },"/editPurOrder?orderid="+res.olist[0]);
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
