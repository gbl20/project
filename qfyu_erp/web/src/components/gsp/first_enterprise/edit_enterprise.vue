<template>
  <div class="main">
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button :disabled ="proData.is_audit?true:false" ><span class="icon iconfont">&#xe793;</span>删除</Button>
          <Button @click="saveData" :disabled ="proData.is_audit?true:false" ><span class="icon iconfont">&#xe793;</span>保存</Button>
          <Divider type="vertical" />
          <Button @click="examBtn" :disabled ="proData.is_audit?true:false" ><span class="icon iconfont">&#xe797;</span>审核</Button>
          <Divider type="vertical" />
          <Button><span class="icon iconfont">&#xe791;</span>查询</Button>
          <Button @click="init"><span class="icon iconfont">&#xe791;</span>刷新</Button>
          <Button><span class="icon iconfont">&#xe791;</span>打印</Button>
        </div>
      </div>
      <div slot="table-list" class="tabs-form" :style="'height:'+height+'px;overflow:hidden;'" >
        <Form ref="formProData" :model="proData" :rules="ruleValidate" :disabled ="proData.is_audit?true:false" :label-width="110">
          <div class="top-m bg-m">
            <div class="top-m-item bg">
              <Row>
                <Col span="6">
                  <FormItem label="单据号" :label-width="70">
                    <Input v-model="proData.orderid" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="供应商编号" :label-width="100">
                    <Input v-model="proData.supplier_code" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="申请部门" :label-width="90" prop="depart_name">
                    <Input readonly v-model="proData.depart_name" icon="ios-more" style="cursor: pointer;" @on-click="showSeldep"></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="填报日期" :label-width="90">
                    <DatePicker type="date" format="yyyy-MM-dd" :value="proData.create_date" disabled></DatePicker>
                  </FormItem>
                </Col>
              </Row>
            </div>
          </div>
          <Tabs value="name1" :animated=false v-model="tabName" type="card">
            <TabPane label="基本信息" name="base">
              <div class="tabs-content" :style="'height:'+(height-157)+'px;overflow-y:auto;padding:5px 10px 0;'">
                  <Row>
                    <Col span="12">
                      <Row>
                        <Col span="14">
                          <FormItem label="企业名称：" prop="name">
                            <Input v-model="proData.name" maxlength="30"></Input>
                          </FormItem>
                        </Col>
                        <Col span="10">
                          <FormItem label="电话：">
                             <Input v-model="proData.tel" maxlength="30"></Input>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="14">
                          <FormItem label="企业地址：" prop="area">
                            <Input v-model="proData.area" maxlength="50"></Input>
                          </FormItem>
                        </Col>
                        <Col span="10">
                          <FormItem label="传真：">
                             <Input v-model="proData.fax" maxlength="30"></Input>
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                        <Col span="12">
                          <FormItem label="邮箱：">
                             <Input v-model="proData.email" maxlength="20"></Input>
                          </FormItem>
                        </Col>
                        <Col span="12">
                          <FormItem label="邮编：">
                             <InputNumber v-model="proData.post_code" maxlength="6"></InputNumber >
                          </FormItem>
                        </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="营业执照注册号：" prop="business_license">
                             <Input v-model="proData.business_license" maxlength="30"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="发照日期：">
                              <DatePicker type="date" transfer format="yyyy-MM-dd" v-model="proData.business_issue_date"></DatePicker>
                           </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="营业执照经营范围：" prop="business_scope">
                        <Input v-model="proData.business_scope" maxlength="200" show-word-limit type="textarea" :autosize="{minRows:3,maxRows: 3}"></Input>
                      </FormItem>
                      <Row>
                         <Col span="12">
                           <FormItem label="发照机关：">
                             <Input v-model="proData.business_issuing_authority" maxlength="30"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="有效期至：">
                              <DatePicker type="date" :options="startOptions" transfer format="yyyy-MM-dd" v-model="proData.business_validity_date"></DatePicker>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="税号：" prop="tax_code">
                              <Input v-model="proData.tax_code" maxlength="30"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="业务负责人：">
                              <Input icon="ios-more" @on-click="clickSelEmployee" readonly v-model="proData.business_leader" ></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="法人委托书：">
                        <Input type="textarea" :autosize="{minRows:2,maxRows: 2}" maxlength="200" show-word-limit  v-model="proData.attorney_book"></Input>
                      </FormItem>
                      <Row>
                         <Col span="12">
                           <FormItem label="委托书有效期至：">
                              <DatePicker type="date" :options="startOptions" transfer format="yyyy-MM-dd" v-model="proData.attorney_validity_date"></DatePicker>
                           </FormItem>
                         </Col>
                         <Col span="12">

                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="合同开始日期：">
                              <DatePicker type="date" transfer format="yyyy-MM-dd" v-model="proData.contract_start_date"></DatePicker>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="结束日期：">
                              <DatePicker type="date" :options="startOptions" transfer format="yyyy-MM-dd" v-model="proData.contract_end_date"></DatePicker>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="企业负责人：" prop="enterprise_leader">
                              <Input v-model="proData.enterprise_leader" maxlength="10"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="技术人员数：">
                              <InputNumber v-model="proData.tech_mans"></InputNumber>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="企业类型：" prop="enterprise_type">
                              <Select v-model="proData.enterprise_type" v-if="JSON.stringify($store.state.sysParam) != '[]'">
                                <Option v-for="(item,index) in $store.state.sysParam['enterprise_type']" :value="item" :key="item">{{item}}</Option>
                              </Select>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="法人代表：">
                              <Input v-model="proData.legal_person"></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                            <FormItem label="联系人：" prop="contact">
                               <Input v-model="proData.contact"></Input>
                            </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="身份证号：" prop="card_id">
                              <Input v-model="proData.card_id"></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="开户行：" prop="bank_area">
                              <Input v-model="proData.bank_area"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="银行账号：" prop="bank_account">
                              <Input v-model="proData.bank_account"></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="注册资金：">
                              <InputNumber :precision="2" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')"  v-model="proData.registered_capital"></InputNumber>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="经济性质：">
                              <Input v-model="proData.economic_nature"></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="年产值：">
                                <InputNumber :precision="2" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="proData.output_year"></InputNumber>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="经营方式：">
                              <Input v-model="proData.operation_mode"></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="拟供产品：">
                        <Input type="textarea" :autosize="{minRows:2,maxRows: 2}" v-model="proData.supply_var"></Input>
                      </FormItem>
                      <FormItem label="获得主要荣誉：">
                        <Input v-model="proData.major_honors"></Input>
                      </FormItem>
                    </Col>
                    <Col span="12">
                      <Row>
                         <Col span="12">
                           <FormItem label="药品生产或经营许可证号：" prop="drug_license">
                              <Input v-model="proData.drug_license"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="发证机关：">
                              <Input v-model="proData.drug_issuing_authority"></Input>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="发证日期：">
                              <DatePicker transfer v-model="proData.drug_issue_date" type="date" format="yyyy-MM-dd"></DatePicker>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="有效期至：" prop="drug_validity_date">
                              <DatePicker :options="startOptions" transfer v-model="proData.drug_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                           </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                           <FormItem label="GMP/GSP证书编号：" prop="gsp_license">
                              <Input v-model="proData.gsp_license"></Input>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="证书有效期：" prop="gsp_validity_date">
                              <DatePicker :options="startOptions" transfer v-model="proData.gsp_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                           </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="许可经营类别：" prop="ddkindid">
                        <Input :value="proData.ddkindid" v-show="false"></Input>
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
                           <FormItem label="已提交质量协议保证书" :label-width="150">
                             <Checkbox v-model="proData.is_quality_agreement" :true-value='1' :false-value='0' ></Checkbox>
                           </FormItem>
                         </Col>
                         <Col span="12">
                           <FormItem label="质量保证书有效期：" :label-width="150" prop="quality_validity_date">
                             <DatePicker :options="startOptions" transfer v-model="proData.quality_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                           </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="GMP证书认证范围：">
                         <Input v-model="proData.gmp_range"></Input>
                      </FormItem>
                      <Row>
                         <Col span="12">
                          <FormItem label="第二GMP证书编号：">
                             <Input v-model="proData.gmp_two_license"></Input>
                          </FormItem>
                         </Col>
                         <Col span="12">
                          <FormItem label="证书有效期：">
                             <DatePicker :options="startOptions" transfer v-model="proData.gmp_two_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                          </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="GMP证书2认证范围：">
                         <Input v-model="proData.gmp_two_range"></Input>
                      </FormItem>
                      <Row>
                         <Col span="12">
                          <FormItem label="第三GMP证书编号：">
                             <Input v-model="proData.gmp_three_license"></Input>
                          </FormItem>
                         </Col>
                         <Col span="12">
                          <FormItem label="证书有效期：">
                             <DatePicker :options="startOptions" transfer v-model="proData.gmp_three_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                          </FormItem>
                         </Col>
                      </Row>
                      <FormItem label="GMP证书3认证范围：">
                         <Input v-model="proData.gmp_three_range"></Input>
                      </FormItem>
                      <Row>
                         <Col span="12">
                          <FormItem label="医疗器械经营许可证编号：">
                             <Input v-model="proData.apparatus_license"></Input>
                          </FormItem>
                         </Col>
                         <Col span="12">
                          <FormItem label="有效期至：">
                             <DatePicker :options="startOptions" transfer v-model="proData.apparatus_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                          </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                          <FormItem label="食品经营许可证编号：">
                             <Input v-model="proData.food_license"></Input>
                          </FormItem>
                         </Col>
                         <Col span="12">
                          <FormItem label="有效期至：">
                             <DatePicker :options="startOptions" transfer v-model="proData.food_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                          </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                          <FormItem label="保健品经营许可证编号：">
                             <Input v-model="proData.health_license"></Input>
                          </FormItem>
                         </Col>
                         <Col span="12">
                          <FormItem label="有效期至：">
                             <DatePicker :options="startOptions" transfer v-model="proData.health_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                          </FormItem>
                         </Col>
                      </Row>
                      <Row>
                         <Col span="12">
                          <FormItem label="组织机构代码证号：">
                             <Input v-model="proData.organization_license"></Input>
                          </FormItem>
                         </Col>
                         <Col span="12">
                          <FormItem label="有效期至：">
                            <DatePicker :options="startOptions" transfer v-model="proData.organization_validity_date" type="date" format="yyyy-MM-dd"></DatePicker>
                          </FormItem>
                         </Col>
                      </Row>
                    </Col>
                  </Row>
              </div>
            </TabPane>
            <TabPane label="产品状况与质量保证" name="pro_mass">
              <div :style="'height:'+(height-157)+'px;overflow-y:auto;padding:0 10px;'">
                <FormItem label="主要产品：" :label-width="160">
                  <Input type="textarea" :autosize="{minRows:3,maxRows: 3}" maxlength="200" show-word-limit v-model="proData.main_pro" style="width:500px"></Input>
                </FormItem>
                <FormItem label="产品优势：" :label-width="160">
                  <Input type="textarea" :autosize="{minRows:3,maxRows: 3}" maxlength="200" show-word-limit v-model="proData.pro_advant" style="width:500px"></Input>
                </FormItem>
                <FormItem label="企业质量机构名称：" :label-width="160">
                  <Input style="width:500px" maxlength="50" show-word-limit v-model="proData.quality_organization"></Input>
                </FormItem>
                <FormItem label="质量保证体系：":label-width="160">
                  <Input style="width:500px" maxlength="50" show-word-limit v-model="proData.quality_system" ></Input>
                </FormItem>
                <FormItem label="质量管理与制度情况：" :label-width="160">
                  <Input type="textarea" maxlength="200" show-word-limit v-model="proData.mana_system" :autosize="{minRows:4,maxRows: 4}" style="width:500px"></Input>
                </FormItem>
              </div>
            </TabPane>
            <TabPane label="随货通行单及印章样式图片" v-if="proData.orderid" name="through">
              <div :style="'height:'+(height-157)+'px;overflow-y:auto;padding:0 10px;'">
                <Row>
                  <Col span="12">
                    <FormItem label="随货通行单：" :label-width="160">
                      <div>
                        有效期至：<DatePicker :options="startOptions" transfer v-model="proData.shtxd_validity_date"  type="date" :clearable="false" :editable="false" format="yyyy-MM-dd" style="display: inline-block; width:200px"></DatePicker>
                      </div>
                      <div class="btn-view">
                        <upload action="enterPriseUpload" :extraData="{code:proData.supplier_code,validity_date:proData.shtxd_validity_date,is_add:1}" imgName="SHTXD" @upSuccess="upSuccess" @upProgress="upProgress">
                        </upload>
                       </div>
                       <div class="img-m border-color" v-if="proData.SHTXD_img">
                         <viewer :images="[BASE_URL+proData.SHTXD_img]">
                             <img :src="BASE_URL+proData.SHTXD_img" alt="">
                         </viewer>
                       </div>
                    </FormItem>
                  </Col>
                  <Col span="12">
                    <FormItem label="印章样式图片：" :label-width="160">
                      <div>
                        有效期至：<DatePicker :options="startOptions" transfer v-model="proData.yzystp_validity_date" type="date" :clearable="false" :editable="false" format="yyyy-MM-dd" style="display: inline-block;width:200px"></DatePicker>
                      </div>
                      <div class="btn-view">
                        <upload action="enterPriseUpload" :extraData="{code:proData.supplier_code,validity_date:proData.shtxd_validity_date}" imgName="YZYSTP" @upSuccess="upSuccess" @upProgress="upProgress">
                        </upload>
                      </div>
                      <div class="img-m border-color" v-if="proData.YZYSTP_img">
                        <viewer :images="[BASE_URL+proData.YZYSTP_img]">
                          <img :src="BASE_URL+proData.YZYSTP_img" alt="">
                        </viewer>
                      </div>
                    </FormItem>
                  </Col>
                </Row>
              </div>
            </TabPane>
            <TabPane label="供方销售人员(联系人)" v-if="proData.orderid" name="contacts">
              <div :style="'height:'+(height-157)+'px;overflow-y:auto;'">
                <div class="nav-menu">
                  <Button @click="addSupplierP(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                  <Button @click="addSupplierP(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                  <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
                </div>
                <Table id="table-m" border stripe :columns="columns" :data="contactsData" :highlight-row="true" :height="height-199"></Table>
              </div>
            </TabPane>
            <TabPane label="意见与结论" v-if="proData.is_audit == 1" name="opinion">
              <div :style="'height:'+(height-157)+'px;overflow-y:auto;'">
                <authentication :orderid="proData.orderid" :examData="examData" :type="2" :isDisabled="proData.is_approval?true:false" @adminCheckSuccess="init"></authentication>
               </div>
            </TabPane>
          </Tabs>
          <div class="top-m bg-m">
            <div class="top-m-item bg">
              <Row>
                <Col span="6">
                  <FormItem label="制单人" :label-width="80">
                    <Input disabled v-model="proData.creator"></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="修改者" :label-width="80">
                    <Input disabled v-model="proData.updater"></Input>
                  </FormItem>
                </Col>
                <Col span="3">
                  <FormItem label="" :label-width="20">
                    <Checkbox v-model="proData.is_audit" :true-value='1' :false-value='0' disabled>已审核</Checkbox>
                  </FormItem>
                </Col>
                <Col span="3">
                  <FormItem label="" :label-width="20">
                    <Checkbox v-model="proData.is_approval" :true-value='1' :false-value='0' disabled>已审批</Checkbox>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="带有*号的为必填项" :label-width="150"></FormItem>
                </Col>
              </Row>
            </div>
          </div>
        </Form>
        <Modal v-model="modal" title="供方销售人员编辑" width="680" footer-hide :mask-closable="false">
          <edit-contacts ref="editContactsRef" @comDataRB="comDataRB"></edit-contacts>
        </Modal>
      </div>
    </split-none>
    <select-depart ref="selectDepartRef" @seldep="selectDep" @clear_sel="clearSel" :clearKeys="['depart_name','depart_id']"></select-depart>
    <select-ddkind ref="selddk" @selddk="select_ddk" @clear_sel="clearSel"></select-ddkind>
    <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
  </div>
</template>

<script>
  import splitNone from '@/components/public/splitNone'
  import editContacts from '@/components/gsp/first_enterprise/edit_contacts.vue'
  import SelectDepart from '@/components/common/SelectDepart'
  import SelectDdkind from '@/components/common/SelectDdkind'
  import authentication from '@/components/public/authentication.vue'
  import upload from '@/components/public/upload.vue'
  import selectEmployee from '@/components/common/SelectEmployee'
  var fData = {orderid:'',mnemonic_code:null,depart_id:null,depart_name:'',name:'',area:'',tel:'',fax:'',email:'',post_code:null,enterprise_leader:'',tech_mans:null,business_license:'',business_scope:'',business_issuing_authority:'',business_issue_date:null,business_validity_date:null,attorney_book:'',attorney_validity_date:null,business_leader_code:'',business_leader:'',contract_start_date:null,contract_end_date:null,enterprise_type:'',output_year:null,major_honors:'',supply_var:'',drug_license:'',drug_issuing_authority:'',drug_issue_date:null,drug_validity_date:null,apparatus_license:'',apparatus_validity_date:null,food_license:'',food_validity_date:null,health_license:'',health_validity_date:null,organization_license:'',organization_validity_date:null,legal_person:'',registered_capital:null,economic_nature:'',operation_mode:null,contact:'',card_id:'',gsp_license:'',gsp_validity_date:null,gmp_range:'',gmp_two_license:'',gmp_two_range:'',gmp_two_validity_date:null,gmp_three_license:'',gmp_three_range:'',gmp_three_validity_date:null,bank_area:'',bank_account:'',tax_code:'',ddkindid:null,is_quality_agreement:0,quality_validity_date:null,create_date:null,e_name:null,main_pro:null,pro_advant:null,quality_organization:null,quality_system:null,mana_system:null,is_audit:0,shtxd_validity_date:null,SHTXD_img:null,yzystp_validity_date:null,YZYSTP_img:null,ue_name:'',is_approval:0};
  export default {
    name:'EditEnterprise',
    components:{
      splitNone,editContacts,upload,authentication,SelectDepart,SelectDdkind,selectEmployee
    },
    data: function() {
      const validateDate = (rule, value, callback) => {
           if (value) {
             callback();
           } else {
             callback(new Error("不能为空"));
           }
         };
      return {
        Breadcrumb:[{title:'GSP'},{title:'首营企业管理',url:'first_enterprise'},{title:'首营企业申请'}],
        tabName:'base',
        height:0,
        selddk:[],
        selddk_txt:[],
        proData: JSON.parse(JSON.stringify(fData)),
        enterpriseType:this.$store.state.sysParam['enterprise_type'],
        columns:[
          { title: "单据编号",key: "orderid",resizable: true,width: 120,tooltip:true},
          { title: "供应商编号",key: "supplier_code",resizable: true,width: 120,tooltip:true},
          { title: "姓名",key: "user_name",resizable: true,width: 120,tooltip:true},
          { title: "身份证号",key: "id_card",resizable: true,width: 120,tooltip:true},
          { title: "性别",solt: "sex",width: 80,render(e,val){return e('div',{},val.row.sex==1?'男':'女')}},
          { title: "部门",key: "depart_name",resizable: true,width: 100,tooltip:true,align: "center"},
          { title: "职务",key: "duties",resizable: true,width: 100,tooltip:true,align: "center"},
          { title: "地址",key: "address",resizable: true,width: 150,tooltip:true,align: "left"},
          { title: "电话",key: "tel",resizable: true,width: 100,tooltip:true,align: "center"},
          { title: "手机",key: "phone",resizable: true,width: 100,align: "center"},
          { title: "QQ",key: "qq",resizable: true,width: 100,tooltip:true,align: "center"},
          { title: "Email",key: "seniority",resizable: true,width: 100,tooltip:true,align: "center"},
          { title: "remark",key: "edu",resizable: true,width: 100,tooltip:true,align: "center"},
          { title: "资料是否有效",key: "status",resizable: true,width: 150,tooltip:true,align: "center",render(e,val){return e('div',{},val.row.status==1?'有效':'无效')}},
          { title: "委托书编号",key: "attorney_no",resizable: true,width: 140,tooltip:true,align: "center"},
          { title: "委托书有效内容",key: "content_power",resizable: true,width: 150,tooltip:true,align: "center"},
          { title: "委托书有效期",key: "validity_date",resizable: true,width: 150,tooltip:true,align: "center"},
          { title: "委托书是否有效",key: "attorney_validity",resizable: true,width: 150,tooltip:true,align: "center",render(e,val){return e('div',{},val.row.attorney_validity==1?'有效':'无效')}}
        ],
        ruleValidate:{
          depart_name:[
            {required:true,message:'请选择部门',trigger:'change'}
          ],
          name:[
            {required:true,message:'请填写企业名称',trigger:'blur'}
          ],
          area:[
            {required:true,message:'请填写企业地址',trigger:'blur'}
          ],
          enterprise_leader:[
            {required:true,message:'请填写负责人',trigger:'blur'}
          ],
          business_license:[
            {required:true,message:'请填写营业执照编号',trigger:'blur'}
          ],
          business_scope:[
            {required:true,message:'请填写营业范围',trigger:'blur'}
          ],
          enterprise_type:[
            {required:true,message:'请选择企业类型',trigger:'change'}
          ],
          drug_license:[
            {required:true,message:'请填写药品经营许可证号',trigger:'blur'}
          ],
          drug_validity_date:[
             { required: true, validator: validateDate, trigger: "change" }
          ],
          contact:[
            {required:true,message:'请填写联系人',trigger:'blur'}
          ],
          card_id:[
            {required:true,message:'请填写联系人身份证号',trigger:'blur'}
          ],
          gsp_license:[
            {required:true,message:'请填写GSP证书编号',trigger:'blur'}
          ],
          ddkindid:[
            {required:true,message:'请选择经营许可类别',trigger:'change'}
          ],
          gsp_validity_date:[
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
          quality_validity_date:[
             { required: true, validator: validateDate, trigger: "change" }
          ]
        },
        contactsData:[],
        contactsIndex:-1,
        modal:false,
        subLoading:false,
        startOptions: {
            disabledDate (date) {
                return date && date.valueOf() < Date.now() - 86400000;
            }
        },
        editEnterpriseOrderid:null,
        examData:null,
        BASE_URL:this.common.BASE_URL
      }
    },
    activated() {
      this.editEnterpriseOrderid = localStorage.getItem("edit_enterprise_orderid") || null;
      const myDate = new Date();
      const year = myDate.getFullYear();
      const month = myDate.getMonth() + 1;
      const day = myDate.getDate();
      this.proData.shtxd_validity_date = `${year}/${month}/${day}`;
      this.proData.yzystp_validity_date = `${year}/${month}/${day}`;
    },
    watch:{
      editEnterpriseOrderid(e){
        this.tabName = 'base';
        if(!e){
          this.proData = JSON.parse(JSON.stringify(fData));
          this.contactsData = [];
        }else this.init();
      }
    },
    mounted() {
      this.init();
    },
    methods: {
      init:function(){
        let _this = this;
        this.common.http({
          url: 'editEnterpriseInit',data:{orderid:this.editEnterpriseOrderid},
        }).then(function (res) {
          if(res.status == 1){
            _this.contactsData = res.contacts_data;
            _this.examData = res.exam_data;
            _this.selddk = res.dd_Kind;
            _this.selddk_txt = res.dd_kind_txt;
            if(res.edit_enter_priseData){
              setTimeout(function(){
                _this.initData(res.edit_enter_priseData);
              },100)
            }
          }
        }).catch(function(err){
           _this.common.httpErr(err.data,_this);
        })
      },
      initData:function(proData){
        if(proData.registered_capital) proData.registered_capital = parseFloat(proData.registered_capital);
        if(proData.output_year) proData.output_year = parseFloat(proData.output_year);
        this.proData = proData;
      },
      saveData:function(){
        let _this = this;
        this.$refs.formProData.validate(function(valid){
          if (valid) {
            _this.common.http({
              url: 'saveEnterprise',data:{fdata:_this.proData}
            }).then(function (res) {
              if(res.status == 1){
                _this.proData = res.re_data;
                localStorage.setItem("edit_enterprise_orderid",res.re_data.orderid);
                _this.alertMsg(res.msg);
              }else{
                _this.alertMsg(res.msg,'error')
              }
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            })
          }else _this.subLoading = false;
        })
      },
      clickSelEmployee:function(){
        this.$refs.chooseEmployeeRef.init();
      },
      confirmEmployee:function(e){
        this.proData.business_leader_code = e.code;
        this.proData.business_leader = e.name;
      },
      showSeldep:function(){
         this.$refs.selectDepartRef.init();
      },
      selectDep:function(e){
        this.$set(this.proData,'depart_id',e.id);
        this.$set(this.proData,'depart_name',e.dept_name);
      },
      show_selddk:function () {
        this.$refs.selddk.init({show_self:1,selddk:this.selddk});
      },
      select_ddk:function (data) {
        let _this = this;
        this.selddk=data;
        if(data.length==0){
          this.proData.ddkindid=null;
        }else{
          this.proData.ddkindid=data.join(',');
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
        this.proData[key]=null;
      },
      examBtn:function(){
        let _this = this;
        this.$Modal.confirm({
          title: '警告提示',
          content: '即将审核首营企业记录。审核之后将不能再修改数据，要继续吗？',
          loading: true,
          onOk: () => {
            _this.common.http({
              url: 'examEnterprise',data:{orderid:_this.proData.orderid}
            }).then(function (res) {
              _this.$Modal.remove();
              if(res.status == 1){
                _this.alertMsg(res.msg);
                _this.proData.is_audit = 1;
              }else{
                _this.alertMsg(res.msg,'error')
              }
            }).catch(function(err){
              _this.$Modal.remove();
              _this.common.httpErr(err.data,_this);
            })
          }
        });
      },
      upSuccess:function(res){
        this.proData[res.name+'_img'] = res.imgUrl;
      },
      upProgress:function(res){
        console.log(res)
      },
      addSupplierP:function(type){
        let editSupplierData = null;
        if(type){
          if(this.contactsIndex == -1){
            this.alertMsg('请选择需要修改的信息','error');
            return false;
          }
          else editSupplierData = this.contactsData[this.contactsIndex];
        }
        this.$refs.editContactsRef.init(this.proData.orderid,this.proData.supplier_code,editSupplierData);
        this.modal = true;
      },
      comDataRB:function(e){
        if(this.contactsIndex != -1) this.$set( this.contactsData, this.contactsIndex, e.data)
        else{
          this.contactsData.unshift(e.data)
        }
        this.contactsIndex = -1;
        this.modal = false;
      },
      DHeight:function(e){
        this.height = e;
      }
    }
  }
</script>
<style lang="less">
  .top-m{
    width: auto;height: auto;padding:6px 0;
    .top-m-item{
      height: 40px;padding:0 10px;
      .ivu-form-item{
        margin-top:3px;
      }
    }
  }
  .showddk{
    height: 227px; padding: 5px 0; border-style: solid; border-width: 1px; border-radius: 4px; cursor: pointer; flex-wrap: wrap; box-sizing: border-box; overflow: auto;
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
  .btn-view{
    display: block;width: 300px;margin:15px 0;
  }
  .img-m{
    display: block;width: 300px;height: 200px;border-radius: 5px;border:1px dotted;
    img{
      display: block;width: auto;max-width: 100%;height: auto;max-height: 100%;margin:auto;
    }
  }
</style>
