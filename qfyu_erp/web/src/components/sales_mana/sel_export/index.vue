<template>
  <div>
    <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="addEdit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="addEdit(1)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Divider type="vertical"/>
          <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button><span class="icon iconfont">&#xe691;</span>筛选</Button>
        </div>
      </div>
      <div slot="table-list">
        <Table ref="contractListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height" :loading="loadding"
          @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
          @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
          <template slot-scope="{row}" slot="pay_mode_no">
            {{settlement[row.pay_mode_no]}}
          </template>
          <template slot-scope="{row}" slot="creater">
            {{$store.state.emp[row.creater]}}
          </template>
          <template slot-scope="{row}" slot="audit">
            {{$store.state.emp[row.audit]}}
          </template>
          <template slot-scope="{row}" slot="dept_id">
            {{$store.state.depart[row.dept_id]}}
          </template>
          <template slot-scope="{row}" slot="is_transfer">
            <Checkbox :value="row.is_transfer" :true-value="1" :false-value="0" disabled></Checkbox>
          </template>
        </Table>
      </div>
    </split-none>
  </div>
</template>
<script>
    import splitNone from '@/components/public/splitNone'
    export default {
      name:'sel_export',
        components:{splitNone},
        data(){
          return {
             height:0,
             Breadcrumb:[{title:'销售管理'},{title:'销售开单'}],
             columns:[
              {title:'单据编号',key:'orderid',width:160,fixed:'left',align:'center'},
              {title:'报价日期',key:'f_date',width:100,align:'center'},
              {title:'有效期至',key:'valid_date',width:100,align:'center'},
              {title:'审核人',slot:'audit',width:100,align:'center'},
              {title:'业务员',key:'emp_name',width:100,align:'center'},
              {title:'客户采购人员',key:'link_man',width:120,align:'center'},
              {title:'客户编号',key:'cust_no',width:120,align:'center'},
              {title:'客户名称',key:'cust_name',resizable:true,width:180,align:'center'},
              {title:'无税金额',key:'goods_sum',resizable:true,width:120,align:'center'},
              {title:'税款',key:'tax_sum',width:120,resizable:true,ellipsis:true,align:'center'},
              {title:'合计',key:'amount',width:150,resizable:true,align:'center'},
              {title:'货品总数',key:'goods_qty',width:100,resizable:true,align:'center'},
              {title:'创建者',key:'creater',width:100,align:'center'},
              {title:'创建人姓名',slot:'creater',width:100,align:'center'},
              {title:'创建日期',key:'create_date',width:140,align:'center'},
              {title:'备注',key:'remark',width:100,resizable:true,ellipsis:true,align:'center'},
              {title:'结算方式',slot:'pay_mode_no',width:100,resizable:true,align:'center'},
              {title:'开单部门',slot:'dept_id',width:100,resizable:true,align:'center'},
              {title:'已过账',slot:'is_transfer',width:60,resizable:false,align:'center',fixed:"right"}
             ],
             data:[],
             settlement:this.$store.state.settlement,
             loadding:false,
             checkIndex:0
          }
        },
        created:function(){
          this.init();
        },
        methods:{
          rowClassName(row,index){
            if (index === this.checkIndex) {
                return 'ivu-table-row-highlight';
            }
            return '';
          },
          DHeight(e){
            this.height = e;
          },
          init:function(){
            let _this = this;
            this.loadding = true;
            this.common.http({url:'s/selExportList',data:{}}).then(function(res){
              if(res.status==1){
                _this.data = res.data;
              }
              _this.$nextTick(function(){
                _this.loadding = false;
              })
            }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
            });
          },
          selectRowIndex:function(index,type){
            this.checkIndex = index;
            if(type) this.addEdit(1);
          },
          addEdit:function(type){
            if(!type){
              localStorage.removeItem('sel_export_orderid');
              this.toUrl('/sel_export_edit');
            }else {
              if(this.checkIndex != -1){
                localStorage.setItem('sel_export_orderid',this.data[this.checkIndex].orderid)
                this.toUrl('/sel_export_edit');
              }
              else this.alertMsg('请选择需要修改的信息','error')
            }
          }
        }
    }
</script>
