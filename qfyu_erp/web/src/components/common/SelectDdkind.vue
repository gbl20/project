<template>
  <Modal v-model="show_self" title="选择许可经营类别" width="742" footer-hide :mask-closable="false">
      <div class="selddk-out">
        <div class="sel-vmiddle">
          <div class="selcustw bg">
            <div class="ddkmid">
              <div class="ddkleft">
                  <div v-for="(p,key) in data" style="padding: 3px 0;"><Checkbox :value="p.checked" @on-change="changddk_big($event,key,p.id)"><span></span></Checkbox><span class="bddk txt-color" :class="[sel_key==key?'ddkhover':'']" @click="change_bddk(key)">{{p.name}}</span></div>
              </div>
              <div class="ddkright">
                  <div v-for="(p,key) in data[sel_key].child" style="padding: 3px 0;"><Checkbox :value="p.checked" @on-change="changddk_small($event,p.id)">{{p.name}}</Checkbox></div>
              </div>
            </div>
            <div class="selcust-foot">
              <div class="selbtngroup">
                <Button type="primary" icon="md-checkmark" @click="sure_cust">选定</Button>
                <Button type="error" icon="md-close" style="margin-left: 15px;" @click="show_self=false">取消</Button>
              </div>
            </div>
          </div>
        </div>
      </div>
  </Modal>
</template>
<script>
    export default{
        name:'SelectDdkind',
        props:{},
        data(){
          return{
            sel_key:0,
            show_self:false,
            data:[{child:[]}],
            selddk:[]
          }
        },
        methods:{
            init:function(params){
              var _this=this;
              this.table_loading=true;
              if(typeof(params)!="undefined"){
                this.show_self=true
                this.selddk=params.selddk;
              }
                _this.common.http({url:'selectDdkind',data:{selddk:_this.selddk}}).then(function(res){
                  _this.table_loading=false;
                  if(res.status==1){
                    _this.data=res.data;
                    _this.selddk=res.selddk;
                  }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
          /**
           * 切换经营类别大类
           */
          change_bddk:function(key){
            this.sel_key=key;
          },
          /**
           * 选择/取消选择大类
           */
          changddk_big:function(checked,key,id){
            this.sel_key=key;
            var selsmall=this.data[key].child;
            for (var k in this.selddk){
              if(this.selddk[k]==id){
                this.selddk.splice(k,1);
              }
            }
            for (var k2 in selsmall){
              for (var k in this.selddk){
                if(this.selddk[k]==selsmall[k2]['id']) this.selddk.splice(k,1);
              }
            }
            if(checked){//选中
              this.selddk.push(id);
              for (var k2 in selsmall){
                this.selddk.push(selsmall[k2]['id']);
              }
            }
            this.set_checked();
          },
          /**
           * 设置选择效果
           */
          set_checked:function(){
            for(var t in this.data){
              if(this.selddk.indexOf(this.data[t].id)!=-1) this.$set(this.data[t],'checked',true);
              else this.$set(this.data[t],'checked',false);
              var child=this.data[t].child;
              for (var k in child){
                if(this.selddk.indexOf(child[k].id)!=-1) this.$set(this.data[t].child[k],'checked',true);
                else this.$set(this.data[t].child[k],'checked',false);
              }
            }
          },
          /**
           * 选择/取消选择小类
           */
          changddk_small:function(checked,id){
            var parent_id=this.data[this.sel_key].id;
            if(checked){//选中
              this.selddk.push(id);
              if(this.selddk.indexOf(parent_id)==-1) this.selddk.push(parent_id);
            }else{
              var key=this.selddk.indexOf(id),all_calcel=true,child=this.data[this.sel_key].child;
              this.selddk.splice(key,1);
              for (var k in child){
                if(this.selddk.indexOf(child[k].id)!=-1){
                  all_calcel=false;
                  break;
                }
              }
              if(all_calcel){
                var key=this.selddk.indexOf(parent_id);
                this.selddk.splice(key,1);
              }
            }
            this.set_checked();
          },
          /**
           * 确定选择
           */
          sure_cust:function () {
            this.$emit('selddk',this.selddk);
            this.show_self=false;
          }
        }
    }
</script>
<style lang="less">
  .selddk-out{display: table; width: 100%; height: 100%;
    .sel-vmiddle{
      display: table-cell; height: 100%; vertical-align: middle;
      .selcustw{width: 722px; height: auto; min-height: 530px; padding: 0 10px 10px 10px; margin: 0 auto; border-radius: 4px; clear: both; overflow: hidden;
        .selcust-tit{height: 41px; position: relative;
          .title-txt{float: left; line-height: 36px;}
          .icon{display: block; width: 36px; height: 36px; line-height: 32px; text-align: center; cursor: pointer; position: absolute; top:0; right: -10px;}
        }
        .ddkmid{
          height: 450px;
          .ddkleft{
            float: left; width: 210px; height: 100%; padding-left: 10px; overflow-x: hidden; overflow-y: auto; border-right: 1px solid #dddddd;
            .ivu-checkbox-wrapper{margin-right: 0;}
            .bddk{cursor: pointer;}
            .ddkhover{background-color: #2d8cf0; color: #ffffff;}
          }
          .ddkright{
            float: right; width: 470px; height: 100%; overflow-x: hidden; overflow-y: auto;
          }
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
