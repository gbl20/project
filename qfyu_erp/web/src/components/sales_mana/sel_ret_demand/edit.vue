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
          <Button @click="toUrl('/SelRetDemandList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button @click="print"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form :model="formData" :label-width="80" class="w1200 padding-top" :disabled="!editType?true:false">
          <Row>
            <Col span="5">
              <FormItem label="单据编号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="申请日期">
                <DatePicker type="date" format="yyyy年MM月dd日" v-model="formData.f_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="合同编号">
                <Input v-model="formData.contract_no"></Input>
              </FormItem>
            </Col>
            <Col span="8">
              <FormItem label="退货客户">
                <Row>
                  <Col span="5"><Input disabled v-model="formData.cust_no"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18"><Input disabled v-model="formData.cust_name"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomer"></Button></Input></Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="采购人员">
                    <Input disabled v-model="formData.linkman"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomerSales(1)"></Button></Input>
                  </FormItem>
                  <FormItem label="购方部门">
                    <Input v-model="formData.cust_depart" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="联系人">
                    <Input disabled v-model="formData.linkman2"><Button class="clear-btn" slot="append" icon="ios-more" @click="openCustomerSales(0)"></Button></Input>
                  </FormItem>
                  <FormItem label="代销收货">
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.fungible"></Checkbox>
                  </FormItem>
                </Col>
              </Row>
            </Col>
            <Col span="5">
              <FormItem label="业务员">
                <Row>
                  <Col span="6"><Input disabled v-model="formData.emp_no"></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="17"><Input disabled v-model="$store.state.emp[formData.emp_no]"><Button class="clear-btn" slot="append" icon="ios-more" @click="opemEmployee"></Button></Input></Col>
                </Row>
              </FormItem>
              <FormItem label="复核员">
                <Input v-model="formData.audit" disabled></Input>
              </FormItem>
              <FormItem>
                <Button type="primary" @click="addRow"><span class="icon iconfont">&#xe797;</span>增行</Button>
                <Button type="error" @click="delRow"><span class="icon iconfont">&#xe6a5;</span>删行</Button>
              </FormItem>
            </Col>
            <Col span="6">
              <FormItem label="单据状态">
                <span :class="'check-status '+(formData.status?'success-bg-text':'warning-bg-text')">{{formData.status?'已审核':'未审核'}}</span>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table size="small" :row-class-name="rowClassName" border :columns="columns" :data="data" :height="height-74" @on-row-click="changeRow">
          <template slot-scope="{row,index}" slot="item_no">
            <span>{{(row.item_no && editType)?row.item_no:(index+1)}}</span>
          </template>
          <template slot-scope="{row,index}" slot="pro_date">
            <DatePicker v-if="editType && index==editIndex" type="date" v-model="data[index].pro_date"></DatePicker>
            <span v-else>{{getDateVal(row.pro_date,false)}}</span>
          </template>
          <template slot-scope="{row,index}" slot="valid_date">
            <DatePicker v-if="editType && index==editIndex" type="date" v-model="data[index].valid_date"></DatePicker>
            <span v-else>{{getDateVal(row.valid_date,false)}}</span>
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
    <select-customer ref="SelectCustomer" @selcust="selCustomer"></select-customer>
    <select-customer-sales ref="selCustomerSales" @selCustSales="selCustSales"></select-customer-sales>
    <select-employee ref="SelectEmployee" @selemp="selEmployee"></select-employee>
    <select-sel-order ref="SelectSelOrderRef" @confirm="selOrderDtl"></select-sel-order>
    <choose-goods ref="ChooseGoodsRef" @selectRow="selGoods"></choose-goods>
    <choose-providers ref="ChooseProvidersRef" @confirm="selPro"></choose-providers>
  </div>
</template>

<script>
  var _this,
    formData = {
      orderid: '', f_date: '', contract_no: '', cust_no: '', cust_name: '', linkman: '', cust_depart: '', linkman2: '', fungible: 0, emp_no: '', audit: '',goods_qty:'', goods_sum:'', tax_sum:'', amount:'', remark:'', creater:'', creater_date:'', print_count:''
    };
  import splitNone from "@/components/public/splitNone"
  import SelectCustomer from "@/components/common/SelectCustomer"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectEmployee from "@/components/common/SelectEmployee"
  import SelectSelOrder from "@/components/sales_mana/sel_ret_demand/SelectSelOrder"
  import ChooseGoods from "@/components/common/ChooseGoods"
  import ChooseProviders from "@/components/common/ChooseProviders"
	export default {
		name: "SelRetDemandEdit",
    components:{
      splitNone,SelectCustomer,SelectCustomerSales,SelectEmployee,SelectSelOrder,ChooseGoods,ChooseProviders
    },
    data: function () {
      return {
        orderid: null,
        height: 0,
        Breadcrumb: [{title: '销售管理'}, {title: '销售退回管理'}, {title: '销售退回申请明细'}],
        editIndex: -1,
        editType: 0,
        editTypeTitle: '',
        formData: formData,
        columns: [
          {title: '项次', slot: 'item_no', width: 50, minWidth: 50, ellipsis: true, resizable: true},
          {title: '商品编号', key: 'goods_code', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '通用名称', key: 'name', width: 160, minWidth: 160, ellipsis: true, resizable: true},
          {title: '规格', key: 'specs', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '剂型', key: 'dosage', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '单位', key: 'unit', width: 50, minWidth: 50, ellipsis: true, resizable: true},
          {title: '包装规格', key: 'packspecs', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {
            title: '生产批号',
            key: 'batch_no',
            width: 120,
            minWidth: 120,
            ellipsis: true,
            resizable: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'batch_no', 1)
            }
          },
          {
            title: '数量',
            key: 'qty',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            align: 'right',
            render:(h,params)=>{
              return this.custRender.renderInput(this, h, params, 'qty', 1)}
            },
          {
            title: '单价',
            key: 'o_price',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'o_price', 1)
            }
          },
          {
            title: '折扣',
            key: 'rebate',
            width: 80,
            minWidth: 80,
            ellipsis: true,
            resizable: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'rebate', 1)
            }
          },
          {
            title: '赠品数量',
            key: 'gift_qty',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'gift_qty', 1)
            }
          },
          {
            title: '实际单价',
            key: 'price',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'price', 1)
            }
          },
          {title: '金额', key: 'amount', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {
            title: '税率%',
            key: 'tax',
            width: 80,
            minWidth: 80,
            ellipsis: true,
            resizable: true,
            align: 'right',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'tax', 1)
            }
          },
          {title: '税款', key: 'tax_sum', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '无税单价', key: 'not_tax_price', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '无税金额', key: 'goods_sum', width: 100, minWidth: 100, ellipsis: true, resizable: true, align: 'right'},
          {title: '生产日期', slot: 'pro_date', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '有效期至', slot: 'valid_date', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '产地', key: 'origin', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '生产企业', key: 'production', width: 150, minWidth: 150, ellipsis: true, resizable: true},
          {title: '批准文号/注册证号', key: 'approval_code', width: 140, minWidth: 140, ellipsis: true, resizable: true},
          {
            title: '供应商编号',
            key: 'prov_no',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'prov_no', 1,true)
            }
          },
          {title: '供应商名称', key: 'prov_name', width: 130, minWidth: 130, ellipsis: true, resizable: true},
          {title: '供应商许可证号', key: 'drug_license', width: 130, minWidth: 130, ellipsis: true, resizable: true},
          {
            title: '原发货单号',
            key: 'p_orderid',
            width: 160,
            minWidth: 160,
            ellipsis: true,
            resizable: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'p_orderid', 1)
            }
          },
          {
            title: '发货项次',
            key: 'p_item_no',
            width: 80,
            minWidth: 80,
            ellipsis: true,
            resizable: true,
            align: 'center',
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'p_item_no', 1)
            }
          },
          {title: '发货日期', key: 'p_date', width: 120, minWidth: 120, ellipsis: true, resizable: true},
          {
            title: '备注',
            key: 'remark',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'remark')
            }
          },
          {
            title: '退货原因',
            key: 'out_remark',
            width: 100,
            minWidth: 100,
            ellipsis: true,
            resizable: true,
            render: (h, params) => {
              return this.custRender.renderInput(this, h, params, 'out_remark')
            }
          },
          {title: '原发货数量', key: 'p_qty', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '原赠品数量', key: 'p_gift_qty', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: 'GSP验收类型', key: 'gsp_type', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '验收类型名称', slot: 'gsp_name', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '储存条件', key: 'storage_type', width: 80, minWidth: 80, ellipsis: true, resizable: true},
          {title: '质量状态', slot: 'quality_state', width: 100, minWidth: 100, ellipsis: true, resizable: true},
          {title: '货品状态', slot: 'goods_state', width: 100, minWidth: 100, ellipsis: true, resizable: true},
        ],
        data: [],
        reData:[],
        CustSales: 1,
        status: 0
      }
    },
    activated() {
      this.orderid = localStorage.getItem("sel_demand_orderid");
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
          if(key == 'prov_no') this.$refs.ChooseProvidersRef.open();
        }else if(fun=='blur'){
          if(key=='qty' || key=='gift_qty' || key=='rebate' || key=='tax' || key=='o_price' || key=='price'){
            this.changeAmount();
          }
        }else{
          this.$set(this.data[index],key,this.custRender.KValue);
        }
      },
      changeAmount(){
        if (!this.editType) return false;
        var tax = this.data[this.editIndex].tax?this.data[this.editIndex].tax:0;
        var rebate = this.data[this.editIndex].rebate?this.data[this.editIndex].rebate:0;
        var qty = this.data[this.editIndex].qty?this.data[this.editIndex].qty:0;
        var gift_qty = this.data[this.editIndex].gift_qty?this.data[this.editIndex].gift_qty:0;
        var o_price = this.data[this.editIndex].o_price?this.data[this.editIndex].o_price:0;
        var price = 0;
        var amount = 0;
        var tax_sum = 0;
        var not_tax_price = 0;
        var goods_sum = 0;
        tax = tax>0?(tax / 100)+1:1;
        rebate = rebate>0?rebate / 100:1;
        qty    = qty<0?Math.abs(qty):qty;
        if (this.status==1){
          qty = qty > parseFloat(this.data[this.editIndex].p_qty)?parseFloat(this.data[this.editIndex].p_qty):qty;
          gift_qty = gift_qty > parseFloat(this.data[this.editIndex].p_gift_qty)?parseFloat(this.data[this.editIndex].p_gift_qty):gift_qty;
        }
        price  = o_price>0?this.formatFloat(o_price*rebate,6):o_price;
        amount = this.formatFloat(qty*price,6);
        not_tax_price = this.formatFloat(price / tax,6);
        goods_sum = this.formatFloat(amount / tax,6);
        tax_sum = this.formatFloat(amount - goods_sum,6);
        this.$set(this.data[this.editIndex],'qty',qty);
        this.$set(this.data[this.editIndex],'gift_qty',gift_qty);
        this.$set(this.data[this.editIndex],'price',price);
        this.$set(this.data[this.editIndex],'amount',amount);
        this.$set(this.data[this.editIndex],'not_tax_price',not_tax_price);
        this.$set(this.data[this.editIndex],'goods_sum',goods_sum);
        this.$set(this.data[this.editIndex],'tax_sum',tax_sum);
      },
      rowClassName(row,index){
        if (index === this.editIndex) {
          this.$set(this.data[index],'isEdit',this.editType?true:false);
          return 'ivu-table-row-highlight';
        }else this.$set(this.data[index],'isEdit',false);
        return '';
      },
      selOrderDtl(data){
        if (!data.length) return false;
        for(let i=0;i<data.length;i++){
          let reData = {};
          reData['p_id']    = data[i]['id'];
          reData['item_no'] = null;
          reData['goods_code'] = data[i]['goods_code'];
          reData['name']   = data[i]['name'];
          reData['specs']  = data[i]['specs'];
          reData['dosage'] = data[i]['dosage'];
          reData['unit']   = data[i]['unit'];
          reData['packspecs'] = data[i]['packspecs'];
          reData['batch_no']  = data[i]['batch_no'];
          reData['qty']       = this.formatFloat(data[i]['qty'] / -1,5);
          reData['o_price']   = data[i]['o_price'];
          reData['rebate']    = data[i]['rebate'];
          reData['gift_qty']  = 0;
          reData['price']     = data[i]['price'];
          reData['amount']    = this.formatFloat(data[i]['amount'] / -1,6);
          reData['tax']       = data[i]['tax_rate'];
          reData['tax_sum']   = this.formatFloat(data[i]['tax_sum'] / -1,6);
          reData['not_tax_price'] = data[i]['un_tax_price'];
          reData['goods_sum'] = this.formatFloat(data[i]['goods_sum'] / -1,6);
          reData['pro_date']  = data[i]['prod_date'];
          reData['valid_date']= data[i]['valid_date'];
          reData['origin']    = data[i]['origin'];
          reData['production']= data[i]['production'];
          reData['approval_code'] = data[i]['approval_code'];
          reData['prov_no']   = data[i]['prov_no'];
          reData['prov_name'] = data[i]['prov_name'];
          reData['drug_license'] = data[i]['drug_license'];
          reData['p_orderid'] = data[i]['orderid'];
          reData['p_item_no'] = data[i]['item_no'];
          reData['p_date']    = data[i]['f_date'];
          reData['remark']    = '';
          reData['out_remark']= '';
          reData['p_qty']     = data[i]['qty'];
          reData['p_gift_qty']= data[i]['gift_qty']?data[i]['gift_qty']:0;
          reData['gsp_type']  = data[i]['gsp_type'];
          reData['storage_type']  = data[i]['storage_type'];
          reData['quality_state'] = '';
          reData['goods_state']   = '';
          if(this.reData.indexOf(data[i]['id']) == -1){
            this.reData.push(data[i]['id']);
            this.data.push(reData);
          }
        }
      },
      selGoods(object){
        var data = {}
        data['goods_code'] = object['goods_code'];
        data['name']    = object['name'];
        data['specs']   = object['specs'];
        data['dosage']  = object['dosage'];
        data['unit']    = object['unit'];
        data['packspecs'] = object['packspecs'];
        data['batch_no']  = '';
        data['qty']       = null;
        data['o_price']   = object.commodity_price[2].price1;
        data['rebate']    = null;
        data['gift_qty']  = null;
        data['price']     = object.commodity_price[2].price1;
        data['amount']    = 0;
        data['tax']  = null;
        data['tax_sum']   = 0;
        data['not_tax_price'] = null;
        data['goods_sum'] = 0;
        data['pro_date']  = '';
        data['valid_date']= '';
        data['origin']    = object['origin'];
        data['production']= object['production'];
        data['approval_code'] = object['approval_code'];
        data['prov_no']   = '';
        data['prov_name'] = '';
        data['drug_license'] = '';
        data['p_orderid'] = '';
        data['p_item_no'] = '';
        data['p_date']    = '';
        data['remark']    = '';
        data['out_remark']= '';
        data['p_qty']     = null;
        data['gift_qty']  = null;
        data['p_gift_qty']= null;
        data['gsp_type']  = object['gsp_type'];
        data['storage_type']  = object['storage_type'];
        data['quality_state'] = '';
        data['goods_state']   = '';
        this.data.push(data)
      },
      selPro(data){
        this.$set(this.data[this.editIndex],'prov_no',data.supplier_code)
        this.$set(this.data[this.editIndex],'prov_name',data.full_name)
      },
      init(){
        this.common.http({
          url:'s/getSelRetDemandDtl',
          data:{orderid:this.orderid}
        }).then(function (res) {
          if (res.status){
            _this.formData = res.selData?res.selData:JSON.parse(JSON.stringify(formData));
            _this.data     = res.selDtlData;
            _this.reData   = res.reData;
            _this.status   = res.selData.o_type;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      edit(type){
        if(this.editType){
          return this.modalMsg('当前正在处于编辑状态，请先保存或取消单据修改！')
        }
        if (!type && !this.formData.orderid) return false;
        this.status = type?0:this.status;
        this.editType = 1;
        this.editTypeTitle = type?'新增':'修改';
        if(type) {
          this.$refs.SelectCustomer.init();
          this.formData = JSON.parse(JSON.stringify(formData));
          this.data = [];
        }
      },
      //删除单据
      del(){
        if (!this.formData.orderid) return false;
        this.$Modal.confirm({
          title: '提示信息',
          content: '确定要删除当前单据吗？',
          onOk() {
            _this.common.http({
              url:'s/delSelRetDemand',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status){
                if (res.orderid){
                  _this.orderid = res.orderid;
                }else{
                  _this.editIndex = -1;
                  _this.editType = 0;
                  _this.editTypeTitle = '';
                  _this.status = 0;
                  _this.formData = JSON.parse(JSON.stringify(formData));
                  _this.data = [];
                }
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
      //保存单据
      preserve(){
        var validate = this.checkGoodsData();
        if (!validate.status){
          this.editIndex = validate.index;
          this.custRender.inputFocus(this,validate.key,validate.index)
          return this.modalMsg(validate.msg);
        }
        this.common.http({
          url:'s/saveSelRetDemand',
          data:{formData:this.formData,data:this.data,status:this.status}
        }).then(function (res) {
          if (!res.status){
            _this.modalMsg(res.msg);
          }else{
            localStorage.setItem("sel_demand_orderid",res.orderid)
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
      //取消保存
      cancel(){
        if (!this.editType) return false;
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要取消对当前单据所作的修改吗？',
          onOk(){
            _this.editType = 0;
            _this.status = 0;
            _this.editTypeTitle = '';
            _this.init();
          }
        })
      },
      //审核单据
      check(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要审核当前单据吗？',
          onOk(){
            _this.common.http({
              url:'s/checkSelRetDemand',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status){
                setTimeout(function () {
                  _this.$Modal.confirm({
                    title:'提示信息',
                    content:'<p>'+_this.orderid+'号销退申请单已成功转出到</p><p>【'+res.orderid+'】号销退登记单，要查看该单据吗？</p>',
                    onOk(){
                      _this.init();
                      localStorage.setItem("sel_check_orderid",res.orderid);
                      _this.toUrl('/SelRetCheckEdit');
                    }
                  })
                },300)
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
      //还原单据
      reduction(){
        this.$Modal.confirm({
          title: '提示信息',
          content: '确定要还原当前已经审核过的单据吗？',
          onOk() {
            _this.common.http({
              url:'s/backSelRetDemand',
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
      //保存/修改操作前 检查商品数据
      checkGoodsData(){
        if (!this.data.length) return false;
        var rule = {status:0,msg:'',key:'',index:''}
        for (let i=0;i<this.data.length;i++){
          if (this.data[i].qty==''){
            rule.msg = '商品数量不能为空';
            rule.key = 'qty';
            rule.index = i;
            return rule;
          }
          if (this.data[i].price==''){
            rule.msg = '商品单价不能为空';
            rule.key = 'price';
            rule.index = i;
            return rule;
          }
        }
        rule.status = 1;
        return rule;
      },
      print(){},
      out(){
        this.delView('SelRetDemandEdit');
      },
      addRow(){
        if (!this.editType) return false;
        if (!this.formData.cust_no) return false;
        if (this.status==1){
          this.$refs.SelectSelOrderRef.open(this.formData.cust_no);
        }else if(this.status==2){
          this.$refs.ChooseGoodsRef.open();
        }
      },
      delRow(){
        if (!this.editType) return false;
        if (this.editIndex==-1) return false;
        this.data.splice(this.editIndex,1);
        this.reData.splice(this.editIndex,1);
      },
      openCustomer(){
        this.$refs.SelectCustomer.init();
      },
      openCustomerSales(type){
        this.CustSales = type;
        if (!this.formData.cust_no) return false;
        this.$refs.selCustomerSales.open(this.formData.cust_no,type,true);
      },
      opemEmployee(){
        this.$refs.SelectEmployee.init();
      },
      selCustomer(e){
        if (this.formData.cust_no && this.formData.cust_no!=e.id){
          this.formData.cust_depart = '';
          this.formData.linkman = '';
          this.formData.linkman2 = '';
          this.formData.emp_no = '';
          this.data = []
        }
        this.formData.cust_no = e.id;
        this.formData.cust_name = e.name;
        this.formData.cust_depart = e.depart;
        if(!this.status){
          this.$Modal.confirm({
            title:'选择退货方式',
            content:'系统支持两种退货方式，按【是】以选原单的方式退货，按【否】以自由录入的方式退货！',
            okText:'是',
            cancelText:'否',
            onOk(){
              _this.status = 1;
            },
            onCancel(){
              _this.status = 2;
            }
          })
        }
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
        this.formData.emp_no = e.code;
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
  .check-status{
    display: inline-block;padding: 0 15px;text-align: center;border-radius: 2px;
  }
</style>
