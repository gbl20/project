<template>
  <div class="variety_main">
    <split-none ref="splitPageRef" :total='total' :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="edit(false)"><span class="icon iconfont">&#xe797;</span>新增首营产品</Button>
          <Button @click="edit(true)"><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Divider type="vertical"/>
          <Button @click="refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button @click="showSearch = true"><span class="icon iconfont">&#xe7f3;</span>筛选</Button>
          <Button><span class="icon iconfont">&#xe6a0;</span>报表</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table ref="goodsData" highlight-row border stripe size="small" :columns="columns" :data="data"
               :height="height-35" @on-row-click="(row,index)=>{rowClick(row,index,false)}"
               @on-row-dblclick="(row,index)=>{rowClick(row,index,true)}">
          <template slot-scope="{row}" slot="status">
            <div :class="row.status?'success-bg-text':'warning-bg-text'">{{row.status?'已审核':'未审核'}}</div>
          </template>
          <template slot-scope="{row}" slot="order_status">
            <div :class="row.order_status?'success-bg-text':'warning-bg-text'">{{row.order_status?'已审核':'未审核'}}</div>
          </template>
          <template slot-scope="{row}" slot="dosage">
            <span>{{dosageItem[row.dosage]}}</span>
          </template>
          <template slot-scope="{row}" slot="unit">
            <span>{{unitItem[row.unit]}}</span>
          </template>
          <template slot-scope="{row}" slot="storage_type">
            <span>{{storageItem[row.storage_type]}}</span>
          </template>
          <template slot-scope="{row}" slot="gsp_type">
            <span>{{gspItem[row.dosage]}}</span>
          </template>
        </Table>
        <div class="page-m">
          <Page :total="total" :page-size="pageSize" size="small" show-total show-elevator show-sizer
                @on-change="ChangePage" @on-page-size-change="ChangePageSize"/>
        </div>
      </div>
    </split-none>
    <Drawer title="筛选条件" :closable="false" width="330" v-model="showSearch">
        <Form ref="formDynamic" :model="formSearch" :label-width="90">
        <Row>
          <Col span="24">
            <FormItem label="填报日期">
              <DatePicker clearable v-model="formSearch.create_date" type="date"></DatePicker>
            </FormItem>
            <FormItem label="批准日期">
              <DatePicker clearable v-model="formSearch.approval_date" type="date"></DatePicker>
            </FormItem>
            <FormItem label="单据号">
              <Input clearable v-model="formSearch.orderid" number></Input>
            </FormItem>
            <FormItem label="填报部门">
              <Select clearable v-model="formSearch.depart_id">
                <Option value="0">未审批</Option>
              </Select>
            </FormItem>
            <FormItem label="业务审批者">
              <Select clearable v-model="formSearch.reviser">
                <Option value="0">选项2</Option>
              </Select>
            </FormItem>
            <FormItem label="商品名称">
              <Input clearable v-model="formSearch.goods_name"></Input>
            </FormItem>
            <FormItem label="供应商">
              <Select clearable v-model="formSearch.name">
                <Option value="0">选项一</Option>
              </Select>
            </FormItem>
            <FormItem label="采购审批者">
              <Select clearable v-model="formSearch.name">
                <Option value="2">选项2</Option>
              </Select>
            </FormItem>
            <FormItem label="质量审批者">
              <Select clearable v-model="formSearch.qa_status">
                <Option value="2">选项2</Option>
              </Select>
            </FormItem>
            <FormItem label="审批状态">
              <Select clearable v-model="formSearch.order_status">
                <Option value="0">未审批</Option>
                <Option value="1">已审批</Option>
              </Select>
            </FormItem>
            <FormItem label="单据状态">
              <Select clearable v-model="formSearch.status">
                <Option value="0">未审核</Option>
                <Option value="1">已审核</Option>
              </Select>
            </FormItem>
            <FormItem>
              <Button @click="(formSearch)=>{this.init()}"><span class="icon iconfont">&#xe691;</span>查询</Button>
              <Button @click="handleReset">重置筛选条件</Button>
            </FormItem>
          </Col>
        </Row>
      </Form>
    </Drawer>
  </div>
</template>

<script>
  import splitNone from '@/components/public/splitNone'
  var _this,
    formSearch = {
    create_date:'',approval_date:'',orderid:null,depart_id:[],reviser:'',goods_name:'',qa_status:'',order_status:null,status:null
  };
  export default {
    components: {splitNone},
    data: function () {
      return {
        Breadcrumb: [{title: 'GSP'}, {title: '首营产品管理'}],
        showSearch: false,
        orderid: null,
        page: 1,
        pageSize: 15,
        total: 10,
        height: 0,
        formSearch:JSON.parse(JSON.stringify(formSearch)),
        columns: [
          {title: "审核状态", slot: "status", width: 100, minWidth: 100, resizable: true, ellipsis: true, fixed: 'left'},
          {title: "审批状态", slot: "order_status", width: 100, minWidth: 100, resizable: true, ellipsis: true, fixed: 'left'},
          {title: "单据号", key: "orderid", width: 160, minWidth: 160, resizable: true, ellipsis: true},
          {title: "部门名称", key: "branch_id", width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {title: "填报日期", key: "create_date", width: 140, minWidth: 140, resizable: true, ellipsis: true},
          {title: "通用名称", key: "goods_name", width: 220, minWidth: 220, resizable: true, ellipsis: true},
          {title: "规格", key: "specs", width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {title: "剂型", slot: "dosage", width: 70, minWidth: 70, resizable: true, ellipsis: true},
          {title: "单位", slot: "unit", width: 70, minWidth: 70, resizable: true, ellipsis: true},
          {title: "生产企业", key: "production", width: 200, minWidth: 200, resizable: true, ellipsis: true},
          {title: "药品性能、成分、质量、用途、疗效", key: "description", width: 250, minWidth: 250, resizable: true, ellipsis: true},
          {title: "质量标准", key: "quality_standards", width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {title: "储存条件", slot: "storage_type", width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: "GSP验收类型", slot: "gsp_type", width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {title: "企业GMP证书号", key: "gmp_code", width: 140, minWidth: 140, resizable: true, ellipsis: true},
          {title: "认证时间", key: "gmp_date", width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: "批准文号", key: "approval_code", width: 140, minWidth: 140, resizable: true, ellipsis: true},
          {title: "大包装规格", key: "pack_specs2", width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: "有效期或使用期(月)", key: "production_mouth", width: 140, minWidth: 140, resizable: true, ellipsis: true, align: 'right'},
          {title: "出厂价", key: "factory_price", width: 100, minWidth: 100, resizable: true, ellipsis: true, align: 'right'},
          {title: "采购实价", key: "buyer_price", width: 100, minWidth: 100, resizable: true, ellipsis: true, align: 'right'},
          {title: "零售价", key: "retail_price", width: 100, minWidth: 100, resizable: true, ellipsis: true, align: 'right'},
          {title: "批发价", key: "trade_price", width: 100, minWidth: 100, resizable: true, ellipsis: true, align: 'right'},
          {title: "采购员", key: "salesman", width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {title: "申请原因", key: "remark", width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {title: "采购负责人意见", key: "buyer_reason", width: 130, minWidth: 130, resizable: true, ellipsis: true},
          {title: "采购负责人", key: "buyer_code", width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: "采购负责人审批日期", key: "buyer_date", width: 150, minWidth: 150, resizable: true, ellipsis: true},
          {title: "质量管理部负责人意见", key: "qa_reason", width: 150, minWidth: 150, resizable: true, ellipsis: true},
          {title: "质量管理部负责人", key: "qa_code", width: 130, minWidth: 130, resizable: true, ellipsis: true},
          {title: "质量管理部审批日期", key: "qa_date", width: 150, minWidth: 150, resizable: true, ellipsis: true},
          {title: '质量负责人', key: 'principal_code', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: "质量负责人审批意见", key: "principal_reason", width: 140, minWidth: 140, resizable: true, ellipsis: true},
          {title: "质量负责人审批日期", key: "principal_date", width: 140, minWidth: 140, resizable: true, ellipsis: true},
        ],
        data: [],
        unitItem: [],
        storageItem: [],
        gspItem: [],
        dosageItem: [],
      }
    },
    mounted: function () {
      _this = this;
    },
    beforeRouteEnter(to, from, next) {
      if (from.name !== 'FirstVarietyList' && from.name !== '/') to.meta.isBack = true;
      next();
    },
    created() {
      this.$route.meta.isBack = true;
      this.init();
    },
    activated() {
      if (!this.$route.meta.isBack) this.init();
      this.$route.meta.isBack = false;
    },
    methods: {
      init: function () {
        this.common.http({
          url: 'getFirstGoodsList',
          data: {search: this.formSearch, page: this.page, page_size: this.pageSize}
        }).then(function (d) {
          if (d.status == 1) {
            _this.data        = d.data.data;
            _this.total       = d.data.total;
            _this.page        = d.data.next_page;
            _this.unitItem    = d.unit;
            _this.storageItem = d.storage_type;
            _this.gspItem     = d.gsp_type;
            _this.dosageItem  = d.dosage;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this)
        })
      },
      //新增-修改产品资料
      edit: function (type) {
        var data = {orderid:type?this.orderid:null,is_back:1};
        if (type){
          if(!this.orderid) return this.alertMsg('请选择需要修改的品种资料','error');
        }
        this.toUrl('/new_variety_goods', data)
      },
      //单击-双击行 type == false 单击 type==true 双击
      rowClick: function (item, index, type) {
        this.orderid = this.data[index].orderid;
        if (type) this.edit(true);
      },
      //刷新页面
      refresh: function () {
        this.init();
      },
      handleReset:function(){
        this.formSearch = JSON.parse(JSON.stringify(formSearch));
      },
      dHeight: function (e) {
        this.height = e;
      },
      ChangePage: function (page) {
        this.page = page;
        this.init();
      },
      ChangePageSize: function (page_size) {
        this.page = 1;
        this.pageSize = page_size;
        this.init();
      }
    }
  }
</script>

<style lang="less">
  .variety_main{
    .success-bg-text, .warning-bg-text {
      text-align: center
    }
  }
  .vertical-center-modal {
    display: flex;align-items: center;justify-content: center;
    .ivu-modal {
      top: 0;
      .ivu-modal-body {
        overflow-x: auto;
      }
    }
  }
</style>
