import { api } from './client'
import type { User, Progress } from '../types/api.types'

export interface UpdateProfileDto {
  name?: string
  bio?: string
  region?: string
  school?: string
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

  updateProfile: (dto: UpdateProfileDto) => api.patch<User>('/users/me', dto),

  getMyPermissions: async (): Promise<string[]> => {
    const data = await api.get<PermissionsResponse>('/users/me/permissions')
    const seen = new Set<string>()
    data.roles.forEach((r) =>
      r.role.permissions.forEach((rp) => seen.add(rp.permission.code))
    )
    return [...seen]
  },
}
