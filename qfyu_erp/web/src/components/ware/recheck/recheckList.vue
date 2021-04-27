<template>
<div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
                <Button @click="editRecheck">
                    <span class="icon iconfont">&#xe791;</span>修改
                </Button>
                <Divider type="vertical"/>
                <Button @click="checkRecheckOrder" :disabled="list[selectIndex].ischeck==1 || list[selectIndex].isclose==1">
                    <span class="icon iconfont">&#xe692;</span>审核
                </Button>
                <Button @click="backRecheckOrder" :disabled="list[selectIndex].ischeck!=1 || list[selectIndex].isclose==1">
                    <span class="icon iconfont">&#xe692;</span>还原
                </Button>
                <Button @click="closeRecheckOrder">
                    <span class="icon iconfont">&#xe69e;</span>结案
                </Button>
                <Divider type="vertical"/>
                <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
            </div>
        </div>
        <div slot="table-list">
            <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading"
                @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                  <template slot-scope="row" slot="ischeck">
                     <Checkbox v-model="row.row.ischeck" :true-value="1" :false-value="0" disabled></Checkbox>
                  </template>
                  <template slot-scope="row" slot="isclose">
                     <Checkbox v-model="row.row.isclose" :true-value="1" :false-value="0" disabled></Checkbox>
                  </template>
                  <template slot-scope="row" slot="fungible">
                     <Checkbox v-model="row.row.fungible" :true-value="1" :false-value="0" disabled></Checkbox>
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
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'验收入库(复核)'}],
              height:0,
              columns:[
                  {title:'编号',type:'index',width:70,fixed:'left',align:'center'},
                  {title:'单据编号',key:'orderid',fixed:'left',width:160,align:'center'},
                  {title:'单据日期',key:'order_date',width:150,align:'center'},
                  {title:'供应商编码',key:'sup_code',width:90,align:'center'},
                  {title:'供应商名称',key:'sup_name',minWidth:200},
                  {title:'收货单号',key:'reforderid',width:160,align:'center'},
                  {title:'货品总数',key:'goodsqty',minWidth:120,align:'center'},
                  {title:'货款',key:'goodssum',minWidth:120,align:'center'},
                  {title:'税款',key:'taxsum',minWidth:120,align:'center'},
                  {title:'合计总额',key:'amount',minWidth:120,align:'center'},
                  {title:'验货员',key:'emp_no',width:90,align:'center'},
                  {title:'验货员姓名',key:'emp_name',minWidth:140,align:'center'},
                  {title:'供方销售人',key:'sup_sell',minWidth:120,align:'center'},
                  {title:'供方联系人',key:'sup_contact',minWidth:120,align:'center'},
                  {title:'过账',slot:'ischeck',width:60,align:'center'},
                  {title:'结案',slot:'isclose',width:60,align:'center'},
                  {title:'是否代销收货',slot:'fungible',width:100,align:'center'},
                  {title:'业务员',key:'sales_code',width:90,align:'center'},
                  {title:'业务员姓名',key:'sales_name',minWidth:120,align:'center'},
                  {title:'结算方式',key:'settlement_name',width:90,align:'center'},
                  {title:'备注说明',key:'remark',minWidth:300},
                  {title:'复核员',key:'check_code',width:90,align:'center'},
                  {title:'复核员姓名',key:'check_name',minWidth:140,align:'center'},
                  {title:'创建者',key:'creator',width:90,align:'center'},
                  {title:'创建时间',key:'create_date',width:140,align:'center'},
                  {title:'开单部门',key:'o_deptname',width:140,align:'center'}
              ],
              list:[],
              loading:false,
              selectIndex:0,
              page:1,
              pageSize:10,
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
            DHeight(e){
                this.height = e;
            },
            rowClassName(row,index) {
                var className='';
                if(index===_this.selectIndex){
                    className+='ivu-table-row-highlight';
                }
                return className;
            },
            /**
             * 初始化数据
             */
            init:function(){
                _this.loading=true;
                _this.common.http({url:'w/stockReceiveList',data:{page:_this.page,pageSize:_this.pageSize,search:_this.search}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.list.data;
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
            /**
             * 点击、双击选择列表
             * @param {Object} index
             * @param {Object} type
             */
            selectRowIndex:function(index,type){
               _this.selectIndex=index;
               if(type) _this.editRecheck();
            },
            /**
             * 修改
             */
            editRecheck:function(){
               if(_this.selectIndex<0){
                  return _this.alertMsg('请至少选择一行后操作','error');
               }
               var orderid=_this.list[_this.selectIndex].orderid;
               localStorage.setItem("recheck_orderid",orderid);
               _this.toUrl("/editReCheck");
            },
            /**
             * 刷新
             */
            Refresh:function(){
                _this.init();
            },
            /*****************常用操作按钮***************/
            /**
             * 审核
             */
            checkRecheckOrder:function(){
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var isclose=_this.list[_this.selectIndex].isclose;
              if(parseInt(ischeck)==1){
                 return _this.alertMsg('复核单据已审核，请务重复审核','error');
              }
              if(parseInt(isclose)==1){
                 return _this.alertMsg('复核单据已结案，不能进行审核','error');
              }
              var orderid=_this.list[_this.selectIndex].orderid;
              _this.$Modal.confirm({
                  title:'审核提示',
                  content:'确定审核订单【'+orderid+'】入库吗？',
                  onOk:function(){
                      _this.common.http({url:'w/checkStockReceive',data:{orderid:orderid}}).then(function(res){
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
            backRecheckOrder:function(){
              var ischeck=_this.list[_this.selectIndex].ischeck;
              var isclose=_this.list[_this.selectIndex].isclose;
              if(parseInt(isclose)==1){
                 return _this.alertMsg('复核单据已结案，不能进行还原','error');
              }
              if(parseInt(ischeck)!=1){
                 return _this.alertMsg('复核单据未审核，不能进行还原','error');
              }
              var orderid=_this.list[_this.selectIndex].orderid;
              _this.$Modal.confirm({
                  title:'还原提示',
                  content:'确定还原入库复核单【'+orderid+'】吗？还原后已入库商品库存会自动撤销',
                  onOk:function(){
                      _this.common.http({url:'w/backStockReceive',data:{orderid:orderid}}).then(function(res){
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
            },
            /**
             * 结案
             */
            closeRecheckOrder:function(){
                var orderid=_this.list[_this.selectIndex].orderid;
                var txt=_this.list[_this.selectIndex].isclose==1?'返结案':'结案';
                _this.$Modal.confirm({
                    title:'结案提示',
                    content:'确定'+txt+'入库单【'+orderid+'】吗？',
                    onOk:function(){
                        _this.common.http({url:'w/closeStockReceive',data:{orderid:orderid}}).then(function(res){
                            if(res.status==1){
                                _this.init();
                            }else{
                                _this.$refs.windowTipRef.open({title:"结案提示",content:res.msg,issucess:false,isconfirm:false});
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
