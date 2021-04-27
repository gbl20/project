<template>
  <Modal v-model="show_self" title="选择部门" width="742" footer-hide :mask-closable="false">
      <div class="seldepart-out">
        <div class="sel-vmiddle">
          <div class="selcustw bg">
            <Table highlight-row :columns="columns" :data="data" size="small" height="450" :loading="table_loading" @on-row-click="sel_column" @on-row-dblclick="sure_cust">
              <template slot-scope="row" slot="id">{{row.row.branch_id?'　　－'+row.row.id:row.row.id}}</template>
            </Table>
            <div class="selcust-foot">
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
        name:'SelectDepart',
        props:{
          clearKeys:{
            type:Array,
            default:()=>['department','dept_name']
          },
          show_clear:{
            type:Boolean,
            default:false
          }
        },
        data(){
          return{
            show_self:false,
            params:{keyword:'',page:1},
            table_loading:true,
            columns: [
              {title:'部门编号',slot:'id',width:90,resizable:true,ellipsis :true},
              {title:'部门(公司)名称',key:'dept_name',width:180,resizable:true,ellipsis :true},
              {title:'电话',key:'tel',width:200,resizable:true,ellipsis :true},
              {title:'地址',key:'address',width:230,resizable:true,ellipsis :true}
            ],
            data:[],
            sel_key:-1
          }
        },
        methods:{
            init:function(params){
              var _this=this;
              this.table_loading=true;
              this.sel_key=-1;
              this.show_self=true;
                _this.common.http({url:'selectDepart',data:_this.params}).then(function(res){
                  _this.table_loading=false;
                  if(res.status==1) _this.data=res.data;
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
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
              this.alertMsg('请选择部门！','error');return false;
            }
            this.$emit('seldep',this.data[this.sel_key]);
            this.show_self=false;
          },
          /**
           * 清除已选择的选项
           */
          clear_sel:function () {
            for(var i=0;i<this.clearKeys.length;i++){
              this.$emit('clear_sel',this.clearKeys[i]);
            }
            this.show_self=false;
          }
        }
    }
</script>
<style lang="less">
  .seldepart-out{display: table; width: 100%; height: 100%;
    .sel-vmiddle{
      display: table-cell; height: 100%; vertical-align: middle;
      .selcustw{width: 722px; height: auto; min-height: 530px; padding: 0 10px 10px 10px; margin: 0 auto; border-radius: 4px; clear: both; overflow: hidden;
        .selcust-tit{height: 41px; position: relative;
          .title-txt{float: left; line-height: 36px;}
          .icon{display: block; width: 36px; height: 36px; line-height: 32px; text-align: center; cursor: pointer; position: absolute; top:0; right: -10px;}
        }
        .selcust-foot{
          padding-top:20px;
          .selcust-page{
            float: left; margin:3px 30px 0 0;
          }
          .serleft{
            float: left; width: 360px;
          }
          .selbtngroup{
           text-align: center;
          }
        }
      }
    }
  }
</style>
