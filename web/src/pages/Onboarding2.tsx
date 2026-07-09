import { useNavigate } from 'react-router-dom'

export default function Onboarding2() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-10 py-16 bg-background font-sans">
      <main className="w-full max-w-[1000px] flex flex-col items-center justify-center">
        <div className="bg-surface rounded-card shadow-card overflow-hidden flex flex-col md:flex-row w-full min-h-[600px]">
          {/* Visual side */}
          <div className="w-full md:w-1/2 bg-surface-container p-8 flex items-center justify-center relative overflow-hidden">
            <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(#8B1A1A 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
            <div className="grid grid-cols-2 gap-4 w-full max-h-[480px]">
              {[
                { icon: 'description', label: 'MICROTEXTO' },
                { icon: 'play_circle', label: 'VÍDEO' },
                { icon: 'map', label: 'MAPA' },
                { icon: 'forum', label: 'FÓRUM' },
              ].map((item) => (
                <div key={item.label} className="bg-surface rounded-card shadow-card p-4 flex flex-col items-center justify-center gap-2 aspect-square">
                  <span className="material-symbols-outlined text-primary text-4xl">{item.icon}</span>
                  <span className="text-[10px] font-bold text-primary tracking-widest font-sans">{item.label}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Content side */}
          <div className="w-full md:w-1/2 p-16 flex flex-col justify-center bg-surface">
            <div className="max-w-[400px] mx-auto w-full space-y-8">
              <h1 className="text-[32px] font-bold text-primary font-sans">Herança Cultural</h1>
              <p className="text-lg text-secondary leading-relaxed font-reading">
                A nossa história como chave do futuro da economia angolana.
              </p>
              {/* Dots */}
              <div className="flex gap-2 py-4">
                <div className="w-2 h-2 rounded-full bg-outline-variant" />
                <div className="w-6 h-2 rounded-full bg-primary" />
                <div className="w-2 h-2 rounded-full bg-outline-variant" />
              </div>
              {/* Actions */}
              <div className="flex items-center gap-4 pt-4">
                <button
                  onClick={() => navigate('/onboarding/1')}
                  className="btn-secondary flex-1 justify-center"
                >
                  Voltar
                </button>
                <button onClick={() => navigate('/onboarding/3')} className="btn-primary flex-1 justify-center">
                  Próximo
                </button>
              </div>
            </div>
          </div>
        </div>

        <footer className="mt-8 flex flex-col items-center gap-2 opacity-60">
          <span className="font-bold text-primary text-xl font-sans">Economia com História</span>
          <p className="text-xs text-secondary font-body">Angola © 2026</p>
        </footer>
      </main>
    </div>
  )
}
