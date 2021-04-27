<template>
	<div class="re-main">
    <Row>
      <Col span="4">
        <div class="left bg" :style="'height:'+height+'px'">
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==0?' cur':'')" @click="changeSel(0)">商品大类</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==1?' cur':'')" @click="changeSel(1)">计量单位</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==2?' cur':'')" @click="changeSel(2)">剂型参考</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==3?' cur':'')" @click="changeSel(3)">部门参考</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==4?' cur':'')" @click="changeSel(4)">职务参考</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==5?' cur':'')" @click="changeSel(5)">行业参考</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==6?' cur':'')" @click="changeSel(6)">常用文字</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==7?' cur':'')" @click="changeSel(7)">疾病参考</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==8?' cur':'')" @click="changeSel(8)">优先发货原因</a>
          <a href="javascript:;" :class="'n-item txt-color'+(menuIndex==9?' cur':'')" @click="changeSel(9)">控销类别</a>
        </div>
      </Col>
      <Col span="20" :style="'height:'+height+'px'">
        <Table size="small" stripe border :columns="columns" :data="data[menuIndex]" :height="height"></Table>
      </Col>
    </Row>
  </div>
</template>

<script>
	export default {
	  props:{
      height:0
    },
		data(){
		  return{
		    menuIndex:0,
        columns:[
          {title:'值',key:'value'},
          {title:'备注',key:'remark'},
        ],
        data:[]
      }
    },
    methods:{
	    init:function(){
        var _this=this;
        this.common.http({
          url:'getReferenceDataInit',
          data:{name:this.menuIndex}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      changeSel:function (index) {
        this.menuIndex = index;
      }
    }
	}
</script>

<style lang="less">

</style>
