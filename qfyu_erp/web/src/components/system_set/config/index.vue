<template>
	<div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser"></div>
      <div slot="table-list">
        <Tabs :animated="false" @on-click="clickTabs" v-model="name">
          <TabPane name="1" label="系统运行参数设定">
            <config-set ref="configSet" :height="height"></config-set>
          </TabPane>
          <TabPane name="2" label="业务参数设置">
            <sales-data ref="salesData"></sales-data>
          </TabPane>
          <TabPane name="3" label="数据类型及访问规则">
            <data-type ref="dataType"></data-type>
          </TabPane>
          <TabPane name="4" label="常用参考资料">
            <reference-data ref="referenceData" :height="height"></reference-data>
          </TabPane>
        </Tabs>
      </div>
    </split-none>
  </div>
</template>

<script>
  import splitNone from "@/components/public/splitNone"
  import configSet from "@/components/system_set/config/configSet"
  import salesData from "@/components/system_set/config/salesData"
  import dataType from "@/components/system_set/config/dataType"
  import referenceData from "@/components/system_set/config/referenceData"
	export default {
    components:{
      splitNone,configSet,salesData,dataType,referenceData
    },
	  data(){
	    return{
        Breadcrumb:[{title:'系统管理'},{title:'系统设置'}],
        height:0,
        name:"1"
      }
    },
    methods:{
      clickTabs:function(name){
        if (name==1){
          this.$refs.configSet.init();
        }else if (name==2){
          this.$refs.salesData.init();
        }else if (name==3){
          this.$refs.dataType.init();
        }else if(name==4){
          this.$refs.referenceData.init();
        }
      },
      DHeight:function (e) {
        var height = e;
        this.height = height-48;
      }
    }
	}
</script>

<style scoped>

</style>
