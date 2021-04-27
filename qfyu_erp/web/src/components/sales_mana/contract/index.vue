<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                <Button @click="addEdit(0)"><span class="icon iconfont">&#xe797;</span>新建</Button>
                <Button @click="addEdit(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
                <Divider type="vertical"/>
                <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
                <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
              </div>
          </div>
          <div slot="table-list">
              <Table ref="contractListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height" :loading="loading"
                  @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
                  @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
                  <template slot-scope="{row}" slot="settlement">
                    {{settlement[row.settlement]}}
                  </template>
              </Table>
          </div>
      </split-none>
      <edit-contract ref="editContractRef" :settlement="settlement" @addNotify="addNotify"></edit-contract>
  </div>
</template>
<script>
    import splitNone from '@/components/public/splitNone'
    import editContract from '@/components/sales_mana/contract/edit'
    var _this=this;
    export default {
      name:'sales_contract',
        components:{splitNone,editContract},
        data(){
          return {
             height:0,
             Breadcrumb:[{title:'销售管理'},{title:'销售合同'}],
             columns:[
                {title:'合同号',key:'contract_no',width:160,fixed:'left',align:'center'},
                {title:'签约日期',key:'sign_date',width:100,align:'center'},
                {title:'生效日期',key:'start_date',width:100,align:'center'},
                {title:'失效日期',key:'validity_date',width:100,align:'center'},
                {title:'合同标题',key:'title',width:200,align:'center'},
                {title:'签约地点',key:'sign_area',width:200,align:'center'},
                {title:'签约人',key:'sign_code',width:100,align:'center'},
                {title:'员工姓名',key:'sign_name',width:120,align:'center'},
                {title:'客户编号',key:'cust_code',width:120,align:'center'},
                {title:'客户名称',key:'cust_name',width:180,align:'center'},
                {title:'发货地点',key:'delivery',width:200,align:'center'},
                {title:'结算方式',slot:'settlement',width:150,align:'center'},
                {title:'收款日期',key:'pay_date',width:120,align:'center'},
                {title:'资源所属',key:'dept_name',width:150,align:'center'},
                {title:'开单人',key:'creator',width:100,align:'center'},
                {title:'开单部门名称',key:'creator',width:100,align:'center'},
                {title:'创建时间',key:'create_date',width:150,align:'center'},
                {title:'备注',key:'explain',width:200}
             ],
             data:[],
             settlement:[],
             loading:false,
             checkIndex:0
          }
        },
        created:function(){
          _this = this;
          _this.init();
        },
        methods:{
          rowClassName(row,index){
            if (index === _this.checkIndex) {
                return 'ivu-table-row-highlight';
            }
            return '';
          },
          DHeight(e){
            _this.height = e;
          },
          init:function(){
            _this.loading = true;
            _this.common.http({url:'s/salesContractInit',data:{}}).then(function(res){
              if(res.status==1){
                _this.settlement = res.settlement;
                _this.data = res.data;
              }
              _this.$nextTick(function(){
                _this.loading = false;
              })
            }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
            });
          },
          addEdit:function(type){
            if(type) this.selectRowIndex(this.checkIndex,true);
            else this.$refs.editContractRef.open();
          },
          selectRowIndex:function(index,type){
            this.checkIndex = index;
            let data = null;
            if(type){
             if(this.checkIndex != -1){
               data = this.data[this.checkIndex];
               this.$refs.editContractRef.open(data);
             }else{
               return this.alertMsg('请选择需要修改的信息','error')
             }
            }
          },
          addNotify:function(e){
            if(e.is_up) this.$set( this.data, this.checkIndex, e.data)
            else{
              this.data.unshift(e.data)
              this.checkIndex = 0;
            }
            this.$refs.editContractRef.close();
          }
        }
    }
</script>
