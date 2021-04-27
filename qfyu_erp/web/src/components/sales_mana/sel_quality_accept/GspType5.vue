<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" :editTypeTitle="editTypeTitle" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button @click="editData"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="dtl" :disabled="formData.status?true:false"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button :disabled="(formData.status || !editType)?true:false" @click="save"><span class="icon iconfont">&#xe792;</span>保存
          </Button>
          <Button @click="cancel" :disabled="!editType?true:false"><span class="icon iconfont">&#xe793;</span>取消</Button>
          <Divider type="vertical"/>
          <Button @click="checker" :disabled="formData.status?true:false"><span class="icon iconfont">&#xe692;</span>审核
          </Button>
          <Button @click="reduction" :disabled="(!formData.status || editType)?true:false"><span class="icon iconfont">&#xe6a2;</span>还原</Button>
          <Divider type="vertical"/>
          <Button @click="toUrl('/SelQualityAcceptList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form ref="FormRef" :model="formData" :rules="ruleInline" :label-width="80" style="width: 1200px;padding-top: 5px;"
              :disabled="editType?false:true">
          <Row>
            <Col span="5">
              <FormItem label="验收单号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="来货日期">
                <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.delivery_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="验收日期">
                <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.accept_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="总金额">
                <Input disabled v-model="formData.money"></Input>
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem label="客户单位">
                <Row>
                  <Col span="5">
                    <Input v-model="formData.supplier_code" disabled></Input>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18">
                    <Input icon="ios-more" v-model="formData.cust_name" disabled></Input>
                  </Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="销退单号">
                    <Input v-model="formData.come_orderid"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="购方部门">
                    <Input v-model="formData.cust_depart" disabled></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="12">
                  <FormItem label="创建人">
                    <Input v-model="$store.state.emp[formData.create_code]" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="创建日期">
                    <Input v-model="formData.create_date" disabled></Input>
                  </FormItem>
                </Col>
              </Row>
              <FormItem label="备注">
                <Input v-model="formData.remark"></Input>
              </FormItem>
            </Col>
            <Col span="6">
              <FormItem label="复核员">
                <Row>
                  <Col span="8">
                    <Input v-model="formData.checker_code" disabled></Input>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="15">
                    <Input v-model="$store.state.emp[formData.checker_code]" disabled></Input>
                  </Col>
                </Row>
              </FormItem>
              <FormItem label="验收员" prop="accept_code">
                <Row>
                  <Col span="8">
                    <Input v-model="formData.accept_code"></Input>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="15">
                    <Input icon="ios-more" v-model="$store.state.emp[formData.accept_code]" @on-click="openEmployee('accept_code')"></Input>
                  </Col>
                </Row>
              </FormItem>
              <FormItem label="第二验收员">
                <Row>
                  <Col span="8">
                    <Input v-model="formData.checker2"></Input>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="15">
                    <Input icon="ios-more" v-model="$store.state.emp[formData.checker2]" @on-click="openEmployee('checker2')"></Input>
                  </Col>
                </Row>
              </FormItem>
            </Col>
            <Col span="3">
              <FormItem label="单据状态">
                <div class="state " :class="formData.status?'success-bg-text':'warning-bg-text'">
                  {{formData.status?'已审核':'未审核'}}
                </div>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table border stripe size="small" :row-class-name="rowClassName" :columns="columns" :data="data"
               :height="height" @on-row-click="changeRow">
          <template slot-scope="{row,index}" slot="production_date">
            <DatePicker v-if="index==editIndex && editType" type="date" v-model="data[index].production_date"></DatePicker>
            <span v-else>{{row.production_date}}</span>
          </template>
          <template slot-scope="{row,index}" slot="production_end_date">
            <DatePicker v-if="index==editIndex && editType" type="date" v-model="data[index].production_end_date"></DatePicker>
            <span v-else>{{row.production_end_date}}</span>
          </template>
          <template slot-scope="{row,index}" slot="verify_report">
            <Select v-if="index==editIndex && editType" v-model="data[index].verify_report">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.verify_report" :value="item"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.verify_report}}</span>
          </template>
          <template slot-scope="{row,index}" slot="certificato">
            <Select v-if="index==editIndex && editType" v-model="data[index].certificato">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.certificato" :value="item"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.certificato}}</span>
          </template>
          <template slot-scope="{row,index}" slot="quality_state">
            <Select v-if="index==editIndex && editType" v-model="data[index].quality_state">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.quality_state" :value="item"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.quality_state}}</span>
          </template>
          <template slot-scope="{row,index}" slot="package_state">
            <Select v-if="index==editIndex && editType" v-model="data[index].package_state">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.package_state" :value="item"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.package_state}}</span>
          </template>
          <template slot-scope="{row,index}" slot="label_state">
            <Select v-if="index==editIndex && editType" v-model="data[index].label_state">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.label_state" :value="item"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.label_state}}</span>
          </template>
          <template slot-scope="{row,index}" slot="directions">
            <Select v-if="index==editIndex && editType" v-model="data[index].directions">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.directions" :value="item" :key="index">
                {{item}}
              </Option>
            </Select>
            <span v-else>{{row.directions}}</span>
          </template>
          <template slot-scope="{row,index}" slot="check_verdict">
            <Select v-if="index==editIndex && editType" v-model="data[index].check_verdict">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.check_verdict" :value="item"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.check_verdict}}</span>
          </template>
          <template slot-scope="{row,index}" slot="rejection_type">
            <Select v-if="index==editIndex && editType" v-model="data[index].rejection_type">
              <Option v-for="(item,index) in $store.state.sysParam.check_default.rejection_type" :value="index"
                      :key="index">{{item}}
              </Option>
            </Select>
            <span v-else>{{$store.state.sysParam.check_default.rejection_type[row.rejection_type]}}</span>
          </template>
          <template slot-scope="{row}" slot="accepter_name">
            <span>{{$store.state.emp[row.accepter]}}</span>
          </template>
        </Table>
      </div>
    </split-none>
    <select-employee ref="employeeRef" @selemp="selEmployee"></select-employee>
    <select-price ref="SelectPriceRef" @confirm="selPrice"></select-price>
  </div>
</template>

<script>
  var _this;
  import splitNone from '@/components/public/splitNone'
  import SelectEmployee from "@/components/common/SelectEmployee"
  import SelectPrice from "@/components/common/SelectPrice"
  import toUrl from "@/assets/sales_mana/sel_quality_accept.js"

  export default {
    components: {
      splitNone, SelectEmployee, SelectPrice
    },
    data: function () {
      return {
        type: 5,
        orderid: null,
        Breadcrumb: [{title: '销售管理'}, {title: '销退质量验收'}, {title: '特殊药品质量验收'}],
        editIndex: -1,
        editType: 0,
        editTypeTitle: '',
        height: 0,
        formData: {},
        columns: [
          {title: '项次', type: 'index', width: 50, minWidth: 50, resizable: true, ellipsis: true, align: 'center'},
          {title: '商品编号', key: 'goods_code', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {title: '通用名称', key: 'name', width: 120, minWidth: 120, resizable: true, ellipsis: true},
          {title: '规格', key: 'specs', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {title: '剂型', key: 'dosage', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {title: '单位', key: 'unit', width: 60, minWidth: 60, resizable: true, ellipsis: true},
          {
            title: '单价',
            key: 'price',
            width: 120,
            minWidth: 120,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'price', 1, true)
            }
          },
          {title: '金额', key: 'money', width: 100, minWidth: 100, resizable: true, ellipsis: true, align: 'right'},
          {
            title: '数量',
            key: 'amount',
            width: 120,
            minWidth: 120,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'amount', 1)
            }
          },
          {
            title: '合格数量',
            key: 'qualified_amount',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'qualified_amount', 1)
            }
          },
          {
            title: '不合格数量',
            key: 'rejection_amount',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'rejection_amount', 1)
            }
          },
          {
            title: '抽样数量',
            key: 'spot_check_amount',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'spot_check_amount', 1)
            }
          },
          {
            title: '生产批号/序列号',
            key: 'batch',
            width: 130,
            minWidth: 130,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'batch')
            }
          },
          {title: '生产日期', slot: 'production_date', width: 130, minWidth: 130, resizable: true, ellipsis: true},
          {title: '有效期至', slot: 'production_end_date', width: 130, minWidth: 130, resizable: true, ellipsis: true},
          {title: '产地', key: 'origin', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {title: '生产企业', key: 'production', width: 110, minWidth: 110, resizable: true, ellipsis: true},
          {title: '药检报告', slot: 'verify_report', width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {
            title: '通关文号',
            key: 'pass_gate_no',
            width: 110,
            minWidth: 110,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'pass_gate_no')
            }
          },
          {title: '批准文号/注册证号', key: 'approval_code', width: 140, minWidth: 140, resizable: true, ellipsis: true},
          {title: '商标', key: 'brand', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {
            title: '注册证号',
            key: 'register_card_no',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'register_card_no')
            }
          },
          {title: '合格证/装箱单', slot: 'certificato', width: 120, minWidth: 120, resizable: true, ellipsis: true},
          {title: '外观质量', slot: 'quality_state', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '包装状况', slot: 'package_state', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '标签状况', slot: 'label_state', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '说明书状况', slot: 'directions', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '验收结论', slot: 'check_verdict', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {
            title: '收货人',
            key: 'accepter',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'accepter', 0, true)
            }
          },
          {title: '收货人姓名', slot: 'accepter_name', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {
            title: '备注',
            key: 'remark',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'remark')
            }
          },
          {title: '包装规格', key: 'packspecs', width: 80, minWidth: 80, resizable: true, ellipsis: true},
          {
            title: '来源单号',
            key: 'p_orderid',
            width: 155,
            minWidth: 155,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'p_orderid')
            }
          },
          {
            title: '源单项次',
            key: 'p_item_no',
            width: 70,
            minWidth: 70,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'p_item_no', 1)
            }
          },
          {title: '不合格品处理方式', slot: 'rejection_type', width: 130, minWidth: 130, resizable: true, ellipsis: true},
          {
            title: '储存条件',
            key: 'storage_type',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'storage_type')
            }
          },
          {
            title: '退货原因',
            key: 'return_reason',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'return_reason')
            }
          },
          {
            title: '追溯号',
            key: 'traceability_code',
            width: 110,
            minWidth: 110,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'traceability_code')
            }
          },
          {title: '生产许可证编号', key: 'license_key', width: 130, minWidth: 130, resizable: true, ellipsis: true}
        ],
        data: [],
        ruleInline: {
          accept_code: [
            {type: 'string', required: true, message: '请选择验收员', trigger: 'change'}
          ]
        },
        state:0,
        empName:''
      }
    },
    activated() {
      this.orderid = localStorage.getItem("quality_gsp5_orderid");
    },
    created() {
      if (this.orderid) this.init();
    },
    mounted() {
      _this = this;
    },
    watch: {
      orderid: function (e) {
        if (this.orderid) this.orderid = e;
        this.init();
      }
    },
    methods: {
      inputEach: function (fun, key, index) {
        this.editIndex = index;
        if (fun == 'click') {
          if (key == 'price') this.$refs.SelectPriceRef.open(this.data[this.editIndex].goods_code);
          if (key == 'accepter') {
            this.state = 1;
            this.$refs.employeeRef.init();
          }
        }else if(fun == 'blur'){
          let qty = this.formatFloat(this.data[this.editIndex].amount,5);
          let qty2 = this.formatFloat(this.data[this.editIndex].qualified_amount,5);
          let qty3 = this.formatFloat(this.data[this.editIndex].rejection_amount,5);
          if (key=='amount'){
            if (qty2 && qty<qty2){
              return this.modalMsg('[验收数量]不能小于[合格数量]！')
            }
            if (qty3 && qty<qty3){
              return this.modalMsg('[验收数量]不能小于[未合格数量]！')
            }
            qty2 = qty2?qty2:qty;
            qty3 = qty2?this.formatFloat(qty - qty2,5):0;
            this.data[this.editIndex].qualified_amount = qty2;
            this.data[this.editIndex].rejection_amount = qty3;
            this.changeAmount();
          }
          if (key=='qualified_amount'){
            if (qty2>qty){
              return this.modalMsg('[验收数量]不能小于[合格数量]！')
            }
            qty3 = this.formatFloat(qty - qty2,5);
            this.data[this.editIndex].rejection_amount = qty3;
            this.changeAmount();
          }
          if (key=='rejection_amount'){
            if (qty3>qty){
              return this.modalMsg('[验收数量]不能小于[未合格数量]！')
            }
            qty2 = qty3?this.formatFloat(qty-qty3,5):qty;
            this.data[this.editIndex].qualified_amount = qty2;
            this.changeAmount();
          }
        }else{
          this.$set(this.data[index], key, this.custRender.KValue);
        }
      },
      rowClassName(row, index) {
        if (index === this.editIndex) {
          this.$set(this.data[index], 'isEdit', this.editType ? true : false);
          return 'ivu-table-row-highlight';
        } else this.$set(this.data[index], 'isEdit', false);
        return '';
      },
      init: function () {
        this.common.http({
          url: 'getGoodsCheckAcceptDtl',
          data: {type: this.type, orderid: this.orderid}
        }).then(function (res) {
          if (res.status) {
            _this.formData = res.form;
            _this.data = res.details;
          }else{
            _this.modalMsg(res.msg)
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this)
        })
      },
      save: function () {
        if (!this.editType) return false;
        var validate = this.checkData();
        if(!validate.status){
          return this.modalMsg(validate.msg);
        }
        var data = {formData: this.formData, dtlData: this.data};
        this.$refs.FormRef.validate((valid) => {
          if (valid) {
            _this.common.http({
              url: 'editGoodsCheckAccept',
              data: data
            }).then(function (res) {
              if (res.status) {
                _this.editType = 0;
                _this.editTypeTitle = '';
                _this.init();
              } else {
                _this.modalMsg(res.msg);
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this);
            })
          }
        })
      },
      /*审核单据*/
      checker: function () {
        if (this.editType) return this.alertMsg('请保存单据后再试！', 'error')
        this.$Modal.confirm({
          title: '提示',
          content: '确定要审核当前质量验收单吗?',
          onOk: function () {
            _this.common.http({
              url: 'checkQuality',
              data: {type: _this.type, orderid: _this.orderid}
            }).then(function (res) {
              if (res.status == 1) {
                _this.init();
                setTimeout(function () {
                  _this.$Modal.confirm({
                    title: '提示',
                    content: '<p>从来货登记单【' + _this.formData.come_orderid + '】生成的质量验收单还有如下单据未审核,您需要查看这些单据吗?</p>' + res.orderid + '<p></p>',
                    onOk: function () {
                      toUrl.toTypeUrl(res.type, res.orderid, _this);
                    }
                  })
                }, 300)
              } else if (res.status == 2) {
                _this.init();
                setTimeout(function () {
                  _this.$Modal.confirm({
                    title: '提示',
                    content: res.msg,
                    onOk: function () {
                      localStorage.setItem("recheck_orderid", res.orderid);
                      _this.toUrl("/editReCheck");
                    }
                  })
                }, 300)
              } else {
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                }, 300);
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this);
            })
          }
        })
      },
      dtl(){
        if (this.editType) return false;
        this.$Modal.confirm({
          title:"提示信息",
          content:'确定要删除该单据吗？',
          onOk(){
            _this.common.http({
              url: 'delGoodsCheckAccept',
              data:{type:_this.type,orderid:_this.orderid}
            }).then(function (res) {
              if (res.status) {
                localStorage.removeItem("quality_gsp5_orderid")
                if (res.orderid){
                  localStorage.setItem("quality_gsp5_orderid",res.orderid);
                  _this.orderid = res.orderid;
                  _this.init();
                }else{
                  _this.editType = 0;
                  _this.editTypeTitle = '';
                  _this.formData = {};
                  _this.data = [];
                }
              }else{
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this);
            })
          }
        })
      },
      reduction(){
        if (this.editType) return false;
        this.$Modal.confirm({
          title:"提示信息",
          content:'确定要还原当前已经审核过的数据吗？',
          onOk(){
            _this.common.http({
              url: 'backGoodsCheckAccept',
              data:{orderid: _this.orderid}
            }).then(function (res) {
              if (res.status) {
                _this.init();
              }else{
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this);
            })
          }
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
      editData: function () {
        this.editType = 1;
        this.editTypeTitle = '编辑';
      },
      openEmployee: function (name) {
        if (!this.editType) return false;
        this.empName = name;
        this.$refs.employeeRef.init();
      },
      selEmployee: function (e) {
        if (!this.state){
          this.formData[this.empName] = e.code;
        }else{
          this.$set(this.data[this.editIndex],'accepter',e.code)
        }
      },
      selPrice(e) {
        this.$set(this.data[this.editIndex], 'price', e.price1);
        this.changeAmount();
      },
      changeAmount(){
        var qty = this.formatFloat(this.data[this.editIndex].amount,5);
        var price = this.formatFloat(this.data[this.editIndex].price,6);
        var money = this.formatFloat(qty * price,6);
        this.data[this.editIndex].amount = qty;
        this.data[this.editIndex].money = money;
      },
      checkData(){
        var relu = {status:0,msg:''};
        if (!this.data.length) return false;
        for (let i=0;i<this.data.length;i++){
          let qty1 = this.formatFloat(this.data[i].amount,5);
          let qty2 = this.formatFloat(this.data[i].qualified_amount,6);
          let qty3 = this.formatFloat(this.data[i].rejection_amount,6);
          if (qty1<qty2){
            relu.msg = '[验收数量]不能小于[合格数量]！';
            return relu;
          }
          if (qty1<qty3){
            relu.msg = '[验收数量]不能小于[未合格数量]！';
            return relu;
          }
        }
        relu.status=1;
        return relu;
      },
      changeRow: function (item, index) {
        this.editIndex = index;
      },
      refresh: function () {
        this.init();
      },
      dHeight: function (e) {
        this.height = e;
      },
      out(){
        this.delView('SelQualityAcceptGsp5');
      },
    }
  }
</script>

<style lang="less">
  .state {
    text-align: center;
    font-size: 14px;
  }
</style>
