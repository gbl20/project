import mData from './m_data.js'
import minfo from './minfo.js'
import Ware from './ware.js'
import supplier from './supplier.js'
import settlement from './settlement.js'
import Cinfo from './c_info.js'
import area from "./area.js"
import entrust from "./entrust.js"

export default[
  ...mData,//主要资料
  ...minfo,
  ...Ware, //仓库、库位管理
  ...supplier, //仓库、库位管理
  ...settlement, //结算方式
  ...Cinfo,//客户资料
  ...area,//地区资料
  ...entrust,//委托物流单位
]
