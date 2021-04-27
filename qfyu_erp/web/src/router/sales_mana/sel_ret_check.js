import SelRetCheckList from "@/components/sales_mana/sel_ret_check/index"
import SelRetCheckEdit from "@/components/sales_mana/sel_ret_check/edit"

export default[
  {
    path:'/SelRetCheckList',
    name:'SelRetCheckList',
    component:SelRetCheckList,
    meta:{
      title:'销售退回登记查询',
      keepAlive:true
    }
  },
  {
    path:'/SelRetCheckEdit',
    name:'SelRetCheckEdit',
    component:SelRetCheckEdit,
    meta:{
      title:'销售退回登记明细',
      keepAlive:true
    }
  }
]
