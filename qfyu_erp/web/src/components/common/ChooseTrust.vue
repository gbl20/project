<template>
<div>
    <Modal v-model="modal" title="选择委托物流单位" :mask-closable="false" width="1000" footer-hide>
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
                      <FormItem label="公司名称">
                         <Input type="text" v-model="serData.company" :maxlength="18" placeholder="公司名称" ></Input>
                      </FormItem>
                    </Col>
                    <Col :span="8">
                      <FormItem label="联系人">
                         <Input type="text" v-model="serData.contact" :maxlength="18" placeholder="联系人" ></Input>
                      </FormItem>
                    </Col>
                    <Col :span="8">
                      <FormItem label="联系人电话">
                         <Input type="text" v-model="serData.phone" :maxlength="18" placeholder="联系人电话" ></Input>
                      </FormItem>
                    </Col>
                  </Row>
                  <Row>
                    <Col :span="16">
                      <FormItem label="运输方式">
                        <Select v-model="serData.ship_type" clearable>
                          <Option v-for="(item,index) in $store.state.sysParam['ship_type']" :key="index" :value="item" >{{item}}</Option>
                        </Select>
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
</div>
</template>
<script>
  var serData = {orderid:'',start_f_date:null,end_f_date:null,deliver_line:null,cust_no:''};
    export default {
        data(){
          return {
            modal:false,
            columns:[
              {title:'编号',key:'id',width:160,fixed:'left',align:'center'},
              {title:'公司名称',key:'company',width:160,fixed:'left'},
              {title:'公司地址',key:'addr',minWidth:200},
              {title:'联系人',key:'contact',minWidth:200},
              {title:'联系人身份证号',key:'card_id',width:120,align:'center'},
              {title:'联系人手机',key:'phone',width:120,align:'center'},
              {title:'联系人电话',key:'tel',width:150,align:'center'},
              {title:'营业执照编号',key:'business_license',minWidth:180},
              {title:'营业执照有效期',key:'business_validity_date',width:120,align:'center'},
              {title:'合同有效期',key:'contract_validity_date',width:120,align:'center'},
              {title:'运输方式',key:'ship_type',width:150,align:'center'},
              {title:'承运范围',key:'scope_carriage',width:200,align:'center'}
            ],
            list:[],
            loading:false,
            serData:JSON.parse(JSON.stringify(serData)),
            checkIndex:-1
          }
        },
        methods:{
            init:function(){
                let _this=this;
                _this.loading=true;
                _this.common.http({url:'chooseTrust',data:{ser_param:this.serData}}).then(function(res){
                    _this.loading=false;
                    if(res.status==1){
                        _this.list = res.data;
                        if(res.list.length > 0) _this.checkIndex = 0;
                    }
                }).catch(function(err){
                     _this.common.httpErr(err.data,_this);
                });
            },
            open:function(orderids){
              this.init();
              this.modal=true;
            },
            close:function(){
               this.modal=false;
            },
            cancelSer:function(){
              this.serData = JSON.parse(JSON.stringify(serData));
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
            confirm:function(){
              if(this.checkIndex<0){
                return this.alertMsg('请选择订单','error');
              }
              this.$emit("confirm",this.list[this.checkIndex]);
              this.close();
            }
        }
    }
</script>
<style lang="less">

</style>
