<template>
  <div class="main-layout">
    <header class="app-header">
      <div class="header-content">
        <div class="logo">
              <img src="/Logo.svg" alt="游戏商城" /> <!-- 修改为 /logo.svg -->
            </div>
        <nav class="main-nav">
          <ul>
            <li><router-link to="/home" exact>首页</router-link></li>
            <li><router-link to="/games">商店</router-link></li>
            <li><a href="#">社区</a></li>
            <li><a href="#">点卡</a></li>
            <li><a href="#">周边</a></li>
          </ul>
        </nav>
        <div class="user-actions">
          <template v-if="isLoggedIn">
            <el-dropdown trigger="click">
              <span class="el-dropdown-link username">
                欢迎, {{ username }}<el-icon class="el-icon--right"><arrow-down /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="router.push('/library')">库</el-dropdown-item>
                  <el-dropdown-item @click="router.push('/cart')">购物车</el-dropdown-item>
                  <el-dropdown-item @click="router.push('/wishlist')">心愿单</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
            <el-button type="danger" size="small" @click="handleLogout" v-if="!isAdmin">退出登录</el-button>
          </template>
          <template v-else>
            <router-link to="/login" class="login-btn">登录</router-link>
            <router-link to="/register" class="register-btn">注册</router-link>
          </template>
        </div>
      </div>
    </header>

    <main class="app-main">
      <router-view></router-view>
    </main>

    <footer class="app-footer">
      <div class="footer-content">
        <div class="footer-links">
          <div class="link-group">
            <h3>关于我们</h3>
            <ul>
              <li><a href="#">关于中电博亚</a></li>
              <li><a href="#">游星开发者平台</a></li>
              <li><a href="#">跃计划</a></li>
            </ul>
          </div>
          <div class="link-group">
            <h3>客户服务</h3>
            <ul>
              <li><a href="#">联系方式</a></li>
              <li><a href="#">工作机会</a></li>
              <li><a href="#">客户服务</a></li>
              <li><a href="#">家长监护</a></li>
              <li><a href="#">账号申诉</a></li>
            </ul>
          </div>
          <div class="link-group">
            <h3>合作与推广</h3>
            <ul>
              <li><a href="#">加入推广联盟</a></li>
            </ul>
          </div>
          <div class="link-group">
            <h3>法律信息</h3>
            <ul>
              <li><a href="#">游星平台协议</a></li>
              <li><a href="#">游星隐私协议</a></li>
              <li><a href="#">游星会员协议</a></li>
            </ul>
          </div>
        </div>
        <div class="footer-info">
          <p>2025 北京中电博亚科技有限公司版权所有 所有商标版权属于其拥有者</p>
          <p>Tel:010-68434500 经营执照</p>
          <p>京公网安备11010802020140号 新出发京批字第直0816号 京ICP证140082号 京ICP备12041226号</p>
          <p class="health-tip">健康游戏忠告:抵制不良游戏 拒绝盗版游戏 注意自我保护 谨防受骗上当 适度游戏益脑 沉迷游戏伤身 合理安排时间 享受健康生活</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user' // 导入 user store
import { storeToRefs } from 'pinia' // 导入 storeToRefs
import { computed } from 'vue' // 导入 computed
import { ArrowDown } from '@element-plus/icons-vue' // 导入 Element Plus 图标

const router = useRouter()
const userStore = useUserStore() // 使用 user store

// 使用 storeToRefs 解构 store 中的响应式属性
const { isLoggedIn, userInfo, isAdmin } = storeToRefs(userStore)

// 创建一个计算属性来获取用户名
const username = computed(() => userInfo.value ? userInfo.value.username : '')

const handleLogout = () => {
  userStore.logout()
  router.push('/login') // 退出后跳转到登录页面
}
</script>

<style lang="scss" scoped>
.main-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #1a1a1a; // 整体暗色背景
  color: #e0e0e0; // 默认文字颜色

  .app-header {
    background-color: #222; // 头部背景色
    padding: 15px 40px;
    border-bottom: 1px solid #333;

    .header-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
      max-width: 1400px; // 限制内容宽度
      margin: 0 auto;
    }

    .logo {
      display: flex;
      align-items: center;

      img {
        height: 40px;
        margin-right: 10px;
      }

      span {
        font-size: 24px;
        font-weight: bold;
        color: #fff;
      }
    }

    .main-nav {
      ul {
        display: flex;
        list-style: none;
        margin: 0;
        padding: 0;

        li {
          margin: 0 20px;

          a {
            color: #e0e0e0;
            text-decoration: none;
            font-size: 16px;
            transition: color 0.3s;

            &:hover,
            &.router-link-active {
              color: #409eff; // 选中和hover颜色
            }
          }
        }
      }
    }

    .user-actions {
      display: flex; /* 确保内容水平排列 */
      align-items: center; /* 垂直居中 */
      gap: 15px; /* 元素间距 */

      .username {
        font-size: 16px;
        color: #fff;
        margin-right: 10px;
      }

      .login-btn,
      .register-btn,
      .el-button {
        background-color: transparent;
        border: 1px solid #409eff;
        color: #409eff;
        padding: 8px 15px;
        border-radius: 4px;
        text-decoration: none;
        transition: all 0.3s;

        &:hover {
          background-color: #409eff;
          color: #fff;
        }
      }

      // 为退出按钮添加特定样式
      .el-button--danger {
        background-color: #f56c6c;
        border-color: #f56c6c;
        color: #fff;

        &:hover {
          background-color: #f78989;
          border-color: #f78989;
        }
      }

      // 下拉菜单样式
      :deep(.el-dropdown-menu) {
        background-color: #2a2a2a !important; /* 强制设置为暗色背景 */
        border: 1px solid #3a3a3a; /* 与卡片边框一致 */
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4); /* 与卡片阴影一致 */
      }

      :deep(.el-dropdown-menu__item) {
        color: #e0e0e0; /* 文字颜色 */

        &:hover {
          background-color: #409eff; /* 悬停背景色 */
          color: #fff; /* 悬停文字颜色 */
        }
      }
    }
  }

  .app-main {
    flex: 1;
    // main 区域的内边距根据具体页面内容调整，这里不设置，由子路由页面自己控制
  }

  .app-footer {
    background-color: #222; // 底部背景色
    padding: 40px 40px;
    border-top: 1px solid #333;
    color: #a0a0a0;
    font-size: 14px;
    line-height: 1.8;

    .footer-content {
      max-width: 1400px;
      margin: 0 auto;
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
    }

    .footer-links {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      margin-bottom: 30px;

      .link-group {
        margin: 0 30px; // 调整组间距

        h3 {
          color: #fff;
          font-size: 16px;
          margin-bottom: 15px;
          white-space: nowrap;
        }

        ul {
          list-style: none;
          padding: 0;
          margin: 0;

          li {
            margin-bottom: 8px;

            a {
              color: #a0a0a0;
              text-decoration: none;
              transition: color 0.3s;

              &:hover {
                color: #409eff;
              }
            }
          }
        }
      }
    }

    .footer-info {
      p {
        margin-bottom: 5px;
      }

      .health-tip {
        color: #666;
        margin-top: 20px;
        font-size: 12px;
      }
    }
  }
}
</style> 