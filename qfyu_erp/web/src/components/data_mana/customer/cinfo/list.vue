<template>
  <div class="main">
    <split-tb :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="init"><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button @click="edit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="edit(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button><span class="icon iconfont">&#xe69c;</span>复制</Button>
          <Button @click="showSearch=true"><span class="icon iconfont">&#xe691;</span>筛选</Button>
          <Button><span class="icon iconfont">&#xe6a0;</span>报表</Button>
          <Button><span class="icon iconfont">&#xe6b7;</span>发短信</Button>
        </div>
      </div>
      <div slot="table-list" :style="'height:'+height+'px;overflow:hidden;'">
        <div class="pro-list">
          <Table border :row-class-name="rowClassName" :columns="columns" :data="data" :height="height" size="small" @on-row-click="sel_column" @on-row-dblclick="edit(1)">
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
      </div>
      <div slot="bottom">
        <Tabs :animated="false" @on-click="tab_tab">
          <TabPane label="协议品种管理">
            <div class="cust_one" :style="'height:'+bheight+'px'">
              <Table highlight-row border :columns="goods_column" :data="goods_data" :height="bheight" size="small" @on-row-click="sel_goods" @on-row-dblclick="open_goods(1)">
                <template slot-scope="row" slot="is_valid"><Checkbox :value="row.row.is_valid" disabled :true-value="1" :false-value="0"></Checkbox></template>
                <template slot-scope="row" slot="no_auto_price"><Checkbox :value="row.row.no_auto_price" disabled :true-value="1" :false-value="0"></Checkbox></template>
                <template slot-scope="row" slot="day_limit">{{row.row.day_limit||'不限'}}</template>
                <template slot-scope="row" slot="month_limit">{{row.row.month_limit||'不限'}}</template>
              </Table>
              <div class="cust_oneright">
                <Button style="margin-bottom: 10px;" @click="open_goods(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button style="margin-bottom: 10px;" @click="open_goods(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button @click="del_goods"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
              </div>
            </div>
          </TabPane>
          <TabPane label="客户采购人员(联系人)管理">
            <div class="cust_one" :style="'height:'+bheight+'px'">
              <Table highlight-row border :columns="contacts_column" :data="contacts" :height="bheight" size="small" @on-row-click="sel_contacts" @on-row-dblclick="open_edit_contacts(1)">
                <template slot-scope="row" slot="sex">
                  <span v-if="row.row.sex==0">女</span>
                  <span v-else-if="row.row.sex==1">男</span>
                </template>
                <template slot-scope="row" slot="check_status"><Checkbox :value="row.row.check_status" disabled :true-value="1" :false-value="0"></Checkbox></template>
                <template slot-scope="row" slot="status"><Checkbox :value="row.row.status" disabled :true-value="1" :false-value="0"></Checkbox></template>
                <template slot-scope="row" slot="attorney_validity"><Checkbox :value="row.row.attorney_validity" disabled :true-value="1" :false-value="0"></Checkbox></template>
              </Table>
              <div class="cust_oneright">
                <Button style="margin-bottom: 10px;" @click="open_edit_contacts(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button style="margin-bottom: 10px;" @click="open_edit_contacts(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button style="margin-bottom: 10px;" @click="del_contacts"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <Button @click="set_default_contacts">设为默认</Button>
              </div>
            </div>
          </TabPane>
          <TabPane label="业务联系记录管理">
            <div class="cust_one" :style="'height:'+bheight+'px'">
              <Table highlight-row border :columns="neg_column" :data="neg_data" :height="bheight" size="small" @on-row-click="sel_business" @on-row-dblclick="open_business(1)"></Table>
              <div class="cust_oneright">
                <Button style="margin-bottom: 10px;" @click="open_business(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button style="margin-bottom: 10px;" @click="open_business(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button style="margin-bottom: 10px;" @click="del_business"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
              </div>
            </div>
          </TabPane>
          <TabPane label="证照图片管理">
            <div class="cust_one" :style="'height:'+bheight+'px'">
              <Table highlight-row border :columns="img_column" :data="img_data" :height="bheight" size="small" @on-row-click="sel_img" @on-row-dblclick="open_img(1)"></Table>
              <div class="cust_oneright">
                <Button style="margin-bottom: 10px;" @click="open_img(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button style="margin-bottom: 10px;" @click="open_img(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button style="margin-bottom: 10px;" @click="del_img"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <!--<Button style="margin-bottom: 10px;"><span class="icon iconfont">&#xe6bf;</span>查看</Button>-->
              </div>
            </div>
          </TabPane>
        </Tabs>
      </div>
    </split-tb>
    <Drawer title="条件筛选" :closable="false" v-model="showSearch">
      <div class="tab-term">
        <RadioGroup v-model="search.isvalid" @on-change="init">
          <Radio :label="2">全部客户</Radio>
          <Radio :label="1">已通过资质审核的客户</Radio>
          <Radio :label="0">未审核的客户</Radio>
        </RadioGroup>
      </div>
    </Drawer>
    <edit-contacts ref="edcont"></edit-contacts>
    <records ref="records"></records>
    <photo ref="photo"></photo>
    <cust-goods ref="cgoods"></cust-goods>
  </div>
</template>
<script>
import splitTb from '@/components/public/splitTB'
import editContacts from '../cinfo/EditContacts'
import records from '../cinfo/records'
import photo from '../cinfo/photo'
import custGoods from '../cinfo/custGoods'
var _this;
export default {
  components:{splitTb,editContacts,records,photo,custGoods},
  name:'customer',
  data() {
    return {
      height:0,
      bheight:0,
      showSearch:false,
      Breadcrumb:[{title:'资料管理'},{title:'客户资料管理'}],
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
        {title:'销售部负责人',slot:'',width:96,resizable:true,ellipsis :true},
        {title:'销售部负责人审核时间',key:'',width:152,resizable:true,ellipsis :true},
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
      goods_column:[
        {title:'商品编号',key:'goods_code',width:80,resizable:true,ellipsis :true},
        {title:'通用名称',key:'goods_name',width:200,resizable:true,ellipsis :true},
        {title:'规格',key:'specs',width:80,resizable:true,ellipsis :true},
        {title:'主单位',key:'unit',width:70,resizable:true,ellipsis :true},
        {title:'主协议价格',key:'price',width:80,resizable:true,ellipsis :true},
        {title:'辅单位',key:'unit2',width:70,resizable:true,ellipsis :true},
        {title:'辅协议价格',key:'price2',width:80,resizable:true,ellipsis :true},
        {title:'是否有效',slot:'is_valid',width:60,resizable:true,ellipsis :true},
        {title:'备注',key:'remark',width:120,resizable:true,ellipsis :true},
        {title:'最近交易日期',key:'near_date',width:100,resizable:true,ellipsis :true},
        {title:'不自动调价',slot:'no_auto_price',width:80,resizable:true,ellipsis :true},
        {title:'产地',key:'origin',width:180,resizable:true,ellipsis :true},
        {title:'生产企业',key:'production',width:220,resizable:true,ellipsis :true},
        {title:'批准文号',key:'approval_code',width:120,resizable:true,ellipsis :true},
        {title:'剂型',key:'dosage',width:70,resizable:true,ellipsis :true},
        {title:'日销量限制',slot:'day_limit',width:80,resizable:true,ellipsis :true},
        {title:'月销量限制',slot:'month_limit',width:80,resizable:true,ellipsis :true},
      ],
      goods_data:[],
      contacts_column:[
        {title:'姓名',key:'user_name',width:80,resizable:true,ellipsis :true},
        {title:'性别',slot:'sex',width:60,resizable:true,ellipsis :true},
        {title:'部门',key:'depart',width:60,resizable:true,ellipsis :true},
        {title:'职位',key:'duties',width:80,resizable:true,ellipsis :true},
        {title:'手机号',key:'tel',width:100,resizable:true,ellipsis :true},
        {title:'办公电话',key:'phone',width:100,resizable:true,ellipsis :true},
        {title:'邮箱',key:'email',width:100,resizable:true,ellipsis :true},
        {title:'销售负责人姓名',key:'salesdepart_name',width:110,resizable:true,ellipsis :true},
        {title:'备注',key:'remark',width:100,resizable:true,ellipsis :true},
        {title:'销售部负责人审核时间',key:'salesdepart_date',width:150,resizable:true,ellipsis :true},
        {title:'质量部负责人',key:'qcdepart',width:100,resizable:true,ellipsis :true},
        {title:'质量部负责人姓名',key:'qcdepart_name',width:130,resizable:true,ellipsis :true},
        {title:'质量部负责人审核时间',key:'qcdepart_date',width:150,resizable:true,ellipsis :true},
        {title:'质量负责人',key:'qcid',width:90,resizable:true,ellipsis :true},
        {title:'质量负责人姓名',key:'qcid_name',width:110,resizable:true,ellipsis :true},
        {title:'质量负责人审核时间',key:'qc_date',width:150,resizable:true,ellipsis :true},
        {title:'创建者',key:'creator',width:80,resizable:true,ellipsis :true},
        {title:'创建者姓名',key:'creator_name',width:100,resizable:true,ellipsis :true},
        {title:'创建时间',key:'create_date',width:110,resizable:true,ellipsis :true},
        {title:'是否合格',slot:'check_status',width:80,resizable:true,ellipsis :true},
        {title:'资料有效',slot:'status',width:80,resizable:true,ellipsis :true},
        {title:'委托书编号',key:'attorney_no',width:90,resizable:true,ellipsis :true},
        {title:'委托书已失效',slot:'attorney_validity',width:100,resizable:true,ellipsis :true},
      ],
      contacts:[],
      neg_column:[
        {title:'序号',type:'index',width:50,resizable:true,ellipsis :true},
        {title:'洽谈主题',key:'submatter',width:100,resizable:true,ellipsis :true},
        {title:'洽谈方式或地点',key:'area',width:120,resizable:true,ellipsis :true},
        {title:'我方洽谈人',key:'mman_name',width:90,resizable:true,ellipsis :true},
        {title:'洽谈时间',key:'bus_date',width:150,resizable:true,ellipsis :true},
        {title:'对方洽谈负责人',key:'yman',width:110,resizable:true,ellipsis :true},
        {title:'洽谈内容',key:'content',minWidth:200,resizable:true,tooltip:true},
      ],
      neg_data:[],
      img_column:[
        {title:'图片名称',key:'pic_name_txt',width:200,resizable:true,ellipsis :true},
        {title:'文件路径',key:'pic_url',width:390,resizable:true,ellipsis :true},
        {title:'采集日期',key:'pic_date',width:150,resizable:true,ellipsis :true},
        {title:'失效日期',key:'use_date',width:150,resizable:true,ellipsis :true},
        {title:'采集人',key:'man_name',width:90,resizable:true,ellipsis :true},
      ],
      img_data:[],
      sel_key:0,
      goods_key:-1,
      contact_key:-1,
      business_key:-1,
      img_key:-1,
      data:[],
      page:1,
      search:{isvalid:2},
      btab_key:0
    }
  },
  created:function() {
    _this=this;
    this.init();
  },
  methods: {
    DHeight:function(e){
      this.height = e.THeight;
      this.bheight=e.BHeight-50;
    },
    init:function(){
      this.common.http({
        url:'customerList',
        data:{search:this.search,page:this.page}
      }).then(function (d) {
        if(d.status==1){
          _this.data = d.data.data;
          _this.$nextTick(function (){
            _this.get_goods(_this.data[_this.sel_key].id)
          })
        }
      }).catch(function (err) {
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
      var id=this.data[index].id;
      if(this.btab_key==0){
        this.get_goods(id);
      }else if(this.btab_key==1){
        this.get_contact(id);
      }else if(this.btab_key==2){
        this.get_neg(id);
      }else if(this.btab_key==3){
        this.get_img(id);
      }
    },
    /**
     * 底部tab切换
     */
    tab_tab:function (index){
      this.btab_key=index;
      if(this.sel_key!=-1) var id=this.data[this.sel_key].id;
      if(index==0 && this.sel_key!=-1){
        this.get_goods(id);
      }else if(index==1 && this.sel_key!=-1){
        this.get_contact(id);
      }else if(index==2 && this.sel_key!=-1){
        this.get_neg(id);
      }else if(index==3 && this.sel_key!=-1){
        this.get_img(id);
      }
    },
    /**
     * 新增/编辑 客户
     */
    edit:function (isedit) {
      if(isedit){
        if(this.sel_key==-1){
          this.alertMsg('请选择要修改的客户！','error');return false;
        }
        this.toUrl('edit_customer',{id:this.data[this.sel_key].id});
      }else{
        this.toUrl('edit_customer',{id:''});
      }
    },
    /**
     * 获取协议品种
     */
    get_goods:function (id){
      this.goods_key=-1;
      this.common.http({
        url:'custGoodsList',
        data:{id:id}
      }).then(function (d) {
        if(d.status==1){
          _this.goods_data = d.data;
        }else{
          _this.goods_data=[];
        }
      }).catch(function (err) {
        _this.common.httpErr(err.data,_this)
      })
    },
    /**
     * 选择协议产品
     */
    sel_goods:function (event,index){
      this.goods_key=index;
    },
    /**
     * 新增/编辑 协议产品
     */
    open_goods:function (type){
      var data= {};data.id=0;
      if(this.sel_key==-1){
        this.alertMsg('请先选择客户','error');
        return false;
      }
      if(type==1){
        if(this.goods_key==-1){
          this.alertMsg('请选择要修改的协议品种','error');
          return false;
        }
        data=this.goods_data[this.goods_key];
      }
      this.$refs.cgoods.init({
        data:data,
        cid:this.data[this.sel_key].id
      })
    },
    /**
     * 删除协议品种
     */
    del_goods:function (){
      if(this.sel_key==-1 || this.goods_key==-1){
        this.alertMsg('请先选择要删除的协议品种！','error');return false;
      }
      var _this=this,id=this.goods_data[this.goods_key].id;
      _this.$Modal.confirm({
        title:'删除提示',
        content:'确定要删除协议品种吗？',
        onOk:function(){
          _this.common.http({url:'delCustGoods',data:{id:id}}).then(function(res){
            if(res.status==1){
              _this.get_goods(_this.data[_this.sel_key].id);
              _this.alertMsg(res.msg,'success');
            }else{
              _this.alertMsg(res.msg,'error');
            }
          }).catch(function(err) {
            _this.common.httpErr(err.data,_this);
          });
        }
      });
    },
    /**
     * 选择联系人
     */
    sel_contacts:function (event,index){
      this.contact_key=index;
    },
    /**
     * 编辑联系人
     */
    open_edit_contacts:function (type){
      var id=0;
      if(this.sel_key==-1){
        this.alertMsg('请先选择客户','error');
        return false;
      }
      if(type==1){
        if(this.contact_key==-1){
          this.alertMsg('请选择要修改的联系人','error');
          return false;
        }
        id=this.contacts[this.contact_key].id;
      }
      this.$refs.edcont.init({
        id:id,
        company:{id:this.data[this.sel_key].id,name:this.data[this.sel_key].name}
      })
    },
    /**
     * 删除联系人
     */
    del_contacts:function (){
      if(this.sel_key==-1 || this.contact_key==-1){
        this.alertMsg('请先选择要删除的联系人！','error');return false;
      }
      var _this=this,id=this.contacts[this.contact_key].id;
      _this.$Modal.confirm({
        title:'删除提示',
        content:'确定要删除联系人吗？',
        onOk:function(){
          _this.common.http({url:'delCustConcat',data:{id:id}}).then(function(res){
            if(res.status==1){
              _this.get_contact(_this.data[_this.sel_key].id);
              _this.alertMsg(res.msg,'success');
            }else{
              _this.alertMsg(res.msg,'error');
            }
          }).catch(function(err) {
            _this.common.httpErr(err.data,_this);
          });
        }
      });
    },
    /**
     * 设置默认联系人
     */
    set_default_contacts:function (){
      if(this.sel_key==-1 || this.contact_key==-1){
        this.alertMsg('请先选择要设置的联系人！','error');return false;
      }
      var _this=this,id=this.contacts[this.contact_key].id;
      _this.common.http({url:'defCustConcat',data:{id:id}}).then(function(res){
        if(res.status==1){
          _this.alertMsg(res.msg,'success');
        }else{
          _this.alertMsg(res.msg,'error');
        }
      }).catch(function(err) {
        _this.common.httpErr(err.data,_this);
      });
    },
    /**
     * 获取联系人
     */
    get_contact:function (id){
      this.contact_key=-1;
      this.common.http({
        url:'contactList',
        data:{id:id}
      }).then(function (d) {
        if(d.status==1){
          _this.contacts = d.data;
        }else{
          _this.contacts=[];
        }
      }).catch(function (err) {
        _this.common.httpErr(err.data,_this)
      })
    },
    /**
     * 选择联系记录
     */
    sel_business:function (event,index){
      this.business_key=index;
    },
    /**
     * 新增/编辑 业务联系记录
     */
    open_business:function (type){
      var data={};data.id=0;
      if(this.sel_key==-1){
        this.alertMsg('请先选择客户','error');
        return false;
      }
      if(type==1){
        if(this.business_key==-1){
          this.alertMsg('请选择要修改的联系记录','error');
          return false;
        }
        data=this.neg_data[this.business_key];
      }
      this.$refs.records.init({
        data:data,
        company_id:this.data[this.sel_key].id
      })
    },
    /**
     * 删除业务联系记录
     */
    del_business:function (){
      if(this.sel_key==-1 || this.business_key==-1){
        this.alertMsg('请先选择要删除的业务联系记录！','error');return false;
      }
      var _this=this,id=this.neg_data[this.business_key].id;
      _this.$Modal.confirm({
        title:'删除提示',
        content:'确定要删除业务联系记录吗？',
        onOk:function(){
          _this.common.http({url:'delBusiness',data:{id:id}}).then(function(res){
            if(res.status==1){
              _this.get_neg(_this.data[_this.sel_key].id);
              _this.alertMsg(res.msg,'success');
            }else{
              _this.alertMsg(res.msg,'error');
            }
          }).catch(function(err) {
            _this.common.httpErr(err.data,_this);
          });
        }
      });
    },
    /**
     * 获取业务联系记录
     */
    get_neg:function (id){
      this.business_key=-1;
      this.common.http({
        url:'negList',
        data:{id:id}
      }).then(function (d) {
        if(d.status==1){
          _this.neg_data = d.data;
        }else{
          _this.neg_data=[];
        }
      }).catch(function (err) {
        _this.common.httpErr(err.data,_this)
      })
    },
    /**
     * 获取证照图片
     */
    get_img:function (id){
      this.img_key=-1;
      this.common.http({
        url:'cimgList',
        data:{id:id}
      }).then(function (d) {
        if(d.status==1){
          _this.img_data = d.data;
        }else{
          _this.img_data=[];
        }
      }).catch(function (err) {
        _this.common.httpErr(err.data,_this)
      })
    },
    /**
     * 选择证照图片
     */
    sel_img:function (event,index){
      this.img_key=index;
    },
    /**
     * 新增/编辑 证照图片
     */
    open_img:function (type){
      var id=0;
      if(this.sel_key==-1){
        this.alertMsg('请先选择客户','error');
        return false;
      }
      if(type==1){
        if(this.img_key==-1){
          this.alertMsg('请选择要修改的证照','error');
          return false;
        }
        id=this.img_data[this.img_key].id;
      }
      this.$refs.photo.init({
        id:id,
        company_id:this.data[this.sel_key].id
      })
    },
    /**
     * 删除业务联系记录
     */
    del_img:function (){
      if(this.sel_key==-1 || this.img_key==-1){
        this.alertMsg('请先选择要删除的证照！','error');return false;
      }
      var _this=this,id=this.img_data[this.img_key].id;
      _this.$Modal.confirm({
        title:'删除提示',
        content:'确定要删除证照吗？',
        onOk:function(){
          _this.common.http({url:'delCustPhoto',data:{id:id}}).then(function(res){
            if(res.status==1){
              _this.get_img(_this.data[_this.sel_key].id);
              _this.alertMsg(res.msg,'success');
            }else{
              _this.alertMsg(res.msg,'error');
            }
          }).catch(function(err) {
            _this.common.httpErr(err.data,_this);
          });
        }
      });
    },
  }
};
</script>
<style lang="less">
  .tab-term{
    padding: 5px 10px;
  }
  .pro-pages{
    text-align: right;padding: 10px 0 0 0;
  }
  .cust_one{padding:0 110px 0 10px; position: relative;
    .cust_oneright{
      width: 90px; position: absolute; right: 10px; top: 0; bottom: 0;
    }
  }
</style>
