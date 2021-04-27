import SelPayList from "@/components/finance/sel_pay/list"
import SelPayDtl from "@/components/finance/sel_pay/dtl"

export default[
  {
    path:'/selPayList',
    name:'SelPayList',
    component:SelPayList,
    meta:{
      title:'销售收款查询',
      keepAlive:true
    }
  },
  {
    path: '/SelPayDtl',
    name:'SelPayDtl',
    component:SelPayDtl,
    meta:{
      title:'销售收款明细',
      keepAlive:true
    }
  }
]
