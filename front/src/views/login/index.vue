<template>
  <div class="login-page">
    <el-card class="login-card">
      <template #header>
        <div class="card-header">
          <h2>用户登录</h2>
        </div>
      </template>
      
      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="rules"
        label-width="80px"
        @submit.prevent="handleLogin"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="loginForm.username" placeholder="请输入用户名"></el-input>
        </el-form-item>
        
        <el-form-item label="密码" prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
          ></el-input>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" native-type="submit" :loading="loading" class="submit-btn">
            登录
          </el-button>
        </el-form-item>
        
        <div class="form-footer">
          <router-link to="/register">还没有账号？立即注册</router-link>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'LoginPage'
}
</script>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { login } from '@/api/user' // 导入登录API
import { useUserStore } from '@/store/user' // 导入user store

const router = useRouter()
const loading = ref(false)
const userStore = useUserStore() // 使用user store

const loginForm = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
  ]
}

const loginFormRef = ref(null)

const handleLogin = async () => {
  if (!loginFormRef.value) return
  loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await login(loginForm) // 调用登录API
        if (res) {
          ElMessage.success('登录成功')
          userStore.setToken(res.token) // 保存token到store和localStorage
          userStore.setUserInfo(res.user) // 保存用户信息到store和localStorage
          console.log('登录成功，用户信息:', res.user)
          
          // 根据用户角色决定跳转路径
          if (userStore.isAdmin) {
            router.push('/admin')
          } else {
            router.push('/')
          }
        } else {
          ElMessage.error('登录失败，请检查用户名或密码') // 根据实际后端响应调整
        }
      } catch (error) {
        console.error('登录请求失败:', error)
        ElMessage.error(error.message || '登录失败')
      } finally {
        loading.value = false
      }
    } else {
      console.log('表单验证失败')
      return false
    }
  })
}
</script>

<style lang="scss" scoped>
.login-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #1a1a1a; /* 暗色背景 */
  
  .login-card {
    width: 400px;
    background-color: #2a2a2a; /* 卡片背景色 */
    border: 1px solid #3a3a3a; /* 卡片边框 */
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4); /* 暗色阴影 */
    
    .card-header {
      text-align: center;
      
      h2 {
        margin: 0;
        font-size: 24px;
        color: #e0e0e0; /* 标题文字颜色 */
      }
    }
    
    .el-form-item__label {
      color: #e0e0e0; /* 表单label文字颜色 */
    }

    .el-input__inner {
      background-color: #3a3a3a; /* 输入框背景 */
      color: #e0e0e0; /* 输入框文字颜色 */
      border: 1px solid #555; /* 输入框边框 */
    }

    .el-input__inner::placeholder {
      color: #a0a0a0; /* 输入框placeholder文字颜色 */
    }

    .submit-btn {
      width: 100%;
      background-color: #409eff; /* 按钮背景色 */
      border-color: #409eff; /* 按钮边框色 */
      color: #fff; /* 按钮文字颜色 */

      &:hover {
        background-color: #53a8ff; /* 按钮hover背景色 */
        border-color: #53a8ff; /* 按钮hover边框色 */
      }
    }
    
    .form-footer {
      text-align: center;
      margin-top: 20px;
      
      a {
        color: #409eff; /* 链接颜色 */
        text-decoration: none;
        
        &:hover {
          text-decoration: underline;
        }
      }
    }
  }
}
</style> 