<template>
  <div>
    <split-none ref="splitPageRef" :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="editData(true)"><span class="icon iconfont">&#xe797;</span>首营企业申请</Button>
          <Button @click="editData(false)"><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
          <Divider type="vertical" />
          <Button><span class="icon iconfont">&#xe791;</span>刷新</Button>
          <Button @click="delView()"><span class="icon iconfont">&#xe791;</span>关闭</Button>
          <Divider type="vertical" />
          <Button @click="screen(1)"><span class="icon iconfont">&#xe791;</span>筛选</Button>
        </div>
        <Drawer width="320" title="筛选条件" :closable="true" v-model="serM">
          <div class="ser-form">
            <Form ref="formCustom" :model="formSearch" :label-width="90" :inline="true">
              <FormItem label="填报日期">
                <DatePicker v-model="formSearch.create_time" style="width:200px" type="date"></DatePicker>
              </FormItem>
              <FormItem label="批准日期">
                <DatePicker v-model="formSearch.approval_date" style="width:200px" type="date"></DatePicker>
              </FormItem>
              <FormItem label="单据号">
                <Input v-model="formSearch.orderid" style="width:200px" number></Input>
              </FormItem>
              <FormItem label="填报部门">
                <Select v-model="formSearch.depart_id" style="width:200px">
                  <Option value="0">未审批</Option>
                </Select>
              </FormItem>
              <FormItem label="业务审批者">
                <Select v-model="formSearch.reviser" style="width:200px">
                  <Option value="0">选项2</Option>
                </Select>
              </FormItem>
              <FormItem label="审批状态">
                <Select v-model="formSearch.order_status" style="width:200px">
                  <Option value="0">未审批</Option>
                  <Option value="1">已审批</Option>
                </Select>
              </FormItem>
              <FormItem label="单据状态">
                <Select v-model="formSearch.status" style="width:200px">
                  <Option value="0">未审批</Option>
                  <Option value="1">已审批</Option>
                </Select>
              </FormItem>
              <FormItem>
               <Button @click="screen(0)">取消</Button>
               <Button type="primary">确定</Button>
              </FormItem>
            </Form>
          </div>
        </Drawer>
      </div>
      <div slot="table-list">
        <Table id="table-m" border stripe size="small" :loading="loading" :columns="columns" :data="data" :highlight-row="true" :height="height-35" @on-row-click="rowClick" @on-row-dblclick="edit">
            <template slot-scope="{ row }" slot="is_audit">
              <div :class="row.is_audit==1?'success-bg-text':'warning-bg-text'">
                {{row.is_audit==1?'已审核':'未审核'}}
              </div>
            </template>
            <template slot-scope="{ row }" slot="is_approval">
              <div :class="row.is_approval==1?'success-bg-text':'warning-bg-text'">
                {{row.is_approval==1?'已审批':'未审批'}}
              </div>
            </template>
        </Table>
        <div class="page-m">
          <Page :total="total" :page-size="pageSize" size="small" show-total show-elevator show-sizer @on-change="ChangePage" @on-page-size-change="ChangePageSize" />
        </div>
      </div>
    </split-none>
  </div>
</template>

<script>
  import splitNone from '@/components/public/splitNone'
  var _this;
  export default {
    name:'FirstEnterprise',
    components: {splitNone},
    data: function() {
      return {
        Breadcrumb: [{title: 'GSP'}, {title: '首营企业管理'}],
        orderid:null,
        modal:false,
        isShow: true,
        loading:false,
        page:1,
        pageSize:10,
        total: 10,
        height: 0,
        serM:false,
        formSearch:{},
        columns:[
          { title: "单据号",key: "orderid",width: 170,fixed:'left'},
          { title: "申请日期",key: "create_date",resizable: true,width: 160},
          { title: "公司名称",key: "name",resizable: true,width: 160},
          { title: "公司地址",key: "area",resizable: true,width: 160},
          { title: "企业类型",key: "enterprise_type",resizable: true,width: 120},
          { title: "E-mail",key: "email",resizable: true,width: 120},
          { title: "法人代表",key: "legal_person",resizable: true,width: 120},
          { title: "拟供产品",key: "supply_var",resizable: true,width: 200,tooltip:true},
          { title: "联系人",key: "contact",resizable: true,width: 120},
          { title: "电话",key: "tel",resizable: true,width: 120},
          { title: "传真",key: "fax",resizable: true,width: 120},
          { title: "邮编",key: "post_code",resizable: true,width: 120},
          { title: "注册资金",key: "registered_capital",resizable: true,width: 120},
          { title: "营业执照注册号",key: "business_license",resizable: true,width: 150},
          { title: "发照机关",key: "business_issuing_authority",resizable: true,width: 120},
          { title: "发照日期",key: "business_issue_date",resizable: true,width: 120},
          { title: "经济性质",key: "economic_nature",resizable: true,width: 120},
          { title: "经营方式",key: "operation_mode",resizable: true,width: 120,tooltip:true},
          { title: "药品经营许可证编号",key: "drug_license",resizable: true,width: 180,tooltip:true},
          { title: "发证机关",key: "drug_issuing_authority",resizable: true,width: 120,tooltip:true},
          { title: "发证日期",key: "drug_issue_date",resizable: true,width: 120},
          { title: "药品经营许可证有效期",key: "drug_validity_date",resizable: true,width: 180},
          { title: "经营范围",key: "business_scope",resizable: true,width: 120,tooltip:true},
          { title: "企业负责人",key: "enterprise_leader",resizable: true,width: 120},
          { title: "GMP/GSP证书编号",key: "gsp_license",resizable: true,width: 180,tooltip:true},
          { title: "GMP/GSP证书有效期",key: "gsp_validity_date",resizable: true,width: 180},

          { title: "采购部负责人审批日期",key: "",resizable: true,width: 120},
          { title: "采购部负责人意见",key: "",resizable: true,width: 120,tooltip:true},
          { title: "采购部负责人",key: "",resizable: true,width: 120},
          { title: "采购部负责人姓名",key: "",resizable: true,width: 120},

          { title: "质量管理部审批日期",key: "",resizable: true,width: 120},
          { title: "质量管理部负责人意见",key: "",resizable: true,width: 120,tooltip:true},
          { title: "质量管理部负责人",key: "",resizable: true,width: 120},
          { title: "质量管理部负责人姓名",key: "",resizable: true,width: 120},

          { title: "质量负责人审批日期",key: "",resizable: true,width: 120},
          { title: "质量负责人审批意见",key: "",resizable: true,width: 120,tooltip:true},
          { title: "质量负责人",key: "",resizable: true,width: 120},
          { title: "质量负责人姓名",key: "",resizable: true,width: 120},

          { title: "是否审核",slot: "is_audit",width: 90,align:'center',fixed:'right'},
          { title: "是否审批",slot: "is_approval",width: 90,align:'center',fixed:'right'}
        ],
        data:[],
        unitItem:[],
        storage_type:[],
        gsp_type:[],
        propData:{},
        editItem:{},
        checkIndex:-1
      }
    },
    beforeRouteEnter(to, from, next) {
      if(from.name === 'EditEnterprise') to.meta.isBack = false;
      next();
    },
    activated() {
      if(!this.$route.meta.isBack) this.init();
      this.$route.meta.isBack = true
    },
    mounted:function(){
      _this=this;
      this.loading = true;
      this.init();
    },
    methods: {
      init:function(){
        this.common.http({
          url: 'enterpriseList'
        }).then(function (res) {
          if(res.status == 1){
            _this.data = res.data.data;
            _this.total = res.data.total;
            _this.$nextTick(function(){
              _this.loading = false;
            })
          }
        }).catch(function(err){
           _this.common.httpErr(err.data,_this);
        })
      },
      editData:function(type){
        if(type){
          localStorage.removeItem("edit_enterprise_orderid");
          this.toUrl('/edit_enterprise');
        }else {
          if(this.checkIndex != -1) this.toUrl('/edit_enterprise');
          else this.alertMsg('请选择需要修改的信息','error')
        }
      },
      rowClick:function(item,index){
        this.checkIndex = index;
        localStorage.setItem("edit_enterprise_orderid",item.orderid);
      },
      edit:function(item,index){
        this.checkIndex = index;
        localStorage.setItem("edit_enterprise_orderid",item.orderid);
        this.editData(false);
      },
      dHeight: function(e) {
        this.height = e;
      },
      ChangePage: function(page) {
        this.page = page;
        this.init();
      },
      ChangePageSize:function(page_size){
        this.page = 1;
        this.pageSize = page_size;
        this.init();
      },
      screen:function(type){
        this.serM = type?true:false;
      },
    }
  }
</script>
