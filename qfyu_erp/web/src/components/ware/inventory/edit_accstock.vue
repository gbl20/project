<template>
<div class="acc-stock-edit">
    <split-none @DHeight="DHeight" :editTypeTitle="editTypeTitle" :Breadcrumb="Breadcrumb">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button v-if="!data.transfer" :disabled="(isAdd || canEdit)?true:false" @click="canEdit=true"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button v-if="!data.transfer" :disabled="!canEdit" @click="upacc"><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Button v-if="!data.transfer" :disabled="!canEdit"  @click="cancel_edit"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
          <Button v-if="!data.transfer" :disabled="(canEdit || isAdd)?true:false" @click="check_acc"><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Button :disabled="(!data.transfer || isAdd)?true:false" @click="make_inv"><span class="icon iconfont">&#xe6a3;</span>实物盘点表</Button>
          <Button @click="delView()"><span class="icon iconfont">&#xe7fd;</span>退出</Button>
        </div>
        <div class="ser-form">
          <Form :label-width="90" class="orderform">
            <Row>
              <Col span="5">
                <FormItem label="结存单号：">
                  <Input v-model="data.bill_no" placeholder="结存单号(系统生成)" disabled></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="经手人：">
                  <Input :icon="(isAdd || canEdit)?'ios-more':''" :value="$store.state.emp[data.empno]" style="cursor: pointer;" readonly :disabled="(isAdd || canEdit)?false:true" @on-click="show_selemp(-1)"></Input>
                </FormItem>
              </Col>
              <Col span="4">
                <FormItem label="盘点日期：">
                  <DatePicker type="date" :editable="false" :clearable="false" :value="data.f_date" disabled></DatePicker>
                </FormItem>
              </Col>
              <Col span="6">
                <FormItem label="盘点仓库：">
                  <Input icon="ios-more" :value="data.ware_title" style="cursor: pointer;" disabled></Input>
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
                  <Input v-model="data.remark" :disabled="(isAdd || canEdit)?false:true"></Input>
                </FormItem>
              </Col>
              <Col span="16">
                <div class="ostatus txt-color">状态：<span class="ostatus-txt">{{data.transfer?'已审核':'未审核'}}</span></div>
                <div class="ostatus-attention">*已审核的订单不可修改</div>
              </Col>
            </Row>
          </Form>
        </div>
      </div>
      <div slot="table-list">
        <Table size="small" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading">
          <template slot-scope="row" slot="dispatched">
            <Checkbox :value="row.row.dispatched" :true-value="1" :false-value="0" disabled></Checkbox>
          </template>
        </Table>
      </div>
    </split-none>
    <select-employee ref="selemp" @selemp="select_emp"></select-employee>
    <Modal width="500" v-model="inv_status" :mask-closable="false" footer-hide title="生成实物盘点单(分发设置)" class-name="acc-edit">
      <div class="mtit txt-color">账面结存单号：{{id}}</div>
      <div class="stit">盘点序号范围:1~{{maxsn}}<span v-if="!re_inv">，已生成实物盘点单，不能重新分发！</span></div>
      <div class="tips bg-color">一张账面结存单可以分为多张实物盘点单，以便多人同时盘点。</div>
      <Table :columns="fcol" :data="fdata" max-height="500">
        <template slot-scope="row" slot="empno">
          <Input :icon="re_inv?'ios-more':''" :value="$store.state.emp[row.row.empno]" style="cursor: pointer;" readonly @on-click="show_selemp(row.index)" :disabled="!re_inv"></Input>
        </template>
        <template slot-scope="row" slot="sn1"><InputNumber :max="maxsn" :min="1" v-model="fdata[row.index].sn1" :disabled="!re_inv"></InputNumber></template>
        <template slot-scope="row" slot="sn2"><InputNumber :max="maxsn" :min="1" v-model="fdata[row.index].sn2" :disabled="!re_inv"></InputNumber></template>
        <template slot-scope="row" slot="action" v-if="row.index+1==fdata.length && re_inv"><Button shape="circle" icon="md-add" size="small" @click="add_invlis"></Button></template>
      </Table>
      <div class="foot-mw">
        <div class="fmfr">
          <Button style="margin-right: 15px;" @click="save_invlis" :disabled="!re_inv"><span class="icon iconfont">&#xe7fe;</span>确定</Button>
          <Button @click="inv_status=false"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
        </div>
      </div>
    </Modal>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import selectEmployee from '@/components/common/SelectEmployee'
    import chooseWare from '@/components/common/ChooseWare'
    export default {
        name:'editAccstock',
        components:{splitNone,selectEmployee},
        data(){
           return {
              id:localStorage.getItem('accstock_editid'),
              Breadcrumb:[{title:'仓储物流'},{title:'库存盘点'},{title:'账面库存结存单'}],
              editTypeTitle:this.id==''?'新增':'修改',
              height:0,
              columns:[
                  {title:'序号',key:'itemno',minWidth:60},
                  {title:'盘点货位',key:'pos_code',minWidth:80},
                  {title:'商品编号',key:'goods_code',minWidth:80},
                  {title:'商品名称',key:'goods_name',minWidth:200},
                  {title:'规格',key:'specs',minWidth:110},
                  {title:'条码',key:'bar_code',minWidth:130},
                  {title:'主单位存量',key:'qty1',minWidth:80},
                  {title:'主单位单价',key:'price1',minWidth:80},
                  {title:'主单位',key:'unit',minWidth:60},
                  {title:'辅单位存量',key:'qty2',minWidth:80},
                  {title:'辅单位单价',key:'price2',minWidth:80},
                  {title:'辅单位',key:'unit2',minWidth:60},
                  {title:'账面金额',key:'amount',minWidth:90},
                  {title:'生产批号',key:'batch_no',minWidth:100},
                  {title:'供应商编号',key:'sup_code',minWidth:80},
                  {title:'供应商名称',key:'sup_name',minWidth:130},
                  {title:'生产日期',key:'prod_date',minWidth:90},
                  {title:'有效期至',key:'valid_date',minWidth:90},
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
                  {title:'产品金额(零售价)',key:'rtl_amount',minWidth:90},
                  {title:'分发标志',slot:'dispatched',minWidth:90},
              ],
              data: {},
              list:[],
              loading:false,
              page:1,
              pageSize:10,
              search:{},
              canEdit:false,
              isAdd:false,
             empkey:-1,
             fcol:[
               {title:'序号',type:'index', width:50},
               {title:'盘点经手人',slot:'empno'},
               {title:'起始序号',slot:'sn1'},
               {title:'结束序号',slot:'sn2'},
               {title:' ',slot:'action',width: 50,align:"center"}
             ],
             fdata:[{empno:null,sn1:null,sn2:null}],
             re_inv:true,
             maxsn:0,
             inv_status:false
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
            if(from.name == 'accstock'){vm.id = localStorage.getItem('accstock_editid');}
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
             * 初始化数据
             */
            init:function(){
                _this.loading=true;
                _this.common.http({url:'w/editAccstock',data:{id:this.id}}).then(function(res){
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
           * 修改未审核的单
           */
          upacc:function (){
            this.$Spin.show();
            _this.common.http({url:'w/upAccstock',data:{bill_no:this.id,empno:this.data.empno,remark:this.data.remark}}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.canEdit=false;
                _this.alertMsg(res.msg);
              }else{
                _this.alertMsg(res.msg,'error');
              }
            }).catch(function(err){
              _this.$Spin.hide();
              _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 结存单审核
           */
          check_acc:function (){
            _this.$Modal.confirm({
              title:'提示',
              content:'确定审核吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/checkAccstock',data:{bill_no:_this.id}}).then(function(res){
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
           * 实物盘点表
           */
          make_inv:function (){
            _this.fdata=[{empno:null,sn1:1,sn2:null}];
            this.$Spin.show();
            _this.common.http({url:'w/invAccstock',data:{bill_no:this.id}}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.inv_status=true;
                _this.re_inv=res.data.length>0?false:true;
                _this.fdata=res.data.length>0?res.data:[{empno:null,sn1:null,sn2:null}];
                _this.maxsn=res.maxsn;
              }else{
                _this.alertMsg(res.msg,'error');
              }
            }).catch(function(err){
              _this.$Spin.hide();
              _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 添加分发列表记录
           */
          add_invlis:function (){
            var err=0;
            for (var k in this.fdata){
              if(!this.fdata[k].empno || !this.fdata[k].sn1 || !this.fdata[k].sn2){
                err=1;
                _this.alertMsg('请先填写完第'+(parseInt(k)+1)+'条记录','error');
                break;
              }
            }
            if(err) return false;
            this.$nextTick(function (){_this.fdata.push({empno:null,sn1:null,sn2:null});})
          },
          /**
           * 保存分发记录
           */
          save_invlis:function (){
            var err=1;
            for (var k in this.fdata){
              if(this.fdata[k].empno && this.fdata[k].sn1 && this.fdata[k].sn2){
                err=0;
                break;
              }
            }
            if(err){
              _this.alertMsg('请先填写分发记录','error');
              return false;
            }
            this.$Spin.show();
            _this.common.http({url:'w/saveAccstock',data:{bill_no:this.id,fdata:this.fdata}}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.inv_status=false;
                _this.init();
                _this.$Modal.confirm({title:'提示',content:res.msg,onOk:function(){
                  _this.toUrl('realstock');
                  }
                });
              }else{
                _this.alertMsg(res.msg,'error',{duration:5,isClosable:true});
              }
            }).catch(function(err){
              _this.$Spin.hide();
              _this.common.httpErr(err.data,_this);
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
.acc-edit{
  .mtit{font-size: 18px;}
  .stit{font-size: 13px; line-height: 26px; color:#ff0000;}
  .tips{font-size: 12px;}
  .foot-mw{height: auto; padding-top: 15px; clear: both; overflow: hidden;
    .fmfl{float: left;}
    .fmfr{float: right;}
  }

}
</style>
