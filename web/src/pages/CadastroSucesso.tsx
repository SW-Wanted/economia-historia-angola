import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function CadastroSucesso() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [writerApplied, setWriterApplied] = useState(false)
  const [wantedWriter, setWantedWriter] = useState(false)

  useEffect(() => {
    setWriterApplied(sessionStorage.getItem('reg_writer_applied') === 'true')
    setWantedWriter(sessionStorage.getItem('reg_wanted_writer') === 'true')
    sessionStorage.removeItem('reg_writer_applied')
    sessionStorage.removeItem('reg_wanted_writer')
  }, [])

  const showWriterSuccess = wantedWriter && writerApplied
  const showWriterFailed = wantedWriter && !writerApplied

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-body bg-background">
      {/* Logo */}
      <div className="mb-8 flex flex-col items-center text-center">
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

      <main className="w-full max-w-[480px] bg-surface rounded-card shadow-card border border-outline-variant/45 overflow-hidden">
        {/* Barra de progresso completa */}
        <div className="h-1 w-full bg-primary" />

        <div className="p-10 flex flex-col gap-8 animate-fade-in">
          {/* Ícone e título */}
          <header className="flex flex-col items-center gap-3 text-center">
            <div className="w-16 h-16 rounded-card bg-success/10 flex items-center justify-center">
              <span
                className="material-symbols-outlined text-success"
                style={{ fontSize: '36px', fontVariationSettings: "'FILL' 1" }}
              >
                check_circle
              </span>
            </div>
            <div>
              <h1 className="text-headline-md font-bold text-text font-sans mt-1">Conta Criada!</h1>
              <p className="text-body-md font-body text-secondary mt-1.5 leading-relaxed">
                Bem-vindo à comunidade. A sua conta está pronta a utilizar.
              </p>
            </div>
          </header>

          {/* Resumo da conta */}
          <div className="bg-surface-container-low rounded-card p-5 space-y-3 border border-outline-variant/30">
            {[
              { label: 'Nome', value: user?.name ?? '—' },
              { label: 'Email', value: user?.email ?? '—' },
            ].map((item) => (
              <div key={item.label} className="flex justify-between items-center gap-4">
                <span className="text-sm text-secondary font-body flex-shrink-0">{item.label}</span>
                <span className="text-sm font-semibold text-text font-sans text-right truncate">{item.value}</span>
              </div>
            ))}
          </div>

          {/* Estado da candidatura de Escritor — sucesso */}
          {showWriterSuccess && (
            <div className="flex flex-col gap-3 animate-slide-up">
              <div className="flex items-start gap-3 p-4 bg-primary/[0.07] border border-primary/25 rounded-card">
                <div className="w-9 h-9 rounded-lg bg-primary/10 flex items-center justify-center flex-shrink-0">
                  <span
                    className="material-symbols-outlined text-primary"
                    style={{ fontSize: '18px', fontVariationSettings: "'FILL' 1" }}
                  >
                    edit_note
                  </span>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-semibold text-text font-sans mb-0.5">
                    Candidatura a Escritor Enviada
                  </p>
                  <p className="text-xs text-secondary font-body leading-relaxed">
                    A candidatura foi enviada com sucesso e será analisada pela administração.
                    Será notificado quando houver uma decisão.
                  </p>
                </div>
              </div>
              <div className="flex items-start gap-2 px-0.5">
                <span
                  className="material-symbols-outlined text-outline flex-shrink-0 mt-0.5"
                  style={{ fontSize: '14px' }}
                >
                  info
                </span>
                <p className="text-xs text-outline font-body leading-relaxed">
                  A sua conta está ativa como utilizador. O acesso como Escritor será concedido após
                  aprovação da candidatura pela equipa de administração.
                </p>
              </div>
            </div>
          )}

          {/* Estado da candidatura de Escritor — falhou */}
          {showWriterFailed && (
            <div className="flex items-start gap-3 p-4 bg-warning/[0.07] border border-warning/25 rounded-card animate-slide-up">
              <span
                className="material-symbols-outlined text-warning flex-shrink-0 mt-0.5"
                style={{ fontSize: '20px' }}
              >
                warning
              </span>
              <div>
                <p className="text-sm font-semibold text-text font-sans mb-0.5">
                  Candidatura não submetida
                </p>
                <p className="text-xs text-secondary font-body leading-relaxed">
                  A sua conta foi criada com sucesso, mas não foi possível submeter a candidatura
                  a Escritor de momento. Pode tentar novamente mais tarde a partir do seu perfil.
                </p>
              </div>
            </div>
          )}

          {/* CTA */}
          <button
            onClick={() => navigate('/dashboard')}
            className="btn-primary w-full justify-center"
          >
            Começar a explorar
            <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
          </button>
        </div>
      </main>
    </div>
  )
}
