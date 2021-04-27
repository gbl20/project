<template>
    <Modal v-model="show_self" :title="'业务联系记录-'+(data.id?'修改':'新增')" width="518" :closable="false" :mask-closable="false" footer-hide>
      <Form ref="formBus" :rules="ruleVal" :model="data" :label-width="100">
        <Row>
          <Col span="12">
            <FormItem label="洽谈时间：" prop="bus_date">
              <DatePicker type="datetime" v-model="data.bus_date" format="yyyy-MM-dd HH:mm" placeholder="洽谈时间"></DatePicker>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem label="我方洽谈人：" prop="mman" :label-width="110">
               <Input icon="ios-more" readonly class="right" style="cursor: pointer;" :value="data.mman" @on-click="chooseEmp"></Input>
            </FormItem>
          </Col>
        </Row>
        <FormItem label="洽谈主题：">
          <Input v-model="data.submatter" maxlength="150"></Input>
        </FormItem>
        <FormItem label="方式/地点：">
          <Input v-model="data.area" maxlength="150"></Input>
        </FormItem>
        <FormItem label="对方洽谈人：">
          <Input v-model="data.yman" maxlength="30"></Input>
        </FormItem>
        <FormItem label="洽谈内容：">
          <Input type="textarea" maxlength="2000" show-word-limit v-model="data.content" :autosize="{minRows:3,maxRows: 3}"></Input>
        </FormItem>
        <Divider/>
        <Row>
          <div style="float: right;">
            <Button type="text" @click="show_self = false">取消</Button>
            <Button type="primary" :loading="subLoading" @click="comData">确定</Button>
          </div>
        </Row>
      </Form>
      <select-employee ref="selectEmployeeRef" @selemp="confirmEmployee"></select-employee>
    </Modal>
</template>

<script>
  import selectEmployee from '@/components/common/SelectEmployee'
  export default{
    name :'records',
    components:{selectEmployee},
    props: {},
    data:function(){
      return {
        show_self:false,
        data:{id:0,bus_date:'',mman:'',submatter:'',area:'',yman:'',content:''},
        cid:0,
        default_data:{id:0,bus_date:'',mman:'',submatter:'',area:'',yman:'',content:''},
        subLoading:false,
        ruleVal:{
          bus_date:[
            {required:true,type:'date', message:'请选择联系日期',trigger:'change'}
          ],
          mman:[
            {required:true,type:'string', message:'请选择我方洽谈人',trigger:'change'}
          ],
        }
      }
    },
    methods:{
      init:function(params){
        if(typeof(params)=="undefined") return false;
        this.show_self=true;
        this.cid=params.company_id;
        if(params.data.id==0){
          this.data=JSON.parse(JSON.stringify(this.default_data));
          this.data.cid=params.company_id;
        }else this.data=JSON.parse(JSON.stringify(params.data));
      },
      /**
       * 弹出选择员工
       */
      chooseEmp:function(){
        this.$refs.selectEmployeeRef.init({show_self:1});
      },
      /**
       * 确认选择员工
       */
      confirmEmployee:function(e){
        this.$set(this.data,'mman',e.code);
      },
      /**
       * 保存联系记录
       */
      comData:function (){
        var _this = this;
        this.$refs.formBus.validate(function(valid){
          if (valid) {
            _this.subLoading = true;
            _this.common.http({
              url: 'saveBusiness',data:_this.data
            }).then(function (res) {
              _this.subLoading = false;
              if(res.status==1){
                _this.$parent.get_neg(_this.cid);
                _this.show_self=false;
                _this.alertMsg(res.msg,'success');
              }else{
                _this.alertMsg(res.msg,'error');
              }
            }).catch(function(err){
              _this.subLoading = false;
              _this.common.httpErr(err.data,_this);
            })
          }else{
            _this.subLoading = false;
          }
        })
      }
    }
  }
</script>
<style lang="less">
</style>
