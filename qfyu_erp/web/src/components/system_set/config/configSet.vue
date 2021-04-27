<template>
	<div :style="'height:'+height+'px;overflow-y: auto;'">
    <Form :model="formData" :label-width="120">
      <div class="le w492">
        <div class="item border-color">
          <div class="i-label border-b bg-text">参考价设置</div>
          <div class="content">
            <FormItem label="采购参考价格体系:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
              <span class="icon iconfont">&#xe7fd;</span>
              <Input class="w102" v-model="formData.peice"></Input>
            </FormItem>
            <FormItem label="限定采购价:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
            </FormItem>
            <FormItem label="批发参考价格体系:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
              <span class="icon iconfont">&#xe7fd;</span>
              <Input class="w102" v-model="formData.peice"></Input>
            </FormItem>
            <FormItem label="限定批发价:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
            </FormItem>
            <FormItem label="零售参考价格体系:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
              <span class="icon iconfont">&#xe7fd;</span>
              <Input class="w102" v-model="formData.peice"></Input>
            </FormItem>
            <FormItem label="以最近采购价更新:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
            </FormItem>
            <FormItem label="以最近批发价更新:">
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
            </FormItem>
            <Row class-name="mb8"><Checkbox v-model="formData.single">将商品最近进价更新/添加到该供应商协议品种</Checkbox></Row>
            <Row class-name="mb8"><Checkbox v-model="formData.single">将商品最近进价更新/添加到该客户协议品种</Checkbox></Row>
          </div>
        </div>
        <div class="item border-color">
          <div class="i-label border-b bg-text">成本核算方式</div>
          <div class="content">
            <Row class-name="mb8">
              <Col span="12"><Radio v-model="formData.aa">批次法</Radio></Col>
              <Col span="12"><Radio v-model="formData.aa">月加权平均法</Radio></Col>
            </Row>
            <Row>
              <Col span="12"><Radio v-model="formData.aa">指定成本价格方案</Radio></Col>
              <Col span="12">
                <Select class="w176" v-model="formData.peice">
                  <Option value="1">标准进价</Option>
                </Select>
              </Col>
            </Row>
          </div>
        </div>
        <div class="item border-color">
          <div class="i-label border-b bg-text">销售模式</div>
          <div class="content">
            <Row class-name="mb8"><Radio v-model="formData.aa">正常销售</Radio></Row>
            <Row><Radio v-model="formData.aa">委托销售</Radio></Row>
          </div>
        </div>
        <div class="item border-color">
          <div class="i-label border-b bg-text">
            直连服务器参数
            <span class="ri">禁用本机直连功能:<Checkbox v-model="formData.ad"></Checkbox></span>
          </div>
          <div class="content">
            <Row class-name="mb8">
              <Radio v-model="formData.aa">外连接</Radio>
              <Radio v-model="formData.aa">内连接</Radio>
            </Row>
            <Row class-name="mb8">
              <div class="s-label" style="float: left">IP地址:</div>
              <Input class="w304" v-model="formData.qty"></Input>
              <Button style="margin-left: 12px;" type="primary">设定</Button>
            </Row>
            <Row class-name="mb8">
              <Col span="11">
                <div class="s-label" style="float: left">登录名称:</div>
                <Input v-model="formData.qty"></Input>
              </Col>
              <Col span="2">&nbsp;</Col>
              <Col span="11">
                <div class="s-label" style="float: left">登陆密码:</div>
                <Input v-model="formData.qty"></Input>
              </Col>
            </Row>
          </div>
        </div>
      </div>
      <div class="le w492">
        <div class="item border-color">
          <div class="i-label border-b bg-text">默认值设置</div>
          <div class="content">
            <FormItem label="默认全局入库仓库:">
              <Input class="w176" icon="ios-more" v-model="formData.qty"></Input><span class="pd8 bg-text">账套内有效</span>
            </FormItem>
            <FormItem label="默认全局发货仓库:">
              <Input class="w176" icon="ios-more" v-model="formData.qty"></Input><span class="pd8 bg-text">账套内有效</span>
            </FormItem>
            <FormItem label="默认本机入库仓库:">
              <Input class="w176" icon="ios-more" v-model="formData.qty"></Input><span class="pd8 bg-text">对本机有效</span>
            </FormItem>
            <FormItem label="默认本机发货仓库:">
              <Input class="w176" icon="ios-more" v-model="formData.qty"></Input><span class="pd8 bg-text">对本机有效</span>
            </FormItem>
            <FormItem label="默认检测:">
              <Input class="w102" v-model="formData.qty"></Input><span class="pd8 bg-text">天内将失效的库存商品</span>
            </FormItem>
            <FormItem label="默认检测:">
              <Input class="w102" v-model="formData.qty"></Input><span class="pd8 bg-text">天内需养护的库存商品</span>
            </FormItem>
            <Row class-name="mt8 mb8"><Checkbox v-model="formData.single">验收时，合格数量等于验收数量</Checkbox></Row>
            <Row class-name="mb8"><Checkbox v-model="formData.single">验收时，不合格品直接拒收</Checkbox></Row>
            <Row class-name="mb8"><div class="s-label" style="float: left">销售开单审核时库存检测类型:</div>
              <Select class="w176" v-model="formData.peice">
                <Option value="1">标准进价</Option>
              </Select>
            </Row>
            <FormItem label="质量疑问药品仓:">
              <Input class="w176" icon="ios-more" v-model="formData.qty"></Input><span class="pd8 bg-text">质量疑问仓</span>
            </FormItem>
            <FormItem label="不合格药品仓:">
              <Input class="w176" icon="ios-more" v-model="formData.qty"></Input><span class="pd8 bg-text">不合格品仓</span>
            </FormItem>
            <span class="txt-color">提示：质量疑问品仓和不合格品仓设定后不可修改！</span>
          </div>
        </div>
        <div class="item border-color">
          <div class="i-label border-b bg-text">启动参数</div>
          <div class="content">
            <FormItem>
              <Checkbox v-model="formData.single">自动合并辅单位库存量</Checkbox>
            </FormItem>
            <FormItem label="商品类别编码格式:">
              <Input class="w240" v-model="formData.qty"></Input>
            </FormItem>
            <FormItem label="部门编号编码格式:">
              <Input class="w240" v-model="formData.qty"></Input>
            </FormItem>
            <FormItem label="仓库编号编码格式:">
              <Input class="w240" v-model="formData.qty"></Input>
            </FormItem>
            <FormItem label="月度结算截止日期:">
              <Input class="w120" v-model="formData.qty"></Input>
              <span class="pd8 bg-text">0：月末最后一天</span>
            </FormItem>
            <Row class-name="m16">
              <span class="error-text">启动参数在启用账套后将不能再修改，具体设置请参阅帮助文件或用
户手册。</span>
            </Row>
          </div>
        </div>
      </div>
      <div class="le w618">
        <div class="item border-color">
          <div class="i-label border-b bg-text">药检报告设置</div>
          <div class="content">
            <Row>
              <div class="s-label" style="float: left">药检报告在服务器上的存放文件夹:</div>
              <Input class="w304" icon="ios-more" v-model="formData.qty"></Input>
            </Row>
            <Row class-name="m16">
              <span class="error-text">提示：药检报告存放文件一旦设定，就不要再修改！如果非得修改，请手动到服务器上复
制原文件夹中的药检报告文件到新文件夹中。</span>
            </Row>
            <Row><Checkbox v-model="formData.single">验收时，合格数量等于验收数量</Checkbox></Row>
            <Row class-name="m32"><Button class="btn" type="primary">清理无库存的药检报告</Button></Row>
            <Row class-name="mb16"><Checkbox v-model="formData.single">验收时，不合格品直接拒收</Checkbox></Row>
            <Row>
              <div class="s-label" style="float: left">药检报告删除时存档文件夹:</div>
              <Input class="w304" icon="ios-more" v-model="formData.qty"></Input>
            </Row>
          </div>
        </div>
      </div>
    </Form>

  </div>
</template>

<script>
	export default {
	  props:{
      height:0
    },
    data(){
      return{
        msg:'系统运行参数设定',
        formData:{}
      }
    },
    methods:{
      init:function () {
        console.log('hello 系统运行参数设定')
      }
    }
	}
</script>

<style lang="less">
  .le{
    margin-left: 64px;float: left;
  }
  .w492{
    width: 492px;
  }
  .w618{
    width: 618px;
  }
  .item{
    border-width: 1px;border-style: solid;border-radius: 2px;margin-bottom: 8px;
    .i-label{
      height: 48px;line-height: 48px;padding:0 24px;font-size: 14px;
    }
    .content{
      padding: 24px 32px;
      .w176{float: left;width:176px;}
      .w102{float: left;width: 102px;}
      .w120{float: left;width: 120px;}
      .w240{float: left;width: 240px;}
      .w304{float: left;width: 304px;}
      .icon{float: left;margin: 0 4px;}
      .pd8{padding-left: 8px;}
      .s-label{float: left;padding-right: 6px;line-height: 28px;}
      .mt8{margin-top: 8px;}
      .mb8{margin-bottom: 8px;}
      .m16{margin: 16px 0;}
      .m32{margin-top: 32px;}
      .mb16{margin-top: 16px;margin-bottom: 12px;}
      .btn{
        width: 172px;height: 32px;background: #1d65ff;border-radius: 2px;text-align: center;
      }
    }
    .ri{display: inline-block;float: right;}
  }
</style>
