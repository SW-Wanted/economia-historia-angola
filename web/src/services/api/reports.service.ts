import { api } from './client'

export interface CreateReportDto {
  reason: string
  communityId?: string
  topicId?: string
  replyId?: string
  commentId?: string
}

export const reportsService = {
  create: (dto: CreateReportDto) => api.post<void>('/reports', dto),
}
