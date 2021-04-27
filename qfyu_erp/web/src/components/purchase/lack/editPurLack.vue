<template>
<div>
    <split-none @DHeight="DHeight" :editTypeTitle="title" :Breadcrumb="Breadcrumb">
         <div slot="form-ser">
             <div class="nav-menu">
                 <Button :disabled="formdata.ischeck==1 || isedit" @click="editHandleFun" v-if="formdata.orderid">
                    <span class="icon iconfont">&#xe791;</span>修改
                 </Button>
                 <Button :disabled="formdata.ischeck==1 || !isedit" @click="cancelHandleFun" v-if="formdata.orderid">
                    <span class="icon iconfont">&#xe792;</span>取消
                 </Button>
                <Button @click="saveLackOrder" :disabled="formdata.ischeck==1 || (formdata.orderid.length>0 && !isedit)">
                    <span class="icon iconfont">&#xe792;</span>保存
                </Button>
                <Divider type="vertical"/>
                <Button @click="checkLackOrder" :disabled="formdata.ischeck==1 || formdata.orderid.length==0 || isedit">
                    <span class="icon iconfont">&#xe692;</span>审核
                </Button>
                <Button @click="backLackOrder" :disabled="formdata.ischeck!=1 || formdata.istrans==1 || formdata.orderid.length==0 || isedit">
                    <span class="icon iconfont">&#xe693;</span>还原
                </Button>
                <Button @click="transPlanOrder" :disabled="formdata.ischeck!=1 || formdata.orderid.length==0 || isedit">
                    <span class="icon iconfont">&#xe6a3;</span>转单
                </Button>
                <Divider type="vertical"/>
                <Button @click="Refresh"><span class="icon iconfont">&#xe788;</span>刷新</Button>
                <Button @click="printLackOrder"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
             </div>
             <div class="ser-form">
                <Form :label-width="85" label-position="left" :disabled="formdata.ischeck==1 || !isedit">
                    <Row>
                      <Col span="6" class="lackColWidth">
                           <FormItem label="单据编号">
                                <Input v-model="formdata.orderid" placeholder="单据编号(系统生成)" disabled></Input>
                           </FormItem>
                           <FormItem label="业 务 员">
                                <Input icon="ios-more" v-model="formdata.emp_code" readonly  @on-click="selectEmployee" style="cursor:pointer;"></Input>
                           </FormItem>
                           <FormItem label="业务员姓名">
                                <Input v-model="formdata.emp_name" readonly></Input>
                           </FormItem>
                      </Col>
                      <Col span="6" class="lackColWidth">
                           <FormItem label="登记日期" class="lackItemLeft">
                                <DatePicker type="date" :value="formdata.register_date" placeholder="登记日期" disabled></DatePicker>
                           </FormItem>
                           <FormItem label="有效期至" class="lackItemLeft">
                                <DatePicker type="date" v-model="formdata.validity_date" :editable="false" placeholder="有效期至"></DatePicker>
                           </FormItem>
                           <FormItem label="创建者" class="lackItemLeft">
                                <Input v-model="formdata.creator" readonly></Input>
                           </FormItem>
                      </Col>
                      <Col span="6" class="lackColWidth">
                           <FormItem label="品种数" class="lackItemLeft">
                                <Input v-model="formdata.nums" placeholder="货品品种数" readonly></Input>
                           </FormItem>
                           <FormItem label="货品总数量" class="lackItemLeft">
                                <Input placeholder="货品总数量" v-model="formdata.total" readonly></Input>
                           </FormItem>
                           <FormItem label="复核员" class="lackItemLeft">
                                <Input v-model="formdata.check_code" readonly></Input>
                           </FormItem>
                      </Col>
                      <Col span="6">
                            <div class="lackOrderSta lacksize">
                                <div class="title title-color">状态：</div>
                                <div class="ckstatus">
                                    <div :class="formdata.ischeck==1?'planSta success-bg-text':'planSta warning-bg-text'">{{formdata.ischeck==1?'已审核':'未审核'}}</div>
                                    <div :class="formdata.istrans==1?'planSta success-bg-text':'planSta warning-bg-text'">{{formdata.istrans==1?'已转单':'未转单'}}</div>
                                </div>
                            </div>
                      </Col>
                    </Row>
                    <Row>
                        <Col span="18" class="lackRemarkWidth">
                            <FormItem label="备注说明">
                                 <Input maxlength="300" v-model="formdata.remark" placeholder="请输入备注说明"></Input>
                            </FormItem>
                        </Col>
                        <Col span="6">
                            <div class="lacksize" v-if="formdata.ischeck!=1 && isedit">
                                <Button @click="addGoodsRow">增加行</Button>
                                <Button @click="removeGoodsRow">删除行</Button>
                            </div>
                        </Col>
                    </Row>
                </Form>
             </div>
         </div>
         <div slot="table-list">
              <Table size="small" stripe :columns="columns" :data="goodslist" border class="table-m"
                     :height="goodslist.length>0?(height-32):height"
                     :show-summary="true"
                     :summary-method="calcSum"
                     @on-row-dblclick="(row,index)=>{selectGoodsIndex(index,true)}">
              </Table>
         </div>
    </split-none>
    <!-- 选择业务员 -->
    <select-employee ref="selectEmpRef" @selemp="confirmEmployee" @clear_sel="clearEmployee"></select-employee>
    <!-- 选择商品，增加行 -->
    <choose-goods ref="chooseGoodsRef" :isSignle="true" @selectRow="chooseGoodsRow"></choose-goods>
    <!-- 编辑缺货资料 -->
    <edit-lack ref="editLackGoodsRef" @confirm="confirmEditGoods"></edit-lack>
    <!-- 弹出操作提示 -->
    <window-tip ref="windowTipRef"></window-tip>
</div>
</template>
<script>
  var form={orderid:"",emp_code:'',emp_name:'',register_date:'',validity_date:'',nums:'',total:'',ischeck:0,istrans:0,check_code:'',creator:'',remark:''};
  import splitNone from '@/components/public/splitNone'
  import selectEmployee from '@/components/common/SelectEmployee'
  import chooseGoods from '@/components/common/ChooseGoods'
  import editLack from '@/components/purchase/lack/editLackGoods'
  import windowTip from '@/components/common/WindowTip'
  var _this;
  export default {
     components:{splitNone,selectEmployee,chooseGoods,editLack,windowTip},
     data(){
        return {
           height:0,
           title:'新增登记',
           Breadcrumb:[{title:'采购管理'},{title:'缺货登记',url:'lackList'},{title:'提交缺货登记'}],
           formdata:JSON.parse(JSON.stringify(form)),
           columns:[
              {title:'序号',type:'index',key:'index',width:70,fixed:'left',align:'center'},
              {title:'商品编码',key:'goods_code',minWidth:100,fixed:'left',align:'center'},
              {title:'通用名称',key:'name',minWidth:200},
              {title:'商品名称',key:'goods_name',minWidth:200},
              {title:'规格',key:'specs',minWidth:100},
              {title:'缺货数量',key:'nums',minWidth:110,align:'center'},
              {title:'已订购数量',key:'already_nums',width:100,align:'center'},
              {title:'单位',key:'unit',width:70,align:'center'},
              {title:'剂型',key:'dosage',minWidth:90},
              {title:'产地',key:'origin',minWidth:120},
              {title:'生产企业',key:'production',minWidth:220},
              {title:'备注说明',key:'explain',minWidth:160},
              {title:'包装规格',key:'packspecs',minWidth:120},
              {title:'批准文号/注册证号',key:'approval_code',minWidth:200},
           ],
           goodslist:[],
           params:{},
           selectIndex:-1,
           save_lock:false,
           isedit:false
        }
     },
     created:function(){
        _this=this;
        var orderid=localStorage.getItem('lack_orderid');
        if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
        _this.formdata.orderid = orderid;
        _this.title=_this.formdata.orderid.length>0?'修改登记':'新增登记';
        if(_this.formdata.orderid.length==0){
            _this.init();
            _this.initDate();
        }
     },
     beforeRouteEnter(to, from, next) {
       next(vm => {
         if(from.name == 'lackList'){
           var orderid=localStorage.getItem('lack_orderid');
           if(typeof(orderid)=="undefined" || orderid==null || orderid.length==0) orderid="";
           vm.formdata.orderid = orderid;
         }
       });
     },
     computed:{
        getOrderId:function(){
           return this.formdata.orderid;
        }
     },
     watch:{
       getOrderId:function(e){
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
       }
     },
     methods:{
        DHeight:function(e){
           _this.height=e;
        },
        initDate:function(){
            var now=new Date();
            _this.formdata.register_date=now.getFullYear()+"-"+(now.getMonth()+1)+'-'+now.getDate();
        },
        init:function(){
            var data={orderid:_this.formdata.orderid};
            _this.common.http({url:'initLack',data:data}).then(function(res){
                if(res.status==1){
                   if(res.data.order==null){
                      _this.formdata=JSON.parse(JSON.stringify(form));
                      _this.initDate();
                      _this.goodslist=[];
                   }else{
                      _this.formdata=res.data.order;
                      _this.goodslist=res.data.glist;
                   }
                }
            }).catch(function(err){
                _this.common.httpErr(err.data,_this);
            });
        },
        /**
         * 选择员工
         */
        selectEmployee:function(){
           if(_this.formdata.ischeck==1 || !_this.isedit) return false;
           _this.$refs.selectEmpRef.init({show_self:1});
        },
        confirmEmployee:function(data){
            if(_this.formdata.ischeck==1 || !_this.isedit) return false;
            _this.formdata.emp_code=data.code;
            _this.formdata.emp_name=data.name;
        },
        clearEmployee:function(){
            _this.formdata.emp_code="";
            _this.formdata.emp_name="";
        },
        /********商品操作********/
        /**
         * 点击、双击商品选择
         * @param index 索引
         * @param type true:双击
         */
        selectGoodsIndex:function(index,type){
            if(_this.formdata.ischeck==1 || !_this.isedit) return false;
            _this.selectIndex=index;
            if(type) _this.editGoodsRow();
        },
        /**
         * 增加行
         */
        addGoodsRow:function(){
           if(_this.formdata.ischeck==1 || !_this.isedit) return false;
           _this.$refs.chooseGoodsRef.open();
        },
        /**
         * 删行
         */
        removeGoodsRow:function(){
            if(_this.formdata.ischeck==1 || !_this.isedit) return false;
            if(_this.selectIndex<0) return _this.alertMsg("请至少选择一行数据后删除",'error');
            _this.$Modal.confirm({
                title:'操作提示',
                content:'确定要移除该商品信息吗？',
                onOk:function(){
                    _this.goodslist.splice(_this.selectIndex,1);
                }
            });
        },
        /**
         * 编辑行
         * @param type true:点击编辑
         */
        editGoodsRow:function(){
            if(_this.formdata.ischeck==1 || !_this.isedit) return false;
            if(_this.selectIndex<0) return _this.alertMsg("请至少选择一行数据后编辑",'error');
            var data=_this.goodslist[_this.selectIndex];
            _this.$refs.editLackGoodsRef.open(data);
        },
        confirmEditGoods:function(data){
            if(_this.formdata.ischeck==1 || !_this.isedit) return false;
            _this.$set(_this.goodslist,_this.selectIndex,data);
        },
        /**
         * 选择商品处理
         * @param data 商品数据
         */
        chooseGoodsRow:function(data){
           if(_this.formdata.ischeck==1 || !_this.isedit) return false;
           data.nums=0; //缺货数量
           data.already_nums=0; //已订购数量
           data.explain=''; //备注
           _this.goodslist.push(data);
        },
        /**
         * 计算合计数量
         */
        calcSum:function({columns,data}){
            _this.formdata.nums=data.length;
            var sums={};
            columns.forEach(function(row,index){
                var key = row.key;
                if (index === 0) {
                    sums[key]={key,value:'合计'};return;
                }
                if(key=='nums'){
                    const values = data.map(item=>Number(item[key]));
                    if(!values.every(value => isNaN(value))) {
                        const v = values.reduce((prev,curr)=>{
                            const value = Number(curr);
                            var total=isNaN(value)?prev:_this.formatFloat(prev+curr,5);
                            _this.formdata.total=total;
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
        /***********按钮操作**********/
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
         * 保存
         */
        saveLackOrder:function(){
            if(_this.formdata.ischeck==1 || _this.save_lock) return false;
            var glist=[];
            _this.goodslist.forEach(function(v){
                var goods={goodsid:v.goods_code,unit:v.unit,nums:v.nums,already_nums:v.already_nums,explain:v.explain};
                glist.push(goods);
            });
            _this.formdata.glist=glist;
            _this.save_lock=true;
            _this.common.http({url:'saveLackOrder',data:_this.formdata}).then(function(res){
                _this.save_lock=false;
                if(res.status==1){
                   _this.formdata.orderid=res.orderid;
                   localStorage.setItem("lack_orderid",res.orderid);
                   _this.isedit=false;
                   _this.alertMsg("保存已成功");
                }else{
                   _this.alertMsg(res.msg,'error');
                }
            }).catch(function(err) {
                _this.common.httpErr(err.data,_this);
            });
        },
        /**
         * 审核
         */
        checkLackOrder:function(){
            if(_this.formdata.ischeck==1) return false;
            var orderid=_this.formdata.orderid;
            _this.$Modal.confirm({
                title:'审核提示',
                content:'确定要审核订单【'+orderid+'】吗？',
                onOk:function(){
                    _this.common.http({url:'checkLackOrder',data:{orderid:orderid}}).then(function(res){
                        if(res.status==1){
                           _this.formdata.ischeck=1;
                           _this.alertMsg("审核处理已成功");
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
         * 还原
         */
        backLackOrder:function(){
            if(_this.formdata.ischeck!=1 || _this.formdata.istrans==1) return false;
            var orderid=_this.formdata.orderid;
            _this.$Modal.confirm({
                title:'还原提示',
                content:'确定要还原订单【'+orderid+'】吗？',
                onOk:function(){
                    _this.common.http({url:'resetLackOrder',data:{orderid:orderid}}).then(function(res){
                        if(res.status==1){
                           _this.formdata.ischeck=0;
                           _this.alertMsg("还原处理已成功");
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
         * 转单（转采购计划单）
         */
        transPlanOrder:function(){
            if(_this.isedit) return false;
            if(_this.formdata.ischeck!=1){
              _this.alertMsg("未审核订单，不能转单操作",'error')
              return false;
            }
            var orderid=_this.formdata.orderid;
            _this.$Modal.confirm({
                title:'转单提示',
                content:'确定要将订单【'+orderid+'】转为采购计划单吗？',
                onOk:function(){
                    _this.common.http({url:'transPlanOrder',data:{orderid:orderid}}).then(function(res){
                        if(res.status==1){
                           _this.formdata.istrans=1;
                           var content="<p>采购订单【"+orderid+"】已成功转出到【"+res.orderid+"】采购计划单!</p>";
                           content+='<br/><p>确定要查看该单据吗？</p>';
                           _this.$refs.windowTipRef.open({
                                  title:"转单提示",
                                  content:content,
                                  issucess:true,
                                  isconfirm:true
                           },"/editPurPlan",function(){
                              localStorage.setItem("plan_orderid",res.orderid);
                           });
                        }else{
                           _this.$refs.windowTipRef.open({title:"操作提示",content:res.msg,issucess:false,isconfirm:false});
                        }
                    }).catch(function(err) {
                        _this.common.httpErr(err.data,_this);
                    });
                }
            });
        },
        /**
         * 打印
         */
        printLackOrder:function(){

        }
     }
  }
</script>
<style lang="less">
  .lackItemLeft{
      margin-left:40px;
  }
  .lackColWidth{
      width:260px;
  }
  .lackRemarkWidth{
      width:780px;
  }
  .lacksize{
      margin-left:50px;
  }
  .lackOrderSta{
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
