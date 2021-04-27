<template>
<div class="acc-stock-edit">
    <split-none @DHeight="DHeight" :editTypeTitle="editTypeTitle" :Breadcrumb="Breadcrumb">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button v-if="!data.transfer" :disabled="canEdit" @click="canEdit=true"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button v-if="!data.transfer" :disabled="!canEdit" @click="uprel"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button v-if="!data.transfer" :disabled="!canEdit" @click="cancel_edit"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
          <Button v-if="!data.transfer" :disabled="canEdit" @click="check_acc"><span class="icon iconfont">&#xe692;</span>审核</Button>
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
                  <Input :icon="id?'':'ios-more'" :value="data.ware_title" style="cursor: pointer;" readonly :disabled="id?true:false" @on-click="show_choware"></Input>
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
              <Col span="5">
                <FormItem label="结存单号：">
                  <Input v-model="data.pbill_no" placeholder="账面库存结存单号" disabled></Input>
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
          </Form>
        </div>
      </div>
      <div slot="table-list">
        <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading" @on-row-click="selectRowIndex">
          <template slot-scope="row" slot="pos_code">
            <Input v-if="canEdit && !row.row.stock_id" icon="ios-more" :value="row.row.pos_code" readonly style="cursor: pointer;" @on-click="openpos(row.index)"></Input>
            <span v-else>{{row.row.pos_code}}</span>
          </template>
          <template slot-scope="row" slot="goods_code">
            <Input v-if="canEdit && !row.row.stock_id" icon="ios-more" :value="row.row.goods_code" readonly style="cursor: pointer;" @on-click="opengoods(row.index)"></Input>
            <span v-else>{{row.row.goods_code}}</span>
          </template>
          <template slot-scope="row" slot="price1">
            <input class="ivu-input ivu-input-default" maxlength="16" v-if="canEdit && !row.row.stock_id" v-model="list[row.index].price1" @input="filter_price(row.index)" />
            <span v-else>{{row.row.price1}}</span>
          </template>
          <template slot-scope="row" slot="rqty1">
            <input class="ivu-input ivu-input-default" maxlength="15" v-model="list[row.index].rqty1" v-if="canEdit" @input="filter_rqty(row.index)" />
            <span v-else>{{row.row.rqty1}}</span>
          </template>
          <template slot-scope="row" slot="batch_no">
            <Input v-if="canEdit && !row.row.stock_id" maxlength="30" v-model="list[row.index].batch_no"></Input>
            <span v-else>{{row.row.batch_no}}</span>
          </template>
          <template slot-scope="row" slot="sup_code">
            <Input v-if="canEdit && !row.row.stock_id" icon="ios-more" :value="row.row.sup_code" readonly style="cursor: pointer;" @on-click="openprov('',row.index)"></Input>
            <span v-else>{{row.row.sup_code}}</span>
          </template>
          <template slot-scope="row" slot="prod_date">
            <DatePicker v-if="canEdit && !row.row.stock_id" type="date" :editable="false" :clearable="false" v-model="list[row.index].prod_date"></DatePicker>
            <span v-else>{{row.row.prod_date}}</span>
          </template>
          <template slot-scope="row" slot="valid_date">
            <DatePicker v-if="canEdit && !row.row.stock_id" type="date" :editable="false" :clearable="false" v-model="list[row.index].valid_date"></DatePicker>
            <span v-else>{{row.row.valid_date}}</span>
          </template>
        </Table>
      </div>
    </split-none>
    <select-employee ref="selemp" @selemp="select_emp"></select-employee>
    <choose-ware ref="chooseWareRef" @confirm="confirmParentWare"></choose-ware>
    <select-goods ref="selectGoodsRef" :isSignle="false" fun="openprov" refname="selectGoodsRef" @selectRow="confirmGoods"></select-goods>
    <choose-providers ref="selectProviderRef" @confirm="confirmPro"></choose-providers>
    <choose-ware-pos ref="chooseWareChildRef" @confirm="confirmPos"></choose-ware-pos>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import selectEmployee from '@/components/common/SelectEmployee'
    import chooseWare from '@/components/common/ChooseWare'
    import selectGoods from '@/components/common/ChooseGoods'
    import chooseProviders from '@/components/common/ChooseProviders'
    import chooseWarePos from '@/components/common/ChooseWarePosition'
    export default {
        name:'editRealstock',
        components:{splitNone,selectEmployee,chooseWare,selectGoods,chooseProviders,chooseWarePos},
        data(){
           return {
              id:localStorage.getItem('realstock_editid'),
              Breadcrumb:[{title:'仓储物流'},{title:'库存盘点'},{title:'实物盘点单'}],
              editTypeTitle:this.id==''?'新增':'修改',
              height:0,
              columns:[
                  {title:'序号',key:'item_no',minWidth:60},
                  {title:'盘点货位',slot:'pos_code',minWidth:110},
                  {title:'商品编号',slot:'goods_code',minWidth:110},
                  {title:'商品名称',key:'goods_name',minWidth:200},
                  {title:'规格',key:'specs',minWidth:110},
                  {title:'主单位存量',key:'qty1',minWidth:80},
                  {title:'主单位单价',slot:'price1',minWidth:100},
                  {title:'主单位',key:'unit',minWidth:60},
                  //{title:'辅单位存量',key:'qty2',minWidth:80},
                  //{title:'辅单位单价',key:'price2',minWidth:80},
                  //{title:'辅单位',key:'unit2',minWidth:60},
                  {title:'账面金额',key:'amount',minWidth:90},
                  {title:'主单位实数',slot:'rqty1',minWidth: 110},
                  {title:'实存金额',key:'ramount',minWidth:90},
                  {title:'主单位盈亏数',key:'diffqty1',minWidth: 60},
                  {title:'盈亏金额',key:'diffamount',minWidth:90},
                  {title:'生产批号',slot:'batch_no',minWidth:110},
                  {title:'供应商编号',slot:'sup_code',minWidth:110},
                  {title:'供应商名称',key:'sup_name',minWidth:130},
                  {title:'生产日期',slot:'prod_date',minWidth:125},
                  {title:'有效期至',slot:'valid_date',minWidth:125},
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
              canEdit:this.id==''?true:false,
              selectIndex:0,
              gref:''
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        created:function(){
          this.canEdit=this.id==''?true:false;
          this.editTypeTitle=this.id==''?'新增':'修改';
          this.init();
        },
        beforeRouteEnter(to, from, next) {
          next(vm => {
            if(from.name == 'realstock'){
              vm.id = localStorage.getItem('realstock_editid');
            }
          });
        },
        watch:{
          id:function (){
            this.editTypeTitle=this.id==''?'新增':'修改';
            this.canEdit=this.id==''?true:false;
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
                _this.common.http({url:'w/editRealstock',data:{id:this.id}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
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
          show_selemp:function (key) {
            this.empkey=key;
            if(!this.data.transfer || key!=-1) this.$refs.selemp.init({})
          },
          /**
           * 选择员工
           */
          select_emp:function (e){
            if(this.empkey==-1) this.$set(this.data,'empno',e.code);
            else this.$set(this.fdata[this.empkey],'empno',e.code);
          },
          /**
           * 打开仓库选择
           */
          show_choware:function (){
            if(!this.id || this.id=='') this.$refs.chooseWareRef.open();
          },
          /**
           * 选择仓库后回调
           */
          confirmParentWare:function (e){
            if(this.data.ware_code!=e.ware_code) this.list=[];
            this.$set(this.data,'ware_code',e.ware_code);
            this.$set(this.data,'ware_title',e.ware_title);
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
            if(!this.data.ware_code){
              this.alertMsg('请先选择盘点仓库','error',{duration:3});
              return false;
            }
            if(this.list.length==0){
              this.list.push({item_no:1,goods_code:null,rqty1:null,stock_id:0,isadd:1});
            }else{
              var last_key=this.list.length-1,item_no=parseInt(this.list[last_key].item_no)+1;
              if(this.list[last_key].goods_code && this.list[last_key].goods_code!=''){
                this.list.push({item_no:item_no,goods_code:null,rqty1:null,stock_id:0,isadd:1});
              }else{
                this.alertMsg('请先填写完已新增行的信息','error',{duration:3});
              }
            }
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
            this.$set(this.list[this.selectIndex],'goods_code',e.goods_code);
            this.$set(this.list[this.selectIndex],'goods_name',e.goods_name);
            this.$set(this.list[this.selectIndex],'specs',e.specs);
            this.$set(this.list[this.selectIndex],'qty1',0);
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
          },
          /**
           * 真实库存输入过滤
           */
          filter_rqty:function (key){
            this.selectIndex=key;
            var va=this.list[key].rqty1;
            va=va.replace(/[^\d.]/g,"");
            va=va.replace(/\.{2,}/g,".");
            va=va.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
            this.list[key].rqty1=va.replace(/^(\-)*(\d+)\.(\d\d\d\d\d).*$/,'$1$2.$3');
            this.calc_price();
          },
          /**
           * 主单位单价输入过滤
           */
          filter_price:function (key){
            this.selectIndex=key;
            var va=this.list[key].price1;
            va=va.replace(/[^\d.]/g,"");
            va=va.replace(/\.{2,}/g,".");
            va=va.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
            this.list[key].price1=va.replace(/^(\-)*(\d+)\.(\d\d\d\d\d\d).*$/,'$1$2.$3');
            this.calc_price();
          },
          /**
           * 计算价格
           */
          calc_price:function (){
            var skey=this.selectIndex;
            if(this.list[skey].rqty1 && parseFloat(this.list[skey].rqty1)>=0){
              if(this.list[skey].price1 && parseFloat(this.list[skey].price1)!=0){
                this.$set(this.list[skey],'ramount',this.formatFloat(this.list[skey].rqty1*this.list[skey].price1,6));
                if(this.list[skey].qty1 && parseFloat(this.list[skey].qty1)>=0){
                  this.$set(this.list[skey],'diffqty1',this.formatFloat(this.list[skey].rqty1-this.list[skey].qty1,5));
                  this.$set(this.list[skey],'diffamount',this.formatFloat(this.list[skey].ramount-this.list[skey].amount,6));
                }else{
                  this.$set(this.list[skey],'diffqty1',parseFloat(this.list[skey].rqty1));
                  this.$set(this.list[skey],'diffamount',parseFloat(this.list[skey].ramount));
                }
              }
              if(this.list[skey].selprice && parseFloat(this.list[skey].selprice)!=0){
                this.$set(this.list[skey],'sel_amount',this.formatFloat(this.list[skey].rqty1*this.list[skey].selprice,6));
                if(!this.list[skey].price1 || (this.list[skey].price1 && parseFloat(this.list[skey].price1)==0)) this.$set(this.list[skey],'diffamount',this.list[skey].sel_amount);
              }
              if(this.list[skey].rtlprice && parseFloat(this.list[skey].rtlprice)!=0){
                this.$set(this.list[skey],'rtl_amount',this.formatFloat(this.list[skey].rqty1*this.list[skey].rtlprice,6));
              }
            }
          },
          /**
           * 保存修改
           */
          uprel:function (){
            if(this.list.length==0){
              this.alertMsg('请添加盘点详情后再保存','error',{duration:3});
              return false;
            }else{
              var last_key=this.list.length-1;
              if(!this.list[last_key].goods_code) {
                this.alertMsg('最后一行未选择产品', 'error', {duration: 3});
                return false;
              }
            }
            for(var i in this.list){
              if(!this.list[i].rqty1 || this.list[i].rqty1.length==0 || this.list[i].rqty1===null){
                this.alertMsg('序号为'+this.list[i].item_no+'的行，产品主单位实数未录入', 'error', {duration: 3});
                return false;
              }
            }
            this.$Spin.show();
            _this.common.http({url:'w/upRealstock',data:{data:this.data,list:this.list}}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.canEdit=false;
                localStorage.setItem('realstock_editid',res.bill_no);
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
           * 实物盘点单审核
           */
          check_acc:function (){
            _this.$Modal.confirm({
              title:'提示',
              content:'确定审核吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/checkReal',data:{bill_no:_this.id}}).then(function(res){
                  _this.$Spin.hide();
                  if(res.status==1){
                    _this.canEdit=false;
                    _this.init();
                    _this.alertMsg(res.msg);
                  }else{
                    _this.alertMsg(res.msg,'error',{duration:8,isClosable:true});
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
