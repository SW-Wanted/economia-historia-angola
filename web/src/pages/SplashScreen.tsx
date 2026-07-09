import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'

export default function SplashScreen() {
  const navigate = useNavigate()

  useEffect(() => {
    const t = setTimeout(() => navigate('/onboarding/1'), 2500)
    return () => clearTimeout(t)
  }, [navigate])

  return (
    <div className="min-h-screen flex flex-col items-center justify-center overflow-hidden relative bg-background font-sans">
      {/* Background map watermark */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none opacity-[0.06]">
        <svg viewBox="0 0 400 500" className="w-[600px] h-[600px]" fill="none" stroke="#8B1A1A" strokeWidth="1.5">
          <path d="M180,40 L220,60 L260,50 L300,80 L320,140 L280,220 L260,300 L220,360 L160,340 L100,300 L80,240 L60,180 L80,100 L140,60 Z" />
        </svg>
      </div>

      <main className="relative z-10 flex flex-col items-center gap-8 text-center px-10">
        <div className="flex flex-col items-center gap-4">
          <span
            className="material-symbols-outlined text-primary"
            style={{ fontSize: '80px', fontVariationSettings: "'FILL' 1" }}
          >
            account_balance
          </span>
          <h1 className="text-[48px] font-extrabold text-primary tracking-tight leading-none font-sans">
            Economia com História
          </h1>
          <div className="flex items-center gap-4 w-full">
            <div className="h-px flex-grow bg-outline-variant" />
            <span className="text-sm font-semibold text-text-muted uppercase tracking-[0.2em] font-sans">Angola</span>
            <div className="h-px flex-grow bg-outline-variant" />
          </div>
        </div>
        <p className="text-lg text-secondary max-w-[500px] leading-relaxed italic font-reading">
          "Compreenda o presente através do passado."
        </p>
      </main>

      {/* Loading bar */}
      <footer className="fixed bottom-16 flex flex-col items-center gap-2">
        <div className="w-60 h-0.5 bg-outline-variant rounded-full relative overflow-hidden">
          <div
            className="absolute h-full w-[40%] bg-primary rounded-full"
            style={{ animation: 'loading 2s infinite linear', left: '-40%' }}
          />
        </div>
        <span className="text-xs text-secondary uppercase tracking-widest opacity-60 font-sans">A carregar arquivo</span>
      </footer>

      <style>{`
        @keyframes loading {
          0% { left: -40%; }
          100% { left: 100%; }
        }
      `}</style>
    </div>
  )
}
