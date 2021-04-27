<template>
<div>
    <Modal v-model="modal" title="选择(供应商)合同信息" :mask-closable="false" width="1000" class-name="vertical-center-modal" footer-hide>
        <Table size="small" stripe :columns="columns"  :data="list" border class="table-m" :height="400" :loading="loading" :highlight-row="true" @on-row-click="(row,index)=>{selectRow(index,false)}" @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
        </Table>
        <div class="contract_page">
           <div class="left">
               <Input v-model="search.orderid" placeholder="按合同号/合同标题" class="inputs" maxlength="50">
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
    export default {
        data(){
          return {
              modal:false,
              columns:[
                {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
                {title:'合同号',key:'orderid',width:160,fixed:'left'},
                {title:'合同标题',key:'title',minWidth:200},
                {title:'交货地点',key:'delivery',minWidth:200},
                {title:'签约日期',key:'sign_date',width:120,align:'center'},
                {title:'生效日期',key:'start_date',width:120,align:'center'},
                {title:'失效日期',key:'validity_date',width:120,align:'center'},
                {title:'签约地点',key:'sign_area',minWidth:200},
                {title:'签约人',key:'sign_code',width:100,align:'center'},
                {title:'签约人姓名',key:'sign_name',width:120,align:'center'},
                {title:'结算方式',key:'settlement_name',width:100,align:'center'},
                {title:'付款日期',key:'pay_date',width:120,align:'center'},
                {title:'创建时间',key:'create_date',width:150,align:'center'},
                {title:'备注说明',key:'explain',minWidth:200},
              ],
              list:[],
              loading:false,
              search:{orderid:''},
              sup_code:'',
              settlement:[],
              selectIndex:-1
          }
        },
        methods:{
            init:function(){
                var _this=this;
                _this.loading=true;
                var data={sup_code:_this.sup_code,search:_this.search};
                _this.common.http({url:'chooseContractList',data:data}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.list;
                        _this.settlement=res.settlement;
                    }
                }).catch(function(err){
                     _this.common.httpErr(err.data,_this);
                });
            },
            open:function(sup_code){
                this.sup_code=sup_code;
                this.init();
                this.modal=true;
            },
            /**
             * 关闭
             */
            close:function(){
               this.modal=false;
            },
            /**
             * 选择
             * @param index
             * @param type
             */
            selectRow:function(index,type){
                this.selectIndex=index;
                if(type) this.confirm();
            },
            /**
             * 搜索
             */
            doSearch:function(){
                this.init();
            },
            /**
             * 确认选定
             */
            confirm:function(){
                if(this.selectIndex<0){
                  return this.alertMsg('请选择合同','error');
                }
                this.$emit("confirm",this.list[this.selectIndex]);
                this.close();
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
  .contract_page{
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
