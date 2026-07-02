import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { ApiError } from '../services/api/client'
import { getErrorMessage } from '../utils/errors'

export default function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const { login, isAuthenticated } = useAuth()

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const from = (location.state as { from?: { pathname: string } } | null)?.from?.pathname ?? '/dashboard'

  useEffect(() => {
    if (isAuthenticated) navigate(from, { replace: true })
  }, [isAuthenticated, navigate, from])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!email.trim() || !password) { setError('Preencha o email e a palavra-passe.'); return }
    setLoading(true)
    try {
      await login({ email: email.trim(), password })
      navigate(from, { replace: true })
    } catch (err: unknown) {
      // Num ecrã de login, 401 significa credenciais erradas (não "sessão expirada").
      if (err instanceof ApiError && err.statusCode === 401) {
        setError('Email ou palavra-passe incorretos.')
      } else {
        setError(getErrorMessage(err))
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex bg-background font-body">

      {/* Left panel — decorative */}
      <div className="hidden lg:flex lg:w-[45%] xl:w-[50%] flex-col relative overflow-hidden"
        style={{ background: 'linear-gradient(145deg, #8B1A1A 0%, #5A1010 55%, #2A0808 100%)' }}>
        {/* Decorative patterns */}
        <div className="absolute inset-0 opacity-[0.04]"
          style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '28px 28px' }} />
        <div className="absolute top-0 left-0 w-96 h-96 rounded-full opacity-[0.08]"
          style={{ background: 'radial-gradient(circle, white 0%, transparent 70%)', transform: 'translate(-30%, -30%)' }} />
        <div className="absolute bottom-0 right-0 w-80 h-80 rounded-full opacity-[0.06]"
          style={{ background: 'radial-gradient(circle, white 0%, transparent 70%)', transform: 'translate(30%, 30%)' }} />

        {/* Content */}
        <div className="relative z-10 flex flex-col h-full p-12">
          {/* Brand */}
          <div className="flex items-center gap-3 mb-auto">
            <div className="w-10 h-10 rounded-xl bg-white/15 flex items-center justify-center border border-white/20">
              <span className="material-symbols-outlined text-white text-[22px]"
                style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div>
              <p className="text-white text-sm font-bold font-sans leading-tight">Economia com História</p>
              <p className="text-white/50 text-[10px] uppercase tracking-[0.1em] font-sans">Angola</p>
            </div>
          </div>

          {/* Testimonial block */}
          <div className="mt-auto">
            <span className="material-symbols-outlined text-5xl text-white/20 mb-4 block"
              style={{ fontVariationSettings: "'FILL' 1" }}>format_quote</span>
            <blockquote className="text-white/80 text-lg font-reading italic leading-relaxed mb-6">
              "Uma plataforma essencial para compreender a complexidade económica de Angola através da sua história."
            </blockquote>
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-full bg-white/15 border border-white/20 flex items-center justify-center">
                <span className="text-[11px] font-bold text-white font-sans">CE</span>
              </div>
              <div>
                <p className="text-white/75 text-sm font-sans font-semibold">Carlos Eduardo</p>
                <p className="text-white/45 text-[11px] font-body">Investigador · Universidade Agostinho Neto</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Right panel — form */}
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-[400px]">

          {/* Mobile brand */}
          <div className="flex items-center gap-2.5 mb-10 lg:hidden">
            <div className="w-9 h-9 rounded-xl bg-primary flex items-center justify-center">
              <span className="material-symbols-outlined text-white text-[20px]"
                style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div>
              <p className="text-sm font-bold text-text font-sans leading-tight">Economia com História</p>
              <p className="text-[10px] text-outline uppercase tracking-[0.1em] font-sans">Angola</p>
            </div>
          </div>

          {/* Heading */}
          <div className="mb-8">
            <h1 className="text-headline-xl font-bold text-text font-sans tracking-tight mb-1">
              Bem-vindo de volta
            </h1>
            <p className="text-body-md text-secondary font-body">
              Inicie sessão para continuar a explorar.
            </p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-1.5">
              <label className="block text-label-lg text-text-muted font-sans">
                Endereço de email
              </label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline/50 text-[17px] pointer-events-none">mail</span>
                <input
                  type="email"
                  placeholder="nome@exemplo.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="input pl-10"
                />
              </div>
            </div>

            <div className="space-y-1.5">
              <div className="flex items-center justify-between">
                <label className="block text-label-lg text-text-muted font-sans">
                  Palavra-passe
                </label>
                <button
                  type="button"
                  onClick={() => navigate('/recuperar-senha')}
                  className="text-sm text-primary hover:text-primary-dark font-semibold font-sans transition-colors duration-150"
                >
                  Esqueceu?
                </button>
              </div>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline/50 text-[17px] pointer-events-none">lock</span>
                <input
                  type={showPassword ? 'text' : 'password'}
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="input pl-10 pr-11"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((v) => !v)}
                  className="absolute right-3.5 top-1/2 -translate-y-1/2 text-outline/50 hover:text-outline transition-colors"
                >
                  <span className="material-symbols-outlined text-[17px]">
                    {showPassword ? 'visibility_off' : 'visibility'}
                  </span>
                </button>
              </div>
            </div>

            {error && (
              <div className="alert-error rounded-button">
                <span className="material-symbols-outlined text-error/70 text-[16px] flex-shrink-0 mt-0.5">error_outline</span>
                <p className="text-sm text-error font-body">{error}</p>
              </div>
            )}

            <label className="flex items-center gap-2.5 cursor-pointer pt-1">
              <input type="checkbox" className="w-4 h-4 rounded border-outline-variant/60 accent-primary" />
              <span className="text-sm text-secondary font-body">Manter sessão iniciada</span>
            </label>

            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full justify-center py-4 text-base mt-2"
            >
              {loading ? (
                <>
                  <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  A entrar...
                </>
              ) : 'Entrar na plataforma'}
            </button>
          </form>

          {/* Divider */}
          <div className="flex items-center gap-3 my-6">
            <div className="h-px flex-grow bg-outline-variant/30" />
            <span className="text-[11px] text-outline/60 uppercase tracking-wider font-sans whitespace-nowrap">ou</span>
            <div className="h-px flex-grow bg-outline-variant/30" />
          </div>

          {/* Social — clearly "coming soon", not broken */}
          <div className="grid grid-cols-2 gap-3 mb-8">
            {[
              { icon: 'language', label: 'Google' },
              { icon: 'work', label: 'LinkedIn' },
            ].map((p) => (
              <div
                key={p.label}
                className="flex items-center justify-center gap-2 py-3 border border-outline-variant/30 rounded-button text-sm font-semibold text-secondary/50 font-sans cursor-not-allowed select-none relative"
              >
                <span className="material-symbols-outlined text-[17px] text-secondary/40">{p.icon}</span>
                {p.label}
                <span className="absolute -top-2 -right-1 text-[9px] bg-surface-container text-secondary/60 px-1.5 py-0.5 rounded-full font-sans font-bold uppercase tracking-wide border border-outline-variant/30">
                  Em breve
                </span>
              </div>
            ))}
          </div>

          {/* Register link */}
          <p className="text-center text-sm text-secondary font-body">
            Não tem conta?{' '}
            <button
              onClick={() => navigate('/cadastro')}
              className="text-primary font-bold hover:text-primary-dark transition-colors duration-150 font-sans"
            >
              Criar conta gratuitamente
            </button>
          </p>

          {/* Footer */}
          <div className="flex justify-center gap-5 mt-10">
            {['Sobre', 'Termos', 'Privacidade'].map((l) => (
              <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-outline/60 hover:text-primary transition-colors font-body">
                {l}
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
