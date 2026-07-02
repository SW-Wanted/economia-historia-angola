import { api } from './client'
import type { Notification } from '../types/api.types'

export const notificationService = {
  list: () => api.get<Notification[]>('/notifications'),

  markRead: (id: string) => api.patch<void>(`/notifications/${id}/read`),
}
