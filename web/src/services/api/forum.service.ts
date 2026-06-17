import { api } from './client'
import type { Forum, Topic } from '../types/api.types'

export interface CreateTopicDto {
  title: string
  slug: string
  body: string
  visibility?: string
}

export const forumService = {
  listForums: () => api.get<Forum[]>('/forums'),

  listTopics: (forumId: string) =>
    api.get<Topic[]>(`/forums/${forumId}/topics`),

  createTopic: (forumId: string, dto: CreateTopicDto) =>
    api.post<Topic>(`/forums/${forumId}/topics`, dto),
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
