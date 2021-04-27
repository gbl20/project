<template>
  <div>
    <Form ref="formEdit" :rules="ruleData"  :model="fData" :label-width="90">
     <FormItem label="选择员工:" prop="emp_id">
       <Select v-model="fData.emp_id" filterable remote :remote-method="remoteMethod" :loading="loading" placeholder="用户编号/姓名" :disabled="isEdit">
          <Option v-for="(option, index) in options" :value="option.value" :key="index">{{option.label}}</Option>
      </Select>
     </FormItem>
     <FormItem label="登录密码:" prop="passwd">
       <Input type="password" v-model="fData.passwd" maxlength="15" placeholder="登录密码"></Input>
     </FormItem>
     <FormItem>
       <Button type="primary" @click="handleSubmit()">立即提交</Button>
       <Button style="margin-left: 8px" @click="closeModal()">取消</Button>
     </FormItem>
    </Form>
  </div>
</template>
<script>
  import crypto from 'crypto'
  var fData = {id:0,emp_id:0,passwd:''};
  export default {
    name:'editOperators',
    data() {
      return {
        fData: JSON.parse(JSON.stringify(fData)),
        loading: false,
        options: [],
        list: [],
        isEdit:false,
        ruleData: {
          emp_id: [
            {required: true,type:'number',min:1, message: '请填写部门名称', trigger: 'change' }
          ],
          passwd: [
            {required: true, message: '请输入6~15位有效的密码', pattern: /^[a-zA-Z0-9]{6,15}$/, trigger: 'blur' }
          ]
        }
      }
    },
    methods:{
      init:function(employeeData,redata){
        this.list = employeeData;
        if(redata){
          this.isEdit = true;
          this.fData = {id:redata.id,emp_id:redata.emp_id,passwd:''};
        }else{
          this.isEdit = false;
          this.fData = JSON.parse(JSON.stringify(fData))
        }
      },
      handleSubmit:function(){
        let _this = this;
        this.$refs.formEdit.validate((valid) => {
          if (valid) {
            const md5 = crypto.createHash('md5')
            md5.update(this.common.md5Salt+this.fData.passwd)
            let passwd = md5.digest('hex')
            this.common.http({
              url: 'editOp',data:{passwd:passwd,emp_id:this.fData.emp_id,id:this.fData.id}
            }).then(function (res) {
              if(res.status == 1){
                _this.alertMsg(res.msg);
                _this.$emit('addOperatorsNotify',{data:res.data,is_up:_this.fData.id})
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
        this.$emit('closeModal',{modal:'modal'})
      },
      remoteMethod:function(query) {
        if (query !== '') {
          this.loading = true;
          setTimeout(() => {
            this.loading = false;
            const list = this.list.map(item => {
              return {
                value: item.id,
                label: item.u_msg
              };
            });
            this.options = list.filter(item => item.label.toLowerCase().indexOf(query.toLowerCase()) > -1);
          }, 200);
        } else {
          this.options = [];
        }
      }
    }
  }
</script>
