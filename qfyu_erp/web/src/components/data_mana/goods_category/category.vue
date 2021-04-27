<template>
  <div>
    <div class="nav-menu">
      <Button type="primary" @click="openModal('add',-1)"><span class="icon iconfont">&#xe797;</span>新增类别</Button>
    </div>
    <div class="item">
      <Table size="small" border row-key="id" :columns="columns" :data="data" width="1100" :height="height-70">
        <template slot-scope="item" slot="status">
          <Switch :true-value="1" :false-value="0" v-model="item.row.status"></Switch>
        </template>
        <template slot-scope="item" slot="active">
          <Button @click="openModal('edit',item.row)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="delKinds(item.row)"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </template>
      </Table>
    </div>
    <Modal v-model="modal" title="商品类别">
      <Form :model="formItem" :label-width="90">
        <FormItem label="所属分类">
          <Select v-model="formItem.id" :disabled="status==0?false:true">
            <Option :value="0">顶级分类</Option>
            <Option v-for="(item,key) in selItem" :value="item.id" :key="key" :disabled="item.level>=3?true:false">{{item.title}}</Option>
          </Select>
        </FormItem>
        <FormItem label="类别名称">
          <Input v-model="formItem.title" maxlength="30"></Input>
        </FormItem>
        <FormItem label="备注">
          <Input type="textarea" maxlength="50" show-word-limit v-model="formItem.remark"></Input>
        </FormItem>
        <FormItem label="是否有效">
            <Switch :true-value="1" :false-value="0" v-model="formItem.status"></Switch>
        </FormItem>
      </Form>
      <div slot="footer" style="text-align:right">
        <Button type="primary" @click="editKinds(true)">确定</Button>
        <Button @click="editKinds(false)">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
	export default {
    props: {
      height:{
        type:Number,
        default:0
      }
    },
    data:function () {
      return{
        status:0,
        Index:0,
        modal:false,
        editModal:false,
        loading:false,
        formItem:{id:0,title:'',remark:'',status:1},
        columns:[
          {title:'类别名称',key:'title',tree: true,minWidth: 350},
          {title:'类别编号',key:'id'},
          {title:'是否有效',slot:'status'},
          {title:'备注',key:'remark',minWidth:80},
          {title:'操作',slot:'active',minWidth:120},
        ],
        data:[],
        selItem:[]
      }
    },
    created:function () {
      this.init();
    },
    methods:{
      init:function () {
        var _this=this;
        this.common.http({
          url:'categoryInit',data:{'data':'category'}
        }).then(function (res) {
          _this.data = res.data;
          _this.selItem = res.option;
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      openModal:function(type,index){
        this.modal = true;
        if(index != -1){
          this.status = 1;
          this.Index = index.id;
          this.formItem.id = index.parent_id;
          this.formItem.title = index.title;
          this.formItem.remark = index.remark;
          this.formItem.status = index.status;
        }else{
          this.Index = 0;
          this.formItem.id = 0;
          this.formItem.title = '';
          this.formItem.remark = '';
          this.formItem.status = 1;
          this.status = 0;
        }
      },
      //新增-修改商品功能类别
      editKinds:function(type){
        var _this=this;
        if(!type){this.modal = false;return;}
        var datas = {id:this.Index,data:JSON.parse(JSON.stringify(this.formItem))};
        if (this.formItem.title==''){return this.alertMsg('商品类别名称不能为空','error');}
        this.common.http({
          url:'setKinds',
          data:datas
        }).then(function (res) {
          if (!res.status){
            _this.alertMsg(res.msg,'error');
          }else{
            _this.modal = false;
            _this.alertMsg(res.msg);
          }
          _this.$nextTick(function () {
            _this.init();
          })
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      //删除商品分类
      delKinds:function (data) {
        var _this=this,datas = {id:data.id};
        if(data.children.length!=0){
          this.alertMsg('该分类不能删除，请先删除该分类下的子分类','error');
        }else {
          this.$Modal.confirm({
              title:'提示',
              content:'确定要删除'+' ['+data.title+'] '+'分类吗?',
              onOk:function (res) {
                _this.common.http({
                  url:'delKinds',
                  data:datas
                }).then(function (d) {
                  if (d.status==1){
                    _this.alertMsg(d.msg);
                  }else{
                    _this.alertMsg(d.msg,'error');
                  }
                  _this.$nextTick(function () {
                    _this.init()
                  })
                }).catch(function(err){
                  _this.common.httpErr(err.data,_this);
                })
              }
          })
        }
      }
    }
	}

</script>

<style lang="less">
  .item{padding: 10px;}
  .ivu-modal-wrap{
    display: flex;
    align-items: center;
    justify-content: center;
    .ivu-modal{
      top: 0;
    }
  }
</style>
