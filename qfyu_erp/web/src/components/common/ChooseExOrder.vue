<template>
<div>
    <Modal v-model="modal" title="选择待送货的销售单" :mask-closable="false" width="1000" footer-hide>
        <Table size="small" stripe :columns="columns" :row-class-name="rowClassName" :data="list" border class="table-m" :height="400" :loading="loading" :highlight-row="true" @on-row-click="(row,index)=>{selectRow(index,false)}" @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
        </Table>
        <Divider/>
        <Form ref="formCustom" :label-width="80">
          <Row>
            <Col :span="21">
              <Row>
                <Col span="20">
                  <Row>
                    <Col :span="8">
                      <FormItem label="单据编号">
                         <Input type="text" v-model="serData.orderid" :maxlength="18" placeholder="单据编号" ></Input>
                      </FormItem>
                    </Col>
                    <Col :span="16">
                     <FormItem label="单据日期">
                       <Row>
                         <Col :span="12">
                            <DatePicker type="date" :editable="false" placeholder="开始时间" v-model="serData.start_f_date"></DatePicker>
                         </Col>
                         <Col :span="12">
                            <DatePicker type="date" :editable="false" placeholder="结束时间" v-model="serData.end_f_date"></DatePicker>
                         </Col>
                       </Row>
                     </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col :span="16">
                      <FormItem label="送货线路:">
                        <Select v-model="serData.deliver_line" clearable>
                           <Option v-for="(item,index) in delivery_data" :key="index" :value="item.id">{{item.dname}}</Option>
                        </Select>
                      </FormItem>
                    </Col>
                    <Col :span="8">
                      <FormItem label="客户:">
                        <Input icon="ios-more" clearable v-model="serData.cust_no" readonly style="cursor:pointer;" @on-click="clickSelCustmoer"></Input>
                      </FormItem>
                    </Col>
                  </Row>
                </Col>
                <Col :span="4">
                  <FormItem :label-width="30">
                    <Button type="info" @click="init"><span class="icon iconfont">&#xe691;</span>搜索</Button>
                  </FormItem>
                  <FormItem :label-width="30">
                    <Button type="dashed" @click="cancelSer"><span class="icon iconfont">&#xe693;</span>清除</Button>
                  </FormItem>
                 
                </Col>
              </Row>
            </Col>
            <Col :span="3">
              <FormItem :label-width="50">
                <Button type="primary" @click="confirm"><span class="icon iconfont">&#xe7fe;</span>选定</Button>
              </FormItem>
              <FormItem :label-width="50">
                <Button type="error" @click="modal=false"><span class="icon iconfont">&#xe7fd;</span>关闭</Button>
              </FormItem>
            </Col>
          </Row>
        </Form>
    </Modal>
    <select-customer ref="chooseCustomerRef" @selcust="confirmCustomer"></select-customer>
</div>
</template>
<script>
   import selectCustomer from '@/components/common/SelectCustomer'
  var serData = {orderid:'',start_f_date:null,end_f_date:null,deliver_line:null,cust_no:''};
    export default {
       components:{selectCustomer},
        data(){
          return {
              modal:false,
              columns:[
                {title:'单据日期',key:'create_date',width:160,fixed:'left',align:'center'},
                {title:'单据编号',key:'orderid',width:160,fixed:'left',resizable:true,ellipsis:true},
                {title:'客户编号',key:'cust_no',width:200,resizable:true,ellipsis:true},
                {title:'客户名称',key:'cust_name',width:200,resizable:true,ellipsis:true},
                {title:'送货路线',key:'deliver_line',width:120,align:'center',resizable:true,ellipsis:true},
                {title:'送货地址',key:'pick_addr',width:120,align:'center',resizable:true,ellipsis:true},
                {title:'客户采购人员',key:'link_man',width:150,align:'center',resizable:true,ellipsis:true},
                {title:'送货顺序号',key:'deliorder',width:200,resizable:true,ellipsis:true},
                {title:'无税金额',key:'goods_sum',width:100,align:'center',resizable:true,ellipsis:true},
                {title:'合计金额',key:'amount',width:120,align:'center',resizable:true,ellipsis:true},
                {title:'税额',key:'tax_sum',width:100,align:'center',resizable:true,ellipsis:true},
                {title:'联系电话',key:'link_tel',width:120,align:'center',resizable:true,ellipsis:true},
                {title:'客户地区',key:'area',width:200,resizable:true,ellipsis:true},
                {title:'业务员',key:'emp_no',width:120},
                {title:'发货方式',key:'deliver_kind',width:150},
              ],
              list:[],
              loading:false,
              serData:JSON.parse(JSON.stringify(serData)),
              delivery_data:null,
              checkIndex:-1,
              YorderIds:[]
          }
        },
        methods:{
            init:function(){
                let _this=this;
                _this.loading=true;
                _this.common.http({url:'s/chooseExOrder',data:{ser_param:this.serData,y_order:this.YorderIds}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list=res.list;
                        _this.delivery_data=res.delivery_data;
                        if(res.list.length > 0) _this.checkIndex = 0;
                    }
                }).catch(function(err){
                     _this.common.httpErr(err.data,_this);
                });
            },
            open:function(orderids){
              this.YorderIds = orderids;
              this.init();
              this.modal=true;
            },
            close:function(){
               this.modal=false;
            },
            selectRow:function(index,type){
                this.checkIndex=index;
                if(type) this.confirm();
            },
            rowClassName(row,index){
              if (index === this.checkIndex) {
                  return 'ivu-table-row-highlight';
              }
              return '';
            },
            cancelSer:function(){
              this.serData = JSON.parse(JSON.stringify(serData));
            },
            clickSelCustmoer:function(){
              this.$refs.chooseCustomerRef.init();
            },
            confirmCustomer:function(e){
              this.serData.cust_no = e.id;
            },
            confirm:function(){
              if(this.checkIndex<0){
                return this.alertMsg('请选择订单','error');
              }
              this.$emit("confirmOrder",this.list[this.checkIndex]);
              this.close();
            }
        }
    }
</script>
<style lang="less">

</style>
