import Vue from 'vue'
import Router from 'vue-router'
import Public  from "./public/index.js"
import System  from "./system_set/index.js"
import DataMana  from "./data_mana/index.js"
import Gsp from "./gsp/index.js"
import Purchase from "./purchase/index.js"
import SalesMana from "./sales_mana/index.js"
import Ware from "./ware/index.js"
import Finance from "./finance/index.js"
import Unqualified from "./ware/unqualified.js"

Vue.use(Router)
const originalPush = Router.prototype.push
Router.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}
export default new Router({
  routes: [
      ...Public,//公共页面
      ...System,//系统设置
      ...DataMana,//资料管理
      ...Purchase,//采购管理
      ...Gsp, //GSP管理
      ...SalesMana, //销售管理
      ...Ware, //仓储物流
      ...Finance, //财务管理
      ...Unqualified, //不合格品
  ]
})
