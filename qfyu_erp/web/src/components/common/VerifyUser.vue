<template>
<div>
    <!-- 验证用户身份 -->
    <Modal v-model="modal" title="用户身份验证" :mask-closable="false" width="350" footer-hide>
        <Form label-position="top">
            <FormItem label="请输入用户编号:">
                <Input type="password" v-model="employee.code" placeholder="用户编号" maxlength="30"></Input>
            </FormItem>
            <FormItem label="请输入用户登录密码:">
                <Input type="password" v-model="employee.upass" placeholder="用户登录密码" maxlength="20"></Input>
            </FormItem>
            <FormItem style="text-align:right;margin-top:20px;">
                <Button type="primary" @click="confirm">确认操作</Button>
                <Button style="margin-left:8px" @click="close">取消</Button>
            </FormItem>
        </Form>
    </Modal>
</div>
</template>
<script>
    import crypto from 'crypto'
    export default {
        props:{
          postCode:{//岗位权限code
            type:String,
            default:''
          },
          processingMethod:{//后台处理方法
            type:String,
            default:''
          },
          paramData:{//额外参数
            type:Object,
            default:()=>{}
          }
        },
        data(){
           return{
              modal:false,
              employee:{code:'',upass:''}
           }
        },
        methods:{
            open:function(){
               this.employee={code:'',upass:''};
               this.modal=true;
            },
            close:function(){
               this.modal=false;
            },
            /**
             * 确认编制人员
             */
            confirm:function(){
                var _this=this;
                if(_this.employee.code.length==0){
                  return _this.alertMsg('请输入身份识别编号','error');
                }
                if(_this.employee.upass.length==0){
                  return _this.alertMsg('请输入用户登录密码','error');
                }
                const md5 = crypto.createHash('md5');
                md5.update(this.common.md5Salt+_this.employee.upass);
                var passwd = md5.digest('hex');
                var data={code:_this.employee.code,upass:passwd,post_code:this.postCode,processing_method:this.processingMethod,param_data:this.paramData};
                _this.common.http({url:'verifyPlan',data:data}).then(function(res){
                    if(res.status==1){
                        _this.$emit("confirm",res.data);
                        _this.close();
                    }
                    if(res.status == 0) _this.alertMsg(res.msg,'error');
                }).catch(function(err) {
                    _this.common.httpErr(err.data,_this);
                });
            }
        }
    }
</script>
<style>
</style>
