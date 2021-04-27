<template>
    <div>
        <split-tb ref="splitMainRef" :splitInit='splitInit' @DHeight="DHeight" :Breadcrumb="Breadcrumb">
            <div slot="form-ser">
              <div class="nav-menu">
                <Button @click="addWare(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button @click="addWare(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button v-if="JSON.stringify(wareSelectData)!='{}'" :disabled="wareSelectData.status!=1"><span class="icon iconfont">&#xe793;</span>停用</Button>
                <Button v-if="JSON.stringify(wareSelectData)!='{}'" :disabled="wareSelectData.status==1"><span class="icon iconfont">&#xe793;</span>启用</Button>
                <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
                <Divider type="vertical"/>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
              </div>
            </div>
            <div slot="table-list">
               <Table id="table-m" size="small" stripe :columns="warecolumn" :data="warelist" border class="table-m"
                    :highlight-row="true" :height="THeight" :loading="wloading" row-key="id"
                    @on-row-click="selectRowData" @on-row-dblclick="selectDbRowData">
                    <template slot-scope="row" slot="c_name">{{$store.state.depart[row.row.ware_deptid]}}</template>
                    <template slot-scope="row" slot="storage_id">
                        <span v-if="JSON.stringify($store.state.sysParam)!='[]'">
                           {{$store.state.sysParam['storage'][row.row.storage_id]}}
                        </span>
                    </template>
                    <template slot-scope="row" slot="type_id">
                        <span v-if="JSON.stringify($store.state.sysParam)!='[]'">
                          {{$store.state.sysParam['ware_type'][row.row.type_id]}}
                        </span>
                    </template>
                    <template slot-scope="row" slot="ware_empname">
                        <span v-if="JSON.stringify($store.state.emp)!='[]'">
                            {{$store.state.emp[row.row.ware_empid]}}
                        </span>
                    </template>
                    <template slot-scope="row" slot="exname">
                        <span v-if="JSON.stringify($store.state.emp)!='[]'">
                          {{$store.state.emp[row.row.ware_examid]}}
                        </span>
                    </template>
                    <template slot-scope="row" slot="canbyonsale">
                        <Checkbox v-model="row.row.canbyonsale" disabled :true-value="1" :false-value="0"></Checkbox>
                    </template>
                    <template slot-scope="row" slot="canbyonline">
                        <Checkbox v-model="row.row.canbyonline" disabled :true-value="1" :false-value="0"></Checkbox>
                    </template>
                    <template slot-scope="row" slot="canvirtual">
                      <Checkbox v-model="row.row.canvirtual" disabled :true-value="1" :false-value="0"></Checkbox>
                    </template>
               </Table>
            </div>
            <div slot="bottom">
               <Tabs type="line" @on-click="changeTabsIndex">
                  <Tab-pane label="仓库货位管理" name="ware_pos">
                    <div class="nav-menu">
                      <Button @click="addWarePosition(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                      <Button @click="addWarePosition(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                      <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
                    </div>
                     <i-table size="small" :columns="poscolumn" :data="poslist" :height="BHeight-90" :loading="posloading" :row-class-name="rowClassName"
                        @on-row-click="(row,index)=>{selectPositionRow(index,false)}"
                        @on-row-dblclick="(row,index)=>{selectPositionRow(index,true)}">
                          <template slot-scope="row" slot="id">{{row.index+1}}</template>
                          <template slot-scope="row" slot="isstock">{{row.row.isstock==1?'可用':'不可用'}}</template>
                     </i-table>
                   </Tab-pane>
                  <Tab-pane label="盘点锁定信息" name="check">
                     <i-table size="small" :columns="inventorycolumn" :data="inventorylist" :height="BHeight-50">

                     </i-table>
                   </Tab-pane>
                </Tabs>
            </div>
        </split-tb>
        <!-- 新增/编辑仓库资料 -->
        <edit-ware ref="wareFormRef" @close="closeModal" @success="saveWareSuccess" :pricelist="pricelist"></edit-ware>
        <!-- 新增/编辑库位资料 -->
        <edit-position ref="warePositionFormRef" @success="savePosSuccess"></edit-position>
    </div>
</template>
<script>
    import splitTb from '@/components/public/splitTB'
    import editWare from '@/components/data_mana/warehouse/editware'
    import editPosition from '@/components/data_mana/warehouse/editPosition'
    var _this;
    export default {
        components:{splitTb,editWare,editPosition},
        data () {
            return {
              Breadcrumb: [{title: '资料管理'}, {title: '仓库及库位管理'}],
              splitInit:0.5,
              BHeight:0,
              THeight:0,
              search:{ware_code:'',ware_title:'',status:1},
              warecolumn: [
                  {title:'编号',type:'index',width:70,fixed:'left'},
                  {title:'仓库编码',key:'ware_code',minWidth:150,fixed:'left',tree:true},
                  {title:'仓库名称',key:'ware_title',minWidth:180},
                  {title:'所属公司',slot:'c_name',minWidth:220},
                  {title:'管理员编码',key:'ware_empid',width:90,align:'center'},
                  {title:'管理员姓名',slot:'ware_empname',minWidth:120,align:'center'},
                  {title:'验货员编码',key:'ware_examid',width:90,align:'center'},
                  {title:'验货员姓名',slot:'exname',minWidth:120,align:'center'},
                  {title:'电话',key:'phone',minWidth:180},
                  {title:'传真',key:'fax',minWidth:180},
                  {title:'所在地区',key:'region',minWidth:180},
                  {title:'地址',key:'address',minWidth:250},
                  {title:'面积',key:'ware_area',minWidth: 180},
                  {title:'存储属性',slot:'storage_id',width:120,align:'center'},
                  {title:'仓库类别',slot:'type_id',width: 120,align:'center'},
                  {title:'不可销售',slot:'canbyonsale',width:80,align:'center'},
                  {title:'不可网购',slot:'canbyonline',width:80,align:'center'},
                  {title:'虚拟分级仓',slot:'canvirtual',width:80,align:'center'},
                  {title:'备注说明',key:'remark',minWidth:200}
              ],
              warelist:[],
              wloading:true,
              wareSelectData:{}, //仓库选择行
              //货位列表
              poscolumn:[
                  {title:'序号',slot:'id',width:70,fixed:'left',align:'center'},
                  {title:'货位编号',key:'pos_code',resizable:true,width:100,fixed:'left'},
                  {title:'所属区域',key:'pos_area',resizable:true,minWidth:120},
                  {title:'长度',key:'pos_long',resizable:true,minWidth:120},
                  {title:'可承重量',key:'pos_weight',resizable:true,minWidth:120},
                  {title:'重量单位',key:'pos_unit1',resizable:true,minWidth:120},
                  {title:'位置描述',key:'pos_desc',resizable:true,minWidth:150},
                  {title:'存放描述',key:'pos_deposit',resizable:true,minWidth:150},
                  {title:'库存可用',slot:'isstock',resizable:true,width:100},
                  {title:'上次盘存日期',key:'inventory_date',resizable:true,width:140,align:"center"},
                  {title:'备注',key:'remark',resizable:true,minWidth:150}
              ],
              poslist:[],
              posloading:false,
              posSelectIndex:0, //货位选择行索引
              inventorycolumn:[
                  {title:'盘点单号',key:'pddh',resizable:true,width:250,fixed:'left'},
                  {title:'锁定时间',key:'sdsj',resizable:true,width:250},
                  {title:'盘点员',key:'pdy',resizable:true,width:250},
                  {title:'盘点员姓名',key:'pdyxm',resizable:true,width:250},
                  {title:'盘点备注',key:'pdbz',resizable:true,width:500},
                  {title:'盘点单类型',key:'pddlx',resizable:true,width:250},
              ],
              inventorylist:[],
              departData:[], //公司部门
              pricelist:[], //价格体系
              selectTabsIndex:'ware_pos', //默认选中货位列表

            }
        },
        mounted() {
          _this = this;
        },
        created:function(){
          this.init();
        },
        methods:{
          DHeight(e){
              this.BHeight = e.BHeight;
              this.THeight = e.THeight;
          },
          /*************Tbs选项卡************/
          changeTabsIndex:function(name){
              _this.selectTabsIndex=name.trim();
              _this.changeTabsData();
          },
          /**
           * 改变Tbs选项卡列表数据
           */
          changeTabsData:function(){
              //加载货位列表
              if(_this.selectTabsIndex=="ware_pos"){
                  _this.initWarePos();
              }
              //盘点锁定信息
              if(_this.selectTabsIndex=="check"){
                  _this.initWareLock();
              }
          },
          /***************盘点锁定信息**************/
          initWareLock:function(){
              var wareCode=_this.wareSelectData.ware_code;
              _this.common.http({url:'wareLockList',data:{ware_code:wareCode}}).then(function(res){
                  if(res.status==1){
                      _this.inventorylist=res.list;
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
          },
          /*************仓库管理************/
          /**
           *  初始化仓库列表
           */
          init:function(){
              _this=this;
              _this.wloading=true;
              _this.common.http({url:'ware_list',data:{search:_this.search}}).then(function(res){
                   _this.wloading=false;
                  if(res.status==1){
                      _this.warelist=res.list;
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 搜索仓库
           */
          doSearch:function(){
              _this.page=1;
              _this.init();
          },
          changePage:function(page){
              _this.page = page;
              _this.init();
          },
          changePageSize:function(page){
              _this.pageSize = page;
              _this.page = 1;
              _this.init();
          },
          /**
           *  关闭新增/编辑仓库资料窗体
           */
          closeModal:function(){
              this.waremodal=false;
          },
          /**
           * 保存新增、编辑仓库资料
           */
          saveWareSuccess:function(res){
              this.page=1;
              this.init();
          },
          /**
           * 点击仓库行数据
           * @param data 行数据
           */
          selectRowData:function(row,index){
              _this.wareSelectData=row;
              _this.changeTabsData();
          },
          /**
           * 双击行数据
           * @param row
           */
          selectDbRowData:function(row,index){
              console.log(index)
              _this.wareSelectData=row;
              _this.addWare(true);
              _this.changeTabsData();
          },
          /**
           * 新增/编辑仓库资料
           */
          addWare:function(type){
               var waredata=null;
               if(type){
                    if(JSON.stringify(_this.wareSelectData)=='{}'){
                        return _this.alertMsg("请至少选择一项后再操作",'error');
                    }
                    waredata=_this.wareSelectData;
               }
               _this.common.http({url:'ware_init',data:{}}).then(function(res){
                  if(res.status==1){
                      _this.pricelist=res.cfg.pricelist;
                      _this.$refs.wareFormRef.init(waredata);
                  }
               }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
               });
          },
          /*************货位管理************/
          rowClassName(row, index) {
             var className = '';
             if (index === this.posSelectIndex) {
                 className+='ivu-table-row-highlight';
             }
             return className;
          },
          /**
           * 加载货位数据列表
           */
          initWarePos:function(){
              if(JSON.stringify(_this.wareSelectData)=='{}') return false;
              _this.posloading=true;
              var wareCode=_this.wareSelectData.ware_code;
              _this.common.http({url:'warepos_list',data:{ware_code:wareCode}}).then(function(res){
                  _this.posloading=false;
                  _this.posSelectIndex=0;
                  _this.poslist=res.list;
              }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
              });
          },
          /**
           * 单击、双击货位列表
           * @param index 选中索引
           * @param type true:双击选择
           */
          selectPositionRow:function(index,type){
                _this.posSelectIndex=index;
                if(type) _this.addWarePosition(true);
          },
          /**
           * 新增、编辑货位资料
           */
          addWarePosition:function(type){
              if(JSON.stringify(_this.wareSelectData)=='{}'){
                 return _this.alertMsg("请选择仓库后操作",'error');
              }
              var wareCode=_this.wareSelectData.ware_code;
              var posdata=null;
              if(type){
                   if(_this.posSelectIndex<0){
                       _this.alertMsg("请选择货位信息后操作",'error');return false;
                   }
                   posdata=_this.poslist[_this.posSelectIndex];
              }else{
                  if(_this.wareSelectData.canvirtual==1){
                      _this.alertMsg("虚拟分级仓下不能建立货位",'error');return false;
                  }
              }
              _this.$refs.warePositionFormRef.init(posdata,wareCode);
          },
          /**
           * 保存新增、编辑货位资料
           */
          savePosSuccess:function(){
              _this.initWarePos();
          }
        }
    }
</script>
<style lang="less">

</style>
