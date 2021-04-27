import TransReg from '@/components/sales_mana/trans_reg/index'
import TransRegEdit from '@/components/sales_mana/trans_reg/edit'

export default[
  {
    path:'/trans_reg',
    name:'trans_reg',
    component:TransReg,
    meta: {
      title: '销售发货运输登记查询',
      keepAlive: true
    }
  },
  {
    path:'/trans_reg_edit',
    name:'trans_reg_edit',
    component:TransRegEdit,
    meta: {
      title: '销售发货运输登记',
      keepAlive: true
    }
  }
]
