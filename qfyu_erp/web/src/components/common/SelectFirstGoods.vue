<template>
	<div>
    <Modal title="选择首营品种" :closable="false" :mask-closable="false" v-model="Model" width="1000">
      <Table border highlight-row :height="450" :columns="columns" :data="data" @on-row-click="(item,index)=>{changeRow(item,index,false)}" @on-row-dblclick="(item,index)=>{changeRow(item,index,true)}"></Table>
      <div class="pro-pages">
        <Page :total="total" :page-size="page_size" :page-size-opts="[15,25,35,50]" size="small" show-total @on-change="ChangePage" />
      </div>
      <div slot="footer">
        <Button @click="cancelData(false)">取消</Button>
        <Button type="primary" @click="confirm">选定</Button>
        <Button type="primary" @click="cancelData(true)">自定义添加</Button>
      </div>
    </Modal>
  </div>
</template>
<script>
  var formData = {
    name:'',goods_name:'',goods_code:'',en_name:'',code:'',file_name:'',pym:'',specs:'',packspecs:'',electron_code:'', color_code:'', kinds_id:null, kinds_kid:null,kinds_name:'',category_id:null, function_id:[], origin:'', production:'', maker:'', unit:'', unit2:null, is_solit:0, solit_value:null, dosage:null, tax:null, approval_code:'', approval_date:'', shelf_life:'', shelf_unit:'', take:null, gsp_type:null, standard_code:'', supervise_code:'', pack_specs1:null, pack_specs2:null, drug:'', drug_unit:'', hours:'', element_type:null, coloc_type:null, billing_type:null, pifaml:null, retail:null,  depart_name:'',depart_id:null, markup:0, is_medical:0, is_check:0, is_qty:0, is_first:0, is_variety:0, is_rx:0, is_shopping:1, is_yi:0, is_yymz:0, is_vip:0, is_supervise:0, is_drugs:0, is_gift:0, creater:'', creater_date:'', checker:'', check_date:'', update_date:'', remark:'', abc:'', abkind:'', quality_standards:'', quality_date:'', exterior:'', brand:'', brand_date:'', level:null, gmp_code:'', gmp_property:'', gmp_end_date:'', license_key:'', license_date:'', code1:'', code1_date:'', code2:'', code2_date:'', custom_name:'', custom_val:'', custom_code1:'', custom_code2:'', custom_code3:'', start_give_amount:null, give_amount:null, times_give:1, give_date:'', integral:'', buyer_type:0, is_new:0, is_buyer:0, supplier:'', amount:null, buyer_id:null, buyer_name:'',buyer_day:'', buyer_cycle:'', buyer_multiple:'', day:'', tend_type:'', tend_day:'', storage_type:'', max_qty:null, min_qty:null, salesman:null,salesman_name:'', wholesale_amount:null, retail_amount:null, sala_multiple:null, is_sale:0, is_wholesale:0, is_retail:0, wholesale_price:null, factory_price:null, buyer_price:null, buyer_price2:null,retail_price:null,retail_price2:null,trade_price:null,trade_price2:null,status:null};
	export default {
		data:function () {
      return{
        Model:false,
        Index:-1,
        columns:[
          {title:'商品编号',key:'goods_code',width:90,minWidth:90,resizable:true,ellipsis:true},
          {title:'单据号',key:'orderid',width:160,minWidth:160,resizable:true,ellipsis:true},
          {title:'日期',key:'create_date',width:150,minWidth:150,resizable:true,ellipsis:true},
          {title:'通用名称',key:'name',width:130,minWidth:100,resizable:true,ellipsis:true},
          {title:'商品名称',key:'goods_name',width:130,minWidth:100,resizable:true,ellipsis:true},
          {title:'剂型',key:'dosage',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'规格',key:'specs',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'单位',key:'unit',width:80,minWidth:80,resizable:true,ellipsis:true},
          {title:'生产单位',key:'production',width:120,minWidth:100,resizable:true,ellipsis:true},
          {title:'性能描述',key:'description',width:140,minWidth:100,resizable:true,ellipsis:true},
          {title:'批准文号',key:'approval_code',width:140,minWidth:100,resizable:true,ellipsis:true},
          {title:'申请原因',key:'remark',width:100,minWidth:100,resizable:true,ellipsis:true},
          {title:'质量标准',key:'quality_standards',width:100,minWidth:100,resizable:true,ellipsis:true},
        ],
        data:[],
        total:0,
        page:1,
        page_size:15,
      }
    },
    methods:{
		  init:function(){
        var _this=this;
        this.common.http({
          url:'getComFirstGoodsList',
          data:{page_size: this.page_size,page: this.page,order_status:this.order_status}
        }).then(function (res) {
          if (res.status){
            _this.data = res.data.data;
            _this.total= res.data.total;
            if(!_this.data.length){
              _this.Model = false;
              _this.$emit('close');
            }else{
              _this.Model = true;
            }
          }
        }).catch(function (err) {
          _this.common.httpErr(err.data,_this)
        })
      },
		  open:function(){
        this.init();
      },
      confirm:function(){
		    if (this.Index==-1){
		      return this.alertMsg('请选择首营品种！','error');
        }
		    var data = this.setFormData(this.data[this.Index]);
		    this.$emit('confirm',data);
        this.Model = false;
      },
      setFormData:function(obj){
        var data = JSON.parse(JSON.stringify(formData));
        for(let i in data){
          if(typeof obj[i] != 'undefined'){
            data[i] = obj[i]
          }
        }
        data.tax = this.formatFloat(data.tax,4)
        data.take = this.formatFloat(data.take,4)
        data.pifaml = this.formatFloat(data.pifaml,4)
        data.retail = this.formatFloat(data.retail,4)
        data.gsp_type = String(data.gsp_type)
        return data;
      },
      changeRow:function (item,index,type) {
        this.Index = index;
        if(type) this.confirm();
      },
      cancelData:function (type) {
        this.Model = false;
        if(type) this.$emit('customize',type)
      },
      ChangePage:function () {

      }
    }
	}
</script>

<style lang="less">

</style>
