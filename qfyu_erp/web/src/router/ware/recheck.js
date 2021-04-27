import recheckList from '@/components/ware/recheck/recheckList'
import editReCheck from '@/components/ware/recheck/editReCheck'

export default[
  {
    path:'/recheckList',
    name:'recheckList',
    component:recheckList,
    meta:{
      title:'验收入库查询',
      keepAlive:true
    }
  },
  {
    path:'/editReCheck',
    name:'editReCheck',
    component:editReCheck,
    meta: {
      title:'验收入库/复核',
      keepAlive:true
    }
  }
]
