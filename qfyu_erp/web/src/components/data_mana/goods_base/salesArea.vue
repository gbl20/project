<template>
	<div>
    <Row>
      <Col span="22">
        <Table highlight-row border size="small" :columns="columns" :data="data" :height="height" @on-row-click="changeRow"></Table>
      </Col>
      <Col span="2" :style="'height:'+height+'px'">
        <div class="active">
          <Button @click="openModal(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="del"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="openModal(false)"><span class="icon iconfont">&#xe791;</span>修改</Button>
        </div>
      </Col>
    </Row>
    <Modal title="商品控销区域" v-model="modal">
      <Form :model="formData" :label-width="90">
        <FormItem label="控销区域">
          <Row>
            <Col span="7">
              <Input icon="ios-more" v-model="formData.area_id" @on-click="openArea"></Input>
            </Col>
            <Col span="1">&nbsp;</Col>
            <Col span="16">
              <Input v-model="formData.area_name"></Input>
            </Col>
          </Row>
        </FormItem>
        <FormItem label="限购数量">
          <InputNumber :max="9999999999" :min="-1" v-model="formData.amount" style="width: 200px;"></InputNumber>
        </FormItem>
        <FormItem><span class="error-text">-1:不限购；0：禁购；其他：限购指定数值</span></FormItem>
        <FormItem label="限购开始日期">
          <datePicker type="date" :options="options" v-model="formData.start_date" style="width: 200px;"></datePicker>
        </FormItem>
        <FormItem label="限购结束日期">
          <datePicker type="date" :options="options2" v-model="formData.end_date" style="width: 200px;"></datePicker>
        </FormItem>
        <FormItem label="备注信息">
          <Input v-model="formData.remark" maxlength="255"></Input>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="edit(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="edit(false)" icon="md-close">取消</Button>
      </div>
    </Modal>
    <select-area ref="selArea" @selarea="selArea"></select-area>
  </div>
</template>
<script>
  var formData = {
    goods_code:null,area_id:null, area_name:'', amount:-1, start_date:'', end_date:'', remark:''
  }
  import SelectArea from "@/components/common/SelectArea"
	export default {
    props:{
      height:0
    },
    components:{
      SelectArea
    },
		data(){
		  return{
        modal:false,
		    goods_code:null,
        Index:-1,
        formData:formData,
        columns:[
          {title:'商品编号',key:'goods_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'控销区域编号',key:'area_id',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'控销区域名称',key:'area_name',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'限购数量',key:'amount',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'限购开始日期',key:'start_date',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'限购结束日期',key:'end_date',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'备注信息',key:'remark',minWidth:160,resizable:true,ellipsis:true},
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
        }
      }
    },
    methods:{
      init:function(code){
        var _this=this;
        if (code) this.goods_code = code;
        this.common.http({
          url:'getGoodsSalesAreaList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      openArea:function(){
        this.$refs.selArea.init();
      },
      selArea:function(data){
        this.formData.area_id   = data.area;
        this.formData.area_name = data.areatxt;
      },
      edit:function(type){
        var _this=this;
        if(!type) return this.modal = false;
        this.formData.goods_code = this.goods_code;
        if(!this.formData.goods_code) return this.modalMsg('操作失败！商品编号不存在。');
        if(!this.formData.area_id) return this.modalMsg('请选择控销区域！');
        this.common.http({
          url:'editSalesArea',
          data:{data:this.formData}
        }).then(function (res) {
          if (res.status){
            _this.modal = false;
            _this.init(_this.goods_code);
          }else{
            _this.modalMsg(res.msg);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      changeRow:function(item,index){
        this.Index = index;
      },
      openModal:function(type){
        if(type){
          this.formData = JSON.parse(JSON.stringify(formData));
        }else{
          if(this.Index==-1) return false;
          this.formData = JSON.parse(JSON.stringify(this.data[this.Index]));
        }
        this.modal = true;
      },
      del:function(){

      },
    }
	}
</script>

<style scoped>

</style>
