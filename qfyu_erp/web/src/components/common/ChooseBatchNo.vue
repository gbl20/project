<template>
  <div >
    <Modal v-model="modal" title="选择生产批号/序列号" :mask-closable="false" width="1000" footer-hide class-name="choose-batch-m">
      <div class="choose-batch-con">
        <div class="con-overflow">
          <div class="top-m">
            <div class="left-l border-r">
              <Tree :data="data" :render="renderContent" children-key="next" @on-select-change="clickMenu($event)"></Tree>
            </div>
            <div class="right-l">
              <div class="r-l-top">
                <div v-if="goodsData">
                  <Row class-name="l-item bg-text">
                    <Col span="8"><span class="success-text">品名：</span>{{goodsData.goods_name}}</Col>
                    <Col span="8"><span class="success-text">规格：</span>{{goodsData.specs}}</Col>
                    <Col span="8"><span class="success-text">单位：</span>{{goodsData.unit}}</Col>
                  </Row>
                  <Row class-name="l-item bg-text">
                    <Col span="12"><span class="success-text">产地：</span>{{goodsData.origin}}</Col>
                    <Col span="12"><span class="success-text">生产企业：</span>{{goodsData.production}}</Col>
                  </Row>
                </div>
              </div>
              <Table size="small" stripe  :row-class-name="rowClassName" :columns="columns" :data="stockList" border class="table-m" :height="320" :loading="loading" @on-row-click="(row,index)=>{checkIndex = index}">
                <template slot-scope="{row,index}" slot="usable_qty">
                  {{(row.unit==goodsData.unit)?row.usable_qty:row.usable_qty1}}
                </template>
                <template slot-scope="{row,index}" slot="qty">
                  {{(row.unit==goodsData.unit)?row.qty:row.qty1}}
                </template>
                <template slot-scope="{row,index}" slot="price1">
                  {{(row.unit==goodsData.unit)?row.price1:row.price2}}
                </template>
              </Table>
            </div>
          </div>
          <div class="bottom-m border-t">
            <Form ref="formRef" :label-width="100" label-position="right">
              <Row class-name="bg-text">
                <Col span="8" class-name="l-item">
                  <div class="red-text">红色表示仓库不可销售！</div>
                  <div class="italic-style brown-text">斜体棕色表示仓库正在盘点！</div>
                  <div class="yellow-text">
                    棕色表示该仓库被设置了[销售警告]标志，在销售开单模块选择这些库存出货时会收到提示信息。
                  </div>
                </Col>
                <Col span="6" class-name="l-item">
                  <div class="red-text" style="margin-bottom:6px;">总库存数量不得大于总可用数量</div>
                  <FormItem label="实际出货数量">
                    <InputNumber v-model="out_qty" :precision="5" :min="0" :active-change="false" style="width: 100px;"></InputNumber>
                  </FormItem>
                  <FormItem label="整件出货数量">
                    <InputNumber v-model="neat_out_qty" :precision="5" :min="0" :active-change="false" style="width: 100px;"></InputNumber>
                  </FormItem>
                </Col>
                <Col span="10" class-name="l-item">
                  <FormItem :label-width="10">
                    <Button @click="confirm" type="primary" style="margin-top:24px;">
                      <Icon type="md-checkmark"/>确定
                    </Button>
                  </FormItem>
                  <FormItem :label-width="10">
                    <Button @click="modal = false" type="warning">
                      <Icon type="md-close" />取消
                    </Button>
                  </FormItem>
                </Col>
              </Row>
            </Form>
          </div>
        </div>
      </div>
    </Modal>
  </div>
</template>
<script>
  export default {
      components:{},
      data () {
        return {
          modal:false,
          loading:false,
          columns:[
            {title:'仓库编号',key:'ware_code',width:80,align:'center'},
            {title:'仓库名称',key:'ware_title',width:140,resizable:true},
            {title:'货位',key:'berth_no',minWidth:80,resizable:true},
            {title:'可用量',slot:'usable_qty',minWidth:120,resizable:true},
            {title:'实际库存',slot:'qty',width:120,align:'center',resizable:true},
            {title:'单价',slot:'price1',width:120,align:'center',resizable:true},
            {title:'金额',key:'amount',width:120,align:'center'},
            {title:'生产批号',key:'batch_no',minWidth:150,resizable:true},
            {title:'生产日期',key:'prod_date',width:100,align:'center',resizable:true},
            {title:'有效日期',key:'valid_date',width:120,align:'center',resizable:true},
            {title:'供应商',key:'prov_no',width:100,align:'center',resizable:true},
            {title:'可用大包装数',key:'usable_big_pack_qty',width:120,align:'center'},
            {title:'大包装数',key:'big_pack_qty',width:120,align:'center'},
            {title:'货品状态',key:'goods_state',width:120,align:'center'},
            {title:'质量状态',key:'quality_state',minWidth:120}
          ],
          data:[],
          stockList:[],
          checkIndex:-1,
          goodsCode:'',
          goodsData:null,
          out_qty:0,
          neat_out_qty:0
        }
      },
      watch:{
        goodsCode(){
          this.init();
        },
        checkIndex(newIndex,oldIndex){
          if(oldIndex == -1) return false;
          else this.out_qty = 0;
        },
        out_qty(outQty){
          let ItemData = this.stockList[this.checkIndex];
          let qty = (ItemData.unit==this.goodsData.unit)?ItemData.usable_qty:ItemData.usable_qty1;
          qty = parseFloat(qty);
          if(qty <= 0) outQty = 0;
          else if(outQty > qty) outQty = qty;
          else if(outQty <= 0) outQty = 0;
          setTimeout(()=>{
            this.out_qty = outQty;
            if(ItemData.unit==this.goodsData.unit){
              this.neat_out_qty = this.formatFloat(outQty/ItemData.big_package,5);
            }else{
              this.neat_out_qty = this.formatFloat(outQty/ItemData.big_package/ItemData.solit_value,5);
            }
          },100)
        },
        neat_out_qty(neatOutQty){
          let ItemData = this.stockList[this.checkIndex];
          let big_pack_qty = ItemData.usable_big_pack_qty;
          big_pack_qty = parseFloat(big_pack_qty);
          if(big_pack_qty <= 0) neatOutQty = 0;
          else if(neatOutQty > big_pack_qty) neatOutQty = big_pack_qty;
          else if(neatOutQty <= 0) neatOutQty = 0;
          setTimeout(()=>{
            this.neat_out_qty = neatOutQty;
            if(ItemData.unit==this.goodsData.unit){
              this.out_qty = this.formatFloat(neatOutQty*ItemData.big_package,5);
            }else{
              this.out_qty = this.formatFloat(neatOutQty*ItemData.big_package*ItemData.solit_value,5);
            }
          },100)
        },
      },
      methods:{
        init:function(){
          let _this = this;
          this.loading=true;
          this.common.http({url:'s/chooseBatchNo',data:{goods_code:this.goodsCode}}).then(function(res){
              _this.loading=false;
              if(res.status==1){
                _this.data = res.data;
                _this.stockList = res.stock_list;
                _this.checkIndex = res.stock_list.length > 0?0:-1
                _this.$nextTick(()=>{
                   _this.out_qty = _this.goodsData.s_qty || 0;
                },300)
              }
          }).catch(function(err){
            _this.common.httpErr(err.data,_this);
          });
        },
        confirm:function(){
          setTimeout(()=>{
            let stockList = this.stockList[this.checkIndex];
            this.$emit("confirm",{'stockList':stockList,'out_qty':this.out_qty});
            this.modal = false;
          },300)
        },
        clickMenu:function(event){
          this.stockList = event[0].stock_list?event[0].stock_list:[]
          this.checkIndex = event[0].stock_list?0:-1
        },
        open:function(goods_data){
          this.goodsData = goods_data;
          this.goodsCode = goods_data.goods_code;
          this.modal = true;
        },
        renderContent (h, { root, node, data }) {
          let className = '';
          if(!data.canbyonsale){//不可销售
            className = 'red-text';
          }else if(data.cannotice){//销售时警告
            className = 'yellow-text';
          }
          if(data.inventory_order_id) className += ' italic-style brown-text';
          return h('span',{class:className}, [h('span',data.title)]);
        },
        rowClassName(row,index){
          let className = '';
          if (index === this.checkIndex) {
            className = 'ivu-table-row-highlight';
          }
          if(!row.canbyonsale){//不可销售
            className += ' red-text';
          }else if(row.cannotice){//销售时警告
            className += ' yellow-text';
          }
          if(row.inventory_order_id) className += ' italic-style brown-text';
          return className;
        }
      }
  }
</script>
<style lang="less">
  .choose-batch-m{
    overflow: hidden;
    .choose-batch-con{
      width: 100%;overflow-x: auto;
      .con-overflow{
        width:1000px;
      }
    }
    .ivu-modal-body{
      padding:0;
    }
    .top-m{
      clear: both;overflow: hidden;height: 400px;
      .left-l{
        width: 229px;float: left;padding:0 10px;height: 400px;
        .ivu-tree{
          overflow-x: auto;height:390px;
        }
      }
      .right-l{
        width: 748px;float: left;height: 100%;margin:0 10px;
        .r-l-top{
          width: auto;height: 70px;padding:10px;
          .l-item{
            line-height: 25px;font-size: 14px;
          }
        }
      }
    }
    .bottom-m{
      width: auto;height: 116px;padding:10px;
      .l-item{
        padding:0 12px;
      }
    }
  }
</style>
