<template>
<div>
    <Modal v-model="modal" title="选择冷藏运输发货项" :mask-closable="false" width="1000" footer-hide>
        <Table size="small" stripe :columns="columns" :row-class-name="rowClassName" :data="list" border class="table-m" :height="400" :loading="loading" :highlight-row="true" @on-row-click="(row,index)=>{selectRow(index,false)}" @on-row-dblclick="(row,index)=>{selectRow(index,true)}" @on-selection-change="onSelectionChange">

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
                      <FormItem label="商品编号:">

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
                {type: 'selection', width: 60, align: 'center',fixed:'left'},
                {title:'客户编号',key:'cust_no',width:100,align:'center',fixed:'left'},
                {title:'送货路线',key:'deliver_line',width:120,align:'center',resizable:true,ellipsis:true},
                {title:'送货地址',key:'pick_addr',width:120,align:'center',resizable:true,ellipsis:true},
                {title:'联系电话',key:'link_tel',width:120,align:'center'},
                {title:'业务员',key:'contacts',width:120,align:'center'},
                {title:'结算方式',key:'pay_mode_no',width:130,align:'center'},
                {title:'销售单号',key:'orderid',width:150,resizable:true,ellipsis:true},
                {title:'销售项次',key:'item_no',width:90,align:'center',resizable:true,ellipsis:true},
                {title:'商品编号',key:'goods_code',width:120,align:'center'},
                {title:'数量',key:'qty',width:100,align:'center'},
                {title:'生产批号/序列号',key:'batch_no',width:180,resizable:true,ellipsis:true},
                {title:'有效期至',key:'valid_date',width:150,resizable:true,ellipsis:true},
                {title:'客户名称',key:'cust_name',width:180,resizable:true,ellipsis:true},
                {title:'客户采购人员',key:'link_man',width:120,align:'center'},
                {title:'商品名称',key:'goods_name',width:180,resizable:true,ellipsis:true},
                {title:'规格',key:'specs',width:120,align:'center'},
                {title:'生产企业',key:'production',width:180,resizable:true,ellipsis:true},
                {title:'批准文号/注册证号',key:'approval_code',width:200,resizable:true,ellipsis:true},
                {title:'产地',key:'origin',width:150}
              ],
              list:[],
              loading:false,
              serData:JSON.parse(JSON.stringify(serData)),
              delivery_data:null,
              checkIndex:-1,
              YorderIds:[],
              selectionData:[],
              dtlId:[]
          }
        },
        methods:{
            init:function(){
              let _this=this;
              _this.loading=true;
              _this.common.http({url:'s/chooseColdTransItem',data:{ser_param:this.serData,y_order:this.YorderIds}}).then(function(res){
                _this.loading=false;
                if(res.status==1){
                  _this.list=res.data;
                 // _this.delivery_data=res.delivery_data;
                  if(res.list.length > 0)_this.checkIndex = 0;
                }
              }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
              });
            },
            onSelectionChange:function(e){
              this.selectionData = e;
            },
            open:function(orderids,dtlId){
              this.YorderIds = orderids;
              this.dtlId = dtlId;
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
              if(typeof(this.list[index]) != 'undefined'){
                let val = this.list[index].id;
                if(this.dtlId.indexOf(val) != -1){
                  this.list.splice(index, 1);
                }
              }
             // this.$set(this.list[index],'_checked',true)
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
              if(this.selectionData.length<0){
                return this.alertMsg('请选择数据','error');
              }
              this.$emit("confirmItem",this.selectionData);
              this.close();
            }
        }
    }
</script>
<style lang="less">

</style>
