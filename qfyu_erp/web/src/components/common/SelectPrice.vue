<template>
	<div>
    <Modal title="选择商品价格" v-model="modal" :mask-closable="false" footer-hide>
      <Table size="small" border :columns="columns" :data="data" :height="390" :row-class-name="rowClassName"
          @on-row-click="(item,index)=>{changeRow(item,index,true)}"
          @on-row-dblclick="(item,index)=>{changeRow(item,index,false)}">
          <template slot-scope="row" slot="price">
              {{is_unit?row.row.price1:row.row.price2}}
          </template>
      </Table>
      <div class="price_selbtn">
          <Button @click="confirm" type="primary">
             <Icon type="md-checkmark"/>确认选定
          </Button>
          <Button @click="close" type="warning" style="margin-left:10px;">
             <Icon type="md-close" />取消
          </Button>
      </div>
    </Modal>
  </div>
</template>
<script>
	export default {
		name: "SelectPrice",
    data:function () {
      return{
        modal:false,
        goods_code:null,
        columns:[
          {title:'价格体系代码',key:'mode_id',align:'center',width:100},
          {title:'价格体系名称',key:'mode_name'},
          {title:'单价',slot:'price',align:'center',width:150}
        ],
        data:[],
        editIndex:0,
        is_unit:true
      }
    },
    methods:{
      rowClassName(row, index) {
        let className='';
        if(index === this.editIndex) {
           className='ivu-table-row-highlight';
        }
        return className;
      },
		  init:function () {
        var _this=this;
        this.common.http({
          url:'getPriceList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      changeRow:function(item,index,type){
		    this.editIndex = index;
		    if (!type) this.confirm();
      },
      open:function (code,isUnit) {
        this.is_unit = (typeof(isUnit)=='undefined' || isUnit==null || isUnit)?true:false;
        this.goods_code = code;
        this.init();
        this.modal = true;
      },
      close:function(){
        this.modal=false;
      },
      confirm:function () {
        if (this.editIndex==-1){
          return this.alertMsg('请选择商品价格','error');
        }
        this.$emit('confirm',this.data[this.editIndex]);
        this.modal = false;
      }
    }
	}
</script>
<style lang="less">
    .price_selbtn{
       padding-top:15px;
    }
</style>
