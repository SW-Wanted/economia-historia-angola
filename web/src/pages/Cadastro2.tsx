import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function Cadastro2() {
  const navigate = useNavigate()
  const { register } = useAuth()
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    if (!sessionStorage.getItem('reg_name') || !sessionStorage.getItem('reg_email')) {
      navigate('/cadastro')
    }
  }, [navigate])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (password.length < 8) {
      setError('A palavra-passe deve ter pelo menos 8 caracteres.')
      return
    }
    const name = sessionStorage.getItem('reg_name') ?? ''
    const email = sessionStorage.getItem('reg_email') ?? ''
    setLoading(true)
    try {
      await register({ name, email, password })
      sessionStorage.removeItem('reg_name')
      sessionStorage.removeItem('reg_email')
      navigate('/cadastro/3')
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Erro ao criar conta. Tente novamente.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-body bg-background">
      {/* Logo */}
      <div className="mb-8 flex flex-col items-center text-center">
        <div className="w-12 h-12 rounded-card bg-surface-container flex items-center justify-center mb-3">
          <span className="material-symbols-outlined text-primary" style={{ fontSize: '22px', fontVariationSettings: "'FILL' 1" }}>account_balance</span>
        </div>
        <h2 className="text-base font-bold text-primary font-sans tracking-tight">Economia com História</h2>
        <p className="text-[10px] text-outline tracking-[0.12em] uppercase font-sans mt-0.5">Angola</p>
      </div>

      <main className="w-full max-w-[480px] bg-surface rounded-card shadow-card border border-outline-variant/45 overflow-hidden">
        <div className="h-1 w-full bg-surface-container-high flex">
          <div className="h-full bg-primary transition-all duration-500" style={{ width: '66.66%' }} />
        </div>

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col gap-2">
            <span className="text-label-md font-bold text-primary uppercase tracking-[0.1em] font-sans">Passo 2 de 3</span>
            <h1 className="text-headline-md font-bold text-text font-sans">Perfil de Investigador</h1>
            <p className="text-body-md font-body text-secondary">
              Diga-nos um pouco mais sobre si para personalizar a sua experiência.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Área de interesse</label>
              <select className="w-full bg-surface border border-outline-variant rounded-button px-4 py-[15px] focus:ring-2 focus:ring-primary/10 focus:border-primary outline-none transition-all text-text font-body text-sm">
                <option value="">Selecione a sua área</option>
                <option>História Económica</option>
                <option>Economia Colonial</option>
                <option>Pós-Independência</option>
                <option>Economia Contemporânea</option>
              </select>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Perfil</label>
              <select className="w-full bg-surface border border-outline-variant rounded-button px-4 py-[15px] focus:ring-2 focus:ring-primary/10 focus:border-primary outline-none transition-all text-text font-body text-sm">
                <option value="">Selecione o seu perfil</option>
                <option>Estudante</option>
                <option>Académico / Investigador</option>
                <option>Jornalista</option>
                <option>Curioso / Entusiasta</option>
              </select>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Palavra-passe</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock</span>
                <input
                  type="password"
                  placeholder="Mínimo 8 caracteres"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  minLength={8}
                  className="w-full pl-10 pr-4 py-[15px] bg-surface border border-outline-variant rounded-button focus:ring-2 focus:ring-primary/10 focus:border-primary outline-none transition-all font-body text-sm text-text placeholder:text-outline"
                />
              </div>
            </div>

            {error && (
              <p className="text-xs text-error bg-error-container/40 border border-error/20 rounded-button px-3 py-2 font-body">{error}</p>
            )}

            <div className="mt-2 flex gap-4">
              <button type="button" onClick={() => navigate('/cadastro')} className="btn-secondary flex-1 justify-center">
                Voltar
              </button>
              <button type="submit" disabled={loading} className="btn-primary flex-1 justify-center disabled:opacity-50 disabled:cursor-not-allowed">
                {loading ? (
                  <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : 'Continuar'}
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  )
}
