import { api } from './client'
import type { WriterApplication, PaginatedResponse } from '../types/api.types'

export type { WriterApplicationStatus } from '../types/api.types'
export type { WriterApplication }

export interface CreateWriterApplicationDto {
  fullName: string
  photoUrl?: string
  biography: string
  academicBackground: string
  institution: string
  specialization: string
  researchExperience: string
  previousPublications?: string
  portfolio?: string
  economicHistoryAreas: string
  languages: string
  interestTopics: string
  documentUrl?: string
}

export interface ReviewWriterApplicationDto {
  decision: 'APPROVED' | 'REJECTED' | 'REQUEST_CHANGES'
  notes?: string
  rejectionReason?: string
}

export const writerApplicationService = {
  apply: (dto: CreateWriterApplicationDto) =>
    api.post<WriterApplication>('/writer-applications', dto),

  findMine: () =>
    api.get<WriterApplication>('/writer-applications/me'),

  resubmit: (dto: CreateWriterApplicationDto) =>
    api.patch<WriterApplication>('/writer-applications/me/resubmit', dto),

  listAll: (params: { page?: number; limit?: number; status?: string } = {}) => {
    const q = new URLSearchParams()
    if (params.page != null) q.set('page', String(params.page))
    if (params.limit != null) q.set('limit', String(params.limit))
    if (params.status) q.set('status', params.status)
    return api.get<PaginatedResponse<WriterApplication>>(`/writer-applications?${q.toString()}`)
  },

  findOne: (id: string) =>
    api.get<WriterApplication>(`/writer-applications/${id}`),

  review: (id: string, dto: ReviewWriterApplicationDto) =>
    api.patch<WriterApplication>(`/writer-applications/${id}/review`, dto),
}
