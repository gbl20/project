<template>
<div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
        <div slot="form-ser">
            <div class="nav-menu">
                <Button @click="aedit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button @click="aedit(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button @click="check_acc"><span class="icon iconfont">&#xe692;</span>审核</Button>
                <Button @click="del_acc"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
                <Button @click="init()"><span class="icon iconfont">&#xe788;</span>刷新</Button>
            </div>
        </div>
        <div slot="table-list">
            <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loading" @on-row-click="selectRowIndex" @on-row-dblclick="aedit(1)">
                  <template slot-scope="row" slot="transfer">
                     <span :class="[row.row.transfer?'acc-stock-checked':'acc-stock-no']">{{row.row.transfer?'已审核':'未审核'}}</span>
                  </template>
            </Table>
        </div>
    </split-none>
  <Modal width="1000" v-model="err.status" :mask-closable="false" footer-hide title="以下盘点商品发生了出库操作，需要删除后才能继续审核" class-name="online-edit">
    <Table :columns="err.columns" :data="err.list" max-height="500"></Table>
    <div class="foot-mw">
      <div class="fmfr">
        <Button style="margin-right: 15px;" @click="del_errlist"><span class="icon iconfont">&#xe7fe;</span>删除</Button>
        <Button @click="err.status=false"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
      </div>
    </div>
  </Modal>
</div>
</template>
<script>
    var _this;
    import splitNone from '@/components/public/splitNone'
    export default {
        name:'immediate',
        components:{splitNone},
        data(){
           return {
              Breadcrumb:[{title:'仓储物流'},{title:'库存盘点'},{title:'即时盘点单'}],
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
               err:{
                 status:false,
                 columns:[
                   {title:'序号',key:'item_no',minWidth:60},
                   {title:'盘点货位',key:'pos_code',minWidth:110},
                   {title:'商品编号',key:'goods_code',minWidth:110},
                   {title:'商品名称',key:'goods_name',minWidth:200},
                   {title:'规格',key:'specs',minWidth:110},
                   {title:'账面数量',key:'qty',minWidth:80},
                   {title:'单价',key:'price',minWidth:100},
                   {title:'单位',key:'unit',minWidth:60},
                   {title:'实存数量',key:'rqty',minWidth: 110},
                   {title:'生产批号',key:'batch_no',minWidth:110},
                   {title:'供应商编号',key:'sup_code',minWidth:110},
                   {title:'供应商名称',key:'sup_name',minWidth:130},
                   {title:'生产日期',key:'prod_date',minWidth:125},
                   {title:'有效期至',key:'valid_date',minWidth:125},
                   {title:'批准文号',key:'approval_code',minWidth:140},
                   {title:'生产企业',key:'production',minWidth:160}
                 ],
                 list:[]
               },
              loading:false,
              selectIndex:0,
              page:1,
              pageSize:10,
              search:{}
           }
        },
        beforeCreate:function(){
            _this=this;
        },
        activated:function(){
            _this.init();
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
                _this.common.http({url:'w/imList',data:{}}).then(function(res){
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
             * 修改/新增
             */
            aedit:function(type){
              if(type==1){
                if(this.list.length==0) return false;
                localStorage.setItem('acconline_editid',this.list[this.selectIndex].bill_no);
                this.toUrl('edit_acconline');
              }else{
                localStorage.setItem('acconline_editid','');
                this.toUrl('edit_acconline');
              }
            },
          /**
           * 审核
           */
          check_acc:function (){
            if(this.list.length==0) return false;
            var bill_no=this.list[this.selectIndex].bill_no,transfer=this.list[this.selectIndex].transfer;
            if(transfer){
              this.alertMsg('已审核的即时盘点单不能重复审核','error');
              return false;
            }
            _this.$Modal.confirm({
              title:'提示',
              content:'确定审核吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/checkAcconline',data:{bill_no:bill_no}}).then(function(res){
                  if(res.status==1){
                    _this.$Spin.hide();
                    _this.init();
                    _this.alertMsg(res.msg);
                  }else if(res.status==2){ //提示盘点商品有出库  需要删除
                    _this.common.http({url:'w/editAcconline',data:{id:bill_no,item_no:res.erritem}}).then(function(ree){
                      _this.$Spin.hide();
                      if(ree.status==1){
                        _this.err.status=true;
                        _this.err.list=ree.list;
                      }else{
                        _this.alertMsg(ree.msg,'error');
                      }
                    }).catch(function(error){
                      _this.$Spin.hide();
                      _this.common.httpErr(error.data,_this);
                    });
                  }else{
                    _this.$Spin.hide();
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
           * 删除有出库变动的盘点商品
           */
          del_errlist:function (){
            var erritem=[],err=_this.err.list,bill_no=this.list[this.selectIndex].bill_no;
            for (var i in err){
              erritem.push(err[i].item_no);
            }
            _this.$Spin.show();
            _this.common.http({url:'w/delAccerr',data:{bill_no:bill_no,erritem:erritem}}).then(function(res){
              _this.$Spin.hide();
              if(res.status==1){
                _this.err.status=false;
                _this.init();
                _this.alertMsg(res.msg);
              }else{
                _this.alertMsg(res.msg,'error',{duration:8,isClosable:true});
              }
            }).catch(function(err){
              _this.$Spin.hide();
              _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 删除即时盘点单
           */
          del_acc:function (){
            if(this.list.length==0) return false;
            var bill_no=this.list[this.selectIndex].bill_no,transfer=this.list[this.selectIndex].transfer;
            if(transfer){
              this.alertMsg('已审核的即时盘点单不能删除','error');
              return false;
            }
            _this.$Modal.confirm({
              title:'提示',
              content:'确定删除吗？',
              onOk:function(){
                _this.$Spin.show();
                _this.common.http({url:'w/delAcconline',data:{bill_no:bill_no}}).then(function(res){
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
.online-edit{
  .foot-mw{height: auto; padding-top: 15px; clear: both; overflow: hidden;
    .fmfl{float: left;}
    .fmfr{float: right;}
  }
}
</style>
