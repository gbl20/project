<template>
	<div>
    <Modal title="商品销售限制" v-model="modal">
        <Row>商品编号：{{goods_code}}</Row>
        <Row>商品名称：<span class="error-text">{{goods_name}}</span></Row>
      <Row class-name="border-b border-t" style="margin-top:10px;padding: 5px 0;"><span class="error-text">请在下边勾选可销售上述商品的客户。</span></Row>
        <Table ref="selection" size="small" border :columns="columns" :data="data" :height="400">
          <template slot-scope="row" slot="selection">
            <Checkbox v-model="data[row.index].selection"></Checkbox>
          </template>
          <template slot-scope="row" slot="limit_price">
            <InputNumber v-if="data[row.index].selection" :active-change="false" :max="9999999999" :min="0" :precision="6" v-model="data[row.index].limit_price"></InputNumber>
          </template>
        </Table>
      <div slot="footer">
        <Checkbox v-model="selAll" style="float: left;" @on-change="selectAll">全选</Checkbox>
        <Button @click="confirm(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="confirm(false)" icon="md-close">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
	export default {
		name: "selCustomer",
    data(){
		  return{
        modal:false,
        goods_code:null,
        goods_name:'',
        columns:[
          {title:'选择',slot:'selection',width:50,align:'center'},
          {title:'客户编号',key:'cust_id',width:90,minWidth:90},
          {title:'客户名称',key:'cust_name'},
          {title:'最低限价',slot:'limit_price'}
        ],
        data:[],
        selectAllData:[],
        selAll:false
      }
    },
    methods:{
      init:function() {
        var _this=this;
        this.common.http({
          url:'getCustomerLimit',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.goods_name = res.goods_name;
            _this.data = res.data;
            for(let i=0;i<_this.data.length;i++){
              _this.$set(_this.data[i],'selection',false);
              _this.$set(_this.data[i],'limit_price',null);
            }
            if(!_this.data.length) _this.$emit('emptyData','当前商品已添加了所有客户')
            else _this.modal = true;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      open:function (code) {
        this.goods_code = code;
        this.init();
      },
      confirm:function(type){
        if(!type) return this.modal=false;
        this.add();
      },
      getCheckData:function(){
        var data = [];
        for (let i=0;i<this.data.length;i++){
          this.data[i]['goods_code'] = this.goods_code;
          if(this.data[i]['selection'] == true){
            data.push(this.data[i]);
          }
        }
        return data;
      },
      selectAll:function (status) {
        for (let i=0;i<this.data.length;i++){
          this.data[i]['selection'] = status?true:false;
        }
      },
      add:function () {
        var _this=this;
        this.selectAllData = this.getCheckData();
        if(!this.selectAllData.length) return this.modalMsg('请选择客户，再试！');
        this.common.http({
          url:'addCustomerLimit',
          data:{data:this.selectAllData}
        }).then(function (res) {
          if (res.status) {
            _this.modal = false;
            _this.$emit('confirm',res.status)
          }else{
            _this.modalMsg(res.msg);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      }
    }
	}
</script>

<style lang="less">

</style>
