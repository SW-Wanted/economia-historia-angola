import { api } from './client'
import type { Quiz, QuizAttempt, RankingEntry, PaginatedResponse } from '../types/api.types'

export const quizService = {
  list: () => api.get<Quiz[] | PaginatedResponse<Quiz>>('/quizzes'),

  start: (quizId: string) => api.post<QuizAttempt>(`/quizzes/${quizId}/start`),

  answer: (attemptId: string, questionId: string, optionId?: string, textAnswer?: string) =>
    api.post<void>(`/quizzes/attempts/${attemptId}/answers`, { questionId, optionId, textAnswer }),

  submit: (attemptId: string) =>
    api.post<QuizAttempt>(`/quizzes/attempts/${attemptId}/submit`),

  getRankings: (scope = 'global', period = 'all') =>
    api.get<RankingEntry[] | PaginatedResponse<RankingEntry>>(
      `/quizzes/rankings?scope=${scope}&period=${period}`,
      { skipAuth: true },
    ),
}
