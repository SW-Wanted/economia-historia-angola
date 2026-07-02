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

export type ContentStatus = 'DRAFT' | 'PENDING_REVIEW' | 'PUBLISHED' | 'ARCHIVED' | 'REJECTED'

export interface ManageContentQueryDto extends ContentQueryDto {
  status?: ContentStatus
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
  mediaUrl?: string
  thumbnailUrl?: string
  sourceUrl?: string
  durationSeconds?: number
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

  // Painel de gestão: inclui rascunhos e pendentes (escopo definido pelo backend).
  listForManagement: (query: ManageContentQueryDto = {}) => {
    const params = new URLSearchParams()
    if (query.status) params.set('status', query.status)
    if (query.type) params.set('type', query.type)
    if (query.categoryId) params.set('categoryId', query.categoryId)
    if (query.search) params.set('search', query.search)
    if (query.page) params.set('page', String(query.page))
    if (query.limit) params.set('limit', String(query.limit))
    const qs = params.toString()
    return api.get<PaginatedResponse<Content>>(`/contents/manage${qs ? `?${qs}` : ''}`)
  },

  changeStatus: (id: string, status: ContentStatus) =>
    api.patch<Content>(`/contents/${id}/status`, { status }),

  remove: (id: string) => api.delete<{ id: string; deleted: boolean }>(`/contents/${id}`),

  create: (dto: CreateContentDto) => api.post<Content>('/contents', dto),

  favorite: (id: string) => api.post<void>(`/contents/${id}/favorite`),

  updateProgress: (id: string, percentage: number) =>
    api.patch<void>(`/contents/${id}/progress`, { percentage }),

  requestAccess: (id: string) =>
    api.post<void>(`/contents/${id}/request-access`),
}
