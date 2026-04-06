import axios from 'axios'

// API configuration
export const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api'

const api = axios.create({ baseURL: API_BASE_URL })

// Attach token to every request
api.interceptors.request.use((config) => {
  const user = JSON.parse(localStorage.getItem('internhub_user') || '{}')
  if (user?.token) config.headers.Authorization = `Bearer ${user.token}`
  return config
})

export default api
