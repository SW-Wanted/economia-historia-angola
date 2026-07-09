import { useState, useEffect, useRef, useCallback } from 'react'
import { useNavigate, useLocation, NavigateFunction } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth, hasPermission } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content, User } from '../services/types/api.types'

function readingMinutes(body: string | null): number {
  if (!body) return 1
  return Math.max(1, Math.round(body.trim().split(/\s+/).length / 200))
}

function JindungoLock({
  contentId,
  user,
  onNavigate,
}: {
  contentId: string | undefined
  user: User | null
  onNavigate: NavigateFunction
}) {
  const [requesting, setRequesting] = useState(false)
  const [requested, setRequested] = useState(false)
  const [requestError, setRequestError] = useState('')

  async function handleRequest() {
    if (!contentId) return
    setRequesting(true)
    setRequestError('')
    try {
      await contentService.requestAccess(contentId)
      setRequested(true)
    } catch (err: unknown) {
      setRequestError(getErrorMessage(err))
    } finally {
      setRequesting(false)
    }
  }

  return (
    <div className="card p-12 text-center">
      <div className="w-16 h-16 rounded-2xl bg-primary/8 flex items-center justify-center mx-auto mb-5">
        <span className="material-symbols-outlined text-primary text-[32px]">lock</span>
      </div>
      <h3 className="text-headline-lg font-bold text-text font-sans mb-2">Conteúdo Exclusivo</h3>
      <p className="text-body-md text-secondary font-reading mb-6 max-w-sm mx-auto leading-relaxed">
        Os textos Jindungo são análises aprofundadas disponíveis para investigadores com conta verificada.
      </p>

      {requested ? (
        <div className="alert-success rounded-xl max-w-sm mx-auto">
          <span className="material-symbols-outlined text-success text-[20px] flex-shrink-0"
            style={{ fontVariationSettings: "'FILL' 1" }}>check_circle</span>
          <div className="text-left">
            <p className="text-sm font-bold text-success font-sans">Pedido enviado!</p>
            <p className="text-body-md text-secondary font-body mt-0.5">
              O seu pedido de acesso foi enviado. Um moderador irá analisar brevemente.
            </p>
          </div>
        </div>
      ) : !user ? (
        <div className="flex flex-col gap-3 items-center">
          <button onClick={() => onNavigate('/cadastro')} className="btn-primary">
            <span className="material-symbols-outlined text-[18px]">person_add</span>
            Criar Conta Gratuita
          </button>
          <button onClick={() => onNavigate('/entrar')} className="btn-ghost text-sm">
            Já tenho conta — Iniciar Sessão
          </button>
        </div>
      ) : (
        <div className="flex flex-col gap-3 items-center">
          <button
            onClick={handleRequest}
            disabled={requesting}
            className="btn-primary disabled:opacity-60 disabled:cursor-not-allowed"
          >
            {requesting ? (
              <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
              <>
                <span className="material-symbols-outlined text-[18px]">key</span>
                Solicitar Acesso
              </>
            )}
          </button>
          {requestError && (
            <p className="text-sm text-error font-body">{requestError}</p>
          )}
        </div>
      )}
    </div>
  )
}

export default function LeituraJindungo() {
  const navigate = useNavigate()
  const location = useLocation()
  const { user } = useAuth()
  const contentId = (location.state as { contentId?: string } | null)?.contentId

  const [content, setContent] = useState<Content | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [scrollPct, setScrollPct] = useState(0)
  const articleRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!contentId) { setError('Nenhum conteúdo selecionado.'); setLoading(false); return }
    contentService.get(contentId)
      .then(setContent)
      .catch((err) => setError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [contentId])

  const reportProgress = useCallback((pct: number) => {
    if (!contentId || !user) return
    contentService.updateProgress(contentId, pct).catch(() => {})
  }, [contentId, user])

  useEffect(() => {
    function onScroll() {
      const el = articleRef.current
      if (!el) return
      const visible = window.innerHeight - Math.max(0, el.getBoundingClientRect().top)
      const pct = Math.min(100, Math.round((visible / el.scrollHeight) * 100))
      setScrollPct(pct)
    }
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  useEffect(() => {
    if (scrollPct > 0 && scrollPct % 25 === 0) reportProgress(scrollPct)
  }, [scrollPct, reportProgress])

  const unlocked = !content?.isJindungo || hasPermission(user, 'JINDUNGO_ACCESS', 'JINDUNGO_WRITE')
  const paragraphs = content?.body && unlocked ? content.body.split(/\n{2,}/).filter(Boolean) : []
  const mins = readingMinutes(content?.body ?? null)

  if (!loading && error) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-primary/30 text-[32px]">nutrition</span>
          </div>
          <p className="text-body-md text-secondary font-body mb-6">{error}</p>
          <button onClick={() => navigate('/explorar')} className="btn-primary">Ir para Explorar</button>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell showSearch={false}>
      {/* Reading progress — fixed under topbar */}
      <div className="fixed top-topbar left-sidebar right-0 z-30 h-[3px] bg-surface-container">
        <div className="h-full bg-primary transition-all duration-500 ease-out" style={{ width: `${scrollPct}%` }} />
      </div>

      <div className="page-content-narrow pt-8 pb-16 animate-fade-in">
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {loading ? (
          <div className="space-y-4">
            <div className="skeleton h-5 w-48 rounded" />
            <div className="skeleton h-12 w-5/6 rounded-lg" />
            <div className="skeleton h-6 w-full rounded" />
            <div className="skeleton h-72 rounded-card" />
            {[1, 2, 3, 4].map((i) => <div key={i} className="skeleton h-4 rounded" />)}
          </div>
        ) : content ? (
          <>
            <header className="mb-8">
              {/* Badges */}
              <div className="flex items-center gap-3 flex-wrap mb-5">
                <span className="badge bg-primary text-white flex items-center gap-1">
                  <span className="material-symbols-outlined text-[12px]">nutrition</span>
                  Análise Aprofundada
                </span>
                {content.category && <span className="badge-muted">{content.category.name}</span>}
                <span className="text-[12px] text-secondary font-body flex items-center gap-1">
                  <span className="material-symbols-outlined text-[13px]">schedule</span>
                  {mins} min de leitura
                </span>
              </div>

              {/* Title */}
              <h1 className="text-display-lg font-extrabold text-text font-sans tracking-tight leading-tight mb-4">
                {content.title}
              </h1>

              {/* Summary */}
              {content.summary && (
                <p className="text-body-xl text-secondary font-reading leading-relaxed mb-6 italic border-l-4 border-primary/30 pl-4">
                  {content.summary}
                </p>
              )}

              {/* Author row */}
              {content.author && (
                <div className="flex items-center gap-3 py-4 border-t border-b border-outline-variant/20">
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary/20 to-primary/8 border border-primary/20 flex items-center justify-center flex-shrink-0">
                    <span className="text-[11px] font-bold text-primary font-sans leading-none">
                      {content.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
                    </span>
                  </div>
                  <div>
                    <p className="text-sm font-bold text-text font-sans">{content.author.name}</p>
                    <p className="text-[11px] text-secondary font-body">Autor · Análise Jindungo</p>
                  </div>
                  <div className="ml-auto flex items-center gap-2">
                    <button onClick={() => navigate('/forum')} className="btn-icon" title="Discutir">
                      <span className="material-symbols-outlined text-[20px]">forum</span>
                    </button>
                  </div>
                </div>
              )}
            </header>

            {/* Cover — imagem de capa carregada, ou fundo editorial por defeito */}
            {content.thumbnailUrl ? (
              <img
                src={content.thumbnailUrl}
                alt={content.title}
                className="w-full h-64 object-cover rounded-card mb-8 border border-outline-variant/25"
              />
            ) : (
              <div className="w-full h-64 rounded-card mb-8 overflow-hidden relative"
                style={{ background: 'linear-gradient(135deg, #8B1A1A 0%, #5A1010 60%, #2A0808 100%)' }}>
                <div className="absolute inset-0 opacity-[0.04]"
                  style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '24px 24px' }} />
                <div className="absolute inset-0 flex items-center justify-center">
                  <span className="material-symbols-outlined text-white/10" style={{ fontSize: '160px' }}>history_edu</span>
                </div>
                <div className="absolute bottom-0 left-0 right-0 p-6 bg-gradient-to-t from-black/40 to-transparent">
                  <span className="text-white/60 text-xs font-body">Análise aprofundada · Economia com História</span>
                </div>
              </div>
            )}

            {unlocked ? (
              <article ref={articleRef} className="prose-article">
                {paragraphs.length > 0 ? (
                  paragraphs.map((p, i) => <p key={i}>{p}</p>)
                ) : (
                  <p style={{ color: '#8A706D', fontStyle: 'italic', fontFamily: 'Lexend' }}>Conteúdo não disponível.</p>
                )}
              </article>
            ) : (
              <JindungoLock contentId={contentId} user={user} onNavigate={navigate} />
            )}

            <div className="flex justify-between items-center mt-12 pt-6 border-t border-outline-variant/20">
              <button onClick={() => navigate('/explorar')} className="btn-ghost">
                <span className="material-symbols-outlined text-[18px]">arrow_back</span>
                Mais análises
              </button>
              <button onClick={() => navigate('/forum')} className="btn-secondary">
                <span className="material-symbols-outlined text-[18px]">forum</span>
                Discutir no Fórum
              </button>
            </div>
          </>
        ) : null}
      </div>
    </AppShell>
  )
}
