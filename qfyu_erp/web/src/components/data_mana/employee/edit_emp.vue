<template>
  <div>
     <Form ref="formEditStaff" :rules="ruleData"  :model="fData" :label-width="90">
        <Row>
          <Col span="8">
           <FormItem label="员工编号:">
             <Input :value="fData.code" maxlength="8" placeholder="自动生成" disabled></Input>
           </FormItem>
           </Col>
           <Col span="8">
             <FormItem label="姓名:" prop="name">
               <Input v-model="fData.name" placeholder="姓名" maxlength="6" clearable></Input>
             </FormItem>
           </Col>
           <Col span="8">
             <FormItem label="身份证号:" prop="card_id">
               <Input v-model="fData.card_id" placeholder="身份证号" maxlength="18" clearable></Input>
             </FormItem>
           </Col>
         </Row>
         <Row>
           <Col span="8">
             <FormItem label="学历:" prop="edu">
               <Select v-model="fData.edu">
                  <Option v-for="(item,index) in eduData" :key="index" :value="index">{{item}}</Option>
               </Select>
             </FormItem>
           </Col>
           <Col span="8">
             <FormItem label="专业:" prop="profess">
               <Input v-model="fData.profess" placeholder="专业" maxlength="10" clearable></Input>
             </FormItem>
           </Col>
           <Col span="8">
              <FormItem label="毕业时间:" prop="grad_date">
                 <DatePicker type="date" placeholder="毕业时间" v-model="fData.grad_date"></DatePicker>
              </FormItem>
           </Col>
         </Row>
         <Row>
           <Col span="8">
             <FormItem label="所在部门:" prop="depart_name">
              <Input readonly :value="fData.depart_name" icon="ios-more" style="cursor: pointer;" @on-click="show_seldep"></Input>
             </FormItem>
           </Col>
           <Col span="8">
             <FormItem label="职务:" prop="duties">
               <Select v-model="fData.duties" filterable allow-create @on-create="handleDuties">
                  <Option v-for="(item,index) in dutiesData" :key="index" :value="item.label">{{item.label}}</Option>
               </Select>
             </FormItem>
           </Col>
           <Col span="8">
             <FormItem label="技术职称:">
               <Input v-model="fData.tech_title" placeholder="技术职称" maxlength="30" clearable></Input>
             </FormItem>
           </Col>
         </Row>
         <Row>
           <Col span="10">
             <FormItem label="执业资格:">
               <Input v-model="fData.seniority" placeholder="执业资格" maxlength="30" clearable></Input>
             </FormItem>
           </Col>
           <Col span="14">
            <FormItem label="执业资格鉴定单位:" :label-width="160">
              <Input v-model="fData.appraisal" placeholder="执业资格鉴定单位" maxlength="50" clearable></Input>
            </FormItem>
           </Col>
         </Row>
         <Row>
           <Col span="8">
             <FormItem label="在职状态:">
               <Select v-model="fData.status">
                  <Option :value='1'>在职</Option>
                  <Option :value='0'>离职</Option>
               </Select>
             </FormItem>
           </Col>
           <Col span="8">
              <FormItem label="入职日期:" prop="entry_date">
                 <DatePicker type="date" placeholder="入职日期" v-model="fData.entry_date"></DatePicker>
              </FormItem>
           </Col>
           <Col span="8">
             <FormItem label="辞退日期:">
                <DatePicker type="date" placeholder="辞退日期" v-model="fData.resign_date"></DatePicker>
             </FormItem>
           </Col>
         </Row>
         <Row>
           <Col span="8">
             <FormItem label="籍贯:" prop="native_place">
               <Input v-model="fData.native_place" placeholder="籍贯" maxlength="30" clearable></Input>
             </FormItem>
           </Col>
           <Col span="8">
            <FormItem label="手机号:" prop="phone">
              <Input maxlength="11" v-model="fData.phone" placeholder="手机号"></Input>
            </FormItem>
           </Col>
           <Col span="8">
            <FormItem label="紧急联络:" prop="urgent_phone">
              <Input v-model="fData.urgent_phone" placeholder="紧急联络方式" maxlength="20" clearable></Input>
            </FormItem>
           </Col>
         </Row>
         <Row>
           <Col span="8">
             <FormItem label="出生年月:">
                <DatePicker type="date" placeholder="出生年月" v-model="fData.birthday_date"></DatePicker>
             </FormItem>
           </Col>
            <Col span="8">
             <FormItem label="提成率:">
                <InputNumber :precision="3" :step="0.01" :max="100" :active-change="false" v-model="fData.comm_rate" placeholder="提成率" maxlength="6" style="width: 166px;"></InputNumber >
             </FormItem>
           </Col>
           <Col span="8">
            <FormItem label="性别:">
               <RadioGroup v-model="fData.sex">
                 <Radio :label='1' checked>男</Radio>
                 <Radio :label='2'>女</Radio>
               </RadioGroup>
            </FormItem>
           </Col>
          </Row>
          <FormItem label="详细地址:">
            <Input v-model="fData.address" placeholder="详细地址" maxlength="50" show-word-limit></Input>
          </FormItem>
          <FormItem label="备注:">
            <Input v-model="fData.remark" placeholder="备注" maxlength="80" show-word-limit></Input>
          </FormItem>
          <FormItem>
            <Button type="primary" :loading="subLoading" @click="handleSubmit">立即提交</Button>
            <Button style="margin-left: 8px" @click="closeModal">取消</Button>
          </FormItem>
     </Form>
     <select-depart ref="seldep" @seldep="select_dep" @clear_sel="clear_sel" :clearKeys="['depart_name','depart_id']"></select-depart>
  </div>
</template>
<script>
  import SelectDepart from '@/components/common/SelectDepart'
    var fData = {id:0, code:'',name: '',card_id:'',sex:1,edu:null,native_place:'',profess:null,birthday_date:null,phone:null,urgent_phone:'',grad_date:null,entry_date:null,resign_date:null,depart_name:'',duties:null,tech_title:'',seniority:'',appraisal:'',comm_rate:null,remark:'',status:1,address:''};
    export default {
      name:'editEmployee',
      components:{SelectDepart},
      props: {
        departData:{
          type:Array,
          default:()=>[]
        },
        eduData:{
          type:Array,
          default:()=>[]
        },
        dutiesData:{
          type:Array,
          default:()=>[]
        }
      },
      data () {
         const validateDate = (rule, value, callback) => {
              if (value) {
                callback();
              } else {
                callback(new Error("不能为空"));
              }
            };
          return {
            fData: JSON.parse(JSON.stringify(fData)),
            ruleData:{
              name: [
                  { required: true, message: '请填写员工姓名', trigger: 'blur' }
              ],
              card_id: [
                  { required: true, message: '请填写身份证号', trigger: 'blur' }
              ],
              depart_name: [
                  { required: true, message: '请选择所在部门', trigger: 'change' }
              ],
              duties: [
                  { required: true, message: '请选择职务', trigger: 'change' }
              ],
              edu: [
                  { required: true,type:'number', message: '请选择学历', trigger: 'change' }
              ],
              grad_date: [
                  { required: true, validator: validateDate, trigger: "change" }
              ],
              entry_date: [
                  { required: true, validator: validateDate, trigger: "change" }
              ],
              native_place: [
                  { required: true, message: '请填写籍贯', trigger: 'blur' }
              ],
              profess: [
                  { required: true, message: '请填写专业', trigger: 'blur' }
              ],
              phone: [
                  { required: true,type: 'string', pattern: /^1[\d+]{10}$/, message: '请填写正确的手机号', trigger: 'blur' }
              ],
              urgent_phone: [
                  { required: true, message: '请填写紧急联系电话', trigger: 'blur' }
              ]
            },
            subLoading:false
          }
      },
      methods:{
        init:function(redata){
          this.fData = JSON.parse(JSON.stringify(fData))
          this.$refs.formEditStaff.resetFields();
          if(redata){
            redata = JSON.parse(JSON.stringify(redata));
            redata.comm_rate = parseFloat(redata.comm_rate);
            redata.phone = redata.phone.toString();
            this.fData = redata;
          }
          this.subLoading = false;
        },
        show_seldep:function () {
          this.$refs.seldep.init();
        },
        select_dep:function (data) {
          this.$set(this.fData,'depart_id',data.id);
          this.$set(this.fData,'depart_name',data.dept_name);
        },
        clear_sel:function (key) {
          this.fData[key]=null;
        },
        handleSubmit:function(){
          let _this = this;
          this.subLoading = true;
          this.$refs.formEditStaff.validate(function(valid){
            if (valid) {
              _this.common.http({
                url: 'comEmployee',data:{fdata:_this.fData}
              }).then(function (res) {
                _this.subLoading = false;
                if(res.status == 1){
                  _this.alertMsg(res.msg);
                  _this.$emit('addEmployeeNotify',{data:res.data,is_up:_this.fData.id})
                }else{
                  _this.alertMsg(res.msg,'error')
                }
              }).catch(function(err){
                _this.common.httpErr(err.data,_this);
              })
            }else _this.subLoading = false;
          })
        },
        handleDuties:function(val){
          let obj = {value: val,label: val};
          this.dutiesData.push(obj);
        },
        closeModal:function(){
          this.$emit('closeModal')
        }
      }
    }
</script>
