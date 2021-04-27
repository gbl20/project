import FirstVarietyList from '@/components/gsp/first_variety/list'
import NewVarietyGoods from '@/components/gsp/first_variety/newVarietyGoods'
export default[
  {
    path:'/first_variety_list',
    name:'FirstVarietyList',
    component:FirstVarietyList,
    meta: {
      title: '首营品种管理',
      keepAlive: true,
      isBack:false
    }
  },
  {
    path:'/new_variety_goods',
    name:'NewVarietyGoods',
    component:NewVarietyGoods,
    meta: {
      title: '首营品种申请',
      keepAlive: true,
      isBack:false
    }
  }
]
