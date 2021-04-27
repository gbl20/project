import PurchasePlan from '@/components/purchase/plan/purchasePlan'
import editPurPlan from '@/components/purchase/plan/editPurPlan'

export default[
  {
    path:'/purchasePlan',
    name:'purchasePlan',
    component:PurchasePlan,
    meta: {
      title:'采购计划',
      keepAlive:true,
    }
  },
  {
    path:'/editPurPlan',
    name:'editPurPlan',
    component:editPurPlan,
    meta: {
      title:'创建采购计划',
      keepAlive:true,
    }
  }
]
