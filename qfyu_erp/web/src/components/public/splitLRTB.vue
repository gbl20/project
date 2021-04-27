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
            <div slot="left" class="left-pan">
              <slot name="left"></slot>
            </div>
            <div slot="right" class="right-pan">
               <div :style="'margin-left: 6px;height:'+SplitHeight+'px'">
                 <Split v-model="splitTBNum" min="140" mode="vertical">
                 <div slot="top" class="top-pane" :style="'height:'+SplitHeight*splitTBNum+'px'">
                      <slot name="rightTop"></slot>
                 </div>
                 <div slot="bottom" class="bottom-pane" :style="'height:'+(SplitHeight*(1-splitTBNum))+'px'">
                     <slot name="rightBottom"></slot>
                 </div>
                 </Split>
              </div>
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
    width: 100%;height: 100%; overflow: hidden;
    .top-pane,.bottom-pane{
      position: relative;z-index: 1;height: auto;overflow:hidden;
    }
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
        splitRTBInit:{
          type:Number,
          default:0.5
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
          splitTBNum:0.5,
          formMH:98,
          SplitHeight:this.$store.state.MainH - 98,
         }
      },
      computed:{
        MainH(){
          return this.$store.state.MainH+document.documentElement.clientWidth;
        }
      },
      watch: {
        splitTBNum() {
          this.changeHeight();
        },
        MainH(e){
           this.changeHeight();
        }
      },
      activated(){
        this.changeHeight();
      },
      mounted:function(){
        this.splitNum = this.splitInit;
        this.changeHeight();
      },
      methods:{
        changeHeight:function(){
          this.formMH = this.$refs.formM.offsetHeight + (JSON.stringify(this.Breadcrumb) != '[]'?34:0);
          this.SplitHeight = this.$store.state.MainH - this.formMH - this.nestingNum;
          this.$emit('DHeight',{SplitHeight:this.SplitHeight,splitTBNum:this.splitTBNum})
        }
      }
    }
</script>
