import { defineStore } from 'pinia'

export const useUserStore = defineStore({
  id: 'user',
  state: () => {
    const token = localStorage.getItem('token') || null;
    let userInfo = null;
    const storedUserInfo = localStorage.getItem('userInfo');

    if (storedUserInfo && storedUserInfo !== 'undefined') {
      try {
        userInfo = JSON.parse(storedUserInfo);
      } catch (e) {
        console.error("Failed to parse userInfo from localStorage, clearing it:", e);
        localStorage.removeItem('userInfo'); // Clear invalid data
        userInfo = null;
      }
    }

    return {
      token: token,
      userInfo: userInfo
    };
  },
  getters: {
    isLoggedIn: (state) => !!state.token,
    getUsername: (state) => state.userInfo ? state.userInfo.username : '',
    isAdmin: (state) => state.userInfo ? state.userInfo.role === 'admin' : false
  },
  actions: {
    setToken(token) {
      this.token = token
      localStorage.setItem('token', token)
    },
    setUserInfo(userInfo) {
      this.userInfo = userInfo
      localStorage.setItem('userInfo', JSON.stringify(userInfo || null))
    },
    logout() {
      this.token = null
      this.userInfo = null
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
    }
  }
}) 