<template>
  <div class="register-page">
    <el-card class="register-card">
      <template #header>
        <div class="card-header">
          <h2>用户注册</h2>
        </div>
      </template>
      
      <el-form
        ref="registerFormRef"
        :model="registerForm"
        :rules="rules"
        label-width="80px"
        @submit.prevent="handleRegister"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="registerForm.username" placeholder="请输入用户名"></el-input>
        </el-form-item>
        
        <el-form-item label="密码" prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
          ></el-input>
        </el-form-item>
        
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请再次输入密码"
            show-password
          ></el-input>
        </el-form-item>
        
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="registerForm.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="registerForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" native-type="submit" :loading="loading" class="submit-btn">
            注册
          </el-button>
        </el-form-item>
        
        <div class="form-footer">
          <router-link to="/login">已有账号？立即登录</router-link>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { register } from '@/api/user' // 导入注册API

defineOptions({
  name: 'RegisterPage'
})

const router = useRouter()
const loading = ref(false)

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  email: '',
  phone: '' // 添加手机号字段
})

const validatePass = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请输入密码'))
  } else {
    if (registerForm.confirmPassword !== '') {
      if (registerForm.password !== registerForm.confirmPassword) {
        callback(new Error('两次输入密码不一致'))
      }
    }
    callback()
  }
}

const validatePass2 = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入密码'))
  } else if (value !== registerForm.password) {
    callback(new Error('两次输入密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, validator: validatePass, trigger: 'blur' },
    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validatePass2, trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  phone: [
    { required: false, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
  ]
}

const registerFormRef = ref(null) // 绑定表单引用

const handleRegister = async () => {
  if (!registerFormRef.value) return
  registerFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await register(registerForm) // 调用注册API
        if (res) {
          ElMessage.success('注册成功')
          console.log('注册成功，用户信息:', res)
          router.push('/login')
        } else {
          ElMessage.error('注册失败，请重试') // 根据实际后端响应调整
        }
      } catch (error) {
        console.error('注册请求失败:', error)
        ElMessage.error(error.message || '注册失败')
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
.register-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #1a1a1a; /* 暗色背景 */
  
  .register-card {
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