<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button><span class="icon iconfont">&#xe6c0;</span>其他</Button>
          <Button @click="add" :disabled="editType?true:false"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="edit" :disabled="(editType || formData.status)?true:false"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="del" :disabled="(editType || formData.status)?true:false"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="preserve" :disabled="!editType?true:false"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button @click="cancel" :disabled="!editType?true:false"><span class="icon iconfont">&#xe793;</span>取消</Button>
          <Divider type="vertical" />
          <Button @click="back" :disabled="(editType || !formData.status)?true:false"><span class="icon iconfont">&#xe693;</span>还原</Button>
          <Button @click="check" :disabled="(editType || formData.status)?true:false"><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Divider type="vertical" />
          <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button @click="toUrl('/selPayList')"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button @click="print"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
        <Form :model="formData" :label-width="80" class="w1200 padding-top" :disabled="!editType?true:false">
          <Row>
            <Col span="5">
              <FormItem label="收款单号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="收款日期">
                <DatePicker type="date" v-model="formData.f_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="收款类型">
                <Select v-model="formData.pay_kind" disabled>
                  <Option :value="0">实收</Option>
                  <Option :value="1">预收</Option>
                </Select>
              </FormItem>
              <FormItem label="结算方式">
                <Select v-model="formData.pay_mode_no">
                  <Option v-for="(item,key,index) in $store.state.settlement" :value="key" :key="index">{{item}}</Option>
                </Select>
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem label="客户">
                <Row>
                  <Col span="5"><Input v-model="formData.cust_no" disabled></Input></Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18">
                    <Input v-model="formData.cust_name" disabled>
                      <Button class="border-lr" slot="append" icon="ios-more" @click="openCustomer"></Button>
                    </Input>
                  </Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="客户采购员">
                    <Input v-model="formData.link_man" disabled>
                      <Button class="border-lr" slot="append" icon="ios-more" @click="openSale(1)"></Button>
                    </Input>
                  </FormItem>
                  <FormItem label="客户联系人">
                    <Input v-model="formData.link_man2" disabled>
                      <Button class="border-lr" slot="append" icon="ios-more" @click="openSale(0)"></Button>
                    </Input>
                  </FormItem>
                  <FormItem label="购方部门">
                    <Input v-model="formData.cust_dept" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="业务部门">
                    <Input v-model="$store.state.depart[formData.yw_dept_id]" disabled>
                      <Button class="border-lr" slot="append" icon="ios-more" @click="openDept"></Button>
                    </Input>
                  </FormItem>
                  <FormItem label="经手人">
                    <Row>
                      <Col span="7"><Input v-model="formData.emp_no" disabled></Input></Col>
                      <Col span="1">&nbsp;</Col>
                      <Col span="16">
                        <Input v-model="$store.state.emp[formData.emp_no]" disabled>
                          <Button class="border-lr" slot="append" icon="ios-more" @click="openEmp"></Button>
                        </Input>
                      </Col>
                    </Row>
                  </FormItem>
                  <FormItem label="复核员">
                    <Input v-model="formData.checker" disabled></Input>
                  </FormItem>
                </Col>
              </Row>
            </Col>
            <Col span="5">
              <FormItem label="现收金额">
                <Input v-model="formData.cash_amount" @on-change="changeMoney"></Input>
              </FormItem>
              <FormItem label="折让金额">
                <Input v-model="formData.discount" :disabled="formData.pay_kind?true:false"  @on-change="changeMoney"></Input>
              </FormItem>
              <FormItem label="结余款">
                <Row>
                  <Col span="4"><Checkbox :true-value="1" :false-value="0" v-model="formData.pay_status" @on-change="changePatState"></Checkbox></Col>
                  <Col span="20">
                    <Input v-model="formData.prepay" disabled></Input>
                  </Col>
                </Row>
              </FormItem>
              <FormItem>
                <Button type="primary" @click="editRow(true)"><span class="icon iconfont">&#xe797;</span>增行</Button>
                <Button type="error" @click="editRow(false)"><span class="icon iconfont">&#xe6a5;</span>删行</Button>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="状态">
                <span :class="'check-status '+(formData.status==1?'success-bg-text':'warning-bg-text')">{{formData.status?'已审核':'未审核'}}</span>
              </FormItem>
              <FormItem label="可用总金额">
                <Input v-model="total" disabled></Input>
              </FormItem>
              <FormItem label="收款后余额">
                <Input v-model="re_total" disabled></Input>
              </FormItem>
              <FormItem>
                <Button @click="autoSettleMent">自动结清</Button>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table size="small" border :row-class-name="rowClassName" :columns="columns" :data="data" :height="height-38" @on-row-click="changeRow">
          <template slot-scope="{row}" slot="settle">
            <Checkbox :true-value="1" :false-value="0" v-model="row.settle" @on-change="changeSettle" :disabled="editType?false:true"></Checkbox>
          </template>
        </Table>
        <Form :label-width="80" class="padding-top" :disabled="!editType?true:false">
          <Row>
            <Col span="6">
              <FormItem label="备注">
                <Input v-model="formData.remark"></Input>
              </FormItem>
            </Col>
            <Col span="5">
              <FormItem label="支票号">
                <Input v-model="formData.cheque_no"></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="创建人">
                <Input v-model="formData.creater" disabled></Input>
              </FormItem>
            </Col>
            <Col span="5">
              <FormItem label="创建日期">
                <Input v-model="formData.creater_date" disabled></Input>
              </FormItem>
            </Col>
            <Col span="4">
              <FormItem label="打印次数">
                <div>{{formData.print}}</div>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
    </split-none>
    <select-customer ref="SelCustomer" @selcust="selCustomer"></select-customer>
    <select-customer-sales ref="selCustSales" @selCustSales="selCustSales"></select-customer-sales>
    <select-depart ref="SelDepart" @seldep="selDepart"></select-depart>
    <select-employee ref="SelEmp" @selemp="selEmployee"></select-employee>
  </div>
</template>

<script>
  var _this;
  import splitNone from "@/components/public/splitNone"
  import SelectCustomer from "@/components/common/SelectCustomer"
  import SelectCustomerSales from "@/components/common/SelectCustomerSales"
  import SelectDepart from "@/components/common/SelectDepart"
  import SelectEmployee from "@/components/common/SelectEmployee"
	export default {
		name: "SelPayDtl",
    components:{
      splitNone,SelectCustomer,SelectCustomerSales,SelectDepart,SelectEmployee
    },
    data(){
		  return{
        orderid:null,
        height:0,
        Breadcrumb:[{title:'财务管理'},{title:'销售收款',url:'/selPayList'},{title:'销售收款明细'}],
        editType:0,
        editTypeTitle:'',
        formData:{},
        columns:[
          {title:'项次',key:'item_no',width:50,minWidth:50,resizable:true,ellipsis:true,align:'center'},
          {title:'商品编号',key:'goods_code',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'商品名称',key:'name',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'规格',key:'specs',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'剂型',key:'dosage',width:60,minWidth:60,resizable:true,ellipsis:true},
          {title:'账款日期',key:'order_date',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'账款单号',key:'settle_orderid',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'账款项次',key:'settle_item_no',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
          {title:'应收金额',key:'amount',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'已收金额',key:'ppaid',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'未收金额',key:'uppaid',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right'},
          {title:'本次支付',key:'paid',width:120,minWidth:120,resizable:true,ellipsis:true,align:'right',render:(h,params)=>{return this.custRender.renderInput(this, h, params, 'paid', 1)}},
          {title:'结清',slot:'settle',width:50,minWidth:50,resizable:true,ellipsis:true,align:'center'},
          {title:'产地',key:'origin',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'生产企业',key:'production',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'发票号码',key:'invoice_no',width:130,minWidth:130,resizable:true,ellipsis:true},
          {title:'发票日期',key:'invoice_date',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'批准文号',key:'approval_code',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'包装规格',key:'packspecs',width:100,minWidth:100,resizable:true,ellipsis:true}
        ],
        data:[],
        editIndex:-1,
        sale:1,
        total:0,
        re_total:0,
        prepay:0
      }
    },
    activated() {
      this.orderid = localStorage.getItem("sel_pay_orderid");
    },
    mounted() {
		  _this = this;
    },
    watch:{
      orderid:function (e) {
        this.orderid = e;
        this.editType=0;
        this.editTypeTitle='';
        if(this.orderid) this.init();
      }
    },
    methods:{
      init(){
        this.common.http({
          url:'f/getSelPayDtl',
          data:{orderid:this.orderid}
        }).then(function (res) {
          if (res.status){
            _this.formData = res.formData;
            _this.data = res.data;
            _this.prepay = res.custMoney;
          }else{
            _this.$Modal.confirm({
              title:'提示信息',
              content:res.msg,
              onOk(){
                _this.toUrl('/selPayList');
              }
            });
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      //新增
      add(){

      },
      //修改
      edit(){
        this.editType = 1;
        this.editTypeTitle = '修改';
        this.changeMoney();
      },
      //删除
      del(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要删除当前单据吗？',
          onOk(){
            this.common.http({
              url:'f/delSelPay',
              data:{orderid:_this.orderid}
            }).then(function (res) {
              if (res.status){
                if (res.orderid) _this.orderid = res.orderid;
                else _this.toUrl('/selPayList');
              }else{
                setTimeout(function () {
                  _this.modalMsg(res.msg);
                },300)
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      //保存
      preserve(){
        this.changeMoney();
        let paid = this.orderPrice();
        if (!this.formData.pay_mode_no){
          return this.modalMsg('请选择付款方式！');
        }
        if(this.re_total<0){
          return this.modalMsg('可用总金额['+this.total+']不足以支付欲支付金额['+paid+']('+this.re_total+')!');
        }
        if (!this.data.length){
          return this.modalMsg('付款单的明细不能为空！');
        }
        if (this.formData.pay_status){
          if (!this.formData.cash_amount){
            return this.modalMsg("必须在'现收金额'字段中输入一个值！");
          }
        }
        this.common.http({
          url:'f/editSelPayDtl',
          data:{formData:this.formData,data:this.data}
        }).then(function (res) {
          if (res.status){
            _this.editType = 0;
            _this.editTypeTitle = '';
          }else{
            _this.modalMsg(res.msg);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      //取消
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
      //还原
      back(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要还原当前已审核过的数据吗？',
          onOk(){
            this.common.http({
              url:'f/backSelPay',
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
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      //审核
      check(){
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要审核当前单据吗？',
          onOk(){
            this.common.http({
              url:'f/checkSelPay',
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
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      //增行-删行
      editRow(type){
        if(!type){
          if(this.editIndex==-1) return this.alertMsg('请选择一项数据！','error');
          this.data.splice(this.editIndex,1);
        }
      },
      openCustomer(){
        this.$refs.SelCustomer.init();
      },
      selCustomer(e){
        this.formData.cust_no = e.id;
        this.formData.cust_name = e.name;
        this.formData.link_man = null;
        this.formData.link_man2 = null;
      },
      openSale(type){
        this.sale = type;
        this.$refs.selCustSales.open(this.formData.cust_no,type,true)
      },
      selCustSales(e){
        if (!e.data){
          this.formData.link_man = null;
          this.formData.link_man2 = null;
        }else{
          if (this.sale==1){
            this.formData.link_man = e.data.user_name;
            if(e.is_check) this.formData.link_man2 = '';
          }else{
            this.formData.link_man2 = e.data.user_name;
          }
        }
      },
      openDept(){
        this.$refs.SelDepart.init();
      },
      selDepart(e){
        this.formData.yw_dept_id = e.id;
      },
      openEmp(){
        this.$refs.SelEmp.init();
      },
      selEmployee(e){
        this.formData.emp_no = e.code;
      },
      changePatState(type){
        this.changeMoney();
      },
      changeSettle(type){
        this.data[this.editIndex].settle = type;
        this.data[this.editIndex].paid = type?this.data[this.editIndex].amount:0;
      },
      changeMoney(){
        var amount = this.formData.cash_amount?parseFloat(this.formData.cash_amount):0,
          discount = this.formData.discount?parseFloat(this.formData.discount):0,
          total = this.formatFloat(amount + discount,6),
          paid  = this.orderPrice(),
          prepay= this.prepay?parseFloat(this.prepay):0,
          re_total = 0,re_prepay = total;
          total = this.formData.pay_status?prepay+total:total;
          re_total = this.formatFloat(total-paid,6);
          prepay = this.formatFloat(paid-re_prepay,6);
          this.total = total;
          this.re_total = re_total;
          this.formData.prepay = this.formData.pay_status?prepay:null;
      },
      autoSettleMent(){
        let amount = 0;
        amount = this.formatFloat(this.total,6);
        this.data.forEach((val)=>{
          let paid = parseFloat(val.amount);
          if(amount-paid>=0){
            val.paid = paid;
            val.settle = 1;
            amount = this.formatFloat(amount-paid,6);
          }else{
            val.paid = amount;
            val.settle = 0;
            amount = 0;
          }
        });
        this.changeMoney();
      },
      orderPrice(){
        var paid=0;
        this.data.forEach((val)=>{
          let price = parseFloat(val.paid);
          paid = this.formatFloat(paid+price,6);
        });
        return paid;
      },
      inputEach:function(fun,key,index){
        this.editIndex = index;
        if (fun=='blur'){
          if (key=='paid') {
            let paid = this.formatFloat(this.data[this.editIndex].paid,6);
            let amount = this.formatFloat(this.data[this.editIndex].amount,6);
            this.data[this.editIndex].paid = paid>amount?amount:this.custRender.KValue;
            this.data[this.editIndex].settle = this.formatFloat(this.data[this.editIndex].paid,6) == amount?1:0;
          }
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
      changeRow(item,index){
        if (this.formData.pay_kind){
          this.editIndex = -1;
          return this.modalMsg('预收款单不能修改明细！');
        }else{
          this.editIndex = index;
        }
      },
      //打印
      print(){},
      //退出
      out(){this.delView();},
      DHeight:function (e) {
        this.height = e;
      },
    }
  }
</script>

<style lang="less">
  .border-lr{
    border-left: none;border-right: none;
  }
  .check-status{
    display: inline-block;padding: 0 15px;height:28px;line-height: 28px;text-align: center;font-size: 14px;box-sizing: border-box;border-radius: 2px;
  }
  .padding-top{
    padding-top: 5px;
  }
</style>
