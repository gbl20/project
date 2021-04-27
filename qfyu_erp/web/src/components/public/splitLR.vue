<template>
    <div class="demo-split">
      <Breadcrumb class="ivu-breadcrumb-custom" v-if="JSON.stringify(Breadcrumb) != '[]'">
          <BreadcrumbItem v-for="(item,index) in Breadcrumb" :key='index' :to="item.url||''">{{item.title}}{{(((index+1)==Breadcrumb.length) && editTypeTitle)?'-'+editTypeTitle:''}}</BreadcrumbItem>
      </Breadcrumb>
      <div ref="formM" class="ser-m-top bg">
         <slot name="form-ser"></slot>
      </div>
      <div class="bg" :style="'height:'+SplitHeight+'px;overflow:hidden;'">
        <Split v-model="splitNum" min="100">
            <div slot="left" class="demo-split-pane left-pan">
              <slot name="left"></slot>
            </div>
            <div slot="right" class="demo-split-pane right-pan">
               <div style="margin-left: 6px;"><slot name="right"></slot></div>
            </div>
        </Split>
      </div>
    </div>
</template>
<style lang="less">
 .demo-split{
    position: relative;
  }
  .left-pan{
    width: 100%;height: 100%; overflow: auto; margin:0;
  }
  .right-pan{
    width: 100%;height: 100%; overflow: auto;
  }
</style>
<script>
    export default {
      name :'splitLR',
      props: {
        splitInit:{
          type:Number,
          default:0.3
        },
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
          splitNum:0.3,
          formMH:98,
          SplitHeight:this.$store.state.MainH - 98,
         }
      },
      computed:{
        MainH(){
          return this.$store.state.MainH+document.documentElement.clientWidth;
        }
      },
      watch:{
        MainH(e){
           this.changeHeight();
        }
      },
      activated() {
        this.changeHeight();
      },
      mounted(){
        this.splitNum = this.splitInit;
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
