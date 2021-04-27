<template>
  <div>
     <Upload ref="upload" :imgName="imgName" :type="dragType"
     :show-upload-list="showUploadList"
     :default-file-list="defaultList"
     :format="formatArr"
     :max-size="maxSize"
     :multiple="multiple"
     :action="'/'+action"
     :data="extraDataNew"
     :on-format-error="handleFormatError"
     :on-exceeded-size="handleMaxSize"
     :before-upload="handleBeforeUpload"
     :on-progress="handleProgress"
     :on-success="handleSuccess"
     :on-error="handleError"
     :on-preview="handlePreview"
     :on-remove="handleRemove">
             <slot name="btn_view">
               <div :style="dragStyle" v-if="dragType == 'drag'">
                 <Icon type="ios-cloud-upload" size="52" style="color: #3399ff"></Icon>
                 <p>{{percent?('已上传'+percent+'%'):'点击上传'}}</p>
               </div>
               <Button v-else :type="percent?'default':'primary'" :loading="percent?true:false"><span v-if="!percent" class="iconfont">&#xe7d9;</span>{{percent?('已上传'+percent+'%'):'点击上传'}}</Button>
             </slot>
        </Upload>
  </div>
</template>
<script>
    export default {
      name:'uploadFun',
      props: {
        dragType:{//select（点击选择），drag（支持拖拽）
          type:String,
          default:'select'
        },
        dragStyle:{//上传按钮样式
          type:String,
          default:'padding: 20px 0;'
        },
        multiple:{//多选
          type:Boolean,
          default:false
        },
        maxLength:{//多选开启时有效  最多上传几张图片
          type:Number,
          default:1
        },
        defaultList:{//已上传数组
          type:Array,
          default:()=>[]
        },
        formatArr:{//支持的文件类型 识别文件后缀
          type:Array,
          default:()=>['jpg','jpeg','png','GIF','JPG','JPEG','PNG']
        },
        imgName:{//文件名称编号
          type:String,
          default:''
        },
        showUploadList:{//是否显示已上传文件列表
          type:Boolean,
          default:false
        },
        maxSize: {//文件上传大小 KB
          type:Number,
          default:3072
        },
        extraData:{//额外参数
          type:Object,
          default:()=>{}
        },
        action:{//请求地址
          type:String,
          default:'uploadImg'
        },
        isPercent:{
          type:Boolean,
          default:true
        }
      },
      data () {
        return {
          BASE_URL:this.common.BASE_URL+'/app/',
          uploadList: [],
          extraDataNew:null,
          percent:0
        }
      },
      watch:{
        extraData(){
          this.initData();
        }
      },
      mounted () {
        this.uploadList = this.$refs.upload.fileList;
        this.initData();
      },
      methods: {
        initData:function(){
          var defaultOptions = {token:this.common.getToken(),acc:localStorage.getItem("acc"),name:this.imgName}
          this.extraDataNew = {
            ...defaultOptions,
            ...this.extraData
          };
        },
        handleBeforeUpload () {
          if(!this.multiple) return true;
          const check = this.uploadList.length < this.maxLength;
          if (!check) {
              this.$Notice.warning({
                  title: '最多可上传'+this.maxLength+'张图片'
              });
              this.percent = 0;
          }
          return check;
        },
        handleFormatError (file) {
          this.$Notice.warning({
              title: '文件格式不正确',
              desc: '待上传的文件格式必须为'+this.formatArr.toString()
          });
          this.percent = 0;
        },
        handleMaxSize (file) {
          this.$Notice.warning({
              title: file.name+'文件超出大小限制',
              desc: '文件大小不能超过' + this.maxSize+'KB'
          });
          this.percent = 0;
        },
        handleProgress (event, file, fileList){
          if(this.isPercent) this.percent = parseInt(event.percent);
          this.$emit('upProgress',{percent:event.percent,'name':this.imgName})
        },
        handleSuccess (response, file, fileList) {
          this.percent = 0;
          if(response.status == 1){
            this.$emit('upSuccess',{imgUrl:response.img,name:this.imgName,file_name:file.name})
          }else{
            this.$Notice.warning({
                title: '上传失败',
                desc: response.msg
            });
          }
        },
        handleError (error, file, fileList){
          this.percent = 0;
          this.$Notice.warning({
              title: '上传失败',
              desc: error
          });
        },
        handlePreview (file) {
          //点击已上传的文件链接时的钩子
        },
        handleRemove (file, fileList) {
          //const fileList = this.$refs.upload.fileList;
          // this.$refs.upload.fileList.splice(fileList.indexOf(file), 1);
        }
      }
    }
</script>

<style>
</style>
