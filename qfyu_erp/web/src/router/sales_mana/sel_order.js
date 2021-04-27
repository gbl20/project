import SelOrder from '@/components/sales_mana/sel_order/index'
import SelOrderEdit from '@/components/sales_mana/sel_order/edit'

export default[
  {
    path:'/sel_order',
    name:'sel_order',
    component:SelOrder,
    meta: {
      title: '销售订单',
      keepAlive: true
    }
  },
  {
    path:'/sel_order_edit',
    name:'sel_order_edit',
    component:SelOrderEdit,
    meta: {
      title: '编辑销售订单',
      keepAlive: true
    }
  }

]
