<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                <Button @click="comData" :loading="subLoading" :disabled="!(isEdit && !formData.is_transfer)"><span class="icon iconfont">&#xe792;</span>保存</Button>
                <Button @click="isEdit = true" :disabled="!formData.is_transfer?isEdit:true"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button @click="init" :disabled="!(isEdit && !formData.is_transfer)"><span class="icon iconfont">&#xe6a2;</span>取消</Button>
                <Divider type="vertical"/>
                <Button :disabled="!(formData.orderid && !formData.is_transfer && !isEdit)" @click="auditOrder"><span class="icon iconfont">&#xe692;</span>审核</Button>
                <Button :disabled="!(!isEdit && formData.is_transfer)" @click="reductionOrder"><span class="icon iconfont">&#xe693;</span>还原</Button>
                <Button :disabled="!(!isEdit && formData.is_transfer)" @click="transferOrder"><span class="icon iconfont">&#xe695;</span>转单</Button>
                <Divider type="vertical"/>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>关闭</Button>
              </div>
          </div>
          <div slot="table-list">
            <div class="height_5"></div>
            <Form ref="formRef" :model="formData" :rules="ruleVal" :label-width="80" label-position="right" :disabled="!isEdit">
              <div class="form-list">
                <Row>
                  <Col span="6">
                    <FormItem label="单据编号">
                      <Input v-model="formData.orderid" placeholder="保存系统自动生成" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="8">
                    <Row>
                      <Col span="11">
                        <FormItem label="客户编号" prop="cust_no">
                          <Input v-model="formData.cust_no" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="13">
                        <FormItem :label-width="5">
                          <Input icon="ios-more" v-model="formData.cust_name" readonly style="cursor:pointer;" @on-click="clickSelCustmoer"></Input>
                        </FormItem>
                      </Col>
                    </Row>
                  </Col>
                  <Col span="6">
                    <Row>
                      <Col span="13">
                        <FormItem label="业务员" :label-width="70" prop="emp_no">
                          <Input v-model="formData.emp_no" disabled></Input>
                        </FormItem>
                      </Col>
                      <Col span="11">
                        <FormItem :label-width="5">
                           <Input icon="ios-more" :value="formData.emp_name" readonly style="cursor:pointer;"  @on-click="chooseEmp"></Input>
                        </FormItem>
                      </Col>
                    </Row>
                  </Col>
                </Row>
                <Row>
                  <Col span="5">
                    <FormItem label="报价日期">
                      <DatePicker type="date" :editable="false" placeholder="报价日期" v-model="formData.f_date" disabled></DatePicker>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="采购人员">
                      <Input icon="ios-more" v-model="formData.link_man" readonly style="cursor:pointer;" @on-click="clickSelCustmoerSales(1)"></Input>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="联系人" :label-width="60">
                      <Input icon="ios-more" v-model="formData.contacts" readonly style="cursor:pointer;" @on-click="clickSelCustmoerSales(0)"></Input>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="状态" :label-width="110">
                      <div :class="formData.is_transfer?'success-bg-text':'warning-bg-text'" style="text-align: center;">{{formData.is_transfer?'已审核':'未审核'}}</div>
                    </FormItem>
                  </Col>
                </Row>
                <Row>
                  <Col span="5">
                    <FormItem label="有效日期">
                      <DatePicker type="date" :editable="false" placeholder="有效日期" v-model="formData.valid_date" :clearable="false" ></DatePicker>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="结算方式" prop="pay_mode_no">
                      <Select v-model="formData.pay_mode_no" >
                       <Option v-for="(item,key) in $store.state.settlement" :value="key" :key="key">{{item}} ( {{key}} )</Option>
                      </Select>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="复核员" :label-width="60">
                      <Input v-model="formData.audit" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="" :label-width="55">
                      <Button type="primary" @click="chooseGoods"><span class="icon iconfont">&#xe797;</span>增加产品</Button>
                      <Button @click="removeGoods"><span class="icon iconfont">&#xe793;</span>删除产品</Button>
                    </FormItem>
                  </Col>
                </Row>
              </div>
              <Table size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height-220"
                      @on-row-click="(row,index)=>{selectGoodsIndex(index,false)}"
                      @on-row-dblclick="(row,index)=>{selectGoodsIndex(index,true)}">
                <template slot-scope="{row,index}" slot="item_no">{{row.item_no?row.item_no:(index+1)}}</template>
                <template slot-scope="{row}" slot="unit">{{row.unit}}</template>
              </Table>
              <div class="height_5"></div>
              <div class="form-list">
                <Row>
                  <Col span="5">
                    <FormItem label="货品总数">
                      <Input v-model="formData.goods_qty" placeholder="货品总数" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="货款" :label-width="50">
                      <Input v-model="formData.goods_sum" placeholder="货款" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="税款" :label-width="50">
                      <Input v-model="formData.tax_sum" placeholder="税款" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="合计" :label-width="50">
                      <Input v-model="formData.amount" placeholder="合计" disabled></Input>
                    </FormItem>
                  </Col>
                </Row>
                <Row>
                  <Col span="11">
                    <FormItem label="备注">
                      <Input v-model="formData.remark" placeholder="备注"></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="创建者" :label-width="70">
                      <FormItem :label-width="5">
                        <Input :value="$store.state.emp[formData.creater]" disabled></Input>
                      </FormItem>
                    </FormItem>
                  </Col>
                  <Col span="5">
                    <FormItem label="创建日期" :label-width="80">
                      <FormItem :label-width="5">
                        <Input v-model="formData.create_date" disabled></Input>
                      </FormItem>
                    </FormItem>
                  </Col>
                </Row>
              </div>
            </Form>
          </div>
      </split-none>
      <select-customer ref="chooseCustomerRef" @selcust="confirmCustomer"></select-customer>
      <select-customer-sales ref="chooseCustomerSalesRef" @selCustSales="selCustSales"></select-customer-sales>
      <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
      <select-goods ref="selectGoodsRef" :isSignle="false" @selectRow="selectGoods"></select-goods>
      <edit-goods-details ref="editGoodsDetailsRef" @comGoodsDet="comGoodsDet"></edit-goods-details>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import selectCustomer from '@/components/common/SelectCustomer'
  import SelectCustomerSales from '@/components/common/SelectCustomerSales'
  import selectEmployee from '@/components/common/SelectEmployee'
  import selectGoods from '@/components/common/ChooseGoods'
  import editGoodsDetails from '@/components/sales_mana/speer/editGoodsDetails'
  var formD = {orderid:'',f_date:null,valid_date:'',emp_no:'',emp_name:'',audit:null,cust_no:'',cust_name:'',link_man:'',goods_sum:"",tax_sum:0,amount:0,goods_qty:0,pay_mode_no:'',is_transfer:0,is_finish:0,remark:'',print_count:0,creater:'',create_date:'',mender:'',update_date:'',contacts:'',dept_id:0};
  export default {
    name:'sel_speer_edit',
      components:{splitNone,selectCustomer,selectEmployee,SelectCustomerSales,selectGoods,editGoodsDetails},
      data () {
          return {
              save_lock:false,
              height:0,
              Breadcrumb:[{title:'销售管理'},{title:'销售报价单',url:'sel_speer'},{title:'编辑报价单'}],
              columns:[
                  {title:'项次',slot:'item_no',width:100,align:'center'},
                  {title:'商品编号',key:'goods_code',width:100,align:'center',resizable:true,ellipsis :true},
                  {title:'商品名称',key:'goods_name',width:150,align:'center',resizable:true,ellipsis :true},
                  {title:'规格',key:'specs',width:100,align:'center'},
                  {title:'单位',key:'unit',width:90,align:'center'},
                  {title:'数量',key:'qty',width:100,align:'center'},
                  {title:'单价',key:'o_price',width:100,align:'center'},
                  {title:'折扣%',key:'rebate',width:100,align:'center'},
                  {title:'实际单价',key:'price',width:100,align:'center'},
                  {title:'税率',key:'tax_rate',width:100,align:'center'},
                  {title:'无税单价',key:'un_tax_price',width:100,align:'center'},
                  {title:'无税金额',key:'goods_sum',width:100,align:'center'},
                  {title:'税款',key:'tax_sum',width:100,align:'center'},
                  {title:'合计',key:'amount',width:100,align:'center'},
                  {title:'客方产品编号',key:'cust_goods_code',width:100,align:'center'},
                  {title:'备注',key:'remark',width:120,resizable:true,ellipsis :true},
                  {title:'产地',key:'origin',width:150,resizable:true,ellipsis :true},
                  {title:'生产企业',key:'production',width:200,resizable:true,ellipsis :true},
                  {title:'剂型',key:'dosage',width:100},
                  {title:'批准文号/注册证号',key:'approval_code',width:150},
                  {title:'包装规格',key:'packspecs',width:100}
              ],
              data:[],
              isEdit:false,
              checkIndex:-1,
              salesType:0,
              subLoading:false,
              cust_data:null,
              formData:JSON.parse(JSON.stringify(formD)),
              ruleVal:{
                cust_no:[
                  {required:true,message:'请选择客户',trigger:'change'}
                ],
                emp_no:[
                  {required:true,message:'请选择业务员',trigger:'change'}
                ],
                pay_mode_no:[
                  {required:true,message:'请选择结算方式',trigger:'change'}
                ]
              },
              quotation_orderid:localStorage.getItem('speer_orderid')
          }
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          vm.quotation_orderid = localStorage.getItem('speer_orderid');
        });
      },
      watch:{
        quotation_orderid(e){
          if(this.isEdit){
            this.$Modal.confirm({
              title:'提示',
              content:'页面正处于编辑状态，确定要放弃修改吗？',
              okText:'继续',
              onOk:()=>{
                this.init();
              }
            });
          }else this.init();
        }
      },
      created:function(){
        this.init();
      },
      methods:{
        init:function(){
          let _this = this;
          this.loadding = true;
          this.common.http({url:'s/editSpeerInit',data:{quotation_orderid:this.quotation_orderid}}).then(function(res){
            if(res.status==1){
              if(res.data.data){
                _this.data = res.data.details;
                _this.formData = res.data.data;
                _this.cust_data = res.data.cust_data;
                _this.isEdit = false;
              }else{
                _this.formData = JSON.parse(JSON.stringify(formD));
                _this.data = [];
                _this.isEdit = true;
              }
            }
            _this.$nextTick(()=>{
              if(!res.data) _this.$refs.chooseEmployeeRef.init();
            })
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          });
        },
        comData:function(){
          let _this = this;
          this.subLoading = true;
          this.$refs.formRef.validate(function(valid){
            if (valid) {
              if(_this.data.length < 1){
                _this.subLoading = false;
                return _this.modalMsg('请选择产品');
              }
              _this.common.http({
                url: 's/comSelSpeer',data:{fdata:_this.formData,data:_this.data}
              }).then(function (res) {
                _this.alertMsg(res.msg,res.status != 1?'error':'');
                if(res.status == 1){
                  _this.data = res.details;
                  _this.formData = res.data;
                  _this.isEdit = false;
                }
                _this.subLoading = false;
              }).catch(function(err){
                _this.subLoading = false;
                _this.common.httpErr(err.data,_this);
              })
            }else{
              _this.subLoading = false;
            }
          })
        },
        //审核
        auditOrder:function(){
          if(this.formData.is_transfer == 1) return false;
          let _this = this;
          this.common.http({
            url: 's/auditSelSpeer',data:{orderid:_this.formData.orderid}
          }).then(function (res) {
            _this.modalMsg(res.msg,'',(res.status != 1?'error':'success'));
            if(res.status == 1){
              _this.formData.audit = res.audit;
              _this.formData.is_transfer = 1;
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        },
        //还原
        reductionOrder:function(){
          if(!this.formData.is_transfer) return false;
          let _this = this;
          this.common.http({
            url: 's/reductionSelSpeer',data:{orderid:_this.formData.orderid}
          }).then(function (res) {
            _this.modalMsg(res.msg,'',(res.status != 1?'error':'success'));
            if(res.status == 1){
              _this.formData.audit = null;
              _this.formData.is_transfer = 0;
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        },
        //转单
        transferOrder:function(){
          if(!this.formData.is_transfer) return false;
          let _this = this;
          this.common.http({
            url: 's/transferSelSpeer',data:{orderid:_this.formData.orderid}
          }).then(function (res) {
            if(res.status == 1){
              _this.$Modal.confirm({
                title:'提示',
                content:res.msg,
                okText:'是',
                cancelText:'否',
                onOk:()=>{
                  localStorage.setItem('sel_order_orderid',res.orderid)
                  _this.toUrl('/sel_order_edit');
                }
              });
            }else{
              _this.modalMsg(res.msg,'','error');
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        },
        clickSelCustmoer:function(){
          if(this.isEdit) this.$refs.chooseCustomerRef.init()
        },
        confirmCustomer:function(e){
          this.cust_data = e;
          this.formData.pay_mode_no = e.settlemode;
          this.formData.cust_no = e.id;
          this.formData.cust_name = e.name;
          this.salesType = 1;
          this.$refs.chooseCustomerSalesRef.open(e.id,1)
        },
        clickSelCustmoerSales:function(type){
          if(!this.isEdit) return false;
          this.salesType = type;
          if(this.formData.cust_no.length < 1){
            return this.modalMsg('请先选择客户编号');
          }else this.$refs.chooseCustomerSalesRef.open(this.formData.cust_no,type,true)
        },
        selCustSales:function(e){
          if(!e.data){
            this.formData.link_man = null;
            this.formData.contacts = null;
          }else{
            if(this.salesType==1){
              this.formData.link_man = e.data.user_name;
              if(e.is_check) this.formData.contacts = '';
            }else{
              this.formData.contacts = e.data.user_name;
            }
          }
        },
        chooseEmp:function(){
          if(this.isEdit) this.$refs.chooseEmployeeRef.init();
        },
        confirmEmployee:function(e){
          this.formData.emp_no = e.code;
          this.formData.emp_name = e.name;
          if(!this.formData.f_date) this.formData.f_date = this.getDateVal();
          if(!this.formData.valid_date) this.formData.valid_date = this.getDateVal();
        },
        chooseGoods:function(){
          if(!this.formData.cust_no) return this.modalMsg('请先选择客户编号');
          if(!this.formData.emp_no) return this.modalMsg("请先选择业务员");
          if(this.isEdit) this.$refs.selectGoodsRef.open();
        },
        selectGoods:function(e){
          let data = {};
          data.item_no = null;
          data.orderid = null;
          data.goods_code = e.goods_code;
          data.goods_name = e.goods_name;
          data.specs = e.specs;
          data.unit = e.unit;
          data.qty = null;
          let o_price = e.commodity_price[this.cust_data.priceshe].price1
          if(!o_price) o_price = e.commodity_price[2].price1
          if(o_price) o_price = this.formatFloat(o_price*this.cust_data.pricecoeff,6);
          data.o_price = o_price;
          data.rebate = null;
          data.price = data.o_price;
          data.tax_rate = e.tax?parseFloat(e.tax):null;
          let tax = data.tax_rate || 0;
          tax = parseFloat(tax + 100);
          if(o_price > 0 && e.tax) data.un_tax_price = this.formatFloat(o_price/tax*100,6);
          else data.un_tax_price = null;
          data.goods_sum = 0;
          data.tax_sum = 0;
          data.amount = 0;
          data.cust_goods_code = null;
          data.remark = null;
          data.origin = e.origin;
          data.production = e.production;
          data.dosage = e.dosage;
          data.approval_code = e.approval_code;
          data.packspecs = e.packspecs;
          this.data.push(data);
          this.$nextTick(()=>{
            this.selectGoodsIndex(this.data.length - 1,true)
          })
        },
        selectGoodsIndex:function(index,type){
          this.checkIndex = index;
          if(type && this.isEdit){
            this.$refs.editGoodsDetailsRef.open(this.data[index],this.cust_data)
          }
        },
        comGoodsDet:function(e){
          this.$set(this.data,this.checkIndex,e);
          this.opPriceNum();
        },
        opPriceNum:function(){
          let goods_qty = 0;
          let goods_sum = 0;
          let tax_sum = 0;
          let amount = 0;
          for(let i=0;i<this.data.length;i++){
            if(!this.data[i].goods_sum) continue;
            goods_qty = this.formatFloat(goods_qty + this.data[i].qty,0);
            goods_sum = this.formatFloat(goods_sum + this.data[i].goods_sum,6);
            tax_sum = this.formatFloat(tax_sum + this.data[i].tax_sum,6);
            amount = this.formatFloat(amount + this.data[i].amount,6);
          }
          this.formData.goods_qty = goods_qty;
          this.formData.goods_sum = goods_sum;
          this.formData.tax_sum = tax_sum;
          this.formData.amount = amount;
        },
        removeGoods:function(){
          this.$Modal.confirm({
            title:'操作提示',
            content:'确定要移除该商品吗？',
            onOk:()=>{
              this.data.splice(this.checkIndex,1);
            }
          });
        },
        rowClassName(row,index){
          if (index === this.checkIndex) {
              return 'ivu-table-row-highlight';
          }
          return '';
        },
        DHeight(e){
          this.height = e;
        }
      }
  }
</script>
<style lang="less">
  .form-list{
    width: 1000px;padding:10px 0;
  }
</style>
