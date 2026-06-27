import { api } from './client'
import type { Report, PaginatedResponse } from '../types/api.types'

export interface CreateReportDto {
  reason: string
  communityId?: string
  topicId?: string
  replyId?: string
  commentId?: string
}

export interface ReviewReportDto {
  status: 'REVIEWING' | 'RESOLVED' | 'DISMISSED'
  resolution?: string
}

export const reportsService = {
  create: (dto: CreateReportDto) => api.post<void>('/reports', dto),

  list: (params: { page?: number; limit?: number } = {}) => {
    const q = new URLSearchParams()
    if (params.page != null) q.set('page', String(params.page))
    if (params.limit != null) q.set('limit', String(params.limit))
    return api.get<PaginatedResponse<Report> | Report[]>(`/reports?${q.toString()}`)
  },

  review: (id: string, dto: ReviewReportDto) =>
    api.patch<Report>(`/reports/${id}/review`, dto),
}
