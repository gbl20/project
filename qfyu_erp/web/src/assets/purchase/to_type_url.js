export default{
  toTypeUrl(type,orderid,_this){
    switch(type){
       case 1:
         localStorage.setItem("edit_general_orderid",orderid);
         _this.toUrl('/GeneralMedicine');
         break;
       case 2:
         localStorage.setItem("edit_imported_orderid",orderid);
         _this.toUrl('/ImportedMedicines');
         break;
       case 3:
         localStorage.setItem("edit_instruments_orderid",orderid);
         _this.toUrl('/InstrumentsMedical');
         break;
       case 4:
         localStorage.setItem("edit_chinese_orderid",orderid);
         _this.toUrl('/ChineseHerbalMedicine');
         break;
       case 5:
         localStorage.setItem("edit_special_orderid",orderid);
         _this.toUrl('/SpecialMedicine');
         break;
       default:
         localStorage.setItem("edit_drug_orderid",orderid);
         _this.toUrl('/NonDrug');
    }
  }
}
