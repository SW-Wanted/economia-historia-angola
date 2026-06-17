import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'

export default function SplashScreen() {
  const navigate = useNavigate()

  useEffect(() => {
    const t = setTimeout(() => navigate('/onboarding/1'), 2500)
    return () => clearTimeout(t)
  }, [navigate])

  return (
    <div
      className="min-h-screen flex flex-col items-center justify-center overflow-hidden relative"
      style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}
    >
      {/* Background map watermark */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none opacity-[0.06]">
        <svg viewBox="0 0 400 500" className="w-[600px] h-[600px]" fill="none" stroke="#8B1A1A" strokeWidth="1.5">
          <path d="M180,40 L220,60 L260,50 L300,80 L320,140 L280,220 L260,300 L220,360 L160,340 L100,300 L80,240 L60,180 L80,100 L140,60 Z" />
        </svg>
      </div>

      <main className="relative z-10 flex flex-col items-center gap-8 text-center px-10">
        <div className="flex flex-col items-center gap-4">
          <span
            className="material-symbols-outlined text-[#8B1A1A]"
            style={{ fontSize: '80px', fontVariationSettings: "'FILL' 1" }}
          >
            account_balance
          </span>
          <h1
            className="text-[48px] font-extrabold text-[#8B1A1A] tracking-tight leading-none"
          >
            Economia com História
          </h1>
          <div className="flex items-center gap-4 w-full">
            <div className="h-px flex-grow bg-[#e0bfbc]" />
            <span className="text-sm font-semibold text-[#5d5f5d] uppercase tracking-[0.2em]">Angola</span>
            <div className="h-px flex-grow bg-[#e0bfbc]" />
          </div>
        </div>
        <p className="text-lg text-[#58413f] max-w-[500px] leading-relaxed italic" style={{ fontFamily: 'Merriweather, serif' }}>
          "Compreenda o presente através do passado."
        </p>
      </main>

      {/* Loading bar */}
      <footer className="fixed bottom-16 flex flex-col items-center gap-2">
        <div className="w-60 h-0.5 bg-[#e0bfbc] rounded-full relative overflow-hidden">
          <div
            className="absolute h-full w-[40%] bg-[#8B1A1A] rounded-full"
            style={{ animation: 'loading 2s infinite linear', left: '-40%' }}
          />
        </div>
        <span className="text-xs text-[#5d5f5d] uppercase tracking-widest opacity-60">A carregar arquivo</span>
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
