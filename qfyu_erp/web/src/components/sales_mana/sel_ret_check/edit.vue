<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" :editTypeTitle="editTypeTitle" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button><span class="icon iconfont">&#xe6c0;</span>其他</Button>
          <Button @click="edit(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="edit(false)" :disabled="(formData.status || editType)?true:false"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="del" :disabled="(formData.status || editType)?true:false"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="preserve" :disabled="!editType?true:false"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button @click="cancel" :disabled="!editType?true:false"><span class="icon iconfont">&#xe793;</span>取消</Button>
          <Divider type="vertical" />
          <Button @click="check"  :disabled="formData.status?true:false"><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Button @click="reduction"  :disabled="formData.status?false:true"><span class="icon iconfont">&#xe693;</span>还原</Button>
          <Divider type="vertical" />
          <Button @click="toUrl('/SelRetCheckList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button @click="print"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form :model="formData" :label-width="80" class="w1200 padding-top" :disabled="!editType?true:false">
          <Row>
            <Col span="5">
              <FormItem label="单据编号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="登记日期">
                <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.f_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="申请单号">
                <Input v-model="formData.p_orderid"></Input>
              </FormItem>
            </Col>
            <Col span="8">
              <FormItem label="退货客户">
                <Row>
                  <Col span="5"><Input disabled v-model="formData.cust_no"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18"><Input disabled v-model="formData.cust_name"></Input></Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="采购人员">
                    <Input disabled v-model="formData.linkman"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomerSales(1)"></Button></Input>
                  </FormItem>
                  <FormItem label="合同编号">
                    <Input v-model="formData.contract_no" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="联系人">
                    <Input disabled v-model="formData.linkman2"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomerSales(0)"></Button></Input>
                  </FormItem>
                  <FormItem label="结算方式">
                    <Select v-model="formData.pay_mode_no">
                      <Option v-for="(item,key,index) in $store.state.settlement" :value="key" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                </Col>
              </Row>
            </Col>
            <Col span="5">
              <FormItem label="购方部门">
                <Input v-model="formData.cust_depart" disabled></Input>
              </FormItem>
              <FormItem label="业务员">
                <Row>
                  <Col span="6"><Input disabled v-model="formData.emp_no"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="17"><Input disabled v-model="$store.state.emp[formData.emp_no]"><Button class="clear-btn" slot="append" icon="ios-more" @click="opemEmployee('emp_no')"></Button></Input></Col>
                </Row>
              </FormItem>
              <FormItem label="复核员">
                <Input v-model="formData.audit" disabled></Input>
              </FormItem>
            </Col>
            <Col span="6">
              <FormItem label="第一收货人">
                <Row>
                  <Col span="6"><Input disabled v-model="formData.consignee1"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="17"><Input disabled v-model="$store.state.emp[formData.consignee1]"><Button class="clear-btn" slot="append" icon="ios-more" @click="opemEmployee('consignee1')"></Button></Input></Col>
                </Row>
              </FormItem>
              <FormItem label="第二收货人">
                <Row>
                  <Col span="6"><Input disabled v-model="formData.consignee2"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="17"><Input disabled v-model="$store.state.emp[formData.consignee2]"><Button class="clear-btn" slot="append" icon="ios-more" @click="opemEmployee('consignee2')"></Button></Input></Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="代销收货">
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.fungible" disabled></Checkbox>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="单据状态">
                    <div style="text-align: center" :class="formData.status?'success-bg-text':'warning-bg-text'">{{formData.status?'已审核':'未审核'}}</div>
                  </FormItem>
                </Col>
              </Row>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table size="small" :row-class-name="rowClassName" border :columns="columns" :data="data" :height="height-74" @on-row-click="changeRow">
          <template slot-scope="{row,index}" slot="item_no">
            <span>{{(row.item_no && editType)?row.item_no:(index+1)}}</span>
          </template>
          <template slot-scope="{row,index}" slot="gsp_name">
            <span v-if="$store.state.sysParam != {}">{{$store.state.sysParam.gsp_category[row.gsp_type]}}</span>
          </template>
          <template slot-scope="{row,index}" slot="quality_state">
            <Select v-if="$store.state.sysParam != {} && editType && index==editIndex" v-model="data[index].quality_state">
              <Option v-for="(item,key) in $store.state.sysParam.quality_status"  :value="item" :key="key">{{item}}</Option>
            </Select>
            <span v-else>{{row.quality_state}}</span>
          </template>
          <template slot-scope="{row,index}" slot="goods_state">
            <Select v-if="$store.state.sysParam != {} && editType && index==editIndex" v-model="data[index].goods_state">
              <Option v-for="(item,key) in $store.state.sysParam.goods_status"  :value="item" :key="key">{{item}}</Option>
            </Select>
            <span v-else>{{row.goods_state}}</span>
          </template>
        </Table>
        <Row class-name="border-b">
          <Form :label-width="80" class="w1200 padding-top" :disabled="!editType?true:false">
            <Row>
              <Col span="5">
                <FormItem label="货品总数">
                  <Input v-model="formData.goods_qty" disabled></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="货款">
                  <Input v-model="formData.goods_sum" disabled></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="税款">
                  <Input v-model="formData.tax_sum" disabled></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="合计">
                  <Input v-model="formData.amount" disabled></Input>
                </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                <FormItem label="备注">
                  <Input v-model="formData.remark"></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="创建者">
                  <Input v-model="$store.state.emp[formData.creater]" disabled></Input>
                </FormItem>
              </Col>
              <Col span="5">
                <FormItem label="创建日期">
                  <Input v-model="formData.creater_date" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="打印次数">
                  <div>{{formData.print_count}}</div>
                </FormItem>
              </Col>
            </Row>
          </Form>
        </Row>
      </div>
    </split-none>
    <select-customer-sales ref="selCustomerSales" @selCustSales="selCustSales"></select-customer-sales>
    <select-employee ref="SelectEmployee" @selemp="selEmployee"></select-employee>
  </div>
</template>

<script>
  var _this,
  formData = {
    orderid:'', f_date:'', p_orderid:'', cust_no:'', cust_name:'', linkman:'', contract_no:'', linkman2:'', pay_mode_no:'', cust_depart:'', emp_no:'', audit:'', consignee1:'', consignee2:'', fungible:'', status:0
  };
  import splitNone from "@/components/public/splitNone"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectEmployee from "@/components/common/SelectEmployee"
	export default {
		name: "SelRetCheckEdit",
    components:{
      splitNone,SelectCustomerSales,SelectEmployee
    },
    data: function () {
      return {
        orderid: null,
        height: 0,
        Breadcrumb: [{title: '销售管理'}, {title: '销售退回管理'}, {title: '销售退回登记明细'}],
        editIndex: -1,
        editType: 0,
        editTypeTitle: '',
        formData: {},
        columns: [
          {title: '项次', slot: 'item_no', width: 50, minWidth: 50, ellipsis: true, resizable: true},
          {title: '商品编号', key: 'goods_code', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '通用名称', key: 'name', width: 160, minWidth: 160, ellipsis: true, resizable: true},
          {title: '规格', key: 'specs', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '剂型', key: 'dosage', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '单位', key: 'unit', width: 50, minWidth: 50, ellipsis: true, resizable: true},
          {title: '包装规格', key: 'packspecs', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '生产批号', key: 'batch_no', width: 120, minWidth: 120, ellipsis: true, resizable: true},
          {title: '数量', key: 'qty', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '单价', key: 'o_price', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '折扣', key: 'rebate', width: 80, minWidth: 80, ellipsis: true, resizable: true, align: 'right'},
          {title: '赠品数量', key: 'gift_qty', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '实际单价', key: 'price', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '金额', key: 'amount', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '税率%', key: 'tax', width: 80, minWidth: 80, ellipsis: true, resizable: true, align: 'right'},
          {title: '税款', key: 'tax_sum', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '无税单价', key: 'not_tax_price', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '无税金额', key: 'goods_sum', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '生产日期', key: 'pro_date', width: 130, minWidth: 130, ellipsis: true, resizable: true},
          {title: '有效期至', key: 'valid_date', width: 130, minWidth: 130, ellipsis: true, resizable: true},
          {title: '产地', key: 'origin', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '生产企业', key: 'production', width: 150, minWidth: 150, ellipsis: true, resizable: true},
          {title: '批准文号/注册证号', key: 'approval_code', width: 140, minWidth: 140, ellipsis: true, resizable: true},
          {title: '供应商编号', key: 'prov_no', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '供应商名称', key: 'prov_name', width: 130, minWidth: 130, ellipsis: true, resizable: true},
          {title: '供应商许可证号', key: 'drug_license', width: 130, minWidth: 130, ellipsis: true, resizable: true},
          {title: '原发货单号', key: 'p_orderid', width: 160, minWidth: 160, ellipsis: true, resizable: true},
          {title: '发货项次', key: 'p_item_no', width: 80, minWidth: 80, ellipsis: true, resizable: true, align: 'center'},
          {title: '发货日期', key: 'p_date', width: 120, minWidth: 120, ellipsis: true, resizable: true},
          {
            title: '备注',
            key: 'remark',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,render:(h,params)=>{return this.custRender.renderInput(this, h, params, 'remark')}
          },
          {title: '退货原因', key: 'out_remark', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '原发货数量', key: 'p_qty', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '原赠品数量', key: 'p_gift_qty', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: 'GSP验收类型', key: 'gsp_type', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '验收类型名称', slot: 'gsp_name', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '储存条件', key: 'storage_type', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '质量状态', slot: 'quality_state', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '货品状态', slot: 'goods_state', width: 100, minWidth: 100, ellipsis: true, resizable: true},
        ],
        data: [],
        CustSales: 1,
        status: 0,
        empName:''
      }
    },
    activated() {
      this.orderid = localStorage.getItem("sel_check_orderid");
    },
    watch:{
      orderid:function (e) {
        this.orderid = e;
        if(this.orderid) this.init();
      }
    },
    mounted() {
      _this = this;
      if (!this.formData.f_date){
        this.formData.f_date = new Date();
      }
    },
    methods:{
      inputEach:function(fun,key,index){
        this.editIndex = index;
        if(fun == 'click'){
        }else{
          this.$set(this.data[index],key,this.custRender.KValue);
        }
      },
      rowClassName(row,index){
        if (index === this.editIndex) {
          this.$set(this.data[index],'isEdit',this.editType?true:false);
          return 'ivu-table-row-highlight';
        }else this.$set(this.data[index],'isEdit',false);
        return '';
      },
      init(){
        this.common.http({
          url:'s/getSelRetCheckDtl',
          data:{orderid:this.orderid}
        }).then(function (res) {
          if (res.status){
            _this.formData = res.formData;
            _this.data     = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      edit(type){
        if(this.editType) return this.modalMsg('当前正在处于编辑状态，请先保存或取消单据修改！')
        if (!type && !this.formData.orderid) return false;
        if (type) return this.modalMsg('当前系统设置限制：销售退回登记单只能由审核通过后的销售退回申请单生成！如需修改请联系当前系统管理员。');
        this.editType = 1;
        this.editTypeTitle = type?'新增':'修改';
      },
      del(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要删除当前单据吗？',
          onOk(){
            _this.common.http({
              url:'s/delSelRetCheck',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status){
                if (res.orderid){
                  localStorage.setItem("sel_check_orderid",res.orderid)
                  _this.orderid = res.orderid;
                }else{
                  localStorage.removeItem("sel_check_orderid");
                  _this.editIndex = -1;
                  _this.editType = 0;
                  _this.editTypeTitle = '';
                  _this.formData = JSON.parse(JSON.stringify(formData));
                  _this.data = [];
                }
              }else{
                _this.modalMsg(res.msg);
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
            })
          }
        })
      },
      //保存单据
      preserve(){
        this.common.http({
          url:'s/saveSelRetCheck',
          data:{formData:this.formData,data:this.data}
        }).then(function (res) {
          if (!res.status){
            _this.modalMsg(res.msg);
          }else{
            localStorage.setItem("sel_check_orderid",res.orderid)
            _this.editIndex=-1;
            _this.editType=0;
            _this.editTypeTitle='';
            _this.orderid = res.orderid;
            _this.init();
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      cancel(){
        if (!this.editType) return false;
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要取消对当前单据所作的修改吗？',
          onOk(){
            _this.editType = 0;
            _this.editTypeTitle = '';
            _this.init();
          }
        })
      },
      check(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要审核当前单据吗？',
          onOk(){
            _this.common.http({
              url:'s/checkSelRetCheck',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status){
                setTimeout(function () {
                  _this.$Modal.confirm({
                    title:'提示信息',
                    content:'<p>'+_this.orderid+'号销退登记单已经生成：</p>'+res.msg+'<p>要查看这些单据吗？</p>',
                    onOk(){
                      localStorage.setItem("sales_accept_orderid",_this.orderid);
                      _this.init();
                      _this.toUrl('/SelQualityAcceptList');
                    }
                  })
                },300)
              }else{
                setTimeout(function () {_this.modalMsg(res.msg)},300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
            })
          }
        })
      },
      reduction(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要还原当前已经审核过的单据吗？',
          onOk(){
            _this.common.http({
              url:'s/backSelRetCheck',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status){
                _this.init();
              }else{
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
            })
          }
        })
      },
      print(){},
      out(){
        this.delView('SelRetCheckEdit');
      },
      openCustomerSales(type){
        this.CustSales = type;
        if (!this.formData.cust_no) return false;
        this.$refs.selCustomerSales.open(this.formData.cust_no,type,true);
      },
      opemEmployee(name){
        this.empName = name;
        this.$refs.SelectEmployee.init();
      },
      selCustSales(e){
        if (!e.data){
          this.formData.linkman = null;
          this.formData.linkman2 = null;
        }else{
          if (this.CustSales==1){
            this.formData.linkman = e.data.user_name;
            if(e.is_check) this.formData.linkman2 = '';
          }else{
            this.formData.linkman2 = e.data.user_name;
          }
        }
      },
      selEmployee(e){
        this.formData[this.empName] = e.code;
      },
      changeRow(item,index){
        this.editIndex = index;
      },
      DHeight(e){
        this.height = e;
      }
    }
	}
</script>

<style lang="less">
.padding-top{
  padding-top: 5px;
}
</style>
