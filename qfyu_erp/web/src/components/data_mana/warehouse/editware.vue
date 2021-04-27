<template>
  <div>
    <Modal v-model="waremodal" title="新增/编辑仓库资料" :mask-closable="false" width="800" footer-hide>
      <Form ref="formWareEdit" :rules="ruleData" :model="formdata" :label-width="100" class="wareform">
        <Row v-if="formdata && formdata.id>0">
           <Col span="12">
             <FormItem label="仓库编号:">
               <Input placeholder="请输入仓库编号" v-model="formdata.ware_code" maxlength="50" readonly disabled></Input>
             </FormItem>
           </Col>
           <Col span="12">
             <FormItem label="默认库位:">
                  <Input v-model="formdata.pos_code" placeholder="默认库位" icon="ios-more" @on-click="selectWarePos" readonly style="cursor:pointer;"></Input>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="12">
             <FormItem label="仓库名称:" prop="ware_title">
               <Input v-model="formdata.ware_title" placeholder="请输入仓库名称" maxlength="50" :show-word-limit="true" clearable></Input>
             </FormItem>
           </Col>
           <Col span="12">
              <FormItem label="上级仓库:">
                  <Input :value="formdata.parent_code" placeholder="顶级仓库" icon="ios-more" @on-click="selectParentWare" :disabled="formdata.id>0" readonly style="cursor:pointer;width:100px;float:left;"></Input>
                  <Input :value="formdata.parent_name" disabled  style="width:165px;display:inline-block;margin-left:10px;"/>
              </FormItem>
           </Col>
        </Row>
        <Row>
          <Col span="12">
              <FormItem label="所属公司:">
                <Input :value="formdata.deptid" placeholder="所属公司" icon="ios-more" @on-click="selectDepart" readonly style="cursor:pointer;width:100px;float:left;"></Input>
                <Input :value="$store.state.depart[formdata.deptid]" disabled style="width:165px;display:inline-block;margin-left:10px;"></Input>
              </FormItem>
          </Col>
          <Col span="12" style="padding-left:100px;line-height:30px;">
              <Checkbox v-model="formdata.canbyonline" :true-value="0" :false-value="1">
                  <span>不可销售</span>
              </Checkbox>
              <Checkbox v-model="formdata.canbyonsale" :true-value="0" :false-value="1">
                  <span>不可网购</span>
              </Checkbox>
          </Col>
        </Row>
        <Row>
          <Col span="12">
             <FormItem label="仓库面积:">
               <Input v-model="formdata.ware_area" placeholder="仓库面积" maxlength="50" :show-word-limit="true" clearable></Input>
             </FormItem>
          </Col>
          <Col span="12">
              <FormItem label="仓库类型:">
                  <Select v-model="formdata.type_id">
                     <Option :value="k" v-for="(p,k) in $store.state.sysParam['ware_type']" :key="k">{{p}}</Option>
                  </Select>
              </FormItem>
          </Col>
        </Row>
        <Row>
           <Col span="12">
             <FormItem label="零售价格方案:">
                <Select v-model="formdata.retail_pid">
                  <Option :value="0">未指定</Option>
                  <Option :value="p.id" v-for="(p,k) in pricelist" :key="k">({{p.id}}) {{p.name}}</Option>
                </Select>
             </FormItem>
           </Col>
           <Col span="12">
             <FormItem label="移库价格方案:">
                 <Select v-model="formdata.move_pid">
                   <Option :value="0">未指定</Option>
                   <Option :value="p.id" v-for="(p,k) in pricelist" :key="k">({{p.id}}) {{p.name}}</Option>
                 </Select>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="12">
             <FormItem label="限定售价方案:">
                <Select v-model="formdata.limit_pid">
                  <Option :value="0">未指定</Option>
                  <Option :value="p.id" v-for="(p,k) in pricelist" :key="k">({{p.id}}) {{p.name}}</Option>
                </Select>
             </FormItem>
           </Col>
           <Col span="12">
             <FormItem label="会员价格方案:" prop="name">
                 <Select v-model="formdata.user_pid">
                   <Option :value="0">未指定</Option>
                   <Option :value="p.id" v-for="(p,k) in pricelist" :key="k">({{p.id}}) {{p.name}}</Option>
                 </Select>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="12">
             <FormItem label="储存属性:">
                <Select v-model="formdata.storage_id">
                    <Option :value="k" v-for="(p,k) in $store.state.sysParam['storage']" :key="k">{{p}}</Option>
                </Select>
             </FormItem>
           </Col>
           <Col span="12">
               <FormItem label="电话:">
                   <Input v-model="formdata.phone" placeholder="电话" maxlength="50" :show-word-limit="true" clearable></Input>
               </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="12">
             <FormItem label="仓库管理员:">
                <Input :value="formdata.ware_empid" placeholder="仓库管理员" icon="ios-more" @on-click="selectEmployeeId(true)" readonly style="cursor:pointer;width:100px;float:left;"></Input>
                <Input :value="$store.state.emp[formdata.ware_empid]" disabled  style="width:165px;display:inline-block;margin-left:10px;"/>
             </FormItem>
           </Col>
           <Col span="12">
               <FormItem label="传真:">
                   <Input v-model="formdata.fax" placeholder="传真" maxlength="50" :show-word-limit="true" clearable></Input>
               </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="12">
             <FormItem label="仓库验货员:">
                <Input :value="formdata.ware_examid" placeholder="仓库验货员" icon="ios-more" @on-click="selectEmployeeId(false)" readonly style="cursor:pointer;width:100px;float:left;"></Input>
                <Input :value="$store.state.emp[formdata.ware_empid]" disabled  style="width:165px;display:inline-block;margin-left:10px;"/>
             </FormItem>
           </Col>
           <Col span="12">
                <FormItem label="所在地区:">
                   <Input v-model="formdata.region" placeholder="所在地区" maxlength="50" :show-word-limit="true" clearable></Input>
                </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="24">
             <FormItem label="仓库地址:">
                 <Input v-model="formdata.address" placeholder="仓库详细地址" maxlength="100" :show-word-limit="true" clearable></Input>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="24">
             <FormItem label="备注说明:">
                  <Input v-model="formdata.remark" placeholder="仓库备注说明" maxlength="300" :show-word-limit="true" clearable></Input>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="24">
             <FormItem>
                <Checkbox v-model="formdata.cannotice" :true-value="1" :false-value="0">
                    <span>销售时警告(当试图从此仓库销售发货时警告用户)</span>
                </Checkbox>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="24">
             <FormItem>
                <Checkbox v-model="formdata.canheadoffice" :true-value="1" :false-value="0" :disabled="formdata.id>0 && formdata.canvirtual==0">
                  <span>总部仓库（用于在直营连锁模式下区分总部与分店仓库）</span>
                </Checkbox>
             </FormItem>
           </Col>
        </Row>
        <Row>
           <Col span="24">
              <FormItem>
                <Checkbox v-model="formdata.canvirtual" :true-value="1" :false-value="0" :disabled="formdata.id>0 && formdata.canvirtual==0">
                    <span>虚拟分级仓</span>
                </Checkbox>
                <Checkbox v-model="formdata.cancomplete" :true-value="1" :false-value="0" :disabled="formdata.id>0 && formdata.canvirtual==0">
                    <span>整件仓</span>
                </Checkbox>
              </FormItem>
           </Col>
        </Row>
        <Row style="margin-top:5px;">
           <Col span="24">
              <FormItem>
                  <Button type="primary" :loading="loading" @click="handleSubmit">确认保存</Button>
                  <Button style="margin-left:8px" @click="closeModal">取消操作</Button>
              </FormItem>
           </Col>
        </Row>
      </Form>
    </Modal>
    <!-- 选择公司部门 -->
    <select-depart ref="selectDepartRef" @seldep="confirmDepart" @clear_sel="clearDepart"></select-depart>
    <!-- 选择仓库管理员与验货员 -->
    <select-employee ref="selectEmployeeRef" @selemp="confirmEmployee"></select-employee>
    <!-- 选择默认仓库货位 -->
    <choose-position ref="choosePositionRef" @confirm="confirmWarePos"></choose-position>
    <!-- 选择上级仓库 -->
    <choose-ware ref="chooseWareRef" :isClear="true" @confirm="confirmParentWare" @clear="clearParentWare"></choose-ware>
  </div>
</template>
<script>
  var form={id:0,ware_code:'',pos_code:0,ware_title:'',ware_area:'',phone:'',fax:'',region:'',address:'',remark:'',
            storage_id:0,type_id:0,deptid:'',dept_name:'',retail_pid:0,move_pid:0,limit_pid:0,user_pid:0,ware_empid:'0',
            ware_examid:'0',canbyonline:1,canbyonsale:1,canheadoffice:0,canvirtual:0,cancomplete:0,cannotice:0,parent_code:'',parent_name:''
  };
  import selectDepart from '@/components/common/SelectDepart'
  import selectEmployee from '@/components/common/SelectEmployee'
  import choosePosition from '@/components/common/ChooseWarePosition'
  import chooseWare from '@/components/common/ChooseWare'
  export default {
      name:'editware',
      components:{selectDepart,selectEmployee,choosePosition,chooseWare},
      props:{
          departData:{
              type:Array,
              default:()=>[]
          },
          pricelist:{
              type:Array,
              default:()=>[]
          }
      },
      data(){
         return {
            waremodal:false,
            loading:false,
            formdata:JSON.parse(JSON.stringify(form)),
            selectType:true,
            ruleData:{
                ware_title:[
                    {required:true,message:'请填写仓库名称',trigger:'blur'}
                ]
            }
         }
      },
      methods:{
          init:function(data){
              var _this=this;
              _this.loading=false;
              if(data==null){
                 _this.formdata=JSON.parse(JSON.stringify(form));
              }else{
                _this.formdata=JSON.parse(JSON.stringify(data));
                _this.formdata.deptid='';
                _this.formdata.dept_name='';
                if(parseInt(data.ware_deptid)>0){
                    _this.formdata.deptid=data.ware_deptid;
                    _this.formdata.dept_name=data.dept_name;
                }
                if(data.parent_code=='0') _this.formdata.parent_code="";
              }
              _this.waremodal=true;
          },
          /**
           * 选择公司部门
           */
          selectDepart:function(){
              this.$refs.selectDepartRef.init({show_self:1});
          },
          confirmDepart:function(data){
              this.formdata.deptid=data.id;
              this.formdata.dept_name=data.dept_name;
          },
          clearDepart:function(e){
              this.formdata.deptid='';
              this.formdata.dept_name='';
          },
          /*********选择仓库管理员与仓库验货员*********/
          selectEmployeeId:function(type){
              this.selectType=type;
              this.$refs.selectEmployeeRef.init({show_self:1});
          },
          confirmEmployee:function(data){
              var _this=this;
              if(_this.selectType){
                  _this.formdata.ware_empid=data.code;
                  _this.formdata.emname=data.name;
              }else{
                  _this.formdata.ware_examid=data.code;
                  _this.formdata.exname=data.name;
              }
          },
          /*************选择仓库货位*************/
          selectWarePos:function(){
              this.$refs.choosePositionRef.open(this.formdata.ware_code);
          },
          confirmWarePos:function(data){
              this.formdata.pos_code=data.pos_code;
          },
          /*************选择上级仓库***********/
          selectParentWare:function(){
              if(parseInt(this.formdata.id)>0) return false;
              this.$refs.chooseWareRef.open(true);
          },
          confirmParentWare:function(data){
              if(parseInt(this.formdata.id)>0) return false;
              if(parseInt(data.canvirtual)!=1){
                return this.alertMsg('不能给实物仓库增加下级仓库','error');
              }
              this.formdata.parent_code=data.ware_code;
              this.formdata.parent_name=data.ware_title;
          },
          clearParentWare:function(){
              this.formdata.parent_code="";
              this.formdata.parent_name="";
          },
          /**
           *  取消
           */
          closeModal:function(){
              this.waremodal=false;
          },
          /**
           *  确认保存
           */
          handleSubmit:function(){
              var _this=this;
              _this.loading=true;
              _this.$refs.formWareEdit.validate(function(valid){
                  if(valid){
                       _this.common.http({url:'ware_save',data:_this.formdata}).then(function(res){
                            _this.loading = false;
                            if(res.status==1){
                              _this.alertMsg(res.msg);
                              setTimeout(function(){
                                _this.$emit('success',_this.formdata);
                                _this.closeModal();
                              },1000);
                            }else{
                              _this.alertMsg(res.msg,'error');
                            }
                       }).catch(function(err){
                            _this.loading = false;
                            _this.common.httpErr(err.data,_this);
                       });
                  }else _this.loading=false;
              });
          }
      }
  }
</script>
<style>
  .wareform{
     width:750px;
  }
</style>
