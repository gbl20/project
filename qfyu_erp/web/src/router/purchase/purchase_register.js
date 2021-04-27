import List from "@/components/purchase/register/list"
import Edit from "@/components/purchase/register/edit"

export default [
  {
    path:'/registerList',
    name:'registerList',
    component:List,
    meta: {
      title:'来货登记',
      keepAlive:true,
    }
  },
  {
    path: '/registerEdit',
    name: 'registerEdit',
    component:Edit,
    meta: {
      title: '来货登记明细',
      keepAlive: true
    }
  }
]
