<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="toRegisterDel(true)"><span class="icon iconfont">&#xe797;</span>新增来货登记</Button>
          <Button><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Divider type="vertical"/>
          <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button><span class="icon iconfont">&#xe7f3;</span>筛选</Button>
          <Button><span class="icon iconfont">&#xe6c0;</span>网格属性</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table border stripe highlight-row size="small" :columns="columns" :data="data" :height="height-33" @on-row-click="(item,index)=>{changeRow(item,index,true)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,false)}">
          <template slot-scope="{row}" slot="order_status">
            <div>{{row.order_status?'是':'否'}}</div>
          </template>
          <template slot-scope="{row}" slot="recipient_status">
            <div>{{row.recipient_status?'是':'否'}}</div>
          </template>
          <template slot-scope="{row}" slot="sale_status">
            <div>{{row.sale_status?'是':'否'}}</div>
          </template>
          <template slot-scope="{row}" slot="status">
            <div :class="row.status==1?'success-bg-text':' warning-bg-text'" style="text-align: center;">{{row.status==1?'已审核':'未审核'}}</div>
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
  import splitNone from '@/components/public/splitNone'
  var _this,
      defaultColumns=[
      "orderid","receiving_date","o_orderid","contract_no","salesman","supplier_code","supplier_sale","supplier_contact","supplier_depart","supplier_orderid","supplier_remark","pay_type","transport_type","transport_equipment","car_number",	"hours","transport_certificate","temperature","warehouse","cnee_code1","cnee_code2","serial_number","amount","price",	"taxes","total_price","creator_code","creation_date","checker_code","checker_date","remark","status","order_status",	"recipient_status","sale_status"
    ];
	export default {
    name: "list",
    components:{
      splitNone
    },
    data:function () {
      return{
        Breadcrumb:[{title:'采购管理'},{title:'来货登记'}],
        height:0,
        editIndex:-1,
        columns:[
          {title:'单据号',key:'orderid',width:150,minWidth:150,resizable:true,ellipsis:true,fixed:'left'},
          {title:'采购订单编号',key:'o_orderid',width:160,minWidth:160,resizable:true,ellipsis:true,fixed:'left'},
          {title:'接货日期',key:'receiving_date',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'合同号',key:'contract_no',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'业务员',key:'salesman',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'供应商编号',key:'supplier_code',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'供应商名称',key:'supplier_name',width:200,minWidth:200,resizable:true,ellipsis:true},
          {title:'货品总数',key:'total_amount',width:110,minWidth:110,resizable:true,ellipsis:true,align:'right'},
          {title:'货款',key:'total_money',width:110,minWidth:110,resizable:true,ellipsis:true,align:'right'},
          {title:'税款',key:'taxes',width:110,minWidth:110,resizable:true,ellipsis:true,align:'right'},
          {title:'合计',key:'total_payprice',width:110,minWidth:110,resizable:true,ellipsis:true,align:'right'},
          {title:'供方销售人',key:'supplier_sale',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'供方联系人',key:'supplier_contact',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'供方部门',key:'supplier_depart',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'供方销售单号',key:'supplier_orderid',width:130,minWidth:130,resizable:true,ellipsis:true},
          {title:'供应商备注',key:'supplier_remark',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'复核员',key:'checker_code',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'复核时间',key:'checker_date',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'结算方式',key:'pay_name',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'运输方式',key:'transport_type',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'运输设备',key:'transport_equipment',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'运输车牌号',key:'car_number',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'运途时间(小时)',key:'hours',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'特殊品运输证',key:'transport_certificate',width:110,minWidth:110,resizable:true,ellipsis:true},
          {title:'温度控制状况',key:'temperature',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'收货仓库',key:'warehouse',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'第一收货人',key:'cnee_code1',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'第二收货人',key:'cnee_code2',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'流水号',key:'serial_number',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'创建者',key:'creator_code',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'创建时间',key:'creation_date',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'备注',key:'remark',width:230,minWidth:230,resizable:true,ellipsis:true},
          {title:'是否转单',slot:'order_status',width:80,minWidth:80,resizable:true,ellipsis:true,align:'center'},
          {title:'代销收货',slot:'recipient_status',width:80,minWidth:80,resizable:true,ellipsis:true,align:'center'},
          {title:'委托销售',slot:'sale_status',width:80,minWidth:80,resizable:true,ellipsis:true,align:'center'},
          {title:'是否审核',slot:'status',width:90,minWidth:90,resizable:true,ellipsis:true,fixed:"right"},
        ],
        data:[],
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
          url:'getRegisterList',
          data:{page:this.page,page_size:this.pageSize}
        }).then(function (res) {
            _this.total = res.total;
            _this.data = res.data;
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      toRegisterDel:function(type){
        if (type){
          /*新增来货登记*/
          localStorage.removeItem("edit_register_orderid");
          this.toUrl('/registerEdit');
        }else{
          if(this.editIndex !=-1) this.toUrl('/registerEdit');
          else this.alertMsg('请选择需要修改的单据！','error');
        }
      },
      /*
        item 当前选中行数据
        index 当前选中行索引
        type==true 单击选择行    type==false双击编辑行数据
      */
      changeRow:function(item,index,type){
        this.editIndex = index;
        if (!type){
        localStorage.setItem("edit_register_orderid",this.data[this.editIndex].orderid);
          this.toRegisterDel(false)
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

</style>
