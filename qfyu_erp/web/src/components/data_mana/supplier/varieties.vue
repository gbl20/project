<template>
  <div>
      <div class="table-m-bot">
        <Table size="small" border stripe :columns="columns" :rowClassName="rowClassName" @on-row-click="rowClick" :data="data" :loading="loading" :height="height">
          <template slot-scope="{ row }" slot="is_valid">
            <span :style="'color:'+(row.is_valid?'green':'red')">{{row.is_valid?'有效':'无效'}}</span>
          </template>
        </Table>
        <div class="right-btn">
          <Button class="edit-btn" @click="addEdit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button class="edit-btn" @click="addEdit(1)" :disabled="checkIndex==-1"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button class="edit-btn"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Checkbox v-model="is_deduction" :true-value="1" :false-value="0">库存显示扣除待出库数量</Checkbox>
        </div>
      </div>
      <Modal v-model="editModal" title="供应商品种管理" width="518" :closable="false" :mask-closable="false" :loading="subLoading" @on-ok="comData">
        <Form ref="formRef" :rules="ruleVal" :model="formData" :label-width="110">
          <Row>
            <Col span="12">
              <FormItem label="商品编号：" prop="goods_code">
                <Input readonly icon="ios-more" style="cursor: pointer;" v-model="formData.goods_code" @on-click="choosePro"></Input>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="供方产品编号：">
                <Input maxlength="10" v-model="formData.prov_goods_code"></Input>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="12">
              <FormItem label="商品名称：">
                <Input v-model="formData.goods_name" disabled></Input>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="规格：">
                <Input v-model="formData.specs" disabled></Input>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="12">
              <FormItem label="主单位：">
                <Input v-model="formData.unit" disabled></Input>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="主单位协议价：">
                <InputNumber :precision="2"  :max="999999" :min="0" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="formData.price"></InputNumber>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="12">
              <FormItem label="辅单位：">
                <Input v-model="formData.unit2" disabled></Input>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="辅单位协议价：">
                <InputNumber :disabled="formData.unit2?false:true" :precision="2"  :max="999999" :min="0" :active-change="false" :formatter="value => `${value}元`" :parser="value => value.replace('元', '')" v-model="formData.price2"></InputNumber>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="12">
              <FormItem label="委托书有效期：">
                <DatePicker type="date" v-model="formData.wtsxq_date" placeholder="委托书有效期" ></DatePicker>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="最近交易日期：">
                <DatePicker type="date" v-model="formData.near_date" placeholder="最近交易日期" ></DatePicker>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="19">
              <FormItem label="备注：">
                <Input maxlength="100" v-model="formData.remark"></Input>
              </FormItem>
            </Col>
            <Col span="5">
              <FormItem :label-width="20">
                <Checkbox v-model="formData.is_valid" :true-value="1" :false-value="0">有效</Checkbox>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </Modal>
      <select-goods ref="selectGoodsRef" :isSignle="true" @selectRow="selectGoodsRow"></select-goods>
  </div>
</template>

<script>
  import selectGoods from '@/components/common/ChooseGoods'
  var fData = {id:0,goods_code:'',price:null,price2:null,prov_goods_code:'',is_valid:1,remark:'',near_date:null,wtsxq_date:null,supplier_code:'',specs:'',goods_name:'',unit:null,unit2:null};
  export default{
    name :'varieties',
    components:{selectGoods},
    props: {
      height:{
        type:Number,
        default:0
      },
      supplierCode:{
        type:String,
        default:''
      }
    },
    data:function(){
      return {
        editModal:false,
        loading:false,
         columns:[
           { title: "商品编号",key: "goods_code",width: 120,align: "center"},
           { title: "通用名称",key: "goods_name",resizable: true,width: 120,tooltip:true,align: "center"},
           { title: "规格",key: "specs",resizable: true,width: 120,align: "center"},
           { title: "主单位",key: "unit",width: 80,align: "center",resizable: true},
           { title: "主协议价格",key: "price",width: 100,align: "center",resizable: true},
           { title: "辅单位",key: "unit2",width: 80,align: "center",resizable: true},
           { title: "辅协议价格",key: "price2",resizable: true,width: 100,align: "center"},
           { title: "最近交易日期",key: "near_date",resizable: true,width: 120,tooltip:true,align: "center"},
           { title: "是否有效",slot:"is_valid",width: 90,align: "center"},
           { title: "供方产品编号",key: "prov_goods_code",resizable: true,width: 120,tooltip:true,align: "center"},
           { title: "备注",key: "remark",resizable: true,width: 220,tooltip:true},
           { title: "总存量（主单位）",key: "",resizable: true,width: 150},
           { title: "近30天进货量",key: "",resizable: true,width: 120},
           { title: "近30天销量",key: "",resizable: true,width: 120},
           { title: "生产企业",key: "production",resizable: true,width: 130,tooltip:true,align: "center"},
           { title: "产地",key: "origin",resizable: true,width: 120,tooltip:true,align: "center"},
           { title: "商品大类",key: "category",resizable: true,width: 100,tooltip:true,align: "center"},
           { title: "功能类别",key: "function",resizable: true,width: 100,tooltip:true,align: "center"},
           { title: "委托书期限",key: "wtsxq_date",resizable: true,width: 120,align: "center"},
         ],
         data:[],
         is_deduction:0,
         proList:{},
         subLoading:true,
         formData:JSON.parse(JSON.stringify(fData)),
         ruleVal:{
           goods_code:[
               {required:true,message:'请选择产品',trigger:'change'}
           ]
         },
         checkIndex:-1,
         goods_unit:this.$store.state.sysParam['goods_unit']
      }
    },
    watch:{
      supplierCode(){
        if(this.supplierCode.length > 0) this.init();
      }
    },
    mounted() {
       if(this.supplierCode.length > 0) this.init();
    },
    methods:{
      init:function(){
        let _this = this;
        _this.loading = true;
        _this.common.http({url:'getProGoods',data:{supplier_code:this.supplierCode}}).then(function(res){
            if(res.status==1){
              _this.data = res.data;
            }else{
              _this.data = [];
            }
            _this.$nextTick(function(){
               _this.loading = false;
               if(res.status==1) _this.checkIndex = 0;
               else  _this.checkIndex = -1;
            })
        }).catch(function(err){
             _this.common.httpErr(err.data,_this);
        });
      },
      rowClassName(row, index) {
          if (index === this.checkIndex) {
            return 'ivu-table-row-highlight';
          }
          return '';
      },
      rowClick:function(item,index){
        this.checkIndex = index;
      },
      addEdit:function(type){
        if(type){
          if(this.checkIndex != -1){
            const NewData = JSON.parse(JSON.stringify(this.data[this.checkIndex]));
            if(NewData.price) NewData.price = parseFloat(NewData.price)
            if(NewData.price2) NewData.price2 = parseFloat(NewData.price2)
            this.formData = NewData;
          }else{
            return this.alertMsg('请选择需要修改的信息','error')
          }
        }else this.formData = JSON.parse(JSON.stringify(fData));
        this.editModal = true;
      },
      choosePro:function(){
        this.$refs.selectGoodsRef.open();
      },
      comData:function(){
        let _this = this;
        if(this.supplierCode.length < 0) return false;
        this.subLoading = true;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.formData.supplier_code = _this.supplierCode;
            _this.common.http({
              url: 'comVarieties',data:{fdata:_this.formData}
            }).then(function (res) {
              _this.alertMsg(res.msg,res.status != 1?'error':'');
              if(res.status == 1){
                if(_this.formData.id) _this.$set(_this.data, _this.checkIndex, res.data)
                else{
                  _this.data.unshift(res.data)
                  _this.checkIndex = 0;
                }
                _this.editModal = false;
              }else{
                _this.subLoading = false;
                setTimeout(function(){_this.subLoading = true;},10)
              }
            }).catch(function(err){
              _this.subLoading = false;
              setTimeout(function(){_this.subLoading = true;},10)
              _this.common.httpErr(err.data,_this);
            })
          }else{
            _this.subLoading = false;
            setTimeout(function(){_this.subLoading = true;},10)
          }
        })
      },
      selectGoodsRow:function(e){
        this.formData.goods_code = e.goods_code;
        this.formData.goods_name = e.goods_name;
        this.formData.unit = e.unit;
        this.formData.unit2 = e.unit2;
        this.formData.specs = e.specs;
      }
    }
  }
</script>
<style lang="less">
  .table-m-bot{
    padding:0 90px 0 10px; position: relative;
    .right-btn{
      width: 77px; position: absolute; right: 0; top: 0; bottom: 0;
      .edit-btn{
        margin-bottom:10px;
      }
      .ivu-checkbox-wrapper {
        font-size: 12px;
      }
    }
  }
</style>
