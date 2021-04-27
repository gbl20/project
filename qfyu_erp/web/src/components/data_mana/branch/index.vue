<template>
  <div>
    <split-lr ref="splitPageRef" @DHeight="DHeight" :Breadcrumb="Breadcrumb" :splitInit=0.2>
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="addCompany(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="addCompany(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
          <Divider type="vertical" />
          <Button @click="addDepart(false)"><span class="icon iconfont">&#xe797;</span>新增部门</Button>
          <Button @click="addDepart(true)"><span class="icon iconfont">&#xe791;</span>编辑部门</Button>
          <Button><span class="icon iconfont">&#xe793;</span>删除部门</Button>
          <Divider type="vertical" />
          <Button @click="reload"><span class="icon iconfont">&#xe791;</span>刷新</Button>
        </div>
      </div>
      <div slot="left">
        <div class="l-title l-color">所有公司</div>
        <div class="company-l">
          <RadioGroup vertical v-model="cIndex">
            <Radio v-for="(item,index) in company" :key="index" :label="index">{{item.dept_name}}</Radio>
          </RadioGroup>
        </div>
      </div>
      <div slot="right">
        <div class="r-title l-color">部门管理</div>
        <Table ref="departTable" highlight-row border stripe size="small" :columns="columns" :data="depart[cId]" :height="height-30" @on-row-click="(row,index)=>{onRowDepart(row,index,false)}" @on-row-dblclick="(row,index)=>{onRowDepart(row,index,true)}"></Table>
      </div>
    </split-lr>
    <Modal v-model="modal1" title="新增企业机构资料" :mask-closable="false" footer-hide width="800">
        <edit-company ref="editCompanyRef" @addCompanyNotify="addCompanyNotify" @closeModal="closeModal"></edit-company>
     </Modal>
     <Modal v-model="modal2" title="编辑部门" :mask-closable="false" footer-hide width="500">
        <edit-depart ref="editDepartRef" :company="company" :chooseId="cId" @addDepartNotify="addDepartNotify" @closeModal="closeModal"></edit-depart>
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
 import editCompany from '@/components/data_mana/branch/editCompany'
 import editDepart from '@/components/data_mana/branch/editDepart'
 var _this;
 export default {
    name:'branch',
    inject: ['reload'],
    components: {
      splitLr,editCompany,editDepart
    },
    data () {
      return {
        Breadcrumb:[{title:'资料管理'},{title:'企业机构管理'}],
        modal2:false,
        modal1: false,
        cId:0,
        cIndex:0,
        height:0,
        company: [],
        depart: [],
        columns: [
          {title: '编号',key: 'id',width: 100,fixed: 'left'},
          {title: '部门名称',resizable: true,key: 'dept_name',fixed: 'left',width: 100},
          {title: '负责人',resizable: true,key: 'leader',width: 100},
          {title: '电话',resizable:true,key: 'tel',width: 120,tooltip:true},
          {title: '传真',resizable: true,key: 'fax',width: 100,tooltip:true},
          {title: '地址',resizable: true,key: 'address',width: 150,tooltip:true},
          {title: '创建者',key:'creator',width:100,tooltip:true},
          {title: '创建日期',key:'create_time',width:100,tooltip:true},
          {title: '更新日期',key:'re_time',width:100,tooltip:true}
        ],
        editDepartIndex:0
      }
    },
    mounted:function() {
      _this = this;
    },
    watch:{
      cIndex(index){
        this.cId = this.company[index].id;
      },
      cId(cid){
        if(this.depart[cid].length){
          this.depart[cid][0]._highlight = true
        }
        if(this.editDepartIndex){
          this.editDepartIndex = 0;
        }
      }
    },
    created:function(){
      this.$init();
    },
    methods:{
      $init:function(){
        this.common.http({
          url: 'branchList'
        }).then(function (res) {
          if(res.status == 1){
            _this.company = res.company;
            _this.depart = res.depart;
            _this.cId = res.c_id;
            if(_this.depart[_this.cId].length) _this.depart[_this.cId][0]._highlight = true
          }
        }).catch(function(err){
			_this.common.httpErr(err.data,_this);
		})
      },
      onRowDepart:function(departData,index,type){
        this.editDepartIndex = index;
        if(type && this.depart[this.cId].length){
          this.$refs.editDepartRef.init(this.depart[this.cId][index]);
          this.modal2 = true;
        }
      },
      addDepart:function(type){
        let data = null;
        if(type){
          if(this.depart[this.cId].length){
            data = this.depart[this.cId][this.editDepartIndex];
          }else return;
        }
        this.$refs.editDepartRef.init(data);
        this.modal2 = true;
      },
      addCompany:function(type){
        let data = null;
        if(type) data = this.company[this.cIndex];
        this.$refs.editCompanyRef.init(data);
        this.modal1 = true;
      },
      addCompanyNotify:function(e){
        if(e.is_up) this.$set(this.company, this.cIndex, e.data)
        else{
          this.company.push(e.data)
          this.depart[e.data.id].push([])
        }
        this.modal1 = false;
      },
      addDepartNotify:function(e){
        if(e.is_up) this.$set( this.depart[e.data.branch_id], this.editDepartIndex, e.data)
        else this.depart[e.data.branch_id].push(e.data)
        this.modal2 = false;
      },
      DHeight:function(e){
        this.height = e;
      },
      closeModal:function(e){
        this[e.modal] = false;
      }
    }
}
</script>
