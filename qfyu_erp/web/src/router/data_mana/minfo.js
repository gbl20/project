import Commodity from '@/components/data_mana/goods_base/list'
import Pricesystem  from '@/components/data_mana/price_system/Pricesystem'
import Category from '@/components/data_mana/goods_category/index'

export default[

{
  path:'/commodity',
  name:'commodity',
  component:Commodity,
  meta: {
    title: '商品资料',
    keepAlive: true,
  }
},
{
  path:'/pricesystem',
  name:'pricesystem',
  component:Pricesystem,
  meta: {
    title: '价格体系管理',
    keepAlive: true,
  }
},
{
  path:'/category',
  name:'category',
  component:Category,
  meta: {
    title: '商品类别管理',
    keepAlive: true,
  }
},

]
