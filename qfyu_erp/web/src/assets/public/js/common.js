import axios from 'axios'
const BASE_URL = 'http://api.erp.cc';
const md5Salt = 'QFYuErp2020';
export default{
   BASE_URL,md5Salt,
   http:function(options){
     return new Promise((resolve, reject) => {
       const defaultOptions = {};
       const newOptions = {
         ...defaultOptions,
         ...options
       };
       newOptions.headers = {
         'content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
         ...newOptions.headers
       };
       newOptions.data = {
         token:this.getToken(),
         acc:localStorage.getItem("acc"),
         ...newOptions.data
       };
       axios({
         method: newOptions.method || 'POST',
         url: BASE_URL+'/'+newOptions.url,
         data: newOptions.data,
         headers: newOptions.headers
       }).then(res => {
         if (res.status == 200) {
            if(res.data.status == 401 || res.data.status == 402){
               reject(res);
            }else{
              resolve(res.data);
            }
         } else {
            reject(res);
         }
       }).catch(err => {
          err.data = {status:404,msg:'请求失败'};
          reject(err);
       })
     })
  },
  getToken:function(){

    return localStorage.getItem('token')
  },
  httpErr:function(errRes,_this){
    if(typeof errRes == 'undefined' || !errRes) return false;
    if(errRes.status == 401){
      _this.$Message.error({content:'请登录', background :true});
      localStorage.removeItem('token');
      localStorage.removeItem('acc');
      _this.$router.push({ path: "/login" });
    }else if(errRes.status == 402){
      _this.alertMsg(errRes.msg,'error');
    }else _this.$Message.error({content:errRes.msg, background :true});
  }
}
