<template>
  <div class="pro-main">
    <div class="pro-form">
      <Form ref="formRef" :rules="ruleVal" :model="formData" :label-width="90">
        <Row>
          <Col span="10">
            <FormItem label="姓名：" prop="user_name">
              <Input v-model="formData.user_name" maxlength="10"></Input>
            </FormItem>
            <FormItem label="性别：">
              <RadioGroup v-model="formData.sex">
                <Radio :label='1' checked>男</Radio>
                <Radio :label='2'>女</Radio>
              </RadioGroup>
            </FormItem>
            <FormItem label="身份证：" prop="id_card">
              <Input v-model="formData.id_card" maxlength="20"></Input>
            </FormItem>
            <FormItem label="部门：">
              <Input v-model="formData.depart" maxlength="30"></Input>
            </FormItem>
            <FormItem label="职务：">
              <Input v-model="formData.duties" maxlength="30"></Input>
            </FormItem>
            <FormItem label="电话：">
              <Input v-model="formData.tel" maxlength="50"></Input>
            </FormItem>
            <FormItem label="手机：">
              <Input v-model="formData.phone" maxlength="11"></Input>
            </FormItem>
            <FormItem label="QQ：">
              <Input v-model="formData.qq" maxlength="15"></Input>
            </FormItem>
            <FormItem label="创建人：">
              <Input v-model="formData.creator" disabled></Input>
            </FormItem>
            <FormItem label="创建日期：">
              <Input v-model="formData.create_date" disabled></Input>
            </FormItem>
          </Col>
          <Col span="14">
            <FormItem label="委托书编号：" :label-width="120">
              <Input v-model="formData.attorney_no" maxlength="30"></Input>
            </FormItem>
            <FormItem label="资料有效：" :label-width="120">
              <Checkbox v-model="formData.status"></Checkbox>
            </FormItem>
            <FormItem label="委托书授权内容：" :label-width="120">
               <Input type="textarea" maxlength="2000" show-word-limit v-model="formData.content_power" :autosize="{minRows:4,maxRows: 4}"></Input>
            </FormItem>
            <FormItem label="委托书有效期：" :label-width="120">
              <DatePicker type="date" :options="startOptions" transfer v-model="formData.validity_date" format="yyyy-MM-dd"></DatePicker>
            </FormItem>
            <FormItem label="委托书已失效：" :label-width="120">
              <Checkbox v-model="formData.attorney_validity"></Checkbox>
            </FormItem>
            <FormItem label="住址：" :label-width="120">
              <Input type="textarea" v-model="formData.address" maxlength="50" show-word-limit :autosize="{minRows:2,maxRows: 2}"></Input>
            </FormItem>
            <FormItem label="备注：" :label-width="120">
              <Input type="textarea" v-model="formData.remark" maxlength="100" show-word-limit :autosize="{minRows:3,maxRows: 3}"></Input>
            </FormItem>
          </Col>
        </Row>
        <Divider/>
        <Row>
          <div style="float: right;">
              <Button type="primary" :loading="btnLoading" @click="comData">提交</Button>
          </div>
        </Row>
      </Form>
    </div>
  </div>
</template>
<script>
  var fData = {id:0,orderid:'',supplier_code:'',user_name:'',sex:1,id_card:'',depart:'',duties:'',tel:'',phone:null,qq:null,attorney_no:'',status:1,content_power:'',validity_date:null,attorney_validity:1,address:'',remark:'',creator:'',create_date:null};
  export default {
    data:function() {
      return {
        btnLoading:false,
        formData:JSON.parse(JSON.stringify(fData)),
        ruleVal:{
          user_name:[
            {required:true, message:'请输入联系人姓名',trigger:'blur'}
          ],
          id_card:[
            {required:true,message:'请输入有效的联系人身份证号',trigger:'blur'}
          ]
        },
        startOptions: {
            disabledDate (date) {
              return date && date.valueOf() < Date.now() - 86400000;
            }
        }
      }
    },
    methods: {
      init:function(orderId,supplierCode,editSupplierData){
        if(editSupplierData){
          this.formData = JSON.parse(JSON.stringify(editSupplierData));
        }else{
          this.formData.orderid = orderId;
          this.formData.supplier_code = supplierCode;
        }
      },
      comData:function(){
        let _this = this;
        this.btnLoading = true;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 'saveContacts',data:{fdata:_this.formData}
            }).then(function (res) {
              if(res.status != 1){
                _this.alertMsg(res.msg,'error');
              }else{
                _this.alertMsg(res.msg);
                _this.$emit('comDataRB',{data:res.re_data})
              }
              _this.btnLoading = false;
            }).catch(function(err){
               _this.btnLoading = false;
              _this.common.httpErr(err.data,_this);
            })
          }else _this.btnLoading = false;
        })
      }
    }
  }
</script>

<style lang="less">
  .pro-main{
    display: block;width: auto;overflow-x:auto;
    .pro-form{
      padding:5px 0;width:648px;
    }
  }
</style>
