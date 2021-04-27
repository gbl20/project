import doubt from '@/components/ware/doubt/doubt'
import dealdoubt from '@/components/ware/doubt/dealdoubt'
export default[
  {
    path:'/doubt',
    name:'doubt',
    component:doubt,
    meta:{
      title:'质量疑问商品',
      keepAlive:true
    }
  },
  {
    path:'/dealdoubt',
    name:'dealdoubt',
    component:dealdoubt,
    meta:{
      title:'质量疑问锁定商品处理',
      keepAlive:true
    }
  }
]
