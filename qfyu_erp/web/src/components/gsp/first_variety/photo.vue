<template>
	<div>
    <div class="tabs-content bg-m" :style="'height:'+(height-53)+'px'">
      <div class="nav-menu bg">
        <Button :disabled="isDisabled" @click="addImage(true)"><span class="icon iconfont">&#xe793;</span>新增</Button>
        <Button :disabled="isDisabled" @click="addImage(false)"><span class="icon iconfont">&#xe793;</span>删除</Button>
      </div>
      <div class="pro-imgbox bg" :style="'height:'+(height-99)+'px;'">
        <div class="pro-le bg-m">
          <div class="bg">
            <ul>
              <li class="item-btn" :class="{cur:delIndex==key}" v-for="(item,key) in goods_img" :key="key" @click="changeImg(key)">{{imgItem[item.img_name]}}</li>
            </ul>
          </div>
        </div>
        <div class="pro-ri">
          <img v-if="Index_pic" :src="BASE_URL+Index_pic" alt="" />
        </div>
      </div>
    </div>
    <Modal v-model="imgModel" title="首营药品证照">
      <div class="tabs-form">
        <Form ref="formFile" :model="formInline" label-position="left" :label-width="65">
          <Row>
            <Col span="12">
              <FormItem label="图片名称">
                <Select v-model="formInline.img_name" @on-change="change" transfer>
                  <Option v-for="(item,index) in imgItem" :value="index" :key="index">{{item}}</Option>
                </Select>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="有效期至">
                <DatePicker type="date" :options="startOptions" v-model="formInline.validity_date"></DatePicker>
              </FormItem>
            </Col>
          </Row>
          <Row>
            <FormItem label="商品证照">
              <upload v-if="formInline.img_name && formInline.validity_date" action="firstGoodsUpload" :extraData="{code:goods_code}" :imgName="formInline.img_name" @upSuccess="upSuccess" @upProgress="upProgress"></upload>
              <div v-else class="error-text">* 商品图片名称与有效期至为必填项！请完善信息后上传证照。</div>
            </FormItem>
          </Row>
          <Row>
            <div class="pro-img border-color">
              <img v-if="formInline.file_name" :src="BASE_URL+formInline.file_name" alt="" />
            </div>
          </Row>
        </Form>
      </div>
      <div slot="footer">
        <Button @click="sendUpload(false)">取消</Button>
        <Button type="primary" @click="sendUpload(true)">保存</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
  import upload from '@/components/public/upload.vue'
	export default {
    components:{
      upload
    },
	  props:{
      height:{
        type: Number,
        default:694
      },
      goods_code:{
        type: String,
        required:true,
        default:''
      },
      isDisabled:{
        type:Boolean,
        default:false
      }
    },
		data:function () {
      return{
        imgModel:false,//证照层
        formInline:{goods_code:null,validity_date:new Date(),file_name:''},//商品证照信息
        imgItem:[],
        goods_img:[],
        Index:'',//商品证照类型
        Index_pic:'',//商品图片地址
        delIndex:0,
        BASE_URL:this.common.BASE_URL,
        startOptions: {
          disabledDate (date) {
            return date && date.valueOf() < Date.now() - 86400000;
          }
        }
      }
    },
    mounted() {
	    this.init();
    },
    methods:{
	    init:function(){
	      var _this=this;
	      this.common.http({
          url:'getFirstGoodsPhoto',
          data:{goods_code:this.goods_code}
        }).then(function (res) {
          if (res.status){
            _this.imgItem   = res.img_item;
            _this.goods_img = typeof(res.goods_img)!=='undefined'?res.goods_img:[];
            _this.Index_pic = _this.goods_img.length?_this.goods_img[0].file_name:'';
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      change:function(val){
        this.Index=val;
        if (this.formInline.file_name) this.formInline.file_name='';
      },
      //证照列表 点击事件
      changeImg:function(index){
        this.delIndex = index;
        this.Index_pic = this.goods_img[index].file_name;
      },
      //新增商品证照
      addImage:function(type){
        var _this=this;
        this.Index = '';
        this.formInline.file_name='';
        if (type) return this.imgModel = true;
        if(this.goods_img.length<1) return this.alertMsg('请选择需要删除的商品证照！','error')
        var data = {data:this.goods_img[this.delIndex]}
        this.common.http({
          url:'firstGoodsImgDel',
          data:data
        }).then(function (d) {
          if (d.status) {
            _this.alertMsg(d.msg)
            _this.init()
          }else {
            _this.alert(d.msg,'error')
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      //保存首营品种证照
      sendUpload:function(type){
        var _this=this,
            obj = this.formInline;
        if(!type) return this.imgModel=false;
        var data = {goods_code:this.goods_code,img_name:obj.img_name,validity_date:obj.validity_date,file_name:obj.file_name}
        if(obj.file_name==''){return this.alertMsg('请上传证照','error')}
        this.common.http({
          url:'firstGoodsInfoUpload',
          data:{data:data}
        }).then(function (d) {
          if(d.status){
            _this.imgModel=false;
            _this.alertMsg(d.msg)
            _this.init();
          }else{
            _this.alertMsg(d.msg,'error')
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      upSuccess:function(e){
        this.formInline.file_name = e.imgUrl;
      },
      upProgress:function(e){},
    }
	}
</script>

<style lang="less">
  .pro-imgbox{
    display: flex;flex-wrap: nowrap;
    .pro-le{
      padding: 10px 10px 0 0;width: 312px;
      .bg{
        width: auto;height: 100%;
        ul{
          display: block;width: 100%;list-style: none;
          li{
            display: block;height: 32px;line-height: 32px;padding: 0 16px 0 24px;font-size: 14px;transition: all .3s;
          }
        }
      }
    }
    .pro-ri{
      padding: 10px;overflow: hidden;
      img{max-width: 100%;max-height: 100%;}
    }
  }
  .pro-img{
    width: auto;height: 300px;text-align:center;vertical-align: center;overflow: hidden;border-width:1px;border-style:solid;
    img{
      max-width: 100%;height: 100%;
    }
  }
</style>
