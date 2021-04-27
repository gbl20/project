<template>
  <div>
    <Form :model="examData" :label-width="90" :disabled="isDisabled">
      <div style="width: 440px;">
        <FormItem label="采购负责人意见">
          <Input type="textarea" v-model="examData.buyer_reason" maxlength="30" show-word-limit :autosize="{minRows:2,maxRows:2}"></Input>
        </FormItem>
        <FormItem label="采购负责人">
          <Row>
            <Col span="8"><Input v-model="examData.buyer_code" disabled></Input></Col>
            <Col span="1">&nbsp;</Col>
            <Col span="8"> <Button type="primary" @click="checkAlert('buyer_code','buyer_reason','purch_depart')">审批订单</Button></Col>
          </Row>
        </FormItem>
        <FormItem label="审批时间">
          <Row>
            <Col span="15">
             <DatePicker type="datetime" disabled v-model="examData.buyer_date"></DatePicker>
            </Col>
            <Col span="1">&nbsp;</Col>
            <Col span="8">
              <div class="exam-status" :class="examData.buyer_status==1?'success-bg-text':(examData.buyer_status==2?'error-bg-text':'warning-bg-text')">{{examData.buyer_status==0?'未审批':(examData.buyer_status==1?'审批通过':'审批未通过')}}</div>
            </Col>
          </Row>
        </FormItem>
        <Divider />
        <FormItem label="质量管理部负责人意见">
          <Input type="textarea" v-model="examData.qa_reason" maxlength="30" show-word-limit :autosize="{minRows:2,maxRows:2}"></Input>
        </FormItem>
        <FormItem label="质量管理部负责人">
          <Row>
            <Col span="8"><Input v-model="examData.qa_code" disabled></Input></Col>
            <Col span="1">&nbsp;</Col>
            <Col span="8"><Button type="primary" @click="checkAlert('qa_code','qa_reason','quality_depart')">审批订单</Button></Col>
          </Row>
        </FormItem>
        <FormItem label="审批时间">
          <Row>
            <Col span="15">
              <DatePicker type="datetime" v-model="examData.qa_date" disabled></DatePicker>
            </Col>
            <Col span="1">&nbsp;</Col>
            <Col span="8">
              <div class="exam-status" :class="examData.qa_status==1?'success-bg-text':(examData.qa_status==2?'error-bg-text':'warning-bg-text')">
                {{examData.qa_status==0?'未审批':(examData.qa_status==1?'审批通过':'审批不通过')}}
              </div>
            </Col>
          </Row>
        </FormItem>
        <Divider />
        <FormItem label="质量负责人意见">
          <Input type="textarea" :disabled="false" v-model="examData.principal_reason" maxlength="30" show-word-limit :autosize="{minRows:3,maxRows:3}"></Input>
        </FormItem>
        <FormItem label="质量负责责人">
          <Row>
            <Col span="8"><Input disabled v-model="examData.principal_code"></Input></Col>
            <Col span="1">&nbsp;</Col>
            <Col span="8"><Button type="primary" @click="checkAlert('principal_code','principal_reason','quality_director')">审批订单</Button></Col>
          </Row>
        </FormItem>
        <FormItem label="审批时间">
          <Row>
            <Col span="15">
              <DatePicker disabled type="datetime" v-model="examData.principal_date"></DatePicker>
            </Col>
            <Col span="1">&nbsp;</Col>
            <Col span="8">
              <div class="exam-status" :class="examData.principal_status==1?'success-bg-text':(examData.principal_status==2?'error-bg-text':'warning-bg-text')">
                {{examData.principal_status==0?'未审批':(examData.principal_status==1?'审批通过':'审批不通过')}}
              </div>
            </Col>
          </Row>
        </FormItem>
      </div>
      <Modal v-model="authM" title="用户身份验证"  width="350">
        <Form ref="refAdmin" :model="userData" label-position="top">
          <FormItem label="请输入用户编号">
            <Input v-model="userData.code"></Input>
          </FormItem>
          <FormItem label="请输入用户登录密码">
            <Input type="password" v-model="userData.pass"></Input>
          </FormItem>
          <FormItem label="审批状态">
            <RadioGroup v-model="userData.status">
              <Radio :label="1">审批通过</Radio>
              <Radio :label="2">审批不通过</Radio>
            </RadioGroup>
          </FormItem>
        </Form>
        <div slot="footer">
          <Button @click="approval(false)">取消</Button>
          <Button type="primary" @click="approval(true)">确定</Button>
        </div>
      </Modal>
    </Form>
  </div>
</template>
<script>
  import crypto from 'crypto'
  var examDatas = {buyer_code:'', buyer_date:null, buyer_reason:'', buyer_status:0, principal_code:'', principal_date:null, principal_reason:'', principal_status:0, qa_code:'', qa_date:null, qa_reason:'', qa_status: 0};
  export default {
    name:'authentication',
    props: {
      type:{
        type:Number,
        default:1
      },
      isDisabled:{
        type:Boolean,
        default:false
      },
      orderid:{
        type:String,
        default:''
      },
      examData:{
        type:Object,
        default:JSON.parse(JSON.stringify(examDatas))
      }
    },
    data: function() {
      return {
        authM:false,
        userData: {name:'',code:'',pass:'',status:1,remark:'',exam_type:''}
      }
    },
    watch:{
      examData(e){
        if(e == null) this.examData = JSON.parse(JSON.stringify(examDatas))
      }
    },
    mounted(){
      if(this.examData == null) this.examData = JSON.parse(JSON.stringify(examDatas))
    },
    methods:{
      checkAlert:function(name,remark,examType){
        this.userData.name = name;
        this.userData.remark = this.examData[remark];
        this.userData.exam_type = examType;
        this.authM = true;
      },
      approval:function(type){
        var _this = this;
        if (!type){
          this.authM = false;
          return false;
        }
        if (this.userData.name==='principal_code' &&this.userData.status===1){
          this.$Modal.confirm({
            title: '提示信息',
            content: '<p>质量负责人审批后，意味着本首营品种被最终批准，将不能再还原修改本资料。确定要继续吗?</p>',
            onOk: () => {
              _this.adminCheck();
            }
          });
        }else{
          _this.adminCheck();
        }
      },
      adminCheck:function(){
        var _this = this;
        var obj = this.userData;
        const md5 = crypto.createHash('md5');
        md5.update(this.common.md5Salt+obj.pass);
        var passwd = md5.digest('hex');

        if (obj.code==''){ return this.alertMsg('请输入身份识别编号','error')}
        var object = {code:obj.code,pwd:passwd,name:obj.name,exam_type:obj.exam_type,orderid:this.orderid,status:obj.status,reason:obj.remark,type:this.type}
        _this.common.http({
          url:'approvalProExam',
          data:object
        }).then(function(e){
          if (e.status){
            _this.alertMsg(e.msg)
            _this.$emit('adminCheckSuccess')
            _this.authM = false;
          }else{
            _this.userData.pass = null;
            _this.alertMsg(e.msg,'error')
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
    }
  }
</script>
<style lang="less">
  .exam-status{
    text-align: center;border-radius: 4px;
  }
</style>
