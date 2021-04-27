<template>
<div>
   <Modal v-model="editModal" title="委托物流单位-新增" width="400" :mask-closable="false" footer-hide>
      <Form ref="formRef" :label-width="105" :rules="ruleVal" :model="formData" label-position="right">
        <FormItem label="公司名称" prop="company">
          <Input placeholder="公司名称" v-model="formData.company" maxlength="100" ></Input>
        </FormItem>
        <FormItem label="公司地址">
          <Input placeholder="公司地址" v-model="formData.addr" maxlength="100" ></Input>
        </FormItem>
        <FormItem label="联系人">
          <Input placeholder="联系人" v-model="formData.contact" maxlength="30" ></Input>
        </FormItem>
        <FormItem label="联系人身份证号">
          <Input placeholder="联系人身份证号" v-model="formData.card_id" maxlength="18" ></Input>
        </FormItem>
        <FormItem label="联系人手机">
          <Input placeholder="联系人手机" v-model="formData.phone" maxlength="11" ></Input>
        </FormItem>
        <FormItem label="联系人电话">
          <Input placeholder="联系人电话" v-model="formData.tel" maxlength="50" ></Input>
        </FormItem>
        <FormItem label="营业执照" prop="business_license">
          <Input placeholder="营业执照" v-model="formData.business_license" maxlength="50" ></Input>
        </FormItem>
        <FormItem label="营业执照有效期" prop="business_validity_date">
          <DatePicker type="date" :editable="false" placeholder="营业执照有效期" v-model="formData.business_validity_date" ></DatePicker>
        </FormItem>
        <FormItem label="合同有效期" prop="contract_validity_date">
          <DatePicker type="date" :editable="false" placeholder="合同有效期" v-model="formData.contract_validity_date" ></DatePicker>
        </FormItem>
        <FormItem label="运输方式">
          <Select v-model="formData.ship_type" >
            <Option v-for="(item,index) in $store.state.sysParam['ship_type']" :key="index" :value="item" >{{item}}</Option>
          </Select>
        </FormItem>
        <FormItem label="备注">
          <Input placeholder="备注" v-model="formData.remark" maxlength="50" ></Input>
        </FormItem>
        <Divider/>
        <Row>
          <div style="float: right;">
            <Button type="text" @click="editModal = false">取消</Button>
            <Button type="primary" :loading="subLoading" @click="comData">保存</Button>
          </div>
        </Row>
   </Form>
  </Modal>
</div>
</template>
<script>
  var formD = {id:0,company:'',addr:'',contact:'',card_id:'',phone:'',tel:'',business_license:'',business_validity_date:null,contract_validity_date:null,ship_type:null,remark:''};
  export default {
    data(){
      const validateDate = (rule, value, callback) => {
           if (value) {
             callback();
           } else {
             callback(new Error("不能为空"));
           }
         };
      return {
        editModal:false,
        isedit:false,
        subLoading:false,
        formData:JSON.parse(JSON.stringify(formD)),
        ruleVal:{
          company:[
            {required:true, message:'请填写公司名称！',trigger:'change'}
          ],
          business_license:[
            {required:true, message:'请填写营业执照号！',trigger:'change'}
          ],
          business_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ],
          contract_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ]
        }
      }
    },
    methods:{
      open:function(data){
        this.file_name = '';
        data = data || null;
        if(data) this.formData = JSON.parse(JSON.stringify(data));
        else this.formData = JSON.parse(JSON.stringify(formD))
        this.editModal = true;
      },
      close:function(){
        this.editModal = false;
      },
      comData:function(){
        let _this = this;
        this.subLoading = true;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 'comEntrust',data:{fdata:_this.formData}
            }).then(function (res) {
              _this.alertMsg(res.msg,res.status != 1?'error':'');
              if(res.status == 1){
                _this.$emit('addNotify',{data:res.data,is_up:_this.formData.id})
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
      }
    }
  }
</script>
