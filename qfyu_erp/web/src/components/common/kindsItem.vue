<template>
  <div ref="kindsRef">
    <Modal v-model="kindModal" title="选择许可经营类别" width="800">
      <div class="kinds-main">
        <div class="left">
          <div class="l-title l-color">商品许可经营大类</div>
          <div class="company-l">
            <RadioGroup v-model="kindId">
              <Radio v-for="(item,index) in kindItem" :label="item.id" :key="index">{{item.name}}</Radio>
            </RadioGroup>
          </div>
        </div>
        <div class="right">
          <div class="r-title l-color">商品许可经营小类 (<span class="error-text"> 双击表格行可选中一项许可经营类别 </span>)</div>
          <Table ref="kindDataRef" border stripe highlight-row size="small" :height="500-21" :columns="kindCol" :data="kindData" @on-row-click="(item,index)=>{changeRow(item,index,false)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,true)}"></Table>
        </div>
      </div>
      <div slot="footer">
        <Button @click="selData"><span class="icon iconfont">&#xe692;</span>选定</Button>
        <Button @click="kindModal = false"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
        <Button @click="delData"><span class="icon iconfont">&#xe6a5;</span>清除选择</Button>
      </div>
    </Modal>
  </div>
</template>
<script>
	export default {
		name: "kindsItem",
    data:function () {
        return{
          kindModal:false,
          height:0,
          kindId:0,
          kindItem:[],
          kindData:[],
          kindCol:[
            {title:'类别编号',key:'id',width:88,minWidth: 88},
            {title:'类别名称',key:'name',width:230,minWidth:230},
            {title:'所属大类',key:'parent_name',width:110,minWidth:110},
            {title:'备注',key:'remark',width:90,minWidth:90},
          ],
          formData:{},
          tableColumnsIndex:-1
        }
    },
    watch:{
      kindId:function(e){
        this.kindId =e;
        this.tableColumnsIndex = -1;
        this.setSmallKind(this.kindId);
      }
    },
    methods:{
		  //获取许可经营大类
		  init:function (id) {
        var _this=this;
		    id = id || null;
        this.kindModal = true;
        this.common.http({
          url:'getPopupKind',
          data:{id:id}
        }).then(function (res) {
          if (res.status){
            _this.kindId = res.parent_id;
            _this.kindItem = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        });

      },
      //获取许可经营小类
      setSmallKind:function(id){
        var _this=this;
        this.common.http({
          url:'getDelKinds',
          data:{id:id}
        }).then(function (res) {
            _this.kindData = res.data;
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        });
      },
      //表格单击-双击事件
      changeRow:function (item,index,type) {
		    this.tableColumnsIndex = index;
		    this.formData = JSON.parse(JSON.stringify(item));
        if (type){
          this.kindModal = false;
          this.$emit('changeKind',item);
        }
      },
      //选定许可经营类别
      selData:function () {
        if (this.tableColumnsIndex==-1){
          return this.alertMsg('没有选定许可经营类别！','error');
        }
        if (JSON.stringify(this.formData)=="{}"){
          return this.alertMsg('没有选定许可经营类别！','error');
        }
        this.$emit('changeKind',this.formData);
        this.kindModal = false;
      },
      delData:function () {
		    this.tableColumnsIndex = -1;
		    this.formData = {};
        this.$refs.kindDataRef.clearCurrentRow();
        this.$emit('clean')
      }
    }
	}
</script>
<style lang="less">
  .kinds-main{
    width: auto;height: 500px;overflow: hidden;
    .left{
      float: left;width: 30%;height: 100%;box-sizing: border-box;overflow-y: auto;
      .ivu-radio-wrapper{
        display: block;line-height: 24px;
      }
    }
    .right{
      float: left;width: 70%;box-sizing: border-box;
    }
  }

</style>
