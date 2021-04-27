<template>
  <div>
    <Form ref="formEdit" :rules="ruleData"  :model="fData" :label-width="90">
     <FormItem label="角色名称:" prop="title">
       <Input v-model="fData.title" maxlength="10" placeholder="角色名称"></Input>
     </FormItem>
     <FormItem>
       <Button type="primary" @click="handleSubmit()">立即提交</Button>
       <Button style="margin-left: 8px" @click="closeModal()">取消</Button>
     </FormItem>
    </Form>
  </div>
</template>
<script>
  var fData = {id:0,title:''};
  export default {
    name:'editRole',
    data() {
      return {
        fData: JSON.parse(JSON.stringify(fData)),
        ruleData: {
          title: [
            {required: true, message: '请输入角色名称', pattern: /[\u4e00-\u9fa5]{1,10}/, trigger: 'blur' }
          ]
        }
      }
    },
    methods:{
      init:function(redata){
        if(redata) this.fData = {id:redata.id,title:redata.title};
        else this.fData = JSON.parse(JSON.stringify(fData))
      },
      handleSubmit:function(){
        let _this = this;
        this.$refs.formEdit.validate((valid) => {
          if (valid) {
            this.common.http({
              url: 'editRole',data:{title:this.fData.title,id:this.fData.id}
            }).then(function (res) {
              if(res.status == 1){
                _this.alertMsg(res.msg);
                _this.$emit('addRoleNotify',{data:res.data,is_up:_this.fData.id})
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
        this.$emit('closeModal',{modal:'modal1'})
      }
    }
  }
</script>
