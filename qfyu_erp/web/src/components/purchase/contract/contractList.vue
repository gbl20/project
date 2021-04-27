<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                <Button @click="createContract(false)"><span class="icon iconfont">&#xe797;</span>新建</Button>
                <Button @click="createContract(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <Divider type="vertical"/>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
              </div>
          </div>
          <div slot="table-list">
              <Table ref="contractListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="list" border class="table-m" :height="height" :loading="loadding"
                  @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                  @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
              </Table>
          </div>
      </split-none>
  </div>
</template>
<script>
    import splitNone from '@/components/public/splitNone'
    var _this=this;
    export default {
        components:{splitNone},
        data(){
          return {
             height:0,
             Breadcrumb:[{title:'采购管理'},{title:'采购合同'}],
             columns:[
                {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
                {title:'合同号',key:'orderid',width:160,fixed:'left',align:'center'},
                {title:'供应商编号',key:'sup_code',width:100,fixed:'left',align:'center'},
                {title:'供应商名称',key:'sup_name',minWidth:200},
                {title:'签约日期',key:'sign_date',minWidth:100,align:'center'},
                {title:'生效日期',key:'start_date',width:100,align:'center'},
                {title:'失效日期',key:'validity_date',width:100,align:'center'},
                {title:'合同标题',key:'title',minWidth:200},
                {title:'签约地点',key:'sign_area',minWidth:200},
                {title:'签约人',key:'sign_code',width:100,align:'center'},
                {title:'签约人姓名',key:'sign_name',width:120,align:'center'},
                {title:'交货地点',key:'delivery',minWidth:200},
                {title:'结算方式',key:'settlement_name',minWidth:150,align:'center'},
                {title:'付款日期',key:'pay_date',width:120,align:'center'},
                {title:'资源所属',key:'dept_name',minWidth:150},
                {title:'创建者',key:'creator',width:100,align:'center'},
                {title:'创建时间',key:'create_date',width:150,align:'center'},
                {title:'更新者',key:'updator',width:100,align:'center'},
                {title:'更新时间',key:'update_date',width:150,align:'center'},
                {title:'备注说明',key:'explain',width:200}
             ],
             list:[],
             loadding:false,
             selectIndex:0
          }
        },
        beforeCreate:function(){
           _this=this;
        },
        created:function(){
           _this.init();
        },
        methods:{
           rowClassName(row,index){
              if (index===_this.selectIndex) {
                  return 'ivu-table-row-highlight';
              }
              return '';
           },
           DHeight(e){
              _this.height = e;
           },
           /**
            * 初始化数据
            */
           init:function(){
              _this.loadding=true;
              _this.common.http({url:'contractList',data:{}}).then(function(res){
                  _this.loadding=false;
                  if(res.status==1){
                      _this.list=res.list.data;
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
           },
           /**
            * 表格双击、单击处理
            * @param index 行索引
            * @param type true:双击
            */
           selectRowIndex:function(index,type){
              _this.selectIndex=index;
              if(type) _this.createContract(true);
           },
           /**
            * 创建、修改合同
            * @param type true:修改
            */
           createContract:function(type){
              var query={orderid:""};
              if(type){
                  if(_this.selectIndex<0) return _this.alertMsg('请至少选择一行后操作','error');
                  query.orderid=_this.list[_this.selectIndex].orderid;
              }
              _this.toUrl("/editContract",query);
           }
        }
    }
</script>
<style>
</style>