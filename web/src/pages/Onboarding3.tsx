import { useNavigate } from 'react-router-dom'

export default function Onboarding3() {
  const navigate = useNavigate()

  return (
    <div className="flex items-center justify-center min-h-screen p-10 bg-background font-sans">
      <main className="w-full max-w-[1160px] bg-surface rounded-card shadow-card overflow-hidden flex flex-col md:flex-row min-h-[640px]">
        {/* Image side */}
        <div className="relative w-full md:w-1/2 bg-surface-container flex items-center justify-center">
          <span className="material-symbols-outlined text-primary opacity-10" style={{ fontSize: '300px', fontVariationSettings: "'wght' 100" }}>map</span>
          <div className="absolute bottom-8 left-8 right-8 bg-primary/90 backdrop-blur-md p-4 rounded-card text-white">
            <div className="flex items-center gap-3 mb-2">
              <span className="material-symbols-outlined text-[20px]">forum</span>
              <span className="text-xs font-semibold uppercase tracking-wider font-sans">Espaço de Comunidade</span>
            </div>
            <p className="text-xs opacity-90 italic leading-relaxed font-reading">
              "A história económica constrói-se com a partilha de conhecimento e o debate rigoroso."
            </p>
          </div>
        </div>

        {/* Content side */}
        <div className="w-full md:w-1/2 p-16 flex flex-col justify-center">
          {/* Brand */}
          <div className="mb-8 flex items-center gap-3">
            <div className="w-10 h-10 bg-primary rounded-button flex items-center justify-center">
              <span className="material-symbols-outlined text-white" style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div>
              <h2 className="font-bold text-primary text-xl leading-tight font-sans">Economia com História</h2>
              <p className="text-xs text-secondary font-body">Angola</p>
            </div>
          </div>

          <div className="mb-16">
            <h1 className="text-[32px] font-bold text-primary mb-4 font-sans">Participe no Debate</h1>
            <p className="text-lg text-secondary leading-relaxed max-w-[480px] font-reading">
              Explore o mapa interactivo, participe no fórum e teste os seus conhecimentos com quizzes concebidos por especialistas em economia.
            </p>
          </div>

          {/* Features */}
          <div className="grid grid-cols-1 gap-4 mb-16">
            {[
              { icon: 'map', title: 'Mapa Económico Interactivo', desc: 'Acompanhe a evolução histórica por província.' },
              { icon: 'groups', title: 'Fórum de Especialistas', desc: 'Debata temas actuais com a nossa comunidade.' },
              { icon: 'quiz', title: 'Quizzes de Conhecimento', desc: 'Avalie a sua compreensão da história angolana.' },
            ].map((f) => (
              <div key={f.title} className="flex items-start gap-3">
                <span className="material-symbols-outlined text-primary mt-1">{f.icon}</span>
                <div>
                  <span className="text-sm font-semibold block text-text font-sans">{f.title}</span>
                  <span className="text-xs text-secondary font-body">{f.desc}</span>
                </div>
              </div>
            ))}
          </div>

          {/* Dots + Actions */}
          <div className="flex flex-col gap-6">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-outline-variant" />
              <div className="w-2 h-2 rounded-full bg-outline-variant" />
              <div className="w-8 h-2 rounded-full bg-primary" />
            </div>
            <div className="flex items-center gap-4">
              <button
                onClick={() => navigate('/cadastro')}
                className="btn-primary"
              >
                Começar Agora
              </button>
              <button
                onClick={() => navigate('/onboarding/2')}
                className="text-secondary text-sm font-semibold font-sans px-6 py-[14px] rounded-button hover:bg-surface-container-low transition-colors"
              >
                Voltar
              </button>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
