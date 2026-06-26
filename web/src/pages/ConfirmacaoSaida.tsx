import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth } from '../contexts/AuthContext'

export default function ConfirmacaoSaida() {
  const navigate = useNavigate()
  const { logout } = useAuth()

  async function handleLogout() {
    await logout()
    navigate('/login', { replace: true })
  }

  return (
    <AppShell showSearch={false}>
      <div className="page-content-narrow py-16 text-center animate-fade-in">
        <div className="card p-8 max-w-[400px] mx-auto">
          <div className="w-16 h-16 bg-surface-container border border-primary/15 rounded-2xl flex items-center justify-center mx-auto mb-5">
            <span className="material-symbols-outlined text-primary" style={{ fontSize: '32px' }}>logout</span>
          </div>
          <h1 className="text-[24px] font-bold text-text mb-2 font-sans tracking-tight">Tem a certeza?</h1>
          <p className="text-body-md font-body text-secondary mb-7 leading-relaxed max-w-xs mx-auto">
            Está prestes a terminar a sua sessão. O seu progresso de leitura será guardado automaticamente.
          </p>
          <div className="flex gap-3">
            <button onClick={() => navigate(-1)} className="btn-ghost flex-1 justify-center">Cancelar</button>
            <button onClick={handleLogout} className="btn-primary flex-1 justify-center">
              Sair
              <span className="material-symbols-outlined text-[16px]">logout</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
