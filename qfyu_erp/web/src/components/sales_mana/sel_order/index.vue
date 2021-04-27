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
          <Button @click="serM = true"><span class="icon iconfont">&#xe691;</span>筛选</Button>
        </div>
        <Drawer width="320" title="筛选条件" :closable="false" :mask-closable="false" v-model="serM">
            <div class="ser-form">
              <Form ref="formCustom" :label-width="80">
                <FormItem label="单据编号">
                   <Input type="text" v-model="serData.orderid" :maxlength="18" placeholder="单据编号" ></Input>
                </FormItem>
                <FormItem label="合同编号">
                   <Input icon="ios-more" clearable v-model="serData.contract_no" readonly style="cursor:pointer;" @on-click="clickContract"></Input>
                </FormItem>
                <FormItem label="订单日期">
                   <DatePicker type="date" :editable="false" placeholder="开始时间" v-model="serData.start_f_date"></DatePicker>
                   <DatePicker type="date" :editable="false" placeholder="结束时间" v-model="serData.end_f_date"></DatePicker>
                </FormItem>
                <FormItem label="手机号">
                   <Input type="text" v-model="serData.phone" :maxlength="11" placeholder="手机号"></Input>
                </FormItem>
                <FormItem label="开单部门:" prop="depart">
                  <Input readonly v-model="serData.depart" icon="ios-more" clearable style="cursor: pointer;" @on-click="show_seldep"></Input>
                </FormItem>
                <FormItem label="结案标志:">
                  <Select v-model="serData.is_finish" clearable>
                     <Option :value='1'>已结案</Option>
                     <Option :value='0'>未结案</Option>
                  </Select>
                </FormItem>
                <FormItem label="转单标志:">
                  <Select v-model="serData.is_pass_on" clearable>
                     <Option :value='1'>已转单</Option>
                     <Option :value='0'>未转单</Option>
                  </Select>
                </FormItem>
                <FormItem label="是否复核:">
                  <Select v-model="serData.is_transfer" clearable>
                     <Option :value='1'>已复核</Option>
                     <Option :value='0'>未复核</Option>
                  </Select>
                </FormItem>
                <FormItem label="结算方式:">
                  <Select v-model="serData.pay_mode_no" clearable>
                   <Option v-for="(item,key) in $store.state.settlement" :value="key" :key="key">{{item}} ( {{key}} )</Option>
                  </Select>
                </FormItem>
                <FormItem label="客户:">
                  <Input icon="ios-more" clearable v-model="serData.cust_no" readonly style="cursor:pointer;" @on-click="clickSelCustmoer"></Input>
                </FormItem>
                <FormItem label="开单人">
                  <Input icon="ios-more" clearable v-model="serData.creater" readonly style="cursor:pointer;"  @on-click="chooseEmp('creater')"></Input>
                </FormItem>
                <FormItem label="复核员">
                  <Input icon="ios-more" clearable v-model="serData.audit" readonly style="cursor:pointer;"  @on-click="chooseEmp('audit')"></Input>
                </FormItem>
                <Divider/>
                <FormItem :label-width="0">
                  <Button type="dashed" @click="cancelSer"><span class="icon iconfont">&#xe693;</span>清除条件</Button>
                  <Divider type="vertical" />
                  <Button type="warning" @click="serM = false"><span class="icon iconfont">&#xe793;</span>关闭</Button>
                  <Divider type="vertical" />
                  <Button type="primary" @click="serSub"><span class="icon iconfont">&#xe691;</span>搜索</Button>
                </FormItem>
              </Form>
            </div>
        </Drawer>
      </div>
      <div slot="table-list">
        <Table ref="contractListRef" size="small" stripe :row-class-name="rowClassName" :columns="columns" :data="data" border class="table-m" :height="height-40" :loading="loadding"
          @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
          @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">
          <template slot-scope="{row}" slot="pay_mode_no">
            {{$store.state.settlement[row.pay_mode_no]}}
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
          <template slot-scope="{row}" slot="is_finish">
            <Checkbox :value="row.is_finish" :true-value="1" :false-value="0" disabled></Checkbox>
          </template>
          <template slot-scope="{row}" slot="is_pass_on">
            <Checkbox :value="row.is_pass_on" :true-value="1" :false-value="0" disabled></Checkbox>
          </template>
        </Table>
        <div class="page-m">
          <Page :total="total" :page-size="pageSize" size="small" show-total show-elevator :page-size-opts="[20,50,80]" show-sizer @on-change="ChangePage" @on-page-size-change="ChangePageSize"/>
        </div>
      </div>
    </split-none>
    <select-customer ref="chooseCustomerRef" @selcust="confirmCustomer"></select-customer>
    <select-employee ref="chooseEmployeeRef" @selemp="confirmEmployee"></select-employee>
    <choose-sales-contract ref="SalesContractRef" @conData="conContract"></choose-sales-contract>
    <select-depart ref="seldep" @seldep="select_dep"></select-depart>
  </div>
</template>
<script>
    import splitNone from '@/components/public/splitNone'
    import chooseSalesContract from '@/components/common/ChooseSalesContract'
    import selectEmployee from '@/components/common/SelectEmployee'
    import selectCustomer from '@/components/common/SelectCustomer'
    import selectDepart from '@/components/common/SelectDepart'
    var serData = {orderid:null,contract_no:null,start_f_date:null,end_f_date:null,phone:null,depart:null,is_finish:null,is_pass_on:null,is_transfer:null,pay_mode_no:null,cust_no:null,creater:null,audit:null};
    export default {
      name:'sel_order',
        components:{splitNone,chooseSalesContract,selectEmployee,selectCustomer,selectDepart},
        data(){
          return {
             serM:false,
             height:0,
             Breadcrumb:[{title:'销售管理'},{title:'销售订单'}],
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
              {title:'税款',key:'tax_sum',width:120,resizable:true,align:'center'},
              {title:'合计',key:'amount',width:150,resizable:true,align:'center'},
              {title:'货品总数',key:'goods_qty',width:100,resizable:true,align:'center'},
              {title:'创建者',key:'creater',width:100,align:'center'},
              {title:'创建人姓名',slot:'creater',width:100,align:'center'},
              {title:'创建日期',key:'create_date',width:140,align:'center'},
              {title:'备注',key:'remark',width:100,resizable:true,align:'center'},
              {title:'结算方式',slot:'pay_mode_no',width:100,resizable:true,align:'center'},
              {title:'开单部门',slot:'dept_id',width:100,resizable:true,align:'center'},
              {title:'已过账',slot:'is_transfer',width:60,resizable:false,align:'center',fixed:"right"},
              {title:'已转单',slot:'is_pass_on',width:60,resizable:false,align:'center',fixed:"right"},
              {title:'已结案',slot:'is_finish',width:60,resizable:false,align:'center',fixed:"right"}
             ],
             data:[],
             loadding:false,
             checkIndex:0,
             total:0,
             pageSize:20,
             page:1,
             serData:JSON.parse(JSON.stringify(serData)),
             empKey:null
          }
        },
        created:function(){
          this.init();
        },
        methods:{
          rowClassName(row,index){
            let ClassName = '';
            if (index === this.checkIndex) {
              ClassName += 'ivu-table-row-highlight';
            }
            
            return ClassName;
          },
          DHeight(e){
            this.height = e;
          },
          ChangePage:function(e){
            this.page = e;
            this.init();
          },
          ChangePageSize:function(e){
            this.pageSize = e;
            this.page = 1;
            this.init();
          },
          init:function(){
            let _this = this;
            this.loadding = true;
            this.serM = false;
            this.common.http({url:'s/selOrderList',data:{page:this.page,page_size:this.pageSize,ser_data:this.serData}}).then(function(res){
              if(res.status==1){
                _this.data = res.data.data;
                _this.total = res.data.total;
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
              localStorage.removeItem('sel_order_orderid');
              this.toUrl('/sel_order_edit');
            }else {
              if(this.checkIndex != -1){
                localStorage.setItem('sel_order_orderid',this.data[this.checkIndex].orderid)
                this.toUrl('/sel_order_edit');
              }
              else this.alertMsg('请选择需要修改的信息','error')
            }
          },
          serSub:function(){
            this.page = 1;
            this.init();
          },
          cancelSer:function(){
            this.serData = JSON.parse(JSON.stringify(serData))
          },
          confirmCustomer:function(e){
            this.serData.cust_no = e.id;
          },
          conContract:function(e){
            this.serData.contract_no = e.contract_no;
          },
          confirmEmployee:function(e){
            this.serData[this.empKey] = e.code;
          },
          chooseEmp:function(empKey){
            this.empKey = empKey;
            this.$refs.chooseEmployeeRef.init();
          },
          clickContract:function(){
            this.$refs.SalesContractRef.open();
          },
          show_seldep:function(){
            this.$refs.seldep.init();
          },
          select_dep:function(e){
            this.serData.depart = e.id;
          },
          clickSelCustmoer:function(){
            this.$refs.chooseCustomerRef.init();
          }
        }
    }
</script>
