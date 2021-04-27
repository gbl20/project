<template>
	<div>
    <Table size="small" border :columns="columns" :data="data" :height="height"></Table>
  </div>
</template>

<script>
	export default {
		name: "SupplyHistory",
    props:{
		  height:0
    },
    data(){
		  return{
		    goods_code:null,
		    columns:[
          {title:'供应商简称',key:'name',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'供应商全称',key:'full_name',width:200,minWidth:200,resizable:true,ellipsis:true},
          {title:'最近进货日期',key:'order_date',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'数量',key:'qty',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'单位',key:'unit',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'最近进价',key:'price1',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'联系人',key:'sup_contact',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'移动电话',key:'mobile',width:110,minWidth:110,resizable:true,ellipsis:true},
          {title:'联系电话',key:'tel',width:110,minWidth:110,resizable:true,ellipsis:true},
          {title:'传真',key:'fax',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'开户行',key:'bank_area',width:160,minWidth:160,resizable:true,ellipsis:true},
          {title:'账号',key:'bank_account',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'地址',key:'address',width:160,minWidth:160,resizable:true,ellipsis:true}
        ],
        data:[]
      }
    },
    methods:{
		  init:function (code) {
        var _this=this;
        if (code) this.goods_code = code;
        this.common.http({
          url:'w/supplyHistoryList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status) _this.data = res.data;
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      }
    }
	}
</script>

<style lang="less">

</style>
