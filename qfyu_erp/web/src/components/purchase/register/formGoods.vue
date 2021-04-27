<template>
	<div class="edit-goods">
    <Modal title="编辑商品信息" width="750" v-model="goodsModal">
      <Form ref="FormDataRef" :model="defaultData" :rules="rulesFormData" :label-width="95" label-position="right">
        <Row>
          <Col span="8">
            <FormItem label="商品编号">
              <Input v-model="defaultData.goods_code" disabled></Input>
            </FormItem>
            <FormItem label="单位">
              <Input v-model="defaultData.unit" disabled></Input>
            </FormItem>
            <FormItem label="入库单位">
              <RadioGroup v-model="unitType" @on-change="changeUnit">
                <Radio label="unit3"><span>主</span></Radio>
                <Radio label="unit2"><span>辅</span></Radio>
              </RadioGroup>
            </FormItem>
            <FormItem label="订货数量" prop="order_amount">
              <InputNumber :active-change="false" :max="99999999" :min="0" :step="1" v-model="defaultData.order_amount" placeholder="请填写订货数量"></InputNumber>
            </FormItem>
            <FormItem label="来货数量" prop="come_amount">
              <InputNumber :active-change="false" :max="99999999" :min="0" :step="1" v-model="defaultData.come_amount" placeholder="请填写来货数量"></InputNumber>
            </FormItem>
            <FormItem label="赠品数量">
              <InputNumber :active-change="false" :max="99999999" :min="0" :step="1" v-model="defaultData.gift_amount" placeholder="请填写赠品数量"></InputNumber>
            </FormItem>
            <FormItem label="拒收数量">
              <InputNumber :active-change="false" :max="99999999" :min="0" :step="1" v-model="defaultData.rejection_amount" placeholder="请填写拒收数量"></InputNumber>
            </FormItem>
            <FormItem label="实收数量" prop="receipts_amout">
              <InputNumber :active-change="false" :max="99999999" :min="0" :step="1" v-model="defaultData.receipts_amout" placeholder="请填写实收数量" @on-change="computingMethod"></InputNumber>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="商品名称">
              <Input v-model="defaultData.name" disabled></Input>
            </FormItem>
            <FormItem label="商品规格">
              <Input v-model="defaultData.specs" disabled></Input>
            </FormItem>
            <FormItem label="折扣(%)">
              <Input v-model="defaultData.discount" @on-change="computingMethod"></Input>
            </FormItem>
            <FormItem label="税率(%)">
              <Input v-model="defaultData.tax" @on-change="computingMethod"></Input>
            </FormItem>
            <FormItem label="无税单价">
              <InputNumber readonly :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.not_tax_price"></InputNumber>
            </FormItem>
            <FormItem label="无税金额">
              <InputNumber readonly :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.not_tax_money"></InputNumber>
            </FormItem>
            <FormItem label="税款">
              <InputNumber readonly :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.tax_total"></InputNumber>
            </FormItem>
            <FormItem label="合格数量">
              <Input v-model="defaultData.qualified_amout" disabled></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="最近进价">
              <Input disabled v-model="defaultData.near_price"></Input>
            </FormItem>
            <FormItem label="最低进价">
              <Input disabled v-model="defaultData.low_price"></Input>
            </FormItem>
            <FormItem label="最高进价">
              <Input disabled v-model="defaultData.high_price"></Input>
            </FormItem>
            <FormItem label="合计">
              <InputNumber :active-change="false" :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.total_price"></InputNumber>
            </FormItem>
            <FormItem label="单价">
              <Input icon="ios-more" v-model="defaultData.price1" @on-click="openPrice" @on-change="computingMethod"></Input>
            </FormItem>
            <FormItem label="实际单价" prop="price">
              <InputNumber :active-change="false" :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.price" @on-change="computingMethod"></InputNumber>
            </FormItem>
            <FormItem label="参考零售价">
              <Input disabled v-model="defaultData.retail_price"></Input>
            </FormItem>
            <FormItem label="参考批发价">
              <Input disabled v-model="defaultData.standard_price" maxlength="20"></Input>
            </FormItem>
          </Col>
        </Row>
        <Divider orientation="left">其他信息</Divider>
        <Row>
          <Col span="8">
            <FormItem label="来货序号">
              <Input v-model="defaultData.order_no" maxlength="20" placeholder="请填写来货序号"></Input>
            </FormItem>
            <FormItem label="生产批号">
              <Input v-model="defaultData.batch" maxlength="20" placeholder="请填写生产批号"></Input>
            </FormItem>
            <FormItem label="生产日期">
              <DatePicker type="date" v-model="defaultData.production_date" placeholder="请选择生产日期"></DatePicker>
            </FormItem>
            <FormItem label="有效期至">
              <DatePicker type="date" :options="options" v-model="defaultData.production_end_date" placeholder="请选择有效期"></DatePicker>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="参考批发毛利">
              <Input disabled v-model="defaultData.pifaml"></Input>
            </FormItem>
            <FormItem label="参考零售毛利">
              <Input disabled v-model="defaultData.retail"></Input>
            </FormItem>
            <FormItem label="供方商品编号">
              <Input v-model="defaultData.supplier_goods_code" placeholder="请填写供方商品编号"></Input>
            </FormItem>
            <FormItem label="供方销售单号">
              <Input v-model="defaultData.supplier_sale_orderid" maxlength="30" placeholder="请填写供方销售单号"></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="最新批发价">
              <InputNumber :active-change="false" :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.new_whole" placeholder="请填写最新批发价"></InputNumber>
            </FormItem>
            <FormItem label="最新零售价">
              <InputNumber :active-change="false" :max="999999999" :min="0" :step="1" :precision="6" v-model="defaultData.new_retail" placeholder="请填写最新零售价"></InputNumber>
            </FormItem>
            <FormItem label="追溯号">
              <Input v-model="defaultData.traceability_code" maxlength="20" placeholder="请填写追溯号"></Input>
            </FormItem>
            <FormItem label="灭菌批号">
              <Input v-model="defaultData.sterilization_batch" maxlength="20" placeholder="请填写灭菌批号"></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="16">
            <FormItem label="拒收原因">
              <Input v-model="defaultData.rejection_remark" maxlength="50" placeholder="请填写拒收原因"></Input>
            </FormItem>
            <FormItem label="备注">
              <Input v-model="defaultData.del_remark" maxlength="50" placeholder="请填写备注信息"></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="货品状态">
              <Select v-model="defaultData.product_status">
                <Option v-for="(item,index) in goodsStatus" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="质量状态">
              <Select v-model="defaultData.quality_status">
                <Option v-for="(item,index) in qualityStatus" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
          </Col>
        </Row>
      </Form>
      <div slot="footer">
        <Button class="f-btn" icon="md-checkmark" type="primary" @click="setGoodsInfo(true)">确定</Button>
        <Button class="f-btn" icon="md-close" @click="setGoodsInfo(false)">取消</Button>
      </div>
    </Modal>
    <select-price ref="selPriceRef" @confirm="selPrice"></select-price>
  </div>
</template>

<script>
  import SelectPrice from "@/components/common/SelectPrice"
  var _this,
      defaultData = {
        goods_code:'', name:'', unit:'', unit2:'', unit3:'',order_amount:null, come_amount:null, discount:null, gift_amount:null, rejection_amount:null, rejection_remark:'', order_no:'', tax:null, not_tax_price:null, not_tax_money:null, tax_total:null, total_price:null, buyer_price:null, buyer_price1:null, buyer_max_price:null, buyer_min_price:null, wholesale_money:null, retail_money:null,gross_profit:'', qualified_amout:null, origin:'', production:'', remark:'', is_first:'', en_name:'', supplier_no:'', wholesale_price:null, standard_price:0,retail_price:0, receipts_amout:null, price1:null, price:null, batch:'', production_date:null, production_end_date:null, supplier_orderid:'', supplier_goods_code:'',packspecs:'', pifaml:'', retail:'', supplier_sale_orderid:'', code:'', file_name:'', custom_code1:'', custom_code2:'', custom_code3:'', traceability_code:'', sterilization_batch:'', production_code:'', drug:'', product_status:'', quality_status:'',del_remark:'',
      };
	export default {
		name: "formGoods",
    components:{
      SelectPrice
    },
    data:function () {
      return{
        defaultData:defaultData,
        goodsModal:false,
        rulesFormData:{
          order_amount:[
            {required:true,type:'number',message:'请填写订货数量',trigger:'change'}
          ],
          come_amount:[
            {required:true,type:'number',message:'请填写来货数量',trigger:'change'}
          ],
          receipts_amout:[
            {required:true,type:'number',message:'请填写实收数量',trigger:'change'}
          ],
          price:[
            {required:true,type:'number',message:'请填写实际单价',trigger:'change'}
          ],
        },
        goodsStatus:[],
        qualityStatus:[],
        options: {
          disabledDate (date) {
            return date && date.valueOf() < Date.now() - 86400000;
          }
        },
        unitType:'unit3',//用作切换商品：主/辅单位 默认unit3主单位 unit2辅单位
      }
    },
    mounted() {
      _this = this;
    },
    methods:{
		  //计算方法
      computingMethod:function(){
        var not_tax_price=0,not_tax_money=0,total_price=0,tax_total=0,price=0;
        var receipts_amout= this.formatFloat(this.defaultData.receipts_amout,5);
        var discount      = this.defaultData.discount>0?this.defaultData.discount / 100:0;
        var tax           = this.defaultData.tax>0?this.defaultData.tax / 100:0;
        var standard_price= this.defaultData.standard_price;
        var retail_price  = this.defaultData.retail_price;
        tax = tax+1;
        price = discount>0?this.formatFloat(this.defaultData.price1 * discount,6):this.formatFloat(this.defaultData.price,6);
        not_tax_price = this.formatFloat(price / tax,6);
        not_tax_money = this.formatFloat(receipts_amout * price,6) / tax;
        total_price   = this.formatFloat(receipts_amout * price,5);
        tax_total     = this.formatFloat(total_price - not_tax_money,6);
        this.defaultData.price = price;
        this.defaultData.not_tax_price = this.formatFloat(not_tax_price,6);
        this.defaultData.not_tax_money = this.formatFloat(not_tax_money,6);
        this.defaultData.total_price = this.formatFloat(total_price,6);
        this.defaultData.tax_total = this.formatFloat(tax_total,6);
        this.defaultData.pifaml = this.formatFloat((standard_price - not_tax_price) * receipts_amout,6);
        this.defaultData.retail = this.formatFloat((retail_price - not_tax_price) * receipts_amout,6);
      },
      openPrice:function(){
        this.$refs.selPriceRef.open(this.defaultData.goods_code);
      },
      //选择商品价格
      selPrice:function(e){
        this.defaultData.price1 = e.price1;
        this.defaultData.price  = e.price1;
        this.computingMethod();
      },
		  open:function(data){
        data.order_amount = this.formatFloat(data.order_amount,5);
        data.come_amount = this.formatFloat(data.come_amount,5);
        data.gift_amount = this.formatFloat(data.gift_amount,5);
        data.rejection_amount = this.formatFloat(data.rejection_amount,5);
        data.receipts_amout = this.formatFloat(data.receipts_amout,5);
        data.discount = this.formatFloat(data.discount,2);
        data.tax = this.formatFloat(data.tax,2);
        data.not_tax_price = this.formatFloat(data.not_tax_price,6);
        data.not_tax_money = this.formatFloat(data.not_tax_money,6);
        data.tax_total = this.formatFloat(data.tax_total,6);
        data.total_price = this.formatFloat(data.total_price,6);
        data.price1 = this.formatFloat(data.price1,6);
        data.price = this.formatFloat(data.price,6);
        data.new_whole = this.formatFloat(data.new_whole,6);
        data.new_retail = this.formatFloat(data.new_retail,6);
        data.standard_price = data.standard_price?this.formatFloat(data.standard_price,2):0;
        data.retail_price = data.retail_price?this.formatFloat(data.retail_price,2):0;
        this.defaultData = data;
        this.goodsStatus = this.$store.state.sysParam['goods_status'];
        this.qualityStatus = this.$store.state.sysParam['quality_status'];
        this.goodsModal = true;
      },
      //编辑商品信息
      setGoodsInfo:function(type){
        if(!type) return this.goodsModal = false;
        if(this.defaultData.order_amount<=0) return this.modalMsg('请输入订货数量！');
        if(this.defaultData.come_amount<=0) return this.modalMsg('请输入来货数量！');
        if(this.defaultData.receipts_amout<=0) return this.modalMsg('请输入实收数量！');
        if(this.defaultData.order_amount < this.defaultData.come_amount) return this.modalMsg('来货数量不能大于订货数量！')
        if(this.defaultData.order_amount < this.defaultData.receipts_amout) return this.modalMsg('实收数量不能大于订货数量！')
        this.$refs.FormDataRef.validate((valid)=>{
          if (valid){
            this.defaultData.production_date = this.getDateVal(this.defaultData.production_date,false);
            this.defaultData.production_end_date = this.getDateVal(this.defaultData.production_end_date,false);
            this.goodsModal = false;
            this.$emit('confirm',this.defaultData);
          }
        })
      },
      changeUnit:function (name) {
        if(this.defaultData[name]!="undefined"){
          this.defaultData.unit = this.defaultData[name];
        }
      }
    }
	}
</script>

<style lang="less">
  .price-btn{border-right: none;border-left: none;}
  .f-btn{
    width: 80px;
  }
</style>
