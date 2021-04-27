<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="table-list">
        <Tabs type="card" :animated="false" @on-click="CPane">
          <TabPane label="商品功能类别">
            <category  :height="height-30"></category>
          </TabPane>
          <TabPane label="商品许可经营类别">
            <permit-kinds ref="permitKindsRef"></permit-kinds>
          </TabPane>
          <TabPane label="自定义许可经营类别">
            <custom-kinds ref="customKindsRef"></custom-kinds>
          </TabPane>
        </Tabs>
      </div>
    </split-none>
  </div>
</template>

<script>
  import splitNone from '@/components/public/splitNone'
  import category from "@/components/data_mana/goods_category/category"
  import permitKinds from "@/components/data_mana/goods_category/permitKinds"
  import customKinds from "@/components/data_mana/goods_category/customKinds"
  export default {
    components:{
      splitNone,category,permitKinds,customKinds
    },
    data:function () {
      return{
        Breadcrumb:[{title:'资料管理'},{title:'商品类别管理'}],
        height:0
      }
    },
    methods:{
      CPane:function(index){
        if(index == 1) this.$refs.permitKindsRef.init();
        else if(index == 2) this.$refs.customKindsRef.init();
      },
      DHeight:function(e){
        this.height = e;
      }
    }
  }
</script>

<style lang="less">

</style>
