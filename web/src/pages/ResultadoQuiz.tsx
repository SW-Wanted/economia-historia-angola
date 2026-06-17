import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function ResultadoQuiz() {
  const navigate = useNavigate()

  return (
    <AppShell title="Resultado do Quiz" showSearch={false}>
      <div className="px-10 py-16 max-w-[700px] mx-auto text-center">
        <div className="bg-white rounded-xl p-12 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          {/* Score circle */}
          <div className="w-32 h-32 rounded-full bg-[#8B1A1A] flex flex-col items-center justify-center mx-auto mb-8">
            <span className="text-[40px] font-extrabold text-white">88%</span>
            <span className="text-xs text-white/80 uppercase tracking-wider">Precisão</span>
          </div>

          <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-2">Excelente Resultado!</h1>
          <p className="text-lg text-[#5d5f5d] mb-8" style={{ fontFamily: 'Merriweather, serif' }}>
            Completou o quiz "A Evolução da Moeda Colonial" com 88% de precisão. Ganhou 150 pontos de mérito!
          </p>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-4 mb-10">
            {[
              { icon: 'check_circle', label: 'Corretas', value: '8', color: 'text-green-600' },
              { icon: 'cancel', label: 'Erradas', value: '1', color: 'text-red-500' },
              { icon: 'timer', label: 'Tempo', value: '7:23', color: 'text-[#8B1A1A]' },
            ].map((s) => (
              <div key={s.label} className="bg-[#f6f3f2] rounded-xl p-4">
                <span className={`material-symbols-outlined text-3xl ${s.color} mb-1`} style={{ fontVariationSettings: "'FILL' 1" }}>{s.icon}</span>
                <p className="text-2xl font-bold text-[#1c1b1b]">{s.value}</p>
                <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
              </div>
            ))}
          </div>

          {/* Badge earned */}
          <div className="bg-[#8B1A1A]/5 border border-[#8B1A1A]/20 rounded-xl p-4 mb-8 flex items-center gap-4">
            <span className="material-symbols-outlined text-[#8B1A1A] text-4xl" style={{ fontVariationSettings: "'FILL' 1" }}>workspace_premium</span>
            <div className="text-left">
              <p className="text-sm font-bold text-[#1c1b1b]">Emblema Desbloqueado!</p>
              <p className="text-xs text-[#5d5f5d]">Especialista em Moeda Colonial — Conquistou 88% ou mais neste quiz.</p>
            </div>
          </div>

          <div className="flex gap-4">
            <button
              onClick={() => navigate('/quiz')}
              className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
            >
              Mais Quizzes
            </button>
            <button
              onClick={() => navigate('/dashboard')}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all flex items-center justify-center gap-2"
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
