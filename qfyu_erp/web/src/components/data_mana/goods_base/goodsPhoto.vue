<template>
	<div class="main">
    <Row>
      <Col span="22">
        <Table size="small" border highlight-row :columns="columns" :data="data" :height="height" @on-row-click="(item,index)=>{clickRow(item,index,false)}">
          <template slot-scope="{row}" slot="img_name">
            <span>{{imgName[row.img_name]}}</span>
          </template>
        </Table>
      </Col>
      <Col span="2" :style="'height:'+height+'px'">
        <div class="active">
          <Button @click="openModal(false)"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button @click="delImg"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
          <Button @click="openModal(true)"><span class="icon iconfont">&#xe791;</span>修改</Button>
          <Button @click="viewImg"><span class="icon iconfont">&#xe691;</span>查看</Button>
        </div>
      </Col>
    </Row>
    <Modal v-model="imgModel" title="药品证照" class-name="vertical-center-modal">
      <div class="tabs-form">
        <Form ref="formFile" :model="formInline" label-position="left" label-colon :label-width="80">
          <Row>
            <Col span="12">
              <FormItem label="图片名称">
                <Select v-model="formInline.img_name" clearable transfer>
                  <Option v-for="(item,index) in imgName" :value="index" :key="index">{{item}}</Option>
                </Select>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem label="有效期至">
                <DatePicker type="datetime" :options="startOptions" v-model="formInline.validity_date"></DatePicker>
              </FormItem>
            </Col>
          </Row>
          <FormItem label="上传证照">
            <upload v-if="formInline.img_name && formInline.validity_date" action="firstGoodsUpload" :extraData="{code:formInline.goods_code}" :imgName="formInline.img_name" @upSuccess="upSuccess" @upProgress="upProgress">
            </upload>
            <div v-else class="error-text">* 商品图片名称与有效期至为必填项！请完善信息后上传证照。</div>
          </FormItem>
          <Row>
            <Col span="24">
              <div class="pro-img border-color"><img v-if="formInline.file_name" :src="BASE_URL+formInline.file_name" alt="" /></div>
            </Col>
          </Row>
        </Form>
      </div>
      <div slot="footer">
        <Button @click="sendUpload(false)">取消</Button>
        <Button type="primary" @click="sendUpload(true)">保存</Button>
      </div>
    </Modal>
    <Modal title="查看证照图片" v-model="showImg" width="632" footer-hide>
      <div class="img-box border-color">
        <img class="img" :src="BASE_URL+imgUrl" alt="" />
      </div>
    </Modal>
  </div>
</template>

<script>
  import upload from '@/components/public/upload.vue'
  var _this;
	export default {
    props:{
      height:0
    },
	  components:{
      upload
    },
    data:function () {
      return{
        imgModel:false,
        showImg:false,
        formInline:{goods_code:'',img_name:'',validity_date:new Date(),file_name:''},
        imgName:[],
        editData:{},
        columns:[
          {title: '图片名称', slot: 'img_name',width:200,minWidth:200,resizable:true,ellipsis:true},
          {title: '文件名', key: 'file_name',width:400,minWidth:400,resizable:true,ellipsis:true},
          {title: '采集日期', key: 'create_date',width:180,minWidth:180,resizable:true,ellipsis:true,align:'center'},
          {title: '有效期至', key: 'validity_date',width:180,minWidth:180,resizable:true,ellipsis:true,align:'center'},
          {title: '采集人', key: 'creator',width:120,minWidth:120,resizable:true,ellipsis:true,align:'center'}
        ],
        data:[],
        imgUrl:'',
        BASE_URL:this.common.BASE_URL,
        startOptions: {
          disabledDate (date) {
            return date && date.valueOf() < Date.now() - 86400000;
          }
        }
      }
    },
    mounted() {
      _this = this;
    },
    methods:{
      init:function (code) {
        this.formInline.goods_code = code;
        this.common.http({
          url:'getGoodsPhoto',
          data:{goods_code:code}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
            _this.imgName = res.img_name;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        });
      },
      clickRow:function(item,index,type){
        this.editData.goods_code = this.data[index].goods_code;
        this.editData.img_name   = this.data[index].img_name;
        this.editData.file_name  = this.data[index].file_name;
        this.editData.validity_date = this.data[index].validity_date;
      },
      //准备上传药品证照操作  type==false 新增  type==true 修改
      openModal:function(type){
        this.formInline.img_name  = '';
        this.formInline.file_name = '';
        if (type){
          if(JSON.stringify(this.editData)=='{}') return this.alertMsg('请选择需要编辑的证照！','error');
          else this.formInline = JSON.parse(JSON.stringify(this.editData));
        }
        this.imgModel=true;
      },
      //确定上传药品证照
      sendUpload:function (type) {
        if(!type) return this.imgModel=false;
        if(!this.formInline.file_name.length) return this.alertMsg('请上传药品证照！','error')
        this.common.http({
          url:'firstGoodsInfoUpload',
          data:{data:this.formInline}
        }).then(function (res) {
          if (res.status){
            _this.alertMsg(res.msg);
            _this.imgModel = false;
            _this.init(_this.formInline.goods_code);
            _this.editData = {}
          }else{
            _this.alertMsg(res.msg,'error')
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
      //删除药品证照
      delImg:function(){
        if(JSON.stringify(this.editData)=='{}') return this.alertMsg('请选择需要删除的药品证照信息！','error');
        this.$Modal.confirm({
          title:"提示",
          content:'确定药删除该证照信息吗？',
          onOk:function () {
            _this.common.http({
              url:"delGoodsPhoto",
              data:{data:_this.editData}
            }).then(function (res) {
              if (res.status){
                _this.alertMsg(res.msg)
                _this.init(_this.formInline.goods_code);
              }else{
                _this.alertMsg(res.msg,'error')
              }
            }).catch(function (err) {
              _this.common.httpErr(err.data,_this);
            })
          }
        })
      },
      //查看证照图片
      viewImg:function(){
        if(JSON.stringify(this.editData)=='{}') return false;
        this.imgUrl = this.editData.file_name;
        this.showImg = true;
      },
      upSuccess:function (e) {
        this.formInline.file_name = e.imgUrl;
      },
      upProgress:function(e){}
    }
	}
</script>

<style lang="less">
  .active{
    padding: 0 10px;
    .ivu-btn{
      display: block;margin-bottom: 5px;
    }
  }
  .pro-img{
    display: flex;width: 488px;height: 330px;justify-content: center;align-items:center;border-width:1px;border-style:solid;overflow: hidden;box-sizing: border-box;
    img{
      display: inline-block;max-width: 100%;max-height: 100%;
    }
  }
  .img-box{
    width: 600px;height: 600px;line-height: 600px;text-align: center;overflow: hidden;border-width: 1px;border-style: dashed;box-sizing: border-box;
    .img{
      display: inline-block;max-width: 100%;vertical-align: middle;
    }
  }
</style>
