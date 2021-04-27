<template id="">
  <div class="tags-view">
      <a href="javascript:;" @click="MoveNav(false,0)" class="t-v-item tag-nav tag-nav-l"><span class="iconfont">&#xe7ec;</span></a>
      <div class="t-v-main" ref="TVMain">
        <div class="t-v-wrap bg-m" ref="TVWrap" :style="'left:-'+TVWrapLeft+'px'">
          <div :ref="isActive({path:'/'})?'TVItemCur':''" :class="'t-v-item'+(isActive({path:'/'})?' cur':'')">
            <router-link to="/" tag="div">工作台</router-link>
          </div>
          <div v-for="tag in Array.from(visitedViews)" :key="tag.path" :ref="isActive(tag)?'TVItemCur':''" :class="'t-v-item'+(isActive(tag)?' cur':'')" v-if="tag.path != '/'">
            <router-link :to="tag.path" tag="div">
              {{tag.title}}<span class="iconfont" @click.prevent.stop="delSelectTag(tag)">&#xe7fd;</span>
            </router-link>
          </div>
        </div>
      </div>
      <a href="javascript:;" @click="MoveNav(true,0)" class="t-v-item tag-nav tag-nav-r"><span class="iconfont">&#xe7eb;</span></a>
  </div>
</template>
<script>
  export default {
    computed: {
      visitedViews(){
        return this.$store.state.tagsview.visitedviews;
      }
    },
    watch:{
      $route(e){
        this.upDataLeft();
      },
      visitedViews(e){
        let _this = this;
        if(Object.keys(e).length < this.visitedviewsLength){
          if (_this.isActive(_this.$route)) {
            let lastView = e.slice(-1)[0];
            if (lastView) _this.$router.push({path:lastView.path});
            else _this.$router.push({path:"/"});
          }else _this.$router.push({path:"/"});
        }
        this.upDataLeft();
        this.visitedviewsLength = Object.keys(e).length;
      }
    },
    data () {
      return {
        TVWrapLeft:0,
        leftWidth:0,
        visitedviewsLength:this.$store.state.tagsview.visitedviews.length
      }
    },
    methods: {
      upDataLeft:function(){
        let _this = this;
        setTimeout(function(){
          let TVItemCurObj = _this.$refs.TVItemCur;
          if(_this.$route.path == '/'){
            _this.MoveNav(false,0)
          }else{
            let Mwidth = _this.$refs.TVMain.offsetWidth;
            let TVWrapWidth = _this.$refs.TVWrap.offsetWidth;
            let offsetLeft = TVItemCurObj.offsetLeft ;
            let offsetWidth = TVItemCurObj.offsetWidth;
            if(TVWrapWidth < Mwidth) _this.MoveNav(false,0);
            else{
              if((offsetLeft+offsetWidth) > Mwidth) _this.MoveNav(false,offsetLeft-Mwidth+offsetWidth);
              else if((offsetLeft-10) < _this.TVWrapLeft) _this.MoveNav(false,offsetLeft - 10);
            }
          }
        },100)
      },
      isActive(route){
        return route.path == this.$route.path;
      },
      delSelectTag(route){
        this.$store.dispatch("delVisitedViews", route);
      },
      MoveNav:function(type,TVWrapLeft){
        let Mwidth = this.$refs.TVMain.offsetWidth;
        let Wwidth = this.$refs.TVWrap.offsetWidth;
        let leftWidth = Wwidth - Mwidth;
        TVWrapLeft = TVWrapLeft || 0;
        if(TVWrapLeft == 0){
          if(type){
            TVWrapLeft = this.TVWrapLeft + Mwidth/2;
          }else{
            TVWrapLeft = this.TVWrapLeft - Mwidth/2;
          }
        }
        if(TVWrapLeft > leftWidth) TVWrapLeft = leftWidth;
        else if(TVWrapLeft < 0) TVWrapLeft = 0;
        this.TVWrapLeft = TVWrapLeft;
      }
    }
  };
</script>
<style lang="less">
  .tags-view{
    position: relative;z-index: 1;width:100%;height: 36px;
    .tag-nav{
      display: block;width: 24px;height: 24px;font-size: 12px;position: absolute;z-index: 2;top:6px;text-align: center;line-height: 24px;
      &-l{
        left: 0;
      }
      &-r{
        right: 0;
      }
    }
    .t-v-main{
      width: auto; height: 36px;padding:6px 0; position: absolute;left: 30px;right: 30px;overflow: hidden;
      .t-v-wrap {
        display: inline-block;position: absolute; overflow: visible;white-space: nowrap;
        .t-v-item {
          height: 24px; line-height: 24px;display: inline-block;padding: 0px 10px;border-radius: 5px;margin: 0 3px;font-size: 12px;
          div{
            cursor: pointer;
          }
          .iconfont{
            font-size: 12px;
          }
        }
      }
    }
  }
</style>
