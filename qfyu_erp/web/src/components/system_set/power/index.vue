<template>
  <div>
    <split-lr ref="splitPageRef" :Breadcrumb="Breadcrumb" :splitInit="0.4" @DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="editOp(1)"><span class="icon iconfont">&#xe797;</span>新增用户</Button>
          <Button @click="editOp(0)"><span class="icon iconfont">&#xe791;</span>编辑用户</Button>
          <Button @click="delOp"><span class="icon iconfont">&#xe793;</span>删除用户</Button>
          <Divider type="vertical" />
          <Button @click="editRo(1)"><span class="icon iconfont">&#xe797;</span>新增角色</Button>
          <Button @click="editRo(0)"><span class="icon iconfont">&#xe791;</span>编辑角色</Button>
          <Button @click="delRo"><span class="icon iconfont">&#xe793;</span>删除角色</Button>
          <Divider type="vertical" />
          <Button @click="init(true)" :loading="reload"><span class="icon iconfont">&#xe788;</span>刷新</Button>
        </div>
         <div class="height_5"></div>
      </div>
      <div slot="left" style="height: 100%;">
        <Split v-model="split">
            <div slot="left" style="height:100%;">
              <Split v-model="split1" mode="vertical">
                  <div slot="top">
                    <div class="l-title l-color border-b">用户列表</div>
                    <Table size="small" :row-class-name="rowClassName" :columns="columns" :data="opData.data" stripe :height="height*split1-70" @on-row-click="(row,index)=>{cOpList(row,index)}" ></Table>
                    <div class="page-m">
                      <Page :total="opData.total" :current="opData.currentPage" simple @on-change="ChangePage" @on-page-size-change="ChangePageSize"/>
                    </div>
                  </div>
                  <div slot="bottom">
                    <div class="l-title l-color border-b" style="margin-top:6px;">用户<font color="#ff6600">“{{opIndex!=-1?opData.data[opIndex].name:''}}”</font>的岗位权限</div>
                    <div :style="'height:'+(height*(1-split1)-46)+'px'">
                      <div class="role-list-m" style="padding-top: 5px;" v-if="opIndex != -1">
                        <CheckboxGroup v-model="opData.data[opIndex].post_auth"  @on-change="checkPostChange">
                            <div class="post-list dropdown-bg" v-for="(item,index) in extendDefine" :key="index">
                              <Checkbox :label="item.id">{{item.t_name}}</Checkbox>
                            </div>
                        </CheckboxGroup>
                      </div>
                    </div>
                  </div>
              </Split>
            </div>
            <div slot="right" style="height: 100%;margin-left:6px;">
              <Split v-model="split2" mode="vertical">
                  <div slot="top">
                    <div class="l-title l-color border-b">用户<font color="#ff6600">“{{opIndex!=-1?opData.data[opIndex].name:''}}”</font>的角色</div>
                    <div :style="'height:'+(height*split2-40)+'px' ">
                      <div class="role-list-m">
                        <div v-if="opIndex!=-1 && opData.data[opIndex].role_ids != '' && opData.data[opIndex].role_ids != null">
                          <div class="role-list item-btn" v-for="(item,index) in opData.data[opIndex].role_list" :key="item" :class="{'cur':item==roIndex}" @click="clickRole(item)">
                            <span class="title bg-text" v-if="roleData[item]">{{roleData[item].title}}</span>
                            <a href="javascript:;" @click="editRole(item,0)" class="icon iconfont">&#xe6a5;</a>
                          </div>
                        </div>
                        <div v-else class="empty-color">暂无角色权限</div>
                      </div>
                    </div>
                  </div>
                  <div slot="bottom">
                    <div class="l-title l-color border-b" style="margin-top:6px;">角色管理</div>
                    <div :style="'height:'+(height*(1-split2)-46)+'px'">
                      <div class="role-list-m">
                        <div class="role-list item-btn" v-for="(item,index) in roleData" :class="{'cur':index==roIndex}" :key="index" @click="clickRole(index)">
                          <span class="title bg-text">{{item.title}}</span>
                          <a href="javascript:;" @click.stop="editRole(index,1)" class="icon iconfont">&#xe797;</a>
                        </div>
                      </div>
                    </div>
                  </div>
              </Split>
            </div>
        </Split>
      </div>
      <div slot="right">
        <div style="overflow: hidden;">
          <div class="r-title l-color border-b">
            <span>为<font color="#ff6600">{{roIndex!=-1?('角色“'+roleData[roIndex].title+'”'):opIndex!=-1?('用户“'+opData.data[opIndex].name+'”'):''}}</font>分配权限</span>
            <Button type="primary" size="small" style="margin-left: 20px;margin-bottom: 3px;" @click="authRole">确认授权</Button>
          </div>
          <div class="power-m" :style="'height:'+(height-30)+'px;'">
            <div class="p-left" style="overflow-y:auto;'">
              <a href="javascript:;" v-for="(item,index) in powerList.menu" :key="index" @click="checkMlist(index)" :class="{'cur':menuIndex==index}" class="n-item txt-color">{{item}}</a>
            </div>
            <div class="p-right border-l" style="overflow-y:auto;'">
                <div v-for="(item,index) in powerList.mList" :key="index" v-show="index == menuIndex">
                  <div v-if="item" v-for="(val,key,i) in item" :key="key">
                    <div class="check-all">
                      <Checkbox :indeterminate="val.indeterminate" v-model="val.checkAll" @click.prevent.native="handleCheckAll(index,key)" label=""></Checkbox>
                      <a href="javascript:;" class="check-one-show bg-text" @click="showHideOne(index,key)">{{val.title}}<span class="icon iconfont">{{val.is_show?'&#xe8ed;':'&#xe8ec;'}}</span></a>
                    </div>
                    <div class="check-one" v-show="val.is_show">
                      <CheckboxGroup v-model="val.checkAllGroup" @on-change="checkAllGroupChange(index,key)">
                          <div v-for="(vv,kk) in val.children" :key="kk" class="one-c-item dropdown-bg"><Checkbox :label="kk">{{vv}}</Checkbox></div>
                      </CheckboxGroup>
                    </div>
                    <div class="height_5 all-item" v-show="Object.keys(item).length > 1 && (i+1) != Object.keys(item).length"></div>
                  </div>
                </div>
            </div>
          </div>
        </div>
      </div>
    </split-lr>
    <Modal v-model="modal" title="编辑用户" :mask-closable="false" footer-hide width="400">
       <edit-operators ref="editOperatorsRef" @addOperatorsNotify="addOperatorsNotify" @closeModal="closeModal"></edit-operators>
     </Modal>
     <Modal v-model="modal1" title="编辑角色" :mask-closable="false" footer-hide width="400">
       <edit-role ref="editRoleRef" @addRoleNotify="addRoleNotify" @closeModal="closeModal"></edit-role>
     </Modal>
  </div>
</template>
<script>
import splitLr from '@/components/public/splitLR'
import editOperators from '@/components/system_set/power/editOperators'
import editRole from '@/components/system_set/power/editRole'
var _this;
export default {
  name:'power',
  inject: ['reload'],
  components: {
    splitLr,editOperators,editRole
  },
  data () {
    return {
      reload:false,
      Breadcrumb:[{title:'资料管理'},{title:'权限管理'}],
      split:0.7,
      split1:0.7,
      split2:0.4,
      height:0,
      extendDefine:[],
      opData:{
        currentPage:1,
        total:0,
        data:[]
      },
      columns: [
          {title: '编号', key: 'code',tree: true,ellipsis:true,minWidth:80},
          {title: '姓名',resizable: true,key: 'name',minWidth:80,ellipsis:true},
          {title: '部门',resizable: true,key: 'dept_name',minWidth:150,ellipsis:true}
      ],
      roleData:null,
      menuIndex:0,
      opIndex:-1,
      roIndex:-1,
      powerList:{
        mList:null,menu:null
      },
      pitchOn:null,
      modal:false,
      modal1:false,
      employeeData:null
    }
  },
  mounted() {
    _this = this;
    this.init(false);
  },
  methods:{
    init:function(type){
      if(type) this.reload = true;
      this.common.http({
        url: 'powerInit'
      }).then(function (res) {
        if(res.status == 1){
          _this.roleData = res.ro_data;
          _this.employeeData = res.employee_data;
          _this.opData = res.op_data;
          _this.powerList = res.power_list;
          _this.extendDefine = res.extend_define;
          _this.pitchOn = JSON.parse(JSON.stringify(res.power_list.pitchOn));
          _this.handleCheckPitchOn(true)
          _this.$nextTick(function(){
            if(type) this.reload = false;
          })
        }
      }).catch(function(err){
         _this.common.httpErr(err.data,_this);
      })
    },
    checkPostChange:function(e){
      _this.common.http({
        url: 'setOpPost',data:{'op_id':this.opData.data[this.opIndex].id,'post_auth':e}
      }).then(function (res) {
        if(res.status == 1){
          _this.opData.data[_this.opIndex].post_auth = res.post_auth;
        }
      }).catch(function(err){
         _this.common.httpErr(err.data,_this);
      })
    },
    rowClassName(row, index) {
        if (index === this.opIndex) {
          return 'ivu-table-row-highlight';
        }
        return '';
    },
    handleCheckAll:function (index,key) {
      let obj = this.powerList.mList[index][key];
      obj.checkAll = obj.indeterminate?false:!obj.checkAll;
      obj.indeterminate = false;
      obj.checkAllGroup = obj.checkAll?obj.groups:[];
      this.pitchOn[index][key] =  obj.checkAll?obj.checkAllGroup:[];
      if(obj.checkAllGroup.length > 0) obj.is_show = true;
    },
    checkAllGroupChange:function (index,key) {
      let obj = this.powerList.mList[index][key];
      let tempRes = this.contrastArr( obj.checkAllGroup,Object.keys(obj.children));
      obj.checkAll = tempRes.isCheckAll;
      obj.indeterminate = tempRes.isCheckAll?false:tempRes.isCheck;
      obj.is_show = tempRes.isCheck;
      this.pitchOn[index][key] = obj.checkAllGroup;
    },
    clickRole:function(index){
      this.roIndex = index;
      if(this.roleData[index].power_ids) this.pitchOn = this.roleData[index].power_ids;
      else this.pitchOn = JSON.parse(JSON.stringify(this.powerList.pitchOn));
      this.handleCheckPitchOn(false);
    },
    cOpList:function(e,index){
      this.opIndex = index;
      this.roIndex = -1;
      if(this.opData.data[index].power_ids) this.pitchOn = this.opData.data[index].power_ids;
      else this.pitchOn = JSON.parse(JSON.stringify(this.powerList.pitchOn));
      this.handleCheckPitchOn(false);
    },
    showHideOne:function(index,key){
      let obj =  this.powerList.mList[index][key];
      this.$set(obj,'is_show',obj.is_show?false:true)
    },
    editRole:function(roleId,type){
      let cont = '';
      if(!type) cont = '<p>确定要移除用户【'+this.opData.data[this.opIndex].name+'】的“'+this.roleData[roleId].title+'”角色吗？</p>';
      else cont = '<p>确定要为用户【'+this.opData.data[this.opIndex].name+'】添加“'+this.roleData[roleId].title+'”角色吗？</p>';
      this.$Modal.confirm({
        title: '提示',
        content: cont,
        onOk: () => {
          _this.common.http({
            url: 'setOpRole',data:{'op_id':this.opData.data[this.opIndex].id,'role_id':roleId,type:type}
          }).then(function (res) {
            _this.alertMsg(res.msg,res.status?'':'error');
            if(res.status == 1){
              _this.opData.data[_this.opIndex].role_list = res.role_list;
              _this.opData.data[_this.opIndex].role_ids = res.role_ids;
            }
          }).catch(function(err){
             _this.common.httpErr(err.data,_this);
          })
        }
      })
    },
    checkMlist:function(key){
      this.menuIndex = key;
    },
    editOp:function(type){
      let data = null;
      if(!type){
        if(this.opIndex != -1){
          data = this.opData.data[this.opIndex];
        }else return;
      }
      this.$refs.editOperatorsRef.init(this.employeeData,data)
      this.modal = true;
    },
    delOp:function(){
      if(this.opIndex == -1 ) return false;
      this.$Modal.confirm({
        title: '提示',
        content: '确定要删除【'+this.opData.data[this.opIndex].name+'】用户吗？',
        onOk: () => {
          _this.common.http({
            url: 'delOp',data:{'op_id':this.opData.data[this.opIndex].id}
          }).then(function (res) {
            _this.alertMsg(res.msg,res.status?'':'error');
            if(res.status == 1){

            }
          }).catch(function(err){
             _this.common.httpErr(err.data,_this);
          })
        }
      })
    },
    editRo:function(type){
      let data = null;
      if(!type){
        if(this.roIndex != -1){
          data = this.roleData[this.roIndex];
        }else return;
      }
      this.$refs.editRoleRef.init(data)
      this.modal1 = true;
    },
    delRo:function(){
      if(this.roIndex == -1 ) return false;
      this.$Modal.confirm({
        title: '提示',
        content: '确定要删除“'+this.roleData[this.roIndex].title+'”角色吗？',
        onOk: () => {
          _this.common.http({
            url: 'delOp',data:{'op_id':this.opData.data[this.opIndex].id}
          }).then(function (res) {
            _this.alertMsg(res.msg,res.status?'':'error');
            if(res.status == 1){

            }
          }).catch(function(err){
             _this.common.httpErr(err.data,_this);
          })
        }
      })
    },
    addOperatorsNotify:function(e){
      if(e.is_up) this.$set( this.opData['data'], this.opIndex, e.data)
      else{
        this.total += 1;
        this.opData['data'].unshift(e.data)
      }
      this.modal = false;
    },
    addRoleNotify:function(e){
      if(e.is_up) this.$set( this.roleData, this.roIndex, e.data)
      else this.roleData.push(e.data)
      this.modal1 = false;
    },
    /**授权*/
    authRole:function(){
      let data = {pitch:this.pitchOn,role_id:0,operators_id:0};
      if(this.roIndex != -1) data.role_id = this.roIndex;
      else if(this.opIndex != -1){
        data.operators_id = this.opData.data[this.opIndex].id;
      }else{
        return this.alertMsg('请求参数有误','error');
      }
      this.common.http({
        url: 'setPower',data:data,
      }).then(function (res) {
        if(res.status == 1){
          if(_this.roIndex != -1){
            _this.roleData[_this.roIndex].power_ids = data.pitch;
          }else if(_this.opIndex != -1){
            _this.opData.data[_this.opIndex].power_ids = data.pitch;
          }
          _this.alertMsg('设置成功');
        }else _this.alertMsg(res.msg,'error');
      }).catch(function(err){
         _this.common.httpErr(err.data,_this);
      })
    },
    ChangePage:function(){

    },
    ChangePageSize:function(){

    },
    handleCheckPitchOn:function(type){
      let pitchOn = this.pitchOn;
      if(this.opData.total > 0 && type){
         this.opIndex = 0;
         if(this.opData.data[0].power_ids) pitchOn = this.opData.data[0].power_ids;
      }
      let indexValues = Object.keys(pitchOn);
      for(let i=0;i<indexValues.length;i++){
        let index = indexValues[i];
        let keyValues = Object.keys(pitchOn[index]);
        if(Object.keys(this.powerList.mList[index]).length <= 0) continue;
        for(let j=0;j<keyValues.length;j++){
          let key = keyValues[j];
          let powerListObj = this.powerList.mList[index][key]
          if(typeof powerListObj != 'undefined'){
            let pitchOnLast = pitchOn[index][key]?pitchOn[index][key]:[];
            let tempRes = this.contrastArr(pitchOnLast,powerListObj.groups);
            powerListObj.checkAll = tempRes.isCheckAll;
            powerListObj.indeterminate = tempRes.isCheckAll?false:tempRes.isCheck;
            powerListObj.checkAllGroup = pitchOnLast;
            if(powerListObj.checkAllGroup != null && powerListObj.checkAllGroup.length > 0) powerListObj.is_show = true;
          }
        }
      }
    },
    DHeight:function(e){
      this.height = e;
    },
    closeModal:function(e){
      console.log(e)
      this[e.modal] = false;
    }
  }
}
</script>
<style lang="less">
  .l-title,.r-title{
    display: block;width: auto;height: 30px;line-height: 30px;font-size: 16px;padding:0 10px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;
  }
  .power-m{
    width: 100%;
    .p-left{
      width: 120px;height: 100%; float: left;
      .n-item{
        padding-left: 28px;
        &.cur{
          border-right: 2px solid;background-color: unset;
        }
      }
    }
    .p-right{
      width: auto;min-width: 200px;height: 100%;margin-left: 120px;
      .all-item{
        margin: 5px 10px 0 10px;width: auto;
      }
      .check-all{
        padding:5px 10px;
        .ivu-checkbox-wrapper{
          margin-right:0;
        }
        .check-one-show{
          .icon{
            font-size: 14px;
          }
        }
      }
      .check-one{
        padding: 0 10px;
        .one-c-item{
          padding:2px 5px;
        }
      }
    }
  }
  .role-list{
    width: auto;height: 30px;line-height: 30px;white-space: nowrap;padding:0 10px;
    span{
      display: inline-block;width: 80%;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;
    }
    .icon{
      visibility: hidden;float: right;width: 20%;text-align: right;
    }
    &:hover .icon{
      visibility: visible;
    }
  }
  .role-list-m{
    height: 100%;overflow-y: auto;overflow-x: hidden;
    .post-list{
      padding: 1px 10px;background-color: unset;
    }
  }
  .empty-color{
    line-height: 80px;text-align: center;
  }
</style>
