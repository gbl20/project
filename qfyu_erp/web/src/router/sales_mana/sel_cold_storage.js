import SelColdStorageList from '@/components/sales_mana/sel_cold_storage/index'
import SelColdStorageEdit from '@/components/sales_mana/sel_cold_storage/edit'

export default [
  {
    path:'/SelColdStorageList',
    name:'SelColdStorageList',
    component:SelColdStorageList,
    meta:{
      title:'冷藏药品销退收货登记查询',
      keepAlive:true
    }
  },
  {
    path: '/SelColdStorageEdit',
    name: 'SelColdStorageEdit',
    component: SelColdStorageEdit,
    meta: {
      title:'冷藏药品销退收货登记明细',
      keepAlive: true
    }
  }
]
