import RejectionList from '@/components/purchase/rejection/list'
import RejectionEdit from '@/components/purchase/rejection/edit'

export default [
  {
    path:'/RejectionList',
    name:'RejectionList',
    component:RejectionList,
    meta:{
      title:'来货拒收列表',
      keepAlive:true
    }
  },
  {
    path:'/RejectionEdit',
    name:'RejectionEdit',
    component:RejectionEdit,
    meta: {
      title:'来货拒收',
      keepAlive:true
    }
  }
]
