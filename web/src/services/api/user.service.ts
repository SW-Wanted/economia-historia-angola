import { api } from './client'
import type { User, Progress } from '../types/api.types'

export interface UpdateProfileDto {
  name?: string
  username?: string
  bio?: string
  region?: string
  province?: string
  municipality?: string
  school?: string
  avatarUrl?: string
}

export const userService = {
  getMe: () => api.get<User>('/users/me'),

  getMyProgress: () => api.get<Progress[]>('/users/me/progress'),

  updateProfile: (dto: UpdateProfileDto) => api.patch<User>('/users/me', dto),
}
