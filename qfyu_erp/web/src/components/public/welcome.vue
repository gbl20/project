<template>
  <div class="bg-m">
    <div class="w-main bg-m">
      <div class="t-main">
        <div class="c-l-msg">
          <div class="company-name">庆丰裕ERP，欢迎登陆本系统！</div>
          <div class="last-log">上次登陆：2020年07月07日 16时16分</div>
          <div class="ver-code">V8.3.1.127 DBV20200707</div>
          <div class="company">庆丰裕医药ERP经营管理系统</div>
          <div class="now-date">
            <div>星期一</div>
            <div>2020/08/01</div>
          </div>
        </div>
      </div>
      <div class="c-l-bottom" :style="'height:'+($store.state.MainH-170)+'px;'">
        <div class="left bg">
          <a href="javascript:;" @click="lNav()" class="n-item txt-color">资料管理</a>
          <a href="javascript:;" @click="lNav()" class="n-item txt-color">采购管理</a>
          <a href="javascript:;" @click="lNav()" class="n-item txt-color cur">销售管理</a>
          <a href="javascript:;" @click="lNav()" class="n-item txt-color">采购管理</a>
          <a href="javascript:;" @click="lNav()" class="n-item txt-color">仓库管理</a>
          <a href="javascript:;" @click="lNav()" class="n-item txt-color">财务管理</a>
          <a href="javascript:;" @click="lNav()" class="n-item txt-color">GSP</a>
        </div>
        <div class="mid-con">
          <div class="mid-c-m bg">
            <div class="title border-b txt-color">销售管理</div>
            <div class="c-flow">

            </div>
          </div>
        </div>
        <div class="right bg">
          <div class="title border-b txt-color">其它管理</div>
          <div class="c-flow">

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="less">
  @import '~@/assets/public/css/welcome';
</style>
<script>
  var _this;
export default {
  data() {
    return {

    }
  },
  mounted() {
    _this = this;
  },
  created() {

  },
  methods: {

    lNav:function(){

    }

  }
};
</script>
