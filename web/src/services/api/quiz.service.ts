import { api } from './client'
import type { Quiz, QuizAttempt, QuizWithQuestions, UserAnswerResult, RankingEntry, PaginatedResponse } from '../types/api.types'

export const quizService = {
  list: () => api.get<Quiz[] | PaginatedResponse<Quiz>>('/quizzes', { skipAuth: true }),

  findById: (id: string) => api.get<QuizWithQuestions>(`/quizzes/${id}`, { skipAuth: true }),

  start: (quizId: string) => api.post<QuizAttempt>(`/quizzes/${quizId}/start`),

  answer: (attemptId: string, questionId: string, optionId: string) =>
    api.post<UserAnswerResult>(`/quizzes/attempts/${attemptId}/answers`, { questionId, optionId }),

  submit: (attemptId: string) =>
    api.post<QuizAttempt>(`/quizzes/attempts/${attemptId}/submit`),

  getRankings: (scope = 'global', period = 'all') =>
    api.get<RankingEntry[] | PaginatedResponse<RankingEntry>>(
      `/quizzes/rankings?scope=${scope}&period=${period}`,
      { skipAuth: true },
    ),
}
