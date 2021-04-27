<template>
  <div>
    <div class="table-m-photo">
      <div class="table-m">
        <Table size="small" border stripe :columns="columns" :rowClassName="rowClassName" @on-row-click="rowClick" :data="data" :loading="loading" :height="height">
          <template slot-scope="{ row }" slot="img_name">
            {{imgLabel[row.img_name]}}
          </template>
          <template slot-scope="{ row }" slot="file_name">
            {{row.file_name.substring((row.file_name.lastIndexOf('/')+1))}}
          </template>
        </Table>
      </div>
      <div class="right-btn">
        <Button class="edit-btn" @click="addEdit(0)"><span class="icon iconfont">&#xe797;</span>新增</Button>
        <Button class="edit-btn" @click="addEdit(1)" :disabled="checkIndex==-1"><span class="icon iconfont">&#xe791;</span>修改</Button>
        <Button class="edit-btn"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        <Button class="edit-btn"><span class="icon iconfont">&#xe691;</span>查看</Button>
      </div>
    </div>
    <Modal v-model="editModal" :title="'供应商'+this.supplierCode+'证照-'+(this.formData.id?'修改':'新增')" width="500" :closable="false" :mask-closable="false" footer-hide>
        <div class="providers-img">
          <Form ref="formPhotoRef" :rules="ruleVal" :model="formData" :label-width="90">
            <Row>
             <Col span="13">
               <FormItem label="图片名称：" prop="img_name">
                  <Select v-model="formData.img_name">
                    <Option v-for="(item,index) in imgLabel" :value="index" :key="index">{{item}}</Option>
                  </Select>
               </FormItem>
             </Col>
             <Col span="11">
               <FormItem label="有效期至：" prop="validity_date">
                 <DatePicker type="date" v-model="formData.validity_date" placeholder="有效期至" format="yyyy-MM-dd"></DatePicker>
               </FormItem>
             </Col>
            </Row>
            <FormItem label="证照图片：" prop="file_name">
              <Input type="text" :value="formData.file_name" v-show="false"></Input>
              <div class="btn-view" v-if="formData.validity_date && formData.img_name">
                <upload action="enterPriseUpload" :extraData="{code:supplierCode,validity_date:formData.validity_date}" :imgName="formData.img_name" @upSuccess="upSuccess" @upProgress="upProgress">
                </upload>
              </div>
              <div v-else class="error-text t-v-item">*请先完善以上两项信息！</div>
            </FormItem>
            <FormItem label="" :label-width="0">
              <div class="choose-img border-class bg-text">
                <viewer :images="[BASE_URL+formData.file_name]" v-show="formData.file_name != ''">
                    <img :src="BASE_URL+formData.file_name" alt="">
                </viewer>
              </div>
            </FormItem>
            <Divider/>
            <Row>
              <div style="float: right;">
                <Button type="text" @click="editModal = false">取消</Button>
                <Button type="primary" :loading="subLoading" @click="comData">确定</Button>
              </div>
            </Row>
          </Form>
        </div>
     </Modal>
  </div>
</template>

<script>
  import upload from '@/components/public/upload.vue'
  var fData = {id:0,supplier_code:'',img_name:'',file_name:'',validity_date:null};
  export default{
    name :'contacts',
    components:{
      upload
    },
    props: {
      height:{
        type:Number,
        default:0
      },
      supplierCode:{
        type:String,
        default:''
      }
    },
    data:function(){
      return {
        editModal:false,
        loading:false,
        columns:[
         { title: "图片名称",slot: "img_name",width: 200,align: "left"},
         { title: "文件名",slot: "file_name",width: 380,align: "left",tooltip:true},
         { title: "有效期至",key: "validity_date",width: 150,align: "center"},
         { title: "采集日期",key: "create_date",width: 200,align: "center"},
         { title: "采集人",key: "creator",width: 150,align: "center"}
        ],
        data:[],
        subLoading:false,
        checkIndex:-1,
        imgLabel:this.$store.state.sysParam['img_config']['providersImg'],
        formData:JSON.parse(JSON.stringify(fData)),
        BASE_URL:this.common.BASE_URL,
        ruleVal:{
         img_name:[
           {required:true, message:'请选择图片名称',trigger:'change'}
         ],
         validity_date:[
           {required:true, type:'date', message:'请选择有效期',trigger:'change'}
         ],
         file_name:[
           {required:true, message:'请上传图片',trigger:'change'}
         ]
        }
      }
    },
    watch:{
      supplierCode(){
        if(this.supplierCode.length > 0) this.init();
      }
    },
    mounted() {
      if(this.supplierCode.length > 0) this.init();
    },
    methods:{
      init:function(){
        let _this = this;
        _this.loading = true;
        _this.common.http({url:'getProvPhoto',data:{supplier_code:this.supplierCode}}).then(function(res){
            if(res.status==1){
              _this.data = res.data;
            }else{
              _this.data = [];
            }
            _this.$nextTick(function(){
               _this.loading = false;
               if(res.status==1) _this.checkIndex = 0;
               else  _this.checkIndex = -1;
            })
        }).catch(function(err){
             _this.common.httpErr(err.data,_this);
        });
      },
      rowClassName(row, index) {
        if (index === this.checkIndex) {
          return 'ivu-table-row-highlight';
        }
        return '';
      },
      rowClick:function(item,index){
        this.checkIndex = index;
      },
      comData:function(){
        let _this = this;
        if(this.supplierCode.length < 0) return false;
        this.formData.supplier_code = this.supplierCode;
        this.subLoading = true;
        this.$refs.formPhotoRef.validate(function(valid){
          if (valid) {
            _this.formData.supplier_code = _this.supplierCode;
            _this.common.http({
              url: 'comProvPhoto',data:{fdata:_this.formData}
            }).then(function (res) {
              _this.alertMsg(res.msg,res.status != 1?'error':'');
              if(res.status == 1){
                let checkReStatus = true;
                for(let i=0;i<_this.data.length;i++){
                  if(_this.data[i].img_name == res.data.img_name){
                    _this.$set(_this.data, i, res.data)
                    checkReStatus = false;
                    _this.checkIndex = i;
                  }
                }
                if(checkReStatus){
                  _this.data.unshift(res.data)
                  _this.checkIndex = 0;
                }
                _this.editModal = false;
              }
              _this.subLoading = false;
            }).catch(function(err){
              _this.subLoading = false;
              _this.common.httpErr(err.data,_this);
            })
          }else{
            _this.subLoading = false;
          }
        })
      },
      addEdit:function(type){
        let _this = this;
        this.formData = JSON.parse(JSON.stringify(fData))
        if(type){
          if(this.checkIndex != -1){
            const NewData = JSON.parse(JSON.stringify(this.data[this.checkIndex]));
            NewData.id = 1;
            setTimeout(function(){
              _this.formData = NewData;
            },200)
          }else{
            return this.alertMsg('请选择需要修改的信息','error')
          }
        }
        this.editModal = true;
      },
      upSuccess:function(res){
        this.formData['file_name'] = res.imgUrl;
      },
      upProgress:function(res){
        console.log(res)
      }
    }
  }
</script>
<style lang="less">
  .table-m-photo{
    padding:0 90px 0 10px; position: relative;
    .right-btn{
      width: 77px; position: absolute; right: 0; top: 0; bottom: 0;
      .edit-btn{
        margin-bottom:10px;
      }
      .ivu-checkbox-wrapper {
        font-size: 12px;
      }
    }
  }
  .providers-img{
    .choose-img{
      display: block;width: 100%;height: 300px;text-align: center;line-height: 300px;cursor: pointer;
      img{
        display: inline-block;width: 100%;height: auto;margin: auto;vertical-align: middle;
      }
    }
  }

</style>
