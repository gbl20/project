import SelRetDemandList from "@/components/sales_mana/sel_ret_demand/index"
import SelRetDemandEdit from "@/components/sales_mana/sel_ret_demand/edit"

export default[
  {
    path:'/SelRetDemandList',
    name:'SelRetDemandList',
    component:SelRetDemandList,
    meta:{
      title:'销售退回申请查询',
      keepAlive:true
    }
  },
  {
    path:'/SelRetDemandEdit',
    name:'SelRetDemandEdit',
    component:SelRetDemandEdit,
    meta:{
      title:'销售退回申请明细',
      keepAlive:true
    }
  }
]
