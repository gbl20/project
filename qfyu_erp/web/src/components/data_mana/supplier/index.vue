<template>
  <div>
    <split-tb ref="splitPageRef" :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="editDataFun(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="editDataFun(1)"><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
          <Divider type="vertical" />
          <Button @click="examData(1)" :disabled="(checkIndex!=-1 && data[checkIndex].audit_status)?true:false"><span class="icon iconfont">&#xe791;</span>审核</Button>
          <Button @click="examData(0)" :disabled="(checkIndex!=-1 && !data[checkIndex].audit_status)?true:false"><span class="icon iconfont">&#xe791;</span>撤销</Button>
          <Divider type="vertical" />
          <Button @click="reload"><span class="icon iconfont">&#xe791;</span>刷新</Button>
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
        <Table id="table-m" ref="tableM" :row-class-name="rowClassName" border stripe size="small" :loading="loading" :columns="columns" :data="data" :height="THeight" @on-row-click="rowClick" @on-row-dblclick="edit">
          <template slot-scope="{ row }" slot="abckind">
            <div class="over-ellipsis" v-if="JSON.stringify($store.state.sysParam) != '[]'">{{$store.state.sysParam['abc_type'][row.abckind]}}</div>
          </template>
          <template slot-scope="{ row }" slot="business_leader">
            <div class="over-ellipsis">{{$store.state.emp[row.business_leader]}}</div>
          </template>
          <template slot-scope="{ row }" slot="pay_mode_no">
            <div class="over-ellipsis">{{$store.state.settlement[row.pay_mode_no]}}</div>
          </template>
          <template slot-scope="{ row }" slot="audit_status">
            <div :class="row.audit_status==1?'success-bg-text':'warning-bg-text'">
              {{row.audit_status==1?'已审核':'未审核'}}
            </div>
          </template>
        </Table>
      </div>
      <div slot="bottom">
        <Tabs v-model="tabName" :animated="false" type="card">
            <TabPane label="供应商协议品种管理" name="varieties">
              <div class="tabs-content" :style="'height:'+(BHeight-52)+'px;overflow-y:auto;'" v-if="tabName == 'varieties'">
                <varieties :height="BHeight-52" :supplierCode="supplierCode"></varieties>
              </div>
            </TabPane>
            <TabPane label="供方销售人员(联系人)管理" name="contacts">
              <div class="tabs-content" :style="'height:'+(BHeight-52)+'px;overflow-y:auto;'" v-if="tabName == 'contacts'">
                <contacts :height="BHeight-52" :supplierCode="supplierCode"></contacts>
              </div>
            </TabPane>
            <TabPane label="业务联系记录管理" name="records">
              <div class="tabs-content" :style="'height:'+(BHeight-52)+'px;overflow-y:auto;'" v-if="tabName == 'records'">
                  <records :height="BHeight-52" :supplierCode="supplierCode"></records>
                </div>
              </TabPane>
            </TabPane>
            <TabPane label="供应商自产商品" name="produced">
              <div class="tabs-content" :style="'height:'+(BHeight-52)+'px;overflow-y:auto;'" v-if="tabName == 'produced'">
                <produced :height="BHeight-52" :isProduction="is_production" :supplierCode="supplierCode"></produced>
              </div>
            </TabPane>
            <TabPane label="证照图片管理" name="photo">
              <div class="tabs-content" :style="'height:'+(BHeight-52)+'px;overflow-y:auto;'" v-if="tabName == 'photo'">
                <photo :height="BHeight-52" :supplierCode="supplierCode"></photo>
              </div>
            </TabPane>
            <TabPane label="供方销售员授权品种管理" name="grant">
              <div class="tabs-content" :style="'height:'+(BHeight-52)+'px;overflow-y:auto;'" v-if="tabName == 'grant'">
                <grant ref="grantRef" :height="BHeight-52" :supplierCode="supplierCode"></grant>
              </div>
            </TabPane>
        </Tabs>
      </div>
    </split-tb>
    <Modal v-model="editModal" title="供应商资料编辑" width="1080" footer-hide :mask-closable="false">
      <edit-data ref="editDataRef" :provData="provData" @addNotify="addNotify" @closeNotify="closeNotify"></edit-data>
    </Modal>
  </div>
</template>
<script>
  import splitTb from '@/components/public/splitTB'
  import varieties from '@/components/data_mana/supplier/varieties'
  import contacts from '@/components/data_mana/supplier/contacts'
  import grant from '@/components/data_mana/supplier/grant'
  import photo from '@/components/data_mana/supplier/photo'
  import produced from '@/components/data_mana/supplier/produced'
  import records from '@/components/data_mana/supplier/records'
  import editData from '@/components/data_mana/supplier/editData'
  var _this;
  export default {
    name:'supplier',
    components: {splitTb,varieties,contacts,grant,photo,produced,records,editData},
    inject:['reload'],
    data: function() {
      return {
        Breadcrumb: [{title: '资料管理'}, {title: '供应商管理'}],
        orderid:null,
        modal:false,
        isShow: true,
        loading:false,
        THeight: 0,
        BHeight: 0,
        serM:false,
        formSearch:{},
        columns:[
          { title: "供应商编号",key: "supplier_code",width: 85,fixed:'left'},
          { title: "供应商名称",key: "name",resizable: true,width: 120},
          { title: "供应商名全称",key: "full_name",resizable: true,width: 200},
          { title: "业务负责人",slot: "business_leader",resizable: true,width: 85},
          { title: "助记码",key: "mnemonic_code",resizable: true,width: 120},
          { title: "ABC分类",slot: "abckind",resizable: true,width: 85},
          { title: "企业类型",key: "enterprise_type",resizable: true,width: 120},
          { title: "供方部门",key: "subject_dept",resizable: true,width: 120},
          { title: "经营方式",key: "operation_mode",resizable: true,width: 120},
          { title: "法人代表",key: "legal_person",resizable: true,width: 120},
          { title: "法人职务",key: "corp_duty",resizable: true,width: 120},
          { title: "经济性质",key: "economic_nature",resizable: true,width: 120},
          { title: "质量保证体系",key: "quality_system",resizable: true,width: 180},
          { title: "营业执照注册号",key: "business_license",resizable: true,width: 150},
          { title: "法定资格",key: "competency",resizable: true,width: 150},
          { title: "所在地区",key: "area",resizable: true,width: 150},
          { title: "详细地址",key: "address",resizable: true,width: 150},
          { title: "联系人",key: "contact",resizable: true,width: 90},
          { title: "移动电话",key: "mobile",resizable: true,width: 120},
          { title: "联系电话",key: "tel",resizable: true,width: 120},
          { title: "传真",key: "fax",resizable: true,width: 120},
          { title: "开户银行",key: "bank_area",resizable: true,width: 120},
          { title: "账号",key: "bank_account",resizable: true,width: 120},
          { title: "税号",key: "tax_code",resizable: true,width: 120},
          { title: "信用额度",key: "credit",resizable: true,width: 120},
          { title: "信用天数",key: "credit_days",resizable: true,width: 120},
          { title: "默认结算方式",slot: "pay_mode_no",resizable: true,width: 150},
          { title: "暂停往来",key: "pause",resizable: true,width: 120},
          { title: "备注",key: "remark",resizable: true,width: 120},
          { title: "年产值",key: "output_year",resizable: true,width: 120},
          { title: "授权品种",key: "staple",resizable: true,width: 120},
          { title: "主要荣誉",key: "major_honors",resizable: true,width: 120},
          { title: "质量状况",key: "quality_state",resizable: true,width: 120},
          { title: "企业质量机构名称",key: "quality_organization",resizable: true,width: 180},
          { title: "质量管理与制度情况",key: "quality_regime",resizable: true,width: 190},
          { title: "质量负责人姓名",key: "qc_name",resizable: true,width: 180},
          { title: "质量负责人性别",key: "qc_sex",resizable: true,width: 180},
          { title: "质量负责人质量工作年限",key: "qc_year",resizable: true,width: 200},
          { title: "GMP/GSP证书编号",key: "gsp_license",resizable: true,width: 180,tooltip:true},
          { title: "GMP/GSP证书有效期",key: "gsp_validity_date",resizable: true,width: 170},
          { title: "药品经营许可证编号",key: "drug_license",resizable: true,width: 180,tooltip:true},
          { title: "药品经营许可证有效期",key: "drug_validity_date",resizable: true,width: 180},
          { title: "法人委托书有效期",key: "attorney_validity_date",resizable: true,width: 180},
          { title: "法人委托书有效期",key: "attorney_validity_date",resizable: true,width: 180},
          { title: "质量保证协议有效期",key: "quality_validity_date",resizable: true,width: 180},
          { title: "保健品经营许可证编号",key: "health_license",resizable: true,width: 180},
          { title: "保健品经营许可证有效期",key: "health_validity_date",resizable: true,width: 180},
          { title: "医疗器械许可证编号",key: "apparatus_license",resizable: true,width: 180},
          { title: "医疗器械许可证有效期",key: "apparatus_validity_date",resizable: true,width: 180},
          { title: "业务员授权有效期",key: "ywysqsyxq_date",resizable: true,width: 180},
          { title: "统一监管码",key: "watch_no",resizable: true,width: 150},
          { title: "食品经营许可证编号",key: "food_license",resizable: true,width: 180},
          { title: "食品经营许可证有效期",key: "food_validity_date",resizable: true,width: 180},
          { title: "邮编",key: "post_code",resizable: true,width: 90},
          { title: "营业执照有效期",key: "business_validity_date",resizable: true,width: 150},
          { title: "所属部门",key: "apply_depart",resizable: true,width: 100},
          { title: "资格证书",key: "qualification",resizable: true,width: 100},
          { title: "授权期限",key: "auth_period_date",resizable: true,width: 100},
          { title: "审核员",key: "auditer",resizable: true,width: 100},
          { title: "仓库地址",key: "depot_addr",resizable: true,width: 200},
          { title: "审核状态",slot: "audit_status",resizable: true,align:'center', width: 85,fixed:'right'}
        ],
        data:[],
        unitItem:[],
        storage_type:[],
        gsp_type:[],
        propData:{},
        editItem:{},
        checkIndex:-1,
        editModal:false,
        provData:[],
        tabName:'varieties',
        supplierCode:'',
        is_production:1
      }
    },
    watch:{
      tabName(e){
        let _this = this;
        if(e == 'grant'){
          setTimeout(function(){
            _this.$refs.grantRef.checkIsNav();
          },300)
        }
      }
    },
    mounted:function(){
      _this = this;
      this.loading = true;
      this.init();
    },
    methods: {
      init:function(){
        this.common.http({
          url: 'getSupplier'
        }).then(function (res) {
          if(res.status == 1){
            _this.data = res.providers_data
            _this.provData = res.prov_data
            _this.$nextTick(function(){
              _this.loading = false;
              _this.checkIndex = 0;
            })
          }else _this.loading = false;
        }).catch(function(err){
           _this.common.httpErr(err.data,_this);
        })
      },
      rowClassName(row, index) {
        let className = '';
        if (index === this.checkIndex) {
          this.supplierCode = this.data[this.checkIndex].supplier_code
          this.is_production = this.data[this.checkIndex].is_production
          className = 'ivu-table-row-highlight';
        }
        if(row.audit_status == 0){
          className += ' yellow-text';
        }
        return className;
      },
      rowClick:function(item,index){
        this.checkIndex = index;
      },
      edit:function(item,index){
        this.checkIndex = index;
        this.editDataFun(true);
      },
      examData:function(type){
        let obj = this.data[this.checkIndex];
        let auditStatus = obj.audit_status,supplier_code = obj.supplier_code;
        if(type){
          if(auditStatus == 1){
            return this.modalMsg('当前供应商已审核合格');
          }else{
            this.common.http({
              url: 'examSupplier',data:{supplier_code:supplier_code}
            }).then(function (res) {
              if(res.status == 1){
                _this.$set(obj,'audit_status',1);
              }
              _this.modalMsg(res.msg,'提示',res.status?'success':'error')
            }).catch(function(err){
               _this.common.httpErr(err.data,_this);
            })
          }
        }else{
          if(auditStatus != 1){
            return this.modalMsg('当前供应商未审核');
          }else{
            this.common.http({
              url: 'revokeSupplier',data:{supplier_code:supplier_code}
            }).then(function (res) {
              if(res.status == 1){
                _this.$set(obj,'audit_status',0);
              }
              _this.modalMsg(res.msg,'提示',res.status?'success':'error')
            }).catch(function(err){
               _this.common.httpErr(err.data,_this);
            })
          }
        }
      },
      addNotify:function(e){
        if(e.is_up) this.$set(this.data, this.checkIndex, e.data)
        else{
          this.total += 1;
          this.data.unshift(e.data)
          this.checkIndex = 0;
        }
        this.closeNotify();
      },
      closeNotify:function(){
        this.editModal = false;
      },
      editDataFun:function(type){
        let data = null;
        if(type){
          if(this.checkIndex != -1){
            data = this.data[this.checkIndex];
          }else{
            return this.alertMsg('请选择需要修改的信息','error')
          }
        }
        this.$refs.editDataRef.init(data)
        this.editModal = true;
      },
      dHeight: function(e) {
        this.THeight = e.THeight;
        this.BHeight = e.BHeight;
      },
      screen:function(type){
        this.serM = type?true:false;
      }
    }
  }
</script>
