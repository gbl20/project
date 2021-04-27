module.exports = {
    error:'',
    check:function (data,rule) {
        for (let i=0;i<rule.length;i++){
            if(!rule[i].checkType){return true;}
            if(!rule[i].name){return true;}
            if(!rule[i].errorMsg){return true;}
            if(!data[rule[i].name]){return true;}
            switch (rule[i].checkType) {
                case 'date':
                    let currentDate = new Date();
                    if(typeof(data[rule[i].name])!=="undefined" && typeof(data[rule[i].name])==="string"){
                        let customDate = new Date(data[rule[i].name]);
                        if(currentDate >= customDate){
                            this.error = rule[i].errorMsg;
                            return false;
                        }
                    }
                break;
                case 'string':
                  var reg = new RegExp('^.{' + rule[i].checkRule + '}$');
                  if(!reg.test(data[rule[i].name])) {this.error = rule[i].errorMsg; return false;}
                break;
            }
        }
        return true;
    }
}
