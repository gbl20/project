<template>
  <div class="pricebox">
    <Row>
      <Col span="21">
        <Table border highlight-row size="small" :columns="columns" :data="data" :height="height" @on-row-click="changeRow">
          <template slot-scope="{ row,index }" slot="price1">
            <InputNumber :active-change="false" :max="9999999999" :min="0" :precision="6" v-model="proData.price1" v-if="editIndex===index"></InputNumber>
            <span v-else>{{row.price1}}</span>
          </template>
          <template slot-scope="{ row,index }" slot="price2">
            <InputNumber :active-change="false" :max="9999999999" :min="0" :precision="6" v-model="proData.price2" v-if="editIndex===index"></InputNumber>
            <span v-else>{{row.price2}}</span>
          </template>
        </Table>
      </Col>
      <Col span="3">
        <div class="active">
          <Row class-name="mb error-text">提示：单击表格行即选中一项！</Row>
          <Button v-if="editIndex==-1" @click="handleEdit"><span class="icon iconfont">&#xe791;</span>修改价格</Button>
          <Row v-else>
            <Button @click="handleSave"><span class="icon iconfont">&#xe792;</span>保存数据</Button>
            <Button @click="editIndex = -1"><span class="icon iconfont">&#xe793;</span>取消修改</Button>
          </Row>
          <Button @click="toUrl('/pricesystem')">价格体系管理</Button>
        </div>
      </Col>
    </Row>
  </div>
</template>

<script>
  var _this;
	export default {
	  props:{
      height:0
    },
    data:function () {
      return{
        goods_code:null,
        editIndex: -1,  // 当前聚焦的输入框的行数
        columns:[
          {title:'商品编号',key:'goods_code',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'价格体系代码',key:'mode_id',width:150,minWidth:150,resizable:true,ellipsis:true,align:'right'},
          {title:'价格体系名称',key:'mode_name',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'主单位价格',slot:'price1',width:250,minWidth:250,resizable:true,ellipsis:true,align:'right'},
          {title:'辅单位价格',slot:'price2',width:250,minWidth:250,resizable:true,ellipsis:true,align:'right'}
        ],
        data:[],
        proData:{price1:0,price2:0}
      }
    },
    mounted() {
      _this = this;
    },
    methods:{
      init:function (code) {
        this.common.http({
          url:'getPriceList',
          data:{goods_code:code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      //保存
      handleSave:function () {
        var datas = {id:this.data[this.editIndex].id,price1:this.proData.price1,price2:this.proData.price2}
        this.common.http({
          url:'editPrice',
          data:{data:datas}
        }).then(function (res) {
          if (res.status){
            _this.alertMsg(res.msg)
            _this.init(_this.goods_code);
            _this.editIndex = -1;
          }else{
            _this.alertMsg(res.msg,'error')
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      //编辑
      handleEdit:function () {
        if(this.editIndex==-1) return this.alertMsg('请选择一项商品价格信息！再编辑。','error');
      },
      changeRow:function (item,index) {
        this.editIndex = index;
        this.proData.price1 = this.formatFloat(this.data[index].price1,6);
        this.proData.price2 = this.formatFloat(this.data[index].price2,6);
      }
    }
	}
</script>

<style lang="less">
.mb{margin-bottom: 8px;}
</style>
