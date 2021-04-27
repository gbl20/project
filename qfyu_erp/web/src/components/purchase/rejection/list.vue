<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="toUrl('/RejectionEdit')"><span class="icon iconfont">&#xe797;</span>新增来货拒收</Button>
          <Button><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Divider type="vertical"/>
          <Button><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button><span class="icon iconfont">&#xe7f3;</span>筛选</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table border stripe highlight-row size="small" :columns="columns" :data="data" :height="height-34" @on-row-click="(item,index)=>{changeRow(item,index,true)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,false)}">
          <template slot-scope="{row}" slot="status">
            <div class="c-state" :class="row.status==1?'success-bg-text':'warning-bg-text'">{{row.status==1?'已审核':'未审核'}}</div>
          </template>
        </Table>
        <div class="page-m">
          <Page size="small" :total="total" :page-size="pageSize" :page-size-opts="[15,25,35,50]" show-total show-elevator show-sizer @on-change="changePage" @on-page-size-change="ChangePageSize" />
        </div>
      </div>
    </split-none>
  </div>
</template>

<script>
  var _this;
  import splitNone from '@/components/public/splitNone'
	export default {
    components:{
      splitNone
    },
    data:function () {
      return{
        Breadcrumb:[{title:'采购管理'},{title: '来货拒收'}],
        height:0,
        columns:[
          {title:'拒收单号',key:'orderid',width:150,minWidth:150,resizable:true,ellipsis:true,fixed:'left'},
          {title:'采购单号',key:'come_orderid',width:160,minWidth:160,resizable:true,ellipsis:true,fixed:'left'},
          {title:'日期',key:'orderid_date',width:110,minWidth:110,resizable:true,ellipsis:true},
          {title:'业务员',key:'salesman',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'员工姓名',key:'salesman_name',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'供应商编号',key:'supplier_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'供应商名称',key:'supplier_name',width:190,minWidth:190,resizable:true,ellipsis:true},
          {title:'进货地址',key:'address',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'运输方式',key:'transport_type',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'复核员',key:'checker_code',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'审核员姓名',key:'checker_name',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'备注',key:'remark',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'进货凭证',key:'invoice',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'开单人',key:'create_code',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'开单人姓名',key:'create_name',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'开单日期',key:'create_date',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'开单部门',key:'depart_id',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'部门名称',key:'depart_name',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'购方部门',key:'sale_status',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'状态',slot:'status',width:100,minWidth:100,resizable:true,ellipsis:true,fixed:'right'},
        ],
        data:[],
        Index:-1,
        total:0,
        page:1,
        pageSize:15
      }
    },
    mounted() {
      _this=this;
    },
    created() {
      this.init();
    },
    methods:{
      init:function(){
        this.common.http({
          url:'getGoodsRejectionList',
          data:{page:this.page,page_size:this.pageSize}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total= res.data.total;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      changeRow:function(item,index,type){
        this.Index = index;
        if (!type){
          localStorage.setItem("edit_ejection_orderid",this.data[index].orderid)
          this.toUrl('RejectionEdit');
        }
      },
      changePage:function(page){
        this.page = page;
        this.init();
      },
      ChangePageSize:function(page_size){
        this.page = 1;
        this.pageSize = page_size;
        this.init();
      },
      dHeight:function (e) {
        this.height = e;
      }
    }
	}
</script>

<style lang="less">
  .c-state{text-align: center;}
</style>
