import { api } from './client'
import type { Comment } from '../types/api.types'

export interface CreateCommentDto {
  text: string
  contentId?: string
  roomId?: string
  parentId?: string
  visibility?: string
}

export const commentsService = {
  listForContent: (contentId: string) =>
    api.get<Comment[]>(`/comments/content/${contentId}`),

  create: (dto: CreateCommentDto) =>
    api.post<Comment>('/comments', dto),
}
