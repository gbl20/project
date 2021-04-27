<template>
  <Modal footer-hide title="查看药检报告" width="900" v-model="model" class-name="drug-modal" :scrollable="true">
    <Row class-name="drug-box">
      <Row class-name="drug-title border-b">
        <span>商品编号：{{data.goods_code}}</span>
        <span>商品名称：{{data.goods_name}}</span>
        <span>生产批号：{{data.batch}}</span>
      </Row>
      <Row class-name="item-img">
        <Col span="6" class-name="fl-col border-r">
          <div class="left bg item-label">
            <a @click="changeSrc('file_a')" :class="'item-btn txt-color'+(imgSrc=='file_a'?' cur':'')" href="javascript:;" :title="data.file_a">{{data.file_a}}</a>
            <a @click="changeSrc('file_b')" :class="'item-btn txt-color'+(imgSrc=='file_b'?' cur':'')" href="javascript:;" :title="data.file_b">{{data.file_b}}</a>
          </div>
        </Col>
        <Col span="18" class-name="ri-col">
          <div class="col-img">
            <img :src="BASE_URL+path+data[imgSrc]" alt="" />
          </div>
        </Col>
      </Row>
    </Row>
  </Modal>
</template>

<script>
	export default {
		name: "ViewDrug",
    data(){
		  return{
		    model:false,
        goods_code:'',
        batch:'',
        supplier_code:'',
        imgSrc:'file_a',
        data:{batch:'',file_a:'',file_b:'',goods_code:'',goods_name:'',supplier_code:''},
        path:'/uploads/drug_img/',
        BASE_URL:this.common.BASE_URL
      }
    },
    methods:{
		  init:function(){
        var _this=this;
        this.common.http({
          url:'getGoodsDrugReports',
          data:{goods_code:this.goods_code,batch:this.batch,supplier_code:this.supplier_code}
        }).then(function (res) {
          if (res.status) {
            _this.data = res.data;
            _this.model = true;
          }else{
            _this.modalMsg(res.msg);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      changeSrc:function(name){
		    this.imgSrc = name;
      },
		  open:function(goods_code,batch,supplier_code){
        this.goods_code = goods_code;
        this.batch = batch;
        this.supplier_code = supplier_code;
        this.init();
      }
    }
	}
</script>

<style lang="less">
.drug-modal{
  .ivu-modal-body{
    padding:0;
  }
}
.drug-box{
  .drug-title{
    line-height: 28px;padding: 10px;
  }
  .item-img{
    height: 600px;overflow: hidden;
    .fl-col{height: 100%;}
    .item-label{
      padding-top: 10px;
      .item-btn{
        display: block;height: 28px;line-height: 28px;padding:0 10px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;
      }
    }
    .ri-col{
      .col-img{padding-left: 10px;padding-top: 10px;}
    }
  }
}
</style>
