import { api } from './client'
import type { AuthTokens } from '../types/api.types'

export interface LoginDto {
  email: string
  password: string
}

export interface RegisterDto {
  name: string
  email: string
  password: string
  username?: string
  interests?: string
  motivation?: string
}

export const authService = {
  login: (dto: LoginDto) =>
    api.post<AuthTokens>('/auth/login', dto, { skipAuth: true }),

  register: (dto: RegisterDto) =>
    api.post<AuthTokens>('/auth/register', dto, { skipAuth: true }),

  logout: (refreshToken: string) =>
    api.post<void>('/auth/logout', { refreshToken }),

  forgotPassword: (email: string) =>
    api.post<{ queued: boolean; message: string }>('/auth/forgot-password', { email }, { skipAuth: true }),
}
