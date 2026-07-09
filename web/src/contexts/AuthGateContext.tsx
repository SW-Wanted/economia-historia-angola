import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useAuth } from './AuthContext'

/**
 * Conteúdo apresentado no diálogo de autenticação do Visitante.
 * Espelha o padrão do `showContentPreview` / `_loginGate` da app Mobile:
 * nunca mostra erro nem redireciona bruscamente — apenas convida a entrar ou
 * criar conta, com a opção de continuar a explorar ("Agora não").
 */
export interface AuthGateOptions {
  /** Título do diálogo. */
  title?: string
  /** Mensagem explicativa. */
  message?: string
  /** Ícone (Material Symbols) apresentado no topo. */
  icon?: string
  /** Rótulo da ação primária. */
  primaryLabel?: string
}

interface AuthGateContextValue {
  /**
   * Executa `action` se o utilizador estiver autenticado; caso contrário abre
   * o diálogo de autenticação. Devolve `true` se a ação foi executada.
   */
  requireAuth: (action?: () => void, options?: AuthGateOptions) => boolean
  /** Abre o diálogo de autenticação incondicionalmente. */
  promptAuth: (options?: AuthGateOptions) => void
  /** Fecha o diálogo. */
  closeAuthGate: () => void
}

const AuthGateContext = createContext<AuthGateContextValue | null>(null)

const DEFAULTS: Required<AuthGateOptions> = {
  title: 'Continue a explorar a História Económica de Angola',
  message: 'Para aceder a este conteúdo é necessário iniciar sessão. Crie uma conta gratuita para ler, participar e guardar o seu progresso.',
  icon: 'lock_open',
  primaryLabel: 'Entrar',
}

export function AuthGateProvider({ children }: { children: ReactNode }) {
  const { isAuthenticated } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [options, setOptions] = useState<AuthGateOptions | null>(null)

  const open = options !== null

  const promptAuth = useCallback((opts?: AuthGateOptions) => {
    setOptions(opts ?? {})
  }, [])

  const closeAuthGate = useCallback(() => setOptions(null), [])

  const requireAuth = useCallback(
    (action?: () => void, opts?: AuthGateOptions): boolean => {
      if (isAuthenticated) {
        action?.()
        return true
      }
      setOptions(opts ?? {})
      return false
    },
    [isAuthenticated],
  )

  // Leva o Visitante ao ecrã pretendido, guardando a origem para regressar
  // depois de autenticar.
  const goTo = useCallback(
    (path: string) => {
      setOptions(null)
      navigate(path, { state: { from: location } })
    },
    [navigate, location],
  )

  const value = useMemo(
    () => ({ requireAuth, promptAuth, closeAuthGate }),
    [requireAuth, promptAuth, closeAuthGate],
  )

  const merged = { ...DEFAULTS, ...(options ?? {}) }

  return (
    <AuthGateContext.Provider value={value}>
      {children}

      {open && (
        <div
          className="fixed inset-0 z-[100] flex items-end sm:items-center justify-center p-0 sm:p-4"
          role="dialog"
          aria-modal="true"
          aria-labelledby="auth-gate-title"
        >
          {/* Backdrop */}
          <button
            aria-label="Fechar"
            onClick={closeAuthGate}
            className="absolute inset-0 bg-black/45 animate-fade-in"
          />

          {/* Card */}
          <div className="relative w-full sm:max-w-md bg-surface rounded-t-3xl sm:rounded-3xl shadow-xl overflow-hidden animate-slide-up sm:animate-scale-in">
            {/* Cabeçalho decorativo */}
            <div
              className="relative px-6 pt-8 pb-6 text-center overflow-hidden"
              style={{ background: 'linear-gradient(145deg, #8B1A1A 0%, #5A1010 100%)' }}
            >
              <div
                className="absolute inset-0 opacity-[0.06]"
                style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '18px 18px' }}
              />
              <div className="relative z-10 flex flex-col items-center gap-3">
                <div className="w-14 h-14 rounded-2xl bg-white/12 border border-white/20 flex items-center justify-center">
                  <span className="material-symbols-outlined text-white text-[28px]">{merged.icon}</span>
                </div>
                <h2 id="auth-gate-title" className="text-headline-md font-bold text-white font-sans leading-snug px-2">
                  {merged.title}
                </h2>
              </div>
            </div>

            {/* Corpo */}
            <div className="px-6 py-6">
              <p className="text-body-md text-secondary font-body leading-relaxed text-center mb-6">
                {merged.message}
              </p>

              <div className="flex flex-col gap-2.5">
                <button onClick={() => goTo('/login')} className="btn-primary w-full justify-center">
                  <span className="material-symbols-outlined text-[18px]">login</span>
                  {merged.primaryLabel}
                </button>
                <button onClick={() => goTo('/cadastro')} className="btn-secondary w-full justify-center">
                  <span className="material-symbols-outlined text-[18px]">person_add</span>
                  Criar Conta Gratuita
                </button>
                <button
                  onClick={closeAuthGate}
                  className="w-full text-center py-3 text-sm font-semibold font-sans text-secondary hover:text-text transition-colors duration-150"
                >
                  Agora não
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </AuthGateContext.Provider>
  )
}

export function useAuthGate(): AuthGateContextValue {
  const ctx = useContext(AuthGateContext)
  if (!ctx) throw new Error('useAuthGate must be used within AuthGateProvider')
  return ctx
}
