import settlementList from '@/components/data_mana/settlement/settlementList'

export default[
  {
    path:'/settlement',
    name:'settlement',
    component:settlementList,
    meta: {
      title:'结算方式',
      keepAlive: true,
      isBack:false
    }
  }
]
