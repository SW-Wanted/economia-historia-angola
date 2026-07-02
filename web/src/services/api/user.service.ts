import { api } from './client'
import type { User, Progress, Favorite, AdminUser, PaginatedResponse } from '../types/api.types'

export interface UpdateProfileDto {
  name?: string
  bio?: string
  region?: string
  school?: string
  course?: string
  interests?: string
  motivation?: string
  avatarUrl?: string
}

interface PermissionsResponse {
  roles: {
    role: {
      code: string
      permissions: { permission: { code: string } }[]
    }
  }[]
}

export const userService = {
  getMe: () => api.get<User>('/users/me'),

  getMyProgress: () => api.get<Progress[]>('/users/me/progress'),

  getMyFavorites: () => api.get<Favorite[]>('/users/me/favorites'),

  updateProfile: (dto: UpdateProfileDto) => api.patch<User>('/users/me', dto),

  getMyPermissions: async (): Promise<string[]> => {
    const data = await api.get<PermissionsResponse>('/users/me/permissions')
    const seen = new Set<string>()
    data.roles.forEach((r) =>
      r.role.permissions.forEach((rp) => seen.add(rp.permission.code))
    )
    return [...seen]
  },

  listAll: (params: { page?: number; limit?: number; search?: string; isActive?: boolean } = {}) => {
    const q = new URLSearchParams()
    if (params.page != null) q.set('page', String(params.page))
    if (params.limit != null) q.set('limit', String(params.limit))
    if (params.search) q.set('search', params.search)
    if (params.isActive != null) q.set('isActive', String(params.isActive))
    return api.get<PaginatedResponse<AdminUser>>(`/users?${q.toString()}`)
  },

  updateStatus: (userId: string, isActive: boolean) =>
    api.patch<{ id: string; email: string; name: string; isActive: boolean }>(
      `/users/${userId}/status`,
      { isActive },
    ),
}
