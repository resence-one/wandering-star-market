// ... existing code ...
import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '@/views/home/index.vue'
import LoginPage from '@/views/login/index.vue'
import RegisterPage from '@/views/register/index.vue'
import MainLayout from '@/layout/index.vue'
import GamesPage from '@/views/games/index.vue' // 引入 GamesPage 组件
import GameDetailPage from '@/views/game_detail/index.vue' // 引入 GameDetailPage 组件
import AdminLayout from '@/layout/AdminLayout.vue' // 引入 AdminLayout
import UserManagement from '@/views/admin/UserManagement.vue' // 引入用户管理组件
import GameManagement from '@/views/admin/GameManagement.vue' // 引入游戏管理组件

const routes = [
  {
    path: '/',
    component: MainLayout,
    redirect: '/home',
    children: [
      {
        path: 'home',
        name: 'Home',
        component: HomePage
      },
      {
        path: 'games', // 确保有这一行
        name: 'Games',
        component: GamesPage
      },
      {
        path: 'game/:id',
        name: 'GameDetail',
        component: GameDetailPage
      },
      {
        path: 'login',
        name: 'Login',
        component: LoginPage
      },
      {
        path: 'register',
        name: 'Register',
        component: RegisterPage
      }
    ]
  },
  {
    path: '/admin',
    component: AdminLayout,
    redirect: '/admin/users',
    children: [
      {
        path: 'users',
        name: 'UserManagement',
        component: UserManagement
      },
      {
        path: 'games',
        name: 'GameManagement',
        component: GameManagement
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router