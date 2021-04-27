<template>
  <div>
  <split-none ref="splitPageRef" :Breadcrumb="Breadcrumb" @DHeight="dHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="editD(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="editD(1)"><span class="icon iconfont">&#xe791;</span>编辑</Button>
          <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
          <Divider type="vertical" />
          <Button @click="init"><span class="icon iconfont">&#xe791;</span>刷新</Button>
          <Divider type="vertical" />
          <Button><span class="icon iconfont">&#xe791;</span>筛选</Button>
        </div>
      </div>
      <div slot="table-list">
         <Table id="table-m" border stripe  size="small" :columns="columns" :loading="loading" :data="data" :rowClassName="rowClassName" :height="height" @on-row-click="(row,index)=>{selectRowIndex(index,false)}" @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}">>

         </Table>
      </div>
    </split-none>
    <edit-entrust ref="editEntrustRef" @addNotify="addNotify"></edit-entrust>
  </div>
</template>
<script>
  import splitNone from '@/components/public/splitNone'
  import editEntrust from '@/components/data_mana/entrust/edit'
  export default {
    name:'entrust',
    components: {
      splitNone,editEntrust
    },
    data () {
      return {
        Breadcrumb:[{title:'资料管理'},{title:'委托物流单位'}],
        loading:false,
        columns:[
           { title: "编号",key: "id",width: 80,align:'center'},
           { title: "公司名称",key: "company",resizable: true,width: 120,tooltip:true},
           { title: "公司地址",key: "addr",width: 150,resizable: true},
           { title: "联系人",key: "contact",width: 100,resizable: true},
           { title: "联系人身份证号",key: "card_id",width: 150,resizable: true},
           { title: "联系人手机",key: "phone",width: 120,resizable: true},
           { title: "联系人电话",key: "tel",width: 120,resizable: true},
           { title: "营业执照",key: "business_license",width: 120,resizable: true},
           { title: "营业执照有效期",key: "business_validity_date",width: 120,resizable: true},
           { title: "合同有效期",key: "contract_validity_date",width: 120,resizable: true},
           { title: "承运范围",key: "scope_carriage",width:150,resizable: true},
           { title: "运输方式",key: "ship_type",width: 100,resizable: true},
           { title: "备注",key: "remark",width: 200,resizable: true}
        ],
        data:[],
        checkIndex:0,
        height:0
      }
    },
    created:function(){
      this.init();
    },
    methods:{
      init:function(type){
        let _this = this;
        this.loading = true;
        _this.common.http({
          url: 'entrustList',data:{fdata:_this.formData}
        }).then(function (res) {
          _this.data = res.data;
          _this.$nextTick(function(){
            _this.loading = false;
          })
        }).catch(function(err){
          _this.loading = false;
          _this.common.httpErr(err.data,_this);
        })
      },
      rowClassName(row,index){
        if (index === this.checkIndex) {
            return 'ivu-table-row-highlight';
        }
        return '';
      },
      editD:function(type){
        if(type) this.selectRowIndex(this.checkIndex,true);
        else this.$refs.editEntrustRef.open();
      },
      selectRowIndex:function(index,type){
        this.checkIndex = index;
        let data = null;
        if(type){
         if(this.checkIndex != -1){
           data = this.data[this.checkIndex];
           this.$refs.editEntrustRef.open(data);
         }else{
           return this.alertMsg('请选择需要修改的信息','error')
         }
        }
      },
      addNotify:function(e){
        this.$refs.editEntrustRef.close();
        this.init();
      },
      dHeight:function(e){
        this.height = e;
      },
      ChangePage:function(e){
        this.page = e;
        this.init();
      },
      ChangePageSize:function(e){
        this.pageSize = e;
        this.page = 1;
        this.init();
      }
    }
  }
</script>
