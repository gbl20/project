import Demo from '@/components/public/demo'
import Welcome from '@/components/public/welcome'
import Login from '@/components/public/login'

export default[
  {
    path: '/',
    name: 'welcome',
    component: Welcome,
    meta: {
      title: '工作台'
    }
  }, {
    path: '/demo',
    name: 'demo',
    component: Demo
  },{
    path: '/login',
    name: 'login',
    component: Login
  }
]
