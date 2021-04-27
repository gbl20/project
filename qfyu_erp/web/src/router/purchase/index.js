import PurchaseLack from './purchase_lack.js'
import PurchasePlan from './purchase_plan.js'
import PurchaseOrder from './purchase_order.js'
import PurchaseContract from './purchase_contract.js'
import PurchaseRegister from './purchase_register.js'
import PurchaseQuality from './purchase_quality'
import PurchaseRejection from "./purchase_rejection"

export default[
  ...PurchaseLack, //缺货登记
  ...PurchasePlan, //采购计划
  ...PurchaseOrder, //采购订单
  ...PurchaseContract, //采购合同
  ...PurchaseRegister, //采购-来货登记
  ...PurchaseQuality,//质量验收
  ...PurchaseRejection,//来货拒收
]
