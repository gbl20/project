<template>
  <div class="main">
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu tright">
          <Button @click="save_cust"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button @click="delView()"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
        </div>
      </div>
      <div slot="table-list" class="customer-editform" :style="'height:'+height+'px;overflow: auto;max-width:1920px;'">
        <Form ref="formProData" :model="cdata" :rules="ruleValidate" :label-width="80" style="padding-top: 5px;">
          <Row>
            <Col span="10">
              <Row>
              <Col span="12">
                <FormItem label="客户编号">
                  <Input :value="cdata.id" placeholder="保存时将自动生成" disabled></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="客户简称" prop="sname">
                  <Input v-model="cdata.sname"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
                <FormItem label="客户全称" prop="name">
                  <Input v-model="cdata.name"></Input>
                </FormItem>
              </Row>
              <Row>
              <Col span="8">
                <FormItem label="部门">
                  <Input v-model="cdata.depart"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="助记码">
                  <Input v-model="cdata.mnecode"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="父级编号">
                  <Input readonly :value="cdata.parlevel" icon="ios-more" style="cursor: pointer;" @on-click="show_selcust"></Input>
                </FormItem>
              </Col>
              </Row>
                <Row>
              <Col span="12">
                <FormItem label="联系人">
                  <Input v-model="cdata.man"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="联系电话">
                  <Input v-model="cdata.mannumber"></Input>
                </FormItem>
              </Col>
                </Row>
              <Row>
              <Col span="16">
                <FormItem label="公司地址" prop="comarea">
                  <Input v-model="cdata.comarea"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="送货顺序">
                  <Input v-model="cdata.deliorder"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="16">
                <FormItem label="仓库地址">
                  <Input v-model="cdata.warehouse"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="送货线路">
                  <Input readonly :value="cdata.deliroute" icon="ios-more" style="cursor: pointer;" @on-click="show_seldeliv('deliroute')"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="16">
                <FormItem label="仓库地址2">
                  <Input v-model="cdata.swarehouse"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="送货线路2">
                  <Input readonly :value="cdata.sdeliroute" icon="ios-more" style="cursor: pointer;" @on-click="show_seldeliv('sdeliroute')"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="16">
                <FormItem label="仓库地址3">
                  <Input v-model="cdata.twarehouse"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="送货线路3">
                  <Input readonly :value="cdata.tdeliroute" icon="ios-more" style="cursor: pointer;" @on-click="show_seldeliv('tdeliroute')"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="手机">
                  <Input v-model="cdata.telephone"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="传真">
                  <Input v-model="cdata.faxed"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="企业类型" prop="typebus">
                  <Select v-model="cdata.typebus">
                    <Option :value="p" v-for="(p,key) in cfg.custom_type" :key="key">{{p}}</Option>
                  </Select>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="所有制性质">
                  <Input v-model="cdata.owner"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="经营方式" prop="opermode">
                  <Input v-model="cdata.opermode"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="质量管理达标情况" prop="quacontril">
                  <Input v-model="cdata.quacontril"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="企业法人">
                  <Input v-model="cdata.corentity"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="法人职务">
                  <Input v-model="cdata.corposition"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="法定资格">
                  <Input v-model="cdata.capacity"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="客户分类">
                  <Select filterable allow-create v-model="cdata.custlass" @on-create="create_custlass">
                    <Option :value="p.label" v-for="(p,key) in cfg.custlass" :key="key">{{p.label}}</Option>
                  </Select>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="所在地区">
                  <Input readonly :value="cdata.areatxt" icon="ios-more" style="cursor: pointer;" @on-click="show_selarea"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="邮编">
                  <Input v-model="cdata.postcode"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="业务负责人">
                  <Input readonly :value="cdata.charge" icon="ios-more" style="cursor: pointer;" @on-click="show_selemp"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="业务授权书有效期">
                  <DatePicker type="date" v-model="cdata.busauthoruse_date"></DatePicker>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="开户银行" prop="accoutbank">
                  <Input v-model="cdata.accoutbank"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="账号" prop="bankid">
                  <Input v-model="cdata.bankid"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="16">
                <FormItem label="税号" prop="taxcode">
                  <Input v-model="cdata.taxcode"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="ABC分类">
                  <Select v-model="cdata.abccla" transfer>
                    <Option :value="p" v-for="(p,key) in cfg.abc_type" :key="key">{{p}}</Option>
                  </Select>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="信用额度">
                  <Input type="number" v-model="cdata.quota"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="信用天数">
                  <Input type="number" v-model="cdata.quotadata"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="价格方案">
                  <Select v-model="cdata.priceshe" transfer>
                    <Option :value="key" v-for="(p,key) in cfg.price_system" :key="key">{{p}}</Option>
                  </Select>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="价格系数">
                  <Input type="number" v-model="cdata.pricecoeff"></Input>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="16">
                <FormItem label="统一监管码">
                  <Input v-model="cdata.monitcode"></Input>
                </FormItem>
              </Col>
              <Col span="8">
                <FormItem label="结算方式">
                  <Select v-model="cdata.settlemode" transfer>
                    <Option value="A">月结</Option>
                  </Select>
                </FormItem>
              </Col>
              </Row>
              <Row>
              <Col span="12">
                <FormItem label="所属部门">
                  <Input readonly :value="cdata.dept_name" icon="ios-more" style="cursor: pointer;" @on-click="show_seldep"></Input>
                </FormItem>
              </Col>
              <Col span="12">
                <FormItem label="备注">
                  <Input v-model="cdata.remark"></Input>
                </FormItem>
              </Col>
              </Row>
            </Col>
            <Col span="14">
              <Row>
                <Col span="14">
                  <FormItem label="营业执照号" :label-width="140">
                    <Input v-model="cdata.busliceid"></Input>
                  </FormItem>
                  <FormItem label="药品经营许可证编号" :label-width="140">
                    <Input v-model="cdata.medbusliceid"></Input>
                  </FormItem>
                  <FormItem label="医疗许可证编号" :label-width="140">
                    <Input v-model="cdata.medpremit"></Input>
                  </FormItem>
                  <FormItem label="GSP证书编号" :label-width="140">
                    <Input v-model="cdata.gspid"></Input>
                  </FormItem>
                  <FormItem label="组织机构代码证编号" :label-width="140">
                    <Input v-model="cdata.organid"></Input>
                  </FormItem>
                  <FormItem label="食品经营许可证编号" :label-width="140">
                    <Input v-model="cdata.foodbusid"></Input>
                  </FormItem>
                  <FormItem label="保健品经营许可证编号" :label-width="140">
                    <Input v-model="cdata.healthid"></Input>
                  </FormItem>
                  <FormItem label="医疗器械许可证编号" :label-width="140">
                    <Input v-model="cdata.medmentid"></Input>
                  </FormItem>
                  <FormItem label="自定义证书(1)编号" :label-width="140">
                    <Input v-model="cdata.customoid"></Input>
                  </FormItem>
                  <FormItem label="自定义证书(2)编号" :label-width="140">
                    <Input v-model="cdata.customsid"></Input>
                  </FormItem>
                  <FormItem label="控销类别" :label-width="140">
                    <Select v-model="cdata.control" transfer>
                      <Option value="A">控销</Option>
                    </Select>
                  </FormItem>
                </Col>
                <Col span="10">
                  <FormItem label="营业执照有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.busliceuse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="药品经营许可证有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.medbusliceuse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="医疗许可证有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.medpremituse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="GSP证书有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.gspuse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="组织机构代码证有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.organuse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="食品经营许可证有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.foodbususe_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="保健品经营许可证有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.healthuse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="医疗器械许可证有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.medmentuse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="自定义证书(1)有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.customouse_date" transfer></DatePicker>
                  </FormItem>
                  <FormItem label="自定义证书(2)有效期" :label-width="150">
                    <DatePicker type="date" v-model="cdata.customsuse_date" transfer></DatePicker>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <FormItem label="许可经营类别" :label-width="140">
                  <div class="showddk border-color" @click="show_selddk">
                    <div class="ddkdout">
                      <div class="ddklist txt-color" v-for="p in selddk_txt">{{p.pname||''}}<span class="ddkicon iconfont">&#xe7eb;</span>{{p.name||''}}</div>
                    </div>
                  </div>
                </FormItem>
              </Row>
              <Row><div class="ddkline"><Divider orientation="center" size="small">质量管理机构</Divider></div></Row>
              <Row>
                <Col span="7">
                  <FormItem label="负责人姓名" :label-width="90">
                    <Input v-model="cdata.qualityman"></Input>
                  </FormItem>
                </Col>
                <Col span="4">
                  <FormItem label="人数" :label-width="50">
                    <Input type="number" v-model="cdata.qmnumber"></Input>
                  </FormItem>
                </Col>
                <Col span="8">
                  <FormItem label="联系电话" :label-width="75">
                    <Input type="number" v-model="cdata.qmphone"></Input>
                  </FormItem>
                </Col>
                <Col span="5">
                  <FormItem label="" :label-width="30">
                    <Checkbox v-model="cdata.stopuser" :true-value="1" :false-value="0">暂停往来</Checkbox>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="3">
                  <FormItem label="" :label-width="20">
                    <Checkbox v-model="cdata.ismem" :true-value="1" :false-value="0">会员</Checkbox>
                  </FormItem>
                </Col>
                <Col span="5">
                  <FormItem label="" :label-width="0">
                    <Checkbox v-model="cdata.agreekind" :true-value="1" :false-value="0">可记录协议品种</Checkbox>
                  </FormItem>
                </Col>
                <Col span="4">
                  <FormItem label="" :label-width="0">
                    <Checkbox v-model="cdata.dataable" :true-value="1" :false-value="0">资料有效</Checkbox>
                  </FormItem>
                </Col>
                <Col span="5">
                  <FormItem label="创建人" :label-width="60">
                    <Input v-model="cdata.createmanid" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="7">
                  <FormItem label="创建时间" :label-width="73">
                    <DatePicker type="datetime" v-model="cdata.create_date" transfer disabled></DatePicker>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="6">
                  <FormItem label="修改人" :label-width="70">
                    <Input v-model="cdata.editmanid" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="9">
                  <FormItem label="修改时间" :label-width="90">
                    <DatePicker type="datetime" v-model="cdata.edit_date" transfer disabled></DatePicker>
                  </FormItem>
                </Col>
                <Col span="9">
                  <FormItem label="自定义编号" :label-width="110">
                    <Input v-model="cdata.customid"></Input>
                  </FormItem>
                </Col>
              </Row>
            </Col>
          </Row>
        </Form>
      </div>
    </split-none>
    <select-customer ref="selcust" @selcust="select_cust" @clear_sel="clear_sel" :show_clear="true"></select-customer>
    <select-delivery ref="seldelivery" @seldeliv="select_deliv" @clear_sel="clear_sel" :show_clear="true"></select-delivery>
    <select-area ref="selarea" @selarea="select_area" @clear_sel="clear_sel" :show_clear="true"></select-area>
    <select-employee ref="selemp" @selemp="select_emp" @clear_sel="clear_sel" :show_clear="true"></select-employee>
    <select-depart ref="seldep" @seldep="select_dep" @clear_sel="clear_sel" :show_clear="true"></select-depart>
    <select-ddkind ref="selddk" @selddk="select_ddk" @clear_sel="clear_sel"></select-ddkind>
  </div>
</template>
<script>
import splitNone from '@/components/public/splitNone'
import selectCustomer from '@/components/common/SelectCustomer'
import selectDelivery from '@/components/common/SelectDelivery'
import selectArea from '@/components/common/SelectArea'
import selectEmployee from '@/components/common/SelectEmployee'
import SelectDepart from '@/components/common/SelectDepart'
import SelectDdkind from '@/components/common/SelectDdkind'
var _this;
export default {
  components:{splitNone,selectCustomer,selectDelivery,selectArea,selectEmployee,SelectDepart,SelectDdkind},
  name:'editCustomer',
  data() {
    return {
      id:'',
      Breadcrumb:[{title:'客户资料'}],
      cdata:{sname:'',name:'',typebus:'',stopuser:0,ismem:0,agreekind:0,dataable:0},
      selddk:[],
      selddk_txt:[],
      cfg:{custom_type:[],custlass:[]},
      ruleValidate:{
        sname:[{type:'string',required:true,message:'请填写客户简称',trigger:'blur'}],
        name:[{type:'string',required:true,message:'请填写客户全称',trigger:'blur'}],
        comarea:[{type:'string',required:true,message:'请填写公司地址',trigger:'blur'}],
        typebus:[{type:'string',required:true,message:'请选择企业类型',trigger:'change'}],
        opermode:[{type:'string',required:true,message:'请填写经营方式',trigger:'blur'}],
        quacontril:[{type:'string',required:true,message:'请填写质量管理达标情况',trigger:'blur'}],
        accoutbank:[{type:'string',required:true,message:'请填写开户银行',trigger:'blur'}],
        bankid:[{type:'string',required:true,message:'请填写银行账号',trigger:'blur'}],
        taxcode:[{type:'string',required:true,message:'请填写税号',trigger:'blur'}],
      },
      height:0,
      sub_lock:0
    }
  },
  created:function() {
    _this=this;
    this.id = this.$route.query.id;
    this.$route.meta.isBack = true;
  },
  activated:function(){
    if(typeof(this.$route.query.id)!=="undefined"){ //点击新增/编辑
      this.id = this.$route.query.id;
      localStorage.setItem('customer_editid',this.id);
      this.init();
    }else{//底部tab切换
      if(typeof(this.id)=="undefined"){
        this.id=localStorage.getItem('customer_editid');
        this.init();
      }
      this.$router.push({query:{id:this.id}});
    }
    this.Breadcrumb=this.id!=''?[{title:'资料管理'},{title:'客户资料',url:'customer'},{title:'修改客户资料'}]:[{title:'资料管理'},{title:'客户资料',url:'customer'},{title:'新增客户'}];
  },
  methods: {
    init:function () {
      this.common.http({
        url:'customerEdit',
        data:{id:this.id}
      }).then(function (d) {
        if(d.status==1){
          _this.cdata = d.data;
          _this.cfg = d.cfg;
          _this.selddk = d.selddk;
          _this.selddk_txt = d.selddk_txt;
        }else{
          _this.alertMsg(d.msg,'error',{duration:0,isClosable:true});
        }
        _this.sub_lock=0;
      }).catch(function (err) {
        _this.common.httpErr(err.data,_this)
      })
    },
    DHeight:function(e){
      this.height = e;
    },
    /**
     * 保存新增或修改
     */
    save_cust:function(){
      if(_this.sub_lock) return false;
      this.$refs.formProData.validate(function(valid){
        if(valid){
          _this.sub_lock=1;
          _this.common.http({
            url:'saveCust',
            data:_this.cdata
          }).then(function (d) {
            if(d.status==1){
              _this.$router.push({query:{id:d.id}});
              _this.id = d.id;
              _this.alertMsg(d.msg);
              _this.init();
            }else{
              _this.sub_lock=0;
              _this.alertMsg(d.msg,'error')
            }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          })
        }else{
          _this.alertMsg('请填写必填资料后再提交！','error');
        }
      })
    },
    /**
     * 打开客户选择组件
     */
    show_selcust:function () {
      this.$refs.selcust.init({
        noid:_this.id
      })
    },
    /**
     * 选择父级ID
     */
    select_cust:function (data) {
      this.$set(this.cdata,'parlevel',data.id);
    },
    /**
     * 打开线路选择组件
     */
    show_seldeliv:function (key) {
      this.$refs.seldelivery.init({set_key:key})
    },
    /**
     * 清除选择的选项
     */
    clear_sel:function (key) {
      this.cdata[key]=null;
    },
    /**
     * 选择送货线路
     */
    select_deliv:function (data) {
      this.$set(this.cdata,data.set_key,data.data.dname);
    },
    /**
     * 打开地区选择组件
     */
    show_selarea:function () {
      this.$refs.selarea.init({})
    },
    /**
     * 选择地区
     */
    select_area:function (data) {
      this.$set(this.cdata,'area',data.area);
      this.$set(this.cdata,'areatxt',data.areatxt);
    },
    /**
     * 打开员工选择组件
     */
    show_selemp:function () {
      this.$refs.selemp.init({})
    },
    /**
     * 确定选择员工
     */
    select_emp:function (data) {
      this.$set(this.cdata,'charge',data.code);
    },
    /**
     * 打开部门选择组件
     */
    show_seldep:function () {
      this.$refs.seldep.init({});
    },
    /**
     * 确定选择部门
     */
    select_dep:function (data) {
      this.$set(this.cdata,'department',data.id);
      this.$set(this.cdata,'dept_name',data.dept_name);
    },
    /**
     * 打开经营类别选择
     */
    show_selddk:function () {
      this.$refs.selddk.init({selddk:this.selddk});
    },
    /**
     * 选择经营类别
     */
    select_ddk:function (data) {
      this.selddk=data;
      if(data.length==0){
        this.cdata.ddkindid=null;
      }else{
        this.cdata.ddkindid=data.join(',');
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
    /**
     * 新增客户分类
     */
    create_custlass:function (va) {
      this.cfg.custlass.push({value:va,label:va});
    }
  }
};
</script>
<style lang="less">
.customer-editform .showddk{
  height: 237px; padding: 5px 0; border-style: solid; border-width: 1px; border-radius: 4px; cursor: pointer; flex-wrap: wrap; box-sizing: border-box; overflow: auto;
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
.customer-editform .ddkline{padding: 0 20px;}
</style>
