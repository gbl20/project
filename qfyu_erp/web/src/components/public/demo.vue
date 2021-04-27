<template>
    <div>
    <split-tb ref="splitPageRef" :Breadcrumb="Breadcrumb" :total='total' :splitInit='splitInit' :pageSizeNum=20 @DHeight="DHeight" @ChangePageOrSize="ChangePageOrSize">
        <div slot="form-ser">
          <div class="nav-menu">
            <a href="javascript:;">撤销</a>
            <a href="javascript:;">复制</a>
            <a href="javascript:;">刷新</a>
            <a href="javascript:;" @click="print">打印</a>
            <a href="javascript:;">撤销审核</a>
            <a href="javascript:;">下载</a>
          </div>
          <Breadcrumb class="ivu-breadcrumb-custom">
              <BreadcrumbItem to="/form">form</BreadcrumbItem>
              <BreadcrumbItem>Home</BreadcrumbItem>
              <BreadcrumbItem>welcome</BreadcrumbItem>
          </Breadcrumb>
          <div class="ser-form">
            <Form ref="formCustom" :label-width="80" :inline="true">
                <FormItem label="Password" prop="passwd">
                    <Input type="password" size="small"></Input>
                </FormItem>
                <FormItem label="Age" prop="age">
                    <Input type="text" number size="small"></Input>
                </FormItem>
                <FormItem label="Age" prop="age">
                  <Select style="width:200px" size="small">
                    <Option value="2">选项2</Option>
                    <Option value="1">选项1</Option>
                    <Option value="3">选项3</Option>
                  </Select>
                </FormItem>
                <FormItem v-if="isShow" label="Password" prop="passwd">
                    <Input type="password" size="small"></Input>
                </FormItem>
                <FormItem v-if="isShow" label="Confirm" prop="passwdCheck">
                    <Input type="password" size="small"></Input>
                </FormItem>
                <FormItem v-if="isShow" label="Age" prop="age">
                    <Input type="text" number size="small"></Input>
                </FormItem>
                <FormItem>
                    <Button type="primary" size="small">Submit</Button>
                    <Button type="default" size="small" @click="showHideS">{{!isShow?'打开':'隐藏'}}更多筛选</Button>
                </FormItem>
            </Form>
          </div>
        </div>
        <div slot="table-list">
           <Table id="table-m" size="small" stripe :columns="columns13" :data="data5" border class="table-m" @on-row-dblclick="dblclick" :highlight-row="true" :height="height"></Table>
        </div>
        <div slot="bottom">
          <Tabs>
              <TabPane label="macOS" icon="logo-apple">标签一的内容</TabPane>
              <TabPane label="Windows" icon="logo-windows">标签二的内容</TabPane>
              <TabPane label="Linux" icon="logo-tux">标签三的内容</TabPane>
          </Tabs>
        </div>
    </split-tb>
      <Modal title="你刚刚双击内容是: " :mask-closable="false" v-model="modal" :styles="{top: '20px'}">
        <p v-if="ModData" v-for="item in ModData">{{item}}</p>
    </Modal>
    </div>
</template>

<script>
  import {getLodop} from '@/assets/public/js/LodopFuncs.js'
  import splitTb from '@/components/public/splitTB'
    export default {
        components: {
          splitTb
        },
        data () {
            return {
              Breadcrumb:[{title:'demo'},{title:'demo'}],
              modal:false,
              ModData:null,
              isShow:true,
              splitInit:0.5,
              height:0,
              total:40,
                columns13: [
                    {
                        title: 'Date',
                        key: 'date',
                        resizable: true,
                        width: 180,fixed:'left'
                    },
                    {
                        title: 'Name',
                        key: 'name',
                        resizable: true,
                        width: 180
                    },
                    {
                        title: 'Age',
                        key: 'age',
                        resizable: true,
                        minWidth: 180
                    },
                    {
                        title: 'Address',
                        key: 'address',
                        resizable: true,
                        minWidth: 180
                    }
                ],
                data5: [
                    {
                        name: 'John Brown',
                        age: 18,
                        address: 'New York No. 1 Lake Park',
                        date: '2016-10-03'
                    },
                    {
                        name: 'Jim Green',
                        age: 24,
                        address: 'London No. 1 Lake Park',
                        date: '2016-10-01'
                    },
                    {
                        name: 'Joe Black',
                        age: 30,
                        address: 'Sydney No. 1 Lake Park',
                        date: '2016-10-02'
                    },
                    {
                        name: 'Jon Snow',
                        age: 26,
                        address: 'Ottawa No. 2 Lake Park',
                        date: '2016-10-04'
                    },
                    {
                        name: 'John Brown',
                        age: 18,
                        address: 'New York No. 1 Lake Park',
                        date: '2016-10-03'
                    },
                    {
                        name: 'Jim Green',
                        age: 24,
                        address: 'London No. 1 Lake Park',
                        date: '2016-10-01'
                    },
                    {
                        name: 'Joe Black',
                        age: 30,
                        address: 'Sydney No. 1 Lake Park',
                        date: '2016-10-02'
                    },
                    {
                        name: 'Jon Snow',
                        age: 26,
                        address: 'Ottawa No. 2 Lake Park',
                        date: '2016-10-04'
                    },
                    {
                        name: 'John Brown',
                        age: 18,
                        address: 'New York No. 1 Lake Park',
                        date: '2016-10-03'
                    },
                    {
                        name: 'Jim Green',
                        age: 24,
                        address: 'London No. 1 Lake Park',
                        date: '2016-10-01'
                    },
                    {
                        name: 'Joe Black',
                        age: 30,
                        address: 'Sydney No. 1 Lake Park',
                        date: '2016-10-02'
                    },
                    {
                        name: 'Jon Snow',
                        age: 26,
                        address: 'Ottawa No. 2 Lake Park',
                        date: '2016-10-04'
                    },
                    {
                        name: 'John Brown',
                        age: 18,
                        address: 'New York No. 1 Lake Park',
                        date: '2016-10-03'
                    },
                    {
                        name: 'Jim Green',
                        age: 24,
                        address: 'London No. 1 Lake Park',
                        date: '2016-10-01'
                    },
                    {
                        name: 'Joe Black',
                        age: 30,
                        address: 'Sydney No. 1 Lake Park',
                        date: '2016-10-02'
                    },
                    {
                        name: 'Jon Snow',
                        age: 26,
                        address: 'Ottawa No. 2 Lake Park',
                        date: '2016-10-04'
                    }
                ]
            }
        },
        methods:{
          DHeight(e){
            this.height = e;
          },
          ChangePageOrSize(e){
            console.log(e)
          },
          AddTitle(){
          		LODOP=getLodop();

          	},
          print(){
             let  LODOP = getLodop();
             LODOP.PRINT_INIT("打印控件功能演示_Lodop功能_不同高度幅面");
             LODOP.ADD_PRINT_TEXT(15,102,355,30,"北京市东城区沃乐福商城收款票据");
             LODOP.SET_PRINT_STYLEA(1,"FontSize",13);
             LODOP.SET_PRINT_STYLEA(1,"Bold",1);
             LODOP.ADD_PRINT_TEXT(50,15,100,20,"商品编号");
             LODOP.SET_PRINT_STYLEA(2,"FontSize",10);
             LODOP.SET_PRINT_STYLEA(2,"Bold",1);
             LODOP.ADD_PRINT_TEXT(50,149,100,20,"商品名称");
             LODOP.SET_PRINT_STYLEA(3,"FontSize",10);
             LODOP.SET_PRINT_STYLEA(3,"Bold",1);
             LODOP.ADD_PRINT_TEXT(50,339,200,20,"商品数量");
             LODOP.SET_PRINT_STYLEA(4,"FontSize",10);
             LODOP.SET_PRINT_STYLEA(4,"Bold",1);
             LODOP.ADD_PRINT_TEXT(50,599,100,20,"单价(元)");
             LODOP.SET_PRINT_STYLEA(5,"FontSize",10);
             LODOP.SET_PRINT_STYLEA(5,"Bold",1);
             LODOP.ADD_PRINT_LINE(72,14,73,700,0,1);
              var iCurLine=80;
              for (var i = 0; i < this.data5.length; i++) {
                  LODOP.ADD_PRINT_TEXT(iCurLine,15,100,20,this.data5[i]['name']);
                  LODOP.ADD_PRINT_TEXT(iCurLine,149,100,20,this.data5[i]['age']);
                  LODOP.ADD_PRINT_TEXT(iCurLine,339,200,20,this.data5[i]['address']);
                  LODOP.ADD_PRINT_TEXT(iCurLine,599,100,20,this.data5[i]['date']);
                  iCurLine=iCurLine+25;

              }
              LODOP.ADD_PRINT_LINE(iCurLine,14,iCurLine,700,0,1);
              LODOP.ADD_PRINT_TEXT(iCurLine+5,20,300,20,"打印时间："+(new Date()).toLocaleDateString()+" "+(new Date()).toLocaleTimeString());
                           LODOP.ADD_PRINT_TEXT(iCurLine+5,346,150,20,"合计金额：888.88");
              LODOP.SET_PRINT_PAGESIZE(3,1385,450,"");//这里3表示纵向打印且纸高“按内容的高度”；1385表示纸宽138.5mm；45表示页底空白4.5mm
              //LODOP.PREVIEW();
              LODOP.PRINT_DESIGN()//打开设置
               //  LODOP.PRINT()  //直接打印 */
              },
          showHideS:function(){
            this.isShow = this.isShow?false:true;
            _.debounce(this.$refs.splitPageRef.changeHeight,100)();
          },
          dblclick:function(item){
            this.ModData = item;
            this.modal = true;
          }
        }

    }
</script>
<style lang="less">
    .nav-menu{
      display: block;width: auto;padding:4px 10px;margin-bottom:5px;
      a{
        color: #ffffff;padding-right: 10px;
        &:hover{
          color: #d5d5d5;
        }
      }
    }
    .ivu-breadcrumb-custom{
      padding:0 10px;
    }

</style>
