import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth } from '../contexts/AuthContext'
import { userService } from '../services/api/user.service'
import { quizService } from '../services/api/quiz.service'
import { extractList } from '../services/types/api.types'
import type { Progress, RankingEntry, PaginatedResponse } from '../services/types/api.types'

function getContentTypeRoute(type: string): string {
  if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
  if (type === 'PDF') return '/documento/detalhe'
  return type === 'ARTICLE' ? '/leitura/jindungo' : '/leitura/microtexto'
}

const quickActions = [
  { icon: 'explore',      label: 'Explorar Arquivo',   sub: 'Artigos, análises, documentos', route: '/explorar' },
  { icon: 'quiz',         label: 'Quizzes',             sub: 'Teste os seus conhecimentos',   route: '/quiz' },
  { icon: 'map',          label: 'Mapa Económico',      sub: 'Províncias e períodos',         route: '/mapa' },
  { icon: 'forum',        label: 'Comunidade',          sub: 'Debater com investigadores',    route: '/forum' },
]

export default function Dashboard() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [progress, setProgress] = useState<Progress[]>([])
  const [loadingProgress, setLoadingProgress] = useState(true)
  const [myRank, setMyRank] = useState<RankingEntry | null>(null)

  const firstName = user?.name?.split(' ')[0] ?? 'Investigador'
  const hour = new Date().getHours()
  const greeting = hour < 12 ? 'Bom dia' : hour < 18 ? 'Boa tarde' : 'Boa noite'

  useEffect(() => {
    userService.getMyProgress()
      .then((data) => setProgress(Array.isArray(data) ? data.slice(0, 4) : []))
      .catch(() => setProgress([]))
      .finally(() => setLoadingProgress(false))
  }, [])

  useEffect(() => {
    if (!user) return
    quizService.getRankings()
      .then((data) => {
        const list = extractList(data as RankingEntry[] | PaginatedResponse<RankingEntry>)
        const entry = list.find((r) => r.userId === user.id) ?? null
        setMyRank(entry)
      })
      .catch(() => {})
  }, [user])

  const completed = progress.filter((p) => p.completedAt)
  const inProgress = progress.filter((p) => !p.completedAt && p.percentage > 0)

  return (
    <AppShell searchPlaceholder="Pesquisar arquivo histórico...">
      <div className="page-content animate-fade-in">

        {/* Hero welcome */}
        <div className="relative rounded-2xl overflow-hidden mb-10 min-h-[200px] flex items-end"
          style={{ background: 'linear-gradient(135deg, #8B1A1A 0%, #5A1010 60%, #3A0808 100%)' }}
        >
          <div className="absolute top-0 right-0 w-80 h-80 rounded-full opacity-[0.07]"
            style={{ background: 'radial-gradient(circle, white 0%, transparent 70%)', transform: 'translate(30%, -30%)' }} />
          <div className="absolute bottom-0 left-1/3 w-64 h-64 rounded-full opacity-[0.05]"
            style={{ background: 'radial-gradient(circle, white 0%, transparent 70%)', transform: 'translate(-50%, 50%)' }} />
          <div className="absolute inset-0 opacity-[0.03]"
            style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '28px 28px' }} />

          <div className="relative z-10 px-10 py-8 flex items-end justify-between w-full">
            <div>
              <p className="text-white/60 text-sm font-body mb-1">{greeting},</p>
              <h1 className="text-display-web font-extrabold text-white font-sans tracking-tighter leading-tight">
                {firstName}
              </h1>
              <p className="text-white/55 text-sm font-body mt-2 max-w-sm leading-relaxed">
                Explore a história económica de Angola — do colonialismo à era contemporânea.
              </p>
            </div>
            <button
              onClick={() => navigate('/explorar')}
              className="btn-white hidden md:inline-flex flex-shrink-0 shadow-lg"
            >
              <span className="material-symbols-outlined text-[18px]">explore</span>
              Explorar Arquivo
            </button>
          </div>
        </div>

        {/* Stats row */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
          {[
            {
              icon: 'stars',
              label: 'Pontos de Mérito',
              value: myRank ? String(myRank.score) : '0',
              sub: myRank?.rank ? `Posição #${myRank.rank} no ranking` : 'Complete quizzes para ganhar pontos',
              accent: false,
            },
            {
              icon: 'library_books',
              label: 'Artigos Lidos',
              value: loadingProgress ? '…' : String(completed.length),
              sub: completed.length === 0 ? 'Inicie a sua primeira leitura' : `de ${progress.length} iniciado${progress.length !== 1 ? 's' : ''}`,
              accent: false,
            },
            {
              icon: 'auto_stories',
              label: 'Em Leitura',
              value: loadingProgress ? '…' : String(inProgress.length),
              sub: inProgress.length === 0 ? 'Nenhuma leitura em curso' : `artigo${inProgress.length !== 1 ? 's' : ''} por concluir`,
              accent: false,
            },
            {
              icon: 'military_tech',
              label: 'Quizzes Feitos',
              value: myRank ? String(myRank.attempts) : '0',
              sub: myRank?.attempts ? `${myRank.attempts} quiz${myRank.attempts !== 1 ? 'zes' : ''} completado${myRank.attempts !== 1 ? 's' : ''}` : 'Faça o seu primeiro quiz',
              accent: true,
            },
          ].map((s) => (
            <div key={s.label} className={`card p-5 ${s.accent ? 'bg-primary border-primary' : ''}`}>
              <div className="flex items-start justify-between mb-3">
                <div className={`w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 ${
                  s.accent ? 'bg-white/15' : 'bg-surface-container'
                }`}>
                  <span className={`material-symbols-outlined text-[20px] ${s.accent ? 'text-white' : 'text-primary'}`}
                    style={{ fontVariationSettings: "'FILL' 1" }}>
                    {s.icon}
                  </span>
                </div>
              </div>
              <p className={`text-display-lg font-bold font-sans leading-none mb-1.5 ${s.accent ? 'text-white' : 'text-text'}`}>
                {s.value}
              </p>
              <p className={`text-label-md uppercase tracking-wider font-sans mb-1 ${s.accent ? 'text-white/70' : 'text-secondary'}`}>
                {s.label}
              </p>
              <p className={`text-[12px] font-body leading-snug ${s.accent ? 'text-white/50' : 'text-outline'}`}>
                {s.sub}
              </p>
            </div>
          ))}
        </div>

        {/* Quick navigation */}
        <section className="mb-10">
          <div className="section-header">
            <div>
              <h2 className="section-title">Explorar a Plataforma</h2>
              <p className="section-subtitle">Acesso rápido às principais funcionalidades</p>
            </div>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {quickActions.map((item) => (
              <button
                key={item.label}
                onClick={() => navigate(item.route)}
                className="card p-5 text-left hover:shadow-card-hover hover:-translate-y-0.5 hover:border-primary/25 transition-all duration-200 group"
              >
                <div className="w-10 h-10 rounded-xl bg-primary/8 flex items-center justify-center mb-4 group-hover:bg-primary/12 transition-colors duration-150">
                  <span className="material-symbols-outlined text-primary text-[22px]">{item.icon}</span>
                </div>
                <p className="text-sm font-bold text-text font-sans leading-tight mb-1">{item.label}</p>
                <p className="text-[12px] text-secondary font-body leading-snug">{item.sub}</p>
              </button>
            ))}
          </div>
        </section>

        {/* Continue reading */}
        <section className="mb-10">
          <div className="section-header">
            <div>
              <h2 className="section-title">Continuar a Ler</h2>
              <p className="section-subtitle">Retome onde parou</p>
            </div>
            <button onClick={() => navigate('/explorar')} className="section-link">
              Ver todo o arquivo
              <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
            </button>
          </div>

          {loadingProgress ? (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {[0, 1].map((i) => (
                <div key={i} className="skeleton h-28 rounded-card" />
              ))}
            </div>
          ) : inProgress.length === 0 ? (
            <div className="card p-10 flex flex-col md:flex-row items-center gap-6 text-center md:text-left">
              <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center flex-shrink-0 mx-auto md:mx-0">
                <span className="material-symbols-outlined text-primary/40 text-[32px]">auto_stories</span>
              </div>
              <div className="flex-1">
                <p className="text-headline-md font-bold text-text font-sans mb-1">Ainda não iniciou nenhuma leitura</p>
                <p className="text-body-md text-secondary font-body mb-4">Explore o arquivo e comece a mergulhar na história económica de Angola.</p>
                <button onClick={() => navigate('/explorar')} className="btn-primary">
                  <span className="material-symbols-outlined text-[18px]">explore</span>
                  Explorar Arquivo
                </button>
              </div>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {inProgress.map((item) => (
                <article
                  key={item.id}
                  onClick={() => navigate(getContentTypeRoute(item.content.type), { state: { contentId: item.contentId } })}
                  className="card-interactive flex gap-4 p-5"
                >
                  <div className="w-16 h-16 rounded-xl bg-gradient-to-br from-surface-container to-surface-container-high flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-primary/30 text-[28px]">history_edu</span>
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-[11px] font-bold text-primary uppercase tracking-wider font-sans mb-1">
                      {item.content.category?.name ?? item.content.type}
                    </p>
                    <h3 className="text-sm font-semibold text-text font-sans leading-snug line-clamp-2 mb-2">
                      {item.content.title}
                    </h3>
                    <div className="flex items-center gap-2">
                      <div className="flex-1 bg-surface-container h-1 rounded-full">
                        <div className="bg-primary h-1 rounded-full transition-all" style={{ width: `${item.percentage}%` }} />
                      </div>
                      <span className="text-[11px] font-bold text-primary font-sans flex-shrink-0">{item.percentage}%</span>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>

        {/* CTA banner */}
        <section className="card p-8 flex flex-col md:flex-row items-center gap-6 bg-surface-warm border-primary/15">
          <div className="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center flex-shrink-0">
            <span className="material-symbols-outlined text-primary text-[28px]"
              style={{ fontVariationSettings: "'FILL' 1" }}>emoji_events</span>
          </div>
          <div className="flex-1 text-center md:text-left">
            <h4 className="text-headline-md font-bold text-text font-sans mb-1">
              Explore o Arquivo Digital
            </h4>
            <p className="text-body-md text-secondary font-body leading-relaxed">
              Documentos históricos, análises económicas e registos sobre Angola desde o período colonial até hoje.
            </p>
          </div>
          <div className="flex gap-3 flex-shrink-0">
            <button onClick={() => navigate('/mapa')} className="btn-secondary">
              <span className="material-symbols-outlined text-[18px]">map</span>
              Ver Mapa
            </button>
            <button onClick={() => navigate('/explorar')} className="btn-primary">
              Explorar
              <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
            </button>
          </div>
        </section>

      </div>

      <footer className="ml-0 border-t border-outline-variant/20 bg-surface mt-10">
        <div className="flex flex-col md:flex-row justify-between items-center px-8 py-5 max-w-[1200px] mx-auto">
          <span className="text-sm font-semibold text-primary font-sans">Economia com História · Angola</span>
          <p className="text-xs text-outline font-body mt-1 md:mt-0">© 2026 Todos os direitos reservados.</p>
        </div>
      </footer>
    </AppShell>
  )
}
