<template>
  <div>
    <div class="table-m-bot">
      <Table size="small" border stripe :columns="columns" :rowClassName="rowClassName" @on-row-click="rowClick" :data="data" :loading="loading" :highlight-row="true" :height="height">
        <template slot-scope="{ row }" slot="exam_status">
          <div :class="row.exam_status==1?'success-bg-text':'warning-bg-text'">
            {{row.exam_status==1?'合格':'未审核'}}
          </div>
        </template>
         <template slot-scope="{ row }" slot="is_default">
          <Checkbox :value="row.is_default" :true-value="1" :false-value="0" disabled label=""></Checkbox>
        </template>
      </Table>
      <div class="right-btn">
        <Button class="edit-btn" @click="addEdit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
        <Button class="edit-btn" @click="addEdit(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
        <Button class="edit-btn"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        <Button @click="setDefault">设为默认</Button>
      </div>
    </div>
    <Modal v-model="editModal" title="供方销售人员(联系人)管理" width="720" :closable="false" :mask-closable="false" footer-hide>
        <Form ref="formRef" :rules="ruleVal" :model="formData" :label-width="80">
            <Row>
              <Col span="8">
                <FormItem label="姓名：" prop="user_name">
                  <Input v-model="formData.user_name" maxlength="10"></Input>
                </FormItem>
                <FormItem label="身份证：" prop="id_card">
                  <Input v-model="formData.id_card" maxlength="20"></Input>
                </FormItem>
                <FormItem label="性别：">
                  <RadioGroup v-model="formData.sex">
                    <Radio :label='1' checked>男</Radio>
                    <Radio :label='2'>女</Radio>
                  </RadioGroup>
                </FormItem>
                <FormItem label="部门：">
                  <Input v-model="formData.depart" maxlength="30"></Input>
                </FormItem>
                <FormItem label="职务：">
                  <Input v-model="formData.duties" maxlength="30"></Input>
                </FormItem>
                <FormItem label="电话：">
                  <Input v-model="formData.tel" maxlength="50"></Input>
                </FormItem>
                <FormItem label="手机：">
                  <Input v-model="formData.phone" maxlength="11"></Input>
                </FormItem>
                <FormItem label="QQ：">
                  <Input v-model="formData.qq" maxlength="15"></Input>
                </FormItem>
                <FormItem label="创建人：">
                  <Input v-model="formData.creator" disabled></Input>
                </FormItem>
                <FormItem label="创建日期：">
                  <Input v-model="formData.create_date" disabled></Input>
                </FormItem>
              </Col>
              <Col span="16">
                <div class="border-r-msg">
                  <Row>
                    <Col span="18">
                      <FormItem label="委托书编号：" :label-width="120">
                        <Input v-model="formData.attorney_no" maxlength="30"></Input>
                      </FormItem>
                    </Col>
                    <Col span="6">
                      <FormItem label="" :label-width="10">
                        <Checkbox v-model="formData.status" :true-value="1" :false-value="0">资料有效</Checkbox>
                      </FormItem>
                    </Col>
                  </Row>
                  <FormItem label="委托书授权内容：" :label-width="120">
                     <Input type="textarea" maxlength="2000" show-word-limit v-model="formData.content_power" :autosize="{minRows:2,maxRows: 2}"></Input>
                  </FormItem>
                  <Row>
                    <Col span="16">
                      <FormItem label="委托书有效期：" :label-width="120">
                        <DatePicker type="date" transfer :value="formData.validity_date" format="yyyy-MM-dd" @on-change="changeValidityDate"></DatePicker>
                      </FormItem>
                    </Col>
                    <Col span="8">
                      <FormItem label="" :label-width="10">
                        <Checkbox v-model="formData.attorney_validity" :true-value="0" :false-value="1" disabled>委托书已失效</Checkbox>
                      </FormItem>
                    </Col>
                  </Row>
                  <FormItem label="" :label-width="120">
                    <div class="tip-msg">*提示：修改以上资料审核合格将失效。</div>
                  </FormItem>
                  <Row>
                    <Col span="13">
                      <FormItem label="采购部负责人：" :label-width="120">
                        <Input icon="md-checkmark" v-model="formData.purcher" readonly @on-click="chooseOp('purch_depart')" style="cursor:pointer;" :disabled="!formData.id"></Input>
                      </FormItem>
                    </Col>
                    <Col span="11">
                      <FormItem label="审核日期：">
                        <DatePicker type="date" disabled transfer v-model="formData.purch_exam_date" format="yyyy-MM-dd"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="13">
                      <FormItem label="质量管理部负责人：" :label-width="120">
                        <Input icon="md-checkmark" v-model="formData.qcer" readonly @on-click="chooseOp('quality_depart')" style="cursor:pointer;" :disabled="!formData.id"></Input>
                      </FormItem>
                    </Col>
                    <Col span="11">
                      <FormItem label="审核日期：">
                        <DatePicker type="date" disabled transfer v-model="formData.qc_exam_date" format="yyyy-MM-dd"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="13">
                      <FormItem label="质量负责人：" :label-width="120">
                        <Input icon="md-checkmark" v-model="formData.qualityer" readonly @on-click="chooseOp('quality_director')" style="cursor:pointer;" :disabled="!formData.id"></Input>
                      </FormItem>
                    </Col>
                    <Col span="11">
                      <FormItem label="审核日期：">
                        <DatePicker type="date" disabled transfer v-model="formData.quality_exam_date" format="yyyy-MM-dd"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="13">
                      <FormItem label="" :label-width="120">
                        <Checkbox v-model="formData.exam_status" :true-value="1" :false-value="0" disabled>已审核合格</Checkbox>
                      </FormItem>
                    </Col>
                    <Col span="11">
                      <FormItem label="" :label-width="10">
                        <div class="tip-msg" style="line-height: 20px;">*审核合格的是“供方销售人员”，未审核的是“联系人”。</div>
                      </FormItem>
                    </Col>
                  </Row>
                </div>
              </Col>
            </Row>
            <FormItem label="住址：">
              <Input v-model="formData.address" maxlength="50" show-word-limit></Input>
            </FormItem>
            <FormItem label="备注：">
              <Input v-model="formData.remark" maxlength="100" show-word-limit></Input>
            </FormItem>
            <Divider/>
            <Row>
              <div style="float: right;">
                  <Button type="text" @click="cancelCom">取消</Button>
                  <Button type="primary" :loading="subLoading" @click="comData">确定</Button>
              </div>
            </Row>
          </Form>
     </Modal>
     <verify-user ref="verifyUserRef" :postCode="postCode" :paramData="{id:formData.id}" processingMethod="examContact" @confirm="confirmOp"></verify-user>
  </div>
</template>

<script>
  import verifyUser from '@/components/common/VerifyUser'
  var fData = {id:0,supplier_code:'',user_name:'',sex:1,id_card:'',depart:'',duties:'',tel:'',phone:null,qq:null,attorney_no:'',status:1,content_power:'',validity_date:null,attorney_validity:1,address:'',remark:'',creator:'',create_date:null,purcher:'',purch_exam_date:null,qualityer:'',quality_exam_date:null,qcer:'',qc_exam_date:null,exam_status:0};
  export default{
    name :'contacts',
    components:{verifyUser},
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
           { title: "供应商编号",key: "supplier_code",resizable: true,width: 120,align: "center"},
           { title: "姓名",key: "user_name",resizable: true,width: 120,align: "center"},
           { title: "身份证号",key: "id_card",resizable: true,width: 180,tooltip:true,align: "center"},
           { title: "性别",solt: "sex",width: 80,align: "center",render(e,val){return e('div',{},val.row.sex==1?'男':'女')}},
           { title: "部门",key: "depart",resizable: true,width:100,align: "center"},
           { title: "职务",key: "duties",resizable: true,width:100,align: "center"},
           { title: "地址",key: "address",resizable: true,width: 150,align: "left"},
           { title: "电话",key: "tel",resizable: true,width: 100,align: "center"},
           { title: "手机",key: "phone",resizable: true,width: 100,align: "center"},
           { title: "QQ",key: "qq",resizable: true,width: 100,align: "center"},
           { title: "Email",key: "seniority",resizable: true,width: 100,align: "center"},
           { title: "备注",key: "edu",resizable: true,width: 100,tooltip:true,align: "center"},
           { title: "资料是否有效",key: "status",resizable: true,width: 120,align: "center",render(e,val){return e('div',{},val.row.status==1?'有效':'无效')}},
           { title: "委托书编号",key: "attorney_no",resizable: true,width: 120,align: "center"},
           { title: "委托书有效内容",key: "content_power",resizable: true,width: 150,tooltip:true,align: "center"},
           { title: "委托书有效期",key: "validity_date",resizable: true,width: 150,align: "center"},
           { title: "委托书是否有效",key: "attorney_validity",resizable: true,width: 150,align: "center",render(e,val){return e('div',{},val.row.attorney_validity==1?'有效':'无效')}},
           { title: "创建者",key: "creator",resizable: true,width: 120,align: "center"},
           { title: "创建时间",key: "create_date",resizable: true,width: 150,align: "center"},
           { title: "采购部负责人姓名",key: "purcher",resizable: true,width: 200,align: "center"},
           { title: "采购部负责人审核时间",key: "purch_exam_date",resizable: true,width: 200,align: "center"},
           { title: "质量管理部负责人",key: "qcer",resizable: true,width: 200,align: "center"},
           { title: "质量管理部负责人审核时间",key: "qc_exam_date",resizable: true,width: 200,align: "center"},
           { title: "质量负责人",key: "qualityer",resizable: true,width: 150,align: "center"},
           { title: "质量负责人审核时间",key: "quality_exam_date",resizable: true,width: 200,align: "center"},
           { title: "是否合格",slot:"exam_status",resizable: true,width: 85,align: "center",fixed:'right'},
           { title: "默认",slot:"is_default",resizable: true,width: 40,align: "center",fixed:'right'},
         ],
         data:[],
         subLoading:false,
         checkIndex:-1,
         postCode:'',
         formData:JSON.parse(JSON.stringify(fData)),
         ruleVal:{
           user_name:[
             {required:true, message:'请输入联系人姓名',trigger:'blur'}
           ],
           id_card:[
             {required:true,message:'请输入有效的联系人身份证号',trigger:'blur'}
           ]
         },
         isCancleBtn:false
      }
    },
    computed:{
      clearExamData(){
        const data = [this.formData.id,this.formData.attorney_no,this.formData.status,this.formData.content_power]
        return {...data};
      }
    },
    watch:{
      clearExamData(val,reVal){
        if(val[0] > 0 && val[0] == reVal[0] && this.formData.exam_status){
          this.changeExamStatus();
        }
      },
      editModal(e){
        if(!e) this.formData = JSON.parse(JSON.stringify(fData));
      },
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
        _this.common.http({url:'getProSales',data:{supplier_code:this.supplierCode}}).then(function(res){
            if(res.status==1){
              _this.data = res.data;
            }else{
              _this.data = [];
            }
            _this.$nextTick(function(){
               _this.loading = false;
               if(res.status==1) _this.checkIndex = 0;
               else  _this.checkIndex = -1;
            })
        }).catch(function(err){
             _this.common.httpErr(err.data,_this);
        });
      },
      changeValidityDate:function(e){
        if(this.formData.exam_status && this.formData.validity_date != e){
          this.formData.validity_date = e
          this.changeExamStatus();
        }
      },
      changeExamStatus:function(){
        this.$Modal.warning({
          title: '提示',
          content: '因委托书相关内容已修改，三审核内容被删除，合格标志被清除，请重新审核！',
          onOk: () => {
            this.formData.purcher = '';
            this.formData.qualityer = '';
            this.formData.qcer = '';
            this.formData.exam_status = 0;
          }
        })
      },
      rowClassName(row, index) {
          let className = '';
          if (index === this.checkIndex) {
            className = 'ivu-table-row-highlight';
          }
          if(row.is_default == 1){
            className += ' blod-style';
          }
          return className;
      },
      setDefault:function(){
        let _this = this;
        let id = _this.data[this.checkIndex].id;
        if(id < 1) return false;
        _this.common.http({
          url: 'setProSalesDefault',data:{id:id,supplier_code:this.supplierCode}
        }).then(function (res) {
           _this.alertMsg(res.msg,res.status != 1?'error':'');
           if(res.status == 1){
             for(let i=0;i<Object.keys(_this.data).length;i++){
               if(i!=_this.checkIndex) _this.$set(_this.data[i], 'is_default', 0)
               else  _this.$set(_this.data[_this.checkIndex], 'is_default', 1)
             }
           }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      rowClick:function(item,index){
        this.checkIndex = index;
      },
      comData:function(){
        let _this = this;
        if(this.supplierCode.length < 0) return false;
        this.formData.supplier_code = this.supplierCode;
        this.subLoading = true;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 'saveProSales',data:{fdata:_this.formData}
            }).then(function (res) {
               _this.subLoading = false;
               _this.alertMsg(res.msg,res.status != 1?'error':'');
               if(res.status == 1){
                 if(_this.formData.id) _this.$set(_this.data, _this.checkIndex, res.data)
                 else{
                   _this.data.unshift(res.data)
                   _this.checkIndex = 0;
                 }
                 _this.isCancleBtn = false;
                 _this.editModal = false;
               }
            }).catch(function(err){
              _this.subLoading = false;
              _this.common.httpErr(err.data,_this);
            })
          }else{
            _this.subLoading = false;
          }
        })
      },
      cancelCom:function(){
        if(this.isCancleBtn){
          this.modalMsg('进行审核操作后，不能取消修改!');
          return false;
        }else this.editModal = false;
      },
      chooseOp:function(post_code){
        if(!this.formData.id) return false;
        if(post_code == 'quality_depart' && this.formData.purcher.length < 1){
          return this.modalMsg('采购部负责人尚未审核!');
        }else if(post_code == 'quality_director' && this.formData.qcer.length < 1){
          return this.modalMsg('质量管理部负责人尚未审核!')
        }
        this.postCode = post_code;
        this.$refs.verifyUserRef.open();
      },
      confirmOp:function(e){
        this.isCancleBtn = true;
        if(this.postCode == 'purch_depart'){
          this.formData.purch_exam_date = e.purch_exam_date;
          this.formData.purcher = e.purcher;
        }else if(this.postCode == 'quality_depart'){
          this.formData.qcer = e.qcer;
          this.formData.qc_exam_date = e.qc_exam_date;
        }else if(this.postCode == 'quality_director'){
          this.formData.qualityer = e.qualityer;
          this.formData.quality_exam_date = e.quality_exam_date;
          this.formData.exam_status = e.exam_status;
        }
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
      }
    }
  }
</script>
<style lang="less">
  .table-m-bot{
    padding:0 90px 0 10px; position: relative;
    .right-btn{
      width: 77px; position: absolute; right: 0; top: 0; bottom: 0;
      .edit-btn{
        margin-bottom:10px;
      }
    }
  }
  .border-r-msg{
    border:1px dotted #ed4014;margin-left: 5px;margin-bottom:5px; padding: 5px 5px 0;border-radius: 5px;
  }
  .tip-msg{
    color: #ed4014;
  }
</style>
