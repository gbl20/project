<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                 <Button><span class="icon iconfont">&#xe797;</span>新增</Button>
                 <Button><span class="icon iconfont">&#xe791;</span>修改</Button>
                 <Button><span class="icon iconfont">&#xe792;</span>保存</Button>
                 <Button><span class="icon iconfont">&#xe792;</span>取消</Button>
                 <Divider type="vertical"/>
                 <Button><span class="icon iconfont">&#xe692;</span>审核</Button>
                 <Button><span class="icon iconfont">&#xe693;</span>还原</Button>
                 <Divider type="vertical"/>
                 <Button @click="refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                 <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                 <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
              </div>
          </div>
      </split-none>
  </div>
</template>
<script>
    import splitNone from '@/components/public/splitNone'
    var _this=this;
    export default {
       name:"EditPchPay",
       components:{splitNone},
       data(){
         return {
            height:0,
            Breadcrumb:[{title:'财务管理'},{title:'采购付款单查询',url:'PchPayList'},{title:'采购付款单'}]

         }
       },
       beforeCreate:function(){
          _this=this;
       },
       methods:{
          DHeight(e){
             _this.height = e;
          },
          refresh:function(){
             _this.init();
          },
          init:function(){

          }
       }
    }
</script>
<style lang="less">
</style>
