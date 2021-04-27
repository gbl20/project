import Power from '@/components/system_set/power/index'

export default[
  {
    path: '/power',
    name: 'power',
    component: Power,
    meta: {
      title: '权限管理', 
      keepAlive: true, //控制页面缓存参数
    }

  }
]
