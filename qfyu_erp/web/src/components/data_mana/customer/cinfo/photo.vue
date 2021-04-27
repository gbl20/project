<template>
    <Modal v-model="show_self" :title="'供应商'+this.cid+'证照-'+(this.data.id?'修改':'新增')" width="500" :closable="false" :mask-closable="false" footer-hide>
        <div class="providers-img">
          <Form ref="formPhotoRef" :rules="ruleVal" :model="data" :label-width="90">
            <Row>
             <Col span="13">
               <FormItem label="图片名称：" prop="pic_name">
                  <Select v-model="data.pic_name">
                    <Option v-for="(item,index) in labelarr" :value="index" :key="index">{{item}}</Option>
                  </Select>
               </FormItem>
             </Col>
             <Col span="11">
               <FormItem label="有效期至：" prop="use_date">
                 <DatePicker type="date" v-model="data.use_date" placeholder="有效期至" format="yyyy-MM-dd"></DatePicker>
               </FormItem>
             </Col>
            </Row>
            <FormItem label="证照图片：" prop="pic_url">
              <Input type="text" :value="data.pic_url" v-show="false"></Input>
              <div class="btn-view" v-if="data.use_date && data.pic_name">
                <upload action="custImgUpload" :extraData="{cid:cid,use_date:data.use_date}" :imgName="data.pic_name" @upSuccess="upSuccess" @upProgress="upProgress">
                </upload>
              </div>
              <div v-else class="error-text t-v-item">*请先完善以上两项信息！</div>
            </FormItem>
            <FormItem label="" :label-width="0">
              <div class="choose-img border-class bg-text">
                <viewer :images="[BASE_URL+data.pic_url]" v-if="data.pic_url">
                    <img :src="BASE_URL+data.pic_url" alt="">
                </viewer>
              </div>
            </FormItem>
            <Divider/>
            <Row>
              <div style="float: right;">
                <Button type="text" @click="show_self = false">取消</Button>
                <Button type="primary" :loading="subLoading" @click="comData">确定</Button>
              </div>
            </Row>
          </Form>
        </div>
     </Modal>
</template>

<script>
  import upload from '@/components/public/upload.vue'
  export default{
    name :'photo',
    components:{upload},
    props: {
    },
    data:function(){
      return {
        show_self:false,
        subLoading:false,
        data:{},
        labelarr:{},
        default_data:{id:0,pic_name:'',pic_url:'',use_date:''},
        cid:'',
        BASE_URL:this.common.BASE_URL,
        ruleVal:{
          pic_name:[
           {required:true, message:'请选择图片名称',trigger:'change'}
         ],
          use_date:[
           {required:true, type:'date', message:'请选择有效期',trigger:'change'}
         ],
          pic_url:[
           {required:true, message:'请上传图片',trigger:'change'}
         ]
        }
      }
    },
    methods:{
      init:function(params){
        var _this = this;
        if(typeof(params)=="undefined") return false;
        this.show_self=true;
        this.cid=params.company_id;
        _this.common.http({url:'getCustPhoto',data:{id:params.id}}).then(function(res){
            if(res.status==1){
              _this.data = res.data;
              _this.labelarr = res.labelarr;
            }else{
              _this.data = [];
            }
        }).catch(function(err){
             _this.common.httpErr(err.data,_this);
        });
      },
      /**
       * 提交保存
       */
      comData:function(){
        var _this = this,data=this.data;
        data.cid=this.cid;
        if(this.cid=='') return false;
        this.subLoading = true;
        this.$refs.formPhotoRef.validate(function(valid){
          if (valid) {
            _this.common.http({url: 'comCustPhoto',data:data}).then(function (res) {
              _this.subLoading = false;
              if(res.status==1){
                _this.$parent.get_img(_this.cid);
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
      },
      /**
       * 上传成功
       */
      upSuccess:function(res){
        this.$set(this.data,'pic_url',res.imgUrl);
      },
      /**
       * 上传进度
       */
      upProgress:function(res){}
    }
  }
</script>
<style lang="less">
.providers-img{
  .choose-img{
    display: block;width: 100%;height: 300px;text-align: center;line-height: 300px;cursor: pointer;
    img{
      display: inline-block;width: 100%;height: auto;margin: auto;vertical-align: middle;
    }
  }
}
</style>
