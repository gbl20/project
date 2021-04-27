import goodsCheckAcceptDefault from "@/components/purchase/quality_accept/goodsCheckAcceptDefault"
import QualityList from "@/components/purchase/quality_accept/list"
import GeneralMedicine from "@/components/purchase/quality_accept/GeneralMedicine"
import ImportedMedicines from "@/components/purchase/quality_accept/ImportedMedicines"
import InstrumentsMedical from "@/components/purchase/quality_accept/InstrumentsMedical"
import ChineseHerbalMedicine from "@/components/purchase/quality_accept/ChineseHerbalMedicine"
import SpecialMedicine from "@/components/purchase/quality_accept/SpecialMedicine"
import NonDrug from "@/components/purchase/quality_accept/NonDrug"
export default[
  {
    path:'/goodsCheckAcceptDefault',
    name:'goodsCheckAcceptDefault',
    component:goodsCheckAcceptDefault,
    meta:{
      title:'质量验收默认设置',
      keepAlive:true
    }
  },
  {
    path: '/qualityList',
    name: 'qualityList',
    component:QualityList,
    meta:{
      title:'质量验收查询',
      keepAlive:true
    }
  },
  {
    path:'/GeneralMedicine',
    name:'GeneralMedicine',
    component:GeneralMedicine,
    meta:{
      title:'普通药品质量验收',
      keepAlive:true
    }
  },
  {
    path:'/ImportedMedicines',
    name:'ImportedMedicines',
    component:ImportedMedicines,
    meta:{
      title:'进口药品质量验收',
      keepAlive:true
    }
  },
  {
    path:'/InstrumentsMedical',
    name:'InstrumentsMedical',
    component:InstrumentsMedical,
    meta:{
      title:'医疗器械质量验收',
      keepAlive:true
    }
  },
  {
    path:'/ChineseHerbalMedicine',
    name:'ChineseHerbalMedicine',
    component:ChineseHerbalMedicine,
    meta:{
      title:'中药饮片质量验收',
      keepAlive:true
    }
  },
  {
    path:'/SpecialMedicine',
    name:'SpecialMedicine',
    component:SpecialMedicine,
    meta:{
      title:'特殊药品质量验收',
      keepAlive:true
    }
  },
  {
    path:'/NonDrug',
    name:'NonDrug',
    component:NonDrug,
    meta:{
      title:'非药品质量验收',
      keepAlive:true
    }
  }
]
