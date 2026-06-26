import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

export default function Cadastro1() {
  const navigate = useNavigate()
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [error, setError] = useState('')

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!name.trim()) { setError('Por favor, introduza o seu nome.'); return }
    if (!email.trim()) { setError('Por favor, introduza o seu email.'); return }
    sessionStorage.setItem('reg_name', name.trim())
    sessionStorage.setItem('reg_email', email.trim())
    navigate('/cadastro/2')
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-body bg-background">
      {/* Logo */}
      <div className="mb-7 flex flex-col items-center text-center">
        <div className="w-12 h-12 rounded-card bg-surface-container flex items-center justify-center mb-3">
          <span className="material-symbols-outlined text-primary" style={{ fontSize: '22px', fontVariationSettings: "'FILL' 1" }}>account_balance</span>
        </div>
        <h2 className="text-base font-bold text-primary font-sans tracking-tight">Economia com História</h2>
        <p className="text-[10px] text-outline tracking-[0.12em] uppercase font-sans mt-0.5">Angola</p>
      </div>

      <main className="w-full max-w-[440px] bg-surface rounded-card shadow-card border border-outline-variant/45 overflow-hidden">
        {/* Barra de progresso */}
        <div className="h-1 w-full bg-surface-container-high">
          <div className="h-full bg-primary transition-all duration-500" style={{ width: '33.33%' }} />
        </div>

        <div className="px-8 py-8 flex flex-col gap-6">
          <header className="flex flex-col gap-1.5">
            <span className="text-label-md font-bold text-primary uppercase tracking-[0.1em] font-sans">Passo 1 de 3</span>
            <h1 className="text-headline-md font-bold text-text font-sans tracking-tight">Criar Conta</h1>
            <p className="text-body-md font-body text-secondary leading-relaxed">
              Comece a sua jornada pela história económica de Angola registando os seus dados.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Nome Completo</label>
              <input
                type="text"
                placeholder="Ex: Manuel dos Santos"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                className="input"
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Email</label>
              <input
                type="email"
                placeholder="nome@exemplo.ao"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="input"
              />
            </div>

            {error && (
              <div className="alert-error rounded-button">
                <p className="text-sm text-error font-body">{error}</p>
              </div>
            )}

            <div className="mt-1 flex flex-col gap-3">
              <button type="submit" className="btn-primary w-full justify-center">
                Continuar
                <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
              </button>
              <div className="relative">
                <button
                  type="button"
                  className="w-full flex items-center justify-center gap-2.5 border border-outline-variant/50 text-secondary py-[14px] rounded-button text-sm font-semibold font-sans transition-all duration-150"
                >
                  <span className="material-symbols-outlined text-[18px]">language</span>
                  Registar com Google
                </button>
                <span className="absolute -top-2 -right-2 bg-surface-container text-primary text-[9px] font-bold font-sans px-1.5 py-0.5 rounded-full border border-primary/20 uppercase tracking-wider">Em breve</span>
              </div>
            </div>
          </form>

          <footer className="pt-5 border-t border-outline-variant/40 text-center">
            <p className="text-sm text-secondary font-body">
              Já tem conta?{' '}
              <button onClick={() => navigate('/login')} className="text-primary font-bold hover:text-primary-dark font-sans transition-colors duration-150">
                Iniciar Sessão
              </button>
            </p>
          </footer>
        </div>
      </main>
    </div>
  )
}
