import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth } from '../contexts/AuthContext'
import { userService } from '../services/api/user.service'
import { quizService } from '../services/api/quiz.service'
import { extractList } from '../services/types/api.types'
import type { Progress, RankingEntry, PaginatedResponse } from '../services/types/api.types'

const tabs = ['Visão Geral', 'Leituras', 'Quizzes']

const TYPE_LABELS: Record<string, string> = {
  VIDEO: 'Vídeo', PODCAST: 'Podcast', TEXT: 'Texto',
  MICROTEXT: 'Microtexto', PDF: 'Documento', ARTICLE: 'Jindungo', AUDIO: 'Áudio',
}

function getContentRoute(type: string): string {
  if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
  if (type === 'PDF') return '/documento/detalhe'
  if (type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

export default function PainelEstatisticas() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [activeTab, setActiveTab] = useState('Visão Geral')
  const [progress, setProgress] = useState<Progress[]>([])
  const [loading, setLoading] = useState(true)
  const [rankings, setRankings] = useState<RankingEntry[]>([])
  const [rankingsLoading, setRankingsLoading] = useState(true)
  const [myRank, setMyRank] = useState<RankingEntry | null>(null)

  useEffect(() => {
    userService.getMyProgress()
      .then((data) => setProgress(Array.isArray(data) ? data : []))
      .catch(() => setProgress([]))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    quizService.getRankings()
      .then((data) => {
        const list = extractList(data as RankingEntry[] | PaginatedResponse<RankingEntry>)
        setRankings(list)
        if (user) {
          setMyRank(list.find((r) => r.userId === user.id) ?? null)
        }
      })
      .catch(() => {})
      .finally(() => setRankingsLoading(false))
  }, [user])

  const completed = progress.filter((p) => p.completedAt || p.percentage === 100)
  const inProgress = progress.filter((p) => !p.completedAt && p.percentage > 0 && p.percentage < 100)

  return (
    <AppShell title="Painel de Estatísticas" showSearch={false}>
      <div className="page-content animate-fade-in">
        <div className="mb-8">
          <h2 className="text-display-web font-extrabold text-text font-sans tracking-tight mb-2">As Suas Estatísticas</h2>
          <p className="text-body-md font-body text-secondary leading-relaxed">
            Acompanhe o seu progresso e impacto na plataforma.
          </p>
        </div>

        {/* Tabs */}
        <div className="border-b border-outline-variant/40 mb-8">
          <div className="flex gap-6">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3.5 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab ? 'border-primary text-primary' : 'border-transparent text-secondary hover:text-text'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {activeTab === 'Visão Geral' && (
          <>
            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-5 mb-8">
              {[
                {
                  icon: 'stars',
                  value: rankingsLoading ? '…' : String(myRank?.score ?? 0),
                  label: 'Pontos de Mérito',
                  sub: myRank?.rank ? `Posição #${myRank.rank} no ranking` : undefined,
                },
                {
                  icon: 'library_books',
                  value: loading ? '…' : String(completed.length),
                  label: 'Artigos Lidos',
                  sub: undefined,
                },
                {
                  icon: 'quiz',
                  value: rankingsLoading ? '…' : String(myRank?.attempts ?? 0),
                  label: 'Quizzes Feitos',
                  sub: myRank?.attempts ? `${myRank.attempts} quiz${myRank.attempts !== 1 ? 'zes' : ''} completo${myRank.attempts !== 1 ? 's' : ''}` : undefined,
                },
                {
                  icon: 'forum',
                  value: String(progress.length),
                  label: 'Conteúdos Iniciados',
                  sub: undefined,
                },
              ].map((s) => (
                <div key={s.label} className="card p-6 text-center">
                  <span className="w-9 h-9 rounded-lg bg-surface-container flex items-center justify-center mx-auto mb-4">
                    <span className="material-symbols-outlined text-primary text-[20px]"
                      style={{ fontVariationSettings: "'FILL' 1" }}>{s.icon}</span>
                  </span>
                  <p className="text-[36px] font-extrabold text-text leading-none font-sans mb-1">{s.value}</p>
                  <p className="text-label-md text-text-muted uppercase tracking-[0.08em] font-sans">{s.label}</p>
                  {s.sub && <p className="text-[11px] text-secondary font-body mt-1">{s.sub}</p>}
                </div>
              ))}
            </div>

            {/* Reading progress */}
            <div className="card p-7 mb-5">
              <h3 className="text-base font-bold text-text mb-6 font-sans">Leituras em Curso</h3>
              {loading ? (
                <div className="space-y-4">
                  {[0, 1, 2].map((i) => (
                    <div key={i} className="h-10 bg-surface-container rounded-lg animate-pulse" />
                  ))}
                </div>
              ) : inProgress.length === 0 ? (
                <div className="text-center py-6">
                  <span className="material-symbols-outlined text-primary/20 text-4xl mb-2 block">auto_stories</span>
                  <p className="text-body-md font-body text-secondary">Nenhuma leitura em curso. Explore o arquivo para começar.</p>
                  <button onClick={() => navigate('/explorar')} className="mt-3 text-sm font-semibold text-primary font-sans hover:underline">
                    Explorar conteúdos →
                  </button>
                </div>
              ) : (
                <div className="space-y-5">
                  {inProgress.slice(0, 5).map((p) => (
                    <div key={p.id}>
                      <div className="flex justify-between items-center mb-1.5">
                        <span className="text-sm font-semibold text-text font-sans truncate max-w-[70%]">{p.content.title}</span>
                        <span className="text-xs text-text-muted font-sans flex-shrink-0 ml-2">{TYPE_LABELS[p.content.type] ?? p.content.type}</span>
                      </div>
                      <div className="w-full bg-surface-container h-1.5 rounded-full">
                        <div className="bg-primary h-1.5 rounded-full transition-all" style={{ width: `${p.percentage}%` }} />
                      </div>
                      <span className="text-xs text-primary font-semibold font-sans mt-1 block">{p.percentage}%</span>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {[
                { icon: 'explore', label: 'Continuar a Ler', route: '/explorar', desc: 'Retome onde parou' },
                { icon: 'quiz', label: 'Fazer Quiz', route: '/quiz', desc: 'Teste os seus conhecimentos' },
                { icon: 'forum', label: 'Ver Fórum', route: '/forum', desc: 'Participe nas discussões' },
              ].map((a) => (
                <button
                  key={a.label}
                  onClick={() => navigate(a.route)}
                  className="bg-surface rounded-card p-5 border border-outline-variant/45 shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 text-left flex items-center gap-4"
                >
                  <div className="w-10 h-10 bg-surface-container rounded-xl flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-primary text-[22px]">{a.icon}</span>
                  </div>
                  <div>
                    <p className="text-sm font-bold text-text font-sans">{a.label}</p>
                    <p className="text-xs text-text-muted font-body">{a.desc}</p>
                  </div>
                </button>
              ))}
            </div>
          </>
        )}

        {activeTab === 'Leituras' && (
          <div className="space-y-3">
            {loading ? (
              <div className="space-y-3">
                {[0, 1, 2, 3].map((i) => (
                  <div key={i} className="h-20 bg-surface border border-outline-variant/45 rounded-card animate-pulse" />
                ))}
              </div>
            ) : progress.length === 0 ? (
              <div className="bg-surface rounded-card border border-outline-variant/45 p-10 text-center">
                <span className="material-symbols-outlined text-primary/20 text-5xl mb-3 block">library_books</span>
                <p className="text-body-md font-body text-secondary">Ainda não iniciou nenhuma leitura.</p>
                <button onClick={() => navigate('/explorar')} className="mt-4 text-sm font-semibold text-primary font-sans hover:underline">
                  Explorar conteúdos →
                </button>
              </div>
            ) : (
              <>
                {progress.map((item) => (
                  <div
                    key={item.id}
                    onClick={() => navigate(getContentRoute(item.content.type), { state: { contentId: item.contentId } })}
                    className="bg-surface rounded-card p-4 border border-outline-variant/45 shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex items-center gap-4"
                  >
                    <div className="w-9 h-9 bg-surface-container rounded-lg flex items-center justify-center flex-shrink-0">
                      <span className="material-symbols-outlined text-primary text-[18px]">article</span>
                    </div>
                    <div className="flex-grow min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <span className="text-[10px] font-bold text-primary bg-surface-container px-2 py-0.5 rounded-full font-sans">
                          {TYPE_LABELS[item.content.type] ?? item.content.type}
                        </span>
                        {item.completedAt && (
                          <span className="text-[10px] font-bold text-success font-sans">✓ Concluído</span>
                        )}
                      </div>
                      <h4 className="text-sm font-semibold text-text font-sans leading-snug truncate">{item.content.title}</h4>
                      <div className="w-full bg-surface-container h-1.5 rounded-full mt-2">
                        <div className="bg-primary h-1.5 rounded-full" style={{ width: `${item.percentage}%` }} />
                      </div>
                    </div>
                    <span className="text-xs font-bold text-primary font-sans flex-shrink-0">{item.percentage}%</span>
                  </div>
                ))}
                <button
                  onClick={() => navigate('/biblioteca')}
                  className="w-full py-3 text-sm font-semibold text-primary hover:text-primary-dark transition-colors duration-150 font-sans"
                >
                  Ver toda a biblioteca →
                </button>
              </>
            )}
          </div>
        )}

        {activeTab === 'Quizzes' && (
          rankingsLoading ? (
            <div className="space-y-3">
              {[0, 1, 2, 3, 4].map((i) => (
                <div key={i} className="h-14 bg-surface border border-outline-variant/45 rounded-card animate-pulse" />
              ))}
            </div>
          ) : (
            <>
              {/* User's rank card */}
              {myRank && (
                <div className="card p-6 mb-6 bg-primary border-primary">
                  <p className="text-label-md uppercase tracking-wider text-white/60 font-sans mb-3">A sua posição</p>
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 rounded-full bg-white/15 flex items-center justify-center text-white font-bold text-lg font-sans flex-shrink-0">
                      #{myRank.rank ?? '—'}
                    </div>
                    <div className="flex-1">
                      <p className="text-white font-bold font-sans">{myRank.user.name}</p>
                      <p className="text-white/60 text-sm font-body">{myRank.attempts} quiz{myRank.attempts !== 1 ? 'zes' : ''} · {myRank.score} pontos</p>
                    </div>
                    <div className="text-right">
                      <p className="text-[28px] font-extrabold text-white font-sans leading-none">{myRank.score}</p>
                      <p className="text-white/60 text-[11px] font-body">pontos</p>
                    </div>
                  </div>
                </div>
              )}

              {/* Full ranking */}
              <div className="card overflow-hidden">
                <div className="px-5 py-4 border-b border-outline-variant/20 flex items-center gap-2">
                  <span className="material-symbols-outlined text-primary text-[20px]"
                    style={{ fontVariationSettings: "'FILL' 1" }}>emoji_events</span>
                  <h3 className="text-base font-bold text-text font-sans">Ranking Global de Quizzes</h3>
                  <span className="ml-auto text-[11px] text-secondary font-body">{rankings.length} participantes</span>
                </div>
                {rankings.length === 0 ? (
                  <div className="p-10 text-center">
                    <span className="material-symbols-outlined text-primary/20 text-5xl mb-3 block">quiz</span>
                    <p className="text-body-md font-body text-secondary mb-5">Ainda não há entradas no ranking. Seja o primeiro!</p>
                    <button onClick={() => navigate('/quiz')} className="btn-primary mx-auto">
                      Fazer um Quiz
                    </button>
                  </div>
                ) : (
                  <div className="divide-y divide-outline-variant/20">
                    {rankings.slice(0, 20).map((entry, idx) => {
                      const isMe = user && entry.userId === user.id
                      const medal = idx === 0 ? '🥇' : idx === 1 ? '🥈' : idx === 2 ? '🥉' : null
                      return (
                        <div
                          key={entry.id}
                          className={`flex items-center gap-4 px-5 py-3.5 transition-colors ${isMe ? 'bg-primary/4' : 'hover:bg-surface-container-low/50'}`}
                        >
                          <div className={`w-8 text-center text-sm font-bold font-sans flex-shrink-0 ${isMe ? 'text-primary' : 'text-secondary'}`}>
                            {medal ?? `#${entry.rank ?? idx + 1}`}
                          </div>
                          <div className="w-8 h-8 rounded-full bg-surface-container border border-outline-variant/40 flex items-center justify-center flex-shrink-0 overflow-hidden">
                            {entry.user.avatarUrl ? (
                              <img src={entry.user.avatarUrl} alt={entry.user.name} className="w-full h-full object-cover" />
                            ) : (
                              <span className="text-[9px] font-bold text-primary font-sans">
                                {entry.user.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
                              </span>
                            )}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className={`text-sm font-semibold font-sans truncate ${isMe ? 'text-primary' : 'text-text'}`}>
                              {entry.user.name} {isMe && <span className="text-[10px] text-primary/60">(Eu)</span>}
                            </p>
                            <p className="text-[11px] text-secondary font-body">{entry.attempts} quiz{entry.attempts !== 1 ? 'zes' : ''}</p>
                          </div>
                          <div className="text-right flex-shrink-0">
                            <p className={`text-sm font-bold font-sans ${isMe ? 'text-primary' : 'text-text'}`}>{entry.score}</p>
                            <p className="text-[10px] text-secondary font-body">pts</p>
                          </div>
                        </div>
                      )
                    })}
                  </div>
                )}
              </div>

              <div className="mt-5 text-center">
                <button onClick={() => navigate('/quiz')} className="btn-primary mx-auto">
                  <span className="material-symbols-outlined text-[18px]">quiz</span>
                  Fazer um Quiz
                </button>
              </div>
            </>
          )
        )}
      </div>
    </AppShell>
  )
}
