import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { quizService } from '../services/api/quiz.service'
import { extractList } from '../services/types/api.types'
import { useAuth } from '../contexts/AuthContext'
import type { Quiz, RankingEntry, PaginatedResponse } from '../services/types/api.types'

const FILTERS = ['Todos', 'Colonialismo', 'Pós-Independência', 'Comércio Atlântico']

type Level = 'Iniciante' | 'Intermédio' | 'Especialista'

function getLevel(count: number): Level {
  if (count <= 8) return 'Iniciante'
  if (count <= 12) return 'Intermédio'
  return 'Especialista'
}

const LEVEL_CONFIG: Record<Level, { badge: string; bg: string; dot: string }> = {
  Iniciante:   { badge: 'badge-success', bg: 'from-success/10 to-success/5',   dot: 'bg-success' },
  Intermédio:  { badge: 'badge-warning', bg: 'from-warning/10 to-warning/5',    dot: 'bg-warning' },
  Especialista:{ badge: 'badge-primary', bg: 'from-primary/10 to-primary/5',   dot: 'bg-primary' },
}

export default function QuizHub() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [activeFilter, setActiveFilter] = useState('Todos')
  const [quizzes, setQuizzes] = useState<Quiz[]>([])
  const [rankings, setRankings] = useState<RankingEntry[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const firstName = user?.name?.split(' ')[0] ?? 'Investigador'

  useEffect(() => {
    async function load() {
      setLoading(true)
      setError('')
      try {
        const [quizRes, rankRes] = await Promise.allSettled([quizService.list(), quizService.getRankings()])
        if (quizRes.status === 'fulfilled') setQuizzes(extractList(quizRes.value as Quiz[] | PaginatedResponse<Quiz>))
        if (rankRes.status === 'fulfilled') setRankings(extractList(rankRes.value as RankingEntry[] | PaginatedResponse<RankingEntry>))
      } catch {
        setError('Não foi possível carregar os quizzes.')
      } finally {
        setLoading(false)
      }
    }
    load()
  }, [])

  const filtered = activeFilter === 'Todos'
    ? quizzes
    : quizzes.filter((q) =>
        q.category?.name?.toLowerCase()?.includes(activeFilter.toLowerCase()) ||
        q.description?.toLowerCase()?.includes(activeFilter.toLowerCase())
      )

  const featured = quizzes[0]
  const myRank = rankings.find((r) => r.userId === user?.id)
  const completedCount = myRank?.attempts ?? 0
  const topRankings = rankings.slice(0, 5)

  return (
    <AppShell searchPlaceholder="Pesquisar quizzes...">
      <div className="page-content animate-fade-in">

        {/* Hero banner */}
        <section className="relative rounded-2xl overflow-hidden mb-10 min-h-[260px] flex items-center"
          style={{ background: 'linear-gradient(135deg, #8B1A1A 0%, #5A1010 60%, #3A0808 100%)' }}>
          <div className="absolute top-0 right-0 w-96 h-96 rounded-full opacity-[0.06]"
            style={{ background: 'radial-gradient(circle, white 0%, transparent 70%)', transform: 'translate(35%, -40%)' }} />
          <div className="absolute inset-0 opacity-[0.025]"
            style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '24px 24px' }} />

          <div className="relative z-10 px-10 py-8 flex-1">
            <span className="inline-flex items-center gap-1.5 bg-white/12 text-white/85 px-3 py-1 rounded-full text-[11px] font-bold font-sans mb-4 border border-white/15 uppercase tracking-wider">
              <span className="material-symbols-outlined text-[14px]" style={{ fontVariationSettings: "'FILL' 1" }}>stars</span>
              Quiz da Semana
            </span>
            {featured ? (
              <>
                <h2 className="text-display-web font-extrabold text-white font-sans tracking-tight leading-tight mb-3">
                  {featured.title}
                </h2>
                {featured.description && (
                  <p className="text-body-lg text-white/65 mb-7 max-w-lg font-body leading-relaxed">{featured.description}</p>
                )}
                <div className="flex items-center gap-5">
                  <button
                    onClick={() => navigate('/quiz/em-curso', { state: { quizId: featured.id } })}
                    className="btn-white shadow-lg"
                  >
                    <span className="material-symbols-outlined text-[18px]" style={{ fontVariationSettings: "'FILL' 1" }}>play_arrow</span>
                    Começar Agora
                  </button>
                  {featured._count && (
                    <span className="text-white/60 text-sm font-body flex items-center gap-1.5">
                      <span className="material-symbols-outlined text-[16px]">quiz</span>
                      {featured._count.questions} questões
                    </span>
                  )}
                </div>
              </>
            ) : (
              <p className="text-white/60 font-body">A carregar quiz da semana...</p>
            )}
          </div>

          {/* Decorative quiz icon */}
          <div className="hidden lg:block absolute right-12 top-1/2 -translate-y-1/2 pointer-events-none">
            <span className="material-symbols-outlined text-white/6" style={{ fontSize: '200px' }}>quiz</span>
          </div>
        </section>

        {/* My journey */}
        <section className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
          {[
            { icon: 'check_circle', label: 'Concluídos', value: String(completedCount), filled: true },
            { icon: 'grade', label: 'Pontuação Média', value: myRank && completedCount > 0 ? String(Math.round(myRank.score / completedCount)) : '—', filled: true },
            { icon: 'quiz', label: 'Disponíveis', value: String(quizzes.length), filled: false },
            { icon: 'leaderboard', label: 'Ranking', value: myRank?.rank ? `#${myRank.rank}` : '—', filled: true },
          ].map((s) => (
            <div key={s.label} className="card p-5">
              <div className="w-9 h-9 rounded-xl bg-primary/8 flex items-center justify-center mb-3">
                <span className="material-symbols-outlined text-primary text-[20px]"
                  style={s.filled ? { fontVariationSettings: "'FILL' 1" } : undefined}>{s.icon}</span>
              </div>
              <p className="text-display-lg font-bold text-text font-sans leading-none mb-1">{s.value}</p>
              <p className="text-label-md uppercase tracking-wider text-secondary font-sans">{s.label}</p>
            </div>
          ))}
        </section>

        {/* Quizzes section */}
        <div className="grid grid-cols-12 gap-8">
          {/* Quiz grid — 8 cols */}
          <div className="col-span-12 lg:col-span-8">
            <div className="section-header">
              <div>
                <h2 className="section-title">Quizzes Temáticos</h2>
                <p className="section-subtitle">Teste os seus conhecimentos por período histórico.</p>
              </div>
              <div className="flex gap-1.5">
                {FILTERS.map((f) => (
                  <button
                    key={f}
                    onClick={() => setActiveFilter(f)}
                    className={`px-3 py-1.5 rounded-full text-xs font-semibold font-sans transition-all duration-150 ${
                      activeFilter === f
                        ? 'bg-primary text-white shadow-xs'
                        : 'bg-surface-container-low text-secondary hover:bg-surface-container hover:text-text'
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>
            </div>

            {loading ? (
              <div className="grid grid-cols-2 gap-4">
                {[0, 1, 2, 3].map((i) => <div key={i} className="skeleton h-52 rounded-card" />)}
              </div>
            ) : error ? (
              <div className="alert-error rounded-card p-6">
                <p className="text-sm text-error font-body">{error}</p>
              </div>
            ) : filtered.length === 0 ? (
              <div className="empty-state">
                <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
                  <span className="material-symbols-outlined text-primary/40 text-[30px]">quiz</span>
                </div>
                <p className="text-headline-md font-bold text-text font-sans">Sem quizzes neste filtro</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 gap-4">
                {filtered.map((quiz) => {
                  const qCount = quiz._count?.questions ?? 0
                  const level = getLevel(qCount)
                  const cfg = LEVEL_CONFIG[level]
                  return (
                    <div
                      key={quiz.id}
                      onClick={() => navigate('/quiz/em-curso', { state: { quizId: quiz.id } })}
                      className="content-card group"
                    >
                      <div className={`h-32 relative bg-gradient-to-br ${cfg.bg} flex items-center justify-center overflow-hidden`}>
                        <span className="material-symbols-outlined text-primary/15 group-hover:scale-105 transition-transform duration-300"
                          style={{ fontSize: '60px' }}>quiz</span>
                        <span className={`absolute top-3 left-3 ${cfg.badge} badge`}>{level}</span>
                        <div className={`absolute bottom-3 right-3 w-2 h-2 rounded-full ${cfg.dot} opacity-60`} />
                      </div>
                      <div className="p-5 flex-grow flex flex-col">
                        <h4 className="text-title-lg font-semibold text-text font-sans mb-2 group-hover:text-primary transition-colors duration-150 leading-snug">
                          {quiz.title}
                        </h4>
                        {quiz.description && (
                          <p className="text-body-md text-secondary font-body flex-grow leading-relaxed line-clamp-2 mb-4">{quiz.description}</p>
                        )}
                        <div className="flex items-center justify-between mt-auto pt-3 border-t border-outline-variant/20">
                          <span className="text-[12px] text-secondary font-body">{qCount} questões</span>
                          <span className="text-sm font-semibold text-primary font-sans flex items-center gap-1">
                            Participar <span className="material-symbols-outlined text-[16px]">chevron_right</span>
                          </span>
                        </div>
                      </div>
                    </div>
                  )
                })}
              </div>
            )}
          </div>

          {/* Ranking sidebar — 4 cols */}
          <div className="col-span-12 lg:col-span-4">
            <div className="section-header">
              <h2 className="section-title">Classificação</h2>
            </div>
            <div className="card p-5">
              {topRankings.length === 0 ? (
                <div className="text-center py-8">
                  <span className="material-symbols-outlined text-primary/25 text-[40px] mb-2 block"
                    style={{ fontVariationSettings: "'FILL' 1" }}>leaderboard</span>
                  <p className="text-sm text-secondary font-body">Seja o primeiro a aparecer no ranking!</p>
                </div>
              ) : (
                <div className="flex flex-col divide-y divide-outline-variant/20">
                  {topRankings.map((entry, i) => {
                    const isMe = entry.userId === user?.id
                    const medals = ['🥇', '🥈', '🥉']
                    return (
                      <div key={entry.userId} className={`flex items-center gap-3 py-3 first:pt-0 last:pb-0 ${isMe ? 'text-primary' : ''}`}>
                        <span className="text-base font-bold font-sans w-6 text-center flex-shrink-0">
                          {i < 3 ? medals[i] : <span className="text-secondary text-sm">#{i + 1}</span>}
                        </span>
                        <div className="w-7 h-7 rounded-full bg-surface-container border border-outline-variant/40 flex items-center justify-center flex-shrink-0">
                          <span className="text-[9px] font-bold text-primary font-sans leading-none">
                            {entry.user?.name?.split(' ').map((n: string) => n[0]).slice(0, 2).join('').toUpperCase() ?? '?'}
                          </span>
                        </div>
                        <span className={`flex-1 text-sm font-medium font-sans truncate ${isMe ? 'font-bold' : 'text-text'}`}>
                          {isMe ? `${entry.user?.name ?? 'Você'} (Você)` : entry.user?.name ?? `Utilizador #${i + 1}`}
                        </span>
                        <span className={`text-sm font-bold font-sans flex-shrink-0 ${isMe ? 'text-primary' : 'text-secondary'}`}>
                          {entry.score}
                        </span>
                      </div>
                    )
                  })}
                </div>
              )}

              <div className="mt-5 pt-4 border-t border-outline-variant/20">
                <p className="text-[11px] text-secondary font-body text-center">
                  {firstName}, complete mais quizzes para subir no ranking.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
