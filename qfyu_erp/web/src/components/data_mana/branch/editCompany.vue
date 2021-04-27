<template>
  <div>
     <Form ref="formEdit" :rules="ruleData"  :model="fData" :label-width="90">
        <FormItem label="公司名称:" prop="dept_name">
          <Input v-model="fData.dept_name" placeholder="公司名称" maxlength="30" clearable></Input>
        </FormItem>
        <Row>
         <Col span="8">
          <FormItem label="联系电话:" prop="tel">
            <Input v-model="fData.tel" placeholder="0755-84xxx,135xxx"></Input>
          </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="传真:">
              <Input v-model="fData.tax" placeholder="传真"></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="负责人:" prop="leader">
              <Input v-model="fData.leader" placeholder="负责人" maxlength="10" clearable></Input>
            </FormItem>
           </Col>
        </Row>
        <Row>
         <Col span="12">
          <FormItem :label-width="135" label="营业执照:" prop="business_license">
            <Input v-model="fData.business_license" placeholder="营业执照"></Input>
          </FormItem>
          </Col>
          <Col span="12">
          <FormItem :label-width="135" label="营业执照有效期:" prop="business_license_validity">
            <DatePicker type="date" placeholder="有效期(不选表示永久)" v-model="fData.business_license_validity"></DatePicker>
          </FormItem>
          </Col>
        </Row>
        <Row>
         <Col span="12">
          <FormItem :label-width="135" label="组织机构代码证:">
            <Input v-model="fData.organization" placeholder="组织机构代码证"></Input>
          </FormItem>
          </Col>
          <Col span="12">
          <FormItem :label-width="135" label="代码证有效期:">
            <DatePicker type="date" placeholder="代码证有效期" v-model="fData.organization_validity"></DatePicker>
          </FormItem>
          </Col>
        </Row>
        <Row>
         <Col span="12">
          <FormItem :label-width="135" label="药品经营许可证:">
            <Input v-model="fData.drug_license" placeholder="药品经营许可证"></Input>
          </FormItem>
          </Col>
          <Col span="12">
          <FormItem :label-width="135" label="许可证有效期:">
            <DatePicker type="date" placeholder="许可证有效期" v-model="fData.drug_license_validity"></DatePicker>
          </FormItem>
          </Col>
        </Row>
        <Row>
         <Col span="12">
          <FormItem :label-width="135" label="GSP证书编号:">
            <Input v-model="fData.gsp_license" placeholder="GSP证书编号"></Input>
          </FormItem>
          </Col>
          <Col span="12">
          <FormItem :label-width="135" label="GSP证书有效期:">
            <DatePicker type="date" placeholder="GSP证书有效期" v-model="fData.gsp_license"></DatePicker>
          </FormItem>
          </Col>
        </Row>
        <Row>
         <Col span="8">
          <FormItem label="税务证号:">
            <Input v-model="fData.tax_num" placeholder="税务证号"></Input>
          </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="入网序号:">
              <Input v-model="fData.network_num" placeholder="入网序号" maxlength="10" clearable></Input>
            </FormItem>
          </Col>
          <Col span="8">
           <FormItem label="是否有效:">
               <RadioGroup v-model="fData.status">
                 <Radio :label='1'>有效</Radio>
                 <Radio :label='0'>无效</Radio>
               </RadioGroup>
           </FormItem>
           </Col>
        </Row>
        <FormItem label="公司地址:" prop="address">
          <Input v-model="fData.address" placeholder="公司机构地址" maxlength="18" clearable></Input>
        </FormItem>
        <FormItem>
          <Button type="primary" @click="handleSubmit()">立即提交</Button>
          <Button style="margin-left: 8px" @click="closeModal()">取消</Button>
        </FormItem>
     </Form>
  </div>
</template>
<script>
    var fData = {id:0,dept_name:'',address:'',tel:'',fax:'',leader:'',network_num:'',tax_num:'',business_license:'',business_license_validity:null,organization:'',organization_validity:null,drug_license:'',drug_license_validity:null,gsp_license:'',gsp_license_validity:null,status:1};
    export default {
      name:'editBranch',
      data () {
        return {
          fData: JSON.parse(JSON.stringify(fData)),
          ruleData:{
            dept_name: [
                { required: true, message: '请填写公司名称', trigger: 'blur' }
            ],
            tel: [
                { required: true, message: '请输入公司联系电话', pattern: /^[\d+]{1,}([-]?[,]?[\d+]{1,})*$/, trigger: 'blur' }
            ],
            leader: [
                { required: true, message: '请输入公司负责人', trigger: 'blur' }
            ],
            address: [
                { required: true, message: '请输入公司机构地址', trigger: 'blur' }
            ],
            business_license: [
                { required: true, message: '请输入营业执照', trigger: 'blur' }
            ]
          }
        }
      },
      methods:{
        init:function(companyData){
          this.$refs.formEdit.resetFields();
          if(companyData) this.fData = JSON.parse(JSON.stringify(companyData))
          else this.fData = JSON.parse(JSON.stringify(fData))
        },
        handleSubmit:function(){
          let _this = this;
          this.$refs.formEdit.validate((valid) => {
            if (valid) {
              this.common.http({
                url: 'addCompany',data:{fdata:this.fData}
              }).then(function (res) {
                if(res.status == 1){
                  _this.alertMsg(res.msg);
                  _this.$emit('addCompanyNotify',{data:res.data,is_up:_this.fData.id})
                }else{
                 _this.alertMsg(res.msg,'error')
                }
              }).catch(function(err){
                _this.common.httpErr(err.data,_this);
              })
            }
          })
        },
        closeModal:function(){
          _this.$emit('closeModal',{modal:'modal1'})
        }
      }
    }
</script>
