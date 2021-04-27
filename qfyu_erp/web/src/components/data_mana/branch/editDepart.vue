<template>
  <div>
     <Form ref="formEdit" :rules="ruleData"  :model="fData" :label-width="90">
         <FormItem label="所属公司:">
           <Select v-model="fData.branch_id">
              <Option v-for="(item,index) in company" :key="index" :value="item.id">{{item.dept_name}}</Option>
           </Select>
         </FormItem>
         <FormItem label="部门名称:" prop="dept_name">
           <Input v-model="fData.dept_name" placeholder="部门名称"></Input>
         </FormItem>
         <FormItem label="地址:">
           <Input v-model="fData.address" placeholder="地址"></Input>
         </FormItem>
         <FormItem label="电话:" prop="tel">
           <Input v-model="fData.tel" placeholder="电话"></Input>
         </FormItem>
         <FormItem label="传真:">
           <Input v-model="fData.fax" placeholder="传真"></Input>
         </FormItem>
         <FormItem label="负责人:" prop="leader">
           <Input v-model="fData.leader" placeholder="负责人"></Input>
         </FormItem>
         <FormItem label="是否有效:">
             <RadioGroup v-model="fData.status">
               <Radio :label='1'>有效</Radio>
               <Radio :label='0'>无效</Radio>
             </RadioGroup>
         </FormItem>
        <FormItem>
          <Button type="primary" @click="handleSubmit()">立即提交</Button>
          <Button style="margin-left: 8px" @click="closeModal()">取消</Button>
        </FormItem>
     </Form>
  </div>
</template>
<script>
    var fData = {id:0,branch_id:1,dept_name:'',address:'',tel:'',fax:'',leader:'',status:1};
    export default {
      name:'editDepart',
      props: {
        company:{
           type:Array,
           default:()=>[]
        },
        chooseId:{
           type:Number,
           default:0
        }
      },
      data () {
          return {
            fData:JSON.parse(JSON.stringify(fData)),
            ruleData:{
              dept_name: [
                  { required: true, message: '请填写部门名称', trigger: 'blur' }
              ],
              tel: [
                  { required: true, message: '请输入部门联系电话', pattern: /^[\d+]{1,}([-]?[,]?[\d+]{1,})*$/, trigger: 'blur' }
              ],
              leader: [
                  { required: true, message: '请输入部门负责人', trigger: 'blur' }
              ]
            }
          }
      },
      mounted:function(){
        this.fData.branch_id = this.chooseId;
      },
      watch:{
        chooseId(val){
          this.fData.branch_id = val;
        }
      },
      methods:{
        init:function(departData){
          this.$refs.formEdit.resetFields();
          if(departData) this.fData = JSON.parse(JSON.stringify(departData))
          else this.fData = JSON.parse(JSON.stringify(fData))
          this.fData.branch_id = this.chooseId;
        },
        handleSubmit:function(){
          let _this = this;
          this.$refs.formEdit.validate((valid) => {
            if (valid) {
              this.common.http({
                url: 'comDepart',data:{fdata:this.fData}
              }).then(function (res) {
                if(res.status == 1){
                  _this.alertMsg(res.msg);
                  _this.$emit('addDepartNotify',{data:res.data,is_up:_this.fData.id})
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
          _this.$emit('closeModal',{modal:'modal2'})
        }
      }
    }
</script>
