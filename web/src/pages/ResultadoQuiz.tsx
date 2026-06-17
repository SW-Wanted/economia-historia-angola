import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function ResultadoQuiz() {
  const navigate = useNavigate()

  return (
    <AppShell title="Resultado do Quiz" showSearch={false}>
      <div className="px-10 py-10 max-w-[640px] mx-auto text-center">
        <div className="bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card">
          {/* Score circle */}
          <div className="w-28 h-28 rounded-full bg-[#8B1A1A] flex flex-col items-center justify-center mx-auto mb-7 shadow-md">
            <span className="text-[36px] font-extrabold text-white leading-none font-sans">88%</span>
            <span className="text-[10px] text-white/70 uppercase tracking-[0.1em] font-sans mt-0.5">Precisão</span>
          </div>

          <h1 className="text-[28px] font-bold text-[#1c1b1b] mb-1.5 font-sans tracking-tight">Excelente Resultado!</h1>
          <p className="text-sm text-[#5d5f5d] mb-7 font-serif leading-relaxed max-w-sm mx-auto">
            Completou o quiz "A Evolução da Moeda Colonial" com 88% de precisão. Ganhou 150 pontos de mérito!
          </p>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-3 mb-8">
            {[
              { icon: 'check_circle', label: 'Corretas', value: '8', color: 'text-emerald-600' },
              { icon: 'cancel', label: 'Erradas', value: '1', color: 'text-red-500' },
              { icon: 'timer', label: 'Tempo', value: '7:23', color: 'text-[#8B1A1A]' },
            ].map((s) => (
              <div key={s.label} className="bg-[#f8f5f4] rounded-xl p-4 border border-[#ebe5e4]">
                <span className={`material-symbols-outlined text-2xl ${s.color} mb-2 block`} style={{ fontVariationSettings: "'FILL' 1" }}>{s.icon}</span>
                <p className="text-xl font-bold text-[#1c1b1b] font-sans">{s.value}</p>
                <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.08em] font-sans mt-0.5">{s.label}</p>
              </div>
            ))}
          </div>

          {/* Badge earned */}
          <div className="bg-[#fff5f4] border border-[#8B1A1A]/15 rounded-xl p-4 mb-7 flex items-center gap-4 text-left">
            <span className="material-symbols-outlined text-[#8B1A1A] text-3xl flex-shrink-0" style={{ fontVariationSettings: "'FILL' 1" }}>workspace_premium</span>
            <div>
              <p className="text-sm font-bold text-[#1c1b1b] font-sans">Emblema Desbloqueado!</p>
              <p className="text-xs text-[#5d5f5d] font-serif mt-0.5">Especialista em Moeda Colonial — Conquistou 88% ou mais neste quiz.</p>
            </div>
          </div>

          <div className="flex gap-3">
            <button
              onClick={() => navigate('/quiz')}
              className="flex-1 border border-[#ebe5e4] text-[#1c1b1b] text-sm font-semibold font-sans py-3 rounded-full hover:bg-[#f0eded] hover:border-[#d4c5c3] transition-all duration-150"
            >
              Mais Quizzes
            </button>
            <button
              onClick={() => navigate('/dashboard')}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold font-sans py-3 rounded-full hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 flex items-center justify-center gap-2"
            >
              Ir ao Dashboard
              <span className="material-symbols-outlined text-[18px]">home</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
