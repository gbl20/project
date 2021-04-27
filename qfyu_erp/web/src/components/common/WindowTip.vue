<template>
  <div>
      <Modal v-model="modal" :mask-closable="false" :closable="false" footer-hide>
         <div class="WinTipsBox">
             <div class="contips title-color">
                 <div class="title">
                    <Icon :type="issucess?'ios-checkmark-circle':'ios-close-circle'"
                          :class="'icon '+(issucess?'success-text':'error-text')"/>
                    <span class="txt">{{title}}</span>
                 </div>
                 <div v-html="content" class="content"></div>
             </div>
             <div class="windowTipBtn">
                  <Button class="cancel" @click="close" v-if="isconfirm">取消</Button>
                  <Button type="primary" @click="confirm">确定</Button>
             </div>
         </div>
      </Modal>
  </div>
</template>
<script>
export default {
    data(){
       return {
          modal:false,
          url:null,
          title:"温馨提示",
          isconfirm:false,
          issucess:false,
          content:"",
          callbackfun:function(){}
       }
    },
    methods:{
       open:function(opt,url,callback){
          var _this=this;
          url=url || null;
          _this.url=(url!=null && url.length>0)?url:'';
          _this.title=opt.title;
          _this.isconfirm=opt.isconfirm;
          _this.issucess=opt.issucess;
          _this.content=opt.content;
          _this.callbackfun=function(){};
          if(typeof(callback)=="function") _this.callbackfun=callback;
          _this.modal=true;
       },
       close:function(){
          this.modal=false;
       },
       confirm:function(){
          var _this=this;
          _this.callbackfun();
          if(_this.url!=null && _this.url.length>0){
            _this.toUrl(_this.url);
          }
          _this.close();
       }
    }
}
</script>
<style lang="less">
    .WinTipsBox{
       padding:10px 30px;
       .contips{
          min-height:120px;
          .title{
             overflow:hidden;
          }
          .icon{
             font-size:28px;float:left;
          }
          .txt{
             display:inline-block;line-height:28px;float:left;margin-left:10px;font-size:16px;
          }
          .content{
             display:block;width:100%;padding-left:40px;padding-top:15px;
          }
       }
    }
    .windowTipBtn{
      margin-top:20px;
      text-align:right;
      .cancel{
         margin-right:15px;
      }
    }
</style>
