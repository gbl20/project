import reject from '@/components/ware/unqualified/reject'
import rejectBook from '@/components/ware/unqualified/reject_book'
export default[
  {
    path:'/reject',
    name:'reject',
    component:reject,
    meta:{
      title:'不合格药品报告确认表',
      keepAlive:true
    }
  },
  {
    path:'/reject_book',
    name:'rejectBook',
    component:rejectBook,
    meta:{
      title:'不合格药品台账',
      keepAlive:true
    }
  }
]
