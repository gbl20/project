<template>
	<div>
    <Row>
      <Col span="22">
        <Table highlight-row border size="small" :columns="columns" :data="data" :height="height" @on-row-click="selRow"></Table>
      </Col>
      <Col span="2">
        <div class="active">
          <Button @click="add"><span class="icon iconfont">&#xe792;</span>新增</Button>
          <Button @click="edit"><span class="icon iconfont">&#xe793;</span>修改</Button>
          <Button @click="del"><span class="icon iconfont">&#xe793;</span>删除</Button>
        </div>
      </Col>
    </Row>
    <sel-customer ref="selCustomer" @emptyData="emptyData" @confirm="SucConfirm"></sel-customer>
    <Modal title="修改商品销售限制" v-model="modal">
      <Form :model="formData" :label-width="80">
        <FormItem label="商品编号">
          <Input v-model="formData.goods_code" disabled></Input>
        </FormItem>
        <FormItem label="客户编号">
          <Input v-model="formData.cust_id" disabled></Input>
        </FormItem>
        <FormItem label="客户名称">
          <Input v-model="formData.sname" disabled></Input>
        </FormItem>
        <FormItem label="客户全称">
          <Input v-model="formData.cust_name" disabled></Input>
        </FormItem>
        <FormItem label="客户地址">
          <Input v-model="formData.comarea" disabled></Input>
        </FormItem>
        <FormItem label="从事行业">
          <Input v-model="formData.typebus" disabled></Input>
        </FormItem>
        <FormItem label="限制最低价">
          <InputNumber :active-change="false" :max="9999999999" :min="0" :precision="6" v-model="formData.limit_price"></InputNumber>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="confirm(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="confirm(false)" icon="md-close">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  import selCustomer from "@/components/data_mana/goods_base/selCustomer"
	export default {
		name: "sellLimit",
    props:{
      height:0
    },
    components:{
      selCustomer
    },
    data(){
		  return{
        modal:false,
		    goods_code:null,
        formData:{goods_code:this.goods_code},
        Index:-1,
		    columns:[
          {title:'客户编号',key:'cust_id',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'客户名称',key:'sname',width:180,minWidth:180,resizable:true,ellipsis:true},
          {title:'客户全称',key:'cust_name',width:230,minWidth:230,resizable:true,ellipsis:true},
          {title:'客户地址',key:'comarea',width:300,minWidth:300,resizable:true,ellipsis:true},
          {title:'从事行业',key:'typebus',width:140,minWidth:140,resizable:true,ellipsis:true},
          {title:'限定最低售价',key:'limit_price',width:140,minWidth:140,resizable:true,ellipsis:true,align:'right'}
        ],
        data:[]
      }
    },
    methods:{
		  init:function (code) {
		    var _this=this;
        if(code) this.goods_code = code;
        this.common.http({
          url:'getSellLimitList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        });
      },
      confirm:function(status){
		    var _this=this;
		    if(!status) return this.modal = false;
		    this.common.http({
          url:'editCustomerLimit',
          data:{data:this.formData}
        }).then(function (res) {
          if (res.status){
            _this.modal = false;
            _this.init(_this.goods_code);
          }else{
            _this.modalMsg(res.msg)
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      add:function(){
        this.$refs.selCustomer.open(this.goods_code);
      },
      SucConfirm:function(status){
		    if(status) this.init(this.goods_code);
      },
      emptyData:function(msg){
        this.modalMsg(msg);
      },
      selRow:function(item,index){
		    this.Index = index;
      },
      edit:function(){
        if(this.Index==-1) return false;
        this.formData = JSON.parse(JSON.stringify(this.data[this.Index]));
        this.formData.limit_price = this.formatFloat(this.formData.limit_price,6)
        this.modal = true;
      },
      del:function () {
		    var _this=this;
        if(this.Index==-1) return false;
        this.$Modal.confirm({
          title:'提示信息',
          content:'确定要删除当前销售限制记录吗？',
          onOk:function () {
            _this.common.http({
              url:'delCustomerLimit',
              data:{data:_this.data[_this.Index]}
            }).then(function (res) {
              if(res.status) _this.init(_this.goods_code)
              else _this.modalMsg(res.msg);
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            });
          }
        })

      }
    }
	}
</script>

<style lang="less">

</style>
