import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { quizService } from '../services/api/quiz.service'
import { extractList } from '../services/types/api.types'
import { useAuth } from '../contexts/AuthContext'
import { useAuthGate } from '../contexts/AuthGateContext'
import type { Content, Quiz, PaginatedResponse } from '../services/types/api.types'

// ── Funcionalidades apresentadas na secção "O que pode explorar" ─────────────
// Cada uma aponta para uma rota pública que o Visitante pode consultar.
const FEATURES = [
  { icon: 'menu_book', title: 'Artigos & Análises', desc: 'História económica de Angola, do Zimbo ao Kwanza.', route: '/explorar', color: 'primary' },
  { icon: 'quiz', title: 'Quizzes', desc: 'Teste os seus conhecimentos por período histórico.', route: '/quiz', color: 'navy' },
  { icon: 'forum', title: 'Fórum', desc: 'Debata com investigadores e curiosos.', route: '/forum', color: 'success' },
  { icon: 'map', title: 'Mapa Económico', desc: 'Explore as 18 províncias e as suas rotas comerciais.', route: '/mapa', color: 'primary' },
  { icon: 'menu_book', title: 'Glossário', desc: 'Conceitos económicos e históricos explicados.', route: '/glossario', color: 'navy' },
  { icon: 'leaderboard', title: 'Rankings', desc: 'Acompanhe a classificação da comunidade.', route: '/quiz', color: 'success' },
]

const FEATURE_COLOR: Record<string, string> = {
  primary: 'bg-primary/10 text-primary',
  navy: 'bg-navy/10 text-navy',
  success: 'bg-success/10 text-success',
}

// ── FAQ — conteúdo informativo real sobre a plataforma ───────────────────────
const FAQ = [
  { q: 'Preciso de conta para usar a plataforma?', a: 'Não para explorar. Pode consultar artigos em destaque, ver fóruns, quizzes, o mapa económico e o glossário sem conta. Para ler conteúdos completos, participar em debates ou realizar quizzes, é necessário criar uma conta gratuita.' },
  { q: 'A plataforma é gratuita?', a: 'Sim. A criação de conta e o acesso aos conteúdos educativos são gratuitos.' },
  { q: 'O que são os "Textos com Jindungo"?', a: 'São análises críticas e aprofundadas sobre a economia angolana — leitura mais "picante", reservada a membros registados.' },
  { q: 'Quem produz os conteúdos?', a: 'Os conteúdos são elaborados e revistos com rigor académico por escritores e professores da comunidade.' },
]

function contentRoute(content: Content): string {
  if (content.type === 'VIDEO' || content.type === 'PODCAST' || content.type === 'AUDIO') return '/aula-video'
  if (content.type === 'PDF') return '/documento/detalhe'
  if (content.isJindungo || content.type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

export default function HomeLanding() {
  const navigate = useNavigate()
  const { isAuthenticated } = useAuth()
  const { requireAuth } = useAuthGate()

  const [contents, setContents] = useState<Content[]>([])
  const [contentsTotal, setContentsTotal] = useState(0)
  const [quizzes, setQuizzes] = useState<Quiz[]>([])
  const [openFaq, setOpenFaq] = useState<number | null>(0)

  useEffect(() => {
    contentService
      .list({ limit: 6 })
      .then((res) => {
        setContents(extractList(res))
        if (!Array.isArray(res)) setContentsTotal(res.total)
      })
      .catch(() => {})
    quizService
      .list()
      .then((res) => setQuizzes(extractList(res as Quiz[] | PaginatedResponse<Quiz>)))
      .catch(() => {})
  }, [])

  const highlights = contents.filter((c) => !c.isJindungo).slice(0, 4)
  const jindungo = contents.find((c) => c.isJindungo) ?? null
  const featuredQuizzes = quizzes.slice(0, 3)

  // Abrir um conteúdo/quiz destacado: o Visitante é convidado a entrar.
  function openContent(content: Content) {
    requireAuth(() => navigate(contentRoute(content), { state: { contentId: content.id } }), {
      title: 'Este conteúdo é para membros',
      message: 'Crie uma conta gratuita ou inicie sessão para ler este conteúdo por completo.',
      icon: 'menu_book',
    })
  }

  function startQuiz(quiz: Quiz) {
    requireAuth(() => navigate('/quiz/em-curso', { state: { quizId: quiz.id } }), {
      title: 'Pronto para testar os seus conhecimentos?',
      message: 'Crie uma conta gratuita ou inicie sessão para realizar o quiz e guardar a sua pontuação.',
      icon: 'quiz',
    })
  }

  const stats = [
    { icon: 'menu_book', value: contentsTotal > 0 ? String(contentsTotal) : (contents.length ? `${contents.length}+` : '—'), label: 'Conteúdos' },
    { icon: 'quiz', value: quizzes.length ? String(quizzes.length) : '—', label: 'Quizzes' },
    { icon: 'public', value: '18', label: 'Províncias' },
  ]

  return (
    <AppShell showSearch={false}>
      <div className="page-content animate-fade-in">

        {/* ── Hero ─────────────────────────────────────────────── */}
        <section className="relative rounded-3xl overflow-hidden mb-12"
          style={{ background: 'linear-gradient(145deg, #8B1A1A 0%, #5A1010 55%, #2A0808 100%)' }}>
          <div className="absolute inset-0 opacity-[0.05]"
            style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '22px 22px' }} />
          <div className="absolute -right-10 -bottom-16 pointer-events-none hidden md:block">
            <span className="material-symbols-outlined text-white/[0.06]" style={{ fontSize: '280px' }}>history_edu</span>
          </div>
          <div className="relative z-10 px-8 sm:px-12 py-14 sm:py-20 max-w-3xl">
            <span className="inline-flex items-center gap-1.5 bg-white/12 text-white/90 px-3 py-1 rounded-full text-[11px] font-bold font-sans mb-6 border border-white/15 uppercase tracking-wider">
              <span className="material-symbols-outlined text-[14px]" style={{ fontVariationSettings: "'FILL' 1" }}>school</span>
              Plataforma Educativa
            </span>
            <h1 className="text-4xl sm:text-5xl font-extrabold text-white font-sans tracking-tight leading-[1.1] mb-5">
              A economia de Angola contada pela sua história
            </h1>
            <p className="text-white/75 text-base sm:text-lg font-body leading-relaxed max-w-xl mb-9">
              Artigos, debates e quizzes sobre as raízes económicas do país — do Zimbo ao Kwanza, do Caminho de Ferro de Benguela à indústria contemporânea.
            </p>
            <div className="flex flex-col sm:flex-row gap-3">
              <button
                onClick={() => navigate('/cadastro')}
                className="btn-white shadow-lg justify-center"
              >
                <span className="material-symbols-outlined text-[18px]">person_add</span>
                Criar Conta Grátis
              </button>
              <button
                onClick={() => navigate('/explorar')}
                className="inline-flex items-center justify-center gap-2 px-[18px] py-[14px] rounded-button border border-white/40 text-white font-semibold font-sans text-sm uppercase tracking-wide hover:bg-white/10 hover:border-white/70 transition-all duration-150"
              >
                <span className="material-symbols-outlined text-[18px]">explore</span>
                Explorar sem conta
              </button>
            </div>
            {!isAuthenticated && (
              <button
                onClick={() => navigate('/login')}
                className="mt-5 text-sm font-semibold font-sans text-white/70 hover:text-white transition-colors duration-150"
              >
                Já tenho conta — Entrar →
              </button>
            )}
          </div>
        </section>

        {/* ── Estatísticas ─────────────────────────────────────── */}
        <section className="grid grid-cols-3 gap-4 mb-14">
          {stats.map((s) => (
            <div key={s.label} className="card p-5 sm:p-6 text-center">
              <div className="w-10 h-10 rounded-xl bg-primary/8 flex items-center justify-center mx-auto mb-3">
                <span className="material-symbols-outlined text-primary text-[22px]">{s.icon}</span>
              </div>
              <p className="text-3xl sm:text-4xl font-extrabold text-text font-sans leading-none mb-1">{s.value}</p>
              <p className="text-label-md uppercase tracking-wider text-secondary font-sans">{s.label}</p>
            </div>
          ))}
        </section>

        {/* ── O que pode explorar ──────────────────────────────── */}
        <section className="mb-14">
          <div className="mb-6">
            <h2 className="text-headline-xl font-bold text-text font-sans tracking-tight">O que pode explorar</h2>
            <p className="text-body-md text-secondary font-body mt-1">Descubra a plataforma antes de criar conta.</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {FEATURES.map((f) => (
              <button
                key={f.title}
                onClick={() => navigate(f.route)}
                className="card-interactive p-6 text-left group"
              >
                <div className={`w-12 h-12 rounded-xl flex items-center justify-center mb-4 ${FEATURE_COLOR[f.color]}`}>
                  <span className="material-symbols-outlined text-[24px]">{f.icon}</span>
                </div>
                <h3 className="text-title-lg font-semibold text-text font-sans mb-1.5 group-hover:text-primary transition-colors duration-150">{f.title}</h3>
                <p className="text-body-md text-secondary font-body leading-relaxed">{f.desc}</p>
              </button>
            ))}
          </div>
        </section>

        {/* ── Leia agora, sem conta ────────────────────────────── */}
        {highlights.length > 0 && (
          <section className="mb-14">
            <div className="section-header">
              <div>
                <h2 className="section-title">Conteúdos em destaque</h2>
                <p className="section-subtitle">Uma amostra do que vai encontrar. Crie conta para ler tudo.</p>
              </div>
              <button onClick={() => navigate('/explorar')} className="btn-ghost text-sm hidden sm:flex">
                Ver todos <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
              </button>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {highlights.map((c) => (
                <article
                  key={c.id}
                  onClick={() => openContent(c)}
                  className="card-interactive p-6 group flex items-start gap-4"
                >
                  <div className="w-11 h-11 rounded-xl bg-surface-container flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-primary text-[22px]">
                      {c.type === 'PDF' ? 'description' : c.type === 'VIDEO' ? 'play_circle' : 'article'}
                    </span>
                  </div>
                  <div className="min-w-0">
                    {c.category && <span className="badge-primary mb-1.5">{c.category.name}</span>}
                    <h3 className="text-title-lg font-semibold text-text font-sans leading-snug group-hover:text-primary transition-colors duration-150 line-clamp-2">{c.title}</h3>
                    {c.summary && <p className="text-body-md text-secondary font-reading line-clamp-2 mt-1 leading-relaxed">{c.summary}</p>}
                  </div>
                </article>
              ))}
            </div>
          </section>
        )}

        {/* ── Textos com Jindungo (restrito) ───────────────────── */}
        <section className="mb-14">
          <div className="mb-6">
            <h2 className="text-headline-xl font-bold text-text font-sans tracking-tight flex items-center gap-2">
              <span className="material-symbols-outlined text-primary text-[26px]">local_fire_department</span>
              Textos com Jindungo
            </h2>
            <p className="text-body-md text-secondary font-body mt-1">Análises críticas e picantes sobre a economia angolana — exclusivo para membros.</p>
          </div>
          <button
            onClick={() => jindungo ? openContent(jindungo) : requireAuth(undefined, {
              title: 'Conteúdo exclusivo para membros',
              message: 'Crie uma conta gratuita ou inicie sessão para aceder às análises Jindungo.',
              icon: 'local_fire_department',
            })}
            className="relative w-full text-left rounded-card overflow-hidden group"
            style={{ background: 'linear-gradient(135deg, #8B1A1A 0%, #5A1010 100%)' }}
          >
            <div className="absolute -right-4 -top-4 pointer-events-none">
              <span className="material-symbols-outlined text-[#E9A23B]/15" style={{ fontSize: '130px' }}>local_fire_department</span>
            </div>
            <div className="relative z-10 p-7">
              <div className="flex items-center gap-2 mb-3">
                <span className="material-symbols-outlined text-[#E9A23B] text-[18px]">local_fire_department</span>
                <span className="text-white/90 text-[11px] font-bold uppercase tracking-wider font-sans">Reservado a membros</span>
                <span className="material-symbols-outlined text-white/70 text-[18px] ml-auto">lock</span>
              </div>
              <h3 className="text-headline-lg font-bold text-white font-sans mb-2 leading-snug">
                {jindungo?.title ?? 'A verdadeira história económica que ninguém lhe contou'}
              </h3>
              <p className="text-white/80 font-reading italic leading-relaxed line-clamp-2">
                {jindungo?.summary ?? 'Análises profundas, fontes selecionadas e leitura premium para quem quer ir além da superfície.'}
              </p>
              <span className="inline-flex items-center gap-1.5 mt-4 text-white text-sm font-semibold font-sans">
                Desbloquear com conta gratuita
                <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
              </span>
            </div>
          </button>
        </section>

        {/* ── Quizzes em destaque ──────────────────────────────── */}
        {featuredQuizzes.length > 0 && (
          <section className="mb-14">
            <div className="section-header">
              <div>
                <h2 className="section-title">Ponha-se à prova</h2>
                <p className="section-subtitle">Veja os quizzes disponíveis. Crie conta para começar.</p>
              </div>
              <button onClick={() => navigate('/quiz')} className="btn-ghost text-sm hidden sm:flex">
                Ver todos <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
              </button>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {featuredQuizzes.map((q) => (
                <button key={q.id} onClick={() => startQuiz(q)} className="card-interactive p-6 text-left group">
                  <div className="w-11 h-11 rounded-xl bg-primary/8 flex items-center justify-center mb-4">
                    <span className="material-symbols-outlined text-primary text-[22px]">quiz</span>
                  </div>
                  <h3 className="text-title-lg font-semibold text-text font-sans mb-1.5 group-hover:text-primary transition-colors duration-150 line-clamp-2">{q.title}</h3>
                  {q.description && <p className="text-body-md text-secondary font-body line-clamp-2 leading-relaxed mb-3">{q.description}</p>}
                  <span className="text-[12px] text-secondary font-body flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-[15px]">help</span>
                    {q._count?.questions ?? 0} questões
                  </span>
                </button>
              ))}
            </div>
          </section>
        )}

        {/* ── FAQ ──────────────────────────────────────────────── */}
        <section className="mb-14">
          <div className="mb-6">
            <h2 className="text-headline-xl font-bold text-text font-sans tracking-tight">Perguntas frequentes</h2>
          </div>
          <div className="flex flex-col gap-2.5">
            {FAQ.map((item, i) => {
              const open = openFaq === i
              return (
                <div key={item.q} className="card overflow-hidden">
                  <button
                    onClick={() => setOpenFaq(open ? null : i)}
                    className="w-full flex items-center gap-4 p-5 text-left"
                    aria-expanded={open}
                  >
                    <span className="flex-1 text-title-md font-semibold text-text font-sans">{item.q}</span>
                    <span className={`material-symbols-outlined text-secondary transition-transform duration-200 ${open ? 'rotate-180' : ''}`}>expand_more</span>
                  </button>
                  {open && (
                    <div className="px-5 pb-5 -mt-1">
                      <p className="text-body-md text-secondary font-reading leading-relaxed">{item.a}</p>
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        </section>

        {/* ── Sabia que? ───────────────────────────────────────── */}
        <section className="mb-14">
          <div className="alert-info rounded-card">
            <span className="material-symbols-outlined text-primary text-[22px] flex-shrink-0" style={{ fontVariationSettings: "'FILL' 1" }}>lightbulb</span>
            <div>
              <p className="text-title-md font-bold text-text font-sans mb-1">Sabia que?</p>
              <p className="text-body-md text-secondary font-reading leading-relaxed">
                Antes do Kwanza, o <strong className="text-text">Zimbo</strong> — pequenas conchas recolhidas na ilha de Luanda — funcionou durante séculos como moeda no comércio do Reino do Kongo.
              </p>
            </div>
          </div>
        </section>

        {/* ── CTA final ────────────────────────────────────────── */}
        <section className="rounded-3xl bg-surface-warm border border-primary/15 p-10 sm:p-14 text-center">
          <h2 className="text-3xl font-bold text-text font-sans tracking-tight mb-3">Pronto para redescobrir a nossa história?</h2>
          <p className="text-body-lg text-secondary font-body max-w-md mx-auto mb-8 leading-relaxed">
            Junte-se à comunidade e comece a explorar a história económica de Angola com rigor.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <button onClick={() => navigate('/cadastro')} className="btn-primary justify-center">
              <span className="material-symbols-outlined text-[18px]">person_add</span>
              Criar a Minha Conta
            </button>
            <button onClick={() => navigate('/login')} className="btn-secondary justify-center">
              <span className="material-symbols-outlined text-[18px]">login</span>
              Já tenho conta
            </button>
          </div>
        </section>
      </div>
    </AppShell>
  )
}
