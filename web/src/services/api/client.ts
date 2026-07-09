const BASE_URL = (import.meta.env.VITE_API_URL as string | undefined) ?? 'http://localhost:3001/api/v1'

const TOKEN_KEY = 'eca_access_token'
const REFRESH_KEY = 'eca_refresh_token'

export function getAccessToken(): string | null {
  return localStorage.getItem(TOKEN_KEY)
}

export function getRefreshToken(): string | null {
  return localStorage.getItem(REFRESH_KEY)
}

export function setTokens(accessToken: string, refreshToken: string): void {
  localStorage.setItem(TOKEN_KEY, accessToken)
  localStorage.setItem(REFRESH_KEY, refreshToken)
}

export function clearTokens(): void {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(REFRESH_KEY)
}

export class ApiError extends Error {
  constructor(
    public readonly statusCode: number,
    message: string,
    public readonly details?: unknown,
  ) {
    super(message)
    this.name = 'ApiError'
  }
}

type RequestOptions = Omit<RequestInit, 'body'> & {
  body?: unknown
  skipAuth?: boolean
}

// Single-flight token refresh: queue concurrent 401s until the refresh resolves
let isRefreshing = false
let refreshWaiters: Array<(token: string | null) => void> = []

function drainRefreshWaiters(token: string | null) {
  refreshWaiters.forEach((resolve) => resolve(token))
  refreshWaiters = []
}

async function performRefresh(): Promise<string | null> {
  const refreshToken = getRefreshToken()
  if (!refreshToken) return null

  try {
    const res = await fetch(`${BASE_URL}/auth/refresh`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken }),
    })
    if (!res.ok) return null
    const data = (await res.json()) as { accessToken?: string; refreshToken?: string }
    if (data.accessToken && data.refreshToken) {
      setTokens(data.accessToken, data.refreshToken)
      return data.accessToken
    }
    return null
  } catch {
    return null
  }
}

async function request<T>(path: string, options: RequestOptions = {}): Promise<T> {
  const { body, skipAuth = false, ...init } = options

  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(init.headers as Record<string, string> | undefined),
  }

  if (!skipAuth) {
    const token = getAccessToken()
    if (token) headers['Authorization'] = `Bearer ${token}`
  }

  const fetchInit: RequestInit = {
    ...init,
    headers,
    body: body !== undefined ? JSON.stringify(body) : undefined,
  }

  let res = await fetch(`${BASE_URL}${path}`, fetchInit)

  // On 401 — try silent token refresh once, then retry
  if (res.status === 401 && !skipAuth) {
    let newToken: string | null

    if (isRefreshing) {
      newToken = await new Promise<string | null>((resolve) => {
        refreshWaiters.push(resolve)
      })
    } else {
      isRefreshing = true
      newToken = await performRefresh()
      isRefreshing = false
      drainRefreshWaiters(newToken)
    }

    if (newToken) {
      headers['Authorization'] = `Bearer ${newToken}`
      res = await fetch(`${BASE_URL}${path}`, { ...fetchInit, headers })
    } else {
      clearTokens()
      window.location.replace('/login')
      throw new ApiError(401, 'Sessão expirada. Por favor, inicie sessão novamente.')
    }
  }

  const text = await res.text()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const data: any = text ? JSON.parse(text) : undefined

  if (!res.ok) {
    const raw = data?.message ?? `Erro ${res.status}`
    const message = Array.isArray(raw) ? raw.join('. ') : String(raw)
    throw new ApiError(res.status, message, data)
  }

  return data as T
}

export const api = {
  get: <T>(path: string, options?: RequestOptions) =>
    request<T>(path, { ...options, method: 'GET' }),

  post: <T>(path: string, body?: unknown, options?: RequestOptions) =>
    request<T>(path, { ...options, method: 'POST', body }),

  patch: <T>(path: string, body?: unknown, options?: RequestOptions) =>
    request<T>(path, { ...options, method: 'PATCH', body }),

  delete: <T>(path: string, options?: RequestOptions) =>
    request<T>(path, { ...options, method: 'DELETE' }),
}
