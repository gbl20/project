import SalesContract from '@/components/sales_mana/contract/index'

export default[
  {
    path:'/sales_contract',
    name:'sales_contract',
    component:SalesContract,
    meta: {
      title: '销售合同',
      keepAlive: true
    }
  }

]
