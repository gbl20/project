<template>
<div>
    <Modal v-model="modal" title="编辑采购商品资料" :mask-closable="false" width="700" footer-hide>
        <Form :label-width="80" label-position="left">
            <Row>
              <Col span="10">
                  <FormItem label="商品编号">
                       <Input v-model="data.goods_code" disabled readonly></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="商品名称">
                       <Input v-model="data.goods_name" disabled readonly></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="调整数量">
                       <Input v-model="data.buynum" @on-blur="changePrice('buynum')" maxlength="15" placeholder="调整数量"></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="商品单价">
                       <Input v-model="data.buyprice" @on-blur="changePrice('buyprice')" maxlength="15" placeholder="商品单价"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="税率(%)">
                       <Input v-model="data.tax" @on-blur="changePrice('tax')" maxlength="15" placeholder="税率"></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="无税单价">
                       <Input v-model="data.notaxprice" @on-blur="changePrice('notaxprice')" maxlength="15" placeholder="无税单价"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="供应商">
                       <Input v-model="data.sup_code" icon="ios-more" @on-click="selectProviders" style="cursor:pointer;" readonly></Input>
                  </FormItem>
              </Col>
              <Col span="14" style="padding-left:5px;">
                  <Input v-model="data.sup_name" readonly></Input>
              </Col>
            </Row>
            <Row>
              <Col span="24">
                  <FormItem label="备注说明">
                       <Input v-model="data.remark" maxlength="500" placeholder="备注说明"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Divider />
            <Row>
              <Col span="10">
                  <FormItem label="供应商1价">
                       <Input v-model="data.provprice1" @on-blur="changePrice('provprice1')" maxlength="15" placeholder="供应商1价"></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="供应商2价">
                       <Input v-model="data.provprice2" @on-blur="changePrice('provprice2')" maxlength="15" placeholder="供应商2价"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="供应商3价">
                       <Input v-model="data.provprice3" @on-blur="changePrice('provprice3')" maxlength="15" placeholder="供应商3价"></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="供应商4价">
                       <Input v-model="data.provprice4" @on-blur="changePrice('provprice4')" maxlength="15" placeholder="供应商4价"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="供应商5价">
                       <Input v-model="data.provprice5" @on-blur="changePrice('provprice5')" maxlength="15" placeholder="供应商5价"></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="供应商6价">
                       <Input v-model="data.provprice6" @on-blur="changePrice('provprice6')" maxlength="15" placeholder="供应商6价"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10">
                  <FormItem label="供应商7价">
                       <Input v-model="data.provprice7" @on-blur="changePrice('provprice7')" maxlength="15" placeholder="供应商7价"></Input>
                  </FormItem>
              </Col>
              <Col span="14">
                  <FormItem label="供应商8价">
                       <Input v-model="data.provprice8" @on-blur="changePrice('provprice8')" maxlength="15" placeholder="供应商8价"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Divider/>
            <Row>
              <Col span="24" style="text-align:right;">
                  <Button style="margin-left:8px" @click="close">取消</Button>
                  <Button type="primary" style="margin-left:15px;" @click="confirm">确认</Button>
              </Col>
            </Row>
        </Form>
    </Modal>
  </div>
</template>
<script>
  var _this;
  export default {
     data(){
        return {
            modal:false,
            data:{}
        }
     },
     created:function(){
        _this=this;
     },
     methods:{
        changePrice:function(obj){
            var isprice=/^(\d{0,9}\.(\d{0,6}))$|^\d{0,9}$/;
            if(obj=="buynum"){
                isprice=/^(\d{0,9}\.(\d{0,5}))$|^\d{0,9}$/;
            }
            if(obj=="tax"){
                isprice=/^(\d{0,3}\.(\d{0,2}))$|^\d{0,3}$/;
            }
            var inputprice=_this.data[obj];
            if(!isprice.test(inputprice)) inputprice=0;
            _this.data[obj]=parseFloat(inputprice);
            _this.calcPrice(obj);
        },
        calcPrice:function(obj){
            //输入无税单价，计算商品单价
            var tax=_this.formatFloat(_this.data.tax/100+1,8);
            if(obj=='notaxprice'){
                _this.data.buyprice=_this.formatFloat(tax*_this.data.notaxprice,6);
            }else if(obj=='buyprice' || obj=='tax'){
               //计算无税单价
               _this.data.notaxprice=_this.formatFloat(_this.data.buyprice/tax,6);
            }
        },
        open:function(data){
              _this.data=JSON.parse(JSON.stringify(data));
              _this.modal=true;
        },
        close:function(){
              _this.modal=false;
        },
        confirm:function(){
              _this.data.tax=parseFloat(_this.data.tax);
              //计算货款，税款、合计
              _this.data.totalprice=_this.formatFloat(_this.data.buynum*_this.data.buyprice,6);
              _this.data.goodsprice=_this.formatFloat(_this.data.buynum*_this.data.notaxprice,6);
              _this.data.taxprice=_this.formatFloat(_this.data.totalprice-_this.data.goodsprice,6);
              _this.$emit("confirmSave",_this.data);
        },
        /****选择供应商****/
        selectProviders:function(){
           this.$parent.selectProviders('editGoodsRef');
        },
        /**
         * 确认选择
         */
        selectProvNotify:function(e){
            _this.data.sup_code=e.supplier_code;
            _this.data.sup_name=e.full_name;
        }
     }
  }
</script>
<style>
</style>
