import { useNavigate } from 'react-router-dom'

export default function Onboarding3() {
  const navigate = useNavigate()

  return (
    <div className="flex items-center justify-center min-h-screen p-10" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <main className="w-full max-w-[1160px] bg-white rounded-xl shadow-xl overflow-hidden flex flex-col md:flex-row min-h-[640px]">
        {/* Image side */}
        <div className="relative w-full md:w-1/2 bg-[#f0eded] flex items-center justify-center">
          <span className="material-symbols-outlined text-[#8B1A1A] opacity-10" style={{ fontSize: '300px', fontVariationSettings: "'wght' 100" }}>map</span>
          <div className="absolute bottom-8 left-8 right-8 bg-[#8B1A1A]/90 backdrop-blur-md p-4 rounded-lg text-white">
            <div className="flex items-center gap-3 mb-2">
              <span className="material-symbols-outlined text-[20px]">forum</span>
              <span className="text-xs font-semibold uppercase tracking-wider">Espaço de Comunidade</span>
            </div>
            <p className="text-xs opacity-90 italic leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>
              "A história económica constrói-se com a partilha de conhecimento e o debate rigoroso."
            </p>
          </div>
        </div>

        {/* Content side */}
        <div className="w-full md:w-1/2 p-16 flex flex-col justify-center">
          {/* Brand */}
          <div className="mb-8 flex items-center gap-3">
            <div className="w-10 h-10 bg-[#8B1A1A] rounded-lg flex items-center justify-center">
              <span className="material-symbols-outlined text-white" style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            </div>
            <div>
              <h2 className="font-bold text-[#8B1A1A] text-xl leading-tight">Economia com História</h2>
              <p className="text-xs text-[#5d5f5d]">Angola</p>
            </div>
          </div>

          <div className="mb-16">
            <h1 className="text-[32px] font-bold text-[#8B1A1A] mb-4">Participe no Debate</h1>
            <p className="text-lg text-[#5d5f5d] leading-relaxed max-w-[480px]" style={{ fontFamily: 'Merriweather, serif' }}>
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
                <span className="material-symbols-outlined text-[#8B1A1A] mt-1">{f.icon}</span>
                <div>
                  <span className="text-sm font-semibold block text-[#1c1b1b]">{f.title}</span>
                  <span className="text-xs text-[#5d5f5d]">{f.desc}</span>
                </div>
              </div>
            ))}
          </div>

          {/* Dots + Actions */}
          <div className="flex flex-col gap-6">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-[#e0bfbc]" />
              <div className="w-2 h-2 rounded-full bg-[#e0bfbc]" />
              <div className="w-8 h-2 rounded-full bg-[#8B1A1A]" />
            </div>
            <div className="flex items-center gap-4">
              <button
                onClick={() => navigate('/cadastro')}
                className="bg-[#8B1A1A] text-white text-sm font-semibold px-10 py-4 rounded-full shadow-lg hover:brightness-110 active:scale-95 transition-all"
              >
                Começar Agora
              </button>
              <button
                onClick={() => navigate('/onboarding/2')}
                className="text-[#5d5f5d] text-sm font-semibold px-6 py-4 rounded-full hover:bg-[#f0eded] transition-colors"
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
