import PchSettleList from '@/components/finance/pch_settle/PchSettleList'
import EditPchSettle from '@/components/finance/pch_settle/EditPchSettle'

export default[
  {
    path:'/PchSettleList',
    name:'PchSettleList',
    component:PchSettleList,
    meta: {
      title:'采购结算单查询',
      keepAlive:true
    }
  },
  {
    path:'/EditPchSettle',
    name:'EditPchSettle',
    component:EditPchSettle,
    meta: {
      title:'采购结算单',
      keepAlive:true
    }
  }
]
