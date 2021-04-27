<template>
<div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
                <Button @click="add_new"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button @click="aedit"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button @click="check_acc"><span class="icon iconfont">&#xe692;</span>审核</Button>
                <Button @click="del_acc"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
                <Button @click="init();get_add_cfg()"><span class="icon iconfont">&#xe788;</span>刷新</Button>
            </div>
        </div>
        <div slot="table-list">
            <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading" @on-row-click="selectRowIndex" @on-row-dblclick="aedit">
                  <template slot-scope="row" slot="transfer">
                     <span :class="[row.row.transfer?'acc-stock-checked':'acc-stock-no']">{{row.row.transfer?'已审核':'未审核'}}</span>
                  </template>
            </Table>
        </div>
    </split-none>
    <Modal width="390" v-model="add.status" :mask-closable="false" footer-hide title="盘点选项" class-name="whole-lst">
      <Form :label-width="80">
        <FormItem label="盘点仓库">
          <Input icon="ios-more" :value="add.ware_title" style="cursor: pointer;" readonly @on-click="show_choware"></Input>
        </FormItem>
        <FormItem :label-width="25">
          <RadioGroup v-model="add.atype" vertical>
            <Radio :label="1">调出盘点仓库的所有库存</Radio>
            <Radio :label="0">手动录入盘点商品</Radio>
            <Radio :label="2">调出指定货位、指定类别的库存</Radio>
          </RadioGroup>
        </FormItem>
        <div class="item-group">
          <FormItem label="货位">
            <Input icon="ios-more" :disabled="add.atype==2?false:true" :value="add.pos_code" style="cursor: pointer;" readonly @on-click="openpos"></Input>
          </FormItem>
          <FormItem label="商品大类">
            <Select v-model="add.category_id" style="width:100%" :disabled="add.atype==2?false:true">
              <Option v-for="(item,key) in add_cfg.category" :value="item.id" :key="key">{{item.title}}</Option>
            </Select>
          </FormItem>
          <FormItem label="功能类别">
            <Input icon="ios-more" :value="add.function" :disabled="add.atype==2?false:true" style="cursor: pointer;" readonly @on-click="show_selgfn"></Input>
          </FormItem>
        </div>
        <FormItem :label-width="25">
          <Checkbox v-model="add.noqty" :true-value="1" :false-value="0">包含账面库存为0的商品</Checkbox>
        </FormItem>
      </Form>
      <div class="foot-mw">
        <div class="fmfr">
          <Button style="margin-right: 15px;" @click="sub_add"><span class="icon iconfont">&#xe7fe;</span>确定</Button>
          <Button @click="add.status=false"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
        </div>
      </div>
    </Modal>
  <choose-ware ref="chooseWareRef" @confirm="confirmParentWare"></choose-ware>
  <choose-ware-pos ref="chooseWareChildRef" @confirm="confirmPos"></choose-ware-pos>
  <select-goods-function ref="goodsFunction" @confirm="selGfn"></select-goods-function>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    import chooseWare from '@/components/common/ChooseWare'
    import chooseWarePos from '@/components/common/ChooseWarePosition'
    import selectGoodsFunction from '@/components/common/SelectGoodFunction'
    export default {
        name:'whole',
        components:{splitNone,chooseWare,chooseWarePos,selectGoodsFunction},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'库存盘点'},{title:'整仓盘点单'}],
              height:0,
              columns:[
                  {title:'单据编号',key:'bill_no',minWidth:160},
                  {title:'盘点时间',key:'f_date',minWidth:130},
                  {title:'盘点仓库编号',key:'ware_code',minWidth:90},
                  {title:'仓库名称',key:'ware_title',minWidth:100},
                  {title:'经手人',key:'empno',minWidth:90},
                  {title:'审核者',key:'auditno',minWidth:90},
                  {title:'是否审核',slot:'transfer',minWidth:90,align:'center'},
                  {title:'备注',key:'remark',minWidth:150},
                  {title:'创建人',key:'creater',minWidth:90},
                  {title:'创建时间',key:'create_date',minWidth:130},
                  {title:'修改人',key:'mender',minWidth:90},
                  {title:'更新时间',key:'update_date',minWidth:130},
                  {title:'资源所属部门',key:'dept_name',minWidth:90}
              ],
              list:[],
              loading:false,
              selectIndex:0,
              page:1,
              pageSize:10,
              search:{},
              add:{
                status:false,
                ware_code:'',
                atype:1,
                ware_title:'',
                pos_code:'',
                category_id:0,
                function_id:0,
                function:'',
                noqty:0
              },
              add_cfg:{category:[]}
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        activated:function(){
            _this.init();
        },
        created() {
          _this.get_add_cfg();
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
             * 初始化数据
             */
            init:function(){
                _this.loading=true;
                _this.common.http({url:'w/wholeList',data:{}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.data;
                    }
                }).catch(function(err){
                    _this.common.httpErr(err.data,_this);
                });
            },
            /**
             * 单击选择某一行
             */
            selectRowIndex:function(data,index){
               _this.selectIndex=index;
            },
            /**
             * 新增整仓盘点单
             */
            add_new:function (){
              this.add={status:true,ware_code:'',atype:1,ware_title:'',pos_code:'',category_id:0,function_id:0,function:'',noqty:0};
            },
            /**
             * 打开仓库选择
             */
            show_choware:function (){
              this.$refs.chooseWareRef.open();
            },
            /**
             * 选择仓库后回调
             */
            confirmParentWare:function (e){
              this.$set(this.add,'ware_code',e.ware_code);
              this.$set(this.add,'ware_title',e.ware_title);
            },
            /**
             * 打开货位选择
             */
            openpos:function () {
              if(this.add.ware_code==''){
                this.alertMsg('请先选择盘点仓库','error',{duration:3});
                return false;
              }
              this.$refs.chooseWareChildRef.open(this.add.ware_code);
            },
            /**
             *  货位回调
             */
            confirmPos:function (e){
              this.$set(this.add,'pos_code',e.pos_code);
            },
            /**
             * 获取发布新整仓盘点单配置
             */
            get_add_cfg:function (){
              _this.common.http({url:'w/getAddCfg',data:{}}).then(function(res){
                if(res.status==1){
                  _this.add_cfg.category=res.category;
                }
              }).catch(function(err){
                _this.common.httpErr(err.data,_this);
              });
            },
          /**
           * 弹出选择产品功能类别
           */
            show_selgfn:function (){
              this.$refs.goodsFunction.init();
            },
          /**
           * 选择产品功能类别
           */
            selGfn:function (e){
              this.$set(this.add,'function_id',e.id);
              this.$set(this.add,'function',e.title);
            },
            /**
             * 修改
             */
            aedit:function(){
              if(this.list.length==0) return false;
              localStorage.setItem('whole_editid',this.list[this.selectIndex].bill_no);
              this.toUrl('edit_whole');
            },
          /**
           * 提交新增整仓盘点单
           */
          sub_add:function (){
            if(this.add.ware_code==''){
              this.alertMsg('请先选择盘点仓库','error',{duration:3});
              return false;
            }
            var data={ware_code:this.add.ware_code,atype:this.add.atype,pos_code:this.add.pos_code,category_id:this.add.category_id,function_id:this.add.function_id,noqty:this.add.noqty};
            _this.common.http({url:'w/addWhole',data:data}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.add.status=false;
                localStorage.setItem('whole_editid',res.bill_no);
                _this.toUrl('edit_whole');
              }else{
                _this.$Modal.error({
                  title: '提示',
                  content: res.msg
                })
              }
            }).catch(function(err){
              _this.$Spin.hide();
              _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 审核
           */
          check_acc:function (){
            if(this.list.length==0) return false;
            var bill_no=this.list[this.selectIndex].bill_no,transfer=this.list[this.selectIndex].transfer;
            if(transfer){
              this.alertMsg('已审核的整仓盘点单不能重复审核','error');
              return false;
            }
            _this.$Modal.confirm({
              title:'提示',
              content:'确定审核吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/checkWhole',data:{bill_no:bill_no}}).then(function(res){
                  _this.$Spin.hide();
                  if(res.status==1){
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
           * 删除整仓盘点单
           */
          del_acc:function (){
            if(this.list.length==0) return false;
            var bill_no=this.list[this.selectIndex].bill_no,transfer=this.list[this.selectIndex].transfer;
            if(transfer){
              this.alertMsg('已审核的整仓盘点单不能删除','error');
              return false;
            }
            _this.$Modal.confirm({
              title:'提示',
              content:'确定删除吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/delWhole',data:{bill_no:bill_no}}).then(function(res){
                  _this.$Spin.hide();
                  if(res.status==1){
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
          }
        }
    }
</script>
<style lang="less">
.acc-stock-checked{display: inline-block; height: 18px; padding: 0 10px; line-height: 18px; color: #52c41a; background-color: rgba(82, 196, 26, 0.15);}
.acc-stock-no{display: inline-block; height: 18px; padding: 0 10px; line-height: 18px; color: #FAAD14; background-color: rgba(250, 173, 20, 0.15);}
.whole-lst{
  .item-group{
    padding-left: 25px;
  }
  .foot-mw{height: auto; padding-top: 15px; clear: both; overflow: hidden;
    .fmfr{float: right;}
  }
}
</style>
