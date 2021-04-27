const KValue = null;
export default{
  KValue,
  /**
   * @param {Object} _this
   * @param {Object} h
   * @param {Object} params
   * @param {Object} key  //input name
   * @param {Object} isNum 是否为数字
   * @param {Object} isMore 'ios-more'是否显示
   * @param {Object} otherProp 其它参数
   */
  renderInput (_this,h,params,key,isNum,isMore,otherProp,type) {
    if(!params.row.isEdit) return h('div', params.row[key])
    isMore = isMore || false;
    isNum = isNum || 0;
    type = type || 'text';
    otherProp = otherProp || {};
    let ref = key + params.row._index + '_c';
    return h('Input', {
      class: [
        `${ref}`
      ],
      props: {
        type: type,
        icon: isMore?"ios-more":'',
        value: params.row[key],
        ...otherProp
      },
      on: {
        'on-blur':(e)=>{
          _this.inputEach('blur',key,params.row._index)
        },
        'on-change':(e)=>{
          setTimeout(()=>{
            this.KValue = e.target.value
            _this.inputEach('change',key,params.row._index)
          },50)
        },
        'on-focus':(e)=>{
          this.KValue = params.row[key];
          setTimeout(()=>{
            document.getElementsByClassName(`${ref}`)[0].children[1].select()
          })
        },
        'on-click':()=>{
          _this.inputEach('click',key,params.row._index)
        },
        'on-enter':()=>{
          _this.inputEach('enter',key,params.row._index)
        }
      },
      nativeOn: {
        keydown: (event) => {
          if (event.keyCode === 38) {
            if (this.cando) return;
            this.cando = true;
            setTimeout(() => {
              this.cando = false;
              let name = key + (params.row._index - 1) + '_c'
              let getChildren = document.getElementsByClassName(`${name}`)[0] || false;
              if(getChildren) return document.getElementsByClassName(`${name}`)[0].children[1].focus();
              else return;
            }, 50)
          }
          if (event.keyCode === 40) {
            if (this.cando) return;
            this.cando = true;
            setTimeout(() => {
              this.cando = false;
              let name = key + (params.row._index + 1) + '_c'
              let getChildren = document.getElementsByClassName(`${name}`)[0] || false;
              if(getChildren) return document.getElementsByClassName(`${name}`)[0].children[1].focus();
              else return;
            }, 50)
          }
        },
        input: (e) => {
          let val = e.target.value
          if (isNum) {
            val = val.replace(/[^\d.]/g, "");
            val = val.replace(/\.{2,}/g, ".");
            val = val.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
            val = val.replace(/^(\-)*(\d+)\.(\d\d\d).*$/, '$1$2.$3');
            setTimeout(() =>{
              document.getElementsByClassName(`${ref}`)[0].children[1].value = val
            }, 2)
            this.KValue = val
          } else {
            this.KValue = val
          }
        }
      },
      key: ref
    })
  },
  /**
   * @param {Object} _this
   * @param {Object} h
   * @param {Object} params
   * @param {Object} key //input name
   * @param {Object} type
   * @param {Object} otherProp 其它参数
   */
  renderDate(_this,h, params,key,type,otherProp){
    if(!params.row.isEdit) return h('div', params.row[key])
    type = type || 'date';
    otherProp = otherProp || {};
    let ref = key + params.row._index + '_c';
    return h('DatePicker', {
      class: [
        `${ref}`
      ],
      props: {
        value: params.row[key],
        type: type,
        transfer: true,
        editable: false,
        clearable: true,
        ...otherProp
      },
      style: {
        width: '100%'
      },
      on:{
        'on-change':(e)=> {
          setTimeout(()=>{
            this.KValue = e
            _this.inputEach('change',key,params.row._index)
          },50)
        }
      },
      key: ref
    });
  },
  inputFocus(_this,key,index){
    _this.$nextTick(()=>{
      let name = key + index + '_c'
      document.getElementsByClassName(`${name}`)[0].children[1].focus()
    })
  }
}
