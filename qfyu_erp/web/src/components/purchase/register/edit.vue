<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" :editTypeTitle="editTypeTitle" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button @click="add" :disabled="!editType?false:true"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="onClickEdit" :disabled="(formData.status!=1 && !editType)?false:true"><span
            class="icon iconfont">&#xe791;</span>编辑
          </Button>
          <Button :disabled="formData.status?true:false"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="keep" :disabled="(formData.status || !editType)?true:false"><span class="icon iconfont">&#xe792;</span>保存
          </Button>
          <Button @click="cancelData" :disabled="formData.status?true:false"><span class="icon iconfont">&#xe7fd;</span>取消
          </Button>
          <Divider type="vertical"/>
          <Button><span class="icon iconfont">&#xe697;</span>监管码</Button>
          <Button><span class="icon iconfont">&#xe698;</span>药检报告</Button>
          <Button @click="openBill">随货同行发票信息</Button>
          <Divider type="vertical"/>
          <Button @click="openChecker" :disabled="(formData.status || editType)?true:false">
            <span class="icon iconfont">&#xe692;</span>审核
          </Button>
          <Button :disabled="formData.status?false:true"><span class="icon iconfont">&#xe69a;</span>转销售</Button>
          <Divider type="vertical"/>
          <Button @click="toUrl('/registerList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form ref="formDataRef" style="width:1200px;padding-top: 5px;" :model="formData" :rules="ruleFormData" :label-width="95" :disabled="!editType?true:false">
          <Row>
            <Col span="6">
              <FormItem label="单据号">
                <Input disabled v-model="formData.orderid" placeholder="由系统自动生产"></Input>
              </FormItem>
              <FormItem label="接货日期">
                <Row>
                  <Col span="14">
                    <DatePicker format="yyyy年MM月dd日" type="date" v-model="formData.receiving_date"></DatePicker>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="9">
                    <TimePicker type="time" v-model="formData.receiving_time"></TimePicker>
                  </Col>
                </Row>
              </FormItem>
              <FormItem label="采购订单号">
                <Input v-model="formData.o_orderid" placeholder="采购订单编号"></Input>
              </FormItem>
              <FormItem label="运输方式">
                <Input v-model="formData.transport_type" placeholder="请输入运输方式"></Input>
              </FormItem>
              <FormItem label="运输设备">
                <Input v-model="formData.transport_equipment" placeholder="请输入运输设备"></Input>
              </FormItem>
              <FormItem label="运输车牌号">
                <Input v-model="formData.car_number" placeholder="请输入运输车牌号"></Input>
              </FormItem>
              <FormItem label="收货仓库">
                <Row>
                  <Col span="7">
                    <Input v-model="formData.ware_id" disabled></Input>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="16">
                    <Input v-model="formData.ware_name" placeholder="请选择收货仓库" disabled>
                      <Button class="clear-btn" slot="append" icon="ios-more" @click="openWarehouse"></Button>
                    </Input>
                  </Col>
                </Row>
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem label="供应商" prop="supplier_code">
                <Row>
                  <Col span="7"><Input v-model="formData.supplier_code" disabled></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="16">
                    <Input v-model="formData.supplier_name" disabled>
                      <Button class="clear-btn" slot="append" icon="ios-more" @click="openProviders(null)"></Button>
                    </Input>
                  </Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="合同号">
                    <Input v-model="formData.contract_no"></Input>
                  </FormItem>
                  <FormItem label="结算方式" prop="pay_type">
                    <Select v-model="formData.pay_type" @on-change="changePay">
                      <Option v-for="(item,key,index) in $store.state.settlement" :value="key" :key="index">{{item}}
                      </Option>
                    </Select>
                  </FormItem>
                  <FormItem label="供应商备注">
                    <Input v-model="formData.supplier_remark" disabled></Input>
                  </FormItem>
                  <FormItem label="供方销售单号">
                    <Input v-model="formData.supplier_orderid"></Input>
                  </FormItem>
                  <FormItem label="特殊品运输证">
                    <Input v-model="formData.transport_certificate"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="业务员" prop="salesman">
                    <Input v-model="$store.state.emp[formData.salesman]" disabled>
                      <Button class="clear-btn" slot="append" icon="ios-more" @click="openEmployee(0)"></Button>
                    </Input>
                  </FormItem>
                  <FormItem label="复核员">
                    <Input v-model="formData.checker_code" disabled></Input>
                  </FormItem>
                  <FormItem label="流水号">
                    <Input v-model="formData.serial_number"></Input>
                  </FormItem>
                  <FormItem label="运输时间">
                    <Input v-model="formData.hours"></Input>
                  </FormItem>
                  <FormItem label="温度状况">
                    <Input v-model="formData.temperature"></Input>
                  </FormItem>
                </Col>
              </Row>
              <div class="font-type">
                <Checkbox v-model="single">半年内过期的商品显示粗体</Checkbox>
                <Checkbox v-model="single1">未导入药检报告显示斜体</Checkbox>
              </div>
            </Col>
            <Col span="4">
              <FormItem label="供方销售人员">
                <Input v-model="formData.supplier_sale" disabled>
                  <Button class="clear-btn" slot="append" icon="ios-more" @click="openProidersSale(1)"></Button>
                </Input>
              </FormItem>
              <FormItem label="供方联系人">
                <Input v-model="formData.supplier_contact" disabled>
                  <Button class="clear-btn" slot="append" icon="ios-more" @click="openProidersSale(2)"></Button>
                </Input>
              </FormItem>
              <FormItem label="供方部门">
                <Input v-model="formData.supplier_depart" disabled></Input>
              </FormItem>
              <FormItem label="第一收货人">
                <Input v-model="$store.state.emp[formData.cnee_code1]" disabled>
                  <Button class="clear-btn" slot="append" icon="ios-more" @click="openEmployee(1)"></Button>
                </Input>
              </FormItem>
              <FormItem label="第二收货人">
                <Input v-model="$store.state.emp[formData.cnee_code2]">
                  <Button class="clear-btn" slot="append" icon="ios-more" @click="openEmployee(2)"></Button>
                </Input>
              </FormItem>
              <div class="font-type">
                <Checkbox :true-value="1" :false-value="0" v-model="formData.recipient_status">代销收货</Checkbox>
                <Checkbox :true-value="1" :false-value="0" v-model="formData.sale_status">委托销售</Checkbox>
              </div>
              <div class="nav-menu">
                <Button type="primary" @click="addRow"><span class="icon iconfont">&#xe797;</span>新增行</Button>
                <Button type="primary" @click="delRow"><span class="icon iconfont">&#xe6a5;</span>删除行</Button>
              </div>
            </Col>
            <Col span="4">
              <FormItem label="状态">
                <span class="stats" :class="formData.status?' success-bg-text':' warning-bg-text'">{{formData.status?"已审核":"未审核"}}</span>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table size="small" context-menu show-context-menu border :row-class-name="rowClassName" :columns="columns"
               :data="data" :height="height-73" @on-row-click="changeRow" @on-contextmenu="openMenu">
          <template slot-scope="{row}" slot="is_first">
            <span>{{row.is_first==1?'是':'否'}}</span>
          </template>
          <template slot-scope="{row,index}" slot="production_date">
            <DatePicker v-if="editType && editIndex===index" type="date"
                        v-model="data[index].production_date"></DatePicker>
            <span v-else>{{row.production_date}}</span>
          </template>
          <template slot-scope="{row,index}" slot="production_end_date">
            <DatePicker v-if="editType && editIndex===index" type="date"
                        v-model="data[index].production_end_date"></DatePicker>
            <span v-else>{{row.production_end_date}}</span>
          </template>
          <template slot-scope="{row,index}" slot="product_status">
            <Select v-if="editType && editIndex===index" v-model="data[index].product_status">
              <Option v-for="(item,key) in $store.state.sysParam.goods_status" :value="item" :key="key">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.product_status}}</span>
          </template>
          <template slot-scope="{row,index}" slot="quality_status">
            <Select v-if="editType && editIndex===index" v-model="data[index].quality_status">
              <Option v-for="(item,key) in $store.state.sysParam.quality_status" :value="item" :key="key">{{item}}
              </Option>
            </Select>
            <span v-else>{{row.quality_status}}</span>
          </template>
          <template slot="contextMenu">
            <DropdownItem @click.native="handleContextMenuEdit">查看药检报告</DropdownItem>
            <DropdownItem @click.native="handleContextMenuDelete">导入药检报告</DropdownItem>
          </template>
        </Table>
        <Form style="padding: 5px 0" :model="formData" :label-width="90" :disabled="!editType?true:false">
          <Row>
            <Col span="4">
              <FormItem label="货品总数">
                <Input disabled :value="formData.total_amount"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="货款">
                <Input disabled v-model="formData.total_money"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="税款">
                <Input disabled v-model="formData.taxes"></Input>
              </FormItem>
            </Col>
            <Col span="5">
              <FormItem label="合计">
                <Input disabled v-model="formData.total_payprice"></Input>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="8">
              <FormItem label="备注">
                <Input v-model="formData.remark" placeholder="请填写来货登记订单备注"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="创建者">
                <Input disabled v-model="$store.state.emp[formData.creator_code]"></Input>
              </FormItem>
            </Col>
            <Col span="5">
              <FormItem label="创建日期">
                <Input disabled v-model="formData.creation_date"></Input>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
    </split-none>
    <Modal v-model="billModal" title="发票信息" width="450">
      <Form ref="biilDataRef" :model="billData" :rules="billRules" :label-width="90">
        <FormItem label="发票号码" prop="bill_no">
          <Row>
            <Col span="18"><Input v-model="billData.bill_no" maxlength="20"></Input></Col>
            <Col span="1">&nbsp;</Col>
            <Col span="5">
              <Button type="primary"><span class="icon iconfont">&#xe691;</span>查询</Button>
            </Col>
          </Row>
        </FormItem>
        <FormItem label="来货单号">
          <Input v-model="billData.orderid" disabled></Input>
        </FormItem>
        <FormItem label="发票抬头">
          <Input v-model="billData.title" maxlength="50"></Input>
        </FormItem>
        <FormItem label="发票地址">
          <Input v-model="billData.address" show-word-limit maxlength="60"></Input>
        </FormItem>
        <FormItem label="发票类型" prop="type">
          <Select v-model="billData.type" style="width: 200px">
            <Option v-for="(item,index) in $store.state.sysParam.billing_type" :value="index" :key="index">{{item}}
            </Option>
          </Select>
        </FormItem>
        <FormItem label="发票日期">
          <DatePicker type="date" v-model="billData.create_date" style="width: 200px"></DatePicker>
        </FormItem>
        <FormItem label="发票总金额" prop="money">
          <InputNumber :precision="2" :active-change="false" v-model="billData.money" maxlength="15" :min="0.01"
                       :max="999999999"></InputNumber>
        </FormItem>
        <FormItem label="发票轨号">
          <Input v-model="billData.track" show-word-limit maxlength="20"></Input>
        </FormItem>
        <FormItem label="发票电话">
          <Input v-model="billData.tel" show-word-limit maxlength="20"></Input>
        </FormItem>
        <FormItem label="备注">
          <Input v-model="billData.remark" show-word-limit maxlength="50"></Input>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="billConfirm(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="billConfirm(false)"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
      </div>
    </Modal>
    <Modal v-model="procedure" title="采购流程选项" footer-hide class-name="vertical-center-modal" :mask-closable="false">
      <Row>
        <Col span="18" class-name="border-color bor-box">
          <span class="bor-title bg txt-color">来货登记单审核选项</span>
          <div class="bor-top">
            <Form :label-width="50">
              <FormItem>
                <RadioGroup v-model="process">
                  <Radio :label="1">一步操作完成采购</Radio>
                  <div class="child-box" :class="process==1?'':' bg-m'">
                    <div class="txt-color">收货仓匹配方式</div>
                    <div class="child-box-pad">
                      <RadioGroup v-model="ware_type">
                        <Radio :label="1" :disabled="process==1?false:true">仅自动匹配</Radio>
                        <Radio :label="2" :disabled="process==1?false:true">先自动匹配,然后匹配指定仓库</Radio>
                        <Radio :label="3" :disabled="process==1?false:true">直接指定收货仓库</Radio>
                      </RadioGroup>
                      <Row class-name="warehouse">
                        <Col span="6" class-name="txt-color">收货仓库:</Col>
                        <Col span="16">
                          <Input v-model="formData.ware_name" disabled>
                            <Button class="clear-btn" slot="append" icon="ios-more" :disabled="process==1?false:true"
                                    @click="openWarehouse"></Button>
                          </Input>
                        </Col>
                      </Row>
                      <Row class-name="error-text">会覆盖来货登记单上指定的仓库</Row>
                    </div>
                  </div>
                  <Radio :label="2">走完整流程(原方式)</Radio>
                </RadioGroup>
                <Checkbox v-model="checker_status">自动审核入库单</Checkbox>
              </FormItem>
            </Form>
          </div>
        </Col>
        <Col span="6" class-name="nav-menu">
          <Button type="primary" @click="checkerConfirm(true)"><span class="icon iconfont">&#xe7fe;</span>确定</Button>
          <Button @click="checkerConfirm(false)"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
        </Col>
      </Row>
      <Row class-name="bor-footer">
        <Checkbox v-model="active">记住我的选择</Checkbox>
      </Row>
    </Modal>
    <Modal v-model="fileModal" title="导入药检报告">
      <Form :label-width="80">
        <FormItem label="商品编号">
          <Input v-model="fileData.goods_code" disabled></Input>
        </FormItem>
        <FormItem label="商品名称">
          <Input v-model="fileData.name" disabled></Input>
        </FormItem>
        <FormItem label="生产批号">
          <Input v-model="fileData.batch" disabled></Input>
        </FormItem>
        <FormItem label="供应商编号">
          <Input v-model="formData.supplier_code" disabled></Input>
        </FormItem>
        <FormItem label="供应商名称">
          <Input v-model="formData.supplier_name" disabled></Input>
        </FormItem>
        <FormItem label="药检报告">
          <div class="drug-img border-class"><img :src="BASE_URL+fileData.file_path" alt=""/></div>
        </FormItem>
        <FormItem label="上传报告">
          <upload action="drugUoload" :extraData="{code:fileData.goods_code,ABType:fileData.ABType}"
                  :imgName="formData.supplier_code" @upSuccess="upSuccess" @upProgress="upProgress">
          </upload>
        </FormItem>
        <FormItem label="AB面">
          <RadioGroup v-model="fileData.ABType" @on-change="changeABType">
            <Radio label="A"><span>A面</span></Radio>
            <Radio label="B"><span>B面</span></Radio>
          </RadioGroup>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="confirmDrug(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="confirmDrug(false)" icon="md-close">取消</Button>
      </div>
    </Modal>
    <choose-providers ref="providersRef" @confirm="selectProviders"></choose-providers>
    <select-employee ref="employeeRef" @selemp="selEmployee"></select-employee>
    <choose-goods ref="selectGoodsRef" :isSignle="false" refname="selectGoodsRef" fun="openProviders" @selectRow="selGoods"></choose-goods>
    <choose-supsales ref="ChooseSupsalesRef" @confirm="selProidersSale"></choose-supsales>
    <choose-ware ref="selChooseWare" @confirm="selWarehouse"></choose-ware>
    <view-drug ref="ViewDrug"></view-drug>
    <select-price ref="selPriceRef" @confirm="selPrice"></select-price>
  </div>
</template>

<script>
  import splitNone from "@/components/public/splitNone"
  import chooseProviders from "@/components/common/ChooseProviders"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import ChooseGoods from "@/components/common/ChooseGoods"
  import ChooseSupsales from "@/components/common/ChooseSupsales"
  import ChooseWare from "@/components/common/ChooseWare"
  import upload from '@/components/public/upload.vue'
  import ViewDrug from "@/components/common/ViewDrug"
  import SelectPrice from "@/components/common/SelectPrice"
  var _this,
    formData = {
      orderid: '', receiving_date: new Date(), receiving_time: '', o_orderid: '', transport_type: '', transport_equipment: '', car_number: '', ware_id: null, ware_name: '', supplier_code: null, supplier_name: '', contract_no: '', pay_type: null, supplier_remark: '', supplier_orderid: '', transport_certificate: '', salesman: null, salesman_name: '', checker_code: '', serial_number: '', hours: '', temperature: '', supplier_sale: '', supplier_contact: '', supplier_depart: '', cnee_code1: null, cnee_code2: null, recipient_status: 0, sale_status: 0, status: 0, total_amount: null, total_money: null, taxes: null, total_payprice: null, remark: null, creator_code: '', creation_date: ''
    },
    defaultData = {
      goods_code: '',name: '',specs: '',dosage: '',unit: '',unit2: '',unit3: '',order_amount: null,come_amount: null,discount: null,gift_amount: null,rejection_amount: null,rejection_remark: '',order_no: '',tax: null,not_tax_price: null,not_tax_money: null,tax_total: null,total_price: null,first_price: null,near_price: null,low_price: null,high_price: null,standard_price: null,retail_price: null,gross_profit: '',qualified_amout: null,origin: '',production: '',remark: '',is_first: '',en_name: '',supplier_no: '',new_whole: null,new_retail: null,receipts_amout: null,price1: null,price: null,batch: '',production_date: null,production_end_date: null,supplier_orderid: '',supplier_goods_code: '',packspecs: '',pifaml: null,retail: null,storage_type: null,supplier_sale_orderid: '',code: '',file_name: '',custom_code1: '',custom_code2: '',custom_code3: '',traceability_code: '',sterilization_batch: '',production_code: '',drug: '',product_status: '',quality_status: '',del_remark: '',r_orderid: ''
    };
  export default {
    name: "edit",
    components: {
      splitNone,chooseProviders,SelectEmployee,ChooseGoods,ChooseSupsales,ChooseWare,upload,ViewDrug,SelectPrice
    },
    data: function () {
      return {
        Breadcrumb: [{title: '采购管理'}, {title: '来货登记', url: '/registerList'}, {title: '登记明细'}],
        editIndex: -1,
        editType: 0,
        editTypeTitle: '',
        height: 0,
        orderid: null,
        formData: formData,
        billData: {bill_no: '', orderid: '', address: '', title: '', type: null, create_date: null, money: null, track: '', tel: '', remark: ''},
        billModal: false,
        columns: [
          {title: '项次', type: 'index', width: 50, minWidth: 50, resizable: true, ellipsis: true,align:'center'},
          {title: '商品编号', key: 'goods_code', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '通用名称', key: 'name', width: 150, minWidth: 150, resizable: true, ellipsis: true},
          {title: '规格', key: 'specs', width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {title: '剂型', key: 'dosage', width: 70, minWidth: 70, resizable: true, ellipsis: true},
          {title: '单位', key: 'unit', width: 60, minWidth: 60, resizable: true, ellipsis: true, align: 'center'},
          {
            title: '订货数量',
            key: 'order_amount',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'order_amount', 1)
            }
          },
          {
            title: '来货数量',
            key: 'come_amount',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'come_amount', 1)
            }
          },
          {
            title: '折扣(%)',
            key: 'discount',
            width: 80,
            minWidth: 80,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'discount', 1)
            }
          },
          {
            title: '赠品数量',
            key: 'gift_amount',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'gift_amount', 1)
            }
          },
          {
            title: '拒收数量',
            key: 'rejection_amount',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'rejection_amount', 1)
            }
          },
          {
            title: '拒收原因',
            key: 'rejection_remark',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'rejection_remark')
            }
          },
          {
            title: '实收数量',
            key: 'receipts_amout',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'receipts_amout', 1)
            }
          },
          {
            title: '合格数量',
            key: 'qualified_amout',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right'
          },
          {
            title: '来货序号',
            key: 'order_no',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'order_no', 1)
            }
          },
          {
            title: '税率(%)',
            key: 'tax',
            width: 80,
            minWidth: 80,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'tax', 1)
            }
          },
          {
            title: '无税单价',
            key: 'not_tax_price',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right'
          },
          {
            title: '无税金额',
            key: 'not_tax_money',
            width: 100,
            minWidth: 100,
            resizable: true,
            ellipsis: true,
            align: 'right'
          },
          {title: '税款', key: 'tax_total', width: 110, minWidth: 110, resizable: true, ellipsis: true, align: 'right'},
          {title: '合计', key: 'total_price', width: 100, minWidth: 100, resizable: true, ellipsis: true, align: 'right'},
          {title: '最近进价', key: 'near_price', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '最初进价', key: 'first_price', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '最高进价', key: 'high_price', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '最低进价', key: 'low_price', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '参考批发价', key: 'standard_price', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '参考零售价', key: 'retail_price', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {
            title: '最新批发价',
            key: 'new_whole',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'new_whole', 1)
            }
          },
          {
            title: '最新零售价',
            key: 'new_retail',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'new_retail', 1)
            }
          },
          {
            title: '单价',
            key: 'price1',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'price1', 1, true)
            }
          },
          {
            title: '实际单价',
            key: 'price',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'price', 1)
            }
          },
          {title: '毛利率分类', key: 'gross_profit', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '参考批发毛利', key: 'pifaml', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '参考零售毛利', key: 'retail', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '产地', key: 'origin', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '生产企业', key: 'production', width: 180, minWidth: 180, resizable: true, ellipsis: true},
          {
            title: '备注',
            key: 'remark',
            width: 120,
            minWidth: 120,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'remark')
            }
          },
          {title: '首营商品', slot: 'is_first', width: 70, minWidth: 70, resizable: true, ellipsis: true, align: 'center'},
          {title: '英文名称', key: 'en_name', width: 110, minWidth: 110, resizable: true, ellipsis: true},
          {title: '供方发货项次', key: 'supplier_no', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '生产批号', key: 'batch', width: 110, minWidth: 110, resizable: true, ellipsis: true,render:(h,params)=>{return this.custRender.renderInput(this,h,params,'batch')}},
          {title: '生产日期', slot: 'production_date', width: 110, minWidth: 110, resizable: true, ellipsis: true},
          {title: '有效期至', slot: 'production_end_date', width: 110, minWidth: 110, resizable: true, ellipsis: true},
          {title: '供方发货单号', key: 'supplier_orderid', width: 140, minWidth: 140, resizable: true, ellipsis: true},
          {title: '包装规格', key: 'packspecs', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '储存条件', key: 'storage_type', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {
            title: '供方销售单号',
            key: 'supplier_sale_orderid',
            width: 130,
            minWidth: 130,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'supplier_sale_orderid')
            }
          },
          {title: '条码一', key: 'code', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '附件名', key: 'file_name', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '商品匹配码一', key: 'custom_code1', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '商品匹配二', key: 'custom_code2', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '商品匹配三', key: 'custom_code3', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {
            title: '追溯号',
            key: 'traceability_code',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'traceability_code')
            }
          },
          {
            title: '灭菌批号',
            key: 'sterilization_batch',
            width: 90,
            minWidth: 90,
            resizable: true,
            ellipsis: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'sterilization_batch')
            }
          },
          {title: '生产许可证号', key: 'production_code', width: 120, minWidth: 120, resizable: true, ellipsis: true},
          {title: '药检报告', key: 'drug', width: 90, minWidth: 90, resizable: true, ellipsis: true},
          {title: '货品状态', slot: 'product_status', width: 100, minWidth: 100, resizable: true, ellipsis: true},
          {title: '质量状态', slot: 'quality_status', width: 100, minWidth: 100, resizable: true, ellipsis: true}
        ],
        data: [],
        single: true,
        single1: true,
        selType: null,
        saleType: null,
        ruleFormData:{
          supplier_code: [
            {required: true, type: 'string', message: '请选择供应商', trigger: 'change'}
          ],
            salesman: [
            {required: true, type: 'string', message: '请选择业务员', trigger: 'change'}
          ],
            pay_type: [
            {required: true, type: 'string', message: '请选择结算方式', trigger: 'change'}
          ]
        },
        defaultData: defaultData,
        provIndex: null,
        billRules: {
          bill_no: [
            {required: true, type: 'string', message: '请填写发票号码', teigger: 'blur'}
          ],
          type: [
            {required: true, type: 'number', message: '请选择发票类型', teigger: 'change'}
          ],
          money: [
            {required: true, type: 'number', message: '请输入发票金额', teigger: 'change'}
          ],
        },
        procedure: false,
        process: 1,
        ware_type: 2,
        checker_status: true,
        active: false,
        fileModal: false,
        fileData: {goods_code: '', name: '', batch: '', file_path: '', ABType: 'A'},
        BASE_URL: this.common.BASE_URL
      }
    },
    activated() {
      this.orderid = localStorage.getItem("edit_register_orderid");
      if (!this.orderid) {
        this.editType = 1;
        this.editTypeTitle = '新增';
      }
    },
    mounted() {
      _this = this;
      var date = new Date();
      var h = date.getHours();
      var i = date.getMinutes();
      var s = date.getSeconds();
      this.formData.receiving_time = h + ':' + i + ':' + s;
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
        if(fun == 'click') {
          if (key=='price1') this.$refs.selPriceRef.open(this.data[index].goods_code);
        }else if(fun=='blur'){
          if (key=='order_amount'){
            this.data[index].rejection_amount = 0;
            this.data[index].come_amount = this.data[index].come_amount?this.data[index].come_amount:this.data[index].order_amount;
            this.data[index].receipts_amout = this.data[index].receipts_amout?this.data[index].receipts_amout:this.data[index].order_amount;
          }
          if (key=='rejection_amount'){
            this.data[index].receipts_amout = this.formatFloat(this.data[index].come_amount-this.data[index].rejection_amount,5);
          }
          if (key=='receipts_amout'){
            this.data[index].rejection_amount = this.formatFloat(this.data[index].come_amount-this.data[index].receipts_amout,5)
          }
          if (key=='order_amount' || key=='come_amount' || key=='discount' || key=='tax' || key=='rejection_amount' || key=='receipts_amout') this.computingMethod();
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
      onClickEdit: function () {
        this.editType = 1;
        this.editTypeTitle = '编辑';
      },
      cancelData: function () {
        if (!this.editType) return false;
        this.$Modal.confirm({
          title: '提示',
          content: '确定要取消对当前单据所作的修改吗?',
          onOk: function () {
            _this.$refs.formDataRef.resetFields();
            _this.editType = 0;
            _this.editTypeTitle = '';
            _this.init();
          }
        })
      },
      //初始化
      init: function () {
        this.common.http({
          url: 'getRegisterDel',
          data: {orderid: this.orderid}
        }).then(function (res) {
          if (res.status) {
            _this.$refs.formDataRef.resetFields();
            _this.$refs.biilDataRef.resetFields();
            _this.formData = typeof (res.form) == "undefined" ? JSON.parse(JSON.stringify(formData)) : res.form;
            _this.data = typeof (res.data) == "undefined" ? [] : res.data;
            _this.billData = res.bill.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this)
        })
      },
      //保存来货登记
      keep: function () {
        if (!this.editType) return false;
        this.formData.receiving_date = this.getDateVal(this.formData.receiving_date, false) + ' ' + this.formData.receiving_time;
        this.$refs.formDataRef.validate((valid) => {
          if (valid) {
            var checker = this.checkOrder(this.data);
            if (!checker) return false;
            _this.common.http({
              url: 'addRegister',
              data: {formData: _this.formData, data: JSON.stringify(_this.data)}
            }).then(function (res) {
              if (res.status == 1) {
                localStorage.setItem("edit_register_orderid", res.orderid);
                _this.orderid = res.orderid;
                _this.editType = 0;
                _this.editTypeTitle = '';
                _this.init();
              } else if (res.status == 2) {
                _this.formData.salesman = res.salesman;
                _this.formData.salesman_name = res.salesman_name;
              } else {
                _this.modalMsg(res.msg);
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this);
            })
          } else {
            _this.modalMsg('请完善资料后提交！');
          }
        });
      },
      //点击审核按钮
      openChecker: function () {
        if (!this.orderid) return false;
        if (this.editType) return false;
        this.$Modal.confirm({
          title: '提示',
          content: '确定要审核当前来货登记单吗?',
          onOk: function () {
            _this.procedure = true;
          }
        });
      },
      //审核来货登记
      checkerConfirm: function (type) {
        this.procedure = false;
        if (!this.orderid) {
          return this.modalMsg('请先保存后再试！');
        }
        if (!this.data.length) {
          return this.modalMsg('缺少商品明细！');
        }
        this.common.http({
          url: 'checkRegister',
          data: {
            process: this.process,
            ware_type: this.ware_type,
            checker_status: this.checker_status,
            orderid: this.orderid,
            ware_id: formData.ware_id
          }
        }).then(function (res) {
          if (res.status) {
            _this.$Modal.confirm({
              title: '提示',
              content: '<p>' + res.orderid + '号来货登记单已生成：</p>' + res.msg + '</p><p>要查看这些单据吗？</p>',
              onOk: function () {
                localStorage.setItem("quality_accept_orderid", res.orderid);
                _this.init();
                _this.toUrl('/qualityList');
              }
            })
          } else {
            _this.modalMsg(res.msg);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      //新增-修改来货登记
      add: function () {
        if (this.editType) return false;
        this.editType = 1;
        this.editTypeTitle = '新增';
        localStorage.removeItem("edit_register_orderid");
        this.formData = JSON.parse(JSON.stringify(formData));
        this.orderid = null;
        this.data = [];
      },
      //发票
      openBill: function () {
        if (!this.formData.orderid) {
          return this.modalMsg('请保存单据后再试！');
        }
        if (!this.billData.orderid) {
          this.common.http({
            url: 'getBillDetail',
            data: {orderid: this.formData.orderid}
          }).then(function (res) {
            _this.$refs.biilDataRef.resetFields();
            _this.billModal = true;
            _this.billData = res.data;
          }).catch(function (err) {
            _this.common.httpErr(err.data, _this)
          });
        } else {
          this.billModal = true;
        }

      },
      billConfirm: function (type) {
        if (!type) return this.billModal = false;
        this.$refs.biilDataRef.validate((valid) => {
          if (valid) {
            this.common.http({
              url: 'editBill',
              data: {data: _this.billData}
            }).then(function (res) {
              if (res.status) {
                _this.billModal = false;
              } else {
                _this.modalMsg(res.msg);
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data, _this);
            })
          } else {
            this.modalMsg('请完善资料后提交！');
          }
        });
      },
      openProviders: function (provIndex) {
        this.provIndex = provIndex;
        this.$refs.providersRef.open();
      },
      openProidersSale: function (type) {
        this.saleType = type;
        if (!this.formData.supplier_code) {
          return this.modalMsg('请先选择供应商');
        }
        this.$refs.ChooseSupsalesRef.open(type, this.formData.supplier_code);
      },
      //选择供应商销售人-联系人
      selProidersSale: function (e) {
        if (this.saleType == 1) {
          this.formData.supplier_sale = e.user_name;
        } else if (this.saleType == 2) {
          this.formData.supplier_contact = e.user_name;
        }
      },
      //选择供应商
      selectProviders: function (e) {
        if (this.provIndex != null) {
          this.$refs[this.provIndex].selectProvNotify(e);
        } else {
          this.formData.salesman = e.business_leader;
          this.formData.salesman_name = this.$store.state.emp[e.business_leader];
          this.formData.pay_type = e.pay_mode_no;
          this.formData.supplier_code = e.supplier_code;
          this.formData.supplier_name = e.full_name;
          this.formData.supplier_remark = e.remark;
          this.formData.supplier_depart = e.subject_dept;
          this.$refs.ChooseSupsalesRef.initSup(e.supplier_code, function (res, res1) {
            _this.formData.supplier_sale = res ? res.user_name : '';
            _this.formData.supplier_contact = res1 ? res1.user_name : '';
          })
        }
      },
      openEmployee: function (type) {
        this.selType = type;
        this.$refs.employeeRef.init({show_self: 1});
      },
      //选择业务员-第一收货员...
      selEmployee: function (e) {
        if (this.selType == 1) {
          this.formData.cnee_code1 = e.code;
        } else if (this.selType == 2) {
          this.formData.cnee_code2 = e.code;
        } else if (this.selType == 0) {
          this.formData.salesman = e.code;
        }
      },
      openWarehouse: function () {
        this.$refs.selChooseWare.open();
      },
      //选择仓库
      selWarehouse: function (e) {
        this.formData.ware_id = e.ware_code;
        this.formData.ware_name = e.ware_title;
      },
      //单击选择行-双击行编辑行
      changeRow: function (item, index) {
        if (!this.editType) return false;
        this.editIndex = index;
      },
      //
      //选择商品价格
      selPrice:function(e){
        this.data[this.editIndex].price1 = e.price1;
        this.data[this.editIndex].price  = e.price1;
        this.computingMethod();
      },
      computingMethod:function(){
        var data = this.data[this.editIndex];
        if (data.order_amount < data.come_amount){
          this.modalMsg('来货数量不能大于订货数量！系统已经自动为你修改。');
          data.come_amount = data.order_amount;
        }
        var reQty = this.formatFloat(data.rejection_amount,5);
        var qty  = this.formatFloat(data.receipts_amout,5);
        if (data.come_amount < reQty){
          this.modalMsg('拒收数量不能大于来货数量！系统已经自动为你修改。');
          data.rejection_amount = data.come_amount;
          qty = 0;
        }
        var discount      = data.discount>0?this.formatFloat(data.discount / 100,2):1;
        var tax           = data.tax>0?this.formatFloat(data.tax / 100,2)+1:1;
        var standard_price= data.standard_price?data.standard_price:0;
        var retail_price  = data.retail_price?data.retail_price:0;
        data.price1 = data.price1?data.price1:data.price;
        var price = this.formatFloat(data.price1 * discount,6);
        var not_tax_price = this.formatFloat(price / tax,6);
        var not_tax_money = this.formatFloat(qty * not_tax_price,6);
        var total_price   = this.formatFloat(qty * price,6);
        var tax_total     = this.formatFloat(total_price - not_tax_money,6);
        data.receipts_amout = qty;
        data.price = price;
        data.not_tax_price = not_tax_price;
        data.not_tax_money = not_tax_money;
        data.total_price = total_price;
        data.tax_total = tax_total;
        data.pifaml = this.formatFloat((standard_price - not_tax_price) * qty,6);
        data.retail = this.formatFloat((retail_price - not_tax_price) * qty,6);
      },
      //选择商品信息
      selGoods: function (e) {
        var data = JSON.parse(JSON.stringify(this.defaultData));
        for (let i in data) {
          if (typeof (e[i]) != "undefined") data[i] = e[i];
        }
        this.data.push(data);
      },
      //统计货品总数 - 货款 - 税款 - 合计
      census: function () {
        var data = this.data, total_amount = 0, total_money = 0, taxes = 0, total_payprice = 0;
        for (let i = 0; i < data.length; i++) {
          if (typeof (data[i].receipts_amout) !== "undefined") total_amount += parseFloat(data[i].receipts_amout);
          if (typeof (data[i].not_tax_money) !== "undefined") total_money += parseFloat(data[i].not_tax_money);
          if (typeof (data[i].tax_total) !== "undefined") taxes += parseFloat(data[i].tax_total);
          if (typeof (data[i].total_price) !== "undefined") total_payprice += parseFloat(data[i].total_price);
        }
        this.formData.total_amount = this.formatFloat(total_amount, 6);
        this.formData.total_money = this.formatFloat(total_money, 6);
        this.formData.taxes = this.formatFloat(taxes, 6);
        this.formData.total_payprice = this.formatFloat(total_payprice, 6);
      },
      //新增行
      addRow: function () {
        this.$refs.formDataRef.validate((valid) => {
          if (valid) {
            var checker = this.checkOrder(this.data);
            if (checker) this.$refs.selectGoodsRef.open();
          }
        });
      },
      //删除行
      delRow: function () {
        if (this.editIndex == -1) return false;
        this.data.splice(this.editIndex, 1);
      },
      checkOrder: function (obj) {
        var msg = '';
        if (!obj.length) return true;
        for (let i = 0; i < obj.length; i++) {
          if (parseFloat(obj[i].come_amount) <= 0) {
            msg = '请输入【' + obj[i].goods_code + '】来货数量！';
            _this.modalMsg(msg);
            return false;
          }
          if (parseFloat(obj[i].order_amount) <= 0 && !obj[i].order_amount) {
            msg = '【' + obj[i].goods_code + '】订货数量不能为空！';
            _this.modalMsg(msg);
            return false;
          }
          if (parseFloat(obj[i].receipts_amout) <= 0) {
            msg = '【' + obj[i].goods_code + '】实收数量不能为空！';
            _this.modalMsg(msg);
            return false;
          }
          if (parseFloat(obj[i].receipts_amout) > parseFloat(obj[i].order_amount)) {
            msg = '【' + obj[i].goods_code + '】实收数量不能大于订货数量！这是不符合GSP规范的,请修改。';
            _this.modalMsg(msg);
            return false;
          }
          if (parseFloat(obj[i].price1) <= 0) {
            msg = '请输入商品【' + obj[i].goods_code + '】单价！';
            _this.modalMsg(msg);
            return false;
          }
        }
        return true;
      },
      //检测供应商有没有设置结算方式
      changePay: function (data) {
        if (typeof (data) == "undefined") return false;
        var obj = {sup_code: this.formData.supplier_code, type: 'paymode'}
        this.common.http({
          url: 'checkProv',
          data: obj
        }).then(function (res) {
          if (res.status) {
            if (res.paymode != _this.formData.supplier_code) {
              _this.modalMsg('<p>该供应商已指定结算方式！暂不允许修改。</p><p>提示：可通过修改业务参数(锁定采购结算方式)来取消此限制。</p>')
              _this.formData.pay_type = res.paymode;
            }
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this);
        })
      },
      DHeight: function (e) {
        this.height = e;
      },
      //表格行右键
      openMenu: function (row) {
        if (!this.editType) return false;
        var obj = JSON.parse(JSON.stringify(row));
        this.fileData.goods_code = obj.goods_code;
        this.fileData.name = obj.name;
        this.fileData.batch = obj.batch;
      },
      //点击查询药检报告按钮
      handleContextMenuEdit: function () {
        this.$refs.ViewDrug.open(this.fileData.goods_code, this.fileData.batch, this.formData.supplier_code)
      },
      //点击上传药检报告按钮
      handleContextMenuDelete: function () {
        if (!this.fileData.batch) return this.$Modal.confirm({
          title: '提示信息',
          content: '生产批号未填写！如果此商品无生产批号，请点击【确定】继续导入药检报告；否则请点击【取消】，然后填写生产批号再试！',
          onOk: function () {
            _this.fileModal = true;
          }
        });
        _this.fileModal = true;
      },
      //确定上传药检报告
      confirmDrug: function (status) {
        if (!status) return this.fileModal = false;
        if (!this.fileData.goods_code) return this.modalMsg('请选择一项商品！');
        if (!this.fileData.file_path) return this.modalMsg('请上传药检报告后提交！');
        var data = {
          goods_code: this.fileData.goods_code,
          batch: this.fileData.batch,
          file_path: this.fileData.file_path,
          ABType: this.fileData.ABType,
          supplier_code: this.formData.supplier_code
        }
        this.common.http({
          url: 'addGoodsDrugReports',
          data: data
        }).then(function (res) {
          if (res.status) _this.fileModal = false;
          else _this.modalMsg(res.msg);
        }).catch(function (err) {
          _this.common.httpErr(err.data, _this)
        })
      },
      changeABType: function () {
        this.fileData.file_path = '';
      },
      upSuccess: function (e) {
        this.fileData.file_path = e.imgUrl;
      },
      upProgress: function (e) {
      },
    }
  }
</script>

<style lang="less">
  .vertical-center-modal {
    display: flex;
    align-items: center;
    justify-content: center;

    .ivu-modal {
      top: 0;

      .nav-menu {
        .ivu-btn {
          display: block;
          width: 100%;
          margin-bottom: 5px;
        }
      }
    }
  }

  .bor-box {
    position: relative;
    border-width: 1px;
    border-style: dashed;
    padding-right: 10px;

    .bor-title {
      display: inline-block;
      position: absolute;
      padding: 0 5px;
      top: -10px;
      left: 10px;
      z-index: 11;
    }

    .bor-top {
      margin-top: 10px;

      .child-box {
        padding-left: 20px;

        .child-box-pad {
          padding-left: 20px;

          .warehouse {
            display: flex;
            flex-wrap: nowrap;
          }
        }
      }
    }
  }

  .bor-footer {
    padding-top: 8px;
  }

  .form-box {
    width: 1200px;

    .nav-menu {
      .ivu-btn {
        margin-bottom: 5px;
      }
    }
  }

  .font-type {
    padding-left: 10px;
  }

  .form-data {
    padding-top: 8px
  }

  .stats {
    display: inline-block;
    padding: 0 20px;
    width: auto;
    height: 28px;
    line-height: 28px;
    text-align: center;
    border-radius: 2px;
  }

  .drug-img {
    width: auto;
    height: 250px;
    line-height: 250px;
    overflow: hidden;
    text-align: center;

    img {
      max-width: 100%;
      max-height: 100%;
    }
  }
</style>
