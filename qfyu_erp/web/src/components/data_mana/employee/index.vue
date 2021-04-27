<template>
  <div>
  <split-none ref="splitPageRef" :total='total' :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="addStaff(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="addStaff(1)"><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button @click="delStaff()"><span class="icon iconfont">&#xe793;</span>删除</Button>
          <Divider type="vertical" />
          <Button><span class="icon iconfont">&#xe791;</span>报表</Button>
          <Divider type="vertical" />
          <Button @click="init"><span class="icon iconfont">&#xe791;</span>刷新</Button>
          <Divider type="vertical" />
          <Button @click="serM = true"><span class="icon iconfont">&#xe791;</span>筛选</Button>
        </div>
        <Drawer width="320" title="筛选条件" :closable="true" v-model="serM">
            <div class="ser-form">
              <Form ref="formCustom" :label-width="80">
                <FormItem label="用户编号">
                   <Input type="text" v-model="serData.code" placeholder="用户编号" ></Input>
                </FormItem>
                <FormItem label="姓名">
                   <Input type="text" v-model="serData.name" placeholder="姓名"></Input>
                </FormItem>
                <FormItem label="手机号">
                   <Input type="text" v-model="serData.phone" placeholder="手机号"></Input>
                </FormItem>
                <FormItem label="部门编号:" prop="depart">
                  <Input v-model="serData.depart"></Input>
                </FormItem>
                <FormItem label="在职状态:">
                  <Select v-model="serData.status">
                     <Option :value='1'>在职</Option>
                     <Option :value='0'>离职</Option>
                  </Select>
                </FormItem>
                <FormItem>
                    <Button @click="serM = false">取消</Button>
                    <Button type="primary" @click="serSub">确定</Button>
                </FormItem>
              </Form>
            </div>
        </Drawer>
      </div>
      <div slot="table-list">
         <Table id="table-m" border stripe  size="small" :columns="columns" :loading="loading" :data="data" :rowClassName="rowClassName" :height="height-40" @on-row-click="checkOne" @on-row-dblclick="edit">
          <template slot-scope="{row}" slot="status">
             <div :style="'color:'+(row.status==1?'green':'gray')">{{row.status==1?'在职':'离职'}}</div>
           </template>
           <template slot-scope="{row}" slot="edu">
             {{eduData?eduData[row.edu]:''}}
           </template>
         </Table>
         <div class="page-m">
           <Page :total="total" :page-size="pageSize" size="small" show-total show-elevator :page-size-opts="[20,50,80]" show-sizer @on-change="ChangePage" @on-page-size-change="ChangePageSize"/>
         </div>
      </div>
    </split-none>
    <Modal v-model="editModal" :mask-closable="false" title="新增/修改员工资料" width="800" footer-hide>
        <edit-staff ref="editEmployeeRef" :eduData="eduData" :dutiesData="dutiesData" @closeModal="closeModal" @addEmployeeNotify="addEmployeeNotify"></edit-staff>
    </Modal>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import editStaff from '@/components/data_mana/employee/edit_emp'
  var _this;
  export default {
    name:'employee',
    inject: ['reload'],
    components: {
      splitNone,editStaff
    },
    data () {
      return {
        Breadcrumb:[{title:'资料管理'},{title:'员工资料'}],
        editModal:false,
        serM:false,
        height:0,
        total:0,
        pageSize:20,
        page:1,
        eduData:this.$store.state.sysParam['edu'],
        dutiesData:[],
        loading:false,
        columns: [
           { type: 'selection',width: 60,fixed: "left"},
           { title: "编号",key: "code",width: 80},
           { title: "姓名",key: "name",resizable: true,width: 120},
           { title: "性别",width: 80,render(e,val){return e('div',{},val.row.sex==1?'男':'女')}},
           { title: "籍贯",key: "native_place",resizable: true,width: 100,align: "center"},
           { title: "联系电话",key: "phone",resizable: true,width: 120,align: "center"},
           { title: "身份证号",key: "card_id",resizable: true,width: 150,tooltip:true,align: "left"},
           { title: "所属部门",key: "depart_name",resizable: true,width: 120,align: "center"},
           { title: "职务",key: "duties",resizable: true,width: 120,align: "center"},
           { title: "是否在职",slot: "status",resizable: true,width: 100,align: "center"},
           { title: "技术职称",key: "tech_title",resizable: true,width: 120,tooltip:true,align: "center"},
           { title: "执业资格",key: "seniority",resizable: true,width: 120,tooltip:true,align: "center"},
           { title: "学历",slot: "edu",resizable: true,width: 100,align: "center"},
           { title: "入职日期",key: "entry_date",resizable: true,width: 120,align: "center"}
        ],
        data: [],
        serData:{
          code:'',name:'',phone:'',status:-1,depart:null,
        },
        checkIndex:-1
      }
    },
    created:function(){
      _this = this;
      this.init(1);
    },
    methods:{
      init:function(type){
        this.loading = true;
        this.common.http({
          url: 'employeeInit',data:{type:type,page:this.page,pageSize:this.pageSize,ser_data:this.serData}
        }).then(function (res) {
          if(res.status == 1){
            if(type){
              _this.dutiesData = res.duties;
            }
            _this.data = res.data.data;
            _this.total = res.data.total;
          }
          _this.$nextTick(function(){
            if(res.data.data.length > 0) this.checkIndex = 0;
            else _this.checkIndex = -1;
            _this.serM = false;
            _this.loading = false;
          })
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      },
      rowClassName(row,index){
        if (index === this.checkIndex) {
            return 'ivu-table-row-highlight';
        }
        return '';
      },
      addEmployeeNotify:function(e){
        if(e.is_up) this.$set( this.data, this.checkIndex, e.data)
        else{
          this.total += 1;
          this.data.unshift(e.data)
        }
        this.checkIndex = -1;
        this.closeModal();
      },
      closeModal:function(){
        this.editModal = false;
      },
      addStaff:function(type){
        let data = null;
        if(type){
          if(this.checkIndex != -1){
            data = this.data[this.checkIndex];
          }else{
            return this.alertMsg('请选择需要修改的信息','error')
          }
        }
        this.$refs.editEmployeeRef.init(data)
        this.editModal = true;
      },
      delStaff:function(){

      },
      checkOne:function(item,index){
        this.checkIndex = index
      },
      edit:function(item,index){
        this.checkIndex = index;
        this.addStaff(true);
      },
      dHeight:function(e){
        this.height = e;
      },
      ChangePage:function(e){
        this.page = e;
        this.init(0);
      },
      ChangePageSize:function(e){
        this.pageSize = e;
        this.page = 1;
        this.init(0);
      },
      serSub:function(){
        this.init(0);
      }
    }
  }
</script>
