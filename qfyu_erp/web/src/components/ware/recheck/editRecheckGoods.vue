<template>
  <div>
      <Modal v-model="modal" title="修改入库商品资料" :mask-closable="false" class-name="recheck-center-modal" width="1000" footer-hide>
          <Form :label-width="70" label-position="left" class="editRecheckGoods">
              <Row>
                  <Col span="5">
                      <FormItem label="商品编号">
                           <Input :value="data.goods_code" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="12" class="pos-left">
                      <FormItem label="商品名称">
                           <Input :value="data.goods_name" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="7" class="pos-left">
                      <FormItem label="商品规格">
                           <Input :value="data.specs" disabled></Input>
                      </FormItem>
                  </Col>
              </Row>
              <Row>
                  <Col span="5">
                      <FormItem label="商品单位">
                           <Input :value="data.unit" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="19" class="pos-left">
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
                  <Col span="11">
                      <FormItem label="收货仓库" class="sel_sup">
                           <Input class="left" v-model="data.ware_code" disabled></Input>
                           <Input icon="ios-more" v-model="data.ware_title" @on-click="selectWare" readonly class="right cursor"></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="仓库货位">
                           <Input icon="ios-more" v-model="data.pos_code" @on-click="selectWarePos" readonly class="cursor"></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="数量">
                           <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="数量" :precision="5" :active-change="false"
                               v-model="data.qty" @on-blur="changePrice('qty')" @on-change="changePrice('qty')"></InputNumber>
                      </FormItem>
                  </Col>
              </Row>
              <Row>
                  <Col span="6">
                      <FormItem label="生产批号">
                           <Input class="left" v-model="data.batchno"></Input>
                      </FormItem>
                  </Col>
                  <Col span="5" class="pos-left">
                      <FormItem label="生产日期">
                           <DatePicker type="date" :editable="false" :clearable="false" v-model="data.prod_date" placeholder="生产日期"></DatePicker>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="有效期至">
                           <DatePicker type="date" :editable="false" v-model="data.valid_date" placeholder="有效期至"></DatePicker>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="赠品数量">
                           <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="赠品数量" :precision="5" :active-change="false"
                               v-model="data.giftqty" @on-blur="changePrice('giftqty')" @on-change="changePrice('giftqty')"></InputNumber>
                      </FormItem>
                  </Col>
              </Row>
              <Row>
                  <Col span="11">
                      <FormItem label="供方销售编号" :label-width="100">
                           <Input class="left" v-model="data.sup_sellno" maxlength="50"></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="实际单价">
                           <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="实际单价" :precision="6" :active-change="false"
                               v-model="data.price" @on-blur="changePrice('price')" @on-change="changePrice('price')" class="editPrice"></InputNumber>
                           <div class="iconfont SelPrice txt-color border-class" @click="clickSelPrice">&#xe7fc;</div>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="无税单价">
                           <InputNumber :max="999999999" :min="0" :step="0.1" placeholder="无税单价" :precision="6" :active-change="false"
                               v-model="data.notax_price" @on-blur="changePrice('notax_price')" @on-change="changePrice('notax_price')"></InputNumber>
                      </FormItem>
                  </Col>
              </Row>
              <Row>
                  <Col span="11">
                      <FormItem label="供方产品编号" :label-width="100">
                           <Input class="left" v-model="data.sup_goodsid" maxlength="50"></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="税率%">
                           <InputNumber :max="100" :min="0" :step="0.1" placeholder="税率%" :precision="2" :active-change="false"
                               v-model="data.taxrate" @on-blur="changePrice('taxrate')" @on-change="changePrice('taxrate')"></InputNumber>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="税额">
                           <Input class="left" v-model="data.taxsum" disabled></Input>
                      </FormItem>
                  </Col>
              </Row>
              <Row>
                  <Col span="6">
                      <FormItem label="追溯号">
                           <Input class="left" v-model="data.traceback_no" maxlength="50"></Input>
                      </FormItem>
                  </Col>
                  <Col span="5" class="pos-left">
                      <FormItem label="灭菌批号">
                           <Input class="left" v-model="data.germicidal_no" maxlength="50"></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="参考零售价" :label-width="80">
                           <Input class="left" v-model="data.retail_price" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="参考批发价" :label-width="80">
                           <Input class="left" v-model="data.standard_price" disabled></Input>
                      </FormItem>
                  </Col>
              </Row>
              <Row>
                  <Col span="6">
                      <FormItem label="货品状态">
                           <Select v-model="data.goods_state" v-if="JSON.stringify(params)!='{}'">
                              <Option :value="p" v-for="(p,k) in params.goods_status" :key="k">{{p}}</Option>
                           </Select>
                      </FormItem>
                  </Col>
                  <Col span="5" class="pos-left">
                      <FormItem label="质量状态">
                          <Select v-model="data.quality_state" v-if="JSON.stringify(params)!='{}'">
                             <Option :value="p" v-for="(p,k) in params.quality_status" :key="k">{{p}}</Option>
                          </Select>
                      </FormItem>
                  </Col>
                  <Col span="12" class="pos-left">
                      <FormItem label="备注说明">
                           <Input class="left" v-model="data.remark"></Input>
                      </FormItem>
                  </Col>
              </Row>
              <Divider />
              <Row>
                  <Col span="6">
                      <FormItem label="参考零售价合计" :label-width="110">
                           <Input class="left" :value="data.retail_amount" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="货款总额" :label-width="90">
                           <Input class="left" :value="data.goodssum" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="合计总额">
                           <Input class="left" v-model="data.amount" disabled></Input>
                      </FormItem>
                  </Col>
                  <Col span="6" class="pos-left">
                      <FormItem label="近销差价">
                           <Input class="left" v-model="data.diff_amount" disabled></Input>
                      </FormItem>
                  </Col>
              </Row>
              <Divider />
              <Row>
                <Col span="24" style="text-align:right;">
                    <Button type="primary" style="margin-rigght:15px;width:120px;" @click="confirm">确认修改</Button>
                    <Button style="margin-left:8px" @click="close">取消</Button>
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
       name:'editRecheckGoods',
       data(){
         return {
            modal:false,
            data:{}
         }
       },
       props:{
          params:{
             type:Object,
             default:()=>{}
          }
       },
       methods:{
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
          open:function(data){
               data.qty=parseFloat(data.qty);
               data.giftqty=parseFloat(data.giftqty);
               data.price=parseFloat(data.price);
               data.taxrate=parseFloat(data.taxrate);
               data.notax_price=parseFloat(data.notax_price);
               this.data=JSON.parse(JSON.stringify(data));
               this.modal=true;
          },
          close:function(){
               this.modal=false;
          },
          confirm:function(){
               var data=JSON.parse(JSON.stringify(this.data));
               if(data.batchno.length==0){
                  return this.alertMsg('请填写商品生产批号/序列号','error');
               }
               if(data.prod_date.length==0){
                  return this.alertMsg('请设置商品生产日期','error');
               }
               if(parseFloat(data.qty)<=0){
                  return this.alertMsg('请填写采购数量（数量必须大于0）','error');
               }
               var pro=new Date(data.prod_date);
               data.prod_date=pro.getFullYear()+'-'+(pro.getMonth()+1)+'-'+pro.getDate();
               if(data.valid_date!=null && data.valid_date.length>0){
                  var valid=new Date(data.valid_date);
                  data.valid_date=valid.getFullYear()+'-'+(valid.getMonth()+1)+'-'+valid.getDate();
               }
               this.$emit("confirm",data);
               this.close();
          },
          changePrice:function(obj){
               var isprice=/^(\d{0,9}\.(\d{0,6}))$|^\d{0,9}$/;
               if(obj=="taxrate") isprice=/^(\d{0,3}\.(\d{0,2}))$|^\d{0,3}$/;
               if(obj=="qty" || obj=='giftqty') isprice=/^(\d{0,9}\.(\d{0,5}))$|^\d{0,9}$/;
               var inputprice=this.data[obj];
               if(!isprice.test(inputprice)) inputprice=0;
               this.data[obj]=isNaN(parseFloat(inputprice))?0:parseFloat(inputprice);
               this.calcPrice(obj);
          },
          calcPrice:function(obj){
              var _this=this;
              var taxrate=parseFloat(_this.data.taxrate)>0?_this.formatFloat(parseFloat(_this.data.taxrate)/100,8):0;
              if(obj=='price' || obj=='taxrate'){ //实际单价或税率时，计算无税单价
                  _this.data.notax_price=_this.formatFloat(_this.data.price/(1+taxrate),6);
              }
              if(obj=='notax_price'){ //改变无税单价，计算实际单价
                  _this.data.price=_this.formatFloat(_this.data.notax_price*(1+taxrate),6);
              }
              //计算总额
              _this.data.amount=_this.formatFloat(_this.data.qty*_this.data.price,6); //合计
              _this.data.goodssum=_this.formatFloat(_this.data.qty*_this.data.notax_price,6); //货款
              _this.data.taxsum=_this.formatFloat(_this.data.amount-_this.data.goodssum,6); //税额
              _this.data.retail_amount=_this.formatFloat(_this.data.qty*_this.data.retail_price,6); //参考零售价合计
              var diff_price=_this.formatFloat(_this.data.retail_price-_this.data.price,10);
              _this.data.diff_amount=_this.formatFloat(diff_price*_this.data.qty,6);
          },
          /**
           * 获取选择的仓库编码
           */
          getWareCode:function(){
             return this.data.ware_code;
          },

          /**********选择仓库***********/
          selectWare:function(){
             this.$parent.selectWareFun("editRecheckGoodsRef");
          },
          /**
           * 设置仓库信息
           * @param ware_code 仓库编码
           * @param ware_title 仓库名称
           */
          setWareNotify:function(data){
             this.data.ware_code=data.ware_code;
             this.data.ware_title=data.ware_title;
          },

          /****************选择货位******************/
          selectWarePos:function(){
             this.$parent.selectWarePosFun("editRecheckGoodsRef");
          },
          /**
           * 选择货位回调
           * @param data
           */
          setWarePosNotify:function(data){
             this.data.pos_code=data.pos_code;
          }
       }
    }
</script>
<style lang="less">
  .recheck-center-modal{
      display:flex;align-items:center;justify-content:center;
      .ivu-modal{top:0;width:1000px !important;}
  }
  .editRecheckGoods{
      width:965px;
      .pos-left{padding-left:15px;}
      .cursor{cursor:pointer;}
      .sel_sup{
        .left{width:80px;float:left;display:inline-block;margin-right:5px;}
        .right{width:287px;display:inline-block;float:left;}
      }
      .editPrice{float:left;width:120px;margin-right:5px;}
      .SelPrice{width:30px;height:28px;display:inline-block;text-align:center;float:left;cursor:pointer;}
  }
</style>
