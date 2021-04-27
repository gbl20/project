<template>
	<div>
    <Row>
      <Col span="22">
        <Table highlight-row border size="small" :columns="columns" :data="data" :height="height" @on-row-click="changeRow"></Table>
      </Col>
      <Col span="2" :style="'height:'+height+'px'">
        <div class="active">
          <Button @click="openModal(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="del"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="openModal(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
        </div>
      </Col>
    </Row>
    <Modal title="商品控销类别" :mask-closable="false" v-model="modal">
      <Form ref="refFormData" :model="formData" :label-width="100">
        <FormItem label="控销类别">
          <Select v-model="formData.name" style="width: 200px">
            <Option value="中药饮片限购">中药饮片限购</Option>
            <Option value="特殊药品限购">特殊药品限购</Option>
          </Select>
        </FormItem>
        <FormItem label="限购数量">
          <InputNumber :active-change="false" :max="99999999999" :min="-1" v-model="formData.amount" style="width: 200px"></InputNumber>
        </FormItem>
        <FormItem>
          <span class="error-text">-1：不启用；0：禁购；其他：限购指定数值</span>
        </FormItem>
        <FormItem label="限购开始日期">
          <DatePicker type="date" :options="options" v-model="formData.start_date" style="width: 200px" placeholder="请选择限购开始日期"></DatePicker>
        </FormItem>
        <FormItem label="限购结束日期">
          <DatePicker type="date" :options="options2" v-model="formData.end_date" style="width: 200px" placeholder="请选择限购结束日期"></DatePicker>
        </FormItem>
        <FormItem label="备注信息">
          <Input v-model="formData.remark" maxlength="200"></Input>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="edit(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="edit(false)" icon="md-close">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  var formData = {goods_code:'',name:'',amount:-1,start_date:'',end_date:'',remark:''};
	export default {
    props:{
      height:0
    },
		data:function () {
      return{
        modal:false,
        goods_code:null,
        formData:formData,
        Index:-1,
        columns:[
          {title:'商品编号',key:'goods_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'控销类别',key:'name',width:180,minWidth:180,resizable:true,ellipsis:true},
          {title:'限购数量',key:'amount',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'限购开始日期',key:'start_date',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'限购结束日期',key:'end_date',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'备注信息',key:'remark',width:160,minWidth:160,resizable:true,ellipsis:true},
        ],
        data:[],
        options: {
          disabledDate (date) {
            return date && date.valueOf() < Date.now() - 86400000;
          }
        },
        options2:{
          disabledDate (date) {
            return date && date.valueOf() < Date.now();
          }
        },
      }
    },
    methods:{
      init:function(code){
        var _this=this;
        if(code) this.goods_code = code;
        this.common.http({
          url: 'getSalesCategoryList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      openModal:function (type) {
        if(!type) {
          this.formData = JSON.parse(JSON.stringify(formData));
        }else{
          if(this.Index==-1) return false;
          this.formData = JSON.parse(JSON.stringify(this.data[this.Index]));
        }
        this.modal=true;
      },
      edit:function (type) {
        var _this=this;
        if(!type) return this.modal = false;
        if(this.formData.name=='') return this.modalMsg('请选择控销类别！');
        this.formData.goods_code = this.goods_code;
        this.common.http({
          url:'editSalesCategory',
          data:{data:this.formData}
        }).then(function (res) {
          if(res.status) {
            _this.modal = false;
            _this.init(_this.goods_code);
          }else {
            _this.modalMsg(res.msg)
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      del:function(){
        var _this=this;
        if(this.Index==-1) return false;
        this.$Modal.confirm({
          title:'提示',
          content:'确定要删除该商品控销类别吗？',
          onOk:function () {
            _this.common.http({
              url:'delSalesCategory',
              data:{data:_this.data[_this.Index]}
            }).then(function (res) {
              if (res.status) _this.init(_this.goods_code);
              else _this.modalMsg(res.msg)
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
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
  .active{
    padding: 0 10px;
    .ivu-btn {
      display: block;margin-bottom: 5px;
    }
  }
</style>
