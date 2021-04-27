<template>
  <div>
      <split-none @DHeight="DHeight" :Breadcrumb="Breadcrumb">
          <div slot="form-ser">
              <div class="nav-menu">
                <Button @click="addSettlement(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
                <Button @click="addSettlement(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
                <Button><span class="icon iconfont">&#xe793;</span>删除</Button>
              </div>
          </div>
          <div slot="table-list">
              <Table size="small" stripe :columns="columns" :data="list" border class="table-m" :height="height" :highlight-row="true" :loading="loadding" @on-row-click="(row,index)=>{selectRowData(index,false)}" @on-row-dblclick="(row,index)=>{selectRowData(index,true)}">
                   <template slot-scope="row" slot="id">{{row.index+1}}</template>
                   <template slot-scope="row" slot="cid">{{row.row.dept_name}}</template>
              </Table>
          </div>
      </split-none>
      <!--新增、修改结算方式-->
      <Modal v-model="modal" :title="title" :mask-closable="false" width="500" class-name="vertical-center-modal" footer-hide>
          <Form ref="formSettlementEdit" :rules="ruleData" :model="formdata" :label-width="100">
              <Row v-if="formdata && formdata.id>0">
                 <Col span="24">
                   <FormItem label="方式编码:">
                     <Input v-model="formdata.code" readonly disabled></Input>
                   </FormItem>
                 </Col>
              </Row>
              <Row>
                 <Col span="24">
                   <FormItem label="结算名称:" prop="name">
                     <Input placeholder="请输入结算名称" v-model="formdata.name" maxlength="50"></Input>
                   </FormItem>
                 </Col>
              </Row>
              <Row>
                 <Col span="12">
                   <FormItem label="收款期限(天):">
                        <InputNumber :max="9999" :min="0" v-model="formdata.overday"></InputNumber>
                   </FormItem>
                 </Col>
                 <Col span="12">
                     <FormItem :label-width="50">
                         <Checkbox v-model="formdata.iseffective" :true-value="1" :false-value="0">
                             <span>资料是否可用</span>
                         </Checkbox>
                     </FormItem>
                 </Col>
              </Row>
              <Row>
                 <Col span="12">
                   <FormItem label="所属部门:">
                      <Input v-model="formdata.deptid" placeholder="所属公司" icon="ios-more" @on-click="selectSettlement" readonly style="cursor:pointer;"></Input>
                   </FormItem>
                 </Col>
                 <Col span="12" style="padding-left:10px;">
                      <Input v-model="formdata.dept_name" readonly></Input>
                 </Col>
              </Row>
              <Row>
                 <Col span="24">
                   <FormItem label="备注说明:">
                      <Input v-model="formdata.remark" placeholder="备注说明" maxlength="300" :show-word-limit="true" clearable></Input>
                   </FormItem>
                 </Col>
              </Row>
              <Row style="margin-top:5px;">
                 <Col span="24">
                    <FormItem>
                        <Button type="primary" :loading="save_lock" @click="handleSubmit">确认保存</Button>
                        <Button style="margin-left:8px" @click="closeModal">取消</Button>
                    </FormItem>
                 </Col>
              </Row>
          </Form>
      </Modal>
      <!-- 选择部门 -->
      <select-depart ref="selectSettlementRef" @seldep="confirmDepart" @clear_sel="clearDepart"></select-depart>
  </div>
</template>
<script>
   import splitNone from '@/components/public/splitNone'
   import selectDepart from '@/components/common/SelectDepart'
   var _this;
   var form={id:0,code:'',name:'',overday:0,deptid:'',dept_name:'',remark:'',iseffective:1};
   export default {
     components:{splitNone,selectDepart},
      data(){
          return {
              height:0,
              Breadcrumb: [{title: '资料管理'}, {title: '结算方式'}],
              columns:[
                  {title:'序号',slot:'id',width:70,fixed:'left',align:'center'},
                  {title:'方式编码',key:'code',width:120,align:'center'},
                  {title:'结算名称',key:'name',minWidth:150},
                  {title:'收（付）款天数',key:'overday',minWidth:150},
                  {title:'所属部门名称',slot:'cid',minWidth:150},
                  {title:'备注说明',key:'remark'}
              ],
              loadding:false,
              departlist:[],
              list:[],
              modal:false,
              title:'新增结算方式',
              selectIndex:0,
              formdata:JSON.parse(JSON.stringify(form)),
              save_lock:false,
              ruleData:{
                  name:[
                      {required:true,message:'请填写结算名称',trigger:'blur'}
                  ]
              },
          }
      },
      created:function(){
          _this=this;
          _this.init();
      },
      methods:{
          DHeight(e){
            this.height = e;
          },
          init:function(){
              _this.wloading=true;
              _this.common.http({url:'settlementList',data:{}}).then(function(res){
                  if(res.status==1){
                      _this.list=res.list;
                      _this.departlist=res.BranchDepart;
                      _this.list[_this.selectIndex]._highlight=true;
                  }
              }).catch(function(err){
                   _this.common.httpErr(err.data,_this);
              });
          },
          addSettlement:function(type){
             _this.title=type?'编辑结算方式':'新增结算方式';
             _this.formdata=JSON.parse(JSON.stringify(form));
             if(type){
                _this.formdata=JSON.parse(JSON.stringify(_this.list[_this.selectIndex]));
                _this.formdata.depart=[_this.formdata.cid,_this.formdata.deptid];
             }
             _this.modal=true;
          },
          selectRowData:function(index,type){
             _this.selectIndex=index;
             if(type) _this.addSettlement(true);
          },
          closeModal:function(){
             _this.modal=false;
          },
          /**
           * 选择部门
           */
          selectSettlement:function(){
              _this.$refs.selectSettlementRef.init({show_self:1});
          },
          confirmDepart:function(data){
              _this.formdata.deptid=data.id;
              _this.formdata.dept_name=data.dept_name;
          },
          clearDepart:function(){
              _this.formdata.deptid='';
              _this.formdata.dept_name='';
          },
          /**
           * 保存提交结算方式
           */
          handleSubmit:function(){
              if(_this.save_lock) return false;
              _this.$refs.formSettlementEdit.validate(function(valid){
                  if(valid){
                       _this.save_lock=true;
                       _this.common.http({url:'saveSettlement',data:_this.formdata}).then(function(res){
                            _this.save_lock = false;
                            if(res.status==1){
                               _this.alertMsg(res.msg);
                               _this.init();
                               _this.modal=false;
                            }else{
                              _this.alertMsg(res.msg,'error');
                            }
                       }).catch(function(err){
                            _this.save_lock = false;
                            _this.common.httpErr(err.data,_this);
                       });
                  }else _this.save_lock=false;
              });
          }
      }
   }
</script>
<style lang="less">
  .vertical-center-modal{
      display:flex;
      align-items:center;
      justify-content:center;
      .ivu-modal{
          top:0;
      }
  }
</style>
