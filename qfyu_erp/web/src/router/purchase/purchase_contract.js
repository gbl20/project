import contractList from '@/components/purchase/contract/contractList'
import editContract from '@/components/purchase/contract/editContract'
export default[
  {
    path:'/contractList',
    name:'contractList',
    component:contractList,
    meta: {
      title:'采购合同',
      keepAlive:true
    }
  },
  {
    path:'/editContract',
    name:'editContract',
    component:editContract,
    meta: {
      title:'创建采购合同',
      keepAlive:true
    }
  }

]
