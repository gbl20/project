<template>
	<div>
    <Row>
      <Col span="22">
        <Table border highlight-row size="small" :columns="columns" :data="data" :height="height" @on-row-click="selectRow"></Table>
      </Col>
      <Col span="2" :style="'height:'+height+'px'">
        <div class="active">
          <Button @click="openWare"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="delWare"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </div>
      </Col>
    </Row>
    <choose-ware ref="chooseWareRef" @confirm="confirmWare"></choose-ware>
    <choose-ware-position ref="chooseWareChildRef" @confirm="confirmWareChild"></choose-ware-position>
  </div>
</template>

<script>
  import ChooseWare from "@/components/common/ChooseWare"
  import ChooseWarePosition from "@/components/common/ChooseWarePosition"
	export default {
		name: "warehouse",
    props:{
		  height:0
    },
    components:{
      ChooseWare,ChooseWarePosition
    },
    data:function () {
      return{
        goods_code:null,
        Index:-1,
        formData:{
          goods_code:null,ware_code:null,pos_code:null,max_num:null,min_num:null,remark:null
        },
        columns:[
          {title:'仓库ID',key:'ware_code',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'仓库名称',key:'ware_title',width:160,minWidth:160,resizable:true,ellipsis:true},
          {title:'存放货位',key:'pos_code',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'最大存量',key:'max_num',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'最小存量',key:'min_num',width:120,minWidth:120,resizable:true,ellipsis:true},
          {title:'备注说明',key:'remark',width:160,minWidth:160,resizable:true,ellipsis:true}
        ],
        data:[]
      }
    },
    methods:{
		  init:function(code){
		    var _this = this;
		    this.goods_code = code;
		    this.common.http({
          url:'getGoodsWareList',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
		  openWare:function () {
        this.$refs.chooseWareRef.open();
      },
      confirmWare:function (e) {
        if (e){
          this.formData.ware_code = e.ware_code;
          this.formData.remark = e.remark;
          this.$refs.chooseWareChildRef.open(e.ware_code);
        }
      },
      confirmWareChild:function (data) {
        this.formData.pos_code = data.pos_code;
        this.addWare();
      },
      addWare:function () {
        var _this=this;
        this.formData.goods_code = this.goods_code;
        this.common.http({
          url:'addGoodsWare',
          data:{data:this.formData}
        }).then(function (res) {
          if (res.status) _this.init(res.goods_code);
          else _this.alertMsg(res.msg,'error');
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      selectRow:function (item,index) {
        this.Index = index;
      },
      delWare:function () {
        if (this.Index==-1) return this.alertMsg('请选择要删除的库位！','error');
        var _this=this,data = {goods_code:this.goods_code,ware_code:this.data[this.Index].ware_code,pos_code:this.data[this.Index].pos_code}
        this.common.http({
          url:'delGoodsWare',
          data:data
        }).then(function (res) {
          if (res.status) _this.init(res.goods_code)
          else _this.alertMsg(res.msg,'error');
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
		  }
    }
	}
</script>

<style lang="less">

</style>
