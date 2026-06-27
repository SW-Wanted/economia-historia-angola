import { api } from './client'
import type { Forum, Topic, TopicReply, PaginatedResponse } from '../types/api.types'

export interface CreateTopicDto {
  title: string
  slug: string
  body: string
  visibility?: string
}

export interface CreateReplyDto {
  body: string
  parentId?: string
}

export const forumService = {
  listForums: () => api.get<Forum[]>('/forums'),

  listTopics: (forumId: string) =>
    api.get<Topic[]>(`/forums/${forumId}/topics`),

  createTopic: (forumId: string, dto: CreateTopicDto) =>
    api.post<Topic>(`/forums/${forumId}/topics`, dto),

  listReplies: (topicId: string, page = 1, limit = 20) =>
    api.get<PaginatedResponse<TopicReply>>(
      `/forums/topics/${topicId}/replies?page=${page}&limit=${limit}`,
    ),

  reply: (topicId: string, dto: CreateReplyDto) =>
    api.post<TopicReply>(`/forums/topics/${topicId}/replies`, dto),
}

export function slugify(text: string): string {
  return text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')
    .slice(0, 80)
}
