import WareList from '@/components/data_mana/warehouse/warelist'

export default[
  {
    path:'/warelist',
    name:'warelist',
    component:WareList,
    meta: {
      title:'仓库及库位管理',
      keepAlive: true,
      isBack:false
    }
  }
]
