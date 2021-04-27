<template>
  <Modal v-model="show_self" width="720" :closable="false" title="客户采购人(联系人管理)" class-name="edcont">
    <div class="company_name">客户名称：{{company.name||''}}</div>
    <Form ref="formProData" :model="data" :label-width="65">
      <Row>
        <Col span="8" style="padding-right: 5px;">
          <FormItem label="姓名">
            <Input v-model="data.user_name"></Input>
          </FormItem>
          <FormItem label="性别">
            <Select v-model="data.sex">
              <Option :value="1">男</Option>
              <Option :value="2">女</Option>
            </Select>
          </FormItem>
          <FormItem label="部门">
            <Input v-model="data.depart"></Input>
          </FormItem>
          <FormItem label="职务">
            <Input v-model="data.duties"></Input>
          </FormItem>
          <FormItem label="手机号">
            <Input v-model="data.tel"></Input>
          </FormItem>
          <FormItem label="办公电话">
            <Input v-model="data.phone"></Input>
          </FormItem>
          <FormItem label="邮箱">
            <Input v-model="data.email"></Input>
          </FormItem>
          <FormItem label="创建人">
            <Input v-model="data.creator" disabled></Input>
          </FormItem>
          <FormItem label="创建日期">
            <Input v-model="data.create_date" disabled></Input>
          </FormItem>
        </Col>
        <Col span="16" style="padding: 5px; border: 1px dotted #ed4014;">
          <Row>
            <Col span="16">
              <FormItem label="委托书编号" :label-width="80">
                <Input v-model="data.attorney_no" @on-change="clear_checkstatus"></Input>
              </FormItem>
            </Col>
            <Col span="8">
              <FormItem label="" :label-width="30">
                <Checkbox v-model="data.status" :true-value="1" :false-value="0" @on-change="clear_checkstatus">资料有效</Checkbox>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <FormItem label="委托书授权内容" :label-width="80">
              <Input type="textarea" maxlength="2000" show-word-limit v-model="data.attorney_content" :autosize="{minRows:3,maxRows: 3}" @on-change="clear_checkstatus"></Input>
            </FormItem>
          </Row>
          <Row>
              <FormItem label="委托书有效期" :label-width="80">
                <DatePicker type="date" v-model="data.validity_date" transfer @on-change="clear_checkstatus"></DatePicker>
              </FormItem>
          </Row>
          <div class="attention-msg">*提示：修改以上4项资料审核合格将失效</div>
          <Row>
            <Col span="13">
              <FormItem label="销售部负责人" :label-width="80">
                <Input v-model="data.salesdepart" icon="md-checkmark" :disabled="checkDisabled" readonly style="cursor: pointer;" @on-click="chooseOp('sales_depart')"></Input>
              </FormItem>
            </Col>
            <Col span="11">
              <FormItem label="审核日期" :label-width="80">
                <DatePicker type="date" v-model="data.salesdepart_date" transfer :disabled="true"></DatePicker>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="13">
              <FormItem label="质量管理部负责人" :label-width="80">
                <Input v-model="data.qcdepart" icon="md-checkmark" :disabled="checkDisabled" readonly style="cursor: pointer;" @on-click="chooseOp('quality_depart')"></Input>
              </FormItem>
            </Col>
            <Col span="11">
              <FormItem label="审核日期" :label-width="80">
                <DatePicker type="date" v-model="data.qcdepart_date" transfer :disabled="true"></DatePicker>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="13">
              <FormItem label="质量负责人" :label-width="80">
                <Input v-model="data.qcid" icon="md-checkmark" :disabled="checkDisabled" readonly style="cursor: pointer;" @on-click="chooseOp('quality_director')"></Input>
              </FormItem>
            </Col>
            <Col span="11">
              <FormItem label="审核日期" :label-width="80">
                <DatePicker type="date" v-model="data.qc_date" transfer :disabled="true"></DatePicker>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="7">
              <FormItem label="" :label-width="10">
                <Checkbox v-model="data.check_status" :true-value="1" :false-value="0" :disabled="checkDisabled" disabled>已审核合格</Checkbox>
              </FormItem>
            </Col>
            <Col span="17">
              <div class="proa-msg">*审核合格的是客户采购人员，未审核的是联系人</div>
            </Col>
          </Row>
        </Col>
      </Row>
      <Row style="margin-top: 5px;">
        <FormItem label="地址">
          <Input v-model="data.address"></Input>
        </FormItem>
      </Row>
      <Row>
        <FormItem label="备注">
          <Input type="textarea" maxlength="500" show-word-limit v-model="data.remark" :autosize="{minRows:3,maxRows: 3}"></Input>
        </FormItem>
      </Row>
    </Form>
    <verify-user ref="verifyUserRef" :postCode="postCode" :paramData="{id:data.id}" processingMethod="checkContact" @confirm="confirmOp"></verify-user>
    <div slot="footer">
      <Button type="text" @click="hide_self">取 消</Button>
      <Button type="primary" @click="sub_contact">确 定</Button>
    </div>
  </Modal>
</template>
<script>
import verifyUser from '@/components/common/VerifyUser'
    export default{
        name:'EditContacts',
        components:{verifyUser},
        props:{},
        data(){
          return{
            show_self:false,
            data: {},
            company:{},
            checkDisabled:true,
            postCode:'',
            canClose:true
          }
        },
        methods:{
          init:function(params){
            var _this=this;
            this.canClose=true;
            if(typeof(params)=="undefined") return false;
            this.show_self=true;
            this.company=params.company;
            this.checkDisabled=params.id?false:true;
            _this.common.http({url:'editContact',data:{id:params.id}}).then(function(res){
              if(res.status==1) _this.data=res.data;
            }).catch(function(err){
                _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 保存联系人
           */
          sub_contact:function (){
            var _this=this;
            this.data.user_name=this.data.user_name.trim();
            if(this.data.user_name==''){
              this.alertMsg('联系人姓名必填','error');
              return false;
            }
            var data=this.data;
            data.cid=this.company.id;
            this.common.http({url:'saveCustContact',data:data}).then(function(res){
              if(res.status==1){
                _this.$parent.get_contact(data.cid);
                _this.show_self=false;
                _this.alertMsg(res.msg,'success');
              }else{
                _this.alertMsg(res.msg,'error');
              }
            }).catch(function(err){
              _this.common.httpErr(err.data,_this);
            });
          },
          /**
           * 关闭自身
           */
          hide_self:function (){
            if(this.canClose) this.show_self=false;
            else this.modalMsg('进行审核操作后，不能取消修改!')
          },
          /**
           * 选择审核人
           */
          chooseOp:function(post_code){
            if(!this.data.id) return false;
            if(post_code == 'quality_depart' && (!this.data.salesdepart || this.data.salesdepart.length < 1)){
              return this.modalMsg('销售部负责人尚未审核!');
            }else if(post_code == 'quality_director' && (!this.data.qcdepart || this.data.qcdepart.length < 1)){
              return this.modalMsg('质量管理部负责人尚未审核!')
            }
            this.postCode = post_code;
            this.$refs.verifyUserRef.open();
          },
          /**
           * 确认选择审核人
           */
          confirmOp:function (e){
            this.canClose = false;
            if(this.postCode == 'sales_depart'){
              this.data.salesdepart = e.salesdepart;
              this.data.salesdepart_date = e.salesdepart_date;
            }else if(this.postCode == 'quality_depart'){
              this.data.qcdepart = e.qcdepart;
              this.data.qcdepart_date = e.qcdepart_date;
            }else if(this.postCode == 'quality_director'){
              this.data.qcid = e.qcid;
              this.data.qc_data = e.qc_data;
              this.data.check_status = e.check_status;
            }
          },
          /**
           * 改变委托书有效期
           */
          clear_checkstatus:function (){
            if(this.data.check_status && this.data.check_status==1){
              this.data.salesdepart = null;
              this.data.salesdepart_date = null;
              this.data.qcdepart = null;
              this.data.qcdepart_date = null;
              this.data.qcid = null;
              this.data.qc_data = null;
              this.data.check_status = 0;
              this.modalMsg('因委托书相关内容已修改，三审核内容被删除，合格标志被清除，请重新审核！');
            }
          }
        }
    }
</script>
<style lang="less">
.edcont{
  .company_name{
    height: 30px; font-size: 14px; line-height: 16px; color: #ed4014; text-align: center;
  }
  .attention-msg{height: 20px; font-size: 12px; line-height: 14px; color: #ed4014; text-align: center;}
  .proa-msg{height: 28px; font-size: 12px; line-height: 28px; color: #ed4014;}
}
</style>
