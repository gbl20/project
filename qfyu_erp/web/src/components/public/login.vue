<template>
  <div :style="'padding-top:'+($store.state.Client_Height-640)/2+'px'">
    <div class="login-m">
      <div class="left-m">
        <div class="erp-logo">
          <img src="@/assets/public/img/erp-logo.png" alt="">
        </div>
        <div class="img-m"><img src="@/assets/public/img/login-m.png" alt=""></div>
      </div>
      <div class="right-m bg">
        <div class="login-item">
          <div class="title txt-color">庆丰裕医药ERP管理系统</div>
          <Form ref="loginData" :model="loginData" :rules="rules">
            <FormItem prop="acc">
              <Select size="large" v-model="loginData.acc" placeholder="请选择账套">
                <span class="icon iconfont" slot="prefix">&#xe7ae;</span>
                <Option v-for="(item,index) in database_list" :key="index" :value="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem prop="user">
              <Input type="text" v-model="loginData.user" placeholder="用户编号" size="large" maxlength='18'>
                <span class="icon iconfont" slot="prefix">&#xe7ae;</span>
              </Input>
            </FormItem>
            <FormItem prop="pwd">
              <Input type="password" v-model="loginData.pwd" placeholder="登录口令" size="large" maxlength='15'>
                <span class="icon iconfont" slot="prefix">&#xe7c9;</span>
              </Input>
            </FormItem>
            <FormItem>
              <Button size="large" type="primary" @click="handleSubmit('loginData')">登录</Button>
            </FormItem>
          </Form>
        </div>
      </div>
    </div>
  </div>

</template>
<style lang="less">
    @import '~@/assets/public/css/login';
</style>
<script>
  var _this;
  import crypto from 'crypto'
export default {
  data() {
    return {
      loginData: {
        user:"",
        pwd: "",
        acc:0
      },
      database_list:null,
      rules: {
        acc: [
          {required: true,message: "请选择账套", trigger: "change"}
        ],
        user: [
          {required: true,message: "请输入有效的用户编号", trigger: "blur"}
        ],
        pwd: [
          {required: true, message: "请输入登录口令",trigger: "blur"},
          {type: "string",min: 6,message: "口令长度不能小于6位", trigger: "blur"}
        ]
      }
    };
  },
  mounted() {
    _this = this;
    if(localStorage.getItem("token")) this.$router.push({ path: "/" });
    this.init();
  },
  methods: {
    init:function(){
      _this.common.http({
        url: 'loginInit'
      }).then(function (res) {
        if(res.status == 1) _this.database_list = res.data;
      }).catch(function(err){
        _this.common.httpErr(err.data,_this);
      })
    },
    handleSubmit:function(name) {
      this.$refs[name].validate(valid => {
        if (valid) {
          const md5 = crypto.createHash('md5')
          md5.update(_this.common.md5Salt+_this.loginData.pwd)
          var passwd = md5.digest('hex');
          _this.common.http({
            url: 'login',data:{user:_this.loginData.user,passwd:passwd,login_acc:_this.loginData.acc}
          }).then(function (res) {
            if(res.status == 1){
              _this.alertMsg("恭喜你，登录成功!");
              _this.$store.commit('upToken',res.token)
              localStorage.setItem("token", res.token);
              localStorage.setItem("acc", res.acc);
              _this.$router.push({ path: "/" });
            }else _this.alertMsg(res.msg,'error');
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        }
      });
    }
  }
};
</script>
