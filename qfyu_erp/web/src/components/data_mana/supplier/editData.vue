<template>
  <div style="overflow-x: auto;">
    <div class="edit-m">
        <Form ref="formEditRef" :rules="ruleData" :model="formData" :label-width="90" :disabled="formData.audit_status?true:false">
          <div class="menu-nav">
            <div class="menu-l">
              <Menu :active-name="TabIndex" width="120" @on-select="changeMenu">
                <MenuItem v-for="(item,key) in menuDate" :name="item.name" :key="key">{{item.msg}}</MenuItem>
              </Menu>
              <div class="nav-menu">
                <Button type="primary" :loading="subLoading" @click="handleSubmit"><span class="icon iconfont">&#xe792;</span>保存</Button>
                <Button type="default" @click="handleCancel"><span class="icon iconfont">&#xe793;</span>取消</Button>
              </div>
              <div v-if="formData.audit_status" class="error-bg-text" style="width: 100%;font-size: 28px;padding: 20px;margin: 10px 0px;text-align: center;">禁止修改已审核的资料</div>
            </div>
            <div class="menu-r">
              <Row v-show="TabIndex=='required'">
                <Col span="12">
                  <Row>
                    <Col span="10">
                      <FormItem label="供应商编号">
                        <Input v-model="formData.supplier_code" disabled></Input>
                      </FormItem>
                    </Col>
                    <Col span="14">
                      <FormItem label="简称" :label-width="55" prop="name">
                        <Input v-model="formData.name" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <FormItem label="全称" prop="full_name">
                    <Input v-model="formData.full_name" maxlength="30"></Input>
                  </FormItem>
                  <Row>
                    <Col span="12">
                      <FormItem label="供方部门">
                        <Input v-model="formData.subject_dept" maxlength="10"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="联系电话">
                        <Input v-model="formData.tel" maxlength="30"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <FormItem label="详细地址" prop="address">
                    <Input v-model="formData.address" show-word-limit maxlength="30"></Input>
                  </FormItem>
                  <Row>
                    <Col span="12">
                      <FormItem label="移动电话">
                        <Input v-model="formData.mobile" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="传真">
                        <Input v-model="formData.fax" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="所有制性质">
                        <Input v-model="formData.economic_nature" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="年产值">
                        <InputNumber :precision="2"  :max="99999999999" :min="0" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="formData.output_year"></InputNumber>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="企业类型" prop="enterprise_type">
                        <Select v-model="formData.enterprise_type" v-if="JSON.stringify($store.state.sysParam) != '[]'">
                          <Option v-for="(item,index) in $store.state.sysParam['enterprise_type']" :value="item" :key="item">{{item}}</Option>
                        </Select>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="经营方式" prop="operation_mode">
                        <Input v-model="formData.operation_mode" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="企业法人" prop="legal_person">
                        <Input v-model="formData.legal_person" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="法人委托书有效期" prop="attorney_validity_date">
                        <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.attorney_validity_date"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="开户银行" prop="bank_area">
                        <Input v-model="formData.bank_area" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="账号" prop="bank_account">
                        <Input v-model="formData.bank_account" maxlength="30"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="税号" prop="tax_code">
                        <Input v-model="formData.tax_code" maxlength="50"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="结算方式" prop="pay_mode_no">
                        <Select v-model="formData.pay_mode_no">
                           <Option v-for="(item,index) in $store.state.settlement" :key="index" :value="index">{{item}} ( {{index}} )</Option>
                        </Select>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="法人职务">
                        <Input v-model="formData.duty" maxlength="20"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="法定资格">
                        <Input v-model="formData.competency" maxlength="50"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <FormItem label="质量保证体系">
                    <Input v-model="formData.quality_system" maxlength="100" show-word-limit></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <Row>
                    <Col span="12">
                      <FormItem label="统一监管码" prop="watch_no">
                        <Input v-model="formData.watch_no" maxlength="10"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="记录协议品种">
                        <Checkbox v-model="formData.record_varieties" :true-value="1" :false-value="0"></Checkbox>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="业务负责人" prop="business_leader">
                        <Input icon="ios-more" @on-click="clickSelEmployee" readonly v-model="formData.business_leader" ></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="业务授权书有效期" prop="ywysqsyxq_date">
                        <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.ywysqsyxq_date"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="质量保证书有效期" prop="quality_validity_date">
                        <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.quality_validity_date"></DatePicker>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="邮编">
                        <Input v-model="formData.post_code" maxlength="6"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="厂商分类">
                         <Select v-model="formData.prov_kind" filterable allow-create clearable @on-create="handleProvKind">
                            <Option v-for="(item,index) in provData" :key="index" :value="item.label">{{item.label}}</Option>
                         </Select>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="所在地区">
                        <Input readonly :value="formData.area" icon="ios-more" style="cursor: pointer;" @on-click="show_selarea"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="营业执照号码" prop="business_license">
                        <Input v-model="formData.business_license" maxlength="50"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="有效期至" prop="business_validity_date">
                        <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.business_validity_date"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="GSP/GMP证书号" prop="gsp_license">
                        <Input v-model="formData.gsp_license" maxlength="50"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="有效期至" prop="gsp_validity_date">
                        <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.gsp_validity_date"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col span="12">
                      <FormItem label="药品生产经营许可证" prop="drug_license">
                        <Input v-model="formData.drug_license" maxlength="50"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="有效期至" prop="drug_validity_date">
                        <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.drug_validity_date"></DatePicker>
                      </FormItem>
                    </Col>
                  </Row>
                  <FormItem label="许可经营类别：" prop="ddkindid">
                    <Input :value="formData.ddkindid" v-show="false"></Input>
                    <div class="showddk border-color" @click="show_selddk">
                      <div class="ddkdout">
                        <div class="ddklist txt-color" v-for="(item,index) in selddk_txt" :key="index">
                          {{item.pname||''}}
                          <span class="ddkicon iconfont">&#xe7eb;</span>
                          {{item.name||''}}
                        </div>
                      </div>
                    </div>
                  </FormItem>
                  <Row>
                    <Col span="12">
                      <FormItem label="暂停往来">
                        <Checkbox v-model="formData.pause" :true-value="1" :false-value="0"></Checkbox>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <FormItem label="审核标志">
                         <Checkbox v-model="formData.audit_status" :true-value="1" :false-value="0"></Checkbox>
                      </FormItem>
                    </Col>
                  </Row>
                </Col>
              </Row>
              <div v-show="TabIndex=='optional'">
                <div>
                  <Row>
                    <Col span="12">
                      <Row>
                        <Col span="12">
                          <FormItem label="ABC分类">
                            <Select v-model="formData.abckind">
                              <Option v-for="(item,index) in $store.state.sysParam['abc_type']" :value="index" :key="index">{{item}}</Option>
                            </Select>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="所属部门">
                             <Input readonly v-model="formData.depart_name" icon="ios-more" style="cursor: pointer;" @on-click="showSeldep"></Input>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="12">
                          <FormItem label="信用额度">
                            <InputNumber :precision="0"  :max="9999999" :min="0" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="formData.credit"></InputNumber>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="信用天数">
                            <InputNumber :precision="0"  :max="9999" :min="0" :active-change="false" :formatter="value => `${value}天`" :parser="value => value.replace('天', '')" v-model="formData.credit_days"></InputNumber>
                          </FormItem>
                        </Col>
                      </Row>
                        <FormItem label="授权品种">
                          <Input v-model="formData.staple" maxlength="100" show-word-limit></Input>
                        </FormItem>
                      <Row>
                        <Col span="12">
                          <FormItem label="资格证书">
                            <Input v-model="formData.qualification" maxlength="50"></Input>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="授权期限">
                            <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.auth_period_date"></DatePicker>
                          </FormItem>
                        </Col>
                      </Row>
                    </Col>
                    <Col span="12">
                      <Row>
                        <Col span="12">
                          <FormItem label="组织机构代码证编号">
                            <Input v-model="formData.organization_license" maxlength="50"></Input>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="有效期至">
                            <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.organization_validity_date"></DatePicker>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="12">
                          <FormItem label="保健品经营许可证">
                            <Input v-model="formData.health_license" maxlength="50"></Input>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="有效期至">
                            <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.health_validity_date"></DatePicker>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="12">
                          <FormItem label="医疗器械经营许可证">
                            <Input v-model="formData.apparatus_license" maxlength="50"></Input>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="有效期至">
                            <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.apparatus_validity_date"></DatePicker>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="12">
                          <FormItem label="食品经营许可证">
                            <Input v-model="formData.food_license" maxlength="50"></Input>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="有效期至">
                            <DatePicker type="date" :editable="false" transfer :options="optionsDate" v-model="formData.food_validity_date"></DatePicker>
                          </FormItem>
                        </Col>
                      </Row>
                    </Col>
                  </Row>
                </div>
                <FormItem label="备注信息">
                  <Input v-model="formData.remark" maxlength="100" show-word-limit></Input>
                </FormItem>
                <Divider orientation="left">质量负责人</Divider>
                <Row>
                  <Col span="4">
                    <FormItem label="姓名" :label-width="45">
                      <Input v-model="formData.qc_name" maxlength="10"></Input>
                    </FormItem>
                  </Col>
                  <Col span="3">
                    <FormItem label="性别" :label-width="45">
                       <Select v-model="formData.qc_sex">
                         <Option value="1">男</Option>
                         <Option value="2">女</Option>
                       </Select>
                    </FormItem>
                  </Col>
                  <Col span="3">
                    <FormItem label="工作年数" :label-width="70">
                      <InputNumber :precision="0" :max="99" :min="1" :active-change="false" :formatter="value => `${value}年`" :parser="value => value.replace('年', '')" v-model="formData.qc_year"></InputNumber>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="文化程度" :label-width="70">
                       <Input v-model="formData.qc_education" maxlength="10"></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="职务" :label-width="45">
                      <Input v-model="formData.qc_post" maxlength="15"></Input>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="技术职称" :label-width="70">
                       <Input v-model="formData.qc_technic_title" maxlength="50"></Input>
                    </FormItem>
                  </Col>
                </Row>
                <Divider orientation="left">质量管理机构</Divider>
                <Row>
                  <Col span="4">
                    <FormItem label="负责人" :label-width="55">
                      <Input v-model="formData.quality_principal" maxlength="10"></Input>
                    </FormItem>
                  </Col>
                  <Col span="4">
                    <FormItem label="人数" :label-width="45">
                      <InputNumber :precision="0"  :max="999999" :min="0" :active-change="false" :formatter="value => `${value}人`" :parser="value => value.replace('人', '')" v-model="formData.quality_man_count"></InputNumber>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="联系电话" :label-width="70">
                      <Input v-model="formData.quality_depart_tel" maxlength="30"></Input>
                    </FormItem>
                  </Col>
                  <Col span="10">
                    <FormItem label="质量状况" :label-width="70">
                       <Input v-model="formData.quality_state" maxlength="100"></Input>
                    </FormItem>
                  </Col>
                </Row>
                <Row>
                  <Col span="10">
                    <FormItem label="机构名称" :label-width="70">
                      <Input v-model="formData.quality_organization" maxlength="100"></Input>
                    </FormItem>
                  </Col>
                  <Col span="14">
                    <FormItem label="质量管理与制度情况" :label-width="135">
                       <Input v-model="formData.quality_regime" maxlength="200" show-word-limit></Input>
                    </FormItem>
                  </Col>
                </Row>
              </div>
           </div>
          </div>
          <div class="border-t">
            <Row>
              <Col span="4">
                <FormItem label="创建人" :label-width="60">
                  <Input v-model="formData.creator" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="创建时间" :label-width="70">
                   <Input v-model="formData.create_date" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="修改人" :label-width="60">
                  <Input v-model="formData.updater" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="修改时间" :label-width="70">
                   <Input v-model="formData.update_date" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="审核人" :label-width="60">
                  <Input v-model="formData.auditer" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="审核时间" :label-width="70">
                   <Input v-model="formData.audit_date" disabled></Input>
                </FormItem>
              </Col>
            </Row>
          </div>
      </Form>
    </div>
    <select-depart ref="selectDepartRef" @seldep="selectDep" @clear_sel="clearSel" :clearKeys="['depart_name','depart_id']"></select-depart>
    <select-ddkind ref="selddk" @selddk="select_ddk" @clear_sel="clearSel"></select-ddkind>
    <select-area ref="selarea" @selarea="select_area" @clear_sel="clearSel"></select-area>
    <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
  </div>
</template>
<script>
  import SelectDepart from '@/components/common/SelectDepart'
  import SelectDdkind from '@/components/common/SelectDdkind'
  import selectArea from '@/components/common/SelectArea'
  import selectEmployee from '@/components/common/SelectEmployee'
  var formData={supplier_code:'',name:'',full_name:'',subject_dept:'',tel:null,address:'',mobile:'',fax:'',economic_nature:'',output_year:null,enterprise_type:null,operation_mode:'',legal_person:'',attorney_validity_date:null,duty:'',competency:'',watch_no:'',record_varieties:0,quality_system:'',business_leader:'',ywysqsyxq_date:'',bank_area:'',bank_account:'',tax_code:'',pay_mode_no:'',quality_validity_date:null,post_code:'',prov_kind:null,area:'',ddkindid:null,business_license:'',business_validity_date:null,gsp_license:'',gsp_validity_date:null,drug_license:'',drug_validity_date:null,pause:0,audit_status:0,abckind:null,depart_name:'',depart_id:null,credit:null,credit_days:null,staple:'',qualification:'',auth_period_date:'',organization_license:'',organization_validity_date:null,health_license:'',health_validity_date:null,apparatus_license:'',apparatus_validity_date:null,food_license:'',food_validity_date:null,remark:'',qc_name:'',qc_sex:null,qc_year:null,qc_education:null,qc_post:null,qc_technic_title:'',quality_principal:'',quality_man_count:null,quality_depart_tel:'',quality_state:'',quality_organization:'',quality_regime:'',creator:'',create_date:null,updater:'',update_date:null,auditer:'',audit_date:null};
	export default {
    components:{
      SelectDepart,SelectDdkind,selectArea,selectEmployee
    },
	  props:{
      provData:{
        type:Array,
        default:()=>[]
      }
    },
		data:function () {
      const validateDate = (rule, value, callback) => {
           if (value) {
             callback();
           } else {
             callback(new Error("不能为空"));
           }
         };
      return{
        formData:JSON.parse(JSON.stringify(formData)),
        TabIndex:'required',
        menuDate:[
          {name:'required',msg:'基础信息'},
          {name:'optional',msg:'其它信息'}
        ],
        ruleData:{
          name:[
            {required:true,message:'请填写简称',trigger:'blur'}
          ],
          full_name:[
            {required:true,message:'请填写全称',trigger:'blur'}
          ],
          address:[
            {required:true,message:'请输入详细地址',trigger:'blur'}
          ],
          enterprise_type:[
            {required:true,message:'请选择企业类型',trigger:'change'}
          ],
          operation_mode:[
            {required:true,message:'请填写经营方式',trigger:'blur'}
          ],
          legal_person:[
            {required:true,message:'请填写企业法人',trigger:'blur'}
          ],
          attorney_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ],
          watch_no:[
             {required:true,message:'请填写统一监管码',trigger:'blur'}
          ],
          business_leader:[
             {required:true,message:'请填写业务负责人',trigger:'blur'}
          ],
          ywysqsyxq_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ],
          bank_area:[
            {required:true,message:'请填写开户行',trigger:'blur'}
          ],
          bank_account:[
            {required:true,message:'请填写银行账号',trigger:'blur'}
          ],
          tax_code:[
            {required:true,message:'请填写税号',trigger:'blur'}
          ],
          pay_mode_no:[
            {required:true,message:'请选择结算方式',trigger:'change'}
          ],
          quality_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ],
          ddkindid:[
            {required:true, message:'请选择经营许可类别',trigger:'change'}
          ],
          business_license:[
            {required:true,message:'请填写营业执照号码',trigger:'blur'}
          ],
          business_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ],
          gsp_license:[
            {required:true,message:'请填写GSP/GMP证书编号',trigger:'blur'}
          ],
          gsp_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ],
          drug_license:[
            {required:true,message:'请填写许可证号',trigger:'blur'}
          ],
          drug_validity_date:[
            { required: true, validator: validateDate, trigger: "change" }
          ]
        },
        optionsDate:{
          disabledDate (date){
            return date && date.valueOf() < Date.now() - 86400000;
          }
        },
        subLoading:false,
        selddk_txt:[],
        selddk:[],
      }
    },
    methods:{
      init:function(redata){
        this.$refs.formEditRef.resetFields();
        if(redata){
          redata.credit = parseFloat(redata.credit);
          redata.output_year = parseFloat(redata.output_year);
          redata.quality_man_count = parseFloat(redata.quality_man_count);
          redata.qc_year = parseFloat(redata.qc_year);
          redata.credit_days = parseFloat(redata.credit_days);
          this.formData = JSON.parse(JSON.stringify(redata));
          let selddk = this.formData.ddkindid.split(",");
          this.selddk = selddk;
          this.select_ddk(selddk);
        }else{
          this.formData = JSON.parse(JSON.stringify(formData))
          this.selddk = [];
          this.selddk_txt = [];
        }
        this.subLoading = false;
      },
      changeMenu:function (name) {
        this.TabIndex = name;
      },
      handleSubmit:function(){
        let _this = this;
        this.subLoading = true;
        if(typeof this.formData.prov_kind == 'undefined') _this.formData.prov_kind = null;
        this.$refs.formEditRef.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 'comSupplier',data:{fdata:_this.formData}
            }).then(function (res) {
              _this.subLoading = false;
              if(res.status == 1){
                _this.alertMsg(res.msg);
                _this.$emit('addNotify',{data:res.re_data,is_up:_this.formData.supplier_code})
              }else{
                _this.alertMsg(res.msg,'error')
              }
            }).catch(function(err){
              _this.subLoading = false;
              _this.common.httpErr(err.data,_this);
            })
          }else{
            _this.subLoading = false;
            _this.TabIndex = 'required';
          }
        })
      },
      handleCancel:function(){
        this.$emit('closeNotify')
      },
      handleProvKind:function(val){
        let obj = {value: val,label: val};
        this.provData.push(obj);
      },
      showSeldep:function(){
         this.$refs.selectDepartRef.init();
      },
      clickSelEmployee:function(){
        this.$refs.chooseEmployeeRef.init();
      },
      confirmEmployee:function(e){
        this.formData.business_leader = e.code;
      },
      selectDep:function(e){
        this.$set(this.formData,'depart_id',e.id);
        this.$set(this.formData,'depart_name',e.dept_name);
      },
      show_selddk:function () {
        if(this.formData.audit_status) return false;
        this.$refs.selddk.init({show_self:1,selddk:this.selddk});
      },
      show_selarea:function () {
        this.$refs.selarea.init()
      },
      select_area:function (data) {
        this.$set(this.formData,'area',data.areatxt);
      },
      select_ddk:function (data) {
        let _this = this;
        this.selddk=data;
        if(data.length==0){
          this.formData.ddkindid=null;
        }else{
          this.formData.ddkindid=data.join(',');
        }
        this.common.http({
          url:'getCustDdk',
          data:{selddk:data}
        }).then(function (d) {
          if(d.status==1){
            _this.selddk_txt=d.selddk_txt;
          }else{
            _this.alertMsg(d.msg,'error',{duration:0,isClosable:true});
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      clearSel:function(key){
        this.formData[key]=null;
      }
    }
	}
</script>
<style lang="less">
  .edit-m{
    min-width: 1000px;padding-top:6px;
    .menu-nav{
      display: flex;min-height: 450px;
      .menu-l{
        flex-shrink: 0;width: 104px;
        .nav-menu{
          .ivu-btn{
            margin-top: 20px;
          }
        }
      }
      .menu-r{
        flex-grow: 1;
      }
    }
    .border-t{
      padding-top:10px;
    }
  }
  .showddk{
    height: 127px; padding: 5px 0; border-style: solid; border-width: 1px; border-radius: 4px; cursor: pointer; flex-wrap: wrap; box-sizing: border-box; overflow: auto;
    .ddkdout{
      clear: both; overflow: hidden;
      .ddklist{
        float: left; width: 46%; height: 22px; margin: 0 2%; font-size: 12px; line-height: 22px; -webkit-box-flex: 1; -ms-flex-positive: 1; flex-grow: 1; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;
        .ddkicon{
          font-size: 12px; padding: 0 3px;
        }
      }
    }
  }
</style>
