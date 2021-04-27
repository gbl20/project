<template>
<div>
  <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
    <div slot="form-ser">
      <Form :label-width="80" style="width: 1200px; padding-top: 10px;">
        <Row>
          <Col span="4">
            <FormItem label="报告日期从">
              <DatePicker type="date" v-model="search.beg"></DatePicker>
            </FormItem>
          </Col>
          <Col span="3">
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
          <Col span="8">
            <Button @click="init" style="margin-left: 10px;"><span class="icon iconfont">&#xe691;</span>查询</Button>
            <Button style="margin-left: 10px;"><span class="icon iconfont">&#xe791;</span>修改</Button>
            <Button style="margin-left: 10px;" @click="init"><span class="icon iconfont">&#xe788;</span>刷新</Button>
            <span class="reject-tips">双击审核</span>
          </Col>
        </Row>
      </Form>
    </div>
    <div slot="table-list">
      <Table size="small" :row-class-name="rowClassName" @on-row-click="selectRowIndex" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading" @on-row-dblclick="check_reject">
        <template slot-scope="row" slot="creater">{{$store.state.emp[row.row.creater]}}</template>
        <template slot-scope="row" slot="qcman">{{$store.state.emp[row.row.qcman]}}</template>
        <template slot-scope="row" slot="qcdepman">{{$store.state.emp[row.row.qcdepman]}}</template>
        <template slot-scope="row" slot="qcauditman">{{$store.state.emp[row.row.qcauditman]}}</template>
      </Table>
    </div>
  </split-none>
  <Modal width="500" v-model="cinfo.status" :mask-closable="false" footer-hide title="不合格药品报告审核" class-name="reject-check">
    <Form :label-width="85">
      <Row>
        <Col span="12">
          <FormItem label="商品编号">
            <Input disabled :value="cinfo.goods_code"></Input>
          </FormItem>
        </Col>
        <Col span="12">
          <FormItem label="生产批号">
            <Input disabled :value="cinfo.batch_no"></Input>
          </FormItem>
        </Col>
      </Row>
      <Row>
        <Col span="12">
          <FormItem label="不合格数量">
            <Input disabled :value="cinfo.qty"></Input>
          </FormItem>
        </Col>
        <Col span="12">
          <FormItem label="发现日期">
            <Input disabled :value="cinfo.detec_date"></Input>
          </FormItem>
        </Col>
      </Row>
      <FormItem label="发现环节">
        <Input disabled :value="cinfo.detec_tache"></Input>
      </FormItem>
      <FormItem label="不合格项目">
        <Input disabled :value="cinfo.thing_descr"></Input>
      </FormItem>
      <FormItem label="质量管理员调查情况">
        <Input type="textarea" :autosize="{minRows:2,maxRows:2}" maxlength="150" v-model="cinfo.qcsurvey" :disabled="cinfo.qcauditman?true:false"></Input>
      </FormItem>
      <Row>
        <Col span="12">
          <FormItem label="质量管理员">
            <Input icon="md-checkmark" :disabled="cinfo.qcauditman?true:false" readonly style="cursor: pointer;" :value="$store.state.emp[cinfo.qcman]" @on-click="chooseOp('quality_admin')"></Input>
          </FormItem>
        </Col>
        <Col span="12">
          <FormItem label="日期">
            <Input disabled :value="cinfo.qc_date"></Input>
          </FormItem>
        </Col>
      </Row>
      <FormItem label="质量管理部确认意见">
        <Input type="textarea" :disabled="cinfo.qcauditman?true:false" :autosize="{minRows:2,maxRows:2}" maxlength="150" v-model="cinfo.qcdeptconfirm"></Input>
      </FormItem>
      <Row>
        <Col span="12">
          <FormItem label="质管部签字">
            <Input icon="md-checkmark" :disabled="cinfo.qcauditman?true:false" readonly style="cursor: pointer;" :value="$store.state.emp[cinfo.qcdepman]" @on-click="chooseOp('quality_depart')"></Input>
          </FormItem>
        </Col>
        <Col span="12">
          <FormItem label="日期">
            <Input disabled :value="cinfo.qcdep_date"></Input>
          </FormItem>
        </Col>
      </Row>
      <FormItem label="质量负责人审核意见">
        <Input type="textarea" :autosize="{minRows:2,maxRows:2}" maxlength="150" v-model="cinfo.qcaudit" :disabled="cinfo.qcauditman?true:false"></Input>
      </FormItem>
      <Row>
        <Col span="12">
          <FormItem label="质量负责人">
            <Input icon="md-checkmark" :disabled="cinfo.qcauditman?true:false" readonly style="cursor: pointer;" :value="$store.state.emp[cinfo.qcauditman]" @on-click="chooseOp('quality_director')"></Input>
          </FormItem>
        </Col>
        <Col span="12">
          <FormItem label="日期">
            <Input disabled :value="cinfo.qcaudit_date"></Input>
          </FormItem>
        </Col>
      </Row>
    </Form>
    <div class="foot-mw">
      <div class="fmfr">
        <span v-if="cinfo.check_status" class="reject-check-tips">当前报告单已审核</span>
        <Button style="margin-right: 15px;" v-if="!cinfo.check_status" @click="sub_check"><span class="icon iconfont">&#xe7fe;</span>确定</Button>
        <Button @click="cinfo.status=false"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
      </div>
    </div>
  </Modal>
  <choose-providers ref="selectProviderRef" @confirm="confirmPro"></choose-providers>
  <verify-user ref="verifyUserRef" :postCode="postCode" :paramData="{id:cinfo.id}" processingMethod="checkRejectReport" @confirm="confirmOp"></verify-user>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import chooseProviders from '@/components/common/ChooseProviders'
    import verifyUser from '@/components/common/VerifyUser'
    export default {
        name:'reject',
        components:{splitNone,chooseProviders,verifyUser},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'不合格药品'},{title:'不合格药品报告确认表'}],
              height:0,
              postCode:'',
              columns:[
                  {title:'序号',key:'id',minWidth:60},
                  {title:'报告时间',key:'f_date',minWidth:90},
                  {title:'商品编号',key:'goods_code',minWidth:80},
                  {title:'商品名称',key:'goods_name',minWidth:160},
                  {title:'单位',key:'unit',minWidth:60},
                  {title:'规格',key:'specs',minWidth:100},
                  {title:'不合格数量',key:'qty',minWidth:80},
                  {title:'库存单价',key:'price',minWidth:80},
                  {title:'库存金额',key:'amount',minWidth:90},
                  {title:'生产批号',key:'batch_no',minWidth:120},
                  {title:'生产日期',key:'prod_date',minWidth:90},
                  {title:'有效期至',key:'valid_date',minWidth:90},
                  {title:'供应商',key:'sup_name',minWidth:160},
                  {title:'购进日期',key:'purch_date',minWidth:90},
                  {title:'进货数量',key:'inqty',minWidth:70},
                  {title:'存放仓库',key:'ware_title',minWidth:90},
                  {title:'货位',key:'pos_code',minWidth:80},
                  {title:'发现日期',key:'detec_date',minWidth:90},
                  {title:'发现环节',key:'detec_tache',minWidth:90},
                  {title:'不合格项目及情况',key:'thing_descr',minWidth:120},
                  {title:'质量管理员调查情况',key:'qcsurvey',minWidth:120},
                  {title:'质量管理员',slot:'qcman',minWidth:70},
                  {title:'质量管理员调查日期',key:'qc_date',minWidth:90},
                  {title:'质量管理部确认意见',key:'qcdeptconfirm',minWidth:120},
                  {title:'质量管理部负责人',slot:'qcdepman',minWidth:70},
                  {title:'质量管理部确认日期',key:'qcdep_date',minWidth:90},
                  {title:'质量负责人审核意见',key:'qcaudit',minWidth:120},
                  {title:'质量负责人',slot:'qcauditman',minWidth:70},
                  {title:'质量负责人审核日期',key:'qcaudit_date',minWidth:90},
                  {title:'报告人',slot:'creater',minWidth:70},
                  {title:'质量疑问药品锁定单号',key:'src_bill_no',minWidth:155},
                  {title:'货品状态',key:'goods_state',minWidth:150},
                  {title:'质量状态',key:'quality_state',minWidth:70},
                  {title:'剂型',key:'dosage',minWidth:70},
                  {title:'批准文号',key:'approval_code',minWidth:130},
                  {title:'产地',key:'origin',minWidth:90},
                  {title:'生产企业',key:'production',minWidth:160}
              ],
              list:[],
              loading:false,
              selectIndex:0,
              page:1,
              search:{},
              cinfo:{
                status:false,
                id:'',
                goods_code:'',
                batch_no:'',
                qty:'',
                detec_date:'',
                detec_tache:'',
                thing_descr:'',
                qcsurvey:'',
                qcman:'',
                qc_date:'',
                qcdeptconfirm:'',
                qcdepman:'',
                qcdep_date:'',
                qcaudit:'',
                qcauditman:'',
                qcaudit_date:''
              }
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        activated:function(){
            _this.init();
        },
        methods:{
            DHeight(e){
                this.height = e;
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
                _this.common.http({url:'w/reject',data:{search:this.search,page:this.page}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.data.data;
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
             * 审核
             */
            check_reject:function (data){
              _this.cinfo.id=data.id;
              _this.cinfo.goods_code=data.goods_code;
              _this.cinfo.batch_no=data.batch_no;
              _this.cinfo.qty=data.qty;
              _this.cinfo.detec_date=data.detec_date;
              _this.cinfo.detec_tache=data.detec_tache;
              _this.cinfo.thing_descr=data.thing_descr;
              _this.cinfo.qcsurvey=data.qcsurvey;
              _this.cinfo.qcman=data.qcman;
              _this.cinfo.qc_date=data.qc_date;
              _this.cinfo.qcdeptconfirm=data.qcdeptconfirm;
              _this.cinfo.qcdepman=data.qcdepman;
              _this.cinfo.qcdep_date=data.qcdep_date;
              _this.cinfo.qcaudit=data.qcaudit;
              _this.cinfo.qcauditman=data.qcauditman;
              _this.cinfo.qcaudit_date=data.qcaudit_date;
              _this.cinfo.check_status=data.check_status;
              _this.cinfo.status=true;
            },
            /**
             * 确认选择审核人
             */
            confirmOp:function (e){
              if(this.postCode == 'quality_admin'){
                this.cinfo.qcman = e.code;
                this.cinfo.qc_date = e.date;
              }else if(this.postCode == 'quality_depart'){
                this.cinfo.qcdepman = e.code;
                this.cinfo.qcdep_date = e.date;
              }else if(this.postCode == 'quality_director'){
                this.cinfo.qcauditman = e.code;
                this.cinfo.qcaudit_date = e.date;
              }
            },
            /**
             * 选择审核人
             */
            chooseOp:function(post_code){
              if(!this.cinfo.id) return false;
              if(post_code == 'quality_director' && (!this.cinfo.qcman || !this.cinfo.qcdepman)) {
                return this.modalMsg('质量管理员和质管部必须先审核!');
              }
              this.postCode = post_code;
              this.$refs.verifyUserRef.open();
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
             * 提交保存审核
             */
            sub_check:function (){
              _this.$Spin.show();
              _this.common.http({url:'w/checkReject',data:_this.cinfo}).then(function(res){
                _this.$Spin.hide();
                if(res.status==1){
                  _this.cinfo.status=false;
                  _this.init();
                  _this.alertMsg(res.msg);
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
.reject-tips{
  display: inline-block; margin-left: 20px; height: 28px; font-size: 13px; line-height: 28px; color: #ff0000;
}
.reject-check-tips{
  display: inline-block; margin-right: 20px; height: 28px; font-size: 13px; line-height: 28px; color: #ff0000;
}
.reject-check{
  .foot-mw{height: auto; padding-top: 15px; clear: both; overflow: hidden;
    .fmfl{float: left;}
    .fmfr{float: right;}
  }
}
</style>
