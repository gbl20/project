<template>
	<div>
    <Modal footer-hide :mask-closable="false" width="1000" title="商品资料" v-model="Model" class-name="min1000">
      <div class="menu-nav">
        <div class="menu-le">
          <Menu active-name="base" width="120" @on-select="changeMenu">
            <MenuItem v-for="(item,key) in menuDate" :name="item.name" :key="key">{{item.msg}}</MenuItem>
          </Menu>
          <div class="nav-menu">
            <Button type="primary" :disabled="formData.status?true:false" @click="newData(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
            <Button type="primary" :disabled="formData.status?true:false" @click="newData(false)"><span class="icon iconfont">&#xe692;</span>保存</Button>
          </div>
          <div v-show="formData.status" class="err-title error-bg-text">禁止修改已审核的资料</div>
        </div>
        <div class="menu-ri">
          <Form ref="formMain" :rules="ruleData" :model="formData" :label-width="110" :disabled="formData.status?true:false">
            <Row :style="{display:TabIndex=='base'?'block':'none'}">
              <Col span="8">
                <FormItem label="商品编号">
                  <Input v-model="formData.goods_code" disabled></Input>
                </FormItem>
                <FormItem label="通用名称" prop="name">
                  <Input v-model="formData.name"></Input>
                </FormItem>
                <FormItem label="商品名称">
                  <Input v-model="formData.goods_name"></Input>
                </FormItem>
                <FormItem label="英文名">
                  <Input v-model="formData.en_name"></Input>
                </FormItem>
                <FormItem label="条形码">
                  <Input v-model="formData.code"></Input>
                </FormItem>
                <FormItem label="附件名">
                  <Input v-model="formData.file_name"></Input>
                </FormItem>
                <FormItem label="拼音码">
                  <Input v-model="formData.pym" disabled></Input>
                </FormItem>
                <FormItem label="规格" prop="specs">
                  <Input v-model="formData.specs"></Input>
                </FormItem>
                <FormItem label="电子监管码">
                  <Input v-model="formData.electron_code"></Input>
                </FormItem>
                <FormItem label="彩页码">
                  <Input v-model="formData.color_code"></Input>
                </FormItem>
                <FormItem label="运输在途时限">
                  <Input v-model="formData.hours"><span slot="append">小时</span></Input>
                </FormItem>
                <FormItem label="成分类别">
                  <Select v-model="formData.element_type" clearable>
                    <Option v-for="(item,index) in selItem.element_type" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="商品色标">
                  <Select v-model="formData.coloc_type" clearable>
                    <Option v-for="(item,index) in selItem.color_type" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="自定义分类">
                  <Input v-model="formData.custom_name"></Input>
                </FormItem>
                <FormItem label="自定义数值">
                  <Input v-model="formData.custom_val"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="许可经营大类">
                  <Select clearable v-model="formData.kinds_id">
                    <Option v-for="(item,index) in custom" :value="item.id" :key="index">{{item.name}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="许可经营小类">
                  <Row>
                    <Col span="6">
                      <Input v-model="formData.kinds_kid"></Input>
                    </Col>
                    <Col span="1">&nbsp;</Col>
                    <Col span="17">
                      <Input v-model="formData.kinds_name">
                        <a href="javascript:;" @click="changeKind" slot="append" class="icon iconfont">&#xe7fc;</a>
                      </Input>
                    </Col>
                  </Row>
                </FormItem>
                <FormItem label="商品大类">
                  <Select clearable v-model="formData.category_id">
                    <Option v-for="(item,index) in category" :value="item.value" :key="index">{{item.label}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="功能类别" prop="function_id">
                  <Cascader change-on-select :data="kinds" :render-format="format" v-model="formData.function_id"></Cascader>
                </FormItem>
                <FormItem label="产地">
                  <Input v-model="formData.origin"></Input>
                </FormItem>
                <FormItem label="生产企业" prop="production">
                  <Input v-model="formData.production"></Input>
                </FormItem>
                <FormItem label="生产企业简称">
                  <Input v-model="formData.maker"></Input>
                </FormItem>
                <FormItem label="主单位" prop="unit">
                  <Select v-model="formData.unit" :disabled="formData.goods_code?true:false">
                    <Option v-for="(item,index) in selItem.goods_unit" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="辅单位">
                  <Select v-model="formData.unit2" :disabled="displayUnit?true:false">
                    <Option v-for="(item,index) in selItem.goods_unit" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="允许拆零">
                  <Switch :true-value="1" :false-value="0" v-model="formData.is_solit" />
                </FormItem>
                <FormItem label="拆零比例 1: ">
                  <InputNumber :disabled="solitValue>1?true:false" :active-change="false" :max="999" :min="1" v-model="formData.solit_value"></InputNumber>
                </FormItem>
                <FormItem label="剂型" prop="dosage">
                  <Select v-model="formData.dosage">
                    <Option v-for="(item,index) in selItem.dosage" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="税率(%)">
                  <InputNumber :max="999" :min="0" :step="1" v-model="formData.tax"></InputNumber>
                </FormItem>
                <FormItem label="储存条件" prop="storage_type">
                  <Select v-model="formData.storage_type">
                    <Option v-for="(item,index) in selItem.storage" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="所属部门">
                  <Input icon="ios-more" v-model="$store.state.depart[formData.depart_id]" @on-click="showDepartModal"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="批准文号" prop="approval_code">
                  <Input v-model="formData.approval_code"></Input>
                </FormItem>
                <FormItem label="批准文号效期">
                  <DatePicker type="date" :editable="false" :options="optionsDate" v-model="formData.approval_date"></DatePicker>
                </FormItem>
                <FormItem label="保质期">
                  <Row>
                    <Col span="12">
                      <Input maxlength="6" v-model="formData.shelf_life"></Input>
                    </Col>
                    <Col span="1">&nbsp;</Col>
                    <Col span="11">
                      <Select v-model="formData.shelf_unit" clearable>
                        <Option v-for="(item,index) in selItem.shelf_unit" :value="item" :key="index">{{item}}</Option>
                      </Select>
                    </Col>
                  </Row>
                </FormItem>
                <FormItem label="提成率(%)">
                  <InputNumber :max="999999" :min="0" :step="1" v-model="formData.take"></InputNumber>
                </FormItem>
                <FormItem label="GSP验收类型" prop="gsp_type">
                  <Select v-model="formData.gsp_type">
                    <Option v-for="(item,index) in selItem.gsp_category" :value="index" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
                <FormItem label="本位码">
                  <Input v-model="formData.standard_code"></Input>
                </FormItem>
                <FormItem label="监管码">
                  <Input v-model="formData.supervise_code"></Input>
                </FormItem>
                <FormItem label="包装规格">
                  <Input v-model="formData.packspecs"></Input>
                </FormItem>
                <FormItem label="中包装数">
                  <InputNumber :active-change="false" :max="9999" :min="0" v-model="formData.pack_specs1"></InputNumber>
                </FormItem>
                <FormItem label="大包装数">
                  <InputNumber :active-change="false" :max="9999" :min="0" v-model="formData.pack_specs2"></InputNumber>
                </FormItem>
                <FormItem label="含量">
                  <Input v-model="formData.drug"></Input>
                </FormItem>
                <FormItem label="含量单位">
                  <Input v-model="formData.drug_unit"></Input>
                </FormItem>
                <FormItem label="批发毛利率(%)">
                  <Tooltip max-width="200" placement="top" content="计算方式：(标准批发价-标准进价) / 标准批发价">
                    <InputNumber disabled :max="99999" :min="0" :step="1" v-model="formData.pifaml"></InputNumber>
                  </Tooltip>
                </FormItem>
                <FormItem label="零售毛利率(%)">
                  <Tooltip max-width="200" placement="top" content="计算方式：(标准零售价-标准进价) / 标准零售价">
                    <InputNumber disabled :max="99999" :min="0" :step="1" v-model="formData.retail"></InputNumber>
                  </Tooltip>
                </FormItem>
                <FormItem label="开票类别">
                  <Select v-model="formData.billing_type" clearable>
                    <Option v-for="(item,index) in selItem.billing_type" :value="item" :key="index">{{item}}</Option>
                  </Select>
                </FormItem>
              </Col>
            </Row>
            <Row :style="{display:TabIndex=='extend'?'block':'none'}">
              <Row>
                <Col span="8">
                  <FormItem label="ABC分类">
                    <Select v-model="formData.abc" clearable>
                      <Option v-for="(item,index) in selItem.abc_type" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                  <FormItem label="毛利率分类" clearable>
                    <Select v-model="formData.abkind">
                      <Option v-for="(item,index) in selItem.ml_type" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                  <FormItem label="质量标准">
                    <Input v-model="formData.quality_standards"></Input>
                  </FormItem>
                  <FormItem label="质量标准有效期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.quality_date"></DatePicker>
                  </FormItem>
                  <FormItem label="外观质量">
                    <Input v-model="formData.exterior"></Input>
                  </FormItem>
                  <FormItem label="注册商标">
                    <Input v-model="formData.brand"></Input>
                  </FormItem>
                  <FormItem label="积分倍率">
                    <Tooltip max-width="200" placement="top" content="0：该商品不积分；空：按会员类别积分规则积分；其他值：销售数量或金额（系统选项中设置）*该值 = 积分">
                      <Input v-model="formData.integral"></Input>
                    </Tooltip>
                  </FormItem>
                </Col>
                <Col span="8">
                  <FormItem label="生产许可证号">
                    <Input v-model="formData.license_key"></Input>
                  </FormItem>
                  <FormItem label="许可证有效期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.license_date"></DatePicker>
                  </FormItem>
                  <FormItem label="GMP属性">
                    <Input v-model="formData.gmp_property"></Input>
                  </FormItem>
                  <FormItem label="GMP证书编号">
                    <Input v-model="formData.gmp_code"></Input>
                  </FormItem>
                  <FormItem label="GMP证书有效期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.gmp_end_date"></DatePicker>
                  </FormItem>
                  <FormItem label="注册商标有效期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.brand_date"></DatePicker>
                  </FormItem>
                  <FormItem label="商品匹配码二">
                    <Input v-model="formData.custom_code2"></Input>
                  </FormItem>
                </Col>
                <Col span="8">
                  <FormItem label="等级">
                    <Select v-model="formData.level" clearable>
                      <Option v-for="(item,index) in selItem.level" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                  <FormItem label="自定义证书一">
                    <Input v-model="formData.code1"></Input>
                  </FormItem>
                  <FormItem label="证书一有效期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.code1_date"></DatePicker>
                  </FormItem>
                  <FormItem label="自定义证书二">
                    <Input v-model="formData.code2"></Input>
                  </FormItem>
                  <FormItem label="证书二有效期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.code2_date"></DatePicker>
                  </FormItem>
                  <FormItem label="商品匹配码一">
                    <Input v-model="formData.custom_code1"></Input>
                  </FormItem>
                  <FormItem label="商品匹配码三">
                    <Input v-model="formData.custom_code3"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row><Divider orientation="left">买赠设置（批发）</Divider></Row>
              <Row>
                <Col span="3">
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.times_give">倍量记赠</Checkbox>
                </Col>
                <Col span="7">
                  <FormItem label="起赠数量">
                    <Input v-model="formData.start_give_amount"></Input>
                  </FormItem>
                </Col>
                <Col span="7">
                  <FormItem label="赠送数量">
                    <Input v-model="formData.give_amount"></Input>
                  </FormItem>
                </Col>
                <Col span="7">
                  <FormItem label="截至日期">
                    <DatePicker :editable="false" type="date" :options="optionsDate" v-model="formData.give_date"></DatePicker>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="8">
                  <Divider orientation="center">采购相关</Divider>
                  <FormItem>
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.is_new">新商品</Checkbox>
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.is_buyer">暂停采购</Checkbox>
                  </FormItem>
                  <FormItem label="采购方式">
                    <Select v-model="formData.buyer_type">
                      <Option v-for="(item,index) in selItem.purch_type" :value="index" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                  <FormItem label="主要供应商">
                    <Input v-model="formData.supplier">
                      <span slot="append" @click="openSupplier" class="icon iconfont">&#xe7fc;</span>
                    </Input>
                  </FormItem>
                  <FormItem label="采购负责人">
                    <Row>
                      <Col span="5">
                        <Input v-model="formData.buyer_id"></Input>
                      </Col>
                      <Col span="1">&nbsp;</Col>
                      <Col span="18">
                        <Input v-model="$store.state.emp[formData.buyer_id]">
                          <span slot="append" class="icon iconfont" @click="showEmpModal('buyer')">&#xe7fc;</span>
                        </Input>
                      </Col>
                    </Row>
                  </FormItem>
                  <FormItem label="采购提前">
                    <Input maxlength="10" v-model="formData.buyer_day"><span slot="append">天</span></Input>
                  </FormItem>
                  <FormItem label="最小采购量">
                    <Input v-model="formData.amount"></Input>
                  </FormItem>
                  <FormItem label="采购周期">
                    <Input maxlength="10" v-model="formData.buyer_cycle"><span slot="append">天</span></Input>
                  </FormItem>
                  <FormItem label="采购倍量">
                    <Input v-model="formData.buyer_multiple"></Input>
                  </FormItem>
                </Col>
                <Col span="8">
                  <Divider orientation="center">销售相关</Divider>
                  <FormItem>
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.is_retail">零售特价</Checkbox>
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.is_wholesale">批发特价</Checkbox>
                  </FormItem>
                  <FormItem>
                    <Checkbox :true-value="1" :false-value="0" v-model="formData.is_sale">暂停销售</Checkbox>
                  </FormItem>
                  <FormItem label="批发限量">
                    <Tooltip transfer max-width="200" placement="top" content="每单限制销量，为0或者空表示不限制。">
                      <InputNumber :active-change="false" :max="999999999" v-model="formData.wholesale_amount"></InputNumber>
                    </Tooltip>
                  </FormItem>
                  <FormItem label="零售限量">
                    <Tooltip transfer max-width="200" placement="top" content="每单限制销量，为0或者空表示不限制。">
                      <InputNumber :active-change="false" :max="999999999" v-model="formData.retail_amount"></InputNumber>
                    </Tooltip>
                  </FormItem>
                  <FormItem label="销售倍量">
                    <Tooltip transfer max-width="200" placement="top" content="这里值设置大于1的时候，在销售订单、销售开单模块对应该商品下单时，数量必须是此值的整倍数。">
                      <InputNumber :active-change="false" :max="999999999" v-model="formData.sala_multiple"></InputNumber>
                    </Tooltip>
                  </FormItem>
                  <FormItem label="销售业务员">
                    <Row>
                      <Col span="5">
                        <Input v-model="formData.salesman"></Input>
                      </Col>
                      <Col span="1">&nbsp;</Col>
                      <Col span="18">
                        <Input icon="ios-more" v-model="$store.state.emp[formData.salesman]" @on-click="showEmpModal('salesman')"></Input>
                      </Col>
                    </Row>
                  </FormItem>
                </Col>
                <Col span="8">
                  <Divider orientation="center">仓库相关</Divider>
                  <FormItem label="保质期提前报警">
                    <Input maxlength="10" v-model="formData.day"><span slot="append">天</span></Input>
                  </FormItem>
                  <FormItem label="养护方式">
                    <Select v-model="formData.tend_type">
                      <Option v-for="(item,index) in selItem.tend_type" :value="index" :key="index">{{item}}</Option>
                    </Select>
                  </FormItem>
                  <FormItem label="养护天数">
                    <Input maxlength="10" v-model="formData.tend_day"><span slot="append">天</span></Input>
                  </FormItem>
                  <FormItem label="总库存最高">
                    <Input v-model="formData.max_qty"></Input>
                  </FormItem>
                  <FormItem label="总库存最低">
                    <Input v-model="formData.min_qty"></Input>
                  </FormItem>
                </Col>
              </Row>
            </Row>
            <Row :style="{display:TabIndex=='other'?'block':'none'}" class-name="pro-property">
              <Col span="8">
                <Divider orientation="center">价格信息</Divider>
                <FormItem label="主标准进价">
                  <InputNumber :active-change="false" :max="9999999999" :min="0" v-model="formData.buyer_price"></InputNumber>
                </FormItem>
                <FormItem label="辅标准进价">
                  <InputNumber :active-change="false" :max="9999999999" :min="0" v-model="formData.buyer_price2"></InputNumber>
                </FormItem>
                <FormItem label="主标准批发价">
                  <InputNumber :active-change="false" :max="9999999999" :min="0" v-model="formData.trade_price"></InputNumber>
                </FormItem>
                <FormItem label="辅标准批发价">
                  <InputNumber :active-change="false" :max="9999999999" :min="0" v-model="formData.trade_price2"></InputNumber>
                </FormItem>
                <FormItem label="主标准零售价">
                  <InputNumber :active-change="false" :max="9999999999" :min="0" v-model="formData.retail_price"></InputNumber>
                </FormItem>
                <FormItem label="辅标准零售价">
                  <InputNumber :active-change="false" :max="9999999999" :min="0" v-model="formData.retail_price2"></InputNumber>
                </FormItem>
              </Col>
              <Col span="16">
                <Divider orientation="left">商品属性</Divider>
                <div class="fl padding-l">
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_rx">处方药</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_shopping">可网购</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_supervise">是否监管</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_gift">赠品</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_first">首营</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_vip">会员商品</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.markup">涨跌价</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_qty">不核算数量</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_check">澄明度检验</Checkbox>
                </div>
                <div class="fl padding-l">
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_variety">中标品种(禁销药店)</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_drugs">含特殊药品复方制剂</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_yymz">限售医院门诊C</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_medical">基本医疗用药</Checkbox>
                  <Checkbox :true-value="1" :false-value="0" v-model="formData.is_yi">限售医院H</Checkbox>
                </div>
              </Col>
            </Row>
          </Form>
        </div>
      </div>
    </Modal>
    <kinds-item  ref="kindsItemRef" @changeKind="getKinds" @clean="cleanKinds"></kinds-item>
    <choose-providers ref="providersRef" @confirm="suProviders"></choose-providers>
    <select-depart ref="seldep" @seldep="selDepart" @clear_sel="clearSel"></select-depart>
    <select-employee ref="selEmployeeRef" @selemp="selEmp" @clear_sel="clearEmp"></select-employee>
  </div>
</template>
<script>
  import kindsItem from "@/components/common/kindsItem"
  import chooseProviders from "@/components/common/ChooseProviders"
  import selectDepart from "@/components/common/SelectDepart"
  import selectEmployee from "@/components/common/SelectEmployee"
  var _this,
  formData={
    name:'',goods_name:'',goods_code:'',en_name:'',code:'',file_name:'',pym:'',specs:'',packspecs:'',electron_code:'', color_code:'', kinds_id:null, kinds_kid:null,kinds_name:'',category_id:null, function_id:[], origin:'', production:'', maker:'', unit:'', unit2:null, is_solit:0, solit_value:null, dosage:null, tax:null, approval_code:'', approval_date:'', shelf_life:'', shelf_unit:'', take:null, gsp_type:null, standard_code:'', supervise_code:'', pack_specs1:null,pack_specs2:null, drug:'', drug_unit:'', hours:'', element_type:null, coloc_type:null, billing_type:null, pifaml:null, retail:null,  depart_name:'',depart_id:null, markup:0, is_medical:0, is_check:0, is_qty:0, is_first:0, is_variety:0, is_rx:0, is_shopping:1, is_yi:0, is_yymz:0, is_vip:0, is_supervise:0, is_drugs:0, is_gift:0, creater:'', creater_date:'', checker:'', check_date:'', update_date:'', remark:'', abc:'', abkind:'', quality_standards:'', quality_date:'', exterior:'', brand:'', brand_date:'', level:null, gmp_code:'', gmp_property:'', gmp_end_date:'', license_key:'', license_date:'', code1:'', code1_date:'', code2:'', code2_date:'', custom_name:'', custom_val:'', custom_code1:'', custom_code2:'', custom_code3:'', start_give_amount:null, give_amount:null, times_give:0, give_date:'', integral:'', buyer_type:0, is_new:0, is_buyer:0, supplier:'', amount:null, buyer_id:null, buyer_name:'',buyer_day:'', buyer_cycle:'', buyer_multiple:'', day:'', tend_type:'', tend_day:'', storage_type:'', max_qty:null, min_qty:null, salesman:null,salesman_name:'', wholesale_amount:null, retail_amount:null, sala_multiple:null, is_sale:0, is_wholesale:0, is_retail:0, wholesale_price:null, factory_price:null, buyer_price:null, buyer_price2:null,retail_price:null,retail_price2:null,trade_price:null,trade_price2:null,status:null};
	export default {
	  components:{
      kindsItem,chooseProviders,selectDepart,selectEmployee
    },
		data:function () {
      return{
        Model:false,
        formData:JSON.parse(JSON.stringify(formData)),
        TabIndex:'base',
        goods_code:null,
        selItem:[],
        custom:[],
        category:[],
        kinds:[],
        displayUnit:false,
        solitValue:false,
        menuDate:[
          {name:'base',msg:'基本信息'},
          {name:'extend',msg:'扩展信息'},
          {name:'other',msg:'其他属性'},
        ],
        ruleData:{
          name:[
            {required:true,type:'string',message:'商品通用名称不能为空',trigger:'blur'}
          ],
          approval_code:[
            {required:true,type:'string',message:'批准文号不能为空',trigger:'blur'}
          ],
          function_id:[
            {required:true,type:'array',message:'请选择商品功能类别',trigger:'change'}
          ],
          gsp_type:[
            {required:true,type:'string',message:'请选择GSP验收类型',trigger:'change'}
          ],
          production:[
            {required:true,type:'string',message:'生产企业不能为空',trigger:'change'}
          ],
          specs:[
            {required:true,type:'string',message:'商品规格不能为空',trigger:'blur'}
          ],
          unit:[
            {required:true,type:'string',message:'请选择商品单位',trigger:'change'}
          ],
          dosage:[
            {required:true,type:'string',message:'请选择商品剂型',trigger:'change'}
          ],
          storage_type:[
            {required:true,type:'string',message:'请选择商品储存条件',trigger:'change'}
          ],
          purch_type:[
            {required:true,type:'number',message:'请选择采购方式',trigger:'change'}
          ]
        },
        optionsDate:{
          disabledDate (date){
            return date && date.valueOf() < Date.now() - 86400000;
          }
        },
        selType:'',
      }
    },
    mounted() {
	    _this=this;
    },
    methods:{
	    init:function(){
        this.common.http({
          url:'getCommodityInfo',
          data:{goods_code: this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.Model    = true;
            _this.selItem  = _this.$store.state.sysParam;
            _this.custom   = res.custom;
            _this.category = res.category;
            _this.kinds    = res.kinds;
            if(res.price.length){
              _this.formData.buyer_price  = _this.formatFloat(res.price[0].price1,6);
              _this.formData.buyer_price2 = _this.formatFloat(res.price[0].price2,6);
              _this.formData.trade_price  = _this.formatFloat(res.price[1].price1,6);
              _this.formData.trade_price2 = _this.formatFloat(res.price[1].price2,6);
              _this.formData.retail_price = _this.formatFloat(res.price[2].price1,6);
              _this.formData.retail_price2= _this.formatFloat(res.price[2].price2,6);
            }
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      changeMenu:function (name) {
        this.TabIndex = name;
      },
      //新增商品资料
      newData:function(type){
	      var datas = {data:this.formData}
        this.$refs.formMain.validate(function (status) {
          if (status){
            _this.common.http({
              url:'newCommodity',
              data:datas
            }).then(function (d) {
              if(d.status) {
                _this.Model = false;
                _this.$emit('SuData',d)
              }else{
                _this.alertMsg(d.msg,'error');
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
            })
          }else{
            _this.TabIndex = 'base';
            _this.alertMsg('保存失败！请完善商品资料后提交。','error')
          }
        });
      },
      format (labels, selectedData) {
        const index = labels.length - 1;
        const data = selectedData[index] || false;
        if (data) {
          return labels[index]
        }
        return labels[index];
      },
      changeKind:function(){
	      this.$refs.kindsItemRef.init(this.formData.kinds_id,true);
      },
      getKinds:function (e) {
        this.formData.kinds_kid = e.id;
        this.formData.kinds_name= e.name;
        this.formData.kinds_id  = e.parent_id;
      },
      cleanKinds:function () {
        this.formData.kinds_kid = null;
        this.formData.kinds_name= '';
        this.formData.kinds_id  = null;
      },
      openSupplier:function(){
	      this.$refs.providersRef.open();
      },
      suProviders:function (e) {
	      this.formData.supplier = e.supplier_code;
      },
      showDepartModal:function(){
        this.$refs.seldep.init({show_self:1});
      },
      //选择部门
      selDepart:function (e) {
	      this.formData.depart_name = e.dept_name;
	      this.formData.depart_id   = e.id;
      },
      //清除已选择的部门选项
      clearSel:function (e) {
        this.formData.depart_name = '';
        this.formData.depart_id   = null;
      },
      showEmpModal:function(name){
	      this.selType = name;
	      this.$refs.selEmployeeRef.init({show_self:1});
      },
      selEmp:function(e){
	      if (this.selType=='buyer'){
	        this.formData.buyer_id = e.code;
          this.formData.buyer_name = e.name;
        }else if (this.selType=='salesman'){
          this.formData.salesman = e.code;
          this.formData.salesman_name = e.name;
        }
      },
      clearEmp:function (e) {
        if (this.selType=='buyer'){
          this.formData.buyer_id = null;
          this.formData.buyer_name = '';
        }else if (this.selType=='salesman'){
          this.formData.salesman = null;
          this.formData.salesman_name = '';
        }
      },
      open:function (data,code) {
        this.formData    = JSON.parse(JSON.stringify(data));
        this.displayUnit = data.unit2;
        this.solitValue  = data.solit_value;
        this.goods_code  = code;
        this.init();
      }
    }
	}
</script>

<style lang="less">
  .min1000{
    .ivu-modal-body{
      overflow: auto;
    }
  }
  .menu-nav{
    display: flex;min-width: 968px;
    .menu-le{
      flex-shrink: 0;width: 104px;
      .nav-menu{
        .ivu-btn{
          margin-bottom: 10px;
        }
      }
      .err-title{
        padding: 10px 12px;font-size: 29px;text-align: center;
      }
    }
    .menu-ri{
      flex-grow: 1;
      .pro-property{
        .fl{float: left;}
        .padding-l{padding-left: 32px;}
        .ivu-checkbox-wrapper{display: block;}
      }
      .ivu-divider-horizontal{margin: 8px 0;}
      .ivu-form-item-content{height: 28px;}
    }
  }
</style>
