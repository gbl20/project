import FirstEnterprise from '@/components/gsp/first_enterprise/index'
import EditEnterprise from '@/components/gsp/first_enterprise/edit_enterprise'

export default[
  {
    path:'/first_enterprise',
    name:'FirstEnterprise',
    component:FirstEnterprise,
    meta: {
      title: '首营企业管理',
      keepAlive: true,
      isBack:false
    }
  },
  {
    path:'/edit_enterprise',
    name:'EditEnterprise',
    component:EditEnterprise,
    meta: {
      title: '首营企业申请',
      keepAlive: true
    }
  }

]
