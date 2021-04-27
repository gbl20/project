<template>
	<div>
    <Table size="small" border :columns="columns" :data="data" :height="height" @on-row-dblclick="changeRow">
      <template slot-scope="{row}" slot="sales_name">
        <span>{{$store.state.emp[row.sales_code]}}</span>
      </template>
      <template slot-scope="{row}" slot="check_name">
        <span>{{$store.state.emp[row.check_code]}}</span>
      </template>
    </Table>
  </div>
</template>

<script>
	export default {
		name: "PurchaseRecord",
    props:{
		  height:0
    },
    data(){
		  return{
		    goods_code:null,
        columns:[
          {title:'入库通知单号',key:'orderid',width:160,minWidth:160,resizable:true,ellipsis:true,fixed:'left'},
          {title:'进货日期',key:'order_date',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'业务员编号',key:'sales_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'业务员姓名',slot:'sales_name',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'审核者编号',key:'check_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'审核者姓名',slot:'check_name',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'供应商编号',key:'sup_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'供应商全称',key:'sup_name',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'供应商简称',key:'sup_full_name',width:200,minWidth:200,resizable:true,ellipsis:true},
          {title:'供应商联系人',key:'sup_contact',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'商品编号',key:'goods_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'购进数量',key:'qty',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'单价',key:'price',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'金额',key:'amount',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'生产批号',key:'batchno',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'生产日期',key:'prod_date',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'有效期至',key:'valid_date',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'仓库ID',key:'ware_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'仓库名称',key:'ware_title',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'货位',key:'pos_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'已结数量',key:'qty1',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'已退货数量',key:'qty2',width:100,minWidth:100,resizable:true,ellipsis:true},
        ],
        data:[]
      }
    },
    methods:{
		  init:function (code) {
        var _this=this;
        if (code) this.goods_code = code;
        this.common.http({
          url:'w/PurchaseRecordList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if(res.status) _this.data = res.data;
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      changeRow:function (item,index) {
        localStorage.setItem("recheck_orderid",this.data[index].orderid);
        this.toUrl("/editReCheck");
      }
    }
	}
</script>

<style scoped>

</style>
