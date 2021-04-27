<template>
  <Modal v-model="ModVal" title="选择客户选择人员(联系人)" width="1000" footer-hide :mask-closable="false">
    <Table border :columns="columns" :row-class-name="rowClassName" :data="data" size="small" height="450" :loading="table_loading"
     @on-row-click="(row,index)=>{selectRowIndex(index,false)}"
     @on-row-dblclick="(row,index)=>{selectRowIndex(index,true)}"
    >
      <template slot-scope="{row}" slot="check_status">
        <Checkbox :value="row.check_status" :true-value="1" :false-value="0" disabled></Checkbox>
      </template>
       <template slot-scope="{row}" slot="attorney_validity">
        <Checkbox :value="row.attorney_validity" :true-value="0" :false-value="1" disabled></Checkbox>
      </template>
    </Table>
    <div class="cust-sales-main">
      <div class="serleft">
        <Input v-model="keyword" placeholder="按姓名/电话/手机" @on-enter="initData">
          <span slot="prepend">查找:</span>
          <Button slot="append" icon="ios-search" @click="initData"></Button>
        </Input>
      </div>
      <div class="selbtngroup">
        <Button type="primary" icon="md-checkmark" @click="comItem">选定</Button>
        <Button type="error" icon="md-close" style="margin-left: 15px;" @click="ModVal=false">取消</Button>
        <Button type="default" icon="ios-trash" style="margin-left: 15px;" @click="clear_sel" v-if="show_clear">删除已选</Button>
      </div>
    </div>
  </Modal>
</template>
<script>
    export default{
      name:'SelectCustomerSales',
      props:{
        show_clear:{
          type:Boolean,
          default:false
        }
      },
      data(){
        return{
          ModVal:false,
          table_loading:true,
          checkIndex:-1,
          columns: [
            {title:'客户编号',key:'cid',width:80,resizable:true,ellipsis :true},
            {title:'姓名',key:'user_name',width:120,resizable:true,ellipsis :true},
            {title:'性别',width: 80,render(e,val){return e('div',{},val.row.sex==1?'男':'女')}},
            {title:'部门',key:'depart',width:90,resizable:true,ellipsis :true},
            {title:'职务',key:'duties',width:100,resizable:true,ellipsis :true},
            {title:'移动电话',key:'tel',width:103,resizable:true,ellipsis :true},
            {title:'办公电话',key:'phone',width:105,resizable:true,ellipsis :true},
            {title:'住址',key:'address',width:180,resizable:true,ellipsis :true},
            {title:'委托书编号',key:'attorney_no',width:80,align:'center'},
            {title:'委托书有效期',key:'validity_date',width:80,align:'center'},
            {title:'委托书已失效',slot:'attorney_validity',width:80,align:'center'},
            {title:'合格',slot:'check_status',width:80,align:'center'}
          ],
          data:[],
          keyword:'',
          custNo:'',
          type:0
        }
      },
      methods:{
        open:function(custNo,type,ModVal){
          this.custNo = custNo;
          this.ModVal = ModVal || false;
          this.type = type || 0;
          this.initData();
        },
        initData:function(){
          let _this=this;
          _this.common.http({url:'selectCustomerSales',data:{type:this.type,cust_no:this.custNo,keyword:this.keyword}}).then(function(res){
            _this.table_loading = false;
            if(res.status==1) _this.data = res.data;
            _this.$nextTick(function(){
              if(res.data.length > 0){
                _this.checkIndex = 0;
              }
              if(_this.type == 1 && !_this.ModVal){
                _this.selectRowIndex(0,1,true);
              }
            })
          }).catch(function(err){
              _this.common.httpErr(err.data,_this);
          });
        },
        selectRowIndex:function(index,type,isCheckIndex){
          isCheckIndex = isCheckIndex || false;
          this.checkIndex = index;
          if(type) this.comItem(isCheckIndex);
        },
        comItem:function (isCheckIndex) {
          let data = null;
          if(!isCheckIndex && this.checkIndex == -1) return this.modalMsg('请选择有效信息！','error');
          else if(this.checkIndex != -1){
            data = this.data[this.checkIndex];
          }
          this.$emit('selCustSales',{data:data,is_check:isCheckIndex});
          this.ModVal = false;
        },
        rowClassName(row, index) {
          let className = '';
          if (index === this.checkIndex) {
            className = 'ivu-table-row-highlight';
          }
          if(row.check_status == 0){
            className += ' yellow-text';
          }
          return className;
        },
        clear_sel:function () {
          this.$emit('clear_sel');
          this.ModVal = false;
        }
      }
    }
</script>
<style lang="less">
  .cust-sales-main{
    padding-top:20px;height: 50px;
    .selcust-page{
      float: left; margin:3px 30px 0 0;
    }
    .serleft{
      float: left; width: 360px;
    }
    .selbtngroup{
      float: left; margin-left: 50px;
    }
  }
</style>
