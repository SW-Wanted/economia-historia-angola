import { createContext, useContext, useState, useEffect, type ReactNode } from 'react'
import { authService, type LoginDto, type RegisterDto } from '../services/api/auth.service'
import { userService } from '../services/api/user.service'
import { setTokens, clearTokens, getAccessToken, getRefreshToken } from '../services/api/client'
import type { User } from '../services/types/api.types'

interface AuthState {
  user: User | null
  isLoading: boolean
  isAuthenticated: boolean
}

interface AuthContextValue extends AuthState {
  login: (dto: LoginDto) => Promise<void>
  register: (dto: RegisterDto) => Promise<void>
  logout: () => Promise<void>
  refreshUser: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<AuthState>({
    user: null,
    isLoading: true,
    isAuthenticated: false,
  })

  useEffect(() => {
    async function restoreSession() {
      if (!getAccessToken()) {
        setState((s) => ({ ...s, isLoading: false }))
        return
      }
      try {
        const user = await userService.getMe()
        setState({ user, isLoading: false, isAuthenticated: true })
      } catch {
        clearTokens()
        setState({ user: null, isLoading: false, isAuthenticated: false })
      }
    }
    restoreSession()
  }, [])

  async function login(dto: LoginDto) {
    const tokens = await authService.login(dto)
    setTokens(tokens.accessToken, tokens.refreshToken)
    const user = await userService.getMe()
    setState({ user, isLoading: false, isAuthenticated: true })
  }

  async function register(dto: RegisterDto) {
    const tokens = await authService.register(dto)
    setTokens(tokens.accessToken, tokens.refreshToken)
    const user = await userService.getMe()
    setState({ user, isLoading: false, isAuthenticated: true })
  }

  async function logout() {
    const refreshToken = getRefreshToken()
    try {
      if (refreshToken) await authService.logout(refreshToken)
    } catch {
      // ignore — clear locally regardless
    } finally {
      clearTokens()
      setState({ user: null, isLoading: false, isAuthenticated: false })
    }
  }

  async function refreshUser() {
    try {
      const user = await userService.getMe()
      setState((s) => ({ ...s, user }))
    } catch {
      // ignore
    }
  }

  return (
    <AuthContext.Provider value={{ ...state, login, register, logout, refreshUser }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}

export function getUserInitials(user: User | null): string {
  if (!user) return '??'
  return user.name
    .split(' ')
    .map((n) => n[0])
    .slice(0, 2)
    .join('')
    .toUpperCase()
}

export function getUserRole(user: User | null): string {
  if (!user || !user.roles?.length) return 'Utilizador'
  const code = user.roles[0].role.code
  const labels: Record<string, string> = {
    USER: 'Investigador',
    WRITER: 'Escritor',
    PROFESSOR: 'Professor',
    MODERATOR: 'Moderador',
    ADMIN: 'Administrador',
    SUPER_ADMIN: 'Super Admin',
  }
  return labels[code] ?? 'Investigador'
}
