import { api } from './client'
import type { Content, PaginatedResponse } from '../types/api.types'

export interface ContentQueryDto {
  type?: string
  categoryId?: string
  page?: number
  limit?: number
}

export const contentService = {
  list: (query: ContentQueryDto = {}) => {
    const params = new URLSearchParams()
    if (query.type) params.set('type', query.type)
    if (query.categoryId) params.set('categoryId', query.categoryId)
    if (query.page) params.set('page', String(query.page))
    if (query.limit) params.set('limit', String(query.limit))
    const qs = params.toString()
    return api.get<PaginatedResponse<Content>>(`/contents${qs ? `?${qs}` : ''}`)
  },

  get: (id: string) => api.get<Content>(`/contents/${id}`),

  favorite: (id: string) => api.post<void>(`/contents/${id}/favorite`),

  updateProgress: (id: string, percentage: number) =>
    api.patch<void>(`/contents/${id}/progress`, { percentage }),
}
