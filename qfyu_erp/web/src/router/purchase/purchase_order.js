import purOrderList from '@/components/purchase/order/purOrderList'
import editPurOrder from '@/components/purchase/order/editPurOrder'
export default[
  {
    path:'/purOrderList',
    name:'purOrderList',
    component:purOrderList,
    meta: {
      title:'采购订单',
      keepAlive:true
    }
  },
  {
    path:'/editPurOrder',
    name:'editPurOrder',
    component:editPurOrder,
    meta: {
      title:'创建采购订单',
      keepAlive:true
    }
  }
]
