export default{
  toTypeUrl(type,orderid,_this){
    switch(type){
      case 1:
        localStorage.setItem("quality_gsp1_orderid",orderid);
        _this.toUrl('/SelQualityAcceptGsp1');
        break;
      case 2:
        localStorage.setItem("quality_gsp2_orderid",orderid);
        _this.toUrl('/SelQualityAcceptGsp2');
        break;
      case 3:
        localStorage.setItem("quality_gsp3_orderid",orderid);
        _this.toUrl('/SelQualityAcceptGsp3');
        break;
      case 4:
        localStorage.setItem("quality_gsp4_orderid",orderid);
        _this.toUrl('/SelQualityAcceptGsp4');
        break;
      case 5:
        localStorage.setItem("quality_gsp5_orderid",orderid);
        _this.toUrl('/SelQualityAcceptGsp5');
        break;
      default:
        localStorage.setItem("quality_gsp6_orderid",orderid);
        _this.toUrl('/SelQualityAcceptGsp6');
    }
  }
}
