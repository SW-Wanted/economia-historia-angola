import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'

interface ResultState {
  score?: number
  total?: number
  quizTitle?: string
}

function ScoreRing({ pct }: { pct: number }) {
  const r = 54
  const circ = 2 * Math.PI * r
  const fill = circ * (pct / 100)
  const gap = circ - fill

  return (
    <div className="relative w-36 h-36 mx-auto mb-6">
      <svg className="w-full h-full -rotate-90" viewBox="0 0 128 128">
        <circle cx="64" cy="64" r={r} fill="none" stroke="#FFE9E6" strokeWidth="8" />
        <circle
          cx="64" cy="64" r={r} fill="none"
          stroke="#8B1A1A" strokeWidth="8"
          strokeDasharray={`${fill} ${gap}`}
          strokeLinecap="round"
          style={{ transition: 'stroke-dasharray 1s cubic-bezier(0.16,1,0.3,1)' }}
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-3xl font-extrabold text-text font-sans leading-none">{pct}%</span>
        <span className="text-[10px] text-secondary uppercase tracking-wider font-sans mt-0.5">Precisão</span>
      </div>
    </div>
  )
}

export default function ResultadoQuiz() {
  const navigate = useNavigate()
  const location = useLocation()
  const state = (location.state as ResultState | null) ?? {}

  const score = state.score ?? 0
  const total = state.total ?? 0
  const quizTitle = state.quizTitle ?? 'Quiz de História'
  const wrong = total - score
  const pct = total > 0 ? Math.round((score / total) * 100) : 0

  const result = pct >= 90 ? { label: 'Excelente!', icon: 'workspace_premium', color: 'text-gold' } :
                 pct >= 70 ? { label: 'Muito Bom!', icon: 'star', color: 'text-success' } :
                 pct >= 50 ? { label: 'Bom Progresso!', icon: 'trending_up', color: 'text-primary' } :
                              { label: 'Continue a Estudar!', icon: 'school', color: 'text-secondary' }

  return (
    <AppShell showSearch={false}>
      <div className="page-content-narrow py-12 animate-slide-up">
        <div className="card p-10 text-center">
          {/* Score ring */}
          <ScoreRing pct={pct} />

          {/* Result label */}
          <div className="flex items-center justify-center gap-2 mb-2">
            <span className={`material-symbols-outlined text-3xl ${result.color}`}
              style={{ fontVariationSettings: "'FILL' 1" }}>{result.icon}</span>
            <h1 className="text-display-lg font-bold text-text font-sans tracking-tight">{result.label}</h1>
          </div>
          <p className="text-body-md text-secondary font-body mb-8 max-w-sm mx-auto leading-relaxed">
            Completou <strong className="text-text font-sans">&ldquo;{quizTitle}&rdquo;</strong> com {score} de {total} respostas corretas.
          </p>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-3 mb-8">
            {[
              { icon: 'check_circle', label: 'Corretas', value: score, colorClass: 'text-success', bgClass: 'bg-success/8 border-success/20' },
              { icon: 'cancel', label: 'Erradas', value: wrong, colorClass: 'text-error', bgClass: 'bg-error/8 border-error/20' },
              { icon: 'quiz', label: 'Total', value: total, colorClass: 'text-primary', bgClass: 'bg-primary/8 border-primary/20' },
            ].map((s) => (
              <div key={s.label} className={`rounded-card p-4 border ${s.bgClass}`}>
                <span className={`material-symbols-outlined text-2xl ${s.colorClass} mb-2 block`}
                  style={{ fontVariationSettings: "'FILL' 1" }}>{s.icon}</span>
                <p className={`text-2xl font-bold ${s.colorClass} font-sans`}>{s.value}</p>
                <p className="text-label-md text-secondary uppercase tracking-wider font-sans mt-0.5">{s.label}</p>
              </div>
            ))}
          </div>

          {/* Achievement banner */}
          {pct >= 70 && (
            <div className="alert-info rounded-card mb-8 text-left">
              <span className="material-symbols-outlined text-primary text-2xl flex-shrink-0"
                style={{ fontVariationSettings: "'FILL' 1" }}>workspace_premium</span>
              <div>
                <p className="text-sm font-bold text-text font-sans">Conquista Desbloqueada</p>
                <p className="text-body-md text-secondary font-body mt-0.5">
                  Completou o quiz com {pct}% de precisão. Continue assim!
                </p>
              </div>
            </div>
          )}

          {/* CTA */}
          <div className="flex gap-3">
            <button onClick={() => navigate('/quiz')} className="btn-secondary flex-1 justify-center">
              <span className="material-symbols-outlined text-[18px]">quiz</span>
              Mais Quizzes
            </button>
            <button onClick={() => navigate('/dashboard')} className="btn-primary flex-1 justify-center">
              <span className="material-symbols-outlined text-[18px]">home</span>
              Dashboard
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
