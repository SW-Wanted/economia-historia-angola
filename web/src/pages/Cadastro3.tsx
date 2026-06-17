import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function Cadastro3() {
  const navigate = useNavigate()
  const { user } = useAuth()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-sans" style={{ backgroundColor: '#F2F2F0' }}>
      <div className="mb-8 flex flex-col items-center text-center">
        <h2 className="text-2xl font-bold text-[#8B1A1A] mb-1">Economia com História</h2>
        <p className="text-xs text-[#5d5f5d] tracking-widest uppercase">Angola</p>
      </div>

      <main className="w-full max-w-[480px] bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 overflow-hidden">
        <div className="h-1.5 w-full bg-[#8B1A1A]" />

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col gap-2">
            <span className="text-xs font-bold text-[#8B1A1A]">Passo 3 de 3</span>
            <h1 className="text-[32px] font-bold text-[#1c1b1b]">Conta Criada!</h1>
            <p className="text-base text-[#5d5f5d] font-serif">
              A sua conta foi criada com sucesso. Bem-vindo à comunidade!
            </p>
          </header>

          {/* Summary */}
          <div className="bg-[#f6f3f2] rounded-xl p-6 space-y-4">
            {[
              { label: 'Nome', value: user?.name ?? '—' },
              { label: 'Email', value: user?.email ?? '—' },
            ].map((item) => (
              <div key={item.label} className="flex justify-between items-center">
                <span className="text-sm text-[#5d5f5d]">{item.label}</span>
                <span className="text-sm font-semibold text-[#1c1b1b]">{item.value}</span>
              </div>
            ))}
          </div>

          <div className="flex gap-4">
            <button
              onClick={() => navigate('/dashboard')}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-colors active:scale-95 flex items-center justify-center gap-2"
            >
              Começar a explorar
              <span className="material-symbols-outlined text-[18px]">check</span>
            </button>
          </div>
        </div>
      </main>
    </div>
  )
}
