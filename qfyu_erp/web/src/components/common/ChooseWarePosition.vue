<template>
 <div>
    <Modal v-model="modal" title="选择货位" :mask-closable="false" class-name="warepos-center-modal" width="1000" footer-hide>
        <Table size="small" stripe :columns="columns"  :data="list" border class="table-m" :height="400"
            :loading="loading" :row-class-name="rowClassName"
            @on-row-click="(row,index)=>{selectRow(index,false)}"
            @on-row-dblclick="(row,index)=>{selectRow(index,true)}">
            <template slot-scope="row" slot="isstock">
                <Checkbox v-model="row.row.isstock" :true-value="1" :false-value="0" disabled></Checkbox>
            </template>
        </Table>
        <div class="warepos_select">
           <div class="left">
               <Input v-model="search.pos_code" placeholder="按货位编码查询" class="inputs" maxlength="50">
                   <span slot="prepend">查找:</span>
                   <Button @click="doSearch" slot="append" icon="ios-search"></Button>
               </Input>
               <Button @click="confirm" type="primary">
                  <Icon type="md-checkmark"/>选定
               </Button>
               <Button @click="close" type="warning" style="margin-left:10px;">
                  <Icon type="md-close" />取消
               </Button>
           </div>
           <div class="right"><div class="ident_dot red-bg"></div>表示库存不可用
           </div>
        </div>
    </Modal>
 </div>
</template>
<script>
    export default {
      name:'chooseWarePos',
      data(){
        return {
           modal:false,
           loading:false,
           ware_code:"",
           columns:[
               {title:'序号',type:'index',width:70,fixed:'left',align:'center'},
               {title:'货位编号',key:'pos_code',resizable:true,width:100,fixed:'left'},
               {title:'所属区域',key:'pos_area',resizable:true,minWidth:100},
               {title:'可承重量',key:'pos_weight',resizable:true,minWidth:100},
               {title:'重量单位',key:'pos_unit1',resizable:true,minWidth:100},
               {title:'长度',key:'pos_long',resizable:true,minWidth:100},
               {title:'宽度',key:'pos_width',resizable:true,minWidth:100},
               {title:'高度',key:'pos_height',resizable:true,minWidth:100},
               {title:'长度单位',key:'pos_unit',resizable:true,minWidth:100},
               {title:'位置描述',key:'pos_desc',resizable:true,minWidth:150},
               {title:'存放描述',key:'pos_deposit',resizable:true,minWidth:150},
               {title:'库存可用',slot:'isstock',width:90,align:'center'},
               {title:'备注',key:'remark',resizable:true,minWidth:150}
           ],
           list:[],
           selectIndex:-1,
           search:{pos_code:''}
        }
      },
      methods:{
         rowClassName(row, index) {
            var className = '';
            if (index === this.selectIndex) {
                className+='ivu-table-row-highlight';
            }
            if(row.isstock==0){
               className+=' red-text';
            }
            return className;
         },
         init:function(){
            var _this=this;
            _this.loading=true;
            var data={ware_code:_this.ware_code,search:_this.search};
            _this.common.http({url:'warepos_list',data:data}).then(function(res){
                _this.loading=false;
                if(res.status==1){
                    _this.list=res.list;
                }
            }).catch(function(err){
                 _this.common.httpErr(err.data,_this);
            });
         },
         open:function(ware_code){
            this.ware_code=ware_code;
            this.init();
            this.modal=true;
         },
         close:function(){
            this.modal=false;
         },
         /**
          * 确认选定
          */
         confirm:function(){
            if(this.selectIndex<0){
              return this.alertMsg('请选择货位','error');
            }
            this.$emit("confirm",this.list[this.selectIndex]);
            this.close();
         },
         /**
          * 表格单击、双击选择
          * @param index 选择索引
          * @param type true:双击
          */
         selectRow:function(index,type){
             this.selectIndex=index;
             if(type) this.confirm();
         },
         /**
          * 搜索
          */
         doSearch:function(){
            this.init();
         }
      }
    }
</script>
<style lang="less">
  .warepos-center-modal{
      display:flex;
      align-items:center;
      justify-content:center;
      .ivu-modal{top:0;}
  }
  .warepos_select{
    padding-top:15px;padding-bottom:10px;overflow:hidden;
    .left{
       width:50%;float:left;
       .inputs{
          width:280px;margin-right:20px;display:inline-table;cursor:pointer;
       }
    }
    .right{
       width:50%;float:right;text-align:left;margin-top:5px;
    }
  }
</style>
