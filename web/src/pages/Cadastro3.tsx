import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function Cadastro3() {
  const navigate = useNavigate()
  const { user } = useAuth()

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
        {/* Barra de progresso completa */}
        <div className="h-1 w-full bg-primary" />

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col items-center gap-3 text-center">
            <div className="w-14 h-14 rounded-card bg-success/10 flex items-center justify-center">
              <span className="material-symbols-outlined text-success" style={{ fontSize: '32px', fontVariationSettings: "'FILL' 1" }}>check_circle</span>
            </div>
            <div>
              <span className="text-label-md font-bold text-primary uppercase tracking-[0.1em] font-sans block mb-1">Passo 3 de 3</span>
              <h1 className="text-headline-md font-bold text-text font-sans">Conta Criada!</h1>
              <p className="text-body-md font-body text-secondary mt-1">
                A sua conta foi criada com sucesso. Bem-vindo à comunidade!
              </p>
            </div>
          </header>

          {/* Resumo */}
          <div className="bg-surface-container-low rounded-card p-5 space-y-3 border border-outline-variant/30">
            {[
              { label: 'Nome', value: user?.name ?? '—' },
              { label: 'Email', value: user?.email ?? '—' },
            ].map((item) => (
              <div key={item.label} className="flex justify-between items-center">
                <span className="text-sm text-secondary font-body">{item.label}</span>
                <span className="text-sm font-semibold text-text font-sans">{item.value}</span>
              </div>
            ))}
          </div>

          <button
            onClick={() => navigate('/dashboard')}
            className="w-full bg-primary text-white text-sm font-semibold py-[14px] rounded-button hover:bg-primary-dark hover:shadow-md transition-all active:scale-[0.98] flex items-center justify-center gap-2 uppercase tracking-wide font-sans"
          >
            Começar a explorar
            <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
          </button>
        </div>
      </main>
    </div>
  )
}
