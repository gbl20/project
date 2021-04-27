<template>
<div>
    <Modal v-model="modal" title="选择供应商" :mask-closable="false" width="1000" class-name="vertical-center-modal" footer-hide>
         <Table size="small" stripe :columns="columns" :data="list" border class="table-m" :height="455" :loading="loading" :highlight-row="true" @on-row-click="(row,index)=>{selectRow(index,false)}" @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
            <template slot-scope="{row}" slot="pause">
                <Checkbox :value="row.pause" :true-value="1" :false-value="0" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="business_leader">
                {{$store.state.emp[row.business_leader]}}
            </template>
            <template slot-scope="{row}" slot="audit_status">
                {{row.audit_status==1?'已审核':'未审核'}}
            </template>
            <template slot-scope="{ row }" slot="pay_mode_no">
              <div class="over-ellipsis">{{$store.state.settlement[row.pay_mode_no]}}</div>
            </template>
            <template slot-scope="{ row }" slot="abckind">
              <div class="over-ellipsis" v-if="JSON.stringify($store.state.sysParam) != '[]'">{{$store.state.sysParam['abc_type'][row.abckind]}}</div>
            </template>
         </Table>
         <div class="providers_page">
            <Page class="right" :total="total" size="small" :page-size="pageSize" @on-change="changePage"/>
            <div class="left">
                <Input v-model="search.supplier_code" placeholder="供应商编号/名称/详细地址" class="inputs" maxlength="300">
                    <span slot="prepend">查找:</span>
                    <Button @click="doSearch" slot="append" icon="ios-search"></Button>
                </Input>
                <Button @click="confirm" type="primary">
                   <Icon type="md-checkmark"/>选定
                </Button>
                <Button @click="close" type="warning" style="margin-left:10px;">
                   <Icon type="md-close" />取消
                </Button>
            </div>
         </div>
    </Modal>
</div>
</template>
<script>
  var searchform={supplier_code:''};
  export default {
     data(){
        return {
           modal:false,
           columns:[
              {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
              {title:'供应商编号',key:'supplier_code',width:100,fixed:'left'},
              {title:'供应商全称',key:'full_name',minWidth:150,fixed:'left'},
              {title:'供应商简称',key:'name',minWidth:150},
              {title:'企业类型',key:'enterprise_type',minWidth:120},
              {title:'结算方式',slot:'pay_mode_no',width:120,align:'center'},
              {title:'地区',key:'area',minWidth:150},
              {title:'详细地址',key:'address',minWidth:150},
              {title:'业务负责人',slot:'business_leader',minWidth:150},
              {title:'备注',key:'remark',minWidth:150},
              {title:'暂停往来',slot:'pause',width:100,align:'center'},
              {title:'审核',slot:'audit_status',width:100,align:'center'},
              {title:'ABC分类',key:'abckind',width:100,align:'center'}
           ],
           loading:false,
           list:[],
           selectIndex:-1,
           search:JSON.parse(JSON.stringify(searchform)),
           page:1,
           total:0,
           pageSize:10
        }
     },
     methods:{
        init:function(){
           var _this=this;
           _this.loading=true;
           var data={page:_this.page,pageSize:_this.pageSize,search:_this.search};
           _this.common.http({url:'chooseProvider',data:data}).then(function(res){
               _this.loading=false;
               if(res.status==1){
                   _this.total=res.list.total;
                   _this.list=res.list.data;
               }
           }).catch(function(err){
                _this.common.httpErr(err.data,_this);
           });
        },
        changePage:function(page){
            this.page=page;
            this.init();
        },
        changePageSize:function(pageSize){
            this.page=1;
            this.pageSize=pageSize;
            this.init();
        },
        doSearch:function(){
           this.page=1;
           this.selectIndex=-1;
           this.init();
        },
        open:function(){
           this.page=1;
           this.init();
           this.modal=true;
        },
        close:function(){
           this.modal=false;
        },
        selectRow:function(index,type){
           this.selectIndex=index;
           if(type) this.confirm();
        },
        /**
         * 选定确认
         */
        confirm:function(){
           var _this=this;
           if(_this.selectIndex<0){
             return _this.alertMsg('请先选择供应商后操作','error');
           }
           _this.$emit("confirm",this.list[_this.selectIndex]);
           _this.close();
        }
     }
  }
</script>
<style lang="less">
    .vertical-center-modal{
        display:flex;
        align-items:center;
        justify-content:center;
        .ivu-modal{
          top:0;
        }
    }
    .providers_page{
      padding-top:15px;padding-bottom:10px;overflow:hidden;
      .left{
         width:50%;float:left;
         .inputs{
            width:280px;margin-right:20px;display:inline-table;cursor:pointer;
         }
      }
      .right{
         width:50%;float:right;text-align:right;margin-top:5px;
      }
    }
</style>
