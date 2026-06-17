import { useNavigate } from 'react-router-dom'

export default function Onboarding2() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-10 py-16" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <main className="w-full max-w-[1000px] flex flex-col items-center justify-center">
        <div className="bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] overflow-hidden flex flex-col md:flex-row w-full min-h-[600px]">
          {/* Visual side */}
          <div className="w-full md:w-1/2 bg-[#f0eded] p-8 flex items-center justify-center relative overflow-hidden">
            <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(#8B1A1A 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
            <div className="grid grid-cols-2 gap-4 w-full max-h-[480px]">
              {[
                { icon: 'description', label: 'MICROTEXTO' },
                { icon: 'play_circle', label: 'VÍDEO' },
                { icon: 'map', label: 'MAPA' },
                { icon: 'forum', label: 'FÓRUM' },
              ].map((item) => (
                <div key={item.label} className="bg-white rounded-lg shadow-sm p-4 flex flex-col items-center justify-center gap-2 aspect-square">
                  <span className="material-symbols-outlined text-[#8B1A1A] text-4xl">{item.icon}</span>
                  <span className="text-[10px] font-bold text-[#8B1A1A] tracking-widest">{item.label}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Content side */}
          <div className="w-full md:w-1/2 p-16 flex flex-col justify-center bg-white">
            <div className="max-w-[400px] mx-auto w-full space-y-8">
              <h1 className="text-[32px] font-bold text-[#8B1A1A]">Herança Cultural</h1>
              <p className="text-lg text-[#5d5f5d] leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>
                A nossa história como chave do futuro da economia angolana.
              </p>
              {/* Dots */}
              <div className="flex gap-2 py-4">
                <div className="w-2 h-2 rounded-full bg-[#c6c7c5]" />
                <div className="w-6 h-2 rounded-full bg-[#8B1A1A]" />
                <div className="w-2 h-2 rounded-full bg-[#c6c7c5]" />
              </div>
              {/* Actions */}
              <div className="flex items-center gap-6 pt-4">
                <button
                  onClick={() => navigate('/onboarding/1')}
                  className="flex-1 px-4 py-4 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold rounded-full hover:bg-[#f0eded] transition-colors"
                >
                  Voltar
                </button>
                <button
                  onClick={() => navigate('/onboarding/3')}
                  className="flex-1 px-4 py-4 bg-[#8B1A1A] text-white text-sm font-semibold rounded-full hover:opacity-90 active:scale-95 transition-all shadow-sm"
                >
                  Próximo
                </button>
              </div>
            </div>
          </div>
        </div>

        <footer className="mt-8 flex flex-col items-center gap-2 opacity-60">
          <span className="font-bold text-[#8B1A1A] text-xl">Economia com História</span>
          <p className="text-xs text-[#5d5f5d]">Angola © 2026</p>
        </footer>
      </main>
    </div>
  )
}
