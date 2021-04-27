<template>
<div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
                <Button @click="aedit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button @click="aedit(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button @click="check_acc"><span class="icon iconfont">&#xe692;</span>审核</Button>
                <Button @click="del_acc"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
                <Button @click="init"><span class="icon iconfont">&#xe788;</span>刷新</Button>
            </div>
        </div>
        <div slot="table-list">
            <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading" @on-row-click="selectRowIndex" @on-row-dblclick="aedit(1)">
                  <template slot-scope="row" slot="transfer">
                     <span :class="[row.row.transfer?'acc-stock-checked':'acc-stock-no']">{{row.row.transfer?'已审核':'未审核'}}</span>
                  </template>
            </Table>
        </div>
    </split-none>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    export default {
        components:{splitNone},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'库存盘点'},{title:'实物盘点单'}],
              height:0,
              columns:[
                  {title:'单据编号',key:'bill_no',minWidth:160},
                  {title:'盘点时间',key:'f_date',minWidth:130},
                  {title:'盘点仓库编号',key:'ware_code',minWidth:90},
                  {title:'仓库名称',key:'ware_title',minWidth:100},
                  {title:'经手人',key:'empno',minWidth:90},
                  {title:'审核者',key:'auditno',minWidth:90},
                  {title:'是否审核',slot:'transfer',minWidth:90,align:'center'},
                  {title:'备注',key:'remark',minWidth:150},
                  {title:'创建人',key:'creater',minWidth:90},
                  {title:'创建时间',key:'create_date',minWidth:130},
                  {title:'修改人',key:'mender',minWidth:90},
                  {title:'修改时间',key:'update_date',minWidth:130},
                  {title:'资源所属部门',key:'dept_name',minWidth:90}
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
        activated:function(){
            _this.init();
        },
        methods:{
            DHeight(e){
                this.height = e;
            },
          /**
           * 设置高亮
           */
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
                _this.common.http({url:'w/realstock',data:{}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.data;
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
            /**
             * 单击选择某一行
             */
            selectRowIndex:function(data,index){
               _this.selectIndex=index;
            },
            /**
             * 新增/修改
             */
            aedit:function(isedit){
              if(isedit){
                if(this.list.length==0) return false;
                localStorage.setItem('realstock_editid',this.list[this.selectIndex].bill_no);
                this.toUrl('edit_realstock');
              }else{
                localStorage.setItem('realstock_editid','');
                this.toUrl('edit_realstock');
              }
            },
          /**
           * 审核
           */
          check_acc:function (){
            if(this.list.length==0) return false;
            var bill_no=this.list[this.selectIndex].bill_no,transfer=this.list[this.selectIndex].transfer;
            if(transfer){
              this.alertMsg('已审核的实物盘点单不能重复审核','error');
              return false;
            }
            _this.$Modal.confirm({
              title:'提示',
              content:'确定审核吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/checkReal',data:{bill_no:bill_no}}).then(function(res){
                  _this.$Spin.hide();
                  if(res.status==1){
                    _this.init();
                    _this.alertMsg(res.msg);
                  }else{
                    _this.alertMsg(res.msg,'error',{duration:6,isClosable:true});
                  }
                }).catch(function(err){
                  _this.$Spin.hide();
                  _this.common.httpErr(err.data,_this);
                });
              }
            });
          },
          /**
           * 删除实物盘点单
           */
          del_acc:function (){
            if(this.list.length==0) return false;
            var bill_no=this.list[this.selectIndex].bill_no,transfer=this.list[this.selectIndex].transfer;
            if(transfer){
              this.alertMsg('已审核的实物盘点单不能删除','error');
              return false;
            }
            _this.$Modal.confirm({
              title:'提示',
              content:'确定删除吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/delRealstock',data:{bill_no:bill_no}}).then(function(res){
                  _this.$Spin.hide();
                  if(res.status==1){
                    _this.init();
                    _this.alertMsg(res.msg);
                  }else{
                    _this.alertMsg(res.msg,'error');
                  }
                }).catch(function(err){
                  _this.$Spin.hide();
                  _this.common.httpErr(err.data,_this);
                });
              }
            });
          }
        }
    }
</script>
<style>
.acc-stock-checked{display: inline-block; height: 18px; padding: 0 10px; line-height: 18px; color: #52c41a; background-color: rgba(82, 196, 26, 0.15);}
.acc-stock-no{display: inline-block; height: 18px; padding: 0 10px; line-height: 18px; color: #FAAD14; background-color: rgba(250, 173, 20, 0.15);}
</style>
