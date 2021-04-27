<template>
<div>
   <Modal v-model="editModal" title="销售合同" width="620" :mask-closable="false" footer-hide>
      <Form ref="formRef" :label-width="90" :rules="ruleVal" :model="formData" label-position="right">
        <FormItem label="合同标题" prop="title">
          <Input placeholder="合同标题" v-model="formData.title" maxlength="200" ></Input>
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem label="合同编号">
              <Input placeholder="合同号(自动生成)" v-model="formData.contract_no" disabled></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="生效日期">
              <DatePicker type="date" :editable="false" placeholder="生效日期" v-model="formData.start_date" ></DatePicker>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="客户" class="sup_sel" prop="cust_code">
              <Row>
                <Col span="8"><Input disabled v-model="formData.cust_code"></Input></Col>
                <Col span="16"><Input icon="ios-more" @on-click="clickSelCustmoer" readonly v-model="formData.cust_name" ></Input></Col>
              </Row>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="结算方式">
              <Select v-model="formData.settlement" >
                <Option v-for="(item,key) in settlement" :value="key" :key="key">{{item}} ( {{key}} )</Option>
              </Select>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="签约日期">
              <DatePicker type="date" :editable="false" placeholder="签约日期" v-model="formData.sign_date" ></DatePicker>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="失效日期">
              <DatePicker type="date" :editable="false" placeholder="失效日期" v-model="formData.validity_date" ></DatePicker>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="签约人" class="sup_sel" prop="sign_code">
              <Row>
                <Col span="8"><Input disabled v-model="formData.sign_code"></Input></Col>
                <Col span="16"><Input icon="ios-more" @on-click="clickSelEmployee" readonly v-model="formData.sign_name" ></Input></Col>
              </Row>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="付款日期">
              <DatePicker type="date" :editable="false" placeholder="付款日期" v-model="formData.pay_date" ></DatePicker>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <FormItem label="合同文件" prop="file_path">
            <Row>
              <Col span="5">
                <upload action="s/upSalesContract" :maxSize="10240" :formatArr="formatArr" @upSuccess="upSuccess" @upProgress="upProgress"></upload>
                <a :href="baseUrl+'/template_file/商品购销合同模板.docx'">下载模板</a>
              </Col>
              <Col span="19">
                <div v-if="file_name!=''" class="bg-text italic-style">
                  {{file_name}}
                  <span class="success-text" style="font-size: 12px;padding-left: 10px;">上传成功</span>
                </div>
                <Input :value="formData.file_path" v-show="false"></Input>
              </Col>
            </Row>
          </FormItem>
        </Row>
        <FormItem label="交货地点">
          <Input placeholder="交货地点" maxlength="100" v-model="formData.delivery" ></Input>
        </FormItem>
        <FormItem label="签约地点">
          <Input placeholder="签约地点" maxlength="200" v-model="formData.sign_area" ></Input>
        </FormItem>
        <FormItem label="备注说明">
          <Input placeholder="备注说明" maxlength="200" v-model="formData.explain" ></Input>
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem label="创建日期">
              <Input disabled :value="formData.create_date"></Input>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="创建人">
              <Input disabled :value="formData.creator"></Input>
            </FormItem>
          </Col>
        </Row>
        <Divider/>
        <Row>
          <div style="float: right;">
            <Button type="text" @click="editModal = false">取消</Button>
            <Button type="primary" :loading="subLoading" @click="comData">保存</Button>
          </div>
        </Row>
   </Form>
  </Modal>
  <select-customer ref="chooseCustomerRef" @selcust="confirmCustomer"></select-customer>
  <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
</div>
</template>
<script>
  import selectCustomer from '@/components/common/SelectCustomer'
  import selectEmployee from '@/components/common/SelectEmployee'
  import upload from '@/components/public/upload.vue'
  var formD = {contract_no:'',title:'',settlement:'',cust_code:'',cust_name:'',start_date:'',sign_date:'',validity_date:'',sign_code:'',sign_name:'',explain:'',pay_date:'',delivery:'',sign_area:'',creator:'',create_date:'',file_path:''};
  export default {
    components:{selectCustomer,selectEmployee,upload},
    props: {
      settlement:{
        type:Array,
        default:()=>[]
      }
    },
    data(){
      return {
        editModal:false,
        formatArr:['doc','docx','pdf','docm','dot','dotm','dotx'],
        isedit:false,
        subLoading:false,
        height:0,
        Breadcrumb:[{title:'销售管理'},{title:'销售合同',url:'contractList'},{title:'新建合同'}],
        formData:JSON.parse(JSON.stringify(formD)),
        ruleVal:{
          file_path:[
            {required:true, message:'请上传合同附件',trigger:'change'}
          ],
          title:[
            {required:true, message:'请输入合同标题',trigger:'blur'}
          ],
          cust_code:[
            {required:true, message:'请选择客户',trigger:'change'}
          ],
          sign_code:[
            {required:true, message:'请选择签约人',trigger:'change'}
          ],
        },
        file_name:'',
        baseUrl:this.common.BASE_URL
      }
    },
    methods:{
      DHeight(e){
         this.height = e;
      },
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
      upSuccess:function(e){
        this.formData.file_path = e.imgUrl
        this.file_name = e.file_name;
      },
      upProgress:function(e){
        console.log(e)
      },
      clickSelCustmoer:function(){
        this.$refs.chooseCustomerRef.init()
      },
      confirmCustomer:function(e){
        this.formData.cust_code = e.id;
        this.formData.cust_name = e.name;
      },
      clickSelEmployee:function(){
        this.$refs.chooseEmployeeRef.init();
      },
      confirmEmployee:function(data){
        this.formData.sign_code=data.code;
        this.formData.sign_name=data.name;
      },
      comData:function(){
        let _this = this;
        this.subLoading = true;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 's/comSalesContract',data:{fdata:_this.formData}
            }).then(function (res) {
              _this.alertMsg(res.msg,res.status != 1?'error':'');
              if(res.status == 1){
                _this.$emit('addNotify',{data:res.data,is_up:_this.formData.contract_no})
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
