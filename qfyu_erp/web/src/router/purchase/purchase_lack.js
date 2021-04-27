import lackList from '@/components/purchase/lack/lackList'
import editPurLack from '@/components/purchase/lack/editPurLack'

export default[
  {
    path:'/lackList',
    name:'lackList',
    component:lackList,
    meta: {
      title:'缺货登记',
      keepAlive:true
    }
  },
  {
    path:'/editPurLack',
    name:'editPurLack',
    component:editPurLack,
    meta: {
      title:'提交缺货登记',
      keepAlive:true
    }
  },

]
