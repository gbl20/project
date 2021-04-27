<template>
      <Modal v-model="show_self" title="选择客户" width="1080" footer-hide :mask-closable="false">
        <div class="selmain-out">
        <div class="sel-vmiddle">
          <div class="selcustw bg">
            <Table highlight-row border :columns="columns" :data="data.data" size="small" height="450" :loading="table_loading" @on-row-click="sel_column" @on-row-dblclick="sure_cust">
              <template slot-scope="row" slot="stopuser">
                <Checkbox :value="row.row.stopuser" :true-value="1" :false-value="0" disabled></Checkbox>
              </template>
            </Table>
            <div class="selcust-foot">
              <Page class-name="selcust-page" :total="data.total" :page-size="data.per_page" show-total simple @on-change="ChangePage" />
              <div class="serleft">
                <Input v-model="params.keyword" placeholder="客户编号/简称/全称/助记码,支持模糊搜索" @on-enter="init()">
                  <span slot="prepend">查找:</span>
                  <Button slot="append" icon="ios-search" @click="init()"></Button>
                </Input>
              </div>
              <div class="selbtngroup">
                <Button type="primary" icon="md-checkmark" @click="sure_cust">选定</Button>
                <Button type="error" icon="md-close" style="margin-left: 15px;" @click="show_self=false">取消</Button>
                <Button type="default" icon="ios-trash" style="margin-left: 15px;" @click="clear_sel" v-if="show_clear">删除已选</Button>
              </div>
            </div>
          </div>
        </div>
      </div>
      </Modal>
</template>
<script>
    export default{
        name:'SelectCustomer',
        props:{
          show_clear:{
            type:Boolean,
            default:false
          }
        },
        sel_key:-1,
        data(){
          return{
            show_self:false,
            params:{keyword:'',noid:[],page:1},//noid 需要排除的客户ID
            table_loading:true,
            columns: [
              {title:'客户编号',key:'id',width:80,resizable:true,ellipsis :true},
              {title:'客户简称',key:'sname',width:120,resizable:true,ellipsis :true},
              {title:'公司地址',key:'comarea',width:180,resizable:true,ellipsis :true},
              {title:'业务负责人',key:'charge',width:90,resizable:true,ellipsis :true},
              {title:'客户采购人员',key:'man',width:100,resizable:true,ellipsis :true},
              {title:'联系方式',key:'telephone',width:103,resizable:true,ellipsis :true},
              {title:'办公电话',key:'mannumber',width:105,resizable:true,ellipsis :true},
              {title:'备注',key:'remark',width:180,resizable:true,ellipsis :true},
              {title:'暂停往来',slot:'stopuser',width:80,align:'center'}
            ],
            data:{}
          }
        },
        methods:{
            init:function(params){
              var _this=this;
              this.table_loading=true;
              this.sel_key=-1;
              this.show_self=true;
              if(typeof(params)!="undefined"){
                this.params.noid=[params.noid];
              }
                _this.common.http({url:'selectCustomer',data:_this.params}).then(function(res){
                  _this.table_loading=false;
                  if(res.status==1) _this.data=res.data;
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
          /**
           * 翻页
           */
          ChangePage:function (page) {
            this.params.page=page;
            this.init();
          },
          /**
           * 选择某一行
           */
          sel_column:function(event,index){
            this.sel_key=index;
          },
          /**
           * 确定选择
           */
          sure_cust:function () {
            if(this.sel_key==-1){
              this.alertMsg('请选择客户！','error');return false;
            }
            this.$emit('selcust',this.data.data[this.sel_key]);
            this.show_self=false;
          },
          /**
           * 清除已选择的选项
           */
          clear_sel:function () {
            this.$emit('clear_sel','parlevel');
            this.show_self=false;
          }
        }
    }
</script>
<style lang="less">
  .selmain-out{display: table; width: 100%; height: 100%;
    .sel-vmiddle{
      display: table-cell; height: 100%; vertical-align: middle;
      .selcustw{width: 1060px; height: auto; min-height: 530px; padding: 0 10px 10px 10px; margin: 0 auto; border-radius: 4px; clear: both; overflow: hidden;
        .selcust-foot{
          padding-top:20px;
          .selcust-page{
            float: left; margin:3px 30px 0 0;
          }
          .serleft{
            float: left; width: 360px;
          }
          .selbtngroup{
            float: left; margin-left: 50px;
          }
        }
      }
    }
  }
</style>
