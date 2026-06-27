import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { writerApplicationService, type CreateWriterApplicationDto } from '../services/api/writer-application.service'
import CadastroStepper from '../components/CadastroStepper'

interface StoredWriterData {
  biography: string
  academicBackground: string
  institution: string
  specialization: string
  researchExperience: string
  economicHistoryAreas: string
  languages: string
  interestTopics: string
  previousPublications?: string
  portfolio?: string
}

export default function Cadastro3() {
  const navigate = useNavigate()
  const { register } = useAuth()

  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirm, setShowConfirm] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  // Dados acumulados das etapas anteriores
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [isWriter, setIsWriter] = useState(false)

  useEffect(() => {
    const storedName = sessionStorage.getItem('reg_name')
    const storedEmail = sessionStorage.getItem('reg_email')
    if (!storedName || !storedEmail) {
      navigate('/cadastro')
      return
    }
    setName(storedName)
    setEmail(storedEmail)
    setIsWriter(sessionStorage.getItem('reg_writer') === 'true')
  }, [navigate])

  // Validação em tempo real
  const passwordLengthOk = password.length >= 8
  const passwordsMatch = password.length > 0 && confirmPassword.length > 0 && password === confirmPassword
  const passwordMismatch = confirmPassword.length > 0 && password !== confirmPassword

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')

    if (!passwordLengthOk) {
      setError('A palavra-passe deve ter pelo menos 8 caracteres.')
      return
    }
    if (!confirmPassword.trim()) {
      setError('Por favor, confirme a sua palavra-passe.')
      return
    }
    if (password !== confirmPassword) {
      setError('As palavras-passe não coincidem.')
      return
    }

    const interests = sessionStorage.getItem('reg_interests') ?? ''
    const motivation = sessionStorage.getItem('reg_motivation') ?? ''
    setLoading(true)

    try {
      await register({
        name,
        email,
        password,
        ...(interests ? { interests } : {}),
        ...(motivation ? { motivation } : {}),
      })

      let writerApplied = false

      if (isWriter) {
        const rawData = sessionStorage.getItem('reg_writer_data')
        if (rawData) {
          try {
            const writerData = JSON.parse(rawData) as StoredWriterData
            const dto: CreateWriterApplicationDto = {
              fullName: name,
              biography: writerData.biography,
              academicBackground: writerData.academicBackground,
              institution: writerData.institution,
              specialization: writerData.specialization,
              researchExperience: writerData.researchExperience,
              economicHistoryAreas: writerData.economicHistoryAreas,
              languages: writerData.languages,
              interestTopics: writerData.interestTopics,
              ...(writerData.previousPublications ? { previousPublications: writerData.previousPublications } : {}),
              ...(writerData.portfolio ? { portfolio: writerData.portfolio } : {}),
            }
            await writerApplicationService.apply(dto)
            writerApplied = true
          } catch {
            writerApplied = false
          }
        }
      }

      // Limpar todos os dados temporários do registo
      ;['reg_name', 'reg_email', 'reg_writer', 'reg_interests', 'reg_motivation', 'reg_writer_data'].forEach((k) =>
        sessionStorage.removeItem(k)
      )

      // Passar resultado para a tela de confirmação
      sessionStorage.setItem('reg_writer_applied', writerApplied ? 'true' : 'false')
      sessionStorage.setItem('reg_wanted_writer', isWriter ? 'true' : 'false')

      navigate('/cadastro/sucesso')
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
          <div className="h-full bg-primary transition-all duration-700 ease-out" style={{ width: '100%' }} />
        </div>

        {/* Stepper */}
        <div className="px-8 pt-6 pb-5">
          <CadastroStepper currentStep={3} />
        </div>

        <div className="h-px mx-8 bg-outline-variant/25" />

        <div className="px-8 py-7 flex flex-col gap-6">
          <header>
            <h1 className="text-headline-md font-bold text-text font-sans tracking-tight">
              Crie uma Palavra-passe
            </h1>
            <p className="text-body-md font-body text-secondary mt-1.5 leading-relaxed">
              Escolha uma palavra-passe segura para proteger a sua conta.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
            {/* Palavra-passe */}
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Palavra-passe
              </label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">
                  lock
                </span>
                <input
                  type={showPassword ? 'text' : 'password'}
                  placeholder="Mínimo 8 caracteres"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  minLength={8}
                  autoFocus
                  className="input pl-10 pr-10"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((v) => !v)}
                  className="absolute right-3.5 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors"
                  aria-label={showPassword ? 'Ocultar' : 'Mostrar'}
                >
                  <span className="material-symbols-outlined text-[18px]">
                    {showPassword ? 'visibility_off' : 'visibility'}
                  </span>
                </button>
              </div>

              {/* Indicador de comprimento */}
              {password.length > 0 && (
                <div className="flex items-center gap-1.5 animate-fade-in">
                  <span
                    className={`material-symbols-outlined text-[14px] ${passwordLengthOk ? 'text-success' : 'text-outline'}`}
                    style={{ fontVariationSettings: passwordLengthOk ? "'FILL' 1" : "'FILL' 0" }}
                  >
                    {passwordLengthOk ? 'check_circle' : 'radio_button_unchecked'}
                  </span>
                  <span className={`text-xs font-body ${passwordLengthOk ? 'text-success' : 'text-outline'}`}>
                    Mínimo 8 caracteres
                  </span>
                </div>
              )}
            </div>

            {/* Confirmar Palavra-passe */}
            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Confirmar Palavra-passe
              </label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">
                  lock
                </span>
                <input
                  type={showConfirm ? 'text' : 'password'}
                  placeholder="Repita a palavra-passe"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  className={[
                    'input pl-10 pr-10 transition-colors',
                    passwordsMatch ? 'border-success/60 focus:border-success focus:ring-success/10' : '',
                    passwordMismatch ? 'border-error/50 focus:border-error focus:ring-error/10' : '',
                  ].join(' ')}
                />
                <div className="absolute right-3.5 top-1/2 -translate-y-1/2 flex items-center gap-1">
                  {confirmPassword.length > 0 && (passwordsMatch || passwordMismatch) ? (
                    <span
                      className={`material-symbols-outlined text-[18px] ${passwordsMatch ? 'text-success' : 'text-error'}`}
                      style={{ fontVariationSettings: "'FILL' 1" }}
                    >
                      {passwordsMatch ? 'check_circle' : 'cancel'}
                    </span>
                  ) : (
                    <button
                      type="button"
                      onClick={() => setShowConfirm((v) => !v)}
                      className="text-outline hover:text-primary transition-colors"
                      aria-label={showConfirm ? 'Ocultar' : 'Mostrar'}
                    >
                      <span className="material-symbols-outlined text-[18px]">
                        {showConfirm ? 'visibility_off' : 'visibility'}
                      </span>
                    </button>
                  )}
                </div>
              </div>

              {/* Feedback em tempo real */}
              {passwordMismatch && (
                <p className="text-xs text-error font-body animate-fade-in">
                  As palavras-passe não coincidem.
                </p>
              )}
              {passwordsMatch && (
                <p className="text-xs text-success font-body animate-fade-in">
                  As palavras-passe coincidem.
                </p>
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

            <div className="mt-1 flex gap-4">
              <button
                type="button"
                onClick={() => navigate('/cadastro/2')}
                className="btn-secondary flex-shrink-0"
              >
                Voltar
              </button>
              <button
                type="submit"
                disabled={loading || passwordMismatch}
                className="btn-primary flex-1 justify-center disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : isWriter ? (
                  'Criar Conta e Candidatar'
                ) : (
                  'Criar Conta'
                )}
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  )
}
