import { useNavigate } from 'react-router-dom'

export default function Onboarding1() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex items-center justify-center p-6" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      {/* Skip */}
      <div className="fixed top-0 left-0 w-full p-10 flex justify-end z-50">
        <button
          onClick={() => navigate('/login')}
          className="text-sm font-semibold text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors flex items-center gap-2"
        >
          Pular
          <span className="material-symbols-outlined text-[18px]">chevron_right</span>
        </button>
      </div>

      <main className="w-full max-w-[1280px] h-[800px] bg-white rounded-xl overflow-hidden flex shadow-[0px_4px_20px_rgba(0,0,0,0.04)] relative">
        {/* Left */}
        <div className="w-1/2 flex flex-col justify-between p-16">
          {/* Brand */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-[#8B1A1A] flex items-center justify-center rounded-lg">
              <span className="material-symbols-outlined text-white" style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div className="flex flex-col">
              <span className="font-bold text-[#8B1A1A] text-xl leading-none">Economia com História</span>
              <span className="text-xs text-[#5d5f5d]">Angola</span>
            </div>
          </div>

          {/* Content */}
          <div className="max-w-[440px]">
            <h1 className="text-[48px] font-extrabold text-[#8B1A1A] mb-4 leading-tight">Rigor Académico</h1>
            <p className="text-lg text-[#5d5f5d] leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>
              Fontes verificadas e análises fundamentadas por especialistas, resgatando a memória económica de Angola com profundidade e precisão histórica.
            </p>
            {/* Dots */}
            <div className="flex gap-2 mt-8">
              <div className="h-2 w-8 bg-[#8B1A1A] rounded-full" />
              <div className="h-2 w-2 bg-[#e2e3e1] rounded-full" />
              <div className="h-2 w-2 bg-[#e2e3e1] rounded-full" />
            </div>
          </div>

          {/* Actions */}
          <div className="flex items-center justify-between">
            <button
              onClick={() => navigate('/onboarding/2')}
              className="bg-[#8B1A1A] text-white px-8 py-4 rounded-full text-sm font-semibold flex items-center gap-3 hover:opacity-90 active:scale-95 transition-all"
            >
              Próximo
              <span className="material-symbols-outlined">arrow_forward</span>
            </button>
            <span className="text-xs text-[#5d5f5d]">Passo 1 de 3</span>
          </div>
        </div>

        {/* Right image */}
        <div className="w-1/2 relative bg-[#e5e2e1] overflow-hidden">
          <div className="absolute inset-0 flex items-center justify-center">
            <span className="material-symbols-outlined text-[#8B1A1A] opacity-10" style={{ fontSize: '300px', fontVariationSettings: "'wght' 100" }}>history_edu</span>
          </div>
          <div className="absolute bottom-10 left-10 right-10 bg-white/10 backdrop-blur-md p-4 border border-white/20 rounded-lg">
            <div className="flex items-start gap-3">
              <span className="material-symbols-outlined text-white">menu_book</span>
              <div>
                <p className="text-sm font-semibold text-white">Arquivo Digital</p>
                <p className="text-xs text-white/80">Documentos históricos preservados e digitalizados para consulta académica.</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
