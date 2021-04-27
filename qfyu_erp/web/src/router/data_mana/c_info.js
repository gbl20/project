import Clist from '@/components/data_mana/customer/cinfo/list.vue'
import Cedit from '@/components/data_mana/customer/cinfo/edit.vue'

export default[
  {
    path: '/customer',
    name: 'customer',
    component: Clist,
    meta: {
      title: '客户资料',
      keepAlive: true,
    }
  },
  {
    path: '/edit_customer',
    name: 'editCustomer',
    component: Cedit,
    meta: {
      title: '编辑客户',
      keepAlive: true,
    }
  }
]
