<template>
    <div class="demo-split">
      <Breadcrumb class="ivu-breadcrumb-custom" v-if="JSON.stringify(Breadcrumb) != '[]'">
          <BreadcrumbItem v-for="(item,index) in Breadcrumb" :key='index' :to="item.url||''">{{item.title}}{{(((index+1)==Breadcrumb.length) && editTypeTitle)?'-'+editTypeTitle:''}}</BreadcrumbItem>
      </Breadcrumb>
      <div ref="formM" class="ser-m-top bg">
         <slot name="form-ser"></slot>
      </div>
      <div class="bg" :style="'height:'+SplitHeight+'px;overflow:hidden;'">
      <div class="demo-split-pane top-pane">
        <slot name="table-list"></slot>
      </div>
      </div>
    </div>
</template>
<style lang="less">
  .demo-split{
    position: relative;
  }
  .demo-split-pane{
    height: 100%;
  }
</style>
<script>
    export default {
      name :'splitNone',
      props: {
        Breadcrumb:{
          type:Array,
          default:()=>[]
        },
        nestingNum:{
          type:Number,
          default:0
        },
        editTypeTitle:{
          type:String,
          default:null
        }
      },
      data:function() {
         return{
            formMH:98,
            SplitHeight:this.$store.state.MainH - 98
         }
      },
      computed:{
        MainH(){
          return this.$store.state.MainH+document.documentElement.clientWidth;
        }
      },
      activated() {
        this.changeHeight();
      },
      watch:{
        MainH(e){
           this.changeHeight();
        }
      },
      mounted(){
        this.changeHeight();
      },
      methods:{
        changeHeight:function(){
          this.formMH = this.$refs.formM.offsetHeight + (JSON.stringify(this.Breadcrumb) != '[]'?34:0);
          this.SplitHeight = this.$store.state.MainH - this.formMH - this.nestingNum;
          this.$emit('DHeight',this.SplitHeight)
        }
      }
    }
</script>
