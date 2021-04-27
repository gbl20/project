<template>
<div>
  <split-l-r :Breadcrumb="Breadcrumb" @DHeight="DHeight">
    <div slot="left" style="min-width: 500px;">
      <Form :label-width="50" style="width: 500px; padding-top: 10px;">
        <Row>
          <Col span="8">
            <FormItem label="仓库">
              <Input icon="ios-more" :value="search.ware_title" style="cursor: pointer;" clearable readonly @on-click="show_choware" @on-clear="clearware"></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="货位">
              <Input icon="ios-more" :value="search.pos_code" style="cursor: pointer;" clearable readonly @on-click="openpos"></Input>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="商品">
              <Input icon="ios-more" :value="search.goods_name" style="cursor: pointer;" clearable readonly @on-click="openGoods"></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="8">
            <FormItem label="生产批号">
              <Input v-model="search.batch_no"></Input>
            </FormItem>
          </Col>
          <Col span="16">
            <Button style="margin-left: 15px;" @click="init_left"><span class="icon iconfont">&#xe691;</span>查询</Button>
            <Button type="error" style="margin-left:10px;" @click="lock_sel"><span class="icon iconfont">&#xe7c9;</span>锁定</Button>
            <Checkbox style="margin-left: 15px;" v-model="lockall">锁定同批号</Checkbox>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="锁定后货品状态" :label-width="120">
              <Select v-model="cfg.def.goods_status">
                <Option v-for="(p,key) in cfg.goods_status" :key="key" :value="p">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="锁定后质量状态" :label-width="120">
              <Select v-model="cfg.def.quality_status">
                <Option v-for="(p,key) in cfg.quality_status" :key="key" :value="p">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
        </Row>
      </Form>
      <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="tableHeightL" :loading="loading" @on-row-click="selectRowIndex"></Table>
    </div>
    <div slot="right" style="min-width: 500px;">
      <Form :label-width="80" style="width: 700px; padding-top: 10px;">
        <Row>
          <Col span="9">
            <FormItem label="锁定日期从">
              <DatePicker type="date" v-model="searchR.beg"></DatePicker>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem label="至" :label-width="30">
              <DatePicker type="date" v-model="searchR.end"></DatePicker>
            </FormItem>
          </Col>
          <Col span="7">
            <FormItem label="供应商">
              <Input icon="ios-more" :value="searchR.sup_name" style="cursor: pointer;" clearable readonly @on-click="openprov" @on-clear="clearprov"></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="10">
            <FormItem label="产品名称">
              <Input v-model="searchR.goods_name"></Input>
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem label="" :label-width="20">
              <RadioGroup v-model="searchR.status">
                <Radio :label="0">全部</Radio>
                <Radio :label="2">已处理</Radio>
                <Radio :label="1">未处理</Radio>
              </RadioGroup>
            </FormItem>
          </Col>
          <Col span="4">
            <Button @click="init_right"><span class="icon iconfont">&#xe691;</span>查询</Button>
          </Col>
        </Row>
      </Form>
      <Table size="small" :columns="columnsR" :data="listR" border class="table-m" :height="tableHeightR" :loading="loadingR">
        <template slot-scope="row" slot="lock_man">{{$store.state.emp[row.row.lock_man]}}</template>
        <template slot-scope="row" slot="unlock_man">{{$store.state.emp[row.row.unlock_man]}}</template>
      </Table>
    </div>
  </split-l-r>
  <Modal v-model="lock.status" title="锁定质量疑问商品" width="390" footer-hide class-name="doubt-w">
    <Form :label-width="70">
      <FormItem label="锁定数量" v-if="!lockall">
        <input type="text" v-model="lock.qty" class="ivu-input ivu-input-default" maxlength="15" @input="filter_qty" />
      </FormItem>
      <FormItem label="锁定说明">
        <input type="text" v-model="lock.remark" class="ivu-input ivu-input-default" maxlength="150" placeholder="选填" />
      </FormItem>
    </Form>
    <div class="foot-mw">
      <div class="fmfr">
        <Button style="margin-right: 15px;" @click="save_doubt"><span class="icon iconfont">&#xe7fe;</span>确定</Button>
        <Button @click="lock.status=false"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
      </div>
    </div>
  </Modal>
  <choose-ware ref="chooseWareRef" @confirm="confirmParentWare"></choose-ware>
  <choose-ware-pos ref="chooseWareChildRef" @confirm="confirmPos"></choose-ware-pos>
  <choose-goods ref="RefGoods" @selectRow="selGoods"></choose-goods>
  <choose-providers ref="selectProviderRef" @confirm="confirmPro"></choose-providers>
</div>
</template>
<script>
    var _this;
    import splitLR from '@/components/public/splitLR'
    import chooseWare from '@/components/common/ChooseWare'
    import chooseWarePos from '@/components/common/ChooseWarePosition'
    import chooseGoods from '@/components/common/ChooseGoods'
    import chooseProviders from '@/components/common/ChooseProviders'
    export default {
        name:'accstock',
        components:{splitLR,chooseWare,chooseWarePos,chooseGoods,chooseProviders},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'质量疑问商品'}],
              tableHeightL:500,
              tableHeightR:500,
              columns:[
                  {title:'商品编号',key:'goods_code',minWidth:80},
                  {title:'商品名称',key:'goods_name',minWidth:150},
                  {title:'规格',key:'specs',minWidth:90},
                  {title:'剂型',key:'dosage',minWidth:70},
                  {title:'生产企业',key:'production',minWidth:180},
                  {title:'产地',key:'origin',minWidth:90},
                  {title:'批准文号',key:'approval_code',minWidth:140},
                  {title:'货位',key:'pos_code',minWidth:70},
                  {title:'库存',key:'qty',minWidth:90},
                  {title:'单位',key:'unit',minWidth:60},
                  {title:'生产批号',key:'batch_no',minWidth:110},
                  {title:'供应商名称',key:'sup_name',minWidth:150},
                  {title:'生产日期',key:'prod_date',minWidth:90},
                  {title:'有效期至',key:'valid_date',minWidth:90},
                  {title:'记录号',key:'id',minWidth:90},
                  {title:'仓库名称',key:'ware_title',minWidth:90},
                  {title:'货品状态',key:'goods_state',minWidth:90},
                  {title:'质量状态',key:'quality_state',minWidth:90}
              ],
               columnsR:[
                 {title:'单据编号',key:'bill_no',minWidth:160},
                 {title:'锁定日期',key:'fdate',minWidth:140},
                 {title:'商品编号',key:'goods_code',minWidth:60},
                 {title:'商品名称',key:'goods_name',minWidth:150},
                 {title:'仓库名称',key:'ware_title',minWidth:90},
                 {title:'货位',key:'pos_code',minWidth:70},
                 {title:'供应商名称',key:'sup_name',minWidth:150},
                 {title:'生产批号',key:'batch_no',minWidth:110},
                 {title:'规格',key:'specs',minWidth:110},
                 {title:'产地',key:'origin',minWidth:90},
                 {title:'剂型',key:'dosage',minWidth:90},
                 {title:'生产企业',key:'production',minWidth:180},
                 {title:'批准文号',key:'approval_code',minWidth:140},
                 {title:'库存数量',key:'stock_qty',minWidth:90},
                 {title:'锁定数量',key:'locked_qty',minWidth:90},
                 {title:'单位',key:'unit',minWidth:60},
                 {title:'价格',key:'price',minWidth:90},
                 {title:'库存金额',key:'amount',minWidth:90},
                 {title:'锁定金额',key:'locked_amount',minWidth:90},
                 {title:'生产日期',key:'prod_date',minWidth:90},
                 {title:'有效期至',key:'valid_date',minWidth:90},
                 {title:'库存记录号',key:'stock_id',minWidth:80},
                 {title:'疑问药品库',key:'lock_ware_title',minWidth:90},
                 {title:'锁定人',slot:'lock_man',minWidth:70},
                 {title:'锁定原因',key:'remark',minWidth:100},
                 {title:'货品状态',key:'goods_state',minWidth:90},
                 {title:'质量状态',key:'quality_state',minWidth:90},
                 {title:'状态',key:'status_txt',minWidth:90},
                 {title:'解锁人',slot:'unlock_man',minWidth:70},
                 {title:'解锁日期',key:'unlock_date',minWidth:140},
                 {title:'解锁说明',key:'unlock_remark',minWidth:100},
                 {title:'合格数量',key:'eqty',minWidth:90},
                 {title:'不合格数量',key:'reqty',minWidth:90}
               ],
              list:[],
              listR:[],
              loading:false,
              loadingR:false,
              selectIndex:0,
              page:1,
              pageSize:10,
              lockall:false,
              cfg:{goods_status:[],quality_status:[],def:{}},
              search:{ware_code:'',pos_code:'',goods_code:'',batch_no:''},
              searchR:{beg:'',end:'',sup_code:'',goods_name:'',status:0},
              lock:{status:false,qty:'',remark:''}
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        created:function(){
            _this.init_left();
            _this.init_right();
        },
      methods:{
        DHeight(e){
          this.tableHeightL=e-115;
          this.tableHeightR=e-80;
        },
          /**
           * 设置高亮
           */
            rowClassName(row,index) {
                var className='';
                if(index===_this.selectIndex){
                    className+='ivu-table-row-highlight';
                }
                return className;
            },
            /**
             * 初始化左侧库存数据
             */
            init_left:function(){
                _this.loading=true;
                _this.common.http({url:'w/stockList',data:this.search}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.cfg=res.cfg;
                        _this.list=res.data;
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
            /**
             * 初始化右侧疑问商品处理记录
             */
            init_right:function(){
              _this.loadingR=true;
              _this.common.http({url:'w/lockList',data:this.searchR}).then(function(res){
                _this.loadingR=false;
                if(res.status==1){
                  _this.listR=res.data;
                }
              }).catch(function(err){
                _this.common.httpErr(err.data,_this);
              });
            },
            /**
             * 单击选择某一行
             */
            selectRowIndex:function(data,index){
               _this.selectIndex=index;
            },
            /**
             * 打开仓库选择
             */
            show_choware:function (){
              this.$refs.chooseWareRef.open();
            },
            /**
             * 选择仓库后回调
             */
            confirmParentWare:function (e){
              this.$set(this.search,'ware_code',e.ware_code);
              this.$set(this.search,'ware_title',e.ware_title);
            },
            /**
             * 清除选择的仓库
             */
            clearware:function (){
              this.search.ware_code='';
              this.search.ware_title='';
              this.search.pos_code='';
            },
            /**
             * 打开货位选择
             */
            openpos:function () {
              if(this.search.ware_code==''){
                this.alertMsg('请先选择仓库','error',{duration:3});
                return false;
              }
              this.$refs.chooseWareChildRef.open(this.search.ware_code);
            },
            /**
             *  货位回调
             */
            confirmPos:function (e){
              this.$set(this.search,'pos_code',e.pos_code);
            },
            /**
             * 打开产品选择
             */
            openGoods(){
              this.$refs.RefGoods.open();
            },
            /**
             * 选择产品
             */
            selGoods:function (e){
              this.$set(this.search,'goods_code',e.goods_code);
              this.$set(this.search,'goods_name',e.goods_name);
            },
            /**
             * 锁定选中的产品
             */
            lock_sel:function (){
              if(this.list.length==0) return false;
              if(this.lockall){
                var msg='即将锁定('+this.list[this.selectIndex].goods_code+')同仓库所有批号为：'+this.list[this.selectIndex].batch_no+' 的商品，确定继续吗？';
                _this.$Modal.confirm({
                  title:'提示',
                  content:msg,
                  onOk:function(){
                    _this.lock.remark='';
                    _this.lock.status=true;
                  }
                });
              }else{
                this.lock.qty=parseFloat(this.list[this.selectIndex].qty);
                this.lock.remark='';
                this.lock.status=true;
              }
            },
            /**
             * 确定锁定
             */
            save_doubt:function (){
              var qty=parseFloat(this.lock.qty);
              if(!this.lockall && (isNaN(qty) || qty==0)){
                this.alertMsg('请填写锁定数量','error',{duration:3});
                return false;
              }
              var data={lockall:this.lockall,qty:qty,remark:this.lock.remark,stock_id:this.list[this.selectIndex].id,goods_state:this.cfg.def.goods_status,quality_state:this.cfg.def.quality_status};
              _this.$Spin.show();
              _this.common.http({url:'w/lockDrug',data:data}).then(function(res){
                _this.$Spin.hide();
                if(res.status==1){
                  _this.lock.status=false;
                  _this.alertMsg(res.msg);
                  _this.init_left();
                  _this.init_right();
                }else{
                  _this.modalMsg(res.msg);
                }
              }).catch(function(err){
                _this.$Spin.hide();
                _this.common.httpErr(err.data,_this);
              });
            },
            /**
             * 锁定库存输入过滤
             */
            filter_qty:function (key){
              var va=this.lock.qty;
              va=va.replace(/[^\d.]/g,"");
              va=va.replace(/\.{2,}/g,".");
              va=va.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
              this.lock.qty=va.replace(/^(\-)*(\d+)\.(\d\d\d\d\d).*$/,'$1$2.$3');
            },
            /**
             * 打开供应商选择
             */
            openprov:function (){
              this.$refs.selectProviderRef.open();
            },
            /**
             * 选择供应商回调
             */
            confirmPro:function (e){
              this.$set(this.searchR,'sup_code',e.supplier_code);
              this.$set(this.searchR,'sup_name',e.full_name);
            },
            /**
             * 清除选择的供应商
             */
            clearprov:function (){
              this.searchR.sup_code='';
              this.searchR.sup_name='';
            }
        }
    }
</script>
<style lang="less">
.doubt-w{
  .foot-mw{height: auto; padding-top: 15px; clear: both; overflow: hidden;
    .fmfl{float: left;}
    .fmfr{float: right;}
  }
}
</style>
