<template>
  <div class="admin-layout">
    <el-container>
      <el-aside width="200px" class="admin-sidebar">
        <el-menu
          default-active="2"
          class="el-menu-vertical-demo"
          router
          background-color="#2a2a2a"
          text-color="#e0e0e0"
          active-text-color="#409eff"
        >
          <h3 class="sidebar-title">管理后台</h3>
          <el-menu-item index="/admin/users">
            <el-icon><user /></el-icon>
            <span>用户管理</span>
          </el-menu-item>
          <el-menu-item index="/admin/games">
            <el-icon><game-controller /></el-icon>
            <span>游戏管理</span>
          </el-menu-item>
          <el-menu-item index="/login" @click="handleLogout">
            <el-icon><switch-button /></el-icon>
            <span>退出登录</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-main class="admin-main-content">
        <router-view></router-view>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { User, GameController, SwitchButton } from '@element-plus/icons-vue' // 导入Element Plus图标和SwitchButton
import { useRouter } from 'vue-router' // 导入 useRouter
import { useUserStore } from '@/store/user' // 导入 useUserStore

const router = useRouter()
const userStore = useUserStore()

const handleLogout = () => {
  userStore.logout()
  router.push('/login') // 退出后跳转到登录页面
}
</script>

<style lang="scss" scoped>
.admin-layout {
  min-height: 100vh;
  background-color: #1a1a1a; // 整体暗色背景

  .el-container {
    min-height: 100vh;
  }

  .admin-sidebar {
    background-color: #2a2a2a;
    border-right: 1px solid #3a3a3a;
    padding-top: 20px;

    .sidebar-title {
      color: #e0e0e0;
      text-align: center;
      margin-bottom: 20px;
      font-size: 20px;
    }

    .el-menu {
      border-right: none; // 移除el-menu自带的边框
    }

    .el-menu-item {
      color: #e0e0e0;
      &:hover {
        background-color: #3a3a3a;
        color: #409eff;
      }
      &.is-active {
        background-color: #409eff !important;
        color: #fff !important;
      }
    }
  }

  .admin-main-content {
    background-color: #1a1a1a; // 主内容区背景色
    color: #e0e0e0;
    padding: 20px;
  }
}
</style> 