<template>
    <div>
        <div class="ivu-input" @click="openDrawer">{{placeholder}}</div>
        <Drawer :title="placeholder" v-model="modal" :closable="false">
           <div class="gridbox">
                <div class="formsearch">
                    <slot name="search"></slot>
                </div>
                <div class="formlist">
                    <i-table :columns="columns" :data="listdata" :loading="loading">
                      <template slot-scope="row" slot="id">{{row.index+1}}</template>
                      <template slot-scope="row" slot="isstock">{{row.row.isstock==1?'可用':'不可用'}}</template>
                    </i-table>
                </div>
                <div class="pagebox" v-if="ispage">
                    <Page :total="total" :page-size="pageSize" size="small" show-total show-elevator :page-size-opts="[5,10,15]" show-sizer @on-change="ChangePage" @on-page-size-change="ChangePageSize"/>
                </div>
           </div>
        </Drawer>
    </div>
</template>
<script>
    export default{
        name:'SelectGrid',
        props:{
          placeholder:{
              type:String,
              default:()=>""
          },
          placement:{
              type:String,
              default:()=>"top-end"
          },
          columns:{
              type:Array,
              default:()=>[]
          },
          ispage:{
              type:Boolean,
              default:()=>true
          },

        },
        data(){
          return{
              modal:false,
              loading:false,
              page:1,
              total:0,
              pageSize:5,
              listdata:[],
              params:{},
              url:""
          }
        },
        methods:{
            init:function(url,params){
               var _this=this;
                _this.params=params;
                _this.url=url;
                _this.loading=true;
                _this.common.http({url:_this.url,data:_this.params}).then(function(res){
                    _this.loading=false;
                    _this.listdata=res.list;
                    console.log(_this.listdata)
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
            ChangePage:function(e){
                this.page=e;
                this.init();
            },
            ChangePageSize:function(e){
                this.pageSize=e;
                this.page=1;
                this.init();
            },
            openDrawer:function(){
                this.modal=true;
            },
            doSearch:function(){

            }
        }
    }
</script>
<style>
  .gridbox{
      width:500px;padding:10px;box-sizing:border-box;
  }
  .formsearch{
      height:40px;
  }
</style>
