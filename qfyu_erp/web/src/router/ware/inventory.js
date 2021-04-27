import accstock from '@/components/ware/inventory/accstock'
import editAccstock from '@/components/ware/inventory/edit_accstock'
import realstock from '@/components/ware/inventory/realstock'
import editRealstock from '@/components/ware/inventory/edit_realstock'
import immediate from '@/components/ware/inventory/immediate'
import editAcconline from '@/components/ware/inventory/edit_acconline'
import whole from '@/components/ware/inventory/whole'
import editWhole from '@/components/ware/inventory/edit_whole'
export default[
  {
    path:'/accstock',
    name:'accstock',
    component:accstock,
    meta:{
      title:'账面库存结存单',
      keepAlive:true
    }
  },
  {
    path:'/edit_accstock',
    name:'editAccstock',
    component:editAccstock,
    meta:{
      title:'编辑结存单',
      keepAlive:true
    }
  },
  {
    path:'/realstock',
    name:'realstock',
    component:realstock,
    meta:{
      title:'实物盘点单',
      keepAlive:true
    }
  },
  {
    path:'/edit_realstock',
    name:'editRealstock',
    component:editRealstock,
    meta:{
      title:'编辑实物盘点单',
      keepAlive:true
    }
  },
  {
    path:'/immediate',
    name:'immediate',
    component:immediate,
    meta:{
      title:'即时盘点单',
      keepAlive:true
    }
  },
  {
    path:'/edit_acconline',
    name:'editAcconline',
    component:editAcconline,
    meta:{
      title:'编辑即时盘点单',
      keepAlive:true
    }
  },
  {
    path:'/whole',
    name:'whole',
    component:whole,
    meta:{
      title:'整库盘点单',
      keepAlive:true
    }
  },
  {
    path:'/edit_whole',
    name:'editWhole',
    component:editWhole,
    meta:{
      title:'编辑整仓盘点单',
      keepAlive:true
    }
  }
]
