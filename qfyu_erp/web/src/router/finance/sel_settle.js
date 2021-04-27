import SelSettleList from "@/components/finance/sel_settle/list"
import SelSettleDtl from "@/components/finance/sel_settle/dtl"

export default [
  {
    path:'/selSettleList',
    name:'SelSettleList',
    component:SelSettleList,
    meta:{
      title:'销售结算查询',
      keepAlive:true
    }
  },
  {
    path:'/selSettleDtl',
    name:'SelSettleDtl',
    component:SelSettleDtl,
    meta:{
      title:'销售结算明细',
      keepAlive:true
    }
  }
]
