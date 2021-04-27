<template>
  <div>
      <div class="table-m-records">
        <div class="table-m">
          <Table size="small" border stripe :columns="columns" :rowClassName="rowClassName" @on-row-click="rowClick" :data="data" :width="620" :loading="loading" :highlight-row="true" :height="height"></Table>
        </div>
        <div class="visit-m">
          <div class="title">*洽谈内容</div>
          <div class="visit-content border-class" :style="'height:'+(height-30)+'px'">
             <div class="c-details" v-if="checkIndex!=-1">{{this.data[this.checkIndex].content}}</div>
          </div>
        </div>
        <div class="right-btn">
          <Button class="edit-btn" @click="addEdit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button class="edit-btn" @click="addEdit(1)" :disabled="checkIndex==-1"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button class="edit-btn"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </div>
      </div>
      <Modal v-model="editModal" :title="'业务联系记录-'+(formData.id?'修改':'新增')" width="518" :closable="false" :mask-closable="false" footer-hide>
        <Form ref="formRef" :rules="ruleVal" :model="formData" :label-width="110">
          <Row>
            <Col span="12">
              <FormItem label="联系日期：" prop="f_date">
                <DatePicker type="date" v-model="formData.f_date" placeholder="联系日期" format="yyyy-MM-dd"></DatePicker>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="我方洽谈人：" prop="emp_code">
                 <Input icon="ios-more" readonly class="right" v-model="formData.emp_code" @on-click="chooseEmp"></Input>
              </FormItem>
            </Col>
          </Row>
          <FormItem label="洽谈主题：">
            <Input v-model="formData.subject" maxlength="50"></Input>
          </FormItem>
          <FormItem label="方式/地点：">
            <Input v-model="formData.visit_place" maxlength="100"></Input>
          </FormItem>
          <FormItem label="对方洽谈人：">
            <Input v-model="formData.visit_man" maxlength="10"></Input>
          </FormItem>
          <FormItem label="洽谈内容：">
            <Input type="textarea" maxlength="2000" show-word-limit v-model="formData.content" :autosize="{minRows:3,maxRows: 3}"></Input>
          </FormItem>
          <Divider/>
          <Row>
            <div style="float: right;">
              <Button type="text" @click="editModal = false">取消</Button>
              <Button type="primary" :loading="subLoading" @click="comData">确定</Button>
            </div>
          </Row>
        </Form>
      </Modal>
      <select-employee ref="selectEmployeeRef" @selemp="confirmEmployee" ></select-employee>
  </div>
</template>

<script>
  import selectEmployee from '@/components/common/SelectEmployee'
  var fData = {id:0,f_date:'',emp_code:null,subject:'',supplier_code:'',visit_man:'',visit_place:'',content:''};
  export default{
    name :'varieties',
    components:{selectEmployee},
    props: {
      height:{
        type:Number,
        default:0
      },
      supplierCode:{
        type:String,
        default:''
      }
    },
    data:function(){
      return {
        editModal:false,
        loading:false,
        columns:[
         { title: "联系日期",key: "f_date",width: 100,align: "center"},
         { title: "洽谈主题",key: "subject",resizable: true,width: 140,tooltip:true,align: "center"},
         { title: "对方洽谈负责人",key: "visit_man",resizable: true,width: 120,align: "center"},
         { title: "洽谈方式或地点",key: "visit_place",width: 158,align: "center",resizable: true},
         { title: "我方洽谈人",key: "emp_code",width: 100,align: "center",resizable: true}
        ],
        data:[],
        subLoading:false,
        formData:JSON.parse(JSON.stringify(fData)),
        ruleVal:{
          f_date:[
            {required:true,type:'date', message:'请选择联系日期',trigger:'change'}
          ],
          emp_code:[
            {required:true, message:'请选择我方洽谈人',trigger:'change'}
          ],
        },
        checkIndex:-1
      }
    },
    watch:{
      supplierCode(){
        if(this.supplierCode.length > 0) this.init();
      }
    },
    mounted() {
      if(this.supplierCode.length > 0) this.init();
    },
    methods:{
      init:function(){
        let _this = this;
        _this.loading = true;
        _this.common.http({url:'getRecords',data:{supplier_code:this.supplierCode}}).then(function(res){
          if(res.status==1)  _this.data = res.data;
          _this.$nextTick(function(){
             _this.loading = false;
             if(res.status==1) _this.checkIndex = 0;
             else{
               _this.checkIndex = -1;
               _this.data = [];
             }
          })
        }).catch(function(err){
             _this.common.httpErr(err.data,_this);
        });
      },
      rowClassName(row, index) {
          if (index === this.checkIndex) {
            return 'ivu-table-row-highlight';
          }
          return '';
      },
      comData:function(){
        let _this = this;
        if(this.supplierCode.length < 0) return false;
        this.subLoading = true;
        this.formData.supplier_code = this.supplierCode;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 'saveRecords',data:{fdata:_this.formData}
            }).then(function (res) {
               _this.alertMsg(res.msg,res.status != 1?'error':'');
               if(res.status == 1){
                 if(_this.formData.id) _this.$set(_this.data, _this.checkIndex, res.data)
                 else{
                   _this.data.unshift(res.data)
                   _this.checkIndex = 0;
                 }
                 _this.editModal = false;
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
      },
      rowClick:function(item,index){
        this.checkIndex = index;
      },
      addEdit:function(type){
        if(type){
          if(this.checkIndex != -1){
            const NewData = JSON.parse(JSON.stringify(this.data[this.checkIndex]));
            this.formData = NewData;
          }else{
            return this.alertMsg('请选择需要修改的信息','error')
          }
        }else this.formData = JSON.parse(JSON.stringify(fData));
        this.editModal = true;
      },
      chooseEmp:function(){
        this.$refs.selectEmployeeRef.init({show_self:1});
      },
      confirmEmployee:function(e){
        this.formData.emp_code = e.code;
      }
    }
  }
</script>
<style lang="less">
  .table-m-records{
    position: relative;padding:0 87px 0 630px;
    .table-m{
      position: absolute; left: 0; top: 0; bottom: 0;
    }
    .visit-m{
      .title{
        height: 30px;line-height: 30px;font-size: 13px;
      }
      .visit-content{
        font-size: 13px;line-height: 22px;padding:10px;
        .c-details{
          height: 100%;overflow-y: auto;
        }
      }
    }
    .right-btn{
      width: 77px; position: absolute; right: 0; top: 0; bottom: 0;
      .edit-btn{
        margin-bottom:10px;
      }
    }
  }
</style>
