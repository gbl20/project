<template>
  <div>
    <split-none :Breadcrumb="Breadcrumb" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="openModal(true,-1)"><span class="icon iconfont">&#xe797;</span>新增体系</Button>
          <Divider type="vertical"/>
          <Button @click="(e)=>{this.init()}"><span class="icon iconfont">&#xe788;</span>刷新数据</Button>
          <Button><span class="icon iconfont">&#xe7d8;</span>打印预览</Button>
          <Button @click="(e)=>{this.delView()}"><span class="icon iconfont">&#xe68f;</span>关闭窗口</Button>
        </div>
      </div>
      <div :style="'height:'+height+'px;overflow:hidden;'" class="tabs-form" slot="table-list">
        <Table size="small" border :loading="loading" :columns="columns" :data="data" :height="height">
          <template slot-scope="item" slot="status">
            <Switch :true-value="1" :false-value="0" v-model="item.row.status" disabled />
          </template>
          <template slot-scope="item" slot="dept_name">
            <span>{{item.row.depart==0?'系统管理员':item.row.dept_name}}</span>
          </template>
          <template slot-scope="item" slot="active">
            <Button @click="openModal(false,item.index)"><span class="icon iconfont">&#xe791;</span>修改体系</Button>
            <Button :disabled="item.row.depart==0?true:false" @click="del(item.row.id)"><span class="icon iconfont">&#xe6a5;</span>删除体系</Button>
          </template>
        </Table>
      </div>
    </split-none>
    <Modal title="价格方案" v-model="modal" class-name="vertical-center-modal">
      <Form :model="formData" :label-width="80">
          <FormItem label="方案名称">
            <Input v-model="formData.name" :disabled="formData.depart==0?true:false"></Input>
          </FormItem>
        <FormItem label="备注">
          <Input type="textarea" :autosize="{minRows: 3, maxRows: 3}" v-model="formData.remark"></Input>
        </FormItem>
        <FormItem label="有效">
          <Switch :true-value="1" :false-value="0" v-model="formData.status"></Switch>
        </FormItem>
      </Form>
      <div slot="footer" style="text-align:right">
        <Button type="primary" @click="editPrice(true)">确定</Button>
        <Button @click="editPrice(false)">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  var _this,formData={id:null,name:'',remark:'',status:1,depart:null};
  import splitNone from "@/components/public/splitNone"
  export default {
    components: {
      splitNone
    },
    data() {
      return {
        Breadcrumb: [{title: '资料管理'}, {title: '价格体系管理'}],
        height: 0,
        loading:false,
        modal: false,
        formData:formData,
        columns: [
          {title:"价格体系编号",key:"id",width:100,minWidth:100,ellipsis:true,resizable :true},
          {title:"价格体系名称",key:"name",width:160,minWidth:160,ellipsis:true,resizable :true},
          {title:"是否有效",slot:"status",width:90,minWidth:100,ellipsis:true,resizable :true},
          {title:"部门编号",key:"depart",width:90,minWidth:100,ellipsis:true,resizable :true},
          {title:"所属部门名称",slot:"dept_name",width:160,minWidth:160,ellipsis:true,resizable :true},
          {title:"备注",key:"remark",width:140,minWidth:140,ellipsis:true,resizable :true},
          {title:"操作",slot:"active",width:220,minWidth:220,ellipsis:true,resizable :true}
        ],
        data: []
      };
    },
    mounted() {
      _this=this;
    },
    created() {
      this.loading = true;
      this.init();
    },
    methods: {
      init:function(){
        this.common.http({
          url:'getPriceSystem'
        }).then(function (res) {
          if (res.status==1) _this.data = res.data;
          _this.$nextTick(function () {
            _this.loading = false;
          })
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      //新增-修改
      openModal:function(type,index){
        this.modal = true;
        if(!type){
          this.formData.id = this.data[index].id;
          this.formData.name = this.data[index].name;
          this.formData.remark = this.data[index].remark;
          this.formData.status = this.data[index].status;
          this.formData.depart = this.data[index].depart;
        }else{
          this.formData = JSON.parse(JSON.stringify(formData));
        }
      },
      //确认新增-修改
      editPrice:function(type){
        if(!type) return this.modal=false;
        if(this.formData.name==''){this.alertMsg('请输入方案名称','error');return;}
        var datas = {id:this.Index,data:JSON.parse(JSON.stringify(this.formData))}
        this.common.http({
          url:'addOrUpdatePriceSystem',
          data:datas
        }).then(function (d) {
            if(d.status) {
              _this.modal = false;
              _this.init();
            }else{
              _this.alertMsg(d.msg,'error');
            }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      del:function(id){
        this.$Modal.confirm({
          title:'提示',
          content:"确定要删除该方案吗?",
          onOk:function () {
            this.common.http({
              url:'delPriceSystem',
              data:{id:id}
            }).then(function (res) {
              if(res.status) _this.init();
              else _this.alertMsg(res.msg,'error');
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      DHeight: function (e) {
        this.height = e;
      }
    }
  };
</script>
<style lang="less">
  .vertical-center-modal{
    display: flex;align-items: center;justify-content: center;

    .ivu-modal{
      top: 0;
    }
  }
</style>
