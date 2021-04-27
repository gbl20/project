<template>
<div>
  <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
    <div slot="form-ser">
      <Form :label-width="80" style="width: 1200px; padding-top: 10px;">
        <Row>
          <Col span="4">
            <FormItem label="日期从" :label-width="60">
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
          <Col span="6">
            <FormItem label="状态" :label-width="60">
              <Checkbox v-model="search.bs_flag" :true-value="1" :false-value="0">已报损</Checkbox>
              <Checkbox v-model="search.xh_flag" :true-value="1" :false-value="0">已销毁</Checkbox>
              <Checkbox v-model="search.th_flag" :true-value="1" :false-value="0">已退货</Checkbox>
            </FormItem>
          </Col>
          <Col span="2">
            <Button @click="init" style="margin-left: 10px;"><span class="icon iconfont">&#xe691;</span>查询</Button>
          </Col>
        </Row>
      </Form>
    </div>
    <div slot="table-list">
      <Table size="small" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading">
        <template slot-scope="row" slot="bs_flag"><Checkbox :value="row.row.bs_flag" :true-value="1" :false-value="0"></Checkbox></template>
        <template slot-scope="row" slot="xh_flag"><Checkbox :value="row.row.xh_flag" :true-value="1" :false-value="0"></Checkbox></template>
        <template slot-scope="row" slot="th_flag"><Checkbox :value="row.row.th_flag" :true-value="1" :false-value="0"></Checkbox></template>
      </Table>
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
        name:'rejectBook',
        components:{splitNone,chooseProviders},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'不合格药品'},{title:'不合格药品台账'}],
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
                  {title:'不合格项目及情况',key:'thing_descr',minWidth:120},
                  {title:'处理情况',key:'progress_state',minWidth:120},
                  {title:'原报告ID',key:'report_id',minWidth:70},
                  {title:'已报损',slot:'bs_flag',minWidth:60},
                  {title:'已销毁',slot:'xh_flag',minWidth:60},
                  {title:'已退货',slot:'th_flag',minWidth:60},
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
              search:{bs_flag:0,xh_flag:0,th_flag:0},
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
             * 初始化数据
             */
            init:function(){
                _this.loading=true;
                _this.common.http({url:'w/rejectBook',data:{search:this.search,page:this.page}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.data.data;
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
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
