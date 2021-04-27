import StockOutList from '@/components/ware/stockout/StockOutList'
import editStockOut from '@/components/ware/stockout/editStockOut'

export default[
  {
    path:'/StockOutList',
    name:'StockOutList',
    component:StockOutList,
    meta:{
      title:'出库登记/复核查询',
      keepAlive:true
    }
  },
  {
    path:'/editStockOut',
    name:'editStockOut',
    component:editStockOut,
    meta:{
      title:'出库登记/复核',
      keepAlive:true
    }
  }
]
