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
      <div className="px-10 py-10 max-w-[460px] mx-auto text-center">
        <div className="bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card">
          <div className="w-16 h-16 bg-[#fff5f4] border border-[#8B1A1A]/15 rounded-2xl flex items-center justify-center mx-auto mb-5">
            <span className="material-symbols-outlined text-[#8B1A1A]" style={{ fontSize: '32px' }}>logout</span>
          </div>
          <h1 className="text-[24px] font-bold text-[#1c1b1b] mb-2 font-sans tracking-tight">Tem a certeza?</h1>
          <p className="text-sm text-[#5d5f5d] mb-7 font-serif leading-relaxed max-w-xs mx-auto">
            Está prestes a terminar a sua sessão. O seu progresso de leitura será guardado automaticamente.
          </p>
          <div className="flex gap-3">
            <button
              onClick={() => navigate(-1)}
              className="flex-1 border border-[#ebe5e4] text-[#1c1b1b] text-sm font-semibold font-sans py-3 rounded-full hover:bg-[#f0eded] hover:border-[#d4c5c3] transition-all duration-150"
            >
              Cancelar
            </button>
            <button
              onClick={handleLogout}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold font-sans py-3 rounded-full hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 flex items-center justify-center gap-2"
            >
              Sair
              <span className="material-symbols-outlined text-[16px]">logout</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
