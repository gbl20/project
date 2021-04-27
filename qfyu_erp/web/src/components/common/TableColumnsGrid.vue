<template>
  <div>
    <Modal footer-hide :mask-closable="Mask" :title="Title" v-model="show" :width="Width">
      <div>
        <Row>
          <Col span="18" class-name="table-check-item">
            <Checkbox-group v-model="columnsGroup" @on-change="checkAllGroupChange">
              <Checkbox v-for="(item,index) in tableColumns" :label="item.label" :key="index">{{item.title}}</Checkbox>
            </Checkbox-group>
          </Col>
          <Col span="6" style="padding: 10px;height:426px;overflow:hidden;border:1px solid #eee;position: relative">
            <Checkbox :indeterminate="indeterminate" :value="checkTableColumnsAll" @click.prevent.native="handleCheckAll">全选</Checkbox>
            <div class="tab-btn">
              <Button @click="changeTableColumns(true)"><span class="icon iconfont">&#xe792;</span>确定</Button>
              <Button @click="changeTableColumns(false)"><span class="icon iconfont">&#xe7fd;</span>取消</Button>
            </div>
          </Col>
        </Row>
      </div>
    </Modal>
  </div>
</template>

<script>
	export default {
		name: "TableColumnsGrid",
    props:{
      Mask:{
        type:Boolean,
        default:false
      },
      Title:{
        type:String,
        default:'网格属性'
      },
      Width:{
        type:Number,
        dedault:600
      },
      //表格列数据
      tableColumnsChecked:{
        type:Array,
        required:true,
        default:[]
      },
      /*多选框数据*/
      tableColumns:{
        type:Array,
        required:true,
        default:[]
      },
      /*表格列属性*/
      tableColumnsList:{
        type:Object,
        required:true,
        default:{}
      }
    },
    data:function () {
      return{
        show:false,
        indeterminate:false,
        checkTableColumnsAll:false,
        columnsGroup:[]
      }
    },
    mounted() {
		  this.columnsGroup = this.tableColumnsChecked;
    },
    methods:{
		  init:function(){
        var data = this.setTableColumns();
        return data;
      },
		  open:function(){
		    this.show = true;
      },
      //
      checkAllGroupChange:function () {
        var length1 = this.tableColumns.length,
            length2 = this.columnsGroup.length;
        this.indeterminate = length1==length2?false:(length2>0?true:false);
        this.checkTableColumnsAll = length1==length2?true:false;
      },
      //全选
      handleCheckAll:function () {
        this.checkTableColumnsAll = this.indeterminate?false:!this.checkTableColumnsAll;
        this.indeterminate = false;
        if (this.checkTableColumnsAll){
          this.columnsGroup = [];
          for (let i in this.tableColumnsList){
            this.columnsGroup.push(i)
          }
        }else {
          this.columnsGroup = [];
        }
      },
      setTableColumns:function(){
        let data = [];
        this.columnsGroup.forEach(
          col=>data.push(this.tableColumnsList[col])
        )
        return data;
      },
      //确定 or 取消
      changeTableColumns:function (type) {
		    type = type || false;
        this.show = false;
        var defaultData = JSON.parse(JSON.stringify(this.tableColumnsChecked));
        if (!type){
          this.columnsGroup = this.tableColumnsChecked;
        }else{
          defaultData = this.columnsGroup;
        }
        var data = this.setTableColumns();
        this.$emit('selTableColumns',[data,defaultData])
      }
    }
	}
</script>

<style lang="less">
  .table-check-item{
    .ivu-checkbox-group{
      display: flex;flex-flow: column wrap;height: 426px;overflow-x: auto;
    }
  }
  .tab-btn{
    text-align: center;position: absolute;left: 0;right: 0;bottom: 0;
    .ivu-btn{
      margin-bottom: 5px;min-width: 120px;
    }
  }
</style>
