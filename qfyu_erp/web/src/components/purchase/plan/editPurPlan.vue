<template>
  <div>
      <split-none @DHeight="DHeight" :editTypeTitle="editTypeTitle" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                  <Button :disabled="formdata.ischeck==1 || isedit" @click="editHandleFun" v-if="formdata.orderid">
                     <span class="icon iconfont">&#xe791;</span>修改
                  </Button>
                  <Button :disabled="formdata.ischeck==1 || !isedit" @click="cancelHandleFun" v-if="formdata.orderid">
                     <span class="icon iconfont">&#xe792;</span>取消
                  </Button>
                  <Button @click="savePlanOrder" :disabled="formdata.ischeck==1 || (formdata.orderid.length>0 && !isedit)">
                      <span class="icon iconfont">&#xe792;</span>保存
                  </Button>
                  <Divider type="vertical"/>
                  <Button @click="checkPlanOrder" :disabled="formdata.orderid.length==0 || formdata.ischeck==1 || isedit">
                      <span class="icon iconfont">&#xe692;</span>审核
                  </Button>
                  <Button @click="closePlanOrder" :disabled="isedit">
                      <span class="icon iconfont">&#xe69e;</span>结案
                  </Button>
                  <Button @click="backPlanOrder" :disabled="formdata.orderid.length==0 || formdata.ischeck!=1 || isedit">
                      <span class="icon iconfont">&#xe693;</span>还原
                  </Button>
                  <Button @click="generateOrder" :disabled="formdata.orderid.length==0 || formdata.ischeck!=1 || formdata.isclose==1 || isedit">
                      <span class="icon iconfont">&#xe6a3;</span>生成订单
                  </Button>
                  <Divider type="vertical"/>
                  <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                  <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                  <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
              </div>
              <div class="ser-form">
                  <Form :label-width="85" label-position="left" :disabled="formdata.ischeck==1 || (formdata.orderid.length>0 && !isedit)">
                      <Row>
                        <Col span="6" class="planColWidth">
                             <FormItem label="单据编号">
                                  <Input v-model="formdata.orderid" placeholder="单据编号(系统生成)" disabled></Input>
                             </FormItem>
                             <FormItem label="编制人员">
                                  <Input icon="ios-more" v-model="formdata.prepared_code" readonly @on-click="selectUser" style="cursor:pointer;"></Input>
                             </FormItem>
                             <FormItem label="编制人姓名">
                                  <Input v-model="formdata.prepared_name" disabled></Input>
                             </FormItem>
                        </Col>
                        <Col span="6" class="planColWidth">
                             <FormItem label="编制日期" class="planItemLeft">
                                  <DatePicker type="date" :value="formdata.prepared_date" placeholder="编制日期" disabled></DatePicker>
                             </FormItem>
                             <FormItem label="失效日期" class="planItemLeft">
                                  <DatePicker type="date" v-model="formdata.invalid_date" :editable="false" placeholder="失效日期" :disabled="formdata.ischeck==1"></DatePicker>
                             </FormItem>
                             <FormItem label="计划类型" class="planItemLeft">
                                   <Select v-model="formdata.typeid">
                                       <Option value="">请选择</Option>
                                       <Option :value="p" v-for="(p,k) in $store.state.sysParam['plan_type']" :key="k">{{p}}</Option>
                                   </Select>
                             </FormItem>
                        </Col>
                        <Col span="6" class="planColWidth">
                             <FormItem label="货品总数" class="planItemLeft">
                               <Input v-model="formdata.nums" disabled></Input>
                             </FormItem>
                             <FormItem label="货品总金额" class="planItemLeft">
                               <Input v-model="formdata.account" disabled></Input>
                             </FormItem>
                             <FormItem label="复核人" class="planItemLeft">
                               <Input v-model="formdata.check_code" disabled></Input>
                             </FormItem>
                        </Col>
                        <Col span="6">
                          <div class="planOrderSta mlsize">
                              <div class="title title-color">状态：</div>
                              <div class="ckstatus">
                                  <div :class="formdata.ischeck==1?'planSta success-bg-text':'planSta warning-bg-text'">{{formdata.ischeck==1?'已审核':'未审核'}}</div>
                                  <div :class="formdata.istrans==1?'planSta success-bg-text':'planSta warning-bg-text'">{{formdata.istrans==1?'已转单':'未转单'}}</div>
                              </div>
                          </div>
                        </Col>
                      </Row>
                      <Row v-if="formdata.orderid.length>0">
                          <Col span="6" class="planColWidth">
                              <FormItem label="创建者">
                                 <Input v-model="formdata.create_name" disabled></Input>
                              </FormItem>
                          </Col>
                          <Col span="6" class="planColWidth">
                              <FormItem label="创建时间" class="planItemLeft">
                                 <Input v-model="formdata.creator_date" disabled></Input>
                              </FormItem>
                          </Col>
                          <Col span="6" class="planColWidth">
                              <FormItem label="最后更新人" class="planItemLeft">
                                 <Input v-model="formdata.update_name" disabled></Input>
                              </FormItem>
                          </Col>
                          <Col span="6"></Col>
                      </Row>
                      <Row v-if="formdata.orderid.length>0">
                          <Col span="12" class="planRemarkWidth">
                              <FormItem label="资源所属">
                                  <Input :value="formdata.dept_name" disabled></Input>
                              </FormItem>
                          </Col>
                          <Col span="6" class="planColWidth">
                              <FormItem label="更新时间" class="planItemLeft">
                                <Input v-model="formdata.updater_date" disabled></Input>
                              </FormItem>
                          </Col>
                          <Col span="6"></Col>
                      </Row>
                      <Row>
                          <Col span="12" class="planRemarkWidth">
                              <FormItem label="备注说明">
                                  <Input maxlength="300" v-model="formdata.remark" placeholder="请输入备注说明" :disabled="formdata.ischeck==1"></Input>
                              </FormItem>
                          </Col>
                          <Col span="6" class="planColWidth">
                              <div style="width:260px;float:left;padding-left:125px;padding-top:5px;">
                                  <Checkbox v-model="formdata.isclose" :true-value="1" :false-value="0" disabled>
                                    <span>已结案</span>
                                  </Checkbox>
                              </div>
                          </Col>
                          <Col span="6">
                              <div class="mlsize" v-if="formdata.orderid.length==0 || (formdata.ischeck!=1 && formdata.orderid.length>0 && isedit)">
                                  <Button @click="addGoodsRow">新增行</Button>
                                  <Button @click="removeGoodsRow">删除行</Button>
                              </div>
                          </Col>
                      </Row>
                  </Form>
              </div>
          </div>
          <div slot="table-list">
               <Table size="small" stripe :columns="columns" :data="goodslist" border class="table-m" :height="goodslist.length>0?(height-34):height"
                      :show-summary="true" :summary-method="calcSum" :highlight-row="true"
                      @on-row-click="(row,index)=>{selectGoodsIndex(index,false)}"
                      @on-row-dblclick="(row,index)=>{selectGoodsIndex(index,true)}">
               </Table>
          </div>
      </split-none>
      <!-- 验证用户身份 -->
      <verify-user ref="verifyUserRef" @confirm="confirmEmployee"></verify-user>
      <!-- 选择商品信息 -->
      <select-goods ref="selectGoodsRef" :isSignle="false" @selectRow="selectGoodsRow"></select-goods>
      <!-- 编辑采购商品 -->
      <edit-goods ref="editGoodsRef" @confirmSave="confirmSave"></edit-goods>
      <!-- 选择供应商 -->
      <select-providers ref="selectProvsRef" @confirm="selectProvData"></select-providers>
      <!-- 消息提示 -->
      <window-tip ref="windowTipRef"></window-tip>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import selectGoods from '@/components/common/ChooseGoods'
  import editGoods from '@/components/purchase/plan/editPlanGoods'
  import selectProviders from '@/components/common/ChooseProviders'
  import verifyUser from '@/components/common/VerifyUser'
  import windowTip from '@/components/common/WindowTip'
  var _this;
  var defform={orderid:'',prepared_date:'',invalid_date:'',hascode:0,prepared_code:'',prepared_name:'',typeid:"",remark:"",nums:0,account:0.00,check_code:'',ischeck:0,isclose:0,istrans:0};
  export default {
      components:{splitNone,selectGoods,editGoods,selectProviders,verifyUser,windowTip},
      data () {
          return {
              save_lock:false,
              height:0,
              Breadcrumb:[{title:'采购管理'},{title:'采购计划',url:'purchasePlan'},{title:'创建采购计划'}],
              editTypeTitle:'新增计划',
              columns:[
                  {title:'操作',type:'index',key:'index',width:70,fixed:'left',align:'center'},
                  {title:'商品编号',key:'goods_code',fixed:'left',width:100,align:'center'},
                  {title:'通用名称',key:'name',minWidth:150},
                  {title:'商品名称',key:'goods_name',minWidth:150},
                  {title:'规格',key:'specs',minWidth:100},
                  {title:'剂型',key:'dosage',key:'dosage',minWidth:120},
                  {title:'单位',key:'unit',key:'unit',minWidth:90,align:'center'},
                  {title:'数量',key:'buynum',minWidth:100,align:'center'},
                  {title:'单价',key:'buyprice',minWidth:100,align:'center'},
                  {title:'税率%',key:'tax',minWidth:100,align:'center'},
                  {title:'无税单价',key:'notaxprice',minWidth:100,align:'center'},
                  {title:'货款',key:'goodsprice',minWidth:100,align:'center'},
                  {title:'税款',key:'taxprice',minWidth:100,align:'center'},
                  {title:'合计',key:'totalprice',minWidth:100,align:'center'},
                  {title:'供应商编号',key:'sup_code',width:100,align:'center'},
                  {title:'供应商名称',key:'sup_name',minWidth:200},
                  {title:'最近进价',key:'id',minWidth:100},
                  {title:'最初进价',key:'id',minWidth:100},
                  {title:'最高进价',key:'id',minWidth:100},
                  {title:'最低进价',key:'id',minWidth:100},
                  {title:'产地',key:'origin',minWidth:150},
                  {title:'生产企业',key:'production',minWidth:200},
                  {title:'备注',key:'remark',minWidth:120},
                  {title:'批准文号/注册证号',key:'approval_code',minWidth:150},
                  {title:'包装规格',key:'packspecs',minWidth:100},
                  {title:'供应商1价',key:'provprice1',minWidth:120,align:'center'},
                  {title:'供应商2价',key:'provprice2',minWidth:120,align:'center'},
                  {title:'供应商3价',key:'provprice3',minWidth:120,align:'center'},
                  {title:'供应商4价',key:'provprice4',minWidth:120,align:'center'},
                  {title:'供应商5价',key:'provprice5',minWidth:120,align:'center'},
                  {title:'供应商6价',key:'provprice6',minWidth:120,align:'center'},
                  {title:'供应商7价',key:'provprice7',minWidth:120,align:'center'},
                  {title:'供应商8价',key:'provprice8',minWidth:120,align:'center'},
                  {title:'标准零售价',key:'id',width:120,align:'center'},
                  {title:'大包装数量',key:'pack_specs2',minWidth:120}
              ],
              goodslist:[],
              selectIndex:-1,
              formdata:JSON.parse(JSON.stringify(defform)),
              typelist:[], //计划类型,
              provIndex:null, //选择供应商
              isedit:false
          }
      },
      beforeCreate:function(){
          _this=this;
      },
      created:function(){
          var orderid=localStorage.getItem("plan_orderid");
          if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
          _this.formdata.orderid = orderid;
          if(JSON.stringify(this.$store.state.sysConfig) != '[]') _this.initDate();
      },
      beforeRouteEnter(to, from, next) {
        next(vm => {
          if(from.name == 'purchasePlan'){
            var orderid=localStorage.getItem("plan_orderid");
            if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
            vm.formdata.orderid = orderid;
          }
        });
      },
      computed:{
        formdataOrderid(){
          return this.formdata.orderid;
        }
      },
      watch:{
        formdataOrderid(e){
          if(this.isedit){
            this.$Modal.confirm({
              title:'温馨提示',
              content:'页面正处于编辑状态，确定要放弃修改吗？',
              okText:'继续',
              onOk:()=>{
                this.init();
              }
            });
          }else this.init();
        },
        '$store.state.sysConfig'(){
          if(_this.formdata.orderid.length==0) _this.initDate();
        }
      },
      methods:{
          Refresh:function(){
             _this.init();
          },
          cancelHandleFun:function(){
             _this.init();
             _this.isedit=false;
          },
          editHandleFun:function(){
             _this.isedit=true;
          },
          /**
           * 选择供应商
           */
          selectProviders:function(provIndex){
              _this.$refs.selectProvsRef.open();
              _this.provIndex = provIndex;
          },
          selectProvData:function(e){
             _this.$refs[_this.provIndex].selectProvNotify(e);
          },
          DHeight:function(e){
              this.height=e;
          },
          initDate:function(){
              var now=new Date();
              _this.formdata.prepared_date=now.getFullYear()+"-"+(now.getMonth()+1)+'-'+now.getDate();
              let invalidDays = this.$store.state.sysConfig['pch_order_plan_invalid_days']
              now.setDate(now.getDate()+invalidDays);
              this.formdata.invalid_date=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate();
          },
          /**
           * 初始化数据
           */
          init:function(){
              var data={orderid:_this.formdata.orderid};
              _this.common.http({url:'initPlan',data:data}).then(function(res){
                  if(res.status==1){
                      _this.typelist=res.typelist;
                      _this.editTypeTitle=_this.formdata.orderid.length>0?'修改计划':'新增计划';
                      if(res.order==null){
                         _this.formdata=JSON.parse(JSON.stringify(defform));
                         _this.goodslist=[];
                         _this.initDate();
                      }else{
                         _this.formdata=res.order;
                         _this.goodslist=res.glist;
                      }
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
          },
          /****选择编制人员****/
          /**
           * 点击选择
           */
          selectUser:function(){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              _this.$refs.verifyUserRef.open();
          },
          /**
           * 确认编制人员
           */
          confirmEmployee:function(data){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              _this.formdata.hascode=1;
              _this.formdata.prepared_code=data.code;
              _this.formdata.prepared_name=data.name;
          },
          /**
           * 检测是否验证编制人员
           */
          checkEmployee:function(){
              var hascode=_this.formdata.hascode;
              var code=_this.formdata.prepared_code;
              if(code==null || code.length==0 || hascode!=1) return false;
              return true;
          },
          /************选择新增商品数量*************/
          /**
           * 添加商品信息
           */
          addGoodsRow:function(){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              if(!_this.checkEmployee()){
                 return _this.alertMsg("请填写编制人员",'error');
              }
              _this.$refs.selectGoodsRef.open();
          },
          /**
           * 删除行
           */
          removeGoodsRow:function(){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              if(!_this.checkEmployee()) return _this.alertMsg("请填写编制人员",'error');
              if(_this.selectIndex<0) return _this.alertMsg("请至少选择一行数据后删除",'error');
              this.$Modal.confirm({
                  title:'操作提示',
                  content:'确定要移除该商品信息吗？',
                  onOk:function(){
                      _this.goodslist.splice(_this.selectIndex,1);
                      _this.calcTotalPrice(); //计算订单总额
                  }
              });
          },
          /**
           * 单击或双击行数据
           * @param index 索引
           * @param type true:双击操作
           */
          selectGoodsIndex:function(index,type){
              _this.selectIndex=index;
              if(type) _this.editGoodsData(index);
          },
          /**
           * 编辑行
           */
          editGoodsData:function(index){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              if(!_this.checkEmployee()) return _this.alertMsg("请填写编制人员",'error');
              if(index<0){
                  if(_this.selectIndex<0) return _this.alertMsg("请至少选择一行数据后编辑",'error');
                  index=_this.selectIndex;
              }
              var data=_this.goodslist[index];
              _this.$refs.editGoodsRef.open(data);
          },
          /**
           *  确定编辑
           */
          confirmSave:function(data){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              _this.$set(_this.goodslist,_this.selectIndex,data);
              _this.calcTotalPrice(); //计算订单总额
              _this.$refs.editGoodsRef.close();
          },
          selectGoodsRow:function(data){
              if(_this.formdata.ischeck==1 || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              if(!_this.checkEmployee()) return _this.alertMsg("请填写编制人员",'error');
              data.buynum=0; //数量
              data.buyprice=0; //单价
              data.notaxprice=0; //无税单价
              data.goodsprice=0; //货款
              data.taxprice=0; //税款
              data.totalprice=0; //商品总合计
              data.sup_name=data.sup_name; //供应商名称
              data.sup_code=data.supplier; //供应商编号
              data.remark=""; //备注说明
              data.provprice1=0; //供应商1价
              data.provprice2=0; //供应商2价
              data.provprice3=0; //供应商3价
              data.provprice4=0; //供应商4价
              data.provprice5=0; //供应商5价
              data.provprice6=0; //供应商6价
              data.provprice7=0; //供应商7价
              data.provprice8=0; //供应商8价
              data.tax=parseFloat(data.tax);
              _this.goodslist.push(data);
              _this.calcTotalPrice(); //计算订单总额
          },
          /**
           * 计算订单总额
           */
          calcTotalPrice:function(){
              var account=0;
              _this.goodslist.forEach(function(v){account+=v.totalprice;});
              _this.formdata.nums=_this.goodslist.length;
              _this.formdata.account=_this.formatFloat(account,2);
          },
          calcSum:function({columns,data}){
              var sums={};
              columns.forEach(function(row,index){
                  var key = row.key;
                  if (index === 0) {
                      sums[key]={key,value:'合计'};return;
                  }
                  if(key=='buynum' || key=='goodsprice' || key=='taxprice' || key=='totalprice'){
                      const values = data.map(item=>Number(item[key]));
                      if(!values.every(value => isNaN(value))) {
                          const v = values.reduce((prev,curr)=>{
                              const value = Number(curr);
                              var dot=key=='buynum'?5:6;
                              var total=isNaN(value)?prev:_this.formatFloat(prev+curr,dot);
                              return total;
                          },0);
                          sums[key]={key,value:v};
                      }
                  }else if(key=='goods_code'){
                      sums[key]={key,value:_this.goodslist.length};
                  }else{
                      sums[key]={key,value:''};
                  }
              });
              return sums;
          },
          /************按钮操作***********/
          /**
           * 保存
           */
          savePlanOrder:function(){
              if(_this.formdata.ischeck==1 || _this.save_lock || (_this.formdata.orderid.length>0 && !_this.isedit)) return false;
              if(!_this.checkEmployee()) return _this.alertMsg("请填写编制人员",'error');
              if(_this.formdata.typeid<=0) return _this.alertMsg("请选择计划类型",'error');
              var glist=[];
              _this.goodslist.forEach(function(v){
                  var goods={
                    goodsid:v.goods_code,
                    unit:v.unit,
                    buynum:v.buynum,
                    buyprice:v.buyprice,
                    sup_code:v.sup_code,
                    taxrate:v.tax,
                    notaxprice:v.notaxprice,
                    goodsprice:v.goodsprice,
                    taxprice:v.taxprice,
                    totalprice:v.totalprice,
                    provprice1:v.provprice1,
                    provprice2:v.provprice2,
                    provprice3:v.provprice3,
                    provprice4:v.provprice4,
                    provprice4:v.provprice5,
                    provprice6:v.provprice6,
                    provprice7:v.provprice7,
                    provprice8:v.provprice8,
                    remark:v.remark
                  }
                  glist.push(goods);
              });
              _this.formdata.glist=glist;
              _this.save_lock=true;
              _this.common.http({url:'savePlanOrder',data:_this.formdata}).then(function(res){
                  _this.save_lock=false;
                  if(res.status==1){
                     _this.isedit=false;
                     _this.formdata.orderid=res.orderid;
                     localStorage.setItem("plan_orderid",res.orderid);
                     _this.alertMsg("保存已成功");
                  }else{
                     _this.alertMsg(res.msg,'error');
                  }
              }).catch(function(err) {
                  _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 结案
           */
          closePlanOrder:function(){
              var orderid=_this.formdata.orderid;
              if(orderid==null || orderid.length==0){
                  _this.formdata.isclose=_this.formdata.isclose==1?0:1;
              }
              //编辑修改时，直接处理结案操作
              if(_this.formdata.orderid.length>0){
                  _this.common.http({url:'closePlanOrder',data:{orderid:orderid}}).then(function(res){
                      if(res.status==1){
                          _this.formdata.isclose=res.isclose;
                      }else{
                          _this.alertMsg(res.msg,'error');
                      }
                  }).catch(function(err){
                      _this.common.httpErr(err.data,_this);
                  });
              }
          },
          /**
           *  审核
           */
          checkPlanOrder:function(){
              var orderid=_this.formdata.orderid;
              if(_this.formdata.ischeck==1 || orderid==null || orderid.length==0) return false;
              _this.$Modal.confirm({
                  title:'审核提示',
                  content:'确定要审核订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'checkPlanOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                              _this.formdata.ischeck=1;
                              _this.formdata.check_code=res.check.code;
                              _this.alertMsg("审核处理成功");
                          }else{
                              _this.$refs.windowTipRef.open({title:"审核提示",content:res.msg,issucess:false,isconfirm:false});
                          }
                      }).catch(function(err){
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 还原
           */
          backPlanOrder:function(){
              var orderid=_this.formdata.orderid;
              if(_this.formdata.ischeck!=1 || orderid==null || orderid.length==0) return false;
              _this.$Modal.confirm({
                  title:'还原提示',
                  content:'确定还原订单【'+orderid+'】吗？',
                  onOk:function(){
                      _this.common.http({url:'backPlanOrder',data:{orderid:orderid}}).then(function(res){
                          if(res.status==1){
                              _this.formdata.ischeck=0;
                              _this.formdata.istrans=0;
                              _this.alertMsg("还原处理成功");
                          }else{
                              _this.$refs.windowTipRef.open({title:"转单提示",content:res.msg,issucess:false,isconfirm:false});
                          }
                      }).catch(function(err){
                          _this.common.httpErr(err.data,_this);
                      });
                  }
              });
          },
          /**
           * 生成订单（采购订单）
           */
          generateOrder:function(){
              var orderid=_this.formdata.orderid;
              if(orderid==null || orderid.length==0 || _this.isedit) return false;
              if(_this.formdata.ischeck!=1 || _this.formdata.isclose==1){
                  return _this.alertMsg("单据未审核或已结案，不能再生成采购订单！",'error');
              }
              _this.$Modal.confirm({
                  title:'转单提示',
                  content:'确定要生成采购订单吗？',
                  onOk:function(){
                       _this.common.http({url:'generateOrder',data:{orderid:orderid}}).then(function(res){
                           if(res.status==1){
                               _this.init();
                               var content="<p>已成功生成以下采购订单：</p>";
                               res.olist.forEach(function(v){content+="<p>"+v+"</p>";});
                               content+='<br/><p>确定要查看这些单据吗？</p>';
                               _this.$refs.windowTipRef.open({
                                      title:"转单提示",
                                      content:content,
                                      issucess:true,
                                      isconfirm:true
                               },"/editPurOrder?orderid="+res.olist[0]);
                           }else{
                               _this.$refs.windowTipRef.open({title:"转单提示",content:res.msg,issucess:false,isconfirm:false});
                           }
                       }).catch(function(err){
                           _this.common.httpErr(err.data,_this);
                       });
                  }
              });
          }
      }
  }
</script>
<style lang="less">
  .planItemLeft{
      margin-left:40px;
  }
  .planColWidth{
      width:270px;
  }
  .planRemarkWidth{
      width:540px;
  }
  .mlsize{
      margin-left: 50px;
  }
  .planOrderSta{
      width:120px;
      box-sizing:border-box;
      .title{
         width:46px;float:left;line-height:32px;
      }
      .ckstatus{
         width:74px;float:left;
      }
      .planSta{
         height:32px;
         line-height:32px;
         text-align:center;
         font-size:14px;
         margin-bottom:10px;
         padding:0;
      }
  }
</style>
