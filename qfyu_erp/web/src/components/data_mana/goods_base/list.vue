<template>
  <div class="main">
    <split-tb :total="total" :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button @click="newData(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="newData(false)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="checker(true)"><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Button @click="checker(false)"><span class="icon iconfont">&#xe6a2;</span>撤销</Button>
          <Button @click="showSearch=true"><span class="icon iconfont">&#xe7f3;</span>筛选</Button>
          <Button><span class="icon iconfont">&#xe6a0;</span>报表</Button>
          <Button><span class="icon iconfont">&#xe6c0;</span>网格属性</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
      </div>
      <div slot="table-list" class="table-item">
          <Table ref="goodsData" size="small" highlight-row border :loading="loading" :columns="columns" :data="data" :height="height-34" @on-row-click="(item,index)=>{clickRow(item,index,false)}" @on-row-dblclick="(item,index)=>{clickRow(item,index,true)}">
            <template slot-scope="{row}" slot="status">
              <div :class="row.status?'success-bg-text':'warning-bg-text'">{{row.status?'已审核':'未审核'}}</div>
            </template>
            <template slot-scope="{row}" slot="gsp_type">
              <span v-if="JSON.stringify($store.state.sysParam) != '[]'">{{$store.state.sysParam.gsp_category[row.gsp_type]}}</span>
            </template>
            <template slot-scope="{row}" slot="markup">
              <Checkbox :true-value="1" :false-value="0" :value="row.markup" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_medical">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_medical" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_check">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_check" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_qty">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_qty" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_first">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_first" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_variety">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_variety" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_rx">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_rx" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_shopping">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_shopping" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_yi">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_yi" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_yymz">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_yymz" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_vip">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_vip" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_supervise">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_supervise" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_drugs">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_drugs" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_gift">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_gift" disabled></Checkbox>
            </template>
            <template slot-scope="{row}" slot="is_solit">
              <Checkbox :true-value="1" :false-value="0" :value="row.is_solit" disabled></Checkbox>
            </template>
          </Table>
        <div class="page-m">
          <Page size="small" :total="total" :page-size="pageSize" :page-size-opts="[15,25,35,50]" show-total show-elevator show-sizer @on-change="changePage" @on-page-size-change="ChangePageSize" />
        </div>
      </div>
      <div ref="heigthRef" slot="bottom" class="tabs-form">
        <Tabs :animated="false" v-model="tabName" @on-click="clickTabs">
          <TabPane label="商品价格设定" name="price">
            <price ref="price" :height="zHeight"></price>
          </TabPane>
          <TabPane label="商品批量折扣" name="discount">
            <goods-batch-discount ref="discount" :height="zHeight"></goods-batch-discount>
          </TabPane>
          <TabPane label="供货历史" name="supply">
            <supply-history ref="supply" :height="zHeight"></supply-history>
          </TabPane>
          <TabPane label="销售限制" name="sale">
            <sell-limit ref="sale" :height="zHeight"></sell-limit>
          </TabPane>
          <TabPane label="库存信息" name="qty">
            <goods-qty ref="qty" :height="zHeight"></goods-qty>
          </TabPane>
          <TabPane label="购进记录" name="buyer">
            <purchase-record ref="buyer" :height="zHeight"></purchase-record>
          </TabPane>
          <TabPane label="存放库位" name="warehouse">
            <warehouse ref="warehouse" :height="zHeight"></warehouse>
          </TabPane>
          <TabPane label="药品证照管理" name="pic">
            <goods-photo ref="pic" :height="zHeight"></goods-photo>
          </TabPane>
          <TabPane label="控销类别" name="category">
            <sales-category ref="category" :height="zHeight"></sales-category>
          </TabPane>
          <TabPane label="控销区域" name="area">
            <sales-area ref="area" :height="zHeight"></sales-area>
          </TabPane>
        </Tabs>
      </div>
    </split-tb>
    <select-first-goods ref="selFirstGoods" @customize="customGoods" @close="closeGoods" @confirm="confirmGoods"></select-first-goods>
    <edit-goods ref="refData" @SuData="upData"></edit-goods>
    <Drawer title="条件筛选" :closable="false" v-model="showSearch" width="340">
        <Form ref="formSearchData" :model="serData" :label-width="80">
          <FormItem label="商品编号">
            <Input v-model="serData.goods_code" placeholder="请输入商品编号"></Input>
          </FormItem>
          <FormItem label="商品名称">
            <Input v-model="serData.name" placeholder="商品名称/通用名称"></Input>
          </FormItem>
          <FormItem label="商品条码">
            <Input v-model="serData.code" placeholder="请输入商品条码"></Input>
          </FormItem>
          <FormItem label="拼音码">
            <Input v-model="serData.pym" placeholder="请输入拼音码"></Input>
          </FormItem>
          <FormItem label="GSP类型">
            <Select v-model="serData.gsp_type" clearable>
              <Option v-for="(item,index) in gsp_category" :value="index" :key="index">{{item}}</Option>
            </Select>
          </FormItem>
          <FormItem label="储存条件">
            <Select v-model="serData.storage_type" clearable>
              <Option v-for="(item,index) in storage" :value="index" :key="index">{{item}}</Option>
            </Select>
          </FormItem>
          <FormItem label="商品剂型">
            <Select v-model="serData.dosage" clearable>
              <Option v-for="(item,index) in dosage" :value="index" :key="index">{{item}}</Option>
            </Select>
          </FormItem>
          <FormItem>
            <RadioGroup v-model="serData.status">
              <Radio label="">全部商品</Radio>
              <Radio label="1">已审核合格的商品</Radio>
              <Radio label="0">未审核的商品</Radio>
            </RadioGroup>
          </FormItem>
          <div class="nav-menu">
            <Button @click="(e)=>{this.init()}" type="primary"><span class="icon iconfont">&#xe691;</span>查询</Button>
            <Button @click="handleReset"><span class="icon iconfont">&#xe6a2;</span>清空筛选条件</Button>
          </div>
        </Form>
    </Drawer>
</div>
</template>
<script>
import splitTb from '@/components/public/splitTB'
import editGoods from "@/components/data_mana/goods_base/editGoods"
import SelectFirstGoods from "@/components/common/SelectFirstGoods"
import price from "@/components/data_mana/goods_base/price"
import goodsPhoto from "@/components/data_mana/goods_base/goodsPhoto"
import warehouse from "@/components/data_mana/goods_base/warehouse"
import salesCategory from "@/components/data_mana/goods_base/salesCategory"
import goodsQty from "@/components/data_mana/goods_base/goodsQty"
import salesArea from "@/components/data_mana/goods_base/salesArea"
import sellLimit from "@/components/data_mana/goods_base/sellLimit"
import goodsBatchDiscount from "@/components/data_mana/goods_base/goodsBatchDiscount"
import PurchaseRecord from "@/components/data_mana/goods_base/PurchaseRecord"
import SupplyHistory from "@/components/data_mana/goods_base/SupplyHistory"
var _this,
  formData = {
    name:'',goods_name:'',goods_code:'',en_name:'',code:'',file_name:'',pym:'',specs:'',packspecs:'',electron_code:'', color_code:'', kinds_id:null, kinds_kid:null,kinds_name:'',category_id:null, function_id:[], origin:'', production:'', maker:'', unit:'', unit2:null, is_solit:0, solit_value:null, dosage:null, tax:null, approval_code:'', approval_date:'', shelf_life:'', shelf_unit:'', take:null, gsp_type:null, standard_code:'', supervise_code:'', pack_specs1:null, pack_specs2:null, drug:'', drug_unit:'', hours:'', element_type:null, coloc_type:null, billing_type:null, pifaml:null, retail:null,  depart_name:'',depart_id:null, markup:0, is_medical:0, is_check:0, is_qty:0, is_first:0, is_variety:0, is_rx:0, is_shopping:1, is_yi:0, is_yymz:0, is_vip:0, is_supervise:0, is_drugs:0, is_gift:0, creater:'', creater_date:'', checker:'', check_date:'', update_date:'', remark:'', abc:'', abkind:'', quality_standards:'', quality_date:'', exterior:'', brand:'', brand_date:'', level:null, gmp_code:'', gmp_property:'', gmp_end_date:'', license_key:'', license_date:'', code1:'', code1_date:'', code2:'', code2_date:'', custom_name:'', custom_val:'', custom_code1:'', custom_code2:'', custom_code3:'', start_give_amount:null, give_amount:null, times_give:0, give_date:'', integral:'', buyer_type:0, is_new:0, is_buyer:0, supplier:'', amount:null, buyer_id:null, buyer_name:'',buyer_day:'', buyer_cycle:'', buyer_multiple:'', day:'', tend_type:'', tend_day:'', storage_type:'', max_qty:null, min_qty:null, salesman:null,salesman_name:'', wholesale_amount:null, retail_amount:null, sala_multiple:null, is_sale:0, is_wholesale:0, is_retail:0, wholesale_price:null, factory_price:null, buyer_price:null, buyer_price2:null,retail_price:null,retail_price2:null,trade_price:null,trade_price2:null,status:null},
  searchData = {
  goods_code:'', name:'', code:'', pym:'', category_id:null, gsp_type:null, storage_type:null, dosage:null, status:null
};
export default {
  components:{
    splitTb,editGoods,SelectFirstGoods,price,goodsPhoto,warehouse,salesCategory,goodsQty,salesArea,sellLimit,goodsBatchDiscount,PurchaseRecord,SupplyHistory
  },
  data() {
    return {
      goods_code:0,
      height:0,
      tabName:'price',
      Breadcrumb:[{title:'资料管理'},{title:'商品资料管理'}],
      showSearch:false,
      loading:false,
      serData:JSON.parse(JSON.stringify(searchData)),
      formData:{},
      columns: [
        {title:'商品编号',key:'goods_code',width:100,minWidth:100,resizable:true,ellipsis:true},
        {title:'通用名称',key:'name',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'商品名称',key:'goods_name',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'条码一',key:'code',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'拼音码',key:'pym',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'附件名',key:'file_name',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'规格',key:'specs',width:100,minWidth:100,resizable:true,ellipsis:true},
        {title:'包装规格',key:'packspecs',width:100,minWidth:100,resizable:true,ellipsis:true},
        {title:'主单位',key:'unit',width:60,minWidth:60,resizable:true,ellipsis:true},
        {title:'辅单位',key:'unit2',width:60,minWidth:60,resizable:true,ellipsis:true},
        {title:'剂型',key:'dosage',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'税率',key:'tax',width:90,minWidth:90,resizable:true,ellipsis:true,align:'right'},
        {title:'批准文号',key:'approval_code',width:140,minWidth:140,resizable:true,ellipsis:true},
        {title:'批准文号有效期',key:'approval_date',width:140,minWidth:140,resizable:true,ellipsis:true},
        {title:'保质期',key:'shelf_life',width:60,minWidth:60,resizable:true,ellipsis:true,align:'right'},
        {title:'保质期单位',key:'shelf_unit',width:80,minWidth:80,resizable:true,ellipsis:true,align:'right'},
        {title:'gsp验收类型',slot:'gsp_type',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'本位码',key:'standard_code',width:120,minWidth:120,resizable:true,ellipsis:true},
        {title:'监管码',key:'supervise_code',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'中包装数',key:'pack_specs1',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'大包装数',key:'pack_specs2',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'含量',key:'drug',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'含量单位',key:'drug_unit',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'运输在途时限(小时)',key:'hours',width:135,minWidth:135,resizable:true,ellipsis:true,align:'right'},
        {title:'成分类别',key:'element_type',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'商品色标',key:'coloc_type',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'开票类型',key:'billing_type',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'批发毛利率',key:'pifaml',width:90,minWidth:90,resizable:true,ellipsis:true,align:'right'},
        {title:'零售毛利率',key:'retail',width:90,minWidth:90,resizable:true,ellipsis:true,align:'right'},
        {title:'涨跌价',slot:'markup',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'医疗用药',slot:'is_medical',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'澄明度检验',slot:'is_check',width:90,minWidth:90,resizable:true,ellipsis:true,align:'center'},
        {title:'核算数量',slot:'is_qty',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'首营',slot:'is_first',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'中标品种(禁销药店)',slot:'is_variety',width:130,minWidth:130,resizable:true,ellipsis:true,align:'center'},
        {title:'处方药',slot:'is_rx',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'可网购 ',slot:'is_shopping',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'限售医院H',slot:'is_yi',width:80,minWidth:80,resizable:true,ellipsis:true,align:'center'},
        {title:'限售医院门诊C',slot:'is_yymz',width:110,minWidth:110,resizable:true,ellipsis:true,align:'center'},
        {title:'会员商品',slot:'is_vip',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'监管',slot:'is_supervise',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'特殊药品复方制剂',slot:'is_drugs',width:130,minWidth:130,resizable:true,ellipsis:true,align:'center'},
        {title:'赠品',slot:'is_gift',width:60,minWidth:60,resizable:true,ellipsis:true,align:'center'},
        {title:'拆零',slot:'is_solit',width:70,minWidth:70,resizable:true,ellipsis:true,align:'center'},
        {title:'拆零比例',key:'solit_value',width:70,minWidth:70,resizable:true,ellipsis:true,align:'right'},
        {title:'商品功能类别',key:'function',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'商品大类',key:'category',width:120,minWidth:100,resizable:true,ellipsis:true},
        {title:'商品许可经营类别',key:'kinds_name',width:140,minWidth:140,resizable:true,ellipsis:true},
        {title:'ABC分类',key:'abc',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'质量标准',key:'quality_standards',width:90,minWidth:90,resizable:true,ellipsis:true},
        {title:'创建人',key:'creater',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'创建时间',key:'creater_date',width:140,minWidth:140,resizable:true,ellipsis:true},
        {title:'审核人',key:'checker',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'审核时间',key:'check_date',width:140,minWidth:140,resizable:true,ellipsis:true},
        {title:'更新人',key:'updater_code',width:80,minWidth:80,resizable:true,ellipsis:true},
        {title:'更新时间',key:'updater_date',width:140,minWidth:140,resizable:true,ellipsis:true},
        {title:'状态',slot:'status',width:100,minWidth:100,resizable:true,ellipsis:true,fixed:'right'}
      ],
      data:[],
      gsp_category:this.$store.state.sysParam['gsp_category'],
      storage:this.$store.state.sysParam['storage'],
      dosage:this.$store.state.sysParam['dosage'],
      total:0,
      page:1,
      pageSize:15,
      zHeight:0,
      Index:-1
    }
  },
  created() {
    this.init();
  },
  mounted() {
    _this=this;
  },
  watch:{
    goods_code:function (e) {
      if(e !="undefined") {
        this.goods_code = e;
        this.clickTabs(this.tabName);
      }
    },
  },
  methods: {
    init:function(){
      this.loading = true;
      this.common.http({
        url:'getCommodityList',
        data:{search:this.serData,page:this.page,pageSize:this.pageSize}
      }).then(function (res) {
        if (res.status){
          _this.goods_code = res.goods_code;
          _this.data       = res.data.data;
          _this.total      = res.data.total;
          _this.$nextTick(function () {
            if(_this.loading) _this.loading=false;
          })
        }
      })
    },
    //新增 OR修改商品资料 type==true时新增 false 修改
    newData:function(type){
      if(!type){
        var data = this.setFormData(this.data[this.Index]);
        if(this.Index==-1) return  this.alertMsg('请选择首营品种','error');
        this.$refs.refData.open(data,this.goods_code);
      }else{
        this.$refs.selFirstGoods.open(formData,'');
      }
    },
    customGoods:function(type){
      if(type){
        this.$refs.refData.init(formData);
      }
    },
    closeGoods:function(){
      this.$refs.refData.init(formData);
    },
    confirmGoods:function(e){
      this.$refs.refData.init(e);
    },
    setFormData:function(obj){
      var data = JSON.parse(JSON.stringify(formData));
      for (let i in data){
        if(typeof obj[i] != 'undefined'){
          data[i] = obj[i]
        }
      }
      data.tax = this.formatFloat(data.tax,4)
      data.take = this.formatFloat(data.take,4)
      data.pifaml = this.formatFloat(data.pifaml,4)
      data.retail = this.formatFloat(data.retail,4)
      data.gsp_type = String(data.gsp_type);
      return data;
    },
    //新增-编辑商品资料操作成功后的回调
    upData:function(e){
      if (e.status) {
        this.init();
      }
    },
    //审核商品资料
    checker:function(type){
      var state = 1,title=' 审核';
      if (!type) state=0;
      title = type?title:' 撤销审核';
      if(this.Index==-1){
        return  this.alertMsg('请选择首营品种','error');
      }
      this.$Modal.confirm({
        title:'提示',
        content:'确定要对商品编号为：'+this.goods_code + title+'吗？',
        onOk:function() {
          _this.common.http({
            url:'checkerCommodity',
            data:{goods_code:_this.goods_code,state:state}
          }).then(function (res) {
            if (!res.status){
              _this.alertMsg(res.msg,'error')
            }else{
              _this.init();
            }
          }).catch(function (err) {
            _this.common.httpErr(err.data,_this)
          })
        }
      })
    },
    //商品资料列表 单击-双击表格事件
    clickRow:function(item,index,type){
      this.goods_code = this.data[index].goods_code;
      this.Index = index;
      if(type){
        var data = this.setFormData(item);
        this.$refs.refData.open(data,this.goods_code);
      }
    },
    //切换标签页
    clickTabs:function(name){
        this.$refs[name].init(this.goods_code);
    },
    dHeight:function(e){
      this.height = e.THeight;
      this.zHeight= e.BHeight-55
    },
    changePage:function(page){
      this.page = page;
      this.init();
    },
    ChangePageSize:function(page_size){
      this.page = 1;
      this.pageSize = page_size;
      this.init();
    },
    Refresh:function () {
      this.init();
    },
    out:function(){
      this.delView();
    },
    handleReset:function () {
      this.serData = JSON.parse(JSON.stringify(searchData));
    },
  }
};
</script>
<style lang="less">
  .main{
    .pro-pages{
      text-align: right;padding: 10px 0 0 0;
    }
    .table-item{
      .warning-bg-text,.success-bg-text{
        text-align: center;
      }
    }
  }
  .table-check-item{
    .ivu-checkbox-group{
      display: flex;flex-flow: column wrap;height: 426px;overflow-x: auto;
    }
  }
</style>

