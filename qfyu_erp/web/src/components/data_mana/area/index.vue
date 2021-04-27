<template>
	<div>
    <split-lr :Breadcrumb="Breadcrumb" @DHeight="DHeight" :splitInit=0.2>
      <div slot="form-ser">
        <div class="nav-menu border-b">
          <Button @click="find"><span class="icon iconfont">&#xe788;</span>刷新</Button>
          <Button @click="openModal(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="openModal(false)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="out"><span class="icon iconfont">&#xe68f;</span>退出</Button>
        </div>
      </div>
      <div slot="left">
        <Tree :data="areaItem" :render="renderContent" @on-select-change="selChildren"></Tree>
      </div>
      <div slot="right">
        <Table border size="small" :columns="columns" :data="data" :height="height"></Table>
      </div>
    </split-lr>
    <Modal :title="title" v-model="modal">
      <Form :model="formData" :label-width="80">
        <FormItem>
          <div v-if="editType">上级：编号【{{id}}】- {{parent_name}}</div>
          <div v-else>地区编号【{{id}}】</div>
        </FormItem>
        <FormItem label="地区名称">
          <Input v-model="formData.area_name"></Input>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="editdata(true)" type="primary" icon="md-checkmark">确定</Button>
        <Button @click="editdata(false)" icon="md-close">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  var _this;
  import splitLr from "@/components/public/splitLR"
	export default {
		components:{
      splitLr
    },
    data(){
		  return{
        Breadcrumb:[{title:'资料管理'},{title:'地区资料'}],
        height:0,
        areaItem:[],
        columns:[
          {title:'地区编号',key:'id',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'地区名称',key:'area_name',width:250,minWidth:250,resizable:true,ellipsis:true}
        ],
        data:[],
        modal:false,
        title:'',
        id:-1,
        parent_id:null,
        parent_name:'',
        formData:{id:null,parent_id:null,area_name:''},
        editType:true,
        children:[]
      }
    },
    mounted() {
		  _this=this;
    },
    created() {
		  this.init(1,true);
    },
    methods:{
		  init:function(id,type){
		    this.common.http({
          url:'getAreaList',
          data:{id:id}
        }).then(function(res){
            if(res.status){
              if(type) _this.areaItem = res.item;
              _this.data = res.data;
            }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      selChildren:function(item,index){
		    this.children = index;
        this.id = index.id;
        this.parent_id = index.parent_id;
        this.parent_name = index.title;
        this.init(index.id,false)
      },
      openModal:function(type){
		    this.editType = type;
		    this.title = type?'新增':'修改';
		    if(this.id==-1) return this.modalMsg('请选择一个分类');
        if(!type) {
          this.formData.id = this.id;
          this.formData.area_name = this.parent_name;
          this.formData.parent_id = this.parent_id;
        }else{
          this.formData.id = null;
          this.formData.area_name = '';
          this.formData.parent_id = this.id;
        }
		    this.modal = true;
      },
      editdata:function(type){
        if(!type) return this.modal = false;
        if(this.formData.area_name=='') return this.alertMsg('请输入地区名称！','error');
        this.common.http({
          url:'editArea',
          data:{data:this.formData}
        }).then(function (res) {
          if (res.status) {
            _this.modal = false;
            _this.init(res.id,false);
            if(!_this.editType) _this.children.title = _this.formData.area_name;
            _this.children.children.push({id:res.id,title:_this.formData.area_name});
          }else {
            _this.modalMsg(res.msg);
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      find:function(){
		    this.init(1,true);
      },
      renderContent:function(h,{root,node,data}){
        return h('span',{
          style:{
            display: 'inline-block',
            width: '100%'
          }
        },
        [
          h('span',[
            h('Icon',{
              props:{
                type:'ios-folder-outline'
              },
              style: {
                marginRight: '8px'
              }
            }),
            h('span',data.title)
          ])
        ])
      },
      out:function(){
		    this.delView();
      },
      DHeight:function (e) {
        this.height = e;
      }
    }
	}
</script>

<style lang="less">

</style>
