<template>
  <div class="footer-m bg-m">
    <Tags/>
    <div class="footer bg">
      <div class="b-l-left txt-color">
        账户：{{user_info}}<Divider type="vertical" />【{{acc_name}}】
        <Divider type="vertical" />
        <a class="bg-text" href="javascript:;" @click="quitLogin()">退出</a>
      </div>
      <div class="b-l-right txt-color">@2020 深圳庆丰裕信息科技有限公司</div>
    </div>
  </div>
</template>
<style lang="less">
 @import '~@/assets/public/css/footer';
</style>
<script>
   var _this;
   import Tags from '@/components/public/TagsView.vue'
    export default {
      components:{Tags},
        data () {
            return {
              user_info:'',
              acc_name:''
            }
        },
        mounted() {
          _this = this;
        },
        created() {
          this.init();
        },
        methods:{
          init:function(){
            this.common.http({
              url: 'welInit'
            }).then(function (res) {
              if(res.status == 1){
                _this.acc_name = res.acc_name;
                _this.user_info = res.user_info;
              }
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            })
          },
          quitLogin:function(){
            localStorage.removeItem('token');
            localStorage.removeItem('acc');
            localStorage.removeItem('visitedTags');
            this.$store.commit('DELALL_VISITED_VIEWS')
            this.alertMsg("退出成功!");
            this.toUrl('/login')
          }
        }
    }
</script>
