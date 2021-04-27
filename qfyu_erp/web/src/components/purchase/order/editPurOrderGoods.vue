<template>
<div>
    <Modal v-model="modal" title="编辑商品资料(采购订单)" :mask-closable="false" width="700" class-name="vertical-center-modal" footer-hide>
        <Form :label-width="70" label-position="left" class="editPurOrderGoods">
            <Row>
              <Col span="8">
                  <FormItem label="商品编号">
                       <Input :value="data.goods_code" disabled readonly></Input>
                  </FormItem>
              </Col>
              <Col span="16" class="editpoleft">
                  <FormItem label="商品名称">
                       <Input :value="data.goods_name" disabled readonly></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="8">
                  <FormItem label="商品规格">
                       <Input :value="data.specs" disabled></Input>
                  </FormItem>
              </Col>
              <Col span="16" class="editpoleft">
                  <FormItem label="生产企业">
                       <Input :value="data.production" disabled></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="8">
                  <FormItem label="商品单位">
                       <Input :value="data.unit" disabled></Input>
                  </FormItem>
              </Col>
              <Col span="16" class="editpoleft">
                  <FormItem label="">
                      <RadioGroup v-model="data.unit" @on-change="changeUnit">
                          <Radio :label="data.unit1"><span>主单位</span></Radio>
                          <Radio :label="data.unit2" :disabled="data.unit2==null || data.unit2.length==0">
                              <span>辅单位</span>
                          </Radio>
                      </RadioGroup>
                  </FormItem>
              </Col>
            </Row>
            <Divider />
            <Row>
              <Col span="12">
                  <FormItem label="商品单价">
                      <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="商品单价" :precision="6" :active-change="false"
                                   v-model="data.price" @on-blur="changePrice('price')" class="editPrice"></InputNumber>
                      <div class="iconfont SelPrice txt-color border-class" @click="clickSelPrice">&#xe7fc;</div>
                  </FormItem>
              </Col>
              <Col span="12" class="editpoleft">
                  <FormItem label="采购数量">
                      <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="采购数量" :precision="5" :active-change="false"
                          v-model="data.nums" @on-blur="changePrice('nums')"></InputNumber>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
                  <FormItem label="实际单价">
                      <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="实际单价" :precision="6" :active-change="false"
                          v-model="data.reality_price" @on-blur="changePrice('reality_price')"></InputNumber>
                  </FormItem>
              </Col>
              <Col span="12" class="editpoleft">
                  <FormItem label="折扣%">
                      <InputNumber :max="100" :min="0" :step="0.1" placeholder="折扣%" :precision="2" :active-change="false"
                          v-model="data.discount" @on-blur="changePrice('discount')"></InputNumber>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
                  <FormItem label="无税单价">
                      <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="无税单价" :precision="6" :active-change="false"
                          v-model="data.notax_price" @on-blur="changePrice('notax_price')"></InputNumber>
                  </FormItem>
              </Col>
              <Col span="12" class="editpoleft">
                  <FormItem label="税率%">
                       <InputNumber :max="100" :min="0" :step="0.1" placeholder="税率%" :precision="2" :active-change="false"
                           v-model="data.taxrate" @on-blur="changePrice('taxrate')"></InputNumber>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="12">
                  <FormItem label="货品状态">
                        <Select v-model="data.goods_status">
                            <Option v-for="(item,k) in $store.state.sysParam['goods_status']" :value="item" :key="k">{{item}}</Option>
                        </Select>
                  </FormItem>
              </Col>
              <Col span="12" class="editpoleft">
                  <FormItem label="质量状态">
                       <Select v-model="data.quality_status">
                           <Option v-for="(item,k) in $store.state.sysParam['quality_status']" :value="item" :key="k">{{item}}</Option>
                       </Select>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="生产批号/序列号" :label-width="120">
                      <Input v-model="data.batch"></Input>
                  </FormItem>
              </Col>
              <Col span="14" class="editpoleft">
                  <FormItem label="备注说明">
                       <Input v-model="data.remark"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row style="padding-top:15px;">
                <Col span="8">
                    <FormItem label="无税金额">
                        <Input :value="data.notax_total" disabled></Input>
                    </FormItem>
                </Col>
                <Col span="8" class="editpoleft">
                    <FormItem label="税款总额">
                        <Input :value="data.tax_total" disabled></Input>
                    </FormItem>
                </Col>
                <Col span="8" class="editpoleft">
                    <FormItem label="合计总额">
                        <Input :value="data.total" disabled></Input>
                    </FormItem>
                </Col>
            </Row>
            <Divider/>
            <Row>
              <Col span="24" style="text-align:right;">
                  <Button style="margin-left:8px" @click="close">取消</Button>
                  <Button type="primary" style="margin-left:15px;" @click="confirm">确认操作</Button>
              </Col>
            </Row>
        </Form>
    </Modal>
    <!-- 选择价格体系 -->
    <select-price ref="selectPriceRef" @confirm="confirmSelPrice"></select-price>
</div>
</template>
<script>
  import selectPrice from '@/components/common/SelectPrice'
  export default {
      components:{selectPrice},
      data(){
         return {
            modal:false,
            data:{}
         }
      },
      methods:{
          open:function(data){
             data.nums=parseFloat(data.nums);
             data.price=parseFloat(data.price);
             data.reality_price=parseFloat(data.reality_price);
             data.discount=parseFloat(data.discount);
             data.taxrate=parseFloat(data.taxrate);
             data.notax_price=parseFloat(data.notax_price);
             this.data=JSON.parse(JSON.stringify(data));
             this.modal=true;
          },
          close:function(){
             this.modal=false;
          },
          confirm:function(){
             this.$emit("confirm",this.data);
             this.close();
          },
          changeUnit:function(value){
             var _this=this;
             setTimeout(function(){
               if(value==null || value.length==0){
                  _this.$Modal.warning({title:"温馨提示",content:"该商品暂未设置辅单位，自动为您切换主单位"});
                  _this.data.unit=_this.data.unit1;
               }
             },5);
          },
          /****************选择价格体系******************/
          /**
           * 点击选择
           */
          clickSelPrice:function(){
              var isunit=this.data.unit==this.data.unit1?true:false;
              this.$refs.selectPriceRef.open(this.data.goods_code,isunit);
          },
          /**
           * 确认选择价格体系
           */
          confirmSelPrice:function(data){
              var price=this.data.unit==this.data.unit1?data.price1:data.price2;
              this.data.price=price;
              this.changePrice("price");
          },
          /**********计算价格**********/
          /**
           * 失去光标
           * @param obj 当前改变对象
           */
          changePrice:function(obj){
              var isprice=/^(\d{0,9}\.(\d{0,6}))$|^\d{0,9}$/;
              if(obj=="discount" || obj=="taxrate"){
                 isprice=/^(\d{0,3}\.(\d{0,2}))$|^\d{0,3}$/;
              }
              if(obj=="nums"){
                 isprice=/^(\d{0,9}\.(\d{0,5}))$|^\d{0,9}$/;
              }
              var inputprice=this.data[obj];
              if(!isprice.test(inputprice)) inputprice=0;
              this.data[obj]=isNaN(parseFloat(inputprice))?0:parseFloat(inputprice);
              this.calcPrice(obj);
          },
          /**
           * 计算价格
           * @param obj 修改对象
           */
          calcPrice:function(obj){
              var _this=this;
              var discount=parseFloat(_this.data.discount)>0?_this.formatFloat(parseFloat(_this.data.discount)/100,8):1;
              var taxrate=parseFloat(_this.data.taxrate)>0?_this.formatFloat(parseFloat(_this.data.taxrate)/100,8):0;
              if(obj=='price' || obj=='discount'){
                  //商品单价/折扣改变，结算实际单价与无税单价
                  _this.data.reality_price=_this.formatFloat(_this.data.price*discount,6); //实际单价
                  _this.data.notax_price=_this.formatFloat(_this.data.reality_price/(1+taxrate),6);//无税单价
              }
              if(obj=='reality_price'){
                  //改变实际单价，计算商品单价与无税单价
                  _this.data.price=_this.formatFloat(_this.data.reality_price*(1+taxrate),6); //商品单价
                  _this.data.notax_price=_this.formatFloat(_this.data.reality_price/(1+taxrate),6);//无税单价
              }
              if(obj=='notax_price'){
                  //改变无税单价，计算税率和折扣计算实际单价和商品单价
                  _this.data.reality_price=_this.formatFloat(_this.data.notax_price*(1+taxrate),6);//实际单价
                  _this.data.price=_this.formatFloat(_this.data.price/discount,6);//商品单价
              }
              if(obj=='taxrate'){
                  //重新计算无税单价
                  _this.data.notax_price=_this.formatFloat(_this.data.reality_price/(1+taxrate),6);//无税单价
              }
              //计算总额
              _this.data.total=_this.formatFloat(_this.data.nums*_this.data.reality_price,6); //合计
              _this.data.notax_total=_this.formatFloat(_this.data.nums*_this.data.notax_price,6); //货款
              _this.data.tax_total=_this.formatFloat(_this.data.total-_this.data.notax_total,6); //税额
          }
      }
  }
</script>
<style lang="less">
  .vertical-center-modal{
      display:flex;
      align-items:center;
      justify-content:center;
      .ivu-modal{
        top:0;
      }
  }
  .editPurOrderGoods{
      .editpoleft{padding-left:15px;}
      .editPrice{float:left;width:223px;margin-right:10px;}
      .SelPrice{width:30px;height:28px;display:inline-block;text-align:center;float:left;cursor:pointer;}
  }

</style>
