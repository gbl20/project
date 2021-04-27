<template>
  <div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
         <div slot="form-ser" class="GoodsInOutForm">
             <Form :model="search" :label-width="70" label-position="left">
                <Row>
                   <Col span="9">
                       <FormItem label="按日期">
                          <DatePicker type="date" v-model="search.startDate" class="dateSel" :editable="false" placeholder="开始日期"></DatePicker>
                          <span>至</span>
                          <DatePicker type="date" v-model="search.endDate" class="dateSel" :editable="false" placeholder="结束日期"></DatePicker>
                       </FormItem>
                       <div class="formItem">
                          <FormItem label="生产企业" class="w">
                             <Input placeholder="生产企业"></Input>
                          </FormItem>
                          <FormItem label="出入类型" class="w">
                             <Select v-if="JSON.stringify($store.state.inoutKind)!='[]'">
                                <Option v-for="(p,k) in $store.state.inoutKind" :value="k" :key="k">{{p}}</Option>
                             </Select>
                          </FormItem>
                       </div>
                       <div class="formItem">
                          <FormItem label="供应商">
                             <Input placeholder="供应商编码" class="selSup_l" icon="ios-more" readonly></Input>
                             <Input class="selSup_r" disabled></Input>
                          </FormItem>
                       </div>
                       <div class="formItem">
                          <FormItem label="按仓库" class="w">
                              <Input placeholder="选择仓库" icon="ios-more" readonly></Input>
                          </FormItem>
                          <FormItem label="按货位" class="w">
                              <Input placeholder="选择货位" icon="ios-more" readonly></Input>
                          </FormItem>
                       </div>
                       <div class="formItem">
                          <FormItem label="主供应商" class="w">
                              <Input icon="ios-more" readonly></Input>
                          </FormItem>
                          <FormItem label="采购负责人" class="w" :label-width="80">
                              <Input icon="ios-more" readonly></Input>
                          </FormItem>
                       </div>
                   </Col>
                   <Col span="5" class="leftCol">
                       <FormItem label="商品编号">
                          <Input icon="ios-more" placeholder="商品编号" style="cursor:pointer;"></Input>
                       </FormItem>
                       <FormItem label="商品大类">
                          <Input placeholder="商品大类" style="cursor:pointer;"></Input>
                       </FormItem>
                       <FormItem label="功能类别">
                          <Input placeholder="功能类别" style="cursor:pointer;"></Input>
                       </FormItem>
                       <FormItem label="商品名称">
                          <Input placeholder="商品名称" style="cursor:pointer;"></Input>
                       </FormItem>
                       <FormItem label="备注说明">
                          <Input></Input>
                       </FormItem>
                   </Col>
                   <Col span="5" class="leftCol">
                       <FormItem label="生产批号">
                          <Input placeholder="生产批号"></Input>
                       </FormItem>
                       <FormItem label="验收类型" class="w">
                          <Select v-if="JSON.stringify($store.state.sysParam)!='[]'">
                             <Option v-for="(p,k) in $store.state.sysParam['gsp_category']" :value="k" :key="k">{{p}}</Option>
                          </Select>
                       </FormItem>
                       <FormItem label="库存数量">
                          <Select style="display:inline-block;width:70px;" placeholder="条件">
                              <Option value="=">=</Option>
                              <Option value=">">></Option>
                              <Option value=">=">>=</Option>
                              <Option value="<"><</Option>
                              <Option value="<"><=</Option>
                          </Select>
                          <Input class="qtyNum"></Input>
                       </FormItem>
                       <FormItem label="ABC分类" class="w">
                           <Select>
                               <Option value="A">A</Option>
                               <Option value="B">B</Option>
                               <Option value="C">C</Option>
                           </Select>
                       </FormItem>
                       <FormItem label="按 税 率" class="w">
                           <Input></Input>
                       </FormItem>
                   </Col>
                   <Col span="5" class="leftCol">
                     <Button type="warning" @click="searchData">查询数据</Button>
                     <Button type="info" style="display:block;margin-top:15px;">清除条件</Button>
                   </Col>
                </Row>
             </Form>
         </div>
         <div slot="table-list">
            <Tabs type="card" :animated="false" class="GoodsQtyTabs" @on-click="changeTabs">
                <TabPane label="入库明细" name="inqty">
                    <div class="qtytools">
                       <Button style="margin-right:20px;"  @click="lookDrugReport">查看药检报告</Button>
                       <RadioGroup v-model="search.status.instatus" @on-change="searchData">
                          <Radio label="0"><span>显示全部</span></Radio>
                          <Radio label="1"><span>只显示无药检报告的记录</span></Radio>
                          <Radio label="2"><span>只显示有药检报告的记录</span></Radio>
                       </RadioGroup>
                    </div>
                    <Table size="small" stripe :columns="inqty_columns" :row-class-name="rowClassName" :data="inqty_list" border class="table-m" :loading="loadding"
                           @on-row-click="selectRowIndex" :height="height-122">
                        <template slot-scope="row" slot="creator_name">
                           <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.creator]}}</span>
                        </template>
                        <template slot-scope="row" slot="status">
                           <Checkbox v-model="row.row.status" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="isstock">
                           <Checkbox v-model="row.row.isstock" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="is_buyer">
                           <Checkbox v-model="row.row.is_buyer" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="is_sale">
                           <Checkbox v-model="row.row.is_sale" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                    </Table>
                </TabPane>
                <TabPane label="出库明细" name="outqty">
                    <div class="qtytools">
                       <Button style="margin-right:20px;"  @click="lookDrugReport">查看药检报告</Button>
                       <RadioGroup v-model="search.status.outstatus" @on-change="searchData">
                          <Radio label="0"><span>显示全部</span></Radio>
                          <Radio label="1"><span>只显示无药检报告的记录</span></Radio>
                          <Radio label="2"><span>只显示有药检报告的记录</span></Radio>
                       </RadioGroup>
                    </div>
                    <Table size="small" stripe :columns="outqty_columns" :row-class-name="rowClassName" :data="outqty_list" border class="table-m" :loading="loadding"
                          @on-row-click="selectRowIndex" :height="height-122">
                        <template slot-scope="row" slot="creator_name">
                           <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.creator]}}</span>
                        </template>
                        <template slot-scope="row" slot="status">
                           <Checkbox v-model="row.row.status" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="isstock">
                           <Checkbox v-model="row.row.isstock" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="is_buyer">
                           <Checkbox v-model="row.row.is_buyer" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="is_sale">
                           <Checkbox v-model="row.row.is_sale" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                    </Table>
                </TabPane>
                <TabPane label="库存明细" name="deqty">
                    <Table size="small" stripe :columns="deqty_columns" :row-class-name="rowClassName" :data="deqty_list" border class="table-m"
                          :loading="loadding" :height="height-72">
                        <template slot-scope="row" slot="updator_name">
                           <span v-if="JSON.stringify($store.state.emp)!='[]'">{{$store.state.emp[row.row.updator]}}</span>
                        </template>
                        <template slot-scope="row" slot="status">
                           <Checkbox v-model="row.row.status" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="isstock">
                           <Checkbox v-model="row.row.isstock" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="is_buyer">
                           <Checkbox v-model="row.row.is_buyer" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                        <template slot-scope="row" slot="is_sale">
                           <Checkbox v-model="row.row.is_sale" :true-value="1" :false-value="0" disabled></Checkbox>
                        </template>
                    </Table>
                </TabPane>
                <TabPane label="分仓库存" name="batchqty">
                    <div class="qtytools">
                       <Button style="margin-right:10px;">导入药检报告</Button>
                       <Button style="margin-right:10px;">管理药检报告</Button>
                       <Button style="margin-right:20px;">查看药检报告</Button>
                       <RadioGroup v-model="search.status.batchstatus" @on-change="searchData">
                          <Radio label="0"><span>显示全部</span></Radio>
                          <Radio label="1"><span>只显示无药检报告的记录</span></Radio>
                          <Radio label="2"><span>只显示有药检报告的记录</span></Radio>
                       </RadioGroup>
                    </div>
                    <Table size="small" stripe :columns="batchqty_columns" :row-class-name="rowClassName" :data="batchqty_list" border class="table-m" :loading="loadding"
                           :height="height-122">
                    </Table>
                </TabPane>
                <TabPane label="总库存" name="qty">
                    <Table size="small" stripe :columns="qty_columns" :data="qty_list" border class="table-m" :loading="loadding"
                          :height="height-72">
                    </Table>
                </TabPane>
                <div slot="extra">
                    <Page :total="total" size="small" :show-total="true" :page-size="pageSize" :show-sizer="true" placement="top" @on-change="changePage" simple/>
                </div>
            </Tabs>
            <div class="goodsInOut_Tool">
                 颜色标识：
                 <span style="margin-right:10px;"><span class="dot red-bg"></span>库存不可用</span>
                 <span style="margin-right:10px;"><span class="dot brown-bg"></span>停购商品</span>
                 <span style="margin-right:10px;"><span class="dot violet-bg"></span>停售商品</span>
                 <span style="margin-right:10px;"><span class="dot green-bg"></span>正常商品</span>
                 （&nbsp;<span style="margin-right:10px;">有药检报告：浅绿底色</span>|&nbsp;<span style="margin-right:10px;">过期商品：斜体</span>）
            </div>
         </div>
    </split-none>
    <view-drug ref="viewDrugRef"></view-drug>
  </div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import viewDrug from '@/components/common/ViewDrug'
    export default {
       name:'GoodsInOutList',
       components:{splitNone,viewDrug},
       data(){
          return {
            height:0,
            Breadcrumb:[{title:'仓储物流'},{title:'库存查询'},{title:'商品出入库查询'}],
            search:{
               status:{instatus:'0',outstatus:'0',batchstatus:'0'},
               startDate:'',endDate:'',
            },
            loadding:false,
            page:1, //当前页码数
            total:0, //总记录数
            pageSize:30, //页码数
            selectTabs:'inqty',
            selectListIndex:0, //默认选择行
            /* 入库明细 */
            inqty_columns:[
               {title:'序号',type:'index',key:'index',fixed:'left',width:70,align:'center'},
               {title:'日期',key:'create_date',width:140,align:'center'},
               {title:'商品编号',key:'goods_code',width:90,align:'center'},
               {title:'通用名称',key:'gname',minWidth:160},
               {title:'商品名称',key:'goods_name',minWidth:180},
               {title:'单位',key:'unit',width:80,align:'center'},
               {title:'规格',key:'specs',minWidth:120},
               {title:'剂型',key:'dosage',minWidth:90},
               {title:'仓库编号',key:'ware_code',width:90,align:'center'},
               {title:'仓库名称',key:'ware_title',minWidth:140},
               {title:'货位编码',key:'pos_code',width:90,align:'center'},
               {title:'数量',key:'qty',width:100,align:'center'},
               {title:'单价',key:'price',width:100,align:'center'},
               {title:'合计',key:'account',width:100,align:'center'},
               {title:'生产批号',key:'batch_no',width:120},
               {title:'生产日期',key:'prod_date',width:100,align:'center'},
               {title:'有效期至',key:'prod_date',width:100,align:'center'},
               {title:'供应商编号',key:'sup_code',width:100,align:'center'},
               {title:'供应商名称',key:'full_name',minWidth:200},
               {title:'出入库类型',key:'kind_name',width:120,align:'center'},
               {title:'产地',key:'origin',minWidth:120},
               {title:'生产企业',key:'production',minWidth:200},
               {title:'批准文号/注册证号',key:'approval_code',minWidth:150},
               {title:'对应单号',key:'reforderid',width:160,align:'center'},
               {title:'记录号',key:'stock_id',width:100,align:'center'},
               {title:'是否有效',slot:'status',width:90,align:'center'},
               {title:'库存可用',slot:'isstock',width:90,align:'center'},
               {title:'暂停采购',slot:'is_buyer',width:90,align:'center'},
               {title:'暂停销售',slot:'is_sale',width:90,align:'center'},
               {title:'货品状态',key:'goods_state',width:100,align:'center'},
               {title:'质量状态',key:'quality_state',width:100,align:'center'},
               {title:'创建者',key:'creator',width:90,align:'center'},
               {title:'创建者姓名',slot:'creator_name',width:90,align:'center'}
            ],
            inqty_list:[],
            /* 出库明细 */
            outqty_columns:[
              {title:'序号',type:'index',key:'index',fixed:'left',width:70,align:'center'},
              {title:'日期',key:'create_date',width:140,align:'center'},
              {title:'商品编号',key:'goods_code',width:90,align:'center'},
              {title:'通用名称',key:'gname',minWidth:160},
              {title:'商品名称',key:'goods_name',minWidth:180},
              {title:'单位',key:'unit',width:80,align:'center'},
              {title:'规格',key:'specs',minWidth:120},
              {title:'剂型',key:'dosage',minWidth:90},
              {title:'仓库编号',key:'ware_code',width:90,align:'center'},
              {title:'仓库名称',key:'ware_title',minWidth:140},
              {title:'货位编码',key:'pos_code',width:90,align:'center'},
              {title:'数量',key:'qty',width:100,align:'center'},
              {title:'单价',key:'price',width:100,align:'center'},
              {title:'合计',key:'account',width:100,align:'center'},
              {title:'生产批号',key:'batch_no',width:120},
              {title:'生产日期',key:'prod_date',width:100,align:'center'},
              {title:'有效期至',key:'prod_date',width:100,align:'center'},
              {title:'供应商编号',key:'sup_code',width:100,align:'center'},
              {title:'供应商名称',key:'full_name',minWidth:200},
              {title:'出入库类型',key:'kind_name',width:120,align:'center'},
              {title:'产地',key:'origin',minWidth:120},
              {title:'生产企业',key:'production',minWidth:200},
              {title:'批准文号/注册证号',key:'approval_code',minWidth:150},
              {title:'对应单号',key:'reforderid',width:160,align:'center'},
              {title:'记录号',key:'stock_id',width:100,align:'center'},
              {title:'是否有效',slot:'status',width:90,align:'center'},
              {title:'库存可用',slot:'isstock',width:90,align:'center'},
              {title:'暂停采购',slot:'is_buyer',width:90,align:'center'},
              {title:'暂停销售',slot:'is_sale',width:90,align:'center'},
              {title:'货品状态',key:'goods_state',width:100,align:'center'},
              {title:'质量状态',key:'quality_state',width:100,align:'center'},
              {title:'创建者',key:'creator',width:90,align:'center'},
              {title:'创建者姓名',slot:'creator_name',width:90,align:'center'}
            ],
            outqty_list:[],
            /* 库存明细 */
            deqty_columns:[
               {title:'序号',type:'index',key:'index',fixed:'left',width:70,align:'center'},
               {title:'日期',key:'update_date',width:140,align:'center'},
               {title:'商品编号',key:'goods_code',width:90,align:'center'},
               {title:'通用名称',key:'gname',minWidth:160},
               {title:'商品名称',key:'goods_name',minWidth:180},
               {title:'单位',key:'unit',width:80,align:'center'},
               {title:'规格',key:'specs',minWidth:120},
               {title:'剂型',key:'dosage',minWidth:90},
               {title:'仓库编号',key:'ware_code',width:90,align:'center'},
               {title:'仓库名称',key:'ware_title',minWidth:140},
               {title:'货位编码',key:'pos_code',width:90,align:'center'},
               {title:'主单位数量',key:'qty',width:100,align:'center'},
               {title:'采购单价',key:'price1',width:100,align:'center'},
               {title:'合计总额',key:'amount',width:100,align:'center'},
               {title:'入库时数量',key:'inqty',width:100,align:'center'},
               {title:'生产批号',key:'batch_no',width:120},
               {title:'生产日期',key:'prod_date',width:100,align:'center'},
               {title:'有效期至',key:'valid_date',width:100,align:'center'},
               {title:'供应商编号',key:'sup_code',width:100,align:'center'},
               {title:'供应商名称',key:'full_name',minWidth:200},
               {title:'出入库类型',key:'kind_name',width:120,align:'center'},
               {title:'产地',key:'origin',minWidth:120},
               {title:'生产企业',key:'production',minWidth:200},
               {title:'批准文号/注册证号',key:'approval_code',minWidth:150},
               {title:'对应单号',key:'reforderid',width:160,align:'center'},
               {title:'是否有效',slot:'status',width:90,align:'center'},
               {title:'库存可用',slot:'isstock',width:90,align:'center'},
               {title:'暂停采购',slot:'is_buyer',width:90,align:'center'},
               {title:'暂停销售',slot:'is_sale',width:90,align:'center'},
               {title:'货品状态',key:'goods_state',width:100,align:'center'},
               {title:'质量状态',key:'quality_state',width:100,align:'center'},
               {title:'采购负责人',slot:'updator_name',width:90,align:'center'}
            ],
            deqty_list:[],
            /* 分仓库存 */
            batchqty_columns:[
                {title:'序号',type:'index',key:'index',fixed:'left',width:70,align:'center'},
                {title:'商品编号',key:'goods_code',width:90,align:'center'},
                {title:'通用名称',key:'gname',minWidth:160},
                {title:'商品名称',key:'goods_name',minWidth:180},
                {title:'规格',key:'specs',minWidth:120},
                {title:'剂型',key:'dosage',minWidth:90},
                {title:'仓库编号',key:'ware_code',width:90,align:'center'},
                {title:'仓库名称',key:'ware_title',minWidth:140},
                {title:'货位编码',key:'pos_code',width:90,align:'center'},
                {title:'供应商编号',key:'sup_code',width:100,align:'center'},
                {title:'供应商名称',key:'full_name',minWidth:200},
                {title:'主单位',key:'unit',width:80,align:'center'},
                {title:'主单位数量',key:'qty',width:100,align:'center'},
                {title:'辅单位',key:'unit2',width:80,align:'center'},
                {title:'辅单位数量',key:'qty1',width:100,align:'center'},
                {title:'转换率',key:'solit_value',width:85,align:'center'},
                {title:'生产批号',key:'batch_no',width:120},
                {title:'生产日期',key:'prod_date',width:100,align:'center'},
                {title:'有效期至',key:'valid_date',width:100,align:'center'},
                





            ],
            batchqty_list:[],
            /* 总库存 */
            qty_columns:[],
            qty_list:[]
          }
        },
        beforeCreate:function(){
           _this=this;
        },
        created:function(){
           _this.initDate();
           _this.initQty();
        },
        methods:{
            rowClassName:function(row,index){
                var className="";
                if (index === _this.selectListIndex) {
                    className+='ivu-table-row-highlight';
                }
                if(row.isstock!=1){ //库存不可用
                   className+=' red-text';
                }else if(row.is_buyer==1){ //停购商品
                   className+=' brown-text';
                }else if(row.is_sale==1){ //停售商品
                   className+=' violet-text';
                }else if(row.isvalid!=1){ //已过期
                   className+=' italic-style';
                }else{ //正常商品
                   className+=' green-text';
                }
                /* 有药检报告 */
                if(row.file_a!=null && row.file_a.length>0){
                    className+=' light-bg';
                }
                return className;
            },
            selectRowIndex:function(row,index){
                _this.selectListIndex=index;
            },
            DHeight:function(e){
                _this.height=e;
            },
            initDate:function(){
               var date = new Date();
               var nowDate=date .getFullYear()+"-"+(date .getMonth()+1)+"-"+date .getDate();
               _this.search.startDate=nowDate;
               date.setDate(date.getDate()+5);
               var endDate=date .getFullYear()+"-"+(date .getMonth()+1)+"-"+date .getDate();
               _this.search.endDate=endDate;
            },
            /*************Tbs选项卡************/
            changeTabs:function(name){
                if(name!=_this.selectTabs){
                    _this.selectTabs=name.trim();
                    _this.changeTabsData();
                }
            },
            /**
             * 改变Tbs选项卡列表数据
             */
            changeTabsData:function(){
                _this.page=1;
                _this.selectListIndex=0;
                _this.initQty();
            },
            /***************加载明细*************/
            initQty:function(){
               var urls={
                  'inqty':'w/getInQtyList',
                  'outqty':'w/getOutQtyList',
                  'deqty':'w/getQtyDetailList',
                  'batchqty':'w/getBatchPartQtyList',
                  'qty':'w/getTotalQtyList',
               };
               var resUrl=urls[_this.selectTabs];
               var data={search:_this.search,page:_this.page,pageSize:_this.pageSize};
               _this.loadding=true;
               _this.common.http({url:resUrl,data:data}).then(function(res){
                   _this.loadding=false;
                   if(res.status==1){
                      var obj_list=_this.selectTabs+"_list";
                      _this[obj_list]=res.list.data;
                      _this.total=res.list.total;
                   }
               }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
               });
            },
            changePage:function(page){
               _this.page=page;
               _this.initQty();
            },
            searchData:function(){
               _this.page=1;
               _this.initQty();
            },
            /**
             * 查看药检报告
             */
            lookDrugReport:function(){
               var obj_list=_this.selectTabs+"_list";
               if(_this[obj_list].length==0) return false;
               var data = _this[obj_list][_this.selectListIndex];
               _this.$refs.viewDrugRef.open(data.goods_code,data.batch_no,data.sup_code);
            }
        }
    }
</script>
<style lang="less">
.GoodsInOutForm{
    width:1200px;padding:10px;
    .dateSel{width:176px;display:inline-block;}
    .dateSpan{width:30px;text-align:center;display:inline-block;}
    .leftCol{padding-left:15px;}
    .formItem{
      display:block;
      .w{width:50%;display:inline-block;float:left;}
      .selSup_l{width:40%;display:inline-block;cursor:pointer;float:left;}
      .selSup_r{width:58%;display:inline-block;float:right;}
    }
    .qtyNum{width:87px;display:inline-block !important;}
    .qtyNum input{text-align:center;}
}
.GoodsQtyTabs{
   .ivu-tabs-bar{margin-bottom:0;}
   .qtytools{height:50px;padding:10px;box-sizing:border-box;}
}
.goodsInOut_Tool{
   height:40px;line-height:40px;padding:0 10px;
   .dot{width:24px;height:16px;vertical-align:middle;display:inline-block;margin-right:5px;}
}
</style>
