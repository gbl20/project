<template>
  <div>
    <div class="table-m-bot">
      <Table size="small" border stripe :columns="columns" :rowClassName="rowClassName" @on-row-click="rowClick" :data="data" :loading="loading" :highlight-row="true" :height="height">
      </Table>
      <div class="right-btn">
        <Button class="edit-btn" @click="addEdit"><span class="icon iconfont">&#xe797;</span>新增</Button>
        <Button class="edit-btn"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        <Checkbox v-model="is_deduction" :true-value="1" :false-value="0">库存显示扣除待出库数量</Checkbox>
      </div>
    </div>
    <Modal v-model="editModal" title="添加供应商自产商品" width="400" :closable="false" :mask-closable="false" :loading="subLoading" @on-ok="comData">
        <Form ref="formRef" :rules="ruleVal" :model="formData" :label-width="90">
          <Row>
            <Col span="12">
              <FormItem label="商品编号：" prop="goods_code">
                <Input readonly icon="ios-more" style="cursor: pointer;" v-model="formData.goods_code" @on-click="choosePro"></Input>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="" :label-width="10">
                <Input disabled v-model="formData.goods_name"></Input>
              </FormItem>
            </Col>
          </Row>
          <FormItem label="备注：">
            <Input type="textarea" maxlength="200" show-word-limit v-model="formData.remark" :autosize="{minRows:2,maxRows: 2}"></Input>
          </FormItem>
        </Form>
     </Modal>
     <select-goods ref="selectGoodsRef" :isSignle="true" @selectRow="selectGoodsRow"></select-goods>
  </div>
</template>

<script>
  import selectGoods from '@/components/common/ChooseGoods'
  var fData = {supplier_code:'',goods_code:'',remark:''};
  export default{
    name :'contacts',
    components:{selectGoods},
    props: {
      height:{
        type:Number,
        default:0
      },
      isProduction:{
        type:Number,
        default:1
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
        is_deduction:0,
        columns:[
         { title: "供应商编号",key: "supplier_code",width: 120,align: "center"},
         { title: "商品编号",key: "goods_code",width: 120,align: "center"},
         { title: "商品名称",key: "goods_name",resizable: true,width: 120,align: "center",tooltip:true},
         { title: "规格",key: "specs",width: 120,align: "center",tooltip:true},
         { title: "主单位",key: "unit",width: 90,align: "center"},
         { title: "辅单位",key: "unit2",width: 90,align: "center"},
         { title: "备注",key: "supplier_code",resizable: true,width: 180,align: "center",tooltip:true},
         { title: "总存量（主单位）",key: "",width: 120,align: "center"},
         { title: "最近30天进货量",key: "",width: 120,align: "center"},
         { title: "最近30天销量",key: "",width: 120,align: "center"},
         { title: "产地",key: "origin",resizable: true,width: 120,align: "center",tooltip:true},
         { title: "生成企业",key: "production",resizable: true,width: 120,align: "center",tooltip:true},
         { title: "商品大类",key: "category",width: 120,align: "center",tooltip:true}
        ],
        data:[],
        subLoading:true,
        checkIndex:-1,
        formData:JSON.parse(JSON.stringify(fData)),
        goods_unit:this.$store.state.sysParam['goods_unit'],
        ruleVal:{
         goods_code:[
           {required:true, message:'请选择一个商品',trigger:'change'}
         ]
        }
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
        _this.common.http({url:'getProduced',data:{supplier_code:this.supplierCode}}).then(function(res){
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
      comData:function(){
        let _this = this;
        if(this.supplierCode.length < 0) return false;
        this.formData.supplier_code = this.supplierCode;
        this.subLoading = true;
        this.$refs.formRef.validate(function(valid){
          if (valid) {
            _this.formData.supplier_code = _this.supplierCode;
            _this.common.http({
              url: 'comProduced',data:{fdata:_this.formData}
            }).then(function (res) {
              _this.alertMsg(res.msg,res.status != 1?'error':'');
              if(res.status == 1){
                _this.data.unshift(res.data)
                _this.checkIndex = 0;
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
      choosePro:function(){
        this.$refs.selectGoodsRef.open();
      },
      addEdit:function(){
        if(!this.isProduction){
          this.modalMsg('只能为“生产企业”类型的供应商添加自产商品！');
        }else{
          this.editModal = true;
        }
      },
      selectGoodsRow:function(e){
        this.formData.goods_code = e.goods_code;
        this.formData.goods_name = e.goods_name;
        this.formData.origin = e.origin;
        this.formData.specs = e.specs;
        this.formData.unit = e.unit;
        this.formData.unit2 = e.unit2;
        this.formData.production = e.production;
        this.formData.category = e.category;
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
