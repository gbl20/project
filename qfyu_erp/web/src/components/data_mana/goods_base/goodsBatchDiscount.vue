<template>
	<div>
    <Row>
      <Col span="22">
        <Table highlight-row border size="small" :columns="columns" :data="data" :height="height" @on-row-click="changeRow">
          <template slot-scope="{row}" slot="retail_status">
            <span>{{row.retail_status==1?'有效':'无效'}}</span>
          </template>
        </Table>
      </Col>
      <Col span="2">
        <div class="active">
          <Button @click="openModal(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="openModal(false)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="del"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </div>
      </Col>
    </Row>
    <Modal v-model="modal" title="商品批量折扣">
      <Form :model="formData" :label-width="70">
        <FormItem label="商品编号">
          <Input disabled v-model="formData.goods_code"></Input>
        </FormItem>
        <FormItem label="商品名称">
          <Input disabled v-model="formData.goods_name"></Input>
        </FormItem>
        <FormItem label="最小批量">
          <InputNumber :active-change="false" :max="99999" :min="0" v-model="formData.min_qty" style="width: 200px;"></InputNumber>
        </FormItem>
        <FormItem label="最大批量">
          <InputNumber :active-change="false" :max="99999" :min="-1" v-model="formData.max_qty" style="width: 200px;"></InputNumber>
          <span class="error-text">-1：表示无上限</span>
        </FormItem>
        <FormItem label="商品单位">
          <Select v-model="formData.unit" style="width: 200px;">
            <Option v-for="(item,index) in unitItem" :value="item" :key="index">{{item}}</Option>
          </Select>
        </FormItem>
        <FormItem label="折扣%">
          <InputNumber :active-change="false" :max="100" :min="0" v-model="formData.discount" style="width: 200px;"></InputNumber>
        </FormItem>
        <FormItem>
          <Checkbox :true-value="1" :false-value="0" v-model="formData.retail_status">同时应用于零售</Checkbox>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="add(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="add(false)" icon="md-close">确定</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  var fData = {
        goods_code:'',goods_name:'',min_qty:null,max_qty:null,unit:'',discount:null,retail_status:0
      }
	export default {
		name: "goodsBatchDiscount",
    props:{
		  height:0
    },
    data(){
		  return{
        modal:false,
		    goods_code:null,
		    goods_name:'',
        formData:fData,
		    columns:[
          {title:'商品编号',key:'goods_code'},
          {title:'批量下限',key:'min_qty'},
          {title:'批量上限',key:'max_qty'},
          {title:'单位',key:'unit'},
          {title:'折扣%',key:'discount'},
          {title:'零售有效',slot:'retail_status'},
        ],
        data:[],
        unitItem:[],
        Index:-1
      }
    },
    methods:{
		  init:function (code) {
        var _this = this;
		    if (code) this.goods_code = code;
        this.common.http({
          url:'getGoodsBatchList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status) {
            _this.data = res.data;
            _this.goods_name = res.goods_name;
            _this.unitItem = res.unitItem;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      openModal:function(status){
		    if (status){
		      this.formData = JSON.parse(JSON.stringify(fData))
          this.formData.goods_code = this.goods_code;
        }else{
		      if (this.Index==-1) return this.alertMsg('请选择一项商品批量折扣！','error');
		      this.formData = JSON.parse(JSON.stringify(this.data[this.Index]));
        }
        this.formData.goods_name = this.goods_name;
        this.modal = true;
      },
      add:function(status){
		    var _this=this;
        if (!status) return this.modal=false;
        if (!this.formData.goods_code) return this.alertMsg('请选择一项商品再试！','error');
        if (!this.formData.min_qty) return this.alertMsg('请输入最小批量！','error');
        if (!this.formData.max_qty) return this.alertMsg('请输入最大批量！','error');
        if (this.formData.max_qty!=-1 && this.formData.min_qty > this.formData.max_qty) return this.alertMsg('最小批量不能大于最大批量！','error');
        if (!this.formData.unit) return this.alertMsg('请选择商品单位！','error');
        if (!this.formData.discount) return this.alertMsg('请输入折扣！','error');
        this.common.http({
          url:'editGoodsBatch',
          data:{data:this.formData}
        }).then(function (res) {
          if (res.status){
            _this.modal = false;
            _this.init(_this.goods_code);
          }else{
            _this.alertMsg(res.msg,'error');
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      del:function(){
		    var _this=this,datas = {data:this.data[this.Index]};
        if (this.Index==-1) return this.alertMsg('请选择一项商品批量折扣！','error');
        this.$Modal.confirm({
          title:'提示',
          content:'确定要删除该批量折扣吗？',
          onOk:function () {
            _this.common.http({
              url:'delGoodsBatch',
              data:datas
            }).then(function (res) {
              if (res.status){
                _this.init(_this.goods_code);
              }else{
                _this.alertMsg(res.msg,'error');
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      changeRow:function (item,index) {
        this.Index = index;
      }
    }
	}
</script>

<style lang="less">

</style>
