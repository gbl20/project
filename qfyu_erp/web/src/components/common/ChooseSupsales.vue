<template>
<div>
    <Modal v-model="modal" title="选择供方销售人员(联系人)" :mask-closable="false" width="1000" class-name="supsales-center-modal" footer-hide>
        <Table size="small" stripe :columns="columns"  :data="list" border class="table-m" :height="400" :loading="loading" :highlight-row="true" @on-row-click="(row,index)=>{selectRow(index,false)}" @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
            <template slot-scope="row" slot="sex">
               {{row.row.sex==1?'男':'女'}}
            </template>
            <template slot-scope="row" slot="attorney_validity">
               <Checkbox v-model="row.row.attorney_validity" :true-value="1" :false-value="0" disabled></Checkbox>
            </template>
            <template slot-scope="row" slot="exam_status">
               <Checkbox v-model="row.row.exam_status" :true-value="1" :false-value="0" disabled></Checkbox>
            </template>
        </Table>
        <div class="supsales_page">
           <div class="left">
               <Input v-model="search.user_name" placeholder="按姓名/电话/手机" class="inputs" maxlength="50">
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
        name:'chooseSupsales',
        data(){
          return {
              modal:false,
              columns:[
                 {title:'供应商编号',key:'supplier_code',width:120,align:'center'},
                 {title:'姓名',key:'user_name',width:120,align:'center'},
                 {title:'性别',slot:'sex',width:80,align:'center'},
                 {title:'部门',key:'depart',minWidth:150,align:'center'},
                 {title:'职务',key:'duties',minWidth:140},
                 {title:'住址',key:'address',minWidth:180},
                 {title:'电话',key:'tel',minwidtW:120},
                 {title:'手机号',key:'phone',minWidth:150},
                 {title:'委托书编号',key:'attorney_no',minWidth:150},
                 {title:'委托书授权内容',key:'content_power',minWidth:180},
                 {title:'委托书有效期',key:'validity_date',width:100},
                 {title:'委托书已失效',slot:'attorney_validity',width:100,align:'center'},
                 {title:'合格',slot:'exam_status',width:100,align:'center'}
              ],
              loading:false,
              list:[],
              search:{user_name:''},
              selectIndex:-1,
              sup_code:'',
              kind:0
          }
        },
        methods:{
           init:function(callback){
              var _this=this;
              _this.loading=true;
              var data={sup_code:_this.sup_code,kind:_this.kind,search:_this.search};
              _this.common.http({url:'chooseSupsales',data:data}).then(function(res){
                  _this.loading=false;
                  if(res.status==1){
                      _this.list=res.list;
                      if(typeof(callback)=='function'){
                         var linkman=null,salelist=null;
                         if(res.list.length>0){
                            linkman=res.list[0];
                            for(var key in res.list){
                                if(res.list[key].exam_status==1){
                                   salelist=res.list[key];break;
                                }
                            }
                         }
                         callback(salelist,linkman);
                      }
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
           },
           /**
            * 选择类型
            * @param kind 1:选择销售人员 2:联系人
            */
           open:function(kind,sup_code){
              var _this=this;
              _this.kind=kind;
              _this.sup_code=sup_code;
              _this.init(false);
              _this.modal=true;
           },
           close:function(){
              this.modal=false;
           },
           /**
            * 搜索
            */
           doSearch:function(){
              this.init(false);
           },
           /**
            * 选择行数据
            * @param index 索引
            * @param type 类型
            */
           selectRow:function(index,type){
              this.selectIndex=index;
              if(type) this.confirm();
           },
           /**
            * 确认选择
            */
           confirm:function(){
              var _this=this;
              if(_this.selectIndex<0){
                  return _this.alertMsg('请选择销售人员(联系人)后操作','error');
              }
              _this.$emit("confirm",_this.list[_this.selectIndex]);
              _this.close();
           },
           /**
            * 选择供应商时调用
            * 默认选择供方销售人员以及联系人
            */
           initSup:function(sup_code,callback){
              var _this=this;
              _this.sup_code=sup_code;
              _this.kind=0;
              _this.init(callback);
           }
        }
    }
</script>
<style lang="less">
  .supsales-center-modal{
      display:flex;
      align-items:center;
      justify-content:center;
      .ivu-modal{
        top:0;
      }
  }
  .supsales_page{
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
