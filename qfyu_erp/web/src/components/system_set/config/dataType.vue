<template>
<div>
  <h2>{{msg}}</h2>
</div>
</template>

<script>
  export default {
    data(){
      return{
        msg:'数据类型及访问方式'
      }
    },
    methods:{
      init:function () {
        console.log('hello 业务参数')
      }
    }
  }
</script>

<style lang="less">

</style>
