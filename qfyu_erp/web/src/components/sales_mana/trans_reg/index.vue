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
            <template slot-scope="{row,index}" slot="emp_no">
              {{$store.state.emp[row.emp_no]}}
            </template>
            <template slot-scope="{row,index}" slot="audit_no">
              {{$store.state.emp[row.audit_no]}}
            </template>
            <template slot-scope="{row,index}" slot="delivery_boy">
              {{$store.state.emp[row.delivery_boy]}}
            </template>
            <template slot-scope="{row,index}" slot="shipper">
              {{$store.state.emp[row.shipper]}}
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
      name:'trans_reg',
        components:{splitNone},
        data(){
          return {
             height:0,
             Breadcrumb:[{title:'销售发货运输'},{title:'销售发货运输登记查询'}],
             columns:[
              {title:'单据编号',key:'orderid',width:160,fixed:'left',align:'center'},
              {title:'日期',key:'f_date',width:100,align:'center'},
              {title:'合计金额',key:'amount',width:100,align:'center'},
              {title:'经手人',slot:'emp_no',width:100,align:'center'},
              {title:'复核员',slot:'audit_no',width:120,align:'center'},
              {title:'过账',slot:'is_transfer',width:120,align:'center'},
              {title:'运输方式',key:'ship_type',resizable:true,width:180,align:'center'},
              {title:'送货司机',key:'driver',resizable:true,width:120,align:'center'},
              {title:'车牌号',key:'car_sum',width:120,resizable:true,align:'center'},
              {title:'货物件数',key:'pack_num',width:150,resizable:true,align:'center'},
              {title:'送货员',slot:'delivery_boy',width:100,resizable:true,align:'center'},
              {title:'发货员',slot:'shipper',width:100,align:'center'},
              {title:'备注',key:'remark',width:100,align:'center'},
              {title:'委托物流单位名称',key:'logistics_unit',width:100,resizable:true,align:'center'},
              {title:'发货方式',key:'deliver_kind',width:100,resizable:true,align:'center'},
              {title:'物流单号',key:'wl_num',width:100,resizable:true,align:'center'}
             ],
             data:[],
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
            this.common.http({url:'s/transRegList',data:{}}).then(function(res){
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
              localStorage.removeItem('trans_reg_orderid');
              this.toUrl('/trans_reg_edit');
            }else {
              if(this.checkIndex != -1){
                localStorage.setItem('trans_reg_orderid',this.data[this.checkIndex].orderid)
                this.toUrl('/trans_reg_edit');
              }
              else this.alertMsg('请选择需要修改的信息','error')
            }
          }
        }
    }
</script>
