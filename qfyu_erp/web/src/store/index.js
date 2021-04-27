import Vue from 'vue'
import Vuex from 'vuex'

import tagsview from './tagsview'
Vue.use(Vuex)
const getters = {
   visitedviews: state => state.tagsview.visitedviews,
};

export default new Vuex.Store({
   modules: {
    tagsview
  },
  getters,
  state: {
    Client_Height:document.documentElement.clientHeight - 48,
    HeaderH:48,
    MainH:document.documentElement.clientHeight - 48,
    ThemeClass:'theme'+(localStorage.ThemeType||1),
    token:localStorage.getItem("token") || null,
    emp:[],sysParam:[],sysConfig:[],depart:[],settlement:[],inoutKind:[]
  },
  mutations: {
    upHeight(state,clientHeight){
      state.Client_Height = clientHeight;
      state.MainH = clientHeight - state.HeaderH;
    },
    upTheme(state,ThemeType){
      state.ThemeClass = 'theme'+ ThemeType;
    },
    upToken(state,token){
      state.token = token;
    },
    upSYS(state,val){
      state.emp = val.emp;
      state.sysParam = val.sysParam;
      state.sysConfig = val.sysConfig;
      state.depart = val.depart;
      state.settlement = val.settlement;
      state.inoutKind = val.inoutKind;
    }
  },
  getters: {
     getMainH: state => state.Client_Height - state.HeaderH
  }
})
