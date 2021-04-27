<template>
	<div>
    <Modal v-model="modal" width="1000" title="选择仓库" class-name="vertical-center-modal" footer-hide>
      <Table ref="currentRowTable" border highlight-row :columns="columns" :data="data" :height="455" @on-row-click="(item,index)=>{changeRow(item,index,true)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,false)}">
        <template slot-scope="{row}" slot="canvirtual">
          <span>{{row.canvirtual==0?'否':'是'}}</span>
        </template>
        <template slot-scope="{row}" slot="storage_id">
          <span>{{wareItem[row.storage_id]}}</span>
        </template>
        <template slot-scope="{row}" slot="canbyonsale">
          <span>{{row.canbyonsale==1?'否':'是'}}</span>
        </template>
      </Table>
      <div class="footer-btn">
        <Row class-name="pad-top">
          <Col span="6">
            <Input v-model="search" placeholder="仓库编号/名称">
              <Button class="clear-btn" slot="append" icon="ios-search" @click="(e)=>{this.init();}"></Button>
            </Input>
          </Col>
          <Col span="6" class-name="mar-btn">
            <Button @click="confirm"><Icon type="md-checkmark" /> 选定</Button>
            <Button @click="clearSelect"><span class="icon iconfont">&#xe7fd;</span>清除选择</Button>
          </Col>
          <Col span="12" class-name="btn-pag">
            <Page show-total show-sizer size="small" :total="total" :page-size="pageSize" :page-size-opts="[15,25,35,50]" @on-change="changePage" @on-page-size-change="changeSizePage" />
          </Col>
        </Row>
      </div>
    </Modal>
  </div>
</template>

<script>
	export default {
		name: "SelectWarehouse",
    data:function () {
      return{
        search:'',
        modal:false,
        columns:[
          {title:'仓库编号',key:'ware_code',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'仓库名称',key:'ware_title',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'联系人',key:'ware_empid',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'电话',key:'phone',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'地址',key:'address',width:170,minWidth:170,resizable:true,ellipsis:true},
          {title:'分级仓',slot:'canvirtual',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
          {title:'所属公司',key:'ware_deptid',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'储存属性',slot:'storage_id',width:90,minWidth:90,resizable:true,ellipsis:true,align:'center'},
          {title:'不可销售',slot:'canbyonsale',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
          {title:'备注',key:'remark',width:150,minWidth:150,resizable:true,tooltip:true}
        ],
        data:[],
        wareItem:[],
        editIndex:-1,
        total:0,
        page:1,
        pageSize:15
      }
    },
    methods:{
		  init:function(){
        var _this=this;
        this.common.http({
          url:'getWarehouseMod',
          data:{search:this.search,page:this.page,page_size:this.pageSize}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total = res.data.total;
            _this.wareItem = res.ware_type;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
		  open:function (type) {
        this.modal =true;
        if (!type) this.init();
      },
      changeRow:function(item,index,type){
		    this.editIndex = index;
		    if(!type){
          this.modal = false;
		      this.$emit('selWare',this.data[index]);
        }
      },
      confirm:function(){
		    if (this.editIndex==-1){
		      return this.alertMsg('请选择仓库！','error');
        }
		    this.modal = false;
		    this.$emit('selWare',this.data[this.editIndex]);
      },
      clearSelect:function(){
		    this.editIndex = -1;
        this.$refs.currentRowTable.clearCurrentRow();
        this.$emit('clearSelect')
      },
      changePage:function(page){
		    this.page = page;
		    this.init();
      },
      changeSizePage:function(page_size){
		    this.page = 1;
		    this.pageSize = page_size;
		    this.init();
      }
    }
	}
</script>

<style lang="less">
  .vertical-center-modal{
    display: flex;align-items: center;justify-content: center;
    .ivu-modal{
      top: 0;
    }
  }
  .clear-btn{
    width:30px;height:26px;line-height:26px;border-left: none;border-right: none;box-sizing: border-box;
  }
  .footer-btn{
    padding-top: 15px;
    .mar-btn{
      padding-left: 20px;
    }
    .btn-pag{
      text-align: right;
    }
  }
</style>
