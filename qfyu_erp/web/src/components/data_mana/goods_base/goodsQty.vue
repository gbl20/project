<template>
	<div>
    <Table border size="small" :columns="columns" :data="data" :height="height"></Table>
  </div>
</template>

<script>
	export default {
		name: "goodsQty",
    props:{
      height:0
    },
    data:function () {
      return{
        goods_code:null,
        columns:[
          {title:'仓库编号',key:'ware_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'仓库名称',key:'ware_title',width:160,minWidth:160,resizable:true,ellipsis:true},
          {title:'货位',key:'pos_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'数量',key:'qty',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'单价',key:'price1',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'金额',key:'amount',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'可用量',key:'qty',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'生产批号',key:'batch_no',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'有效日期',key:'valid_date',width:120,minWidth:120,resizable:true,ellipsis:true},
        ],
        data:[],
      }
    },
    methods:{
		  init:function (code) {
        var _this=this;
        if (code) this.goods_code = code;
        this.common.http({
          url:'getGoodsQty',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      }
    }
	}
</script>

<style lang="less">

</style>
