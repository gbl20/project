<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                  <Button @click="addPurLack(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                  <Button @click="addPurLack(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                  <Button @click="delPurLack" :disabled="selectIndex<0 || list[selectIndex].ischeck==1 || list[selectIndex].istrans==1">
                      <span class="icon iconfont">&#xe6a5;</span>删除
                  </Button>
                  <Divider type="vertical"/>
                  <Button @click="checkPurLack" :disabled="selectIndex<0 || list[selectIndex].ischeck==1">
                      <span class="icon iconfont">&#xe692;</span>审核
                  </Button>
                  <Button @click="backPurLack" :disabled="selectIndex<0 || list[selectIndex].ischeck!=1 || list[selectIndex].istrans==1">
                      <span class="icon iconfont">&#xe693;</span>还原
                  </Button>
                  <Button @click="transPlanOrder" :disabled="selectIndex<0 || list[selectIndex].ischeck!=1">
                      <span class="icon iconfont">&#xe6a3;</span>转单
                  </Button>
                  <Divider type="vertical"/>
                  <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                  <Button @click="searchList"><span class="icon iconfont">&#xe691;</span>筛选</Button>
              </div>
          </div>
          <div slot="table-list">
              <Table ref="lackListRef" size="small" stripe :columns="columns" :data="list" border class="table-m" :height="height" :highlight-row="true" :loading="loading"
                  @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                  @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                  <template slot-scope="row" slot="ischeck">
                      <Checkbox v-model="row.row.ischeck" :true-value="1" :false-value="0" disabled></Checkbox>
                  </template>
                  <template slot-scope="row" slot="istrans">
                      <Checkbox v-model="row.row.istrans" :true-value="1" :false-value="0" disabled></Checkbox>
                  </template>
              </Table>
          </div>
      </split-none>
      <!-- 弹出操作提示 -->
      <window-tip ref="windowTipRef"></window-tip>
      <!-- 搜索功能 -->
      <Drawer title="筛选条件" :closable="true" v-model="searchModal" :width="400">

      </Drawer>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import windowTip from '@/components/common/WindowTip'
  var _this;
  export default {
      components:{splitNone,windowTip},
      data(){
         return {
            height:0,
            Breadcrumb:[{title:'采购管理'},{title:'缺货登记'}],
            loading:false,
            columns:[
                {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
                {title:'单据号',key:'orderid',width:160,fixed:'left',align:'center'},
                {title:'登记日期',key:'register_date',width:100,align:'center'},
                {title:'有效期至',key:'validity_date',width:100,align:'center'},
                {title:'缺货品种数',key:'nums',width:100,align:'center'},
                {title:'缺货总数量',key:'total',minWidth:100,align:'center'},
                {title:'审核状态',slot:'ischeck',width:100,align:'center'},
                {title:'是否转单',slot:'istrans',width:100,align:'center'},
                {title:'业务员编号',key:'emp_code',width:100,align:'center'},
                {title:'业务员姓名',key:'emp_name',width:120,align:'center'},
                {title:'资源所属部门',key:'dept_name',minWidth:120},
                {title:'创建者',key:'creator',width:100,align:'center'},
                {title:'创建时间',key:'create_date',width:150,align:'center'},
                {title:'备注说明',key:'remark',minWidth:220}
            ],
            list:[],
            selectIndex:-1,
            //筛选功能
            searchModal:false,


         }
      },
      created:function(){
          _this=this;
          _this.init();
      },
      methods:{
          DHeight:function(e){
            _this.height=e;
          },
          init:function(){
              _this.loading=true;
              _this.common.http({url:'lackList',data:{}}).then(function(res){
                  _this.loading=false;
                  if(res.status==1){
                     _this.list=res.list;
                     _this.list[_this.selectIndex]._highlight=true;
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 表格双击或单击事件
           */
          selectRowIndex:function(index,type){
              _this.selectIndex=index;
              if(type) _this.addPurLack(true);
          },
          /**
           * 添加、修改缺货登记
           */
          addPurLack:function(type){
              var orderid="";
              if(type){
                  if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
                  orderid=_this.list[_this.selectIndex].orderid;
              }
              localStorage.setItem("lack_orderid",orderid);
              _this.toUrl("/editPurLack");
          },
          /**********按钮操作*********/
          /**
           * 删除
           */
          delPurLack:function(){
              if(_this.selectIndex<0){
                 _this.alertMsg("请至少选择一项后操作",'error');
                 return false;
              }
              var istrans=_this.list[_this.selectIndex].istrans;
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck==1 || istrans==1){
                  _this.alertMsg("单据已审核或已转单，不能进行删除",'error');
                  return false;
              }
              _this.$Modal.confirm({
                  title:'删除提示',
                  content:'确定要删除订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'deleteLackOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                             _this.init();
                             _this.alertMsg("删除已成功");
                          }else{
                             _this.alertMsg(res.msg,'error');
                          }
                      }).catch(function(err) {
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 审核
           */
          checkPurLack:function(){
              if(_this.selectIndex<0){
                 _this.alertMsg("请至少选择一项后操作",'error');
                 return false;
              }
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck==1) return false;
              _this.$Modal.confirm({
                  title:'审核提示',
                  content:'确定要审核订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'checkLackOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                             _this.init();
                             _this.alertMsg("审核处理已成功");
                          }else{
                             _this.alertMsg(res.msg,'error');
                          }
                      }).catch(function(err) {
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 还原
           */
          backPurLack:function(){
              if(_this.selectIndex<0){
                 _this.alertMsg("请至少选择一项后操作",'error');
                 return false;
              }
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck!=1) return false;
              _this.$Modal.confirm({
                  title:'还原提示',
                  content:'确定要还原订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'resetLackOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                             _this.init();
                             _this.alertMsg("还原处理已成功");
                          }else{
                             _this.alertMsg(res.msg,'error');
                          }
                      }).catch(function(err) {
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 转单（转采购计划单）
           */
          transPlanOrder:function(){
              if(_this.selectIndex<0){
                 _this.alertMsg("请至少选择一项后操作",'error');
                 return false;
              }
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var orderid=_this.list[_this.selectIndex].orderid;
              if(ischeck!=1){
                  _this.alertMsg("未审核订单，不能转单操作",'error')
                  return false;
              }
              _this.$Modal.confirm({
                  title:'转单提示',
                  content:'确定要将订单【'+orderid+'】转为采购计划单吗？',
                  onOk:function(){
                      _this.common.http({url:'transPlanOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                             _this.list[_this.selectIndex].istrans=1;
                             var content="<p>采购订单【"+orderid+"】已成功转出到【"+res.orderid+"】采购计划单!</p>";
                             content+='<br/><p>确定要查看该单据吗？</p>';
                             _this.$refs.windowTipRef.open({
                                    title:"转单提示",
                                    content:content,
                                    issucess:true,
                                    isconfirm:true
                             },"/editPurPlan",function(){
                                localStorage.setItem("plan_orderid",res.orderid);
                             });
                          }else{
                             _this.$refs.windowTipRef.open({title:"操作提示",content:res.msg,issucess:false,isconfirm:false});
                          }
                      }).catch(function(err) {
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 打印
           */
          printPurLack:function(){

          },
          /**
           * 筛选
           */
          searchList:function(){
             _this.searchModal=true;
          }
      }
  }
</script>
<style>

</style>
