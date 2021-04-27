import recheck from './recheck.js'
import inventory from './inventory.js'
import goodsinout from './goodsinout.js'
import stockout from './stockout.js'
import doubt from './doubt.js'

export default[
  ...recheck, //验收入库/复核
  ...inventory,//库存盘点
  ...goodsinout, //商品出入库查询
  ...stockout, //出库登记、复核
  ...doubt, //质量疑问商品、不合格商品
]
