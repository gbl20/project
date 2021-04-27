import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store';
import common from '@/assets/public/js/common.js'
import custRender from '@/assets/public/js/custRender.js'
import 'babel-polyfill'
import ViewUI from 'view-design';
import Lodash from 'lodash'
import '@/assets/my-theme/color.less'
import axios from 'axios'
import Viewer from 'v-viewer'
import 'viewerjs/dist/viewer.css'
Vue.use(ViewUI);
Vue.use(Viewer, {
  defaultOptions: {
    zIndex: 9999
  }
})
Vue.config.productionTip = false
Vue.prototype.common = common;
Vue.prototype.custRender = custRender;
Vue.prototype._ = Lodash;
import '@/assets/public/icon/iconfont.css';
new Vue({
  el: '#app',
  router,store,
  components: { App },
  template: '<App/>',
  watch: {

  }
})
Vue.prototype.toUrl = function (url, query) {
  const defaultQuery = {};
  const queryObj = {
    ...defaultQuery,
    ...query
  };
  this.$router.push({ path: url, query: queryObj })
};

/**
 * Message 全局提示
 * @param {Object} msg 提示语
 * @param {Object} errorType 'error、success、warning、info、loading'
 * @param {Object} option 关闭回调方法
 */
Vue.prototype.alertMsg = function(msg,errorType,option){
  errorType = errorType || 'success';
  if(option && typeof(option.duration)!="undefined") var duration=option.duration;
  else duration=1.5;
  var isClosable = (option && option.isClosable) || false,
  onCloseFun = (option && option.onCloseFun) || function(){};
  this.$Message[errorType](
    {
      content:msg,
      background :true,
      closable:isClosable,
      duration:duration,
      onClose: onCloseFun
  });
};
/**
 * Message modal 提示
 * @param {string} errorType 'info、success、warning、error'
 * @param {string} title
 * @param {string} content
 */
Vue.prototype.modalMsg = function(content,title,errorType,type){
  type = type || false;
  errorType = errorType || 'warning';
  title = title || '温馨提示';
  this.$Modal[errorType]({
    title: title,
    content: content
  });
};
/**
 * Message 格式化日式格式
 * @param {Date} 标准时间
 * @param {type} true 年-月-日 时：分：秒 false 年-月-日
 */
Vue.prototype.getDateVal = function (date,type) {
  date = date || null;
  type = type || false;
  if(date) date = new Date(date);
  else date = new Date();
  let y = date.getFullYear(),
      m = date.getMonth()+1,
      d = date.getDate(),
      h = date.getHours(),
      i = date.getMinutes(),
      s = date.getSeconds();
      m = m < 10 ? ('0'+m) : m;
      d = d < 10 ? ('0'+d) : d;
      h = h < 10 ? ('0'+h) : h;
      s = s < 10 ? ('0'+s) : s;
      if (type) {
        return y+'-'+m+'-'+d+' '+h+':'+i+':'+s;
      }else{
        return y+'-'+m+'-'+d;
      }
};
/**
 * 浮点型计算转换（四舍五入）
 * @param expression 数值或表达式
 * @param digit 转换位数
 */
Vue.prototype.formatFloat = function(expression,digit){
    var m = Math.pow(10,digit);
    return Math.round(expression * m) / m;
}

/**
 * 关闭页面
 */
Vue.prototype.delView = function(){
  this.$store.dispatch("delVisitedViews", this.$route);
}
/**
 * 比较两个数组 针对checkbox
 * @param {Object} pitchOnArr 选中数组
 * @param {Object} KnownArr 已知数组
 */
Vue.prototype.contrastArr = function(pitchOnArr,KnownArr) {
  let difTemp = []
  var resObj = {isCheckAll:false,isCheck:false};
  if(pitchOnArr === null || pitchOnArr === 'null') return resObj;
  else if(!pitchOnArr.length) return resObj;
  else{
    for (const item of KnownArr) {
      if(pitchOnArr.indexOf(item) === -1) difTemp.push(item)
      else resObj.isCheck = true;
    }
    if(!difTemp.length) resObj.isCheckAll = true;
    return resObj;
  }
}
