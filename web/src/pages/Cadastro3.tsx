import { useNavigate } from 'react-router-dom'

export default function Cadastro3() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <div className="mb-8 flex flex-col items-center text-center">
        <h2 className="text-2xl font-bold text-[#8B1A1A] mb-1">Economia com História</h2>
        <p className="text-xs text-[#5d5f5d] tracking-widest uppercase">Angola</p>
      </div>

      <main className="w-full max-w-[480px] bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 overflow-hidden">
        <div className="h-1.5 w-full bg-[#8B1A1A]" />

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col gap-2">
            <span className="text-xs font-bold text-[#8B1A1A]">Passo 3 de 3</span>
            <h1 className="text-[32px] font-bold text-[#1c1b1b]">Confirmar Dados</h1>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Reveja os seus dados antes de concluir o registo.
            </p>
          </header>

          {/* Summary */}
          <div className="bg-[#f6f3f2] rounded-xl p-6 space-y-4">
            {[
              { label: 'Nome', value: 'Manuel dos Santos' },
              { label: 'Email', value: 'manuel@exemplo.ao' },
              { label: 'Perfil', value: 'Académico / Investigador' },
              { label: 'Área', value: 'História Económica' },
            ].map((item) => (
              <div key={item.label} className="flex justify-between items-center">
                <span className="text-sm text-[#5d5f5d]">{item.label}</span>
                <span className="text-sm font-semibold text-[#1c1b1b]">{item.value}</span>
              </div>
            ))}
          </div>

          <label className="flex items-start gap-3 cursor-pointer">
            <input type="checkbox" defaultChecked className="w-4 h-4 mt-1 rounded border-[#e0bfbc] text-[#8B1A1A]" />
            <span className="text-sm text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Aceito os <button type="button" onClick={() => navigate('/ajuda')} className="text-[#8B1A1A] hover:underline">Termos de Uso</button> e a{' '}
              <button type="button" onClick={() => navigate('/ajuda')} className="text-[#8B1A1A] hover:underline">Política de Privacidade</button>
            </span>
          </label>

          <div className="flex gap-4">
            <button
              onClick={() => navigate('/cadastro/2')}
              className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
            >
              Voltar
            </button>
            <button
              onClick={() => navigate('/dashboard')}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-colors active:scale-95 flex items-center justify-center gap-2"
            >
              Concluir
              <span className="material-symbols-outlined text-[18px]">check</span>
            </button>
          </div>
        </div>
      </main>
    </div>
  )
}
