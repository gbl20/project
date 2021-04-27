<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button><span class="icon iconfont">&#xe792;</span>保存</Button>
          <Divider type="vertical"/>
          <Button><span class="icon iconfont">&#xe692;</span>审核</Button>
          <Button><span class="icon iconfont">&#xe6a2;</span>还原</Button>
          <Divider type="vertical"/>
          <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe691;</span>查询</Button>
          <Button><span class="icon iconfont">&#xe7d8;</span>打印</Button>
          <Button><span class="icon iconfont">&#xe68f;</span>返回</Button>
        </div>
        <Form :model="formData" :label-width="80" style="width: 1200px">
          <Row>
            <Col span="5">
              <FormItem label="拒收单号">
                <Input v-model="formData.orderid" disabled></Input>
              </FormItem>
              <FormItem label="日期">
                <DatePicker type="date" v-model="formData.orderid_date" disabled></DatePicker>
              </FormItem>
              <FormItem label="对应单号">
                <Input v-model="formData.come_orderid" disabled></Input>
              </FormItem>
              <FormItem label="进货地址">
                <Input v-model="formData.address"></Input>
              </FormItem>
            </Col>
            <Col span="8">
              <FormItem label="供应厂商">
                <Row>
                  <Col span="5">
                    <Input v-model="formData.supplier_code" disabled></Input>
                  </Col>
                  <Col span="1">&nbsp;</Col>
                  <Col span="18">
                    <Input v-model="formData.supplier_name" disabled></Input>
                  </Col>
                </Row>
              </FormItem>
              <Row>
                <Col span="12">
                  <FormItem label="供方销售员">
                    <Input v-model="formData.supplier_sale" disabled></Input>
                  </FormItem>
                  <FormItem label="联系人">
                    <Input v-model="formData.supplier_contact" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="供方部门">
                    <Input v-model="formData.supplier_depart" disabled></Input>
                  </FormItem>
                  <FormItem label="进货凭证">
                    <Input v-model="formData.invoice"></Input>
                  </FormItem>
                </Col>
              </Row>
              <FormItem label="备注">
                <Input v-model="formData.remark"></Input>
              </FormItem>
            </Col>
            <Col span="8">
              <Row>
                <Col span="12">
                  <FormItem label="运输方式">
                    <Input v-model="formData.transport_type"></Input>
                  </FormItem>
                  <FormItem label="运输到站">
                    <Input v-model="formData.car_addr"></Input>
                  </FormItem>
                  <FormItem label="创建人">
                    <Input v-model="formData.create_code" disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="业务员">
                    <Input v-model="formData.salesman"></Input>
                  </FormItem>
                  <FormItem label="复核员">
                    <Input v-model="formData.checker_code" disabled></Input>
                  </FormItem>
                  <FormItem label="创建时间">
                    <Input v-model="formData.create_date" disabled></Input>
                  </FormItem>
                </Col>
              </Row>
            </Col>
            <Col span="3">
              <FormItem label="状态">
                <div class="state " :class="formData.status==1?'success-bg-text':'warning-bg-text'">{{formData.status==1?'已审核':'未审核'}}</div>
              </FormItem>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="table-list">
        <Table border stripe highlight-row size="small" :columns="columns" :data="data" :height="height" @on-row-click="(item,index)=>{changeRow(item,index,true)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,false)}"></Table>
      </div>
    </split-none>
  </div>
</template>

<script>
  var _this;
  import splitNone from '@/components/public/splitNone'
  export default {
    components:{
      splitNone
    },
    data:function () {
      return{
        orderid:null,
        Breadcrumb:[{title:'采购管理'},{title:'来货拒收'}],
        height:0,
        formData:{},
        columns:[
          {title:'项次',type:'index',width:70,minWidth:70,resizable:true,ellipsis:true},
          {title:'商品编号',key:'goods_code',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'通用名称',key:'name',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'包装规格',key:'packspecs',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'单位',key:'unit',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'来货数量',key:'come_amount',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'金额',key:'money',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'拒收数量',key:'rejection_amount',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'拒收理由',key:'rejection_remark',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'供方产品编号',key:'supplier_goods_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'生产批号/序列号',key:'supplier_orderid',width:130,minWidth:130,resizable:true,ellipsis:true},
          {title:'有效期至',key:'transport_type',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'产地',key:'origin',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'生产企业',key:'production',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'检验标准',key:'check_type',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'批准文号/注册证号',key:'approval_code',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'业务部门负责人',key:'emp_code',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'业务部门负责人姓名',key:'emp_name',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'业务部门负责人意见',key:'emp_remark',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'质量管理部负责人',key:'qc_code',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'质量管理部负责人姓名',key:'qc_name',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'质量管理部负责人意见',key:'qc_remark',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'抽检数量',key:'check_amount',width:90,minWidth:90,resizable:true,ellipsis:true},
        ],
        data:[{goods_code:11}]
      }
    },
    activated() {
      this.orderid = localStorage.getItem("edit_ejection_orderid");
    },
    created() {
      this.init();
    },
    mounted() {
      _this=this;
    },
    watch:{
      orderid:function(e){
        if(this.orderid) this.orderid = e;
        this.init();
      }
    },
    methods:{
      init:function(){
        this.common.http({
          url:'getGoodsRejectionDtl',
          data:{orderid:this.orderid}
        }).then(function (res) {
          if (res.status){
            _this.formData = res.form;
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      dHeight:function (e) {
        this.height = e;
      }
    }
  }
</script>

<style lang="less">
  .state{text-align: center;font-size: 14px;}
</style>
