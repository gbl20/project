import PurchaseSettle from "./purchase_settle"
import PurchasePay from "./purchase_pay"
import SelSettle from "./sel_settle"
import SelPay from "./sel_pay"

export default[
  ...PurchaseSettle, //采购结算
  ...PurchasePay, //采购付款
  ...SelSettle, //销售结算
  ...SelPay, //销售收款

]
