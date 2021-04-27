<template>
<div>
   <Modal v-model="modal" title="编辑缺货登记" :mask-closable="false" width="700" class-name="vertical-center-modal" footer-hide>
        <Form :label-width="90" label-position="left">
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
            <Divider />
            <Row>
              <Col span="10">
                    <FormItem label="商品单位">
                        <Input v-model="data.unit" disabled></Input>
                    </FormItem>
              </Col>
              <Col span="14">
                    <FormItem label="缺货数量">
                        <InputNumber :max="99999999" :min="0" :precision="5" :step="0.1" :active-change="false" v-model="data.nums" placeholder="缺货数量"></InputNumber>
                    </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="24">
                  <FormItem label="已订购数量">
                       <Input v-model="data.already_nums" maxlength="15" placeholder="已订购数量"></Input>
                  </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="24">
                  <FormItem label="备注说明">
                       <Input v-model="data.explain" maxlength="15" placeholder="请填写备注说明"></Input>
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
              data:{},
              modal:false
           }
        },
        created:function(){
           _this=this;
        },
        methods:{
            open:function(data){
                 _this.data=JSON.parse(JSON.stringify(data));
                 _this.modal=true;
            },
            close:function(){
                 _this.modal=false;
            },
            confirm:function(){
                _this.$emit("confirm",JSON.parse(JSON.stringify(_this.data)));
                _this.close();
            }
        }
    }
</script>
<style>
</style>
