import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authService } from '../services/api/auth.service'
import { getErrorMessage } from '../utils/errors'

export default function RecuperarSenha() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const [sent, setSent] = useState(false)
  const [error, setError] = useState('')

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!email.trim()) { setError('Por favor, introduza o seu email.'); return }
    setLoading(true)
    try {
      await authService.forgotPassword(email.trim())
      setSent(true)
    } catch (err: unknown) {
      setError(getErrorMessage(err))
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-6 font-body relative bg-background">
      <div className="absolute inset-0 opacity-[0.035] pointer-events-none" style={{ backgroundImage: 'radial-gradient(#8B1A1A 0.5px, transparent 0.5px)', backgroundSize: '24px 24px' }} />

      <main className="w-full max-w-[480px] z-10">
        {/* Logo */}
        <div className="flex flex-col items-center mb-8 text-center">
          <div className="w-12 h-12 rounded-card bg-surface-container flex items-center justify-center mb-3">
            <span className="material-symbols-outlined text-primary" style={{ fontSize: '28px', fontVariationSettings: "'FILL' 1" }}>history_edu</span>
          </div>
          <h1 className="text-base font-bold text-primary font-sans tracking-tight">Economia com História</h1>
          <p className="text-[10px] text-outline uppercase tracking-[0.12em] font-sans mt-0.5">Angola</p>
        </div>

        <div className="bg-surface rounded-card shadow-card border border-outline-variant/45 p-10">
          {sent ? (
            <div className="flex flex-col items-center text-center gap-5 py-4">
              <div className="w-14 h-14 rounded-card bg-success/10 flex items-center justify-center">
                <span className="material-symbols-outlined text-success text-[32px]">mark_email_read</span>
              </div>
              <div>
                <h2 className="text-headline-md font-sans font-bold text-text mb-2">Email Enviado</h2>
                <p className="text-body-md font-body text-secondary leading-relaxed">
                  Se o endereço <strong className="text-text">{email}</strong> estiver registado, receberá instruções de recuperação em breve.
                </p>
              </div>
              <button
                onClick={() => navigate('/login')}
                className="mt-2 text-sm font-bold text-primary hover:text-primary-dark transition-colors font-sans"
              >
                Voltar para o Login
              </button>
            </div>
          ) : (
            <>
              <div className="mb-8">
                <h2 className="text-headline-md font-sans font-bold text-text mb-2">Recuperar Senha</h2>
                <p className="text-body-md font-body text-secondary">
                  Introduza o seu e-mail para receber as instruções de recuperação.
                </p>
              </div>

              <form className="space-y-4" onSubmit={handleSubmit}>
                <div className="flex flex-col gap-1.5">
                  <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Email</label>
                  <div className="relative">
                    <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">mail</span>
                    <input
                      type="email"
                      placeholder="exemplo@email.com"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                      className="w-full pl-10 pr-4 py-[15px] bg-surface rounded-button border border-outline-variant focus:ring-2 focus:ring-primary/10 focus:border-primary outline-none transition-all font-body text-sm text-text placeholder:text-outline"
                    />
                  </div>
                </div>

                {error && (
                  <p className="text-xs text-error bg-error-container/40 border border-error/20 rounded-button px-3 py-2 font-body">{error}</p>
                )}

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-primary text-white font-semibold py-[14px] rounded-button hover:bg-primary-dark hover:shadow-md transition-all active:scale-[0.98] mt-4 flex items-center justify-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed uppercase tracking-wide font-sans text-sm"
                >
                  {loading ? (
                    <>
                      <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      A enviar...
                    </>
                  ) : (
                    <>
                      Enviar Instruções
                      <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
                    </>
                  )}
                </button>
              </form>

              <div className="mt-8 text-center pt-4 border-t border-outline-variant/40">
                <button
                  onClick={() => navigate('/login')}
                  className="inline-flex items-center gap-2 text-sm font-bold text-primary hover:text-primary-dark transition-colors group font-sans"
                >
                  <span className="material-symbols-outlined text-[18px] group-hover:-translate-x-1 transition-transform">arrow_back</span>
                  Voltar para o Login
                </button>
              </div>
            </>
          )}
        </div>

        <footer className="mt-16 text-center">
          <p className="text-xs text-outline font-body">© 2026 Economia com História – Angola. Todos os direitos reservados.</p>
        </footer>
      </main>
    </div>
  )
}
