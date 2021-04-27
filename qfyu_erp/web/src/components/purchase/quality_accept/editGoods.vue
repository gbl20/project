<template>
	<div>
    <Modal title="编辑商品信息" v-model="modal" width="800">
      <Form ref="formInline" :model="proData" :label-width="80">
        <Row>
          <Col span="8">
            <FormItem label="商品编号">
              <Input v-model="proData.goods_code" disabled></Input>
            </FormItem>
            <FormItem label="验收数量">
              <InputNumber :max="9999999999" :min="0" :precision="5" :active-change="false" v-model="proData.amount"></InputNumber>
            </FormItem>
            <FormItem label="合格数量">
              <InputNumber :max="9999999999" :min="0" :precision="5" :active-change="false" v-model="proData.qualified_amount"></InputNumber>
            </FormItem>
            <FormItem label="药检报告">
              <Select v-model="proData.verify_report">
                <Option v-for="(item,index) in checkItem.verify_report" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="通关单号">
              <Input v-model="proData.pass_gate_no"></Input>
            </FormItem>
            <FormItem label="包装状况">
              <Select v-model="proData.package_state">
                <Option v-for="(item,index) in checkItem.package_state" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="验收结论">
              <Select v-model="proData.check_verdict">
                <Option v-for="(item,index) in checkItem.check_verdict" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="源单项次">
              <Input v-model="proData.item_no"></Input>
            </FormItem>
            <FormItem label="生产日期">
              <DatePicker type="date" v-model="proData.production_date"></DatePicker>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="商品名称">
              <Input v-model="proData.name"></Input>
            </FormItem>
            <FormItem label="不合格数量">
              <InputNumber :max="9999999999" :min="0" :precision="5" :active-change="false" v-model="proData.rejection_amount"></InputNumber>
            </FormItem>
            <FormItem label="抽样数量">
              <InputNumber :max="9999999999" :min="0" :precision="5" :active-change="false" v-model="proData.spot_check_amount"></InputNumber>
            </FormItem>
            <FormItem label="注册证号">
              <Input v-model="proData.register_card_no"></Input>
            </FormItem>
            <FormItem label="合格证">
              <Input v-model="proData.certificato"></Input>
            </FormItem>
            <FormItem label="标签状况">
              <Select v-model="proData.label_state">
                <Option v-for="(item,index) in checkItem.label_state" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="收货人">
              <Input v-model="proData.accepter"></Input>
            </FormItem>
            <FormItem label="存储条件">
              <Input v-model="proData.storage_type"></Input>
            </FormItem>
            <FormItem label="有效期至">
              <DatePicker type="date" v-model="proData.production_end_date"></DatePicker>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="商品单价">
              <InputNumber :max="9999999999" :min="0" :precision="6" :active-change="false" v-model="proData.price"></InputNumber>
            </FormItem>
            <FormItem label="金额">
              <InputNumber :max="9999999999" :min="0" :precision="6" :active-change="false" v-model="proData.money"></InputNumber>
            </FormItem>
            <FormItem label="生产批号">
              <Input v-model="proData.batch"></Input>
            </FormItem>
            <FormItem label="灭菌批号">
              <Input v-model="proData.sterilization_batch"></Input>
            </FormItem>
            <FormItem label="外观质量">
              <Select v-model="proData.quality_state">
                <Option v-for="(item,index) in checkItem.quality_state" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="说明书">
              <Select v-model="proData.directions">
                <Option v-for="(item,index) in checkItem.directions" :value="item" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="不合格处理">
              <Select v-model="proData.rejection_type">
                <Option v-for="(item,index) in checkItem.rejection_type" :value="index" :key="index">{{item}}</Option>
              </Select>
            </FormItem>
            <FormItem label="追溯号">
              <Input v-model="proData.traceability_code"></Input>
            </FormItem>
            <FormItem label="备注">
              <Input v-model="proData.remark"></Input>
            </FormItem>
          </Col>
        </Row>
      </Form>
      <div slot="footer">
        <Button type="primary" icon="md-checkmark" @click="confirm(true)">确定</Button>
        <Button icon="md-checkmark" @click="confirm(false)">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
	export default {
    data:function () {
      return{
        modal:false,
        gspType:null,
        typeItem:[],
        proData:{},
        formData:{
          goods_code:'',
          amount:null,
          qualified_amount:null,
          verify_report:'',
          pass_gate_no:'',
          package_state:'',
          check_verdict:'',
          item_no:'',
          name:'',
          rejection_amount:'',
          spot_check_amount:'',
          label_state:'',
          accepter:'',
          storage_type:'',
          price:null,
          money:null,
          batch:'',
          sterilization_batch:'',
          quality_state:'',
          directions:'',
          rejection_type:'0',
          traceability_code:'',
          production_date:'',
          production_end_date:'',
          remark:''
        },
        checkItem:[]
      }
    },
    methods:{
      changenum:function(){

      },
		  open:function (data) {
        this.checkItem = this.$store.state.sysParam['check_default'];
        this.modal = true;
        for (let key in this.formData){
          if(data[key]!="undefined") this.proData[key] = data[key];
          this.proData.amount = this.formatFloat(this.proData.amount,5)
          this.proData.qualified_amount = this.formatFloat(this.proData.qualified_amount,5)
          this.proData.rejection_amount = this.formatFloat(this.proData.rejection_amount,5)
          this.proData.spot_check_amount = this.formatFloat(this.proData.spot_check_amount,5)
          this.proData.price = this.formatFloat(this.proData.price,6)
          this.proData.money = this.formatFloat(this.proData.money,6)
        }
      },
      confirm:function (type) {
		    if (type){
          if(this.proData.spot_check_amount<=0) return this.modalMsg('请填写【抽样数量】！');
          if(this.proData.amount<this.proData.spot_check_amount) return this.modalMsg('【抽检数量】不能超过【待验收数量】！');
          if(this.proData.amount<this.proData.qualified_amount) return this.modalMsg('【验收数量】不能小于【合格品数量】！');
          if(this.proData.rejection_amount>this.proData.qualified_amount) return this.modalMsg('【验收数量】不能小于【未合格品数量】！');
          this.$emit('confirm',this.proData)
        }
        this.modal=false;
      }
    }
	}
</script>

<style lang="less">

</style>
