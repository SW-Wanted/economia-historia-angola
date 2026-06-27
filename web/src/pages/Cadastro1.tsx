import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import CadastroStepper from '../components/CadastroStepper'

export default function Cadastro1() {
  const navigate = useNavigate()
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [wantsWriter, setWantsWriter] = useState(false)
  const [error, setError] = useState('')

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!name.trim()) { setError('Por favor, introduza o seu nome completo.'); return }
    if (!email.trim()) { setError('Por favor, introduza um email válido.'); return }

    sessionStorage.setItem('reg_name', name.trim())
    sessionStorage.setItem('reg_email', email.trim())
    sessionStorage.setItem('reg_writer', wantsWriter ? 'true' : 'false')
    navigate('/cadastro/2')
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-body bg-background">
      {/* Logo */}
      <div className="mb-7 flex flex-col items-center text-center">
        <div className="w-12 h-12 rounded-card bg-surface-container flex items-center justify-center mb-3">
          <span
            className="material-symbols-outlined text-primary"
            style={{ fontSize: '22px', fontVariationSettings: "'FILL' 1" }}
          >
            account_balance
          </span>
        </div>
        <h2 className="text-base font-bold text-primary font-sans tracking-tight">Economia com História</h2>
        <p className="text-[10px] text-outline tracking-[0.12em] uppercase font-sans mt-0.5">Angola</p>
      </div>

      <main className="w-full max-w-[440px] bg-surface rounded-card shadow-card border border-outline-variant/45 overflow-hidden">
        {/* Barra de progresso */}
        <div className="h-0.5 w-full bg-surface-container-high">
          <div className="h-full bg-primary transition-all duration-700 ease-out" style={{ width: '33%' }} />
        </div>

        {/* Stepper */}
        <div className="px-8 pt-6 pb-5">
          <CadastroStepper currentStep={1} />
        </div>

        <div className="h-px mx-8 bg-outline-variant/25" />

        <div className="px-8 py-7 flex flex-col gap-6">
          <header>
            <h1 className="text-headline-md font-bold text-text font-sans tracking-tight">Criar Conta</h1>
            <p className="text-body-md font-body text-secondary mt-1.5 leading-relaxed">
              Comece a sua jornada pela história económica de Angola.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
            {/* Nome Completo */}
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Nome Completo
              </label>
              <input
                type="text"
                placeholder="Ex: Manuel dos Santos"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                autoFocus
                className="input"
              />
            </div>

            {/* Email */}
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Email
              </label>
              <input
                type="email"
                placeholder="nome@exemplo.ao"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="input"
              />
            </div>

            {/* Switch — Candidatar-me a Escritor */}
            <div className="border border-outline-variant/50 rounded-card p-4 bg-surface-container-low/50">
              <div className="flex items-start gap-3">
                <span
                  className="material-symbols-outlined text-primary flex-shrink-0 mt-0.5"
                  style={{ fontSize: '20px', fontVariationSettings: "'FILL' 1" }}
                >
                  edit_note
                </span>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between gap-3">
                    <span className="text-sm font-semibold text-text font-sans leading-snug">
                      Candidatar-me a Escritor
                    </span>
                    <button
                      type="button"
                      role="switch"
                      aria-checked={wantsWriter}
                      onClick={() => setWantsWriter((v) => !v)}
                      className={[
                        'relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent',
                        'transition-colors duration-200 ease-in-out',
                        'focus:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2',
                        wantsWriter ? 'bg-primary' : 'bg-outline/35',
                      ].join(' ')}
                    >
                      <span
                        aria-hidden="true"
                        className={[
                          'pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-sm ring-0',
                          'transition duration-200 ease-in-out',
                          wantsWriter ? 'translate-x-5' : 'translate-x-0',
                        ].join(' ')}
                      />
                    </button>
                  </div>
                  <p className="text-xs text-secondary font-body mt-1.5 leading-relaxed">
                    Os escritores podem publicar artigos e contribuir com conteúdos educativos.
                    A candidatura será analisada pela administração.
                  </p>
                </div>
              </div>

              {wantsWriter && (
                <div className="mt-3 p-3 bg-primary/[0.07] border border-primary/20 rounded-button animate-slide-up">
                  <div className="flex items-start gap-2">
                    <span className="material-symbols-outlined text-primary text-[16px] mt-0.5 flex-shrink-0">
                      info
                    </span>
                    <p className="text-xs text-primary/90 font-body leading-relaxed">
                      A sua conta será criada normalmente. Após o cadastro será enviada automaticamente
                      uma candidatura para Escritor.
                    </p>
                  </div>
                </div>
              )}
            </div>

            {error && (
              <div className="alert-error">
                <span
                  className="material-symbols-outlined text-error text-[18px] flex-shrink-0 mt-0.5"
                  style={{ fontVariationSettings: "'FILL' 1" }}
                >
                  error
                </span>
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
                  disabled
                  className="w-full flex items-center justify-center gap-2.5 border border-outline-variant/50 text-secondary/55 py-[14px] rounded-button text-sm font-semibold font-sans cursor-not-allowed"
                >
                  <span className="material-symbols-outlined text-[18px]">language</span>
                  Registar com Google
                </button>
                <span className="absolute -top-2 -right-2 bg-surface-container text-primary text-[9px] font-bold font-sans px-1.5 py-0.5 rounded-full border border-primary/20 uppercase tracking-wider">
                  Em breve
                </span>
              </div>
            </div>
          </form>

          <footer className="pt-4 border-t border-outline-variant/40 text-center">
            <p className="text-sm text-secondary font-body">
              Já tem conta?{' '}
              <button
                onClick={() => navigate('/login')}
                className="text-primary font-bold hover:text-primary-dark font-sans transition-colors duration-150"
              >
                Iniciar Sessão
              </button>
            </p>
          </footer>
        </div>
      </main>
    </div>
  )
}
