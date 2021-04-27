import Employee from '@/components/data_mana/employee/index.vue'
import Branch from '@/components/data_mana/branch/index.vue'

export default[
  {
    path: '/employee',
    name: 'employee',
    component: Employee,
    meta: {
      title: '员工资料',
      keepAlive: true,
    }
  },
  {
    path: '/branch',
    name: 'branch',
    component: Branch,
    meta: {
      title: '企业机构管理',
      keepAlive: true,
    }
  }
]
