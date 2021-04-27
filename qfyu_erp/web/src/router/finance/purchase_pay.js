import PchPayList from '@/components/finance/pch_pay/PchPayList'
import EditPchPay from '@/components/finance/pch_pay/EditPchPay'

export default[
  {
    path:'/PchPayList',
    name:'PchPayList',
    component:PchPayList,
    meta: {
      title:'采购付款单查询',
      keepAlive:true,
    }
  },
  {
    path:'/EditPchPay',
    name:'EditPchPay',
    component:EditPchPay,
    meta: {
      title:'采购付款单',
      keepAlive:true,
    }
  }
]
