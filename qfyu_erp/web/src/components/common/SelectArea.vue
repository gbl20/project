<template>
  <Modal v-model="show_self" title="选择地区" width="380" footer-hide :mask-closable="false">
      <div class="selarea-out">
        <div class="sel-vmiddle">
          <div class="selcustw bg">
            <div class="arealsw">
              <Tree :data="data" @on-select-change="sel_column"></Tree>
            </div>
            <div class="selcust-foot">
              <div class="selbtngroup">
                <Button type="primary" icon="md-checkmark" @click="sure_cust">选定</Button>
                <Button type="error" icon="md-close" style="margin-left: 15px;" @click="close_self">取消</Button>
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
        name:'SelectArea',
        props:{
          show_clear:{
            type:Boolean,
            default:false
          }
        },
        sel_data: {},
        set_key:'',
        data(){
          return{
            show_self:false,
            data:[]
          }
        },
        methods:{
            init:function(params){
              var _this=this;
              this.table_loading=true;
              this.sel_data= {};
              this.show_self=true;
              if(typeof(params)!="undefined"){
                this.set_key=params.set_key;
              }
                _this.common.http({url:'selectArea',data:_this.params}).then(function(res){
                  if(res.status==1) _this.data=res.data;
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
          /**
           * 选择某一行
           */
          sel_column:function(data){
            if(data.length==0) return false;
            this.sel_data={area:data[0].id,areatxt:data[0].title};
          },
          /**
           * 确定选择
           */
          sure_cust:function () {
            if(JSON.stringify(this.sel_data)=='{}'){
              this.alertMsg('请选择地区！','error');return false;
            }
            this.$emit('selarea',this.sel_data);
            this.data=[];
            this.show_self=false;
          },
          /**
           * 清除已选择的选项
           */
          clear_sel:function () {
            this.$emit('clear_sel','area');
            this.$emit('clear_sel','areatxt');
            this.show_self=false;
          },
          /**
           * 关闭组件
           */
          close_self:function () {
            this.data=[];
            this.show_self=false;
          }
        }
    }
</script>
<style lang="less">
  .selarea-out{display: table; width: 100%; height: 100%;
    .sel-vmiddle{
      display: table-cell; height: 100%; vertical-align: middle;
      .selcustw{width: 360px; height: auto; min-height: 530px; padding: 0 10px 10px 10px; margin: 0 auto; border-radius: 4px; clear: both; overflow: hidden;
        .selcust-tit{height: 41px; position: relative;
          .title-txt{float: left; line-height: 36px;}
          .icon{display: block; width: 36px; height: 36px; line-height: 32px; text-align: center; cursor: pointer; position: absolute; top:0; right: -10px;}
        }
        .arealsw{
          height: 450px; overflow-y: auto;
        }
        .selcust-foot{
          padding-top:20px;
          .selbtngroup{
            text-align: center;
          }
        }
      }
    }
  }
</style>
