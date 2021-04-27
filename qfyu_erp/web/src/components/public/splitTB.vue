<template>
    <div class="demo-split">
      <Breadcrumb class="ivu-breadcrumb-custom" v-if="JSON.stringify(Breadcrumb) != '[]'">
          <BreadcrumbItem v-for="(item,index) in Breadcrumb" :key='index' :to="item.url||''">{{item.title}}{{(((index+1)==Breadcrumb.length) && editTypeTitle)?'-'+editTypeTitle:''}}</BreadcrumbItem>
      </Breadcrumb>
      <div ref="formM" class="ser-m-top bg">
         <slot name="form-ser"></slot>
      </div>
      <div class="bg" :style="'height:'+SplitHeight+'px'">
        <Split v-model="splitNum" min="140" mode="vertical">
            <div slot="top" class="demo-split-pane top-pane" :style="'height:'+(SplitHeight*splitNum)+'px'">
                 <slot name="table-list"></slot>
            </div>
            <div slot="bottom" class="demo-split-pane bottom-pane" :style="'height:'+(SplitHeight*(1-splitNum))+'px'">
                <slot name="bottom"></slot>
            </div>
        </Split>
      </div>
    </div>
</template>
<style lang="less">
  .demo-split{
    position: relative;
  }
  .bottom-pane{
    padding-top:3px;
  }
</style>
<script>
    export default {
      name :'splitTB',
      props: {
        splitInit:{
          type:Number,
          default:0.7
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
            splitNum:0.7,
            formMH:98,
            pageH:0,
            pageSize:0,
            page:1,
            SplitHeight:this.$store.state.MainH - 98
         }
      },
      computed:{
        MainH(){
          return this.$store.state.MainH+document.documentElement.clientWidth;
        }
      },
      watch: {
        MainH(e){
           this.changeHeight();
        },
        splitNum() {
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
          this.SplitHeight = this.$store.state.MainH - this.formMH;
          this.$emit('DHeight',{THeight:this.SplitHeight*this.splitNum,BHeight:this.SplitHeight*(1-this.splitNum)-7})
        }
      }
    }
</script>
