<template>
<div class="acc-stock-edit">
    <split-none @DHeight="DHeight" :editTypeTitle="editTypeTitle" :Breadcrumb="Breadcrumb">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button v-if="!data.transfer" :disabled="canEdit" @click="canEdit=true"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button v-if="!data.transfer" :disabled="!canEdit" @click="upwhole"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button v-if="!data.transfer" :disabled="!canEdit"  @click="cancel_edit"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
          <Button v-if="!data.transfer" :disabled="canEdit" @click="check_whole"><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Button @click="delView()"><span class="icon iconfont">&#xe7fd;</span>退出</Button>
        </div>
        <div class="ser-form">
          <Form :label-width="90" class="orderform">
            <Row>
              <Col span="5">
                <FormItem label="盘点单号：">
                  <Input v-model="data.bill_no" placeholder="盘点单号(系统生成)" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="经手人：">
                  <Input :icon="canEdit?'ios-more':''" :value="$store.state.emp[data.empno]" style="cursor: pointer;" readonly :disabled="!canEdit" @on-click="show_selemp(-1)"></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="盘点日期：">
                  <DatePicker type="date" :editable="false" :clearable="false" :value="data.f_date" disabled></DatePicker>
                </FormItem>
              </Col>
              <Col span="6">
                <FormItem label="盘点仓库：">
                  <Input :value="data.ware_title" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="审核员：">
                  <Input :value="$store.state.emp[data.auditno]" disabled></Input>
                </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="8">
                <FormItem label="备注：">
                  <Input v-model="data.remark" :disabled="!canEdit"></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <Button type="primary" style="margin: 0 10px 0 25px;" :disabled="!canEdit" @click="add_line">增加行</Button>
                <Button :disabled="!canEdit" @click="del_line">删除行</Button>
              </Col>
              <Col span="7">
                <div class="ostatus txt-color">状态：<span class="ostatus-txt">{{data.transfer?'已审核':'未审核'}}</span></div>
                <div class="ostatus-attention">*已审核的订单不可修改</div>
              </Col>
            </Row>
            <Row>
              <Col span="24">
                <FormItem label="明细添加方式：" :label-width="110">
                  <RadioGroup v-model="initCfg.atype" @on-change="change_atype">
                    <Radio :label="0">手工添加盘盈数据</Radio>
                    <Radio :label="1">调出录入商品的库存</Radio>
                  </RadioGroup>
                  <Checkbox v-model="initCfg.noqty" :true-value="1" :false-value="0" :disabled="initCfg.atype==0?true:false">包含账面库存为0的商品</Checkbox>
                  <Checkbox v-model="initCfg.setTqty" :true-value="1" :false-value="0" :disabled="initCfg.atype==0?true:false">将账面库存设为实际库存</Checkbox>
                </FormItem>
              </Col>
            </Row>
          </Form>
        </div>
      </div>
      <div slot="table-list">
        <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading" @on-row-click="selectRowIndex">
          <template slot-scope="row" slot="pos_code">
            <Input v-if="canEdit && !row.row.stock_id && row.row.atype!=1" icon="ios-more" :value="row.row.pos_code" readonly style="cursor: pointer;" @on-click="openpos(row.index)" :class="'pos_code'+row.row.index"></Input>
            <span v-else>{{row.row.pos_code}}</span>
          </template>
          <template slot-scope="row" slot="goods_code">
            <Input v-if="canEdit && !row.row.stock_id" icon="ios-more" :value="row.row.goods_code" readonly style="cursor: pointer;" @on-click="opengoods(row.index)" :class="'goods_code'+row.row.index"></Input>
            <span v-else>{{row.row.goods_code}}</span>
          </template>
          <template slot-scope="row" slot="price">
            <input class="ivu-input ivu-input-default" maxlength="16" v-if="canEdit && !row.row.stock_id && row.row.atype!=1" v-model="list[row.index].price" @input="filter_price(row.index)" :class="'price'+row.row.index" />
            <span v-else>{{row.row.price}}</span>
          </template>
          <template slot-scope="row" slot="rqty">
            <input class="ivu-input ivu-input-default" maxlength="15" v-model="list[row.index].rqty" v-if="canEdit && row.row.atype!=1" @input="filter_rqty(row.index)" :class="'rqty'+row.row.index" />
            <span v-else>{{row.row.rqty}}</span>
          </template>
          <template slot-scope="row" slot="batch_no">
            <Input v-if="canEdit && !row.row.stock_id && row.row.atype!=1" maxlength="30" v-model="list[row.index].batch_no" :class="'batch_no'+row.row.index"></Input>
            <span v-else>{{row.row.batch_no}}</span>
          </template>
          <template slot-scope="row" slot="sup_code">
            <Input v-if="canEdit && !row.row.stock_id && row.row.atype!=1" icon="ios-more" :value="row.row.sup_code" readonly style="cursor: pointer;" @on-click="openprov('',row.index)" :class="'sup_code'+row.row.index"></Input>
            <span v-else>{{row.row.sup_code}}</span>
          </template>
          <template slot-scope="row" slot="prod_date">
            <DatePicker v-if="canEdit && !row.row.stock_id && row.row.atype!=1" type="date" :editable="false" :clearable="false" v-model="list[row.index].prod_date" :class="'prod_date'+row.row.index"></DatePicker>
            <span v-else>{{row.row.prod_date}}</span>
          </template>
          <template slot-scope="row" slot="valid_date">
            <DatePicker v-if="canEdit && !row.row.stock_id && row.row.atype!=1" type="date" :editable="false" :clearable="false" v-model="list[row.index].valid_date" :class="'valid_date'+row.row.index"></DatePicker>
            <span v-else>{{row.row.valid_date}}</span>
          </template>
          <template slot-scope="row" slot="remark">
            <Input v-if="canEdit && row.row.atype!=1" v-model="list[row.index].remark" maxlength="150"></Input>
            <span v-else>{{row.row.remark}}</span>
          </template>
        </Table>
      </div>
    </split-none>
    <select-employee ref="selemp" @selemp="select_emp"></select-employee>
  <select-goods ref="selectGoodsRef" :isSignle="false" fun="openprov" refname="selectGoodsRef" @selectRow="confirmGoods"></select-goods>
  <choose-providers ref="selectProviderRef" @confirm="confirmPro"></choose-providers>
  <choose-ware-pos ref="chooseWareChildRef" @confirm="confirmPos"></choose-ware-pos>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import selectEmployee from '@/components/common/SelectEmployee'
    import selectGoods from '@/components/common/ChooseGoods'
    import chooseProviders from '@/components/common/ChooseProviders'
    import chooseWarePos from '@/components/common/ChooseWarePosition'
    export default {
        name:'editWhole',
        components:{splitNone,selectEmployee,selectGoods,chooseProviders,chooseWarePos},
        data(){
           return {
              id:localStorage.getItem('whole_editid'),
              Breadcrumb:[{title:'仓储物流'},{title:'库存盘点'},{title:'整仓盘点单'}],
              editTypeTitle:this.id==''?'新增':'修改',
              height:0,
              columns:[
                {title:'序号',key:'item_no',minWidth:60},
                {title:'货位',slot:'pos_code',minWidth:110},
                {title:'商品编号',slot:'goods_code',minWidth:110},
                {title:'商品名称',key:'goods_name',minWidth:200},
                {title:'规格',key:'specs',minWidth:110},
                {title:'账面数量',key:'qty',minWidth:80},
                {title:'单价',slot:'price',minWidth:100},
                {title:'单位',key:'unit',minWidth:60},
                {title:'账面金额',key:'amount',minWidth:90},
                {title:'实存数量',slot:'rqty',minWidth: 110},
                {title:'实存金额',key:'ramount',minWidth:90},
                {title:'盈亏数量',key:'diff_qty',minWidth: 60},
                {title:'盈亏金额',key:'diff_amount',minWidth:90},
                {title:'生产批号',slot:'batch_no',minWidth:110},
                {title:'供应商编号',slot:'sup_code',minWidth:110},
                {title:'供应商名称',key:'sup_name',minWidth:130},
                {title:'生产日期',slot:'prod_date',minWidth:125},
                {title:'有效期至',slot:'valid_date',minWidth:125},
                {title:'备注',slot:'remark',minWidth:125},
                {title:'附件名',key:'file_name',minWidth:90},
                {title:'拼音码',key:'pym',minWidth:90},
                {title:'功能类别',key:'function_name',minWidth:90},
                {title:'商品大类',key:'category_name',minWidth:90},
                {title:'剂型',key:'dosage',minWidth:90},
                {title:'批准文号',key:'approval_code',minWidth:140},
                {title:'生产企业',key:'production',minWidth:160},
                {title:'产地',key:'origin',minWidth:90},
                {title:'参考批发价',key:'selprice',minWidth:90},
                {title:'产品金额(批发价)',key:'sel_amount',minWidth:90},
                {title:'参考零售价',key:'rtlprice',minWidth:90},
                {title:'产品金额(零售价)',key:'rtl_amount',minWidth:90}
              ],
              data: {},
              list:[],
              loading:false,
              page:1,
              pageSize:10,
              search:{},
              canEdit:false,
              isAdd:false,
              initCfg:{setTqty:1,atype:1,noqty:0}
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        created:function(){
          this.editTypeTitle=this.id==''?'新增':'修改';
          this.init();
        },
        beforeRouteEnter(to, from, next) {
          next(vm => {
            if(from.name == 'accstock'){vm.id = localStorage.getItem('whole_editid');}
          });
        },
        watch:{
          id:function (){
            this.editTypeTitle=this.id==''?'新增':'修改';
            this.init();
          }
        },
        methods:{
            DHeight(e){
                this.height = e;
            },
          /**
           * 设置高亮
           */
          rowClassName(row,index) {
            var className='';
            if(index===_this.selectIndex){
              className+='ivu-table-row-highlight';
            }
            return className;
          },
          /**
           * 单击选择某一行
           */
          selectRowIndex:function(data,index){
            _this.selectIndex=index;
          },
            /**
             * 初始化数据
             */
            init:function(){
                _this.loading=true;
                _this.common.http({url:'w/editWhole',data:{id:this.id}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                      _this.isAdd=res.data.bill_no?false:true;
                      _this.data=res.data;
                      _this.list=res.list;
                    }else{
                      _this.alertMsg(res.msg,'error');
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
          /**
           * 打开员工选择组件
           */
          show_selemp:function () {
            if(!this.data.transfer) this.$refs.selemp.init({})
          },
          /**
           * 选择员工
           */
          select_emp:function (e){
            this.$set(this.data,'empno',e.code);
          },
          /**
           * 修改 详情添加方式
           */
          change_atype:function (atype){
            var last_key=this.list.length-1;
            if(this.list.length>0) this.list[last_key].atype=atype;
          },
          /**
           * 删除行
           */
          del_line:function (){
            this.list.splice(this.selectIndex,1);
          },
          /**
           * 增加行
           */
          add_line:function (){
            if(!this.data.ware_code) return false;
            if(this.list.length==0){
              this.list.push({item_no:1,goods_code:null,rqty:null,stock_id:0,remark:'',isadd:1,atype:this.initCfg.atype});
            }else{
              if(this.check_complete()){
                var last_key=this.list.length-1,item_no=parseInt(this.list[last_key].item_no)+1;
                this.list.push({item_no:item_no,goods_code:null,rqty:null,stock_id:0,isadd:1,atype:this.initCfg.atype});
              }
            }
          },
          /**
           * 验证详情列表资料是否完善
           */
          check_complete:function (){
            var data=this.list,has_complete=true;
            for(var i in data){
              if(!data[i].goods_code || data[i].goods_code==''){
                has_complete=false;
                this.alertMsg('序号为'+data[i].item_no+'的行，未选择产品','error',{duration:5});
                break;
              }else if(!data[i].pos_code || data[i].pos_code==''){
                has_complete=false;
                this.alertMsg('序号为'+data[i].item_no+'的行，未选择盘点货位','error',{duration:5});
                break;
              }else if(!data[i].price || data[i].price==''){
                has_complete=false;
                this.alertMsg('序号为'+data[i].item_no+'的行，未填写单价','error',{duration:5});
                break;
              }else if(!data[i].rqty || data[i].rqty==''){
                has_complete=false;
                this.alertMsg('序号为'+data[i].item_no+'的行，未填写实存数量','error',{duration:5});
                break;
              }else if(!data[i].batch_no || data[i].batch_no==''){
                has_complete=false;
                this.alertMsg('序号为'+data[i].item_no+'的行，未填写生产批号','error',{duration:5});
                break;
              }else if(!data[i].prod_date || data[i].prod_date==''){
                has_complete=false;
                this.alertMsg('序号为'+data[i].item_no+'的行，未填写生生产日期','error',{duration:5});
                break;
              }
            }
            return has_complete;
          },
          /**
           * 打开货位选择
           */
          openpos:function (key) {
            if(!this.data.ware_code){
              this.alertMsg('请先选择盘点仓库','error',{duration:3});
              return false;
            }
            this.selectIndex=key;
            this.$refs.chooseWareChildRef.open(this.data.ware_code);
          },
          /**
           *  货位回调
           */
          confirmPos:function (e){
            this.$set(this.list[this.selectIndex],'pos_code',e.pos_code);
          },
          /**
           * 打开供应商选择
           */
          openprov:function (gref,key){
            if(typeof key != "undefined") this.selectIndex=key;
            this.gref=gref;
            this.$refs.selectProviderRef.open();
          },
          /**
           * 选择供应商回调
           */
          confirmPro:function (e){
            if(this.gref==''){
              this.$set(this.list[this.selectIndex],'sup_code',e.supplier_code);
              this.$set(this.list[this.selectIndex],'sup_name',e.full_name);
            }else{
              this.$refs[this.gref].selectProvNotify(e);
            }
          },
          /**
           * 打开产品选择
           */
          opengoods:function (key){
            this.selectIndex=key;
            this.$refs.selectGoodsRef.open();
          },
          /**
           * 选择产品回调
           */
          confirmGoods:function (e){
            if(this.list[this.selectIndex].atype==0){
              this.$set(this.list[this.selectIndex],'goods_code',e.goods_code);
              this.$set(this.list[this.selectIndex],'goods_name',e.goods_name);
              this.$set(this.list[this.selectIndex],'specs',e.specs);
              this.$set(this.list[this.selectIndex],'qty',0);
              this.$set(this.list[this.selectIndex],'unit',e.unit);
              this.$set(this.list[this.selectIndex],'amount',0);
              this.$set(this.list[this.selectIndex],'file_name',e.file_name);
              this.$set(this.list[this.selectIndex],'pym',e.pym);
              this.$set(this.list[this.selectIndex],'sup_code',e.supplier);
              this.$set(this.list[this.selectIndex],'sup_name',e.sup_name);
              this.$set(this.list[this.selectIndex],'function_name',e.function);
              this.$set(this.list[this.selectIndex],'category_name',e.category);
              this.$set(this.list[this.selectIndex],'dosage',e.dosage);
              this.$set(this.list[this.selectIndex],'approval_code',e.approval_code);
              this.$set(this.list[this.selectIndex],'production',e.production);
              this.$set(this.list[this.selectIndex],'origin',e.origin);
              this.$set(this.list[this.selectIndex],'selprice',e.commodity_price[2].price1);
              this.$set(this.list[this.selectIndex],'rtlprice',e.commodity_price[3].price1);
              this.calc_price();
            }else{
              var hasadd=0;
              if(this.list.length>0){
                var last_key=this.list.length-1,maxkey=this.list[last_key].item_no;
                if(last_key==this.selectIndex) maxkey-=1;
              }else{
                var maxkey=0;
              }
              for(var i in this.list){
                if(this.list[i].goods_code==e.goods_code && this.list[i].stock_id>0){
                  hasadd=1;
                  this.alertMsg('已添加此商品','error',{duration:3});
                  break;
                }
              }
              if(hasadd) return false;
              _this.loading=true;
              _this.common.http({url:'w/imStockList',data:{ware_code:this.data.ware_code,goods_code:e.goods_code,maxkey:maxkey,tqty:this.initCfg.setTqty,noqty:this.initCfg.noqty}}).then(function(res){
                _this.loading=false;
                if(res.status==1){
                  _this.list.splice(_this.selectIndex,1);
                  _this.list=_this.list.concat(res.list);
                }else{
                  _this.alertMsg(res.msg,'error');
                }
              }).catch(function(err){
                _this.common.httpErr(err.data,_this);
              });
            }
          },
          /**
           * 真实库存输入过滤
           */
          filter_rqty:function (key){
            this.selectIndex=key;
            var va=this.list[key].rqty;
            va=va.replace(/[^\d.]/g,"");
            va=va.replace(/\.{2,}/g,".");
            va=va.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
            this.list[key].rqty=va.replace(/^(\-)*(\d+)\.(\d\d\d\d\d).*$/,'$1$2.$3');
            this.calc_price();
          },
          /**
           * 主单位单价输入过滤
           */
          filter_price:function (key){
            this.selectIndex=key;
            var va=this.list[key].price;
            va=va.replace(/[^\d.]/g,"");
            va=va.replace(/\.{2,}/g,".");
            va=va.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
            this.list[key].price=va.replace(/^(\-)*(\d+)\.(\d\d\d\d\d\d).*$/,'$1$2.$3');
            this.calc_price();
          },
          /**
           * 计算价格
           */
          calc_price:function (){
            var skey=this.selectIndex;
            if(this.list[skey].rqty && parseFloat(this.list[skey].rqty)>=0){
              if(this.list[skey].price && parseFloat(this.list[skey].price)!=0){
                this.$set(this.list[skey],'ramount',this.formatFloat(this.list[skey].rqty*this.list[skey].price,6));
                if(this.list[skey].qty && parseFloat(this.list[skey].qty)>=0){
                  this.$set(this.list[skey],'diff_qty',this.formatFloat(this.list[skey].rqty-this.list[skey].qty,5));
                  this.$set(this.list[skey],'diff_amount',this.formatFloat(this.list[skey].ramount-this.list[skey].amount,6));
                }else{
                  this.$set(this.list[skey],'diff_qty',parseFloat(this.list[skey].rqty));
                  this.$set(this.list[skey],'diff_amount',parseFloat(this.list[skey].ramount));
                }
              }
              if(this.list[skey].selprice && parseFloat(this.list[skey].selprice)!=0){
                this.$set(this.list[skey],'sel_amount',this.formatFloat(this.list[skey].rqty*this.list[skey].selprice,6));
                if(!this.list[skey].price || (this.list[skey].price && parseFloat(this.list[skey].price)==0)) this.$set(this.list[skey],'diff_amount',this.list[skey].sel_amount);
              }
              if(this.list[skey].rtlprice && parseFloat(this.list[skey].rtlprice)!=0){
                this.$set(this.list[skey],'rtl_amount',this.formatFloat(this.list[skey].rqty*this.list[skey].rtlprice,6));
              }
            }
          },
          /**
           * 保存修改
           */
          upwhole:function (){
            if(this.list.length==0){
              this.alertMsg('请添加盘点详情后再保存','error',{duration:3});
              return false;
            }else{
              if(!this.check_complete()) return false;
            }
            this.$Spin.show();
            _this.common.http({url:'w/upWhole',data:{data:this.data,list:this.list}}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.canEdit=false;
                localStorage.setItem('whole_editid',res.bill_no);
                _this.id=res.bill_no;
                _this.init();
                _this.alertMsg(res.msg);
              }else{
                _this.alertMsg(res.msg,'error',{duration:5,isClosable:true});
              }
            }).catch(function(err){
              _this.$Spin.hide();
              _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 整仓盘点单审核
           */
          check_whole:function (){
            _this.$Modal.confirm({
              title:'提示',
              content:'确定审核吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/checkWhole',data:{bill_no:_this.id}}).then(function(res){
                  _this.$Spin.hide();
                  if(res.status==1){
                    _this.canEdit=false;
                    _this.init();
                    _this.alertMsg(res.msg);
                  }else{
                    _this.alertMsg(res.msg,'error');
                  }
                }).catch(function(err){
                  _this.$Spin.hide();
                  _this.common.httpErr(err.data,_this);
                });
              }
            });
          },
          /**
           * 取消修改
           */
          cancel_edit:function (){
            this.canEdit=false;
            this.init();
          }
        }
    }
</script>
<style lang="less">
.acc-stock-edit{
  .ostatus{display: inline-block; height: 32px; padding-left: 30px; font-size: 13px; line-height: 32px;
  .ostatus-txt{font-size: 16px; font-weight: bold; color: #ff4d4f; vertical-align: middle; box-sizing: border-box;}
  }
  .ostatus-attention{display: inline-block; padding-left: 50px; font-size: 12px; line-height: 32px; color: #ff0000;}
}
</style>
