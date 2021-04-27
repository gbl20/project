<template>
  <div class="main">
    <split-none :Breadcrumb="Breadcrumb" :editTypeTitle="editTypeTitle" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="add" :disabled="editType!=-1?true:false">
            <span class="icon iconfont">&#xe797;</span>新增
          </Button>
          <Button :disabled="(proData.status || editType!=-1)?true:false" @click="onEditData">
            <span class="icon iconfont">&#xe791;</span>修改
          </Button>
          <Button :disabled="(proData.status || editType==-1)?true:false" @click="editData">
            <span class="icon iconfont">&#xe792;</span>保存
          </Button>
          <Button :disabled="(proData.status || editType==-1)?true:false" @click="cancelData">
            <span class="icon iconfont">&#xe7fd;</span>取消
          </Button>
          <Divider type="vertical" />
          <Button @click="checkOrder" :disabled="(editType==-1 && !proData.status)?false:true">
            <span class="icon iconfont">&#xe692;</span>审核
          </Button>
          <Divider type="vertical" />
          <Button :disabled="editType!=-1?true:false"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button :disabled="editType!=-1?true:false"><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button :disabled="editType!=-1?true:false" @click="(e)=>{this.toUrl('/first_variety_list')}"><span class="icon iconfont">&#xe6a2;</span>返回</Button>
        </div>
      </div>
      <div slot="table-list" class="tabs-form" :style="'height:'+height+'px;overflow:hidden;'" >
        <Tabs v-model="TabsName" :animated=false>
          <TabPane label="商品信息" name="base">
            <div class="tabs-content">
              <Form ref="formProData" :model="proData" :rules="ruleValidate" :label-width="130" :disabled="(proData.status || editType==-1)?true:false">
                <Row>
                  <Col span="6">
                    <FormItem label="单据编号">
                      <Input v-model="proData.orderid" disabled></Input>
                    </FormItem>
                    <FormItem label="通用名称" prop="name">
                      <Input v-model="proData.name"></Input>
                    </FormItem>
                    <FormItem label="单位" prop="unit">
                      <Select v-model="proData.unit">
                        <Option v-for="(item,index) in unit" :value="item" :key="index">{{item}}</Option>
                      </Select>
                    </FormItem>
                    <FormItem label="英文名称">
                      <Input v-model="proData.en_name"></Input>
                    </FormItem>
                    <FormItem label="商品性能成分、质量、用途疗效、副作用描述:" prop="description">
                      <Input type="textarea" v-model="proData.description" maxlength="255" show-word-limit :autosize="{minRows:4,maxRows:4}"></Input>
                    </FormItem>
                    <FormItem label="本位码" prop="standard_code">
                      <Input v-model="proData.standard_code"></Input>
                    </FormItem>
                    <FormItem label="规格" prop="specs">
                      <Input type="text" v-model="proData.specs"></Input>
                    </FormItem>
                    <FormItem label="中包装规格">
                      <Input type="text" v-model="proData.pack_specs1"></Input>
                    </FormItem>
                    <FormItem label="大包装规格">
                      <Input v-model="proData.pack_specs2"></Input>
                    </FormItem>
                    <FormItem label="质量标准" prop="quality_standards">
                      <Input v-model="proData.quality_standards"></Input>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="申请部门" prop="depart_name">
                      <Input readonly :value="proData.depart_name" icon="ios-more" style="cursor: pointer;" @on-click="show_seldepart"></Input>
                    </FormItem>
                    <FormItem label="商品名称">
                      <Input v-model="proData.goods_name"></Input>
                    </FormItem>
                    <FormItem label="批准文号/注册证号" prop="approval_code">
                      <Input v-model="proData.approval_code"></Input>
                    </FormItem>
                    <FormItem label="批准文号/注册证号有效期" prop="approval_date">
                      <DatePicker type="date" :options="startOptions" v-model="proData.approval_date"></DatePicker>
                    </FormItem>
                    <FormItem label="有效期(月)" prop="production_mouth">
                      <InputNumber :max="999" :min="0" v-model="proData.production_mouth"></InputNumber>
                    </FormItem>
                    <FormItem label="样品批号" prop="sample_code">
                      <Input v-model="proData.sample_code"></Input>
                    </FormItem>
                    <FormItem label="样品有效期">
                      <DatePicker type="date" format="yyyy-MM-dd" v-model="proData.sample_date"></DatePicker>
                    </FormItem>
                    <FormItem label="出厂价">
                      <Input v-model="proData.factory_price"></Input>
                    </FormItem>
                    <FormItem label="采购价">
                      <Input v-model="proData.buyer_price"></Input>
                    </FormItem>
                    <FormItem label="批发价">
                      <Input v-model="proData.trade_price"></Input>
                    </FormItem>
                    <FormItem label="零售价">
                      <Input type="text" v-model="proData.retail_price"></Input>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="填报日期">
                      <DatePicker type="datetime" v-model="proData.create_date"></DatePicker>
                    </FormItem>
                    <FormItem label="剂型" prop="dosage">
                      <Select v-model="proData.dosage">
                        <Option v-for="(item,index) in dosage" :value="item" :key="index">{{item}}</Option>
                      </Select>
                    </FormItem>
                    <FormItem label="产地">
                      <Input v-model="proData.origin"></Input>
                    </FormItem>
                    <FormItem label="生产企业" prop="production">
                      <Input v-model="proData.production"></Input>
                    </FormItem>
                    <FormItem label="许可证号" prop="license_key">
                      <Input v-model="proData.license_key"></Input>
                    </FormItem>
                    <FormItem label="许可证有效期">
                      <DatePicker type="date" format="yyyy-MM-dd" :options="startOptions" v-model="proData.license_date"></DatePicker>
                    </FormItem>
                    <FormItem label="生产企业详细地址" prop="production_addr">
                      <Input type="textarea" v-model="proData.production_addr" maxlength="30" :autosize="{minRows:2,maxRows:2}"></Input>
                    </FormItem>
                    <FormItem label="营业执照号" prop="business_license_no">
                      <Input v-model="proData.business_license_no"></Input>
                    </FormItem>
                    <FormItem label="营业执照有效期">
                      <DatePicker :options="startOptions" type="date" format="yyyy-MM-dd" transfer v-model="proData.business_date"></DatePicker>
                    </FormItem>
                    <FormItem label="合同开始时间">
                      <DatePicker type="date" format="yyyy-MM-dd" transfer v-model="proData.ht_date"></DatePicker>
                    </FormItem>
                    <FormItem label="合同结束日期">
                      <DatePicker :options="startOptions" type="date" format="yyyy-MM-dd" transfer v-model="proData.ht_end_date"></DatePicker>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="许可经营大类">
                      <Select v-model="proData.kinds_id">
                        <Option v-for="(item,index) in customItem" :value="item.id" :key="index">{{item.name}}</Option>
                      </Select>
                    </FormItem>
                    <FormItem label="许可经营小类">
                      <Row>
                        <Col span="6">
                          <Input v-model="proData.kinds_kid"></Input>
                        </Col>
                        <Col span="1">&nbsp;</Col>
                        <Col span="17">
                          <Input v-model="proData.kinds_name">
                            <a href="javascript:;" @click="changeKind" slot="append" class="icon iconfont">&#xe7fc;</a>
                          </Input>
                        </Col>
                      </Row>
                    </FormItem>
                    <FormItem label="商品大类">
                      <Select v-model="proData.category_id">
                        <Option v-for="(item,index) in category" :value="item.value" :key="index">{{item.label}}</Option>
                      </Select>
                    </FormItem>
                    <FormItem label="商品功能类别" prop="function_id">
                      <Cascader change-on-select transfer :data="fun_category" v-model="proData.function_id"></Cascader>
                    </FormItem>
                    <FormItem label="GSP验收类型" prop="gsp_type">
                      <Select v-model="proData.gsp_type">
                        <Option v-for="(item,index) in gsp_type" :value="index" :key="index">{{item}}</Option>
                      </Select>
                    </FormItem>
                    <FormItem label="GMP证书号" prop="gmp_code">
                      <Input type="text" v-model="proData.gmp_code"></Input>
                    </FormItem>
                    <FormItem label="GMP认证时间" prop="gmp_date">
                      <DatePicker type="date" format="yyyy-MM-dd" v-model="proData.gmp_date"></DatePicker>
                    </FormItem>
                    <FormItem label="GMP证书有效期" prop="gmp_end_date">
                      <DatePicker type="date" :options="startOptions" format="yyyy-MM-dd" v-model="proData.gmp_end_date"></DatePicker>
                    </FormItem>
                    <FormItem label="储存条件" prop="storage_type">
                      <Select v-model="proData.storage_type">
                        <Option v-for="(item,index) in storage_type" :value="item" :key="index">{{item}}</Option>
                      </Select>
                    </FormItem>
                    <FormItem label="出厂检验报告书">
                      <Input type="text" v-model="proData.book"></Input>
                    </FormItem>
                    <FormItem label="申请原因" prop="remark">
                      <Input type="textarea" v-model="proData.remark" maxlength="100" show-word-limit :autosize="{minRows:3,maxRows:3}"></Input>
                    </FormItem>
                  </Col>
                </Row>
                <Divider />
                <Row>
                  <Col span="6">
                    <FormItem label="制单人">
                      <Input v-model="proData.creator_name" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col span="6">
                    <FormItem label="修改人">
                      <Input v-model="proData.reviser_name" disabled></Input>
                    </FormItem>
                  </Col>
                  <Col v-if="proData.order_status==0" span="6">
                    <FormItem label="已审核">
                      <Switch :true-value="1" :false-value="0" v-model="proData.status" disabled/>
                    </FormItem>
                  </Col>
                  <Col v-if="proData.order_status==1" span="6">
                    <FormItem label="已审批">
                      <Switch :true-value="1" :false-value="0" v-model="proData.order_status" disabled/>
                    </FormItem>
                  </Col>
                  <Col span="6"></Col>
                </Row>
              </Form>
            </div>
          </TabPane>
          <TabPane label="商品证照" name="pro_img">
            <photo ref="firstGoodsPhoto" :height="height" :goods_code="proData.goods_code" :isDisabled="proData.status?true:false"></photo>
          </TabPane>
          <TabPane v-if="proData.status" label="意见与结论" name="view">
            <div class="opinion-box">
              <authentication :orderid="proData.orderid" :examData="admData" :type="1" :isDisabled="proData.order_status?true:false" @adminCheckSuccess="init"></authentication>
            </div>
          </TabPane>
        </Tabs>
      </div>
    </split-none>
    <kinds-item ref="kindsItemRef" @changeKind="getKinds" @clean="cleanKinds"></kinds-item>
    <select-depart ref="seldep" @seldep="select_dep" @clear_sel="clear_sel"></select-depart>
  </div>
</template>

<script>
  import splitNone from '@/components/public/splitNone'
  import authentication from '@/components/public/authentication.vue'
  import kindsItem from "@/components/common/kindsItem"
  import SelectDepart from '@/components/common/SelectDepart'
  import photo from "@/components/gsp/first_variety/photo"
  var _this,
    formData={
    orderid:'', depart_name:'', depart_id:null,create_date:new Date(), name:'', dosage:null, unit:null, specs:'', description:'',kinds_id:null,kinds_kid:null, kinds_name:'',function_id:[], quality_standards:'', standard_code:'', approval_code:'', approval_date:'',category_id:null, gsp_type:null, remark:'', production:'', production_addr:'', production_mouth:null, gmp_code:'', gmp_date:'', gmp_end_date:'', storage_type:null, sample_code:'', sample_date:'', status:0, order_status:0, creator_name:'', reviser_name:''},
    UserData={
    buyer_code:'', buyer_date:'', buyer_reason:'', buyer_status:0, principal_code:'', principal_date:'', principal_reason:'', principal_status:0, qa_code:'', qa_date:'', qa_reason:'', qa_status: 0,};
  export default {
    components:{
      splitNone,authentication,kindsItem,SelectDepart,photo
    },
    data: function() {
      const validateDate = (rule, value, callback) => {
        if (value) {
          callback();
        } else {
          callback(new Error("不能为空"));
        }
      };
      return {
        orderid:"",
        TabsName:'base',
        height:0,
        Breadcrumb:[{title:'GSP'},{title:'首营产品管理',url:'first_variety_list'},{title:'首营产品申请'}],
        editType:-1,
        editTypeTitle:'',
        proData:JSON.parse(JSON.stringify(formData)),//商品信息
        admData:JSON.parse(JSON.stringify(UserData)),//意见与结论
        ruleValidate:{
          depart_name:[
            {type:'string',required:true,message:'请选择开单部门',trigger:'change'}
          ],
          create_date:[
            {type:'date',required:true,message:'填报日期不能为空',trigger:'change',pattern: /.+/}
          ],
          name:[
            {type:'string',required:true,message:'通用名称不能为空',trigger:'blur'}
          ],
          dosage:[
            {type:'string',required:true,message:'请选择剂型',trigger:'change'}
          ],
          unit:[
            {type:'string',required:true,message:'单位不能为空',trigger:'change'}
          ],
          approval_code:[
            {type:'string',required:true,message:'批准文号不能为空',trigger:"blur"}
          ],
          approval_date:[
            {required:true,validator:validateDate,trigger:'change'}
          ],
          function_id:[
            {type:'array',required:true,message:'请选择商品功能类别',trigger:'change'}
          ],
          production:[
            {type:'string',required:true,message:'生产企业不能为空',trigger:'blur'}
          ],
          license_key:[
            {type:'string',required:true,message:'许可证号不能为空',trigger:'blur'}
          ],
          description:[
            {type:'string',required:true,message:'商品作用描述不能为空',trigger:'blur'}
          ],
          production_addr:[
            {type:'string',required:true,message:'生产企业详细地址不能为空',trigger:'blur'}
          ],
          business_license_no:[
            {type:'string',required:true,message:'营业执照号不能为空',trigger:"blur"}
          ],
          gsp_type:[
            {type:'string',required:true,message:'GSP验收类型不能为空',trigger:'change'}
          ],
          standard_code:[
            {type:'string',required:true,message:'本位码不能为空',trigger:'blur'}
          ],
          specs:[
            {type:'string',required:true,message:'产品规格不能为空',trigger:'blur'}
          ],
          quality_standards:[
            {type:'string',required:true,message:'质量标准不能为空',trigger:'blur'}
          ],
          production_mouth:[
            {required:true,type:'number',message:'有效(使用)期不能为空',trigger:'blur'}
          ],
          sample_code:[
            {type:'string',required:true,message:'样品批号不能为空',trigger:'blur'}
          ],
          gmp_code:[
            {type:'string',required:true,message:'GMP证书号',trigger:'blur'}
          ],
          gmp_date:[
            {required:true,validator:validateDate,trigger:'change'}
          ],
          gmp_end_date:[
            {required:true,validator:validateDate,trigger:'change'}
          ],
          storage_type:[
            {type:'string',required:true,message:'储存条件不能为空',trigger:'change'}
          ],
          remark:[
            {type:'string',required:true,message:'申请原因不能为空',trigger:'blur'}
          ]
        },//商品验证规则
        customItem:[],
        category:[],
        fun_category:[],
        gsp_type:[],
        storage_type:[],
        unit:[],
        dosage:[],
        startOptions: {
          disabledDate (date) {
            return date && date.valueOf() < Date.now() - 86400000;
          }
        }
      }
    },
    mounted(){
      _this=this;
    },
    // 路由导航钩子，此时还不能获取组件实例 `this`，所以无法在data中定义变量（利用vm除外）
    beforeRouteEnter:function(to,from,next){
      //判断是从哪个路由过来的 如果是 NewVarietyGoods 过来的表示当前页面不需要刷新数据，直接使用之前缓存数据
      if(from.name == 'NewVarietyGoods') to.meta.isBack = true;
      next();
    },
    //只有第一次进入或者刷新页面后才会执行 使用keep-alive后(2+次)进入不会执行
    created(){
      this.orderid = this.$route.query.orderid;
      this.$route.meta.isBack = true;
      this.init();
    },
    //每次都会加载 但是：第一次进入或者刷新页面 先执行created()方法
    activated(){
      this.orderid = this.$route.query.orderid;
      this.$router.push({
        query:{orderid:this.orderid,is_back:this.$route.query.is_back}
      });
      //is_back 有值说明需要更新数据 为undefined表示读取缓存
      if(!this.$route.meta.isBack && typeof(this.$route.query.is_back) !=="undefined") this.init()
      this.$route.meta.isBack = false;
    },
    methods: {
      init:function(){
        var _this=this;
        this.common.http({
          url:'getGspCategory',
          data:{orderid:this.orderid}
        }).then(function (res) {
          if (res.status==1){
            _this.$refs.formProData.resetFields();
            _this.gsp_type     = res.gsp_type;
            _this.category     = res.category;
            _this.fun_category = res.function;
            _this.customItem   = res.custom;
            _this.storage_type = res.storage_type;
            _this.unit         = res.unit;
            _this.dosage       = res.dosage;
            _this.proData   = typeof(res.info)!=='undefined'?res.info:JSON.parse(JSON.stringify(formData));
            _this.admData   = typeof(res.admData)!=='undefined'?res.admData:{};
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        });
      },
      format:function(labels, selectedData){
        const index = labels.length - 1;
        const data = selectedData[index] || false;
        return labels[index];
      },
      //点击新增按钮
      add:function(){
        this.editType = 1;
        this.editTypeTitle = '新增';
        this.$refs.formProData.resetFields();
        this.proData = JSON.parse(JSON.stringify(formData));
      },
      //点击修改按钮
      onEditData:function(){
        if(!this.orderid || !this.proData.orderid){
          this.$Modal.warning({
            title:'提示',
            content:'请先新增或者选择一项首营申请单！'
          });
          return false;
        }
        this.editType = 1;
        this.editTypeTitle = '编辑';
      },
      //点击取消按钮
      cancelData:function(){
        this.$Modal.confirm({
          title:'提示',
          content:'确定要取消操作码?您的数据将不会倍保存。',
          onOk:function () {
            _this.editType = -1;
            _this.editTypeTitle = '';
            _this.init();
          }
        })
      },
      //保存首营资料
      editData:function(){
        var datas = {data:this.proData,orderid:this.orderid}
        this.$refs.formProData.validate(function(valid){
          if(valid){
            _this.common.http({
              url:'addFirstGoods',
              data:datas
            }).then(function (d) {
              if(d.status){
                _this.editType = -1;
                _this.editTypeTitle = '';
                _this.alertMsg(d.msg);
                _this.orderid = d.orderid;
                _this.init();
              }else{
                _this.alertMsg(d.msg,'error')
              }
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            })
          }else{
            _this.alertMsg('首营品种资料未完善,请完善后再次提交！','error')
          }
        })
      },
      //审核单据
      checkOrder:function(){
        this.$Modal.confirm({
          title:'提示',
          content:'即将审核首营商品资料。审核之后将不能在修改数据。确定要继续操作吗?',
          okText:'继续',
          cancelText:'取消',
          onOk:function () {
            this.common.http({
              url:'checkFirstGoods',
              data:{orderid:_this.orderid}
            }).then(function (d) {
              if (d.status==1) {
                _this.alertMsg(d.msg);
                _this.init();
              }else{
                _this.alertMsg(d.msg,'error')
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
            })
          }
        })
      },
      DHeight:function(e){
        this.height = e;
      },
      //弹出许可经营类别层
      changeKind:function () {
        this.$refs.kindsItemRef.init(this.proData.kinds_id);
      },
      //选定许可经营小类
      getKinds:function (e) {
        this.proData.kinds_kid = e.id;
        this.proData.kinds_name= e.name;
        this.proData.kinds_id  = e.parent_id;
      },
      //清除选定许可经营小类
      cleanKinds:function(){
        this.proData.kinds_kid = null;
        this.proData.kinds_name= '';
        this.proData.kinds_id  = null;
      },
      //弹出部门层
      show_seldepart:function () {
        this.$refs.seldep.init({show_self:1});
      },
      //确定选择部门
      select_dep:function (data) {
        this.proData.depart_id = data.id;
        this.proData.depart_name = data.dept_name;
      },
      //清除选择的选项
      clear_sel:function () {
        this.proData.depart_id = null;
        this.proData.depart_name = '';
      },
    }
  }
</script>

<style lang="less">
    .opinion-box{
      width: 450px;max-width: 450px;
    }
    .ivu-col-span-11{
      .ivu-dropdown{
        display: block;
        .ivu-dropdown{display: block}
      }
    }
    .checker-btn{
      display: block;background: #2d8cf0;color: #fff;text-align: center;border-radius: 4px;
      &:hover{
        text-decoration: none;
      }
    }
    .status{
      text-align: center;border-radius: 4px;
    }
    .ivu-dropdown-menu a{
      display: block;padding: 7px 16px;line-height: normal;text-align: center;white-space: nowrap;cursor: pointer;transition: background 0.2s ease-in-out;
      &:hover{
        text-decoration: none;background: #f0faff;
      }
    }
    .ivu-tabs-bar{margin-bottom: 10px;}
    .tabs-form .tabs-content {
       overflow-y: auto;padding-top:4px;max-width: 1440px;box-sizing: border-box;
       .ivu-divider-horizontal{
         margin: 15px 0;
       }
    }
    .vertical-center-modal {
       display: flex;align-items: center;justify-content: center;
       .ivu-form-item{margin-right: 0;margin-bottom: 15px!important;}
       .ivu-modal{top: 0;}
     }

</style>
