<template>
  <div class="main custexam">
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="table-list" :style="'display:flex;display:-ms-flexbox; display:-webkit-flex;height:'+height+'px;overflow:hidden;'">
        <div class="pro-list">
          <Table border :row-class-name="rowClassName" :columns="columns" :data="data" :height="height" size="small" @on-row-click="sel_column">
            <template slot-scope="row" slot="stopuser">
              <Checkbox :value="row.row.stopuser" :true-value="1" :false-value="0" disabled></Checkbox>
            </template>
            <template slot-scope="row" slot="sales_man">{{$store.state.emp[row.row.sales_man]}}</template>
            <template slot-scope="row" slot="quality_adm">{{$store.state.emp[row.row.quality_adm]}}</template>
            <template slot-scope="row" slot="quality_depart">{{$store.state.emp[row.row.quality_depart]}}</template>
            <template slot-scope="row" slot="quality_man">{{$store.state.emp[row.row.quality_man]}}</template>
            <template slot-scope="row" slot="ismem">
              <Checkbox :value="row.row.ismem" :true-value="1" :false-value="0" disabled></Checkbox>
            </template>
            <template slot-scope="row" slot="createmanid">{{$store.state.emp[row.row.createmanid]}}</template>
            <template slot-scope="row" slot="editmanid">{{$store.state.emp[row.row.editmanid]}}</template>
          </Table>
        </div>
        <div class="exam-right">
          <Form :label-width="80">
            <Col span="16">
              <Row>
                <div :class="'exam-status exam'+seldata.isvalid">{{seldata.isvalid?'资质已审核合格':'客户资质待审核'}}</div>
              </Row>
              <Row>
                <Col span="8">
                  <FormItem label="客户编号">
                    <Input disabled :value="seldata.id"></Input>
                  </FormItem>
                </Col>
                <Col span="16">
                  <FormItem label="客户简称">
                    <Input disabled :value="seldata.sname"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <FormItem label="客户全称">
                  <Input disabled :value="seldata.name"></Input>
                </FormItem>
              </Row>
              <Row>
                <Col span="8">
                  <FormItem label="助记码">
                    <Input disabled :value="seldata.mnecode"></Input>
                  </FormItem>
                </Col>
                <Col span="7">
                  <FormItem label="联系人" :label-width="60">
                    <Input disabled :value="seldata.man"></Input>
                  </FormItem>
                </Col>
                <Col span="9">
                  <FormItem label="联系电话">
                    <Input disabled :value="seldata.mannumber"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <FormItem label="公司地址">
                  <Input disabled :value="seldata.comarea"></Input>
                </FormItem>
              </Row>
              <Row>
                <Col span="15">
                  <FormItem label="仓库地址">
                    <Input disabled :value="seldata.warehouse"></Input>
                  </FormItem>
                </Col>
                <Col span="9">
                  <FormItem label="送货线路">
                    <Input disabled :value="seldata.deliroute"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="12">
                  <FormItem label="手机">
                    <Input disabled :value="seldata.telephone"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="传真">
                    <Input disabled :value="seldata.faxed"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="12">
                  <FormItem label="企业类型">
                    <Input disabled :value="seldata.typebus"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="所有制性质" :label-width="95">
                    <Input disabled :value="seldata.owner"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="10">
                  <FormItem label="经营方式">
                    <Input disabled :value="seldata.opermode"></Input>
                  </FormItem>
                </Col>
                <Col span="14">
                  <FormItem label="质量管理达标情况" :label-width="125">
                    <Input disabled :value="seldata.quacontril"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="11">
                  <FormItem label="企业法人">
                    <Input disabled :value="seldata.corentity"></Input>
                  </FormItem>
                </Col>
                <Col span="13">
                  <FormItem label="法人职务">
                    <Input disabled :value="seldata.corposition"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="11">
                  <FormItem label="法定资格">
                    <Input disabled :value="seldata.capacity"></Input>
                  </FormItem>
                </Col>
                <Col span="13">
                  <FormItem label="客户分类">
                    <Input disabled :value="seldata.custlass"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="13">
                  <FormItem label="所在地区">
                    <Input disabled :value="seldata.area"></Input>
                  </FormItem>
                </Col>
                <Col span="11">
                  <FormItem label="邮编">
                    <Input disabled :value="seldata.postcode"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="10">
                  <FormItem label="业务负责人">
                    <Input disabled :value="$store.state.emp[seldata.charge]"></Input>
                  </FormItem>
                </Col>
                <Col span="14">
                  <FormItem label="业务授权书有效期" :label-width="120">
                    <Input disabled :value="seldata.busauthoruse_date"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="12">
                  <FormItem label="开户银行">
                    <Input disabled :value="seldata.accoutbank"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="账号" :label-width="60">
                    <Input disabled :value="seldata.bankid"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="14">
                  <FormItem label="税号">
                    <Input disabled :value="seldata.taxcode"></Input>
                  </FormItem>
                </Col>
                <Col span="10">
                  <FormItem label="ABC分类">
                    <Input disabled :value="seldata.abccla"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <Col span="13">
                  <FormItem label="统一监管码">
                    <Input disabled :value="seldata.monitcode"></Input>
                  </FormItem>
                </Col>
                <Col span="11">
                  <FormItem label="所属部门">
                    <Input disabled :value="$store.state.depart[seldata.department]"></Input>
                  </FormItem>
                </Col>
              </Row>
              <Row>
                <FormItem label="备注">
                  <Input disabled :value="seldata.remark"></Input>
                </FormItem>
              </Row>
              <Row>
                <Col span="9">
                  <FormItem label="质量管理机构负责人">
                    <Input disabled :value="seldata.qualityman"></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="人数" :label-width="50">
                    <Input disabled :value="seldata.qmnumber"></Input>
                  </FormItem>
                </Col>
                <Col span="9">
                  <FormItem label="联系电话">
                    <Input disabled :value="seldata.qmphone"></Input>
                  </FormItem>
                </Col>
              </Row>
            </Col>
            <Col span="8">
              <FormItem label="营业执照编号">
                <Input disabled :value="seldata.busliceid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.busliceuse_date"></Input>
              </FormItem>
              <FormItem label="药品经营许可证编号">
                <Input disabled :value="seldata.medbusliceid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.medbusliceuse_date"></Input>
              </FormItem>
              <FormItem label="医疗许可证">
                <Input disabled :value="seldata.medpremit"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.medpremituse_date"></Input>
              </FormItem>
              <FormItem label="GSP证书编号">
                <Input disabled :value="seldata.gspid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.gspuse_date"></Input>
              </FormItem>
              <FormItem label="组织机构代码证编号">
                <Input disabled :value="seldata.organid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.organuse_date"></Input>
              </FormItem>
              <FormItem label="食品经营许可证">
                <Input disabled :value="seldata.foodbusid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.foodbususe_date"></Input>
              </FormItem>
              <FormItem label="保健品经营许可证">
                <Input disabled :value="seldata.healthid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.healthuse_date"></Input>
              </FormItem>
              <FormItem label="医疗器械经营许可证">
                <Input disabled :value="seldata.medmentid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.medmentuse_date"></Input>
              </FormItem>
              <FormItem label="自定义证书(1)编号">
                <Input disabled :value="seldata.customoid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.customouse_date"></Input>
              </FormItem>
              <FormItem label="自定义证书(2)编号">
                <Input disabled :value="seldata.customsid"></Input>
              </FormItem>
              <FormItem label="有效期">
                <Input disabled :value="seldata.customsuse_date"></Input>
              </FormItem>
            </Col>
          </Form>
        </div>
      </div>
    </split-none>
    <div class="exambottom border-color">
      <div class="exam-foot">
        <Form :label-width="120">
          <Row style="width: 1000px;">
            <Col span="6">
              <FormItem label="销售部负责人">
                <Input disabled :value="seldata.sales_man_status?$store.state.emp[seldata.sales_man]:''"></Input>
              </FormItem>
              <FormItem label="质量管理员">
                <Input disabled :value="seldata.quality_adm_status?$store.state.emp[seldata.quality_adm]:''"></Input>
              </FormItem>
              <FormItem label="质量管理部负责人">
                <Input disabled :value="seldata.quality_depart_status?$store.state.emp[seldata.quality_depart]:''"></Input>
              </FormItem>
              <FormItem label="质量负责人">
                <Input disabled :value="seldata.quality_man_status?$store.state.emp[seldata.quality_man]:''"></Input>
              </FormItem>
            </Col>
            <Col span="6">
              <FormItem label="审核时间" :label-width="80">
                <Input disabled :value="seldata.sales_man_status?seldata.sales_man_date:''"></Input>
              </FormItem>
              <FormItem label="审核时间" :label-width="80">
                <Input disabled :value="seldata.quality_adm_status?seldata.quality_adm_date:''"></Input>
              </FormItem>
              <FormItem label="审核时间" :label-width="80">
                <Input disabled :value="seldata.quality_depart_status?seldata.quality_depart_date:''"></Input>
              </FormItem>
              <FormItem label="审核时间" :label-width="80">
                <Input disabled :value="seldata.quality_man_status?seldata.quality_man_date:''"></Input>
              </FormItem>
            </Col>
            <Col span="9">
              <FormItem label="销售部负责人意见">
                <Input :disabled="seldata.isvalid?true:false" v-model="seldata.sales_man_remark" :maxlength="150"></Input>
              </FormItem>
              <FormItem label="质量管理员意见">
                <Input :disabled="seldata.isvalid?true:false" v-model="seldata.quality_adm_remark" :maxlength="150"></Input>
              </FormItem>
              <FormItem label="质量管理部意见">
                <Input :disabled="seldata.isvalid?true:false" v-model="seldata.quality_depart_remark" :maxlength="150"></Input>
              </FormItem>
              <FormItem label="质量负责人意见">
                <Input :disabled="seldata.isvalid?true:false" v-model="seldata.quality_man_remark" :maxlength="150"></Input>
              </FormItem>
            </Col>
            <Col span="3" style="padding-left: 15px;">
              <FormItem :label-width="5"><Button :disabled="seldata.isvalid?true:false" @click="chooseOp('sales_depart')"><span class="icon iconfont">&#xe7fe;</span>{{seldata.sales_man_status?'已审核':'审核'}}</Button></FormItem>
              <FormItem :label-width="5"><Button :disabled="seldata.isvalid?true:false" @click="chooseOp('quality_admin')"><span class="icon iconfont">&#xe7fe;</span>{{seldata.quality_adm_status?'已审核':'审核'}}</Button></FormItem>
              <FormItem :label-width="5"><Button :disabled="seldata.isvalid?true:false" @click="chooseOp('quality_depart')"><span class="icon iconfont">&#xe7fe;</span>{{seldata.quality_depart_status?'已审核':'审核'}}</Button></FormItem>
              <FormItem :label-width="5"><Button :disabled="seldata.isvalid?true:false" @click="chooseOp('quality_director')"><span class="icon iconfont">&#xe7fe;</span>{{seldata.quality_man_status?'已审核':'审核'}}</Button></FormItem>
            </Col>
          </Row>
          <Row class-name="border-t" style="padding-top: 5px;">
            <FormItem label="快速筛选：">
              <RadioGroup v-model="search.isvalid" @on-change="init">
                <Radio :label="2">全部客户</Radio>
                <Radio :label="1">已通过资质审核的客户</Radio>
                <Radio :label="0">未审核的客户</Radio>
              </RadioGroup>
              <div class="ctips">提示：资质审核后如果修改了客户资料，则需要重新审核</div>
              <Button @click="init" style="margin-left: 50px;"><span class="icon iconfont">&#xe788;</span>刷新</Button>
            </FormItem>
          </Row>
        </Form>
      </div>
      <verify-user ref="verifyUserRef" :postCode="postCode" :paramData="{id:seldata.id,remark:seldata.check_remark}" processingMethod="checkUser" @confirm="confirmOp"></verify-user>
    </div>
  </div>
</template>
<script>
var _this;
import splitNone from '@/components/public/splitNone'
import verifyUser from '@/components/common/VerifyUser'
export default {
  components:{splitNone,verifyUser},
  name:'customer',
  data() {
    return {
      height:0,
      bheight:0,
      showSearch:false,
      Breadcrumb:[{title:'GSP'},{title:'客户资质审核'}],
      columns: [
        {title:'客户编号',key:'id',width:80,resizable:true,ellipsis :true},
        {title:'客户简称',key:'sname',width:100,resizable:true,ellipsis :true},
        {title:'客户全称',key:'name',width:180,resizable:true,ellipsis :true},
        {title:'助记码',key:'mnecode',width:80,resizable:true,ellipsis :true},
        {title:'ABC分类',key:'abccla',width:72,resizable:true,ellipsis :true},
        {title:'企业类型',key:'typebustxt',width:100,resizable:true,ellipsis :true},
        {title:'供方部门',key:'depart',width:72,resizable:true,ellipsis :true},
        {title:'经营方式',key:'opermode',width:72,resizable:true,ellipsis :true},
        {title:'经营范围',key:'ddkindtxt',width:500,resizable:true,tooltip:true},
        {title:'企业法人',key:'corentity',width:72,resizable:true,ellipsis :true},
        {title:'法人职务',key:'corposition',width:72,resizable:true,ellipsis :true},
        {title:'所有制性质',key:'owner',width:86,resizable:true,ellipsis :true},
        {title:'质量管理达标情况',key:'quacontril',width:126,resizable:true,ellipsis :true},
        {title:'证照号码',key:'busliceid',width:160,resizable:true,ellipsis :true},
        {title:'药品经营许可证编号',key:'medbusliceid',width:160,resizable:true,ellipsis :true},
        {title:'医疗许可证',key:'medpremit',width:190,resizable:true,ellipsis :true},
        {title:'法定资格',key:'capacity',width:90,resizable:true,ellipsis :true},
        {title:'业务负责人',key:'charge',width:84,resizable:true,ellipsis :true},
        {title:'客户地区',key:'area',width:90,resizable:true,ellipsis :true},
        {title:'公司地址',key:'comarea',width:180,resizable:true,ellipsis :true},
        {title:'客户采购人员',key:'man',width:96,resizable:true,ellipsis :true},
        {title:'仓库地址',key:'warehouse',width:180,resizable:true,ellipsis :true},
        {title:'办公电话',key:'mannumber',width:110,resizable:true,ellipsis :true},
        {title:'传真',key:'faxed',width:110,resizable:true,ellipsis :true},
        {title:'开户银行',key:'accoutbank',width:120,resizable:true,ellipsis :true},
        {title:'账号',key:'bankid',width:170,resizable:true,ellipsis :true},
        {title:'税号',key:'taxcode',width:160,resizable:true,ellipsis :true},
        {title:'信用额度',key:'quota',width:90,resizable:true,ellipsis :true},
        {title:'信用天数',key:'quotadata',width:72,resizable:true,ellipsis :true},
        {title:'暂停往来',slot:'stopuser',width:72,resizable:true,ellipsis :true},//暂停往来
        {title:'价格方案',key:'priceshetxt',width:90,resizable:true,ellipsis :true},
        {title:'价格系数',key:'pricecoeff',width:72,resizable:true,ellipsis :true},
        {title:'结算方式',key:'settlemodetxt',width:72,resizable:true,ellipsis :true},
        {title:'备注',key:'remark',width:120,resizable:true,ellipsis :true},
        {title:'药品经营许可证有效期',key:'medbusliceuse_date',width:152,resizable:true,ellipsis :true},
        {title:'客户分类',key:'custlass',width:100,resizable:true,ellipsis :true},
        {title:'质量管理机构负责人',key:'qualityman',width:140,resizable:true,ellipsis :true},
        {title:'质量管理机构人数',key:'qmnumber',width:128,resizable:true,ellipsis :true},
        {title:'质量管理机构电话',key:'qmphone',width:128,resizable:true,ellipsis :true},
        {title:'营业执照有效期',key:'busliceuse_date',width:110,resizable:true,ellipsis :true},
        {title:'医疗许可证有效期',key:'medpremituse_date',width:128,resizable:true,ellipsis :true},
        {title:'GSP证书号',key:'gspid',width:150,resizable:true,ellipsis :true},
        {title:'GSP证书有效期',key:'gspuse_date',width:110,resizable:true,ellipsis :true},
        {title:'统一监管码',key:'monitcode',width:130,resizable:true,ellipsis :true},
        {title:'保健食品经营许可证编号',key:'healthid',width:190,resizable:true,ellipsis :true},
        {title:'保健食品经营许可证有效期',key:'healthuse_date',width:176,resizable:true,ellipsis :true},
        {title:'医疗器械经营许可证编号',key:'medmentid',width:230,resizable:true,ellipsis :true},
        {title:'医疗器械经营许可证有效期',key:'medmentuse_date',width:176,resizable:true,ellipsis :true},
        {title:'业务员授权书有效期',key:'busauthoruse_date',width:140,resizable:true,ellipsis :true},
        {title:'组织机构代码证编号',key:'organid',width:140,resizable:true,ellipsis :true},
        {title:'组织机构代码证有效期',key:'organuse_date',width:148,resizable:true,ellipsis :true},
        {title:'自定义证书1编号',key:'customoid',width:190,resizable:true,ellipsis :true},
        {title:'自定义证书1有效期',key:'customouse_date',width:136,resizable:true,ellipsis :true},
        {title:'自定义证书2编号',key:'customsid',width:190,resizable:true,ellipsis :true},
        {title:'自定义证书2有效期',key:'customsuse_date',width:136,resizable:true,ellipsis :true},
        {title:'食品经营许可证编号',key:'foodbusid',width:190,resizable:true,ellipsis :true},
        {title:'食品经营许可证有效期',key:'foodbususe_date',width:150,resizable:true,ellipsis :true},
        {title:'邮编',key:'postcode',width:72,resizable:true,ellipsis :true},
        {title:'移动电话',key:'telephone',width:110,resizable:true,ellipsis :true},
        {title:'送货线路',key:'deliroute',width:72,resizable:true,ellipsis :true},
        {title:'所属部门',key:'department',width:72,resizable:true,ellipsis :true},
        {title:'送货顺序号',key:'deliorder',width:82,resizable:true,ellipsis :true},
        {title:'仓库地址2',key:'swarehouse',width:180,resizable:true,ellipsis :true},
        {title:'送货线路2',key:'sdeliroute',width:80,resizable:true,ellipsis :true},
        {title:'仓库地址3',key:'twarehouse',width:180,resizable:true,ellipsis :true},
        {title:'送货线路3',key:'tdeliroute',width:80,resizable:true,ellipsis :true},
        {title:'销售部负责人',slot:'sales_man',width:96,resizable:true,ellipsis :true},
        {title:'销售部负责人审核时间',key:'sales_man_date',width:152,resizable:true,ellipsis :true},
        {title:'质量管理员',slot:'quality_adm',width:86,resizable:true,ellipsis :true},
        {title:'质量管理员审核时间',key:'quality_adm_date',width:138,resizable:true,ellipsis :true},
        {title:'质量管理部负责人',slot:'quality_depart',width:128,resizable:true,ellipsis :true},
        {title:'质量管理部负责人审核时间',key:'quality_depart_date',width:176,resizable:true,ellipsis :true},
        {title:'质量负责人',slot:'quality_man',width:86,resizable:true,ellipsis :true},
        {title:'质量负责人审核时间',key:'quality_man_date',width:138,resizable:true,ellipsis :true},
        {title:'会员标志',slot:'ismem',width:72,resizable:true,ellipsis :true},
        {title:'自定义编号',key:'customid',width:82,resizable:true,ellipsis :true},
        {title:'控销类别',key:'control',width:72,resizable:true},
        {title:'创建者',slot:'createmanid',width:72,resizable:true,ellipsis :true},
        {title:'创建日期',key:'create_date',width:90,resizable:true,ellipsis :true},
        {title:'更新人员',slot:'editmanid',width:72,resizable:true,ellipsis :true},
        {title:'更新日期',key:'edit_date',width:90,resizable:true,ellipsis :true}
      ],
      data:[],
      page:1,
      sel_key:0,
      seldata:{},
      search:{isvalid:2},
      postCode:''
    }
  },
  created:function() {
    _this=this;
    this.init();
  },
  methods: {
    DHeight:function(e){
      this.height = e-193;
    },
    init:function(){
      _this.$Spin.show();
      this.common.http({
        url:'examList',
        data:{search:this.search,page:this.page}
      }).then(function (d) {
        _this.$Spin.hide();
        if(d.status==1){
          _this.data = d.data.data;
          if(d.data.data.length>0) _this.seldata=_this.data[_this.sel_key];
        }
      }).catch(function (err) {
        _this.$Spin.hide();
        _this.common.httpErr(err.data,_this)
      })
    },
    /**
     * 行样式
     */
    rowClassName(row, index) {
      var className = '';
      if (index === this.sel_key) {
        className = 'ivu-table-row-highlight';
      }
      return className;
    },
    /**
     * 选择某一行
     */
    sel_column:function(event,index){
      this.sel_key=index;
      this.seldata=this.data[this.sel_key];
    },
    /**
     * 选择审核人
     */
    chooseOp:function(post_code){
      if(this.data.length==0) return false;
      var errmsg=[
        {key:'sales_man_status',msg:'销售部负责人尚未审核'},
        {key:'quality_adm_status',msg:'质量管理员尚未审核'},
        {key:'quality_depart_status',msg:'质量管理部负责人尚未审核'}
      ],end_key=-1,haserr=false;
      if(post_code == 'sales_depart'){
        end_key=-1
        this.$set(this.seldata,'check_remark',this.seldata.sales_man_remark);
      }else if(post_code == 'quality_admin'){
        this.$set(this.seldata,'check_remark',this.seldata.quality_adm_remark);
        end_key=0;
      }else if(post_code == 'quality_depart'){
        this.$set(this.seldata,'check_remark',this.seldata.quality_depart_remark);
        end_key=1;
      }else if(post_code == 'quality_director'){
        this.$set(this.seldata,'check_remark',this.seldata.quality_man_remark);
        end_key=2;
      }
      for(var i=0;i<=end_key;i++){
        if(this.seldata[errmsg[i].key]!=1){
          haserr=true;
          this.modalMsg(errmsg[i].msg);
          break;
        }
      }
      if(haserr) return false;
      this.postCode = post_code;
      this.$refs.verifyUserRef.open();
    },
    /**
     * 确认选择审核人
     */
    confirmOp:function (rdata){
      for (var i in rdata){
        this.$set(this.seldata,i,rdata[i]);
      }
    },
  }
};
</script>
<style lang="less">
.custexam{
  position: relative;
  .pro-list{overflow: auto;-webkit-flex: 1; -ms-flex-positive: 1; flex-grow: 1; flex: 1;}
  .exam-right{width: 760px; padding-top: 10px; overflow: auto;}
  .exam-status{height: 70px; width: 360px; margin: 10px auto 30px auto; font-size: 42px; text-align: center; border-width: 3px; border-style: solid;}
  .exam1{color: #1d9c00; border-color: #1d9c00;}
  .exam0{color: #ff0000; border-color: #ff0000;}
  .exambottom{
    position: absolute; left: 0; right: 0; bottom: 0; border-top-width: 3px; border-top-style: solid;
    .exam-foot{padding-top: 10px;}
    .ctips{display: inline-block; padding-left: 30px; font-size: 16px; line-height: 28px; color: #0000ff;}
  }
}
</style>
