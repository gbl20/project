import custExam from '@/components/gsp/customer_exam/custExam'
export default[
  {
    path:'/customer_exam',
    name:'custExam',
    component:custExam,
    meta: {
      title: '客户资质审核',
      keepAlive: true
    }
  }
]
