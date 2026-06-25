import { api } from './client'
import type { Content, PaginatedResponse } from '../types/api.types'
import type { ContentType, ContentVisibility } from '../types/api.types'

export interface ContentQueryDto {
  type?: string
  categoryId?: string
  tag?: string
  search?: string
  page?: number
  limit?: number
}

export interface CreateContentDto {
  title: string
  slug: string
  type: ContentType
  summary?: string
  body?: string
  visibility?: ContentVisibility
  isJindungo?: boolean
  categoryId?: string
}

export const contentService = {
  list: (query: ContentQueryDto = {}) => {
    const params = new URLSearchParams()
    if (query.type) params.set('type', query.type)
    if (query.categoryId) params.set('categoryId', query.categoryId)
    if (query.tag) params.set('tag', query.tag)
    if (query.search) params.set('search', query.search)
    if (query.page) params.set('page', String(query.page))
    if (query.limit) params.set('limit', String(query.limit))
    const qs = params.toString()
    return api.get<PaginatedResponse<Content>>(`/contents${qs ? `?${qs}` : ''}`)
  },

  get: (id: string) => api.get<Content>(`/contents/${id}`),

  create: (dto: CreateContentDto) => api.post<Content>('/contents', dto),

  favorite: (id: string) => api.post<void>(`/contents/${id}/favorite`),

  updateProgress: (id: string, percentage: number) =>
    api.patch<void>(`/contents/${id}/progress`, { percentage }),

}
