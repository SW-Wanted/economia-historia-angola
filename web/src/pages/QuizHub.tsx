import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { quizService } from '../services/api/quiz.service'
import { extractList } from '../services/types/api.types'
import { useAuth } from '../contexts/AuthContext'
import type { Quiz, RankingEntry, PaginatedResponse } from '../services/types/api.types'

const FILTERS = ['Todos', 'Colonialismo', 'Pós-Independência', 'Comércio Atlântico']

function getLevelFromCount(count: number): { label: string; color: string } {
  if (count <= 8) return { label: 'Iniciante', color: 'bg-emerald-50 text-emerald-700 border border-emerald-200' }
  if (count <= 12) return { label: 'Intermédio', color: 'bg-amber-50 text-amber-700 border border-amber-200' }
  return { label: 'Especialista', color: 'bg-red-50 text-red-700 border border-red-200' }
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
        const [quizRes, rankRes] = await Promise.allSettled([
          quizService.list(),
          quizService.getRankings(),
        ])
        if (quizRes.status === 'fulfilled') {
          setQuizzes(extractList(quizRes.value as Quiz[] | PaginatedResponse<Quiz>))
        }
        if (rankRes.status === 'fulfilled') {
          setRankings(extractList(rankRes.value as RankingEntry[] | PaginatedResponse<RankingEntry>))
        }
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

  // User's ranking entry
  const myRank = rankings.find((r) => r.userId === user?.id)
  const completedCount = myRank?.attempts ?? 0
  const rankPosition = myRank?.rank ?? rankings.length + 1

  return (
    <AppShell searchPlaceholder="Pesquisar arquivo histórico...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        {/* Featured banner */}
        <section className="relative bg-[#8b1a1a] rounded-2xl overflow-hidden mb-12 flex items-center min-h-[340px] shadow-lg">
          <div className="w-full md:w-1/2 p-10 relative z-10">
            <span className="inline-block bg-white/15 text-white/90 px-4 py-1 rounded-full text-[10px] font-bold font-sans mb-5 uppercase tracking-[0.1em] border border-white/20">
              Quiz da Semana
            </span>
            {featured ? (
              <>
                <h2 className="text-[36px] font-extrabold text-white mb-4 leading-tight font-sans tracking-tight">{featured.title}</h2>
                {featured.description && (
                  <p className="text-sm text-white/80 mb-7 max-w-md font-serif leading-relaxed">{featured.description}</p>
                )}
                <div className="flex items-center gap-5">
                  <button
                    onClick={() => navigate('/quiz/em-curso', { state: { quizId: featured.id } })}
                    className="bg-white text-[#8B1A1A] px-7 py-3 rounded-full text-sm font-bold font-sans flex items-center gap-2 hover:-translate-y-0.5 hover:shadow-md transition-all duration-150"
                  >
                    Começar Agora
                    <span className="material-symbols-outlined text-[18px]">play_arrow</span>
                  </button>
                  {featured._count && (
                    <div className="flex items-center gap-2 text-white/80 text-sm font-sans">
                      <span className="material-symbols-outlined text-[18px]">quiz</span>
                      {featured._count.questions} questões
                    </div>
                  )}
                </div>
              </>
            ) : (
              <p className="text-white/80 font-serif">A carregar quiz da semana...</p>
            )}
          </div>
          <div className="hidden md:flex w-1/2 h-full absolute right-0 top-0 items-center justify-center pointer-events-none">
            <span className="material-symbols-outlined text-white/8" style={{ fontSize: '260px' }}>quiz</span>
          </div>
        </section>

        {/* Thematic quizzes */}
        <section>
          <div className="flex items-end justify-between mb-7">
            <div>
              <h3 className="text-xl font-bold text-[#1c1b1b] font-sans">Explorar Quizzes Temáticos</h3>
              <p className="text-sm text-[#5d5f5d] font-serif mt-0.5">Aprofunde os seus conhecimentos por período histórico ou tema económico.</p>
            </div>
            <div className="flex gap-1.5">
              {FILTERS.map((f) => (
                <button
                  key={f}
                  onClick={() => setActiveFilter(f)}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-semibold font-sans transition-all duration-150 ${
                    activeFilter === f
                      ? 'bg-[#8B1A1A] text-white shadow-xs'
                      : 'bg-[#f0eded] text-[#5d5f5d] hover:bg-[#e8e2e1] hover:text-[#1c1b1b]'
                  }`}
                >
                  {f}
                </button>
              ))}
            </div>
          </div>

          {loading ? (
            <div className="grid grid-cols-12 gap-5">
              {Array.from({ length: 4 }).map((_, i) => (
                <div key={i} className="col-span-12 md:col-span-4 bg-white rounded-xl h-52 border border-[#ebe5e4] animate-pulse" />
              ))}
            </div>
          ) : error ? (
            <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
              <p className="text-sm text-red-700 font-sans">{error}</p>
            </div>
          ) : filtered.length === 0 ? (
            <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
              <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">quiz</span>
              <p className="text-sm text-[#5d5f5d] font-serif">Nenhum quiz disponível para este filtro.</p>
            </div>
          ) : (
            <div className="grid grid-cols-12 gap-5">
              {filtered.map((quiz) => {
                const qCount = quiz._count?.questions ?? 0
                const level = getLevelFromCount(qCount)
                return (
                  <div
                    key={quiz.id}
                    onClick={() => navigate('/quiz/em-curso', { state: { quizId: quiz.id } })}
                    className="col-span-12 md:col-span-4 bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 flex flex-col group cursor-pointer"
                  >
                    <div className="h-36 relative bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center overflow-hidden">
                      <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '64px' }}>quiz</span>
                      <span className={`absolute top-3 left-3 px-2.5 py-1 rounded-full text-xs font-bold font-sans ${level.color}`}>{level.label}</span>
                    </div>
                    <div className="p-5 flex-grow flex flex-col">
                      <h4 className="text-base font-semibold text-[#1c1b1b] mb-2 font-sans leading-snug">{quiz.title}</h4>
                      {quiz.description && <p className="text-sm text-[#5d5f5d] mb-5 flex-grow font-serif leading-relaxed line-clamp-2">{quiz.description}</p>}
                      <div className="flex items-center justify-between mt-auto">
                        <span className="text-xs text-[#8c716e] font-sans">{qCount} Questões</span>
                        <span className="text-[#8B1A1A] font-bold text-sm font-sans flex items-center gap-1">
                          Participar <span className="material-symbols-outlined text-[16px]">chevron_right</span>
                        </span>
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          )}
        </section>

        {/* Stats */}
        <section className="mt-10 bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card flex gap-10 items-center">
          <div className="w-1/3">
            <h3 className="text-lg font-bold text-[#1c1b1b] mb-1 font-sans">A Sua Jornada</h3>
            <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">{firstName}, o seu progresso como Investigador continua a crescer.</p>
          </div>
          <div className="flex flex-grow justify-between border-l border-[#ebe5e4] pl-10">
            {[
              { value: String(completedCount), label: 'Quizzes Concluídos' },
              { value: myRank ? `${Math.round((myRank.score / Math.max(completedCount, 1)))}` : '—', label: 'Pontuação Média' },
              { value: String(quizzes.length), label: 'Quizzes Disponíveis' },
              { value: myRank?.rank ? `#${myRank.rank}` : '—', label: 'Ranking Geral' },
            ].map((stat) => (
              <div key={stat.label} className="text-center">
                <p className="text-[36px] text-[#8B1A1A] font-extrabold leading-none font-sans mb-1">{stat.value}</p>
                <p className="text-[10px] text-[#8c716e] uppercase tracking-[0.08em] font-sans">{stat.label}</p>
              </div>
            ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
