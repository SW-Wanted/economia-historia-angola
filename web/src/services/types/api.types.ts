export interface ApiErrorShape {
  statusCode: number
  message: string | string[]
  error?: string
}

export interface AuthTokens {
  accessToken: string
  refreshToken: string
  user: AuthUserPayload
}

export interface AuthUserPayload {
  id: string
  email: string
  roles: string[]
  permissions: string[]
}

export interface User {
  id: string
  email: string
  name: string
  username: string | null
  avatarUrl: string | null
  bio: string | null
  region: string | null
  province: string | null
  municipality: string | null
  school: string | null
  course: string | null
  interests: string | null
  motivation: string | null
  roles: { role: { code: string; name: string } }[]
  permissions: string[]
  createdAt: string
  updatedAt: string
}

export type ContentType = 'VIDEO' | 'PODCAST' | 'TEXT' | 'MICROTEXT' | 'PDF' | 'ARTICLE' | 'AUDIO'
export type ContentStatus = 'DRAFT' | 'PENDING_REVIEW' | 'PUBLISHED' | 'ARCHIVED' | 'REJECTED'
export type ContentVisibility = 'PUBLIC' | 'AUTHENTICATED' | 'PRIVATE' | 'COMMUNITY' | 'PERMISSIONED'

export interface Content {
  id: string
  title: string
  slug: string
  summary: string | null
  body: string | null
  type: ContentType
  status: ContentStatus
  visibility: ContentVisibility
  isJindungo: boolean
  mediaUrl: string | null
  thumbnailUrl: string | null
  durationSeconds: number | null
  publishedAt: string | null
  author?: { id: string; name: string } | null
  category: { id: string; name: string; slug: string } | null
  tags: { tag: { id: string; name: string; slug: string } }[]
  _count?: { views: number; favorites: number; comments: number }
  createdAt: string
  updatedAt: string
}

export interface ProgressContent {
  id: string
  title: string
  type: ContentType
  thumbnailUrl: string | null
  category?: { id: string; name: string; slug: string } | null
  tags?: { tag: { id: string; name: string; slug: string } }[]
}

export interface Progress {
  id: string
  contentId: string
  percentage: number
  positionSeconds: number | null
  completedAt: string | null
  updatedAt: string
  content: ProgressContent
}

export interface Notification {
  id: string
  type: string
  title: string
  body: string
  data: Record<string, unknown> | null
  readAt: string | null
  createdAt: string
}

export interface Comment {
  id: string
  text: string
  contentId: string | null
  roomId: string | null
  parentId: string | null
  visibility: string
  status: string
  author: { id: string; name: string; avatarUrl: string | null }
  createdAt: string
  updatedAt: string
}

export interface Forum {
  id: string
  name: string
  slug: string
  description: string | null
  visibility: string
  communityId: string
  createdAt: string
}

export interface Topic {
  id: string
  title: string
  slug: string
  body: string
  status: string
  visibility: string
  author: { id: string; name: string }
  category: { id: string; name: string } | null
  tags: { tag: { id: string; name: string } }[]
  _count?: { replies: number }
  createdAt: string
  updatedAt: string
}

export interface Quiz {
  id: string
  title: string
  slug: string
  description: string | null
  visibility: string
  category: { id: string; name: string } | null
  _count?: { questions: number; attempts: number }
  publishedAt: string | null
  createdAt: string
}

export interface QuizAttempt {
  id: string
  quizId: string
  userId: string
  status: 'STARTED' | 'SUBMITTED' | 'ABANDONED'
  score: number | null
  totalQuestions: number
  startedAt: string
  submittedAt: string | null
}

export interface RankingEntry {
  id: string
  userId: string
  scope: string
  score: number
  attempts: number
  rank: number | null
  computedAt: string
  user: { name: string; avatarUrl: string | null }
}

export interface PaginatedResponse<T> {
  items: T[]
  total: number
  page: number
  limit: number
}

export function extractList<T>(res: T[] | PaginatedResponse<T>): T[] {
  if (Array.isArray(res)) return res
  if ('items' in res && Array.isArray(res.items)) return res.items
  return []
}

// ── Favorites ──────────────────────────────────────────────────────────────
export interface FavoriteContent {
  id: string
  title: string
  type: ContentType
  thumbnailUrl: string | null
  slug: string
}
export interface Favorite {
  userId: string
  contentId: string
  createdAt: string
  content: FavoriteContent
}

// ── Admin Users ─────────────────────────────────────────────────────────────
export interface AdminUser {
  id: string
  email: string
  name: string
  username: string | null
  isActive: boolean
  createdAt: string
  roles: { role: { code: string } }[]
}

// ── Forum Replies ───────────────────────────────────────────────────────────
export interface TopicReply {
  id: string
  topicId: string
  authorId: string
  parentId: string | null
  body: string
  createdAt: string
  updatedAt: string
  author: { id: string; name: string; avatarUrl: string | null }
}

// ── Quiz (full with questions) ──────────────────────────────────────────────
export interface QuizOption {
  id: string
  text: string
  position: number
}
export interface QuizQuestion {
  id: string
  statement: string
  explanation: string | null
  points: number
  position: number
  options: QuizOption[]
}
export interface QuizWithQuestions extends Quiz {
  questions: QuizQuestion[]
}

// ── Quiz answer result ──────────────────────────────────────────────────────
export interface UserAnswerResult {
  id: string
  questionId: string
  optionId: string
  isCorrect: boolean
  pointsEarned: number
}

// ── Report ──────────────────────────────────────────────────────────────────
export type ReportStatus = 'PENDING' | 'REVIEWING' | 'RESOLVED' | 'DISMISSED'
export interface Report {
  id: string
  reporterId: string
  communityId: string | null
  topicId: string | null
  replyId: string | null
  commentId: string | null
  reason: string
  status: ReportStatus
  resolution: string | null
  createdAt: string
  updatedAt: string
  reporter: { id: string; name: string; email: string }
}

export type WriterApplicationStatus = 'PENDING' | 'APPROVED' | 'REJECTED' | 'REQUEST_CHANGES'

export interface WriterApplication {
  id: string
  userId: string
  status: WriterApplicationStatus
  fullName: string
  photoUrl?: string | null
  biography: string
  academicBackground: string
  institution: string
  specialization: string
  researchExperience: string
  previousPublications?: string | null
  portfolio?: string | null
  economicHistoryAreas: string
  languages: string
  interestTopics: string
  documentUrl?: string | null
  reviewedBy?: string | null
  reviewNotes?: string | null
  rejectionReason?: string | null
  submittedAt: string
  reviewedAt?: string | null
  updatedAt: string
  user?: { id: string; name: string; email: string }
  reviewer?: { id: string; name: string } | null
}
