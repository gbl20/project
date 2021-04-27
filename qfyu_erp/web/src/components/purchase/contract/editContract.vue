<template>
<div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
                <Button @click="saveEdit" :loading="save_loading" :disabled="!isedit && formdata.orderid.length>0">
                    <span class="icon iconfont">&#xe792;</span>保存
                </Button>
                <Button :disabled="isedit" @click="clickEdit" v-if="formdata.orderid.length>0">
                    <span class="icon iconfont">&#xe791;</span>修改
                </Button>
                <Divider type="vertical"/>
                <Button @click="delView()"><span class="icon iconfont">&#xe68f;</span>退出</Button>
            </div>
            <div class="ser-form">
                <Form :label-width="70" label-position="left" class="contractform">
                    <Row>
                      <Col span="5">
                          <FormItem label="合同编号">
                               <Input placeholder="合同号(系统生成)" v-model="formdata.orderid" disabled readonly></Input>
                          </FormItem>
                      </Col>
                      <Col span="5" class="cleft">
                          <FormItem label="生效日期">
                               <DatePicker type="date" :editable="false" placeholder="生效日期" v-model="formdata.start_date" :disabled="!isedit && formdata.orderid.length>0"></DatePicker>
                          </FormItem>
                      </Col>
                      <Col span="9" class="cleft">
                          <FormItem label="供应商" class="sup_sel">
                               <Input readonly disabled class="left" v-model="formdata.sup_code"></Input>
                               <Input icon="ios-more" @on-click="clickSelProvider" readonly class="right" v-model="formdata.sup_name" :disabled="!isedit && formdata.orderid.length>0"></Input>
                          </FormItem>
                      </Col>
                      <Col span="5">
                          <FormItem label="结算方式">
                              <Select v-model="formdata.settlement" :disabled="!isedit && formdata.orderid.length>0">
                                  <Option :value="0">请选择</Option>
                                  <Option :value="p.id" :key="k" v-for="(p,k) in settlement">{{p.name}} ( {{p.code}} )</Option>
                              </Select>
                          </FormItem>
                      </Col>
                    </Row>
                    <Row>
                      <Col span="5">
                          <FormItem label="签约日期">
                              <DatePicker type="date" :editable="false" placeholder="签约日期" v-model="formdata.sign_date" :disabled="!isedit && formdata.orderid.length>0"></DatePicker>
                          </FormItem>
                      </Col>
                      <Col span="5" class="cleft">
                          <FormItem label="失效日期">
                              <DatePicker type="date" :editable="false" placeholder="失效日期" v-model="formdata.validity_date" :disabled="!isedit && formdata.orderid.length>0"></DatePicker>
                          </FormItem>
                      </Col>
                      <Col span="9" class="cleft">
                          <FormItem label="签约人" class="sup_sel">
                               <Input readonly disabled class="left" v-model="formdata.sign_code"></Input>
                               <Input icon="ios-more" @on-click="clickSelEmployee" readonly class="right" v-model="formdata.sign_name" :disabled="!isedit && formdata.orderid.length>0"></Input>
                          </FormItem>
                      </Col>
                      <Col span="5">
                          <FormItem label="付款日期">
                              <DatePicker type="date" :editable="false" placeholder="失效日期" v-model="formdata.pay_date" :disabled="!isedit && formdata.orderid.length>0"></DatePicker>
                          </FormItem>
                      </Col>
                    </Row>
                    <Row>
                      <Col span="10">
                          <FormItem label="合同标题">
                              <Input placeholder="合同标题" v-model="formdata.title" maxlength="200" :disabled="!isedit && formdata.orderid.length>0"></Input>
                          </FormItem>
                      </Col>
                      <Col span="14" class="cleft">
                          <FormItem label="交货地点">
                              <Input placeholder="交货地点" maxlength="100" v-model="formdata.delivery" :disabled="!isedit && formdata.orderid.length>0"></Input>
                          </FormItem>
                      </Col>
                    </Row>
                </Form>
            </div>
        </div>
        <div slot="table-list">
           <div :style="{height:(height-85)+'px','padding':'12px'}">
               <div class="contract_title title-color">相关合同信息文件</div>
               <div class="contractbox contractform border-class" :style="{height:(height-135)+'px'}">
                   <div class="item blue-bg-text">
                      <div class="icon iconfont">&#xe858;</div>
                      <div class="title title-color">
                          <div class="left">商品购销合同模板.doc</div>
                          <div class="right">
                             <Button type="primary" class="btn" v-if="isedit || formdata.orderid.length==0">
                                <span class="icon iconfont">&#xe7d9;</span>上传
                             </Button>
                             <Button type="warning" class="btn">下载</Button>
                             <Button type="success" class="btn">打印</Button>
                          </div>
                      </div>
                   </div>
               </div>
           </div>
           <div class="ser-form">
             <Form :label-width="70" label-position="left" class="contractform">
                 <Row>
                   <Col span="19">
                       <FormItem label="签约地点">
                           <Input placeholder="签约地点" maxlength="200" v-model="formdata.sign_area" :disabled="!isedit && formdata.orderid.length>0"></Input>
                       </FormItem>
                   </Col>
                   <Col span="5" class="cleft">
                       <FormItem label="创建人">
                           <Input maxlength="100" readonly disabled :value="formdata.creator"></Input>
                       </FormItem>
                   </Col>
                 </Row>
                 <Row>
                   <Col span="19">
                       <FormItem label="备注说明">
                           <Input placeholder="备注说明" maxlength="200" v-model="formdata.explain" :disabled="!isedit && formdata.orderid.length>0"></Input>
                       </FormItem>
                   </Col>
                   <Col span="5" class="cleft">
                       <FormItem label="创建日期">
                           <Input maxlength="100" readonly disabled :value="formdata.create_date"></Input>
                       </FormItem>
                   </Col>
                 </Row>
             </Form>
          </div>
        </div>
    </split-none>
    <!-- 选择供应商 -->
    <choose-providers ref="chooseProviderRef" @confirm="confirmProviders"></choose-providers>
    <!-- 选择签约人 -->
    <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
</div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import chooseProviders from '@/components/common/ChooseProviders'
  import selectEmployee from '@/components/common/SelectEmployee'
  var _this=this;
  var form={orderid:'',title:'',settlement:0,sup_code:'',sup_name:'',start_date:'',sign_date:'',validity_date:'',sign_code:'',sign_name:'',explain:'',pay_date:'',delivery:'',sign_area:'',creator:'',create_date:'',filepath:''};
  export default {
    components:{splitNone,chooseProviders,selectEmployee},
    data(){
      return {
        isedit:false,
        save_loading:false,
        height:0,
        Breadcrumb:[{title:'采购管理'},{title:'采购合同',url:'contractList'},{title:'新建合同'}],
        formdata:JSON.parse(JSON.stringify(form)),
        settlement:[] //结算方式
      }
    },
    beforeCreate:function(){
       _this=this;
    },
    activated:function(){
        _this=this;
        var orderid=_this.$route.query.orderid;
        if(typeof(orderid)!=="undefined"){
            _this.formdata.orderid=(orderid!=null && orderid.length>0)?orderid:'';
        }else{
            _this.$router.push({query:{orderid:_this.formdata.orderid}});
        }
        if(_this.formdata.orderid.length==0) _this.init();
        if(_this.formdata.orderid.length>0) _this.Breadcrumb=[{title:'采购管理'},{title:'采购合同',url:'contractList'},{title:'修改合同'}];
    },
    computed:{
        formdataOrderid(){
          return this.formdata.orderid;
        }
    },
    watch:{
        formdataOrderid(e){
          if(!e){
            this.formdata = JSON.parse(JSON.stringify(form));
          }else this.init();
        }
    },
    methods:{
      DHeight(e){
         _this.height = e;
      },
      init:function(){
         _this.common.http({url:'initContract',data:{orderid:_this.formdata.orderid}}).then(function(res){
             if(res.status==1){
                 _this.settlement=res.settlement;
                 if(res.order==null){
                    _this.formdata=JSON.parse(JSON.stringify(form));
                 }else{
                    _this.formdata=res.order;
                 }
             }
         }).catch(function(err){
              _this.common.httpErr(err.data,_this);
         });
      },
      /************选择供应商***********/
      /**
       * 点击选择
       */
      clickSelProvider:function(){
          _this.$refs.chooseProviderRef.open();
      },
      /**
       * 确认选定
       * @param data 选择数据
       */
      confirmProviders:function(data){
          _this.formdata.sup_code=data.supplier_code;
          _this.formdata.sup_name=data.full_name;
      },
      /************选择签约人************/
      /**
       * 点击选择
       */
      clickSelEmployee:function(){
          _this.$refs.chooseEmployeeRef.init({show_self:1});
      },
      /**
       * 确认选定
       * @param data 选择数据
       */
      confirmEmployee:function(data){
          _this.formdata.sign_code=data.code;
          _this.formdata.sign_name=data.name;
      },
      /*************按钮操作*************/
      /**
       * 修改
       */
      clickEdit:function(){
         if(_this.isedit) return false;
         _this.isedit=true;
      },
      /**
       * 保存
       */
      saveEdit:function(){
         if((!_this.isedit && _this.formdata.orderid.length>0) || _this.save_loading) return false;
         _this.save_loading=true;
         _this.common.http({url:'saveContract',data:_this.formdata}).then(function(res){
             _this.save_loading=false;
             if(res.status==1){
                _this.formdata.orderid=res.orderid;
                _this.isedit=false;
                _this.alertMsg(res.msg);
             }else{
                return _this.alertMsg(res.msg,'error');
             }
         }).catch(function(err){
              _this.common.httpErr(err.data,_this);
         });
      }
    }
  }
</script>
<style lang="less">
  .contractform{
    width:1200px;
    .cleft{padding-left:30px;}
    .sup_sel{
       .left{width:70px;display:inline-block;float:left;}
       .right{width:240px;display:inline-block;cursor:pointer;float:left;margin-left:5px;}
    }
  }
  .contract_title{height:30px;}
  .contractbox{
     overflow:hidden;overflow-y:auto;
     .item{
        margin:15px;border-radius:3px;overflow:hidden;height:80px;
        .icon{
           margin:10px;font-size:40px;color:#1D65FF;float:left;
        }
        .title{
           padding-left:20px;line-height:80px;font-size:16px;overflow:hidden;
           .left{width:70%;float:left;}
           .right{
             width:30%;float:left;text-align:right;padding-right:20px;
             .icon{margin:0;font-size:16px;color:#FFFFFF;}
           }
           .btn{margin-right:15px;}
        }
     }
  }

</style>
