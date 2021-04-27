<template>
  <div v-if="show_self">
    <Modal v-model="show_self" title="协议品种管理" width="618" :closable="false" :mask-closable="false" footer-hide>
      <Form ref="formRef" :rules="ruleVal" :model="data" :label-width="110">
        <Row>
          <Col span="12">
            <FormItem label="商品编号：" prop="goods_code">
              <Input readonly icon="ios-more" style="cursor: pointer;" v-model="data.goods_code" @on-click="choosePro"></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="客户产品编号：">
              <Input maxlength="10" v-model="data.cgoods_code"></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="商品名称：">
              <Input v-model="data.goods_name" disabled></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="规格：">
              <Input v-model="data.specs" disabled></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="主单位：">
              <Input v-model="data.unit" disabled></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="主单位协议价：">
              <InputNumber :precision="2"  :max="999999" :min="0" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="data.price"></InputNumber>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="辅单位：">
              <Input v-model="data.unit2" disabled></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="辅单位协议价：">
              <InputNumber :disabled="data.unit2?false:true" :precision="2"  :max="999999" :min="0" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="data.price2"></InputNumber>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="产地：">
              <Input v-model="data.origin" disabled></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="最近交易日期：">
              <DatePicker type="date" v-model="data.near_date" placeholder="最近交易日期" ></DatePicker>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="限制月销量：">
              <InputNumber v-model="data.month_limit" :precision="0"></InputNumber>
            </FormItem>
          </Col>
          <Col span="12" class="cust-goods-attention-msg">*以主单位计算，填0或留空表示不限制</Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="限制日销量：">
              <InputNumber v-model="data.day_limit" :precision="0"></InputNumber>
            </FormItem>
          </Col>
          <Col span="12"><span class="cust-goods-attention-msg">*以主单位计算，填0或留空表示不限制</span></Col>
        </Row>
        <Row>
          <Col span="16">
            <FormItem label="生产企业：">
              <Input v-model="data.production" disabled></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="剂型：" :label-width="70">
              <Input v-model="data.dosage" disabled></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="16">
            <FormItem label="批准文号：">
              <Input v-model="data.approval_code" disabled></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="" :label-width="30">
              <Checkbox :value="data.no_auto_price" :true-value="1" :false-value="0">不自动调价</Checkbox>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="16">
            <FormItem label="备注：">
              <Input maxlength="100" v-model="data.remark"></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem :label-width="30">
              <Checkbox v-model="data.is_valid" :true-value="1" :false-value="0">有效</Checkbox>
            </FormItem>
          </Col>
        </Row>
      </Form>
      <Divider/>
      <div style="text-align: right;">
        <Button type="text" @click="show_self = false">取消</Button>
        <Button type="primary" :loading="subLoading" @click="comData">确定</Button>
      </div>
    </Modal>
    <select-goods ref="selectGoodsRef" :isSignle="true" @selectRow="selectGoodsRow"></select-goods>
  </div>
</template>
<script>
import selectGoods from '@/components/common/ChooseGoods'
  export default{
    name :'custgoods',
    components:{selectGoods},
    props: {
    },
    data:function(){
      return {
        show_self:false,
        subLoading:false,
        data:{},
        default_data:{id:0,goods_code:'',cgoods_code:'',goods_name:'',specs:'',unit:'',unit2:'',price:null,price2:null,origin:'',near_date:'',month_limit:null,day_limit:null,production:'',dosage:'',approval_code:'',no_auto_price:0,remark:'',is_valid:1},
        cid:'',
        ruleVal:{
          goods_code:[
            {required:true,type:'string',message:'请选择产品',trigger:'change'}
         ]
        }
      }
    },
    methods:{
      init:function(params){
        if(typeof(params)=="undefined") return false;
        this.show_self=true;
        this.cid=params.cid;
        if(params.data.id==0){
          this.data=JSON.parse(JSON.stringify(this.default_data));
        }else{
          params.data.price=params.data.price==null?null:parseFloat(params.data.price);
          params.data.price2=params.data.price2==null?null:parseFloat(params.data.price2);
          this.data=params.data;
        }
      },
      /**
       * 打开选择产品
       */
      choosePro:function(){
        this.$refs.selectGoodsRef.open();
      },
      /**
       * 选择产品回调
       */
      selectGoodsRow:function (goods){
        this.data.goods_code=goods.goods_code;
        this.data.goods_name=goods.goods_name;
        this.data.specs=goods.specs;
        this.data.unit=goods.unit;
        this.data.unit2=goods.unit2;
        this.data.origin=goods.origin;
        this.data.production=goods.production;
        this.data.dosage=goods.dosage;
        this.data.approval_code=goods.approval_code;
      },
      /**
       * 提交保存
       */
      comData:function (){
        var _this = this;
        if(this.cid=='') return false;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.subLoading = true;
            _this.data.cid = _this.cid;
            _this.common.http({url: 'comCustGoods',data:_this.data}).then(function (res) {
              _this.subLoading = false;
              if(res.status==1){
                _this.$parent.get_goods(_this.cid);
                _this.show_self=false;
                _this.alertMsg(res.msg,'success');
              }else{
                _this.alertMsg(res.msg,'error');
              }
            }).catch(function(err){
              _this.subLoading = false;
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      }
    }
  }
</script>
<style lang="less">
  .cust-goods-attention-msg{
    padding-left:10px;font-size: 12px;line-height: 28px; color: #ed4014;
  }
</style>
