<template>
  <div>
      <Modal v-model="modal" title="选择仓库" :mask-closable="false" class-name="ware-center-modal" width="1000" footer-hide>
          <Table size="small" stripe :columns="columns"  :data="list" border class="table-m" :height="460" row-key="id" :loading="loading"
              :row-class-name="rowClassName" @on-row-click="clickRow" @on-row-dblclick="selectRow">
              <template slot-scope="row" slot="c_name">{{$store.state.depart[row.row.ware_deptid]}}</template>
              <template slot-scope="row" slot="storage_id">
                  <span v-if="JSON.stringify($store.state.sysParam)!='[]'">
                     {{$store.state.sysParam['storage'][row.row.storage_id]}}
                  </span>
              </template>
              <template slot-scope="row" slot="type_id">
                  <span v-if="JSON.stringify($store.state.sysParam)!='[]'">
                    {{$store.state.sysParam['ware_type'][row.row.type_id]}}
                  </span>
              </template>
              <template slot-scope="row" slot="ware_empname">
                  <span v-if="JSON.stringify($store.state.emp)!='[]'">
                      {{$store.state.emp[row.row.ware_empid]}}
                  </span>
              </template>
              <template slot-scope="row" slot="exname">
                  <span v-if="JSON.stringify($store.state.emp)!='[]'">
                    {{$store.state.emp[row.row.ware_examid]}}
                  </span>
              </template>
              <template slot-scope="row" slot="canbyonsale">
                  <Checkbox v-model="row.row.canbyonsale" disabled :true-value="1" :false-value="0"></Checkbox>
              </template>
              <template slot-scope="row" slot="canbyonline">
                  <Checkbox v-model="row.row.canbyonline" disabled :true-value="1" :false-value="0"></Checkbox>
              </template>
              <template slot-scope="row" slot="canvirtual">
                <Checkbox v-model="row.row.canvirtual" disabled :true-value="1" :false-value="0"></Checkbox>
              </template>
          </Table>
          <div class="ware_select">
             <div class="left">
                 <Button @click="confirm" type="primary"><Icon type="md-checkmark"/>确认选定</Button>
                 <Button @click="close" type="warning" style="margin-left:20px;margin-right:30px;"><Icon type="md-close" />取消</Button>
                 <span class="red-text">“红色”表示不可销售，“斜体”标识仓库正在盘点</span>
             </div>
             <div class="right">
                <Button @click="clear" style="margin-left:30px;" v-if="isClear">
                    <Icon type="md-close" />清除选择
                </Button>
             </div>
          </div>
      </Modal>
  </div>
</template>
<script>
    export default {
      name:'chooseWare',
      data(){
         return {
            modal:false,
            columns:[
                {title:'编号',type:'index',width:70,fixed:'left'},
                {title:'仓库编码',key:'ware_code',minWidth:150,fixed:'left',tree:true},
                {title:'仓库名称',key:'ware_title',minWidth:180},
                {title:'所属公司',slot:'c_name',minWidth:220},
                {title:'管理员编码',key:'ware_empid',width:90,align:'center'},
                {title:'管理员姓名',slot:'ware_empname',minWidth:120,align:'center'},
                {title:'验货员编码',key:'ware_examid',width:90,align:'center'},
                {title:'验货员姓名',slot:'exname',minWidth:120,align:'center'},
                {title:'电话',key:'phone',minWidth:180},
                {title:'传真',key:'fax',minWidth:180},
                {title:'所在地区',key:'region',minWidth:180},
                {title:'地址',key:'address',minWidth:250},
                {title:'面积',key:'ware_area',minWidth: 180},
                {title:'存储属性',slot:'storage_id',width:120,align:'center'},
                {title:'仓库类别',slot:'type_id',width: 120,align:'center'},
                {title:'不可销售',slot:'canbyonsale',width:80,align:'center'},
                {title:'不可网购',slot:'canbyonline',width:80,align:'center'},
                {title:'虚拟分级仓',slot:'canvirtual',width:80,align:'center'},
                {title:'备注说明',key:'remark',minWidth:200}
            ],
            list:[],
            loading:false,
            selectData:{}
         }
      },
      props:{
         isClear:{
            type:Boolean,
            default:false
         }
      },
      methods:{
         rowClassName(row,index) {
            var className = '';
            if(row.canbyonsale==0){
               className+=' red-text';
            }
            if(row.haslock){
               className+=' italic-style';
            }
            return className;
         },
         init:function(){
            var _this=this;
            _this.loading=true;
            _this.common.http({url:'ware_list',data:{}}).then(function(res){
                _this.loading=false;
                if(res.status==1){
                   _this.list=res.list;
                }
            }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
            });
         },
         /**
          * 搜索
          */
         doSearch:function(){
            this.init();
         },
         /**
          * 打开选择框
          */
         open:function(){
            this.init();
            this.modal=true;
         },
         close:function(){
            this.modal=false;
         },
         clickRow:function(data){
            this.selectData=data;
         },
         selectRow:function(data){
            this.selectData=data;
            this.confirm();
         },
         /**
          * 确定选中
          */
         confirm:function(){
            if(JSON.stringify(this.selectData)=='{}'){
              return this.alertMsg('请选择仓库','error');
            }
            this.$emit("confirm",this.selectData);
            this.close();
         },
         /**
          * 清除选择
          */
         clear:function(){
            if(!this.isClear) return false;
            this.$emit("clear");
            this.close();
         }
      }
    }
</script>
<style lang="less">
  .ware-center-modal{
      display:flex;
      align-items:center;
      justify-content:center;
      .ivu-modal{top:0;}
  }
  .ware_select{
    padding-top:15px;padding-bottom:10px;overflow:hidden;width:100%;
    .left{
       width:560px;float:left;
       .inputs{
          width:280px;margin-right:20px;display:inline-table;cursor:pointer;
       }
    }
    .right{
       width:380px;float:right;text-align:right;margin-top:5px;
    }
  }
</style>
