<template>
    <div>
        <Modal v-model="modal" title="选择商品信息" :mask-closable="false" width="1000" class-name="vertical-center-modal" footer-hide>
            <div class="goods-search">
                <Form :label-width="70" label-position="left">
                    <Row>
                        <Col span="6">
                            <FormItem label="单据编号">
                                <Input placeholder="商品编号" v-model="search.goods_code"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="form-btn">
                            <FormItem label="生产企业">
                                <Input placeholder="生产企业" v-model="search.production"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="form-btn">
                            <FormItem label="主供应商">
                                <Input placeholder="主供应商" v-model="search.supplier" icon="ios-more" @on-click="selectProviders" style="cursor:pointer;"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="form-btn">
                            <Button @click="clearForm">清除条件</Button>
                        </Col>
                    </Row>
                    <Row>
                        <Col span="6">
                            <FormItem label="商品名称">
                                <Input placeholder="商品名称" v-model="search.goods_name"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="form-btn">
                            <FormItem label="产 地">
                                <Input placeholder="产地" v-model="search.origin"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="form-btn">
                            <FormItem label="条形码">
                                <Input placeholder="条形码" v-model="search.code"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6" class="form-btn">
                            <Button type="primary" @click="doSearch">查询商品</Button>
                        </Col>
                    </Row>
                    <Row>
                        <Col span="6">
                            <FormItem label="批准文号">
                                <Input placeholder="批准文号" v-model="search.approval_code"></Input>
                            </FormItem>
                        </Col>
                        <Col span="12" class="form-btn">
                            <FormItem label="商品类别">
                                <Cascader placeholder="选择商品类别" v-model="search.goodstype" :data="category"></Cascader>
                            </FormItem>
                        </Col>
                        <Col span="6"></Col>
                    </Row>
                </Form>
            </div>
            <Table size="small" stripe :columns="columns" :data="list" border class="table-m" :height="220" :loading="loading"
                :row-class-name="rowClassName"
                @on-row-click="(row,index)=>{selectRow(index,false)}"
                @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
                 <template slot-scope="row" slot="is_solit">
                    <Checkbox :value="row.row.is_solit" :true-value="1" :false-value="0" disabled></Checkbox>
                 </template>
            </Table>
            <div class="goods_page">
                <Page :total="total" size="small" :show-total="true" :page-size="pageSize" :page-size-opts="pageSizeOpts" :show-sizer="true" placement="top" @on-change="changePage" @on-page-size-change="changePageSize" class="left" simple/>
                <div class="right">
                    <span style="padding-right:20px;" class="red-text">【红色】表示商品 “ GMP证书已过期 ”</span>
                    <Button type="info">查看商品证照</Button>
                </div>
            </div>
            <div class="goods_qty_price">
                <div class="left">
                    <Table size="small" stripe :columns="qty_columns" :data="qty_list" border class="table-m" :height="220">
                    </Table>
                </div>
                <div class="right">
                    <Table size="small" stripe :columns="price_columns" :data="price_list" border class="table-m" :height="220">
                    </Table>
                </div>
            </div>
            <div class="goods_subbtn">
                <div class="left">
                    <span class="span">
                        <Checkbox v-model="disabledQty" :true-value="1" :false-value="0">无可用库存不显示</Checkbox>
                    </span>
                    <span class="span">
                        <Checkbox v-model="autoPrice" :true-value="1" :false-value="0" @on-change="initGoodsPrice">自动显示价格</Checkbox>
                    </span>
                </div>
                <div class="right">
                      <Button @click="confirm" type="primary">
                         <Icon type="md-checkmark"/>确认选定
                      </Button>
                      <Button @click="close" type="warning" style="margin-left:10px;">
                         <Icon type="md-close" />取消
                      </Button>
                </div>
            </div>
        </Modal>
        <!-- 选择供应商 -->
        <choose-providers v-if="isSignle" ref="selectProviderRef" @confirm="selectProvNotify"></choose-providers>
    </div>
</template>
<script>
  var searchform={goods_code:'',production:'',goods_name:'',origin:'',code:'',approval_code:'',goodstype:[],supplier:''};
  import chooseProviders from '@/components/common/ChooseProviders'
  export default {
     name:'selGoods',
     components:{chooseProviders},
     props:{
       isSignle:{
         type:Boolean,
         default:true
       },
       refname:{
         type:String,
         default:'selectGoodsRef'
       },
       fun:{
         type:String,
         default:"selectProviders"
       }
     },
     data(){
        return {
            modal:false,
            loading:false,
            search:JSON.parse(JSON.stringify(searchform)),
            columns:[
                {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
                {title:'商品编号',key:'goods_code',fixed:'left',width:90,align:"center"},
                {title:'通用名称',key:'name',minWidth:200,resizable:true},
                {title:'商品名称',key:'goods_name',minWidth:200,resizable:true},
                {title:'规格',key:'specs',minWidth:120,resizable:true},
                {title:'包装规格',key:'packspecs',minWidth:100},
                {title:'剂型',key:'dosage',minWidth:100},
                {title:'商品大类',key:'category',minWidth:150},
                {title:'主单位',key:'unit',minWidth:90},
                {title:'辅单位',key:'unit2',minWidth:90},
                {title:'主供应商',key:'supplier',width:100,align:'center'},
                {title:'允许拆分',slot:'is_solit',width:80,align:'center'},
                {title:'产地',key:'origin',minWidth:100},
                {title:'生产企业',key:'production',minWidth:250},
                {title:'生产企业简称',key:'maker',minWidth:150},
                {title:'批准文号/注册证号',key:'approval_code',minWidth:200},
                {title:'税率%',key:'tax',width:100,align:'center'},
                {title:'GMP证书编号',key:'gmp_code',minWidth:140,align:'center'},
                {title:'GMP证书有效期',key:'gmp_end_date',width:120,align:'center'},
                {title:'质量标准',key:'quality_standards',minWidth:90,align:'center'},
                {title:'储存条件',key:'storage_type',minWidth:100,align:'center'},
                {title:'本位码',key:'standard_code',minWidth:160}
            ],
            list:[],
            category:[],
            selectGoodsIndex:0,
            total:0,
            page:1,
            pageSize:5,
            pageSizeOpts:[5,10,15,20],
            autoPrice:1, //自动显示价格
            disabledQty:0, //无可用库存不显示
            /** 库存信息 **/
            qty_columns:[
                {title:'仓库编码',key:'goods_code',width:90,align:"center"},
                {title:'仓库名称',key:'goods_code',minWidth:120},
                {title:'货位编码',key:'goods_code',width:90,align:"center"},
                {title:'数量',key:'goods_code',width:90,align:"center"},
                {title:'单价',key:'goods_code',width:90,align:"center"},
                {title:'金额',key:'goods_code',width:90,align:"center"},
                {title:'可用量',key:'goods_code',width:90,align:"center"},
                {title:'生产批号',key:'goods_code',width:90,align:"center"},
                {title:'有效期至',key:'goods_code',width:90,align:"center"},
            ],
            qty_list:[],
            /** 商品价格体系 **/
            price_columns:[
                {title:'方案编号',key:'mode_id',width:70,align:"center"},
                {title:'价格方案',key:'mode_name',width:117},
                {title:'主单位价格',key:'price1',width:85,align:"center"},
                {title:'辅单位价格',key:'price2',width:85,align:"center"},
            ],
            price_list:[]
        }
     },
     methods:{
          rowClassName(row, index) {
           let className='';
           if(index === this.selectGoodsIndex) {
              className='ivu-table-row-highlight';
           }
           //判断GMP过期
           if(row.gmp_end_date!=null && row.gmp_end_date.length>0){
              let gmptime=new Date(row.gmp_end_date);
              let nowtime=new Date().getTime();
              if(gmptime<=nowtime){
                 className+=' red-text';
              }
           }
           return className;
         },
         init:function(){
            var _this=this;
            _this.loading=true;
            var data={page:_this.page,pageSize:_this.pageSize,search:_this.search};
            _this.common.http({url:'chooseGoodsList',data:data}).then(function(res){
                _this.loading=false;
                if(res.status==1){
                    _this.total=res.list.total;
                    _this.list=res.list.data;
                    _this.category=res.category;
                    _this.initGoodsPrice();
                }
            }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
            });
         },
         doSearch:function(){
            this.selectGoodsIndex=-1;
            this.init();
         },
         changePage:function(page){
            this.page=page;
            this.init();
         },
         changePageSize:function(pageSize){
            this.page=1;
            this.pageSize=pageSize;
            this.init();
         },
         clearForm:function(){
            this.search=JSON.parse(JSON.stringify(searchform));
         },
         open:function(){
            this.modal=true;
            this.init();
         },
         close:function(){
            this.modal=false;
         },
         selectRow:function(index,type){
            this.selectGoodsIndex=index;
            if(type) this.confirm();
            if(!type) this.initGoodsPrice();
         },
         confirm:function(){
            var _this=this;
            if(_this.selectGoodsIndex<0){
              return _this.alertMsg('请先选择商品后操作','error');
            }
            var data=JSON.parse(JSON.stringify(_this.list[_this.selectGoodsIndex]));
            _this.$emit("selectRow",data);
            _this.close();
         },
         /****选择供应商****/
         selectProviders:function(){
            var _this=this;
            if(_this.isSignle){
                _this.$refs.selectProviderRef.open();
            }else{
                _this.$parent[_this.fun](_this.refname);
            }
         },
         selectProvNotify:function(e){
            this.search.supplier=e.supplier_code;
         },
         /*************显示价格体系************/
         initGoodsPrice:function(){
            var _this=this;
            if(_this.selectGoodsIndex<0) return false;
            if(parseInt(_this.autoPrice)!=1){
                _this.price_list=[];
                return false;
            }
            var goods_code=_this.list[_this.selectGoodsIndex]['goods_code'];
            _this.common.http({url:'getPriceList',data:{goods_code:goods_code}}).then(function(res){
                if(res.status==1){
                    _this.price_list=res.data;
                }
            }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
            });
         }
     }
  }
</script>
<style lang="less">
  .goods-search{
     padding-bottom:8px;
     .form-btn{
        padding-left:40px;
     }
  }
  .vertical-center-modal{
      display:flex;
      align-items:center;
      justify-content:center;
      .ivu-modal{
        top:0;
      }
  }
  .goods_page{
      padding-top:15px;padding-bottom:10px;overflow:hidden;
      .left{width:30%;float:left;}
      .right{
         width:70%;float:right;text-align:right;
      }
  }
  .goods_subbtn{
      padding-top:15px;padding-bottom:10px;overflow:hidden;
      .span{margin-right:15px;}
      .left{width:60%;float:left;}
      .right{width:40%;float:right;text-align:right;}
  }
  .goods_qty_price{
      overflow:hidden;padding-bottom:10px;
      .left{width:60%;float:left;}
      .right{width:39%;float:right;}
  }
</style>
