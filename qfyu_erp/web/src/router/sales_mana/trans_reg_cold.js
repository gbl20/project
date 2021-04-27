import TransReg from '@/components/sales_mana/trans_reg_cold/index'
import TransRegEdit from '@/components/sales_mana/trans_reg_cold/edit'

export default[
  {
    path:'/trans_reg_cold',
    name:'trans_reg_cold',
    component:TransReg,
    meta: {
      title: '冷藏药品运输登记查询',
      keepAlive: true
    }
  },
  {
    path:'/trans_reg_cold_edit',
    name:'trans_reg_cold_edit',
    component:TransRegEdit,
    meta: {
      title: '冷藏药品运输登记',
      keepAlive: true
    }
  }
]
