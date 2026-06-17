import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function ConfirmacaoSaida() {
  const navigate = useNavigate()

  return (
    <AppShell showSearch={false}>
      <div className="px-10 py-16 max-w-[500px] mx-auto text-center">
        <div className="bg-white rounded-xl p-12 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <div className="w-20 h-20 bg-[#ffdad6] rounded-full flex items-center justify-center mx-auto mb-6">
            <span className="material-symbols-outlined text-[#8B1A1A]" style={{ fontSize: '48px' }}>logout</span>
          </div>
          <h1 className="text-[28px] font-bold text-[#1c1b1b] mb-3">Tem a certeza?</h1>
          <p className="text-base text-[#5d5f5d] mb-8" style={{ fontFamily: 'Merriweather, serif' }}>
            Está prestes a terminar a sua sessão. O seu progresso de leitura será guardado automaticamente.
          </p>
          <div className="flex gap-4">
            <button onClick={() => navigate(-1)}
              className="flex-1 border border-[#e0bfbc] text-[#1c1b1b] text-sm font-semibold py-4 rounded-full hover:bg-[#f6f3f2] transition-colors">
              Cancelar
            </button>
            <button onClick={() => navigate('/login')}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all flex items-center justify-center gap-2">
              Sair
              <span className="material-symbols-outlined text-[18px]">logout</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
