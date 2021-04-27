<template>
<div>
  <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
    <div slot="form-ser">
      <Form :label-width="80" style="width: 1200px; padding-top: 10px;">
        <Row>
          <Col span="5">
            <FormItem label="锁定日期从">
              <DatePicker type="date" v-model="search.beg"></DatePicker>
            </FormItem>
          </Col>
          <Col span="4">
            <FormItem label="至" :label-width="30">
              <DatePicker type="date" v-model="search.end"></DatePicker>
            </FormItem>
          </Col>
          <Col span="4">
            <FormItem label="供应商">
              <Input icon="ios-more" :value="search.sup_name" style="cursor: pointer;" clearable readonly @on-click="openprov" @on-clear="clearprov"></Input>
            </FormItem>
          </Col>
          <Col span="5">
            <FormItem label="产品名称">
              <Input v-model="search.goods_name"></Input>
            </FormItem>
          </Col>
          <Col span="6">
            <Button @click="init" style="margin-left: 10px;"><span class="icon iconfont">&#xe691;</span>查询</Button>
          </Col>
        </Row>
      </Form>
    </div>
    <div slot="table-list">
      <Table size="small" :row-class-name="rowClassName" @on-row-click="selectRowIndex" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading">
        <template slot-scope="row" slot="lock_man">{{$store.state.emp[row.row.lock_man]}}</template>
        <template slot-scope="row" slot="unlock_man">{{$store.state.emp[row.row.unlock_man]}}</template>
      </Table>
      <Form :label-width="80" style="width: 1200px; padding-top: 10px;">
        <Row>
          <Col span="4">
            <FormItem label="商品编号">
              <Input :value="seldata.goods_code" disabled></Input>
            </FormItem>
          </Col>
          <Col span="4">
            <FormItem label="生产批号">
              <Input :value="seldata.batch_no" disabled></Input>
            </FormItem>
          </Col>
          <Col span="3">
            <FormItem label="锁定数量">
              <Input :value="seldata.locked_qty" disabled></Input>
            </FormItem>
          </Col>
          <Col span="3">
            <FormItem label="合格数量">
              <input type="text" class="ivu-input ivu-input-default" v-model="subdata.eqty" style="background-color: #19be6b;" maxlength="15" @input="filter_qty('eqty')" />
            </FormItem>
          </Col>
          <Col span="3">
            <FormItem label="不合格数量">
              <input type="text" class="ivu-input ivu-input-default" v-model="subdata.reqty" style="background-color: #ed4014;" maxlength="15" @input="filter_qty('reqty')" />
            </FormItem>
          </Col>
          <Col span="5">
            <FormItem label="发现环节">
              <Select v-model="subdata.detect_tache" :disabled="subdata.reqty>0?false:true">
                <Option :value="p" v-for="(p,key) in cfg.detect_tache" :key="key">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span="2">
            <FormItem label="" :label-width="10">
              <Button type="primary" @click="unlock"><span class="icon iconfont">&#xe7ca;</span>解锁</Button>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem label="解锁原因">
              <Input :value="subdata.unlock_remark" maxlength="150"></Input>
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem label="不合格项目及情况" :label-width="120">
              <Input :value="subdata.thing_descr" maxlength="150" :disabled="subdata.reqty>0?false:true"></Input>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="6">
            <FormItem label="解锁后合格货品状态" :label-width="135">
              <Select v-model="subdata.goods_state" :disabled="subdata.eqty>0?false:true">
                <Option :value="p" v-for="(p,key) in cfg.goods_status" :key="key">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span="5">
            <FormItem label="解锁后合格质量状态" :label-width="135">
              <Select v-model="subdata.quality_state" :disabled="subdata.eqty>0?false:true">
                <Option :value="p" v-for="(p,key) in cfg.quality_status" :key="key">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem label="解锁后不合格货品状态" :label-width="150" style="color: #ed4014">
              <Select v-model="subdata.rgoods_state" :disabled="subdata.reqty>0?false:true">
                <Option :value="p" v-for="(p,key) in cfg.goods_status" :key="key">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span="5">
            <FormItem label="解锁后不合格质量状态" :label-width="150" style="color: #ed4014">
              <Select v-model="subdata.rquality_state" :disabled="subdata.reqty>0?false:true">
                <Option :value="p" v-for="(p,key) in cfg.quality_status" :key="key">{{p}}</Option>
              </Select>
            </FormItem>
          </Col>
        </Row>
      </Form>
    </div>
  </split-none>
  <choose-providers ref="selectProviderRef" @confirm="confirmPro"></choose-providers>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import chooseProviders from '@/components/common/ChooseProviders'
    export default {
        name:'accstock',
        components:{splitNone,chooseProviders},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'质量疑问锁定商品处理'}],
              height:0,
              cfg:{detect_tache:[],goods_status:[],quality_status:[]},
              columns:[
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
              loading:false,
              selectIndex:0,
              page:1,
              pageSize:10,
              search:{beg:'',end:'',sup_code:'',goods_name:''},
              seldata:{goods_code:'',batch_no:'',locked_qty:''},
              subdata:{eqty:'',reqty:'',detect_tache:'',unlock_remark:'',thing_descr:'',goods_state:'',quality_state:'',rgoods_state:'',rquality_state:''}
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        activated:function(){
            _this.init();
        },
      created() {
          _this.get_cfg();
      },
      methods:{
            DHeight(e){
              this.height = e-116;
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
             * 初始化数据
             */
            init:function(){
                _this.loading=true;
                _this.common.http({url:'w/dealList',data:this.search}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.data;
                        if(res.data.length>0){
                          _this.seldata=res.data[0];
                          _this.subdata.thing_descr=res.data[0].remark;
                        }
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
            /**
             * 获取配置项
             */
            get_cfg:function (){
              _this.common.http({url:'w/getDoubtCfg'}).then(function(res){
                if(res.status==1){
                  _this.cfg=res.cfg;
                  _this.subdata.detect_tache=res.cfg.detect_tache[0];
                  _this.subdata.goods_state=res.cfg.goods_status[1];
                  _this.subdata.quality_state=res.cfg.quality_status[0];
                  _this.subdata.rgoods_state=res.cfg.goods_status[17];
                  _this.subdata.rquality_state=res.cfg.quality_status[1];
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
               _this.seldata=this.list[index];
               _this.subdata.eqty='';
               _this.subdata.reqty='';
               _this.subdata.thing_descr=this.list[index].remark;
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
              this.$set(this.search,'sup_code',e.supplier_code);
              this.$set(this.search,'sup_name',e.full_name);
            },
            /**
             * 清除选择的供应商
             */
            clearprov:function (){
              this.search.sup_code='';
              this.search.sup_name='';
            },
            /**
             * 库存输入过滤
             */
            filter_qty:function (key){
              var va=this.subdata[key];
              va=va.replace(/[^\d.]/g,"");
              va=va.replace(/\.{2,}/g,".");
              va=va.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
              this.subdata[key]=va.replace(/^(\-)*(\d+)\.(\d\d\d\d\d).*$/,'$1$2.$3');
              if(this.subdata[key]>this.seldata.locked_qty) this.subdata[key]=this.seldata.locked_qty;
              if(key=='eqty') this.subdata.reqty=this.formatFloat(this.seldata.locked_qty-this.subdata.eqty,5);
              else this.subdata.eqty=this.formatFloat(this.seldata.locked_qty-this.subdata.reqty,5);
            },
            /**
             * 解锁
             */
            unlock:function (){
              if(this.subdata.eqty=='' && this.subdata.reqty==''){
                this.alertMsg('请填写合格数量与不合格数量','error',{duration:3});
                return false;
              }
              _this.$Spin.show();
              _this.subdata.bill_no=this.seldata.bill_no;
              _this.common.http({url:'w/unlock',data:this.subdata}).then(function(res){
                _this.$Spin.hide();
                if(res.status==1){
                  _this.init();
                  _this.subdata.eqty='';
                  _this.subdata.reqty='';
                  _this.alertMsg(res.msg,'success');
                }else{
                  _this.modalMsg(res.msg);
                }
              }).catch(function(err){
                _this.common.httpErr(err.data,_this);
              });
            }
        }
    }
</script>
<style lang="less">
</style>
