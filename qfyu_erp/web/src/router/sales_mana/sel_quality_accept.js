import SelQualityAcceptList from "@/components/sales_mana/sel_quality_accept/list"
import QualityAcceptDefault from "@/components/sales_mana/sel_quality_accept/QualityAcceptDefault"
import SelQualityAcceptGsp1 from "@/components/sales_mana/sel_quality_accept/GspType1"
import SelQualityAcceptGsp2 from "@/components/sales_mana/sel_quality_accept/GspType2"
import SelQualityAcceptGsp3 from "@/components/sales_mana/sel_quality_accept/GspType3"
import SelQualityAcceptGsp4 from "@/components/sales_mana/sel_quality_accept/GspType4"
import SelQualityAcceptGsp5 from "@/components/sales_mana/sel_quality_accept/GspType5"
import SelQualityAcceptGsp6 from "@/components/sales_mana/sel_quality_accept/GspType6"

export default [
  {
    path:'/SelQualityAcceptList',
    name:'SelQualityAcceptList',
    component:SelQualityAcceptList,
    meta:{
      title:'销售退回质量验收查询',
      keepAlive:true
    }
  },
  {
    path:'/QualityAcceptDefault',
    name:'QualityAcceptDefault',
    component:QualityAcceptDefault,
    meta:{
      title:'销退质量验收默认设置',
      keepAlive:false
    }
  },
  {
    path:'/SelQualityAcceptGsp1',
    name:'SelQualityAcceptGsp1',
    component:SelQualityAcceptGsp1,
    meta:{
      title:'【销退】普通药品质量验收',
      keepAlive:true
    }
  },
  {
    path:'/SelQualityAcceptGsp2',
    name:'SelQualityAcceptGsp2',
    component:SelQualityAcceptGsp2,
    meta:{
      title:'【销退】进口药品质量验收',
      keepAlive:true
    }
  },
  {
    path:'/SelQualityAcceptGsp3',
    name:'SelQualityAcceptGsp3',
    component:SelQualityAcceptGsp3,
    meta:{
      title:'【销退】医疗器械质量验收',
      keepAlive:true
    }
  },
  {
    path:'/SelQualityAcceptGsp4',
    name:'SelQualityAcceptGsp4',
    component:SelQualityAcceptGsp4,
    meta:{
      title:'【销退】中药饮片质量验收',
      keepAlive:true
    }
  },
  {
    path:'/SelQualityAcceptGsp5',
    name:'SelQualityAcceptGsp5',
    component:SelQualityAcceptGsp5,
    meta:{
      title:'【销退】特殊药品质量验收',
      keepAlive:true
    }
  },
  {
    path:'/SelQualityAcceptGsp6',
    name:'SelQualityAcceptGsp6',
    component:SelQualityAcceptGsp6,
    meta:{
      title:'【销退】非药品质量验收',
      keepAlive:true
    }
  }
]
