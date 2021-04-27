<template>
<div>
    <Modal v-model="ModVal" title="编辑商品信息" :mask-closable="false" width="600" footer-hide>
        <Form ref="formRef" :model="data" :rules="ruleVal" :label-width="90" label-position="right">
            <FormItem label="基本信息">
              <Input :value="'('+data.goods_code+')'+data.goods_name" disabled></Input>
            </FormItem>
            <Row>
              <Col span="12">
                <FormItem label="客方产品编号">
                  <Input v-model="data.cust_goods_code" maxlength="15" placeholder="客方产品编号"></Input>
                </FormItem>
              </Col>
              <Col span="12">
               <FormItem label="数量" prop="qty">
                 <InputNumber :active-change="false" :precision="3" :max="99999999" :min="0.001" v-model="data.qty" placeholder="调整数量"></InputNumber>
               </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
                <Row>
                  <Col span="21">
                    <FormItem label="商品单价" prop="o_price">
                      <InputNumber :active-change="false" :precision="6" :max="9999999" :min="0.01" v-model="data.o_price" placeholder="商品单价"></InputNumber>
                    </FormItem>
                  </Col>
                  <Col span="3">
                    <FormItem label="" :label-width="3">
                      <div class="edit-goods-details">
                        <Input icon="ios-more" style="cursor:pointer;" @on-click="chooseSelPrice" readonly></Input>
                      </div>
                    </FormItem>
                  </Col>
                </Row>
              </Col>
              <Col span="12">
                <FormItem label="折扣(%)">
                  <InputNumber :active-change="false" :precision="2" :max="100" :min="0.01" v-model="data.rebate" placeholder="折扣(%)"></InputNumber>
                </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
                <FormItem label="税率(%)">
                  <InputNumber :active-change="false" :precision="4" :max="100" :min="0" v-model="data.tax_rate" placeholder="税率(%)"></InputNumber>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="无税单价(元)">
                   <Input :value="data.un_tax_price" placeholder="无税单价" disabled></Input>
                </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
               <FormItem label="实际单价">
                  <Input :value="data.price" placeholder="无税单价" disabled></Input>
               </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="无税金额">
                   <Input :value="data.goods_sum" placeholder="无税金额" disabled></Input>
                </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
                <FormItem label="税款">
                   <Input :value="data.tax_sum" placeholder="税款" disabled></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="合计">
                   <Input :value="data.amount" placeholder="合计" disabled></Input>
                </FormItem>
              </Col>
            </Row>
            <FormItem label="备注说明">
              <Input v-model="data.remark" maxlength="500" placeholder="备注说明"></Input>
            </FormItem>
            <Divider/>
            <Row>
              <Col span="24" style="text-align:right;">
                <Button @click="ModVal=false">取消</Button>
                <Button type="primary" style="margin-left:15px;" @click="comGoodsDet">确认</Button>
              </Col>
            </Row>
        </Form>
    </Modal>
    <select-price ref="selectPriceRef" @confirm="confirmSelPrice"></select-price>
  </div>
</template>
<script>
  import selectPrice from '@/components/common/SelectPrice'
  export default {
     components:{selectPrice},
     data(){
      return {
        ModVal:false,
        data:{o_price:0.01},
        ruleVal:{
          qty:[
            {required:true,type:'number',min:0.001,message:'请输入数量',trigger:'change'}
          ],
          o_price:[
            {required:true,type:'number',min:0.01,message:'请输入有效的价格',trigger:'change'}
          ]
        }
      }
     },
     computed:{
       checkPrice(){
         return this.data.qty + this.data.o_price + this.data.rebate + this.data.tax;
       }
     },
     watch:{
       checkPrice(){
        this.opPrice();
       }
     },
     methods:{
        open:function(data){
          if(data.o_price) data.o_price = parseFloat(data.o_price);
          if(data.price) data.price = parseFloat(data.price);
          if(data.qty) data.qty = parseFloat(data.qty);
          if(data.rebate) data.rebate = parseFloat(data.rebate);
          if(data.tax_rate) data.tax_rate = parseFloat(data.tax_rate);
          this.data = JSON.parse(JSON.stringify(data));
          this.ModVal = true
        },
        confirmSelPrice:function(e){
          this.$set(this.data,'o_price',e.price1);
        },
        chooseSelPrice:function(){
          this.$refs.selectPriceRef.open(this.data.goods_code);
        },
        opPrice:function(){
          let obj = this.data;
          let qty = obj.qty || 0;
          let rebate = obj.rebate || 100;
          let tax = obj.tax_rate || 0;
          tax = parseFloat(tax + 100);
          let price = this.formatFloat(obj.o_price*rebate/100,6)
          if(!price){
            obj.price = null;
            obj.un_tax_price = null
          }else{
            obj.price = price;
            obj.un_tax_price = this.formatFloat(obj.price/tax*100,6);
          }
          obj.goods_sum = this.formatFloat(obj.un_tax_price*qty,6);
          obj.amount = this.formatFloat(obj.price*qty,6);
          obj.tax_sum = this.formatFloat(obj.amount-obj.goods_sum,6);
        },
        comGoodsDet:function(){
          let _this = this;
          this.$refs.formRef.validate(function(valid){
            if (valid) {
              _this.$emit('comGoodsDet',_this.data);
              _this.ModVal = false;
            }
          })
        }
     }
  }
</script>
<style lang="less">
  .edit-goods-details{
    .ivu-input-icon-normal + .ivu-input{
      padding-right: 0;
    }
  }
</style>
