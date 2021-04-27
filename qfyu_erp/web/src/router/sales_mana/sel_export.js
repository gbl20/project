import SelOrder from '@/components/sales_mana/sel_export/index'
import SelOrderEdit from '@/components/sales_mana/sel_export/edit'

export default[
  {
    path:'/sel_export',
    name:'sel_export',
    component:SelOrder,
    meta: {
      title: '销售开单',
      keepAlive: true
    }
  },
  {
    path:'/sel_export_edit',
    name:'sel_export_edit',
    component:SelOrderEdit,
    meta: {
      title: '编辑销售开单',
      keepAlive: true
    }
  }

]
