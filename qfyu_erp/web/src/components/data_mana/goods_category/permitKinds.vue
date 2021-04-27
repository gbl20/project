<template>
  <div>
    <split-lr ref="splitPageRef" @DHeight="DHeight" :splitInit=0.2 :nestingNum="88">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="openModal(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="openModal(false)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button disabled @click="delKinds"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="reload"><span class="icon iconfont">&#xe788;</span>刷新</Button>
        </div>
      </div>
      <div slot="left">
        <div class="l-title l-color">商品许可经营大类</div>
        <div class="company-l">
          <RadioGroup vertical v-model="parent_id">
            <Radio v-for="(item,index) in item" :label="item.id" :key="index">{{item.name}}</Radio>
          </RadioGroup>
        </div>
      </div>
      <div slot="right">
        <div class="r-title l-color">商品许可经营小类</div>
        <div class="nav-menu">
          <Button @click="openSmallKinds(true)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="openSmallKinds(false)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button disabled @click="delSmallKinds"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </div>
        <Table ref="departTable" border stripe highlight-row size="small" :columns="columns" :data="data" :height="height-73" @on-row-click="changeRow"></Table>
      </div>
    </split-lr>
    <Modal v-model="modal" :title="'商品许可经营大类'+(kinds_id==0?' -新增':' -修改')">
      <Form :model="formData" :label-width="80">
        <FormItem label="大类名称">
          <Input v-model="formData.name" maxlength="30" :disabled="kinds_id?true:false"></Input>
        </FormItem>
        <FormItem label="备注">
          <Input type="textarea" v-model="formData.remark" maxlength="50" :autosize="{minRows:3,maxRows: 6}"></Input>
        </FormItem>
      </Form>
      <div slot="footer" style="text-align: right">
        <Button type="primary" @click="editKind(true)">确定</Button>
        <Button @click="editKind(false)">取消</Button>
      </div>
    </Modal>
    <Modal v-model="modal2" title="商品许可经营小类">
      <Form :model="editKinds" :label-width="80">
        <FormItem label="所属类别">
          <Select v-model="editKinds.parent_id" disabled>
            <Option v-for="(item,index) in item" :value="item.id" :key="index">{{item.name}}</Option>
          </Select>
        </FormItem>
        <FormItem label="类别名称">
          <Input v-model="editKinds.name" maxlength="30"></Input>
        </FormItem>
        <FormItem label="备注">
          <Input type="textarea" v-model="editKinds.remark" maxlength="50" :autosize="{minRows:3,maxRows: 6}"></Input>
        </FormItem>
      </Form>
      <div slot="footer" style="text-align: right">
        <Button type="primary" @click="editSmallKind(true)">确定</Button>
        <Button @click="editSmallKind(false)">取消</Button>
      </div>
    </Modal>
  </div>
</template>
<style lang="less">
  .l-title,.r-title{
    display: block;width: auto;height: 30px;line-height: 30px;font-size: 14px;padding:0 10px;
  }
  .company-l{
    width: auto;height: auto;padding:10px;
  }
</style>
<script>
  import splitLr from '@/components/public/splitLR'
  var _this;
  export default {
    inject: ['reload'],
    components: {splitLr},
    data () {
      return {
        modal:false,
        modal2:false,
        kinds_id:0,
        parent_id:0,
        editIndex:-1,
        editId:null,
        height:0,
        item:[],
        formData:{name:'',remark:''},
        editKinds:{id:null,parent_id:0,name:'',remark:''},
        columns: [
          {title: '类别编号',key: 'id',width: 100,minWidth: 100},
          {title: '类别名称',key: 'name',resizable: true,width: 240,minWidth: 240},
          {title: '所属大类名称',key: 'parent_name',resizable: true,width: 180,minWidth: 180},
          {title: '备注',key: 'remark',resizable:true,width:240,minWidth: 140}
        ],
        data:[]
      }
    },
    mounted() {
      _this = this;
      _this.getDelKinds(_this.parent_id);
    },
    watch:{
      parent_id:function (e) {
        this.parent_id = e;
        this.editId = null;
        this.editIndex = -1;
        this.getDelKinds(this.parent_id)
      }
    },
    methods:{
      init:function(){
        this.common.http({
          url:'categoryInit',data:{'data':'permit_kinds'}
        }).then(function (res) {
          if(res.status==1){
            _this.item = res.data;
            _this.parent_id = res.parent_id;
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      getDelKinds:function(id){
        this.common.http({
          url:'getDelKinds',data:{id:id}
        }).then(function (res) {
          _this.data = res.data;
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      //type==true 新增 type==false 修改
      openModal:function(type){
        if (type){
          this.kinds_id = 0;
          this.formData.name = '';
          this.formData.remark = '';
        }else {
          this.kinds_id = parseInt(this.parent_id);
          this.formData.name = this.item[this.parent_id].name;
          this.formData.remark = this.item[this.parent_id].remark;
        }
        this.modal=true;
      },
      //新增-编辑许可大类
      editKind:function(type){
        if(!type) return this.modal=false;
        if(!this.formData.name) return this.alertMsg('请输入许可大类名称','error');
        this.common.http({
          url:'setPermitKinds',
          data:{data:this.formData}
        }).then(function (res) {
          if (res.status==1){
            _this.modal = false;
            _this.alertMsg(res.msg)
            _this.init();
          }else {
            _this.alertMsg(res.msg,'error')
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      delKinds:function(){
        var datas = {id:this.parent_id}
        this.$Modal.confirm({
          title:'提示',
          content:'确定要删除 [ '+this.item[this.parent_id].name+' ] 类别吗?',
          onOk:function () {
            this.common.http({
              url:'delPermitKinds',
              data:datas
            }).then(function (d) {
              if(d.status==1){
                _this.alertMsg(d.msg)
                _this.init();
              }else{
                _this.alertMsg(d.msg,'error')
              }
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      changeRow:function(item,index){
        this.editIndex = index;
        this.editId = this.data[index].id;
      },
      //新增-修改许可经营小类 type==true 新增 type==false修改
      openSmallKinds:function(type){
        this.editKinds.parent_id = this.parent_id;
        this.editKinds.name = '';
        this.editKinds.remark = '';
        this.editKinds.id = type?null:this.editId;
        if(!type){
          if(this.editIndex==-1) return this.alertMsg('请选择需要修改的类别','error')
          if(!this.data.length) return false;
          this.editKinds.name   = this.data[this.editIndex].name;
          this.editKinds.remark = this.data[this.editIndex].remark;
        }
        this.modal2=true;
      },
      editSmallKind:function(type){
        if(!type){return this.modal2=false;}
        if(!this.editKinds.name){return this.alertMsg('请填写许可小类名称','error')}
        this.common.http({
          url:'editSmallPermitKind',
          data:{data:this.editKinds}
        }).then(function (d) {
          if (d.status==1){
            _this.alertMsg(d.msg);
            _this.modal2 = false;
            if (_this.editIndex!=-1){
              var obj = JSON.parse(JSON.stringify(_this.editKinds))
              _this.data[_this.editIndex].name = obj.name;
              _this.data[_this.editIndex].remark = obj.remark;
            }else{
              var index = _this.data.length?_this.data.length-1:0;
              var obj = JSON.parse(JSON.stringify(_this.editKinds));
              obj.id = _this.data[index].id+1;
              obj.parent_name = _this.data[index].parent_name;
              _this.data.push(obj)
            }
          }else{
            _this.alertMsg(d.msg,'error');
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      delSmallKinds:function(){
        if(this.editIndex==-1) return this.alertMsg('请选择需要删除的类别','error')
        this.$Modal.confirm({
          title:'提示',
          content:'确定药删除该分类吗?',
          onOk:function () {
            this.common.http({
              url:'delSmallPermitKind',
              data:{id:_this.editId}
            }).then(function (d) {
              if(d.status==1){
                _this.alertMsg(d.msg);
                _this.init();
              }else{
                _this.alertMsg(d.msg,'error')
              }
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      DHeight:function(e){
        this.height = e;
      }
    }
  }
</script>
