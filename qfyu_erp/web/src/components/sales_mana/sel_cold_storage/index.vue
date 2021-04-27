<template>
	<div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe691;</span>查询</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table size="small" border :columns="columns" :data="data" :height="height-34" @on-row-click="(item,index)=>{changeRow(item,index,false)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,true)}">
          <template slot-scope="{row}" slot="emp_name">
            <span>{{$store.state.emp[row.emp_no]}}</span>
          </template>
          <template slot-scope="{row}" slot="status">
            <div style="text-align: center;" :class="row.status?'success-bg-text':'warning-bg-text'">{{row.status?'已过账':'未过账'}}</div>
          </template>
        </Table>
        <div class="page-m">
          <Page size="small" show-total show-sizer :total="total" :page-size="pageSize" :page-size-opts="[25,35,50]" @on-change="changePage" @on-page-size-change="changePageSize"></Page>
        </div>
      </div>
    </split-none>
  </div>
</template>

<script>
  var _this;
  import splitNone from "@/components/public/splitNone"
	export default {
		name: "SelColdStorageList",
    components:{
      splitNone
    },
    data(){
		  return{
        height:0,
        Breadcrumb:[{title:'销售管理'},{title:'冷藏药品销退收货登记查询'}],
        columns:[
          {title: '单据编号', key: 'orderid', width: 155, minWidth: 155, ellipsis: true, resizable: true,fixed:'left'},
          {title: '日期', key: 'f_date', width: 140, minWidth: 140, ellipsis: true, resizable: true},
          {title: '运输方式', key: 'trans_type', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '经手人', key: 'emp_no', width: 70, minWidth: 70, ellipsis: true, resizable: true},
          {title: '经手人姓名', slot: 'emp_name', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '审核人', key: 'audit', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '过账', slot: 'status', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '送货司机', key: 'driver', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '车牌号', key: 'license_plate', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '销退登记单号', key: 'p_orderid', width: 155, minWidth: 155, ellipsis: true, resizable: true},
          {title: '送货人', key: 'deliveryman', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '发货员', key: 'shipper', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '备注', key: 'remark', width: 80, minWidth: 80, ellipsis: true, resizable: true}
        ],
        data:[],
        total:0,
        pageSize:25,
        page:1
      }
    },
    mounted() {
		  _this = this;
    },
    created() {
		  this.init();
    },
    methods:{
		  init(){
		    this.common.http({
          url:'s/getSelColdStorageList',
          data:{page:this.page,pageSize:this.pageSize}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total= res.data.total;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      changeRow(item,index,type){
        if (type){
          localStorage.setItem("cold_storage_orderid",item.orderid);
          this.toUrl('/SelColdStorageEdit');
        }
      },
      changePage(page){
        this.page = page;
        this.init();
      },
      changePageSize(pageSize){
        this.page = 1;
        this.pageSize = pageSize;
        this.init();
      },
      DHeight(e){
        this.height = e;
      }
    }
	}
</script>

<style scoped>

</style>
