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

export interface ResetPasswordDto {
  token: string
  newPassword: string
}

export interface ChangePasswordDto {
  currentPassword: string
  newPassword: string
}

export const authService = {
  login: (dto: LoginDto) =>
    api.post<AuthTokens>('/auth/login', dto, { skipAuth: true }),

  register: (dto: RegisterDto) =>
    api.post<AuthTokens>('/auth/register', dto, { skipAuth: true }),

  logout: (refreshToken: string) =>
    api.post<void>('/auth/logout', { refreshToken }),

  forgotPassword: (email: string) =>
    api.post<{ message: string; resetToken?: string; resetUrl?: string }>('/auth/forgot-password', { email }, { skipAuth: true }),

  resetPassword: (dto: ResetPasswordDto) =>
    api.post<{ success: boolean }>('/auth/reset-password', dto, { skipAuth: true }),

  changePassword: (dto: ChangePasswordDto) =>
    api.post<{ success: boolean }>('/auth/change-password', dto),
}
