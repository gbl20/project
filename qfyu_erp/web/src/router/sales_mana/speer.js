import SelSpeer from '@/components/sales_mana/speer/index'
import SelSpeerEdit from '@/components/sales_mana/speer/edit'

export default[
  {
    path:'/sel_speer',
    name:'sel_speer',
    component:SelSpeer,
    meta: {
      title: '销售报价单',
      keepAlive: true
    }
  },
  {
    path:'/sel_speer_edit',
    name:'sel_speer_edit',
    component:SelSpeerEdit,
    meta: {
      title: '编辑报价单',
      keepAlive: true
    }
  }

]
