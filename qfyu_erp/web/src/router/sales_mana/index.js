import Contract from './contract.js'
import Speer from './speer.js'
import SelOrder from './sel_order.js'
import SelExport from './sel_export.js'
import SelRetDemand from './sel_ret_demand'
import SelRetCheck from './sel_ret_check'
import SelColdStorage from './sel_cold_storage'
import TransReg from './trans_reg.js'
import TransRegCold from './trans_reg_cold.js'
//import SelQualityAccept from './sel_quality_accept'

export default[
  ...Contract,
  ...Speer,
  ...SelOrder,
  ...SelExport,
  ...SelRetDemand,
  ...SelRetCheck,
  ...SelColdStorage,
  ...TransReg,
  ...TransRegCold,
 // ...SelQualityAccept,
]
