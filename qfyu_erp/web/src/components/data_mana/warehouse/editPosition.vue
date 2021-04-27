<template>
<div>
    <Modal v-model="posmodal" title="新增/编辑仓库货位" :mask-closable="false" width="600" footer-hide>
         <Form ref="formWarePositionEdit" :model="formdata" :label-width="75" class="editpos-main">
            <Row v-if="formdata.pos_code && formdata.id>0">
                <Col span="24">
                  <FormItem label="货位编号:">
                    <Input v-model="formdata.pos_code" maxlength="30" readonly disabled></Input>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="12">
                  <FormItem label="仓库编号:">
                      <Input v-model="formdata.ware_code" maxlength="30" readonly disabled></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="" :label-width="100">
                        <Checkbox v-model="formdata.isstock" :true-value="1" :false-value="0">
                            <span>库存可用</span>
                        </Checkbox>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="12">
                  <FormItem label="所属区域:">
                      <Input v-model="formdata.pos_area" maxlength="50" placeholder="请输入所属区域"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="上次盘存日期:" :label-width="100">
                      <DatePicker type="date" v-model="formdata.inventory_date" format="yyyy-MM-dd" placeholder="上次盘存日期" :editable="false"></DatePicker>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="24">
                  <FormItem label="位置描述:">
                      <Input v-model="formdata.pos_desc" maxlength="300" placeholder="请输入位置描述"></Input>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="24">
                  <FormItem label="存放描述:">
                      <Input v-model="formdata.pos_deposit" maxlength="300" placeholder="请输入存放描述"></Input>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="24">
                  <FormItem label="备注说明:">
                      <Input v-model="formdata.remark" maxlength="300" placeholder="请输入备注说明"></Input>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="6">
                  <FormItem label="长度:" :label-width="75">
                      <Input v-model="formdata.pos_long" maxlength="30" placeholder="长度"></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="宽度:" :label-width="50">
                      <Input v-model="formdata.pos_width" maxlength="30" placeholder="宽度"></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="高度:" :label-width="50">
                      <Input v-model="formdata.pos_height" maxlength="30" placeholder="高度"></Input>
                  </FormItem>
                </Col>
                <Col span="6">
                  <FormItem label="单位:" :label-width="50">
                      <Input v-model="formdata.pos_unit" maxlength="30" placeholder="单位"></Input>
                  </FormItem>
                </Col>
            </Row>
            <Row>
                <Col span="12">
                  <FormItem label="可承载重量:" :label-width="90">
                      <Input v-model="formdata.pos_weight" maxlength="30" placeholder="可承载重量"></Input>
                  </FormItem>
                </Col>
                <Col span="12">
                  <FormItem label="单位:">
                      <Input v-model="formdata.pos_unit1" maxlength="30" placeholder="单位"></Input>
                  </FormItem>
                </Col>
            </Row>
            <Row style="margin-top:15px;">
               <Col span="24">
                  <FormItem>
                      <Button type="primary" :loading="loading" @click="handleSubmit">保存库位资料</Button>
                      <Button style="margin-left:8px" @click="closePosModal">取消</Button>
                  </FormItem>
               </Col>
            </Row>
         </Form>
    </Modal>
</div>
</template>
<script>
  var form={id:0,pos_code:'',ware_code:'',isstock:1,pos_area:'',pos_desc:'',pos_deposit:'',remark:'',pos_long:'',pos_width:'',pos_height:'',pos_unit:'',pos_weight:'',pos_unit1:'',inventory_date:''};
  export default {
      name:'editposition',
      data(){
          return {
              loading:false,
              formdata:JSON.parse(JSON.stringify(form)),
              posmodal:false
          }
      },
      methods:{
          init:function(data,warecode){
              var _this=this;
              if(data==null){
                  _this.formdata=JSON.parse(JSON.stringify(form));
                  _this.formdata.ware_code=warecode;
              }else{
                  _this.formdata=JSON.parse(JSON.stringify(data));
              }
              _this.posmodal=true;
          },
          closePosModal:function(){
              this.posmodal=false;
          },
          handleSubmit:function(){
               var _this=this;
               _this.loading=true;
               _this.common.http({url:'warepos_save',data:_this.formdata}).then(function(res){
                    _this.loading = false;
                    if(res.status==1){
                        _this.alertMsg(res.msg);
                        setTimeout(function(){
                            _this.$emit('success',res);
                            _this.closePosModal();
                        },1000);
                    }else{
                        _this.alertMsg(res.msg,'error');
                    }
               }).catch(function(err){
                    _this.loading = false;
                    _this.common.httpErr(err.data,_this);
               });
          }
      }
  }
</script>
<style>
  .editpos-main{
      width:500px;
  }
</style>
