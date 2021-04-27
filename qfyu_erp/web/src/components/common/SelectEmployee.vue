<template>
    <div v-if="show_self">
      <Modal v-model="show_self" title="选择员工" width="1080" footer-hide :mask-closable="false">
        <div class="selemp-out">
            <div class="sel-vmiddle">
              <div class="selcustw bg">
                <Table highlight-row border :columns="columns" :data="data.data" size="small" height="358" :loading="table_loading" @on-row-click="sel_column" @on-row-dblclick="sure_cust">
                  <template slot-scope="row" slot="sex">{{row.row.sex?sex[row.row.sex]:''}}</template>
                  <template slot-scope="row" slot="status">{{row.row.status?'在职':'离职'}}</template>
                </Table>
                <div class="selcust-foot">
                  <Page class-name="selcust-page" :total="data.total" :page-size="data.per_page" show-total simple @on-change="ChangePage" />
                  <div class="serleft">
                    <Input v-model="params.keyword" placeholder="员工编号/姓名/手机/部门/职务,支持模糊搜索" @on-enter="init()">
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
    </div>
</template>
<script>
    export default{
        name:'SelectEmployee',
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
            params:{keyword:'',page:1},
            table_loading:true,
            columns: [
              {title:'员工编号',key:'code',width:80,resizable:true,ellipsis :true},
              {title:'姓名',key:'name',width:120,resizable:true,ellipsis :true},
              {title:'性别',slot:'sex',width:60,resizable:true,ellipsis :true},
              {title:'部门',key:'dept_name',width:150,resizable:true,ellipsis :true},
              {title:'职务',key:'dutiestxt',width:150,resizable:true,ellipsis :true},
              {title:'在职状态',slot:'status',width:80,resizable:true,ellipsis :true},
              {title:'手机号',key:'phone',width:130,resizable:true,ellipsis :true},
              {title:'备注',key:'remark',width:268,resizable:true,ellipsis :true}
            ],
            data:{},
            sex:['','男','女']
          }
        },
        methods:{
            init:function(params){
              var _this = this;
              this.table_loading=true;
              this.sel_key=-1;
              this.show_self=true;
              if(typeof(params)!="undefined"){
                this.params.noid=[params.noid];
              }
                _this.common.http({url:'selectEmployee',data:_this.params}).then(function(res){
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
              this.alertMsg('请选择员工！','error');return false;
            }
            this.$emit('selemp',this.data.data[this.sel_key]);
            this.show_self=false;
          },
          /**
           * 清除已选择的选项
           */
          clear_sel:function () {
            this.$emit('clear_sel','charge');
            this.show_self=false;
          }
        }
    }
</script>
<style lang="less">
  .selemp-out{display: table; width: 100%; height: 100%;
    .sel-vmiddle{
      display: table-cell; height: 100%; vertical-align: middle;
      .selcustw{width: 1060px; height: auto; min-height: 418px; padding: 0 10px 10px 10px; margin: 0 auto; border-radius: 4px; clear: both; overflow: hidden;
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
