<template>
	<div class="main">
    <split-none :Breadcrumb="Breadcrumb" :DHeight="DHeight">
      <div slot="form-ser">
        <div class="nav-menu">
          <Button @click="edit"><span class="icon iconfont">&#xe792;</span>保存设置</Button>
        </div>
      </div>
      <div slot="table-list">
        <Tabs type="card" :animated="false" v-model="Index" @on-click="changeTabs">
          <TabPane v-for="(item,index) in menuItem" :name="item.name" :label="item.label" :key="index">
            <Form :model="data[Index]" :label-width="80" class="tabs-TabPane-form">
              <Row>
                <Col span="12">
                  <formItem label="药检报告" v-if="Index==2">
                    <Input v-model="data[Index].verify_report"></Input>
                  </formItem>
                  <formItem label="灭菌批号" v-if="Index==3">
                    <Input v-model="data[Index].sterilization_batch"></Input>
                  </formItem>
                  <formItem label="生产批号" v-if="Index==3">
                    <Input v-model="data[Index].batch"></Input>
                  </formItem>
                  <formItem label="合格证" v-if="Index!=3">
                    <Input v-model="data[Index].certificato"></Input>
                  </formItem>
                  <formItem label="外观质量">
                    <Select transfer v-model="data[Index].quality_state">
                      <Option v-for="(item,index) in typeItem.quality_state" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </formItem>
                  <formItem label="包装情况">
                    <Select transfer v-model="data[Index].package_state">
                      <Option v-for="(item,index) in typeItem.package_state" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </formItem>
                  <formItem label="标签状况">
                    <Select transfer v-model="data[Index].label_state">
                      <Option v-for="(item,index) in typeItem.label_state" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </formItem>
                </Col>
                <Col span="12">
                  <formItem label="通关文号" v-if="Index==2">
                    <Input v-model="data[Index].pass_gate_no"></Input>
                  </formItem>
                  <formItem label="注册证号" v-if="Index==3">
                    <Input v-model="data[Index].register_card_no"></Input>
                  </formItem>
                  <formItem label="说明书状况">
                    <Select transfer v-model="data[Index].directions">
                      <Option v-for="(item,index) in typeItem.directions" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </formItem>
                  <formItem label="验收结论">
                    <Select transfer v-model="data[Index].check_verdict">
                      <Option v-for="(item,index) in typeItem.check_verdict" :value="item" :key="index">{{item}}</Option>
                    </Select>
                  </formItem>
                  <formItem label="验货人">
                    <Input icon="ios-more" v-model="data[Index].checker" @on-click="openEmplyee('checker')"></Input>
                  </formItem>
                  <formItem label="收货人">
                    <Input icon="ios-more" v-model="data[Index].accepter" @on-click="openEmplyee('accepter')"></Input>
                  </formItem>
                </Col>
              </Row>
            </Form>
          </TabPane>
        </Tabs>
      </div>
    </split-none>
    <select-employee ref="selEmplyeeRef" @selemp="comfirm" @clear_sel="clear"></select-employee>
  </div>
</template>

<script>
  var _this;
  import splitNone from "@/components/public/splitNone"
  import SelectEmployee from "@/components/common/SelectEmployee"
	export default {
		name: "goodsCheckAcceptDefault",
    components: {splitNone,SelectEmployee},
    data:function () {
      return{
        Breadcrumb:[{title:'采购管理'},{title:'质量验收'},{title:'质量验收默认设置'}],
        menuItem:[
          {name:"1",label:'普通药品'},
          {name:"2",label:'进口药品'},
          {name:"3",label:'医疗器械'},
          {name:"4",label:'中药饮片'},
          {name:"5",label:'特殊商品'},
          {name:"6",label:'非商品'},
        ],
        Index:"1",
        height:0,
        name:null,
        data:[],
        typeItem:this.$store.state.sysParam['check_default']
      }
    },
    mounted() {
		  _this=this;
    },
    created() {
      this.init();
    },
    methods:{
		  init:function(){
        this.common.http({
          url:"getGoodsCheckDefault"
        }).then(function (res) {
          if (res.status){
            _this.data = res.data;
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      edit:function(){
		    var data = {data:this.data[this.Index]}
		    this.common.http({
          url:'editGoodsCheckDefault',
          data:data
        }).then(function (res) {
          if (res.status) _this.init();
          else _this.alertMsg(res.msg,'error');
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this);
        })
      },
      openEmplyee:function(name){
		    this.name = name;
		    this.$refs.selEmplyeeRef.init({show_self:1});
      },
      comfirm:function(e){
		    this.data[this.Index].this.name = e.code;
		    console.log(e)
      },
      clear:function(){

      },
      changeTabs:function (name) {
		    if(name==7) return false;
        this.Index = name;
      },
      DHeight:function (e) {
        this.height = e;
      }
    }
	}
</script>

<style lang="less">
  .main{
    .tabs-TabPane-form{
      width: 668px;
    }
  }
</style>
