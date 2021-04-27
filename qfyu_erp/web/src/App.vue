<template>
    <div id="app" :class="'layout '+ThemeClass">
      </Layout>
        <Header v-if="isHeader"></Header>
        <Content class="main-s" :style="'height:'+(isHeader?MainH:(Client_Height+68))+'px;'">
          <div class="m-s-con">
            <keep-alive :exclude="$store.state.tagsview.excludeAlive">
              <router-view v-if="$route.meta.keepAlive && isRouterAlive">
              </router-view>
            </keep-alive>
            <router-view v-if="!$route.meta.keepAlive && isRouterAlive">
            </router-view>
          </div>
        </Content>
        <Footer v-if="isHeader"></Footer>
      </layout>
    </div>
</template>
<script>
  import Header from '@/components/public/header.vue'
  import Footer from '@/components/public/footer.vue'
  export default {
    components:{ Header,Footer},
    name: 'App',
    data(){
      return {
        isHeader:false,
        isRouterAlive: true,
        initAppStatus:false
      }
    },
    provide () {
      return {
        reload: this.reload
      }
    },
    computed:{
      Client_Height(){
        return this.$store.state.Client_Height;
      },
      ThemeClass(){
        return this.$store.state.ThemeClass;
      },
      MainH(){
        return this.$store.state.MainH;
      },
      visitedViews() {
        return this.$store.state.tagsview.visitedviews;
      }
    },
    watch:{
      ThemeClass(e){
        document.getElementsByTagName('body')[0].className = e
      },
      visitedViews(e){
        if(e.length > 0) localStorage.visitedTags = JSON.stringify(e);
      },
      '$route.path':function(newVal,oldVal){
        if(newVal !== '/login') this.$store.dispatch("addVisitedViews", this.$route);
        if(newVal === '/login') this.isHeader = false;
        else if(!localStorage.token){
          this.isHeader = false;
          this.$router.push({ path:'/login'  })
        }else{
          if(!this.isHeader) this.isHeader = true;
        }
      },
      isHeader(e){
        if(e && !this.initAppStatus) this.initApp();
      }
    },
    mounted:function(){
      if(this.isHeader && !this.initAppStatus) this.initApp();
     // this.stopF5Refresh();
      document.getElementsByTagName('body')[0].className = this.$store.state.ThemeClass
      var visitedTags = localStorage.visitedTags;
      if(visitedTags != 'undefined' && visitedTags){
         visitedTags = JSON.parse(visitedTags);
      }else visitedTags = [{path:'/',name:'工作台',title:'工作台'}];
      this.$store.commit('SAVE_VISITED_VIEWS',visitedTags)
      if(this.$route.path == '/login') this.isHeader = false;
      else{
        this.$store.dispatch("addVisitedViews", this.$route);
        if(!this.isHeader) this.isHeader = true;
      }
      if(!localStorage.token) this.$router.push({ path:'/login'  })
      _.debounce(this.setHeight,500)();
      window.onresize = ()=>{
        return (() => {
           this.setHeight();
        })()
      }
    },
    methods:{
      initApp(){
        if(this.initAppStatus) return false;
        let _this = this;
        this.common.http({
          url: 'initApp',
        }).then(function (res) {
          if(res.status == 1){
             _this.$store.commit('upSYS',res)
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      setHeight(){
        var clientHeight = document.documentElement.clientHeight - 68;
        this.$store.commit('upHeight',clientHeight)
      },
      reload () {
        if(!this.isRouterAlive) return false;
        this.isRouterAlive = false
        this.$nextTick(() => {
          this.isRouterAlive = true
        })
      },
      stopF5Refresh() {
       window.onbeforeunload = function (e) {
         e = e || window.event;
         if (e) {
           e.returnValue = '关闭提示';
         }
          return '关闭提示';
       };
      },
    }
  }
</script>
