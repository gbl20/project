<template>
  <div class="header-m">
    <Header>
     <div class="h-m-main">
         <div class="layout-logo"><img src="@/assets/public/img/logo-h.png" alt=""></div>
         <div class="layout-nav bg">
          <a class="menu-list bg-text" href="javascript:;" @click="toUrl('/')">工作台</a>
          <Dropdown v-if="menuList" transfer-class-name="dropdown-main" trigger="click" v-for="(item,index) in menuList" :name="item.id" :key="index" @on-click="clickM">
             <a class="menu-list bg-text" @click="curIndex=index" href="javascript:;">{{item.name}}<span class="icon iconfont">&#xe8ec;</span></a>
             <DropdownMenu slot="list" v-if="item.next_menu.length > 0">
               <div v-for="(v,k) in item.next_menu" :key="k" class="d-list-item">
                 <DropdownItem v-if="!v.next_menu.length" :name="index+','+k" :divided="true"><span class="t-name">{{v.name}}</span></DropdownItem>
                 <Dropdown v-else placement="right-start">
                     <DropdownItem name="-1">
                         <span class="t-name">{{v.name}}</span>
                         <span class="icon iconfont">&#xe7eb;</span>
                     </DropdownItem>
                     <DropdownMenu slot="list">
                         <DropdownItem v-for="(vv,kk) in v.next_menu" :key="kk" :name="index+','+k+','+kk"><span class="t-name">{{vv.name}}</span></DropdownItem>
                     </DropdownMenu>
                 </Dropdown>
               </div>
             </DropdownMenu>
           </Dropdown>
           <a class="menu-list bg-text" href="javascript:;" @click="quickEntry">快捷入口</a>
         </div>
     </div>
    </Header>
    <Drawer title="快捷菜单" :closable="false" v-model="value1">
       <Button class="bottom-s" @click="tabTheme(2)">白色</Button>
       <Button class="bottom-s" @click="tabTheme(1)">黑色</Button>
       <Button class="bottom-s" to="/" ghost>welcome</Button>
       <Button class="bottom-s" to="/demo" ghost replace>demo</Button>
       <Button class="bottom-s" to="/demo" ghost target="_blank">New demo</Button>
    </Drawer>
  </div>
</template>
<style lang="less">
  @import '~@/assets/public/css/header';
</style>
<script>
  export default {
    data () {
        return {
          menuList:null,
          curIndex:-1,
          value1:false,
        }
    },
    computed:{
      token(){
        return this.$store.state.token;
      }
    },
    watch: {
      token(e) {
        if(e) this.init();
      }
    },
    mounted() {
      if(localStorage.token) this.init();
    },
    methods:{
      init:function(){
        let _this = this;
        this.common.http({
          url: 'getMenu',
        }).then(function (res) {
          if(res.status == 1){
             _this.menuList = res.menu;
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      tabTheme:function(type){
        if(localStorage.ThemeType != type){
          localStorage.ThemeType = type;
          this.$store.commit('upTheme',type)
        }
      },
      clickM:function(name){
        if(name == -1) return false;
        var strs = name.split(",");
        var url = null;
        switch(strs.length){
          case 1:
            url = this.menuList[strs[0]].url;
            break;
          case 2:
            url = this.menuList[strs[0]].next_menu[strs[1]].url;
            break;
          case 3:
            url = this.menuList[strs[0]].next_menu[strs[1]].next_menu[strs[2]].url;
            break;
        }
        if(url && url.length > 0) this.toUrl(url);
      },
      quickEntry:function(){
          this.value1 = true;
      },
    }
  }
</script>
