<template>
  <div>
      <div class="table-m-grant">
        <div class="table-m-left">
          <Table size="small" border stripe :columns="columns" :rowClassName="rowClassName" @on-row-click="rowClick" :data="data" :loading="loading" :height="height-24">
          </Table>
          <div class="tab-contact">
            <div class="tags-view-s border-l border-r border-b">
              <a href="javascript:;" v-if="isNav" @click="MoveNav(false,0)" class="g-v-item tag-nav tag-nav-l bg-text"><span class="iconfont">&#xe7ec;</span></a>
              <div class="t-v-main" ref="TVMain" :style="!isNav?'right:0;left:0;':''">
                <div class="t-l-item">
                  <div class="t-v-wrap" ref="TVWrap" :style="'left:-'+TVWrapLeft+'px;'+(isNav?'position:absolute':'')">
                    <div v-if="contactList.length">
                      <div v-for="(item,index) in contactList" :key="index" :class="'border-l g-v-item'+(contactIndex==index?' error-bg-text':'')" @click="chooseSales(index)">
                       {{item.user_name}}
                      </div>
                    </div>
                    <div v-else class="error-text" style="padding:0 10px;line-height: 24px;">当前没有可添加授权品种的供方销售人员</div>
                  </div>
                </div>
              </div>
              <a href="javascript:;" v-if="isNav" @click="MoveNav(true,0)" class="g-v-item tag-nav tag-nav-r bg-text"><span class="iconfont">&#xe7eb;</span></a>
            </div>
          </div>
        </div>
        <div class="right-btn">
          <Button class="edit-btn" @click="choosePro"><span class="icon iconfont">&#xe797;</span>新增</Button>
          <Button class="edit-btn"><span class="icon iconfont">&#xe6a5;</span>删除</Button>
        </div>
      </div>
     <select-goods ref="selectGoodsRef" :isSignle="true" @selectRow="selectGoodsRow"></select-goods>
  </div>
</template>

<script>
  import selectGoods from '@/components/common/ChooseGoods'
  export default{
    name :'varieties',
    components:{selectGoods},
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
         { title: "供应商编号",key: "supplier_code",width: 100,align: "center"},
         { title: "姓名",key: "user_name",width: 120,align: "center"},
         { title: "商品编号",key: "goods_code",width: 120,align: "center"},
         { title: "通用名称",key: "goods_name",resizable: true,width: 150,ellipsis:true,align: "center"},
         { title: "规格",key: "specs",resizable: true,width: 120,align: "center"},
         { title: "剂型",key: "dosage",width: 80,align: "center",resizable: true},
         { title: "生产企业",key: "production",resizable: true,width: 150,ellipsis:true,align: "center"},
         { title: "产地",key: "origin",resizable: true,width: 180,ellipsis:true,align: "center"},
         { title: "批准文号/注册证号",key: "approval_code",resizable: true,width: 150,ellipsis:true,align: "center"}
        ],
        data:[],
        proList:{},
        subLoading:true,
        contactList:[],
        contactIndex:-1,
        contactId:0,
        TVWrapLeft:0,
        leftWidth:0,
        isNav:false,
        checkIndex:-1
      }
    },
    watch:{
      supplierCode(){
        if(this.supplierCode.length > 0) this.init(-1);
      },
      contactIndex(e){
        if(e != -1 && this.contactList.length > 0){
          this.contactId = this.contactList[e].id;
        }else this.contactId = 0;
      }
    },
    mounted() {
       if(this.supplierCode.length > 0) this.init(-1);
    },
    methods:{
      init:function(contact_id){
        let _this = this;
        _this.loading = true;
        _this.common.http({url:'getProGrant',data:{supplier_code:this.supplierCode,contact_id:contact_id}}).then(function(res){
            if(res.status==1){
              _this.data = res.data;
              if(res.data.length > 0) _this.checkIndex = 0;
              else _this.checkIndex = -1;
              if(contact_id == -1){
                _this.contactList = res.contacts;
                if(res.contacts.length > 0) _this.contactIndex = 0;
                else _this.contactIndex = -1;
              }
            }else{
              _this.data = [];
              _this.contactList = [];
            }
            _this.$nextTick(function(){
              _this.loading = false;
              _this.checkIsNav();
            })
        }).catch(function(err){
             _this.common.httpErr(err.data,_this);
        });
      },
      checkIsNav:function(){
        let Mwidth = this.$refs.TVMain.offsetWidth;
        let Wwidth = this.$refs.TVWrap.offsetWidth;
        if((Wwidth+60) > Mwidth) this.isNav = true;
        else this.isNav = false;
      },
      rowClassName(row, index) {
          if (index === this.checkIndex) {
            return 'ivu-table-row-highlight';
          }
          return '';
      },
      MoveNav:function(type,TVWrapLeft){
        let Mwidth = this.$refs.TVMain.offsetWidth;
        let Wwidth = this.$refs.TVWrap.offsetWidth;
        let leftWidth = Wwidth - Mwidth;
        TVWrapLeft = TVWrapLeft || 0;
        if(TVWrapLeft == 0){
          if(type){
            TVWrapLeft = this.TVWrapLeft + Mwidth/2;
          }else{
            TVWrapLeft = this.TVWrapLeft - Mwidth/2;
          }
        }
        if(TVWrapLeft > leftWidth) TVWrapLeft = leftWidth;
        else if(TVWrapLeft < 0) TVWrapLeft = 0;
        this.TVWrapLeft = TVWrapLeft;
      },
      rowClick:function(item,index){
        this.checkIndex = index;
      },
      addEdit:function(type){
        this.editModal = true;
      },
      chooseSales:function(index){
        this.contactIndex = index;
        this.init(this.contactList[index].id)
      },
      choosePro:function(){
        if(this.contactId == 0){
          return this.modalMsg('当前没有可添加授权品种的供方销售人员');
        }else this.$refs.selectGoodsRef.open();
      },
      selectGoodsRow:function(e){
        let _this = this;
        if(this.supplierCode.length < 0) return false;
        _this.common.http({
          url: 'comProvGrant',data:{supplier_code:_this.supplierCode,goods_code:e.goods_code,contact_id:this.contactId}
        }).then(function (res) {
          _this.alertMsg(res.msg,res.status != 1?'error':'');
          if(res.status == 1){
            _this.data.unshift(res.data)
          }
        }).catch(function(err){
          _this.common.httpErr(err.data,_this);
        })
      }
    }
  }
</script>
<style lang="less">
  .table-m-grant{
    padding:0 90px 24px 10px; position: relative;width: 100%;
    .right-btn{
      width: 77px; position: absolute; right: 0; top: 0; bottom: 0;
      .edit-btn{
        margin-bottom:10px;
      }
      .ivu-checkbox-wrapper {
        font-size: 12px;
      }
    }
    .table-m-left{
      position: relative;z-index: 1;width: 100%;
      .tab-contact{
         width: 100%; position: absolute;right:0;
         .tags-view-s{
           position: relative;z-index: 1;width:100%;height: 24px;
           .tag-nav{
             display: block;width: 24px;height: 24px;font-size: 12px;position: absolute;z-index: 2;top:0;text-align: center;line-height: 24px;
             &-l{
               left: 0;
             }
             &-r{
               right: 0;
             }
           }
           .t-v-main{
             width: auto; height: 24px;position: absolute;left: 30px;right: 30px;overflow: hidden;
             .t-l-item{
               display: inline-block;float: right;
             }
             .t-v-wrap {
               display: inline-block;overflow: visible;white-space: nowrap;
               .g-v-item {
                 height: 24px; line-height: 24px;display: inline-block;padding: 0px 15px;font-size: 12px;float: right;cursor: pointer;
                 .iconfont{
                   font-size: 12px;
                 }
               }
             }
           }
         }

      }
    }
  }

</style>
