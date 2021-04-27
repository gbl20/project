<template>
	<div>
    <split-lr  ref="splitPageRef" @DHeight="DHeight" :splitInit=0.2 :nestingNum="88">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="showKinds(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="reload"><span class="icon iconfont">&#xe788;</span>刷新</Button>
        </div>
      </div>
      <div slot="left">
        <div class="l-title l-color">自定义商品许可经营类别</div>
        <div class="company-l">
          <RadioGroup vertical v-model="Index" @on-change="changeIndex">
            <Radio v-for="(item,index) in customItem" :label="item.id" :key="index">{{item.name}}</Radio>
          </RadioGroup>
        </div>
      </div>
      <div slot="right">
        <div class="r-title l-color">自定义商品许可经营类别列表</div>
        <div class="nav-menu">
          <Button @click="editKinds"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="delKinds"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </div>
        <Table ref="departTable" border stripe highlight-row size="small" :columns="columns" :data="data[Index]" :height="height-116" @on-row-click="changeRow">
        </Table>
      </div>
    </split-lr>
    <Modal v-model="modal" title="自定义许可经营类别" width="900" ref="editModal">
      <Form :label-width="90">
        <FormItem label="自定义名称">
          <Input v-model="name" maxlength="30"></Input>
        </FormItem>
        <FormItem label="许可设置">
          <div class="sel-box">
            <div class="sel-item" v-for="(list,index) in item" :key="index">
              <div class="title">
                <Checkbox :indeterminate="list.indeterminate" v-model="list.checkall" @click.prevent.native="handleCheckAll(index)">{{list.name}}</Checkbox>
              </div>
              <div class="content">
                <CheckboxGroup v-model="list.checkAllGroup" @on-change="checkAllGroupChange(index)">
                  <Checkbox v-for="(i,key) in list.children" :label="i.id" :key="key"><span>{{i.name}}</span></Checkbox>
                </CheckboxGroup>
              </div>
            </div>
          </div>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button type="primary" @click="addKinds(true)">确定</Button>
        <Button @click="addKinds(false)">取消</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  import splitLr from "@/components/public/splitLR"
  var _this;
	export default {
    inject: ['reload'],
    components:{splitLr},
    data:function () {
      return{
        Index:0,
        loading:false,
        modal:false,
        height:0,
        name:'',
        chlid_kid:0,
        customItem:[],
        item:[],
        columns:[
          {title:'小类编号',key:'chlid_kid',width:120,ellipsis:true,resizable:true},
          {title:'小类名称',key:'chlid_name',width:220,ellipsis:true,resizable:true},
          {title:'所属大类编号',key:'top_kid',width:140,ellipsis:true,resizable:true},
          {title:'所属大类',key:'parent_name',width:220,ellipsis:true,resizable:true},
        ],
        data:[],
        delIndex:-1
      }
    },
    mounted() {
      _this=this;
    },
    watch:{
      Index:function (e) {

      }
    },
    created() {
    },
    methods:{
      init:function(){
        this.common.http({
          url:'categoryInit',data:{'data':'custom_kinds'}
        }).then(function (res) {
          if (res.status==1){
            _this.Index = res.index;
            _this.customItem = res.item;
            _this.data = res.data;
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      //点击新增许可类别按钮
      showKinds:function(type){
        this.common.http({
          url:'getCustomList',
        }).then(function (d) {
          if (d.status==1) _this.item = d.item;
          _this.$nextTick(function () {
              _this.modal=true;
          })
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      handleCheckAll(index){
        var obj = this.item[index];
        obj.checkall = obj.indeterminate?false:!obj.checkall;
        obj.indeterminate = false;
        if(obj.checkall){
          for (let i = 0; i < obj.children.length; i++) {
            obj.checkAllGroup.push(obj.children[i].id);
          }
        }else{
          obj.checkAllGroup = [];
        }
      },
      checkAllGroupChange (index) {
        var obj = this.item[index],
            length1 = obj.children.length,
            length2 = obj.checkAllGroup.length;
        obj.indeterminate = length1===length2?false:(length2>0?true:false);
        obj.checkall = length1===length2?true:false;
      },
      addKinds:function(type){
        if (!type) return this.modal=false;
        if(this.name=='') return this.alertMsg('请填写自定义名称','error')
        var obj = this.item,parent = [],arrData = [];
        for (let i=0;i<obj.length;i++){
          if(obj[i].checkall || obj[i].indeterminate){
            if (!obj[i].children.length){
              parent.push(obj[i].id)
            }
            if (obj[i].checkAllGroup.length!=0){
              let objChild = obj[i].checkAllGroup;
              for (let j=0;j<objChild.length;j++){
                arrData.push(objChild[j])
              }
            }
          }
        }
        if (!arrData.length && !parent.length){
          return this.alertMsg('请选择许可经营类别','error')
        }
        var datas = {name:this.name,parent_kid:parent,chlid_kid:arrData};
        this.common.http({
          url:'addCustomKinds',
          data:datas
        }).then(function (d) {
          if(d.status==1){
            _this.modal = false;
            _this.name  = '';
            _this.alertMsg(d.msg);
            _this.init();
          }else{
            _this.alertMsg(d.msg,'error')
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      DHeight:function (e) {
        this.height = e;
      },
      changeIndex:function (index) {
        this.Index = index;
      },
      changeRow:function(item,index){
        this.delIndex = index;
      },
      editKinds:function () {

      },
      delKinds:function () {
        if(this.delIndex == -1){
          return this.alertMsg('请选择需要删除的类别!','error')
        }
        var data = {data:this.data[this.Index][this.delIndex]}
        data.data.kid = this.Index;
        this.$Modal.confirm({
          title:"提示",
          content:"确定要删除该类别吗?",
          onOk:function () {
            _this.common.http({
              url:'delCustomKinds',
              data:data
            }).then(function (res) {

            }).catch(function (err) {
              _this.common.httpErr(err.data,_this)
            })
          }
        })
      }
    }
	}
</script>

<style lang="less">
  .sel-box{
    max-height: 408px;overflow: hidden;overflow-y: auto;border: 1px solid #d9d9d9;
    .sel-item{
      display: flex;flex-flow: row nowrap;border-bottom: 1px solid #d9d9d9;
      .title{
        display: flex;justify-content:left;align-items: center;width: 137px;min-width: 137px;line-height: 20px;padding: 16px;border-right: 1px solid #d9d9d9;box-sizing: border-box;
      }
      .content{
        padding: 10px 16px;
      }
    }
    .sel-item:last-child{
      border-bottom: none;
    }
  }
</style>
