import { useNavigate } from 'react-router-dom'

export default function Onboarding1() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex items-center justify-center p-6 bg-background font-sans">
      {/* Skip */}
      <div className="fixed top-0 left-0 w-full p-10 flex justify-end z-50">
        <button
          onClick={() => navigate('/login')}
          className="text-sm font-semibold text-secondary hover:text-primary transition-colors flex items-center gap-2 font-sans"
        >
          Pular
          <span className="material-symbols-outlined text-[18px]">chevron_right</span>
        </button>
      </div>

      <main className="w-full max-w-[1280px] h-[800px] bg-surface rounded-card overflow-hidden flex shadow-card relative">
        {/* Left */}
        <div className="w-1/2 flex flex-col justify-between p-16">
          {/* Brand */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary flex items-center justify-center rounded-button">
              <span className="material-symbols-outlined text-white" style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div className="flex flex-col">
              <span className="font-bold text-primary text-xl leading-none font-sans">Economia com História</span>
              <span className="text-xs text-secondary font-body">Angola</span>
            </div>
          </div>

          {/* Content */}
          <div className="max-w-[440px]">
            <h1 className="text-[48px] font-extrabold text-primary mb-4 leading-tight font-sans">Rigor Académico</h1>
            <p className="text-lg text-secondary leading-relaxed font-reading">
              Fontes verificadas e análises fundamentadas por especialistas, resgatando a memória económica de Angola com profundidade e precisão histórica.
            </p>
            {/* Dots */}
            <div className="flex gap-2 mt-8">
              <div className="h-2 w-8 bg-primary rounded-full" />
              <div className="h-2 w-2 bg-outline-variant rounded-full" />
              <div className="h-2 w-2 bg-outline-variant rounded-full" />
            </div>
          </div>

          {/* Actions */}
          <div className="flex items-center justify-between">
            <button
              onClick={() => navigate('/onboarding/2')}
              className="btn-primary"
            >
              Próximo
              <span className="material-symbols-outlined">arrow_forward</span>
            </button>
            <span className="text-xs text-secondary font-body">Passo 1 de 3</span>
          </div>
        </div>

        {/* Right image */}
        <div className="w-1/2 relative bg-surface-container overflow-hidden">
          <div className="absolute inset-0 flex items-center justify-center">
            <span className="material-symbols-outlined text-primary opacity-10" style={{ fontSize: '300px', fontVariationSettings: "'wght' 100" }}>history_edu</span>
          </div>
          <div className="absolute bottom-10 left-10 right-10 bg-primary/80 backdrop-blur-md p-4 border border-primary/20 rounded-card">
            <div className="flex items-start gap-3">
              <span className="material-symbols-outlined text-white">menu_book</span>
              <div>
                <p className="text-sm font-semibold text-white font-sans">Arquivo Digital</p>
                <p className="text-xs text-white/80 font-body">Documentos históricos preservados e digitalizados para consulta académica.</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
