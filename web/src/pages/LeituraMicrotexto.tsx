import { useState, useEffect, useRef, useCallback } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content } from '../services/types/api.types'

function readingMinutes(body: string | null): number {
  if (!body) return 1
  return Math.max(1, Math.round(body.trim().split(/\s+/).length / 200))
}

export default function LeituraMicrotexto() {
  const navigate = useNavigate()
  const location = useLocation()
  const { user } = useAuth()
  const contentId = (location.state as { contentId?: string } | null)?.contentId

  const [content, setContent] = useState<Content | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [bookmarked, setBookmarked] = useState(false)
  const [bookmarkLoading, setBookmarkLoading] = useState(false)
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
      const rect = el.getBoundingClientRect()
      const visible = window.innerHeight - Math.max(0, rect.top)
      const pct = Math.min(100, Math.round((visible / el.scrollHeight) * 100))
      setScrollPct(pct)
    }
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  useEffect(() => {
    if (scrollPct > 0 && scrollPct % 25 === 0) reportProgress(scrollPct)
  }, [scrollPct, reportProgress])

  async function toggleFavorite() {
    if (!contentId || !user) return
    setBookmarkLoading(true)
    try { await contentService.favorite(contentId); setBookmarked((b) => !b) }
    catch { /* ignore */ }
    finally { setBookmarkLoading(false) }
  }

  const paragraphs = content?.body?.split(/\n{2,}/).filter(Boolean) ?? []
  const mins = readingMinutes(content?.body ?? null)

  if (!loading && error) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-primary/30 text-[32px]">article</span>
          </div>
          <p className="text-body-md text-secondary font-body mb-6">{error}</p>
          <button onClick={() => navigate('/explorar')} className="btn-primary">Ir para Explorar</button>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell showSearch={false}>
      {/* Reading progress bar — fixed under topbar */}
      <div className="fixed top-topbar left-sidebar right-0 z-30 h-[3px] bg-surface-container">
        <div className="h-full bg-primary transition-all duration-500 ease-out" style={{ width: `${scrollPct}%` }} />
      </div>

      <div className="page-content-narrow pt-8 pb-16 animate-fade-in">
        {/* Back */}
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {loading ? (
          <div className="space-y-5">
            <div className="skeleton h-5 w-32 rounded" />
            <div className="skeleton h-10 w-4/5 rounded-lg" />
            <div className="skeleton h-6 w-full rounded-lg" />
            <div className="skeleton h-56 rounded-card" />
            {[1, 2, 3].map((i) => <div key={i} className="skeleton h-4 rounded" />)}
          </div>
        ) : content ? (
          <>
            {/* Article header */}
            <header className="mb-8">
              {/* Meta */}
              <div className="flex items-center gap-3 flex-wrap mb-5">
                <span className="badge-primary">{content.category?.name ?? 'Microtexto'}</span>
                <span className="text-[12px] text-secondary font-body flex items-center gap-1">
                  <span className="material-symbols-outlined text-[13px]">schedule</span>
                  {mins} min de leitura
                </span>
                {content.tags.slice(0, 2).map((t) => (
                  <span key={t.tag.id} className="text-[12px] text-secondary font-body">· {t.tag.name}</span>
                ))}
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
              <div className="flex items-center justify-between py-4 border-t border-b border-outline-variant/25">
                {content.author ? (
                  <div className="flex items-center gap-3">
                    <div className="w-9 h-9 rounded-full bg-gradient-to-br from-primary/20 to-primary/8 border border-primary/20 flex items-center justify-center flex-shrink-0">
                      <span className="text-[11px] font-bold text-primary font-sans leading-none">
                        {content.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
                      </span>
                    </div>
                    <div>
                      <p className="text-sm font-bold text-text font-sans leading-tight">{content.author.name}</p>
                      <p className="text-[11px] text-secondary font-body">Autor</p>
                    </div>
                  </div>
                ) : <div />}
                <div className="flex items-center gap-2">
                  <button
                    onClick={toggleFavorite}
                    disabled={bookmarkLoading || !user}
                    className={`btn-icon ${bookmarked ? 'text-primary bg-primary/8' : ''}`}
                    title={user ? (bookmarked ? 'Remover dos favoritos' : 'Guardar') : 'Inicie sessão para guardar'}
                  >
                    <span className="material-symbols-outlined text-[20px]"
                      style={bookmarked ? { fontVariationSettings: "'FILL' 1" } : undefined}>bookmark</span>
                  </button>
                  <button
                    onClick={() => navigate('/forum')}
                    className="btn-icon"
                    title="Discutir no fórum"
                  >
                    <span className="material-symbols-outlined text-[20px]">forum</span>
                  </button>
                </div>
              </div>
            </header>

            {/* Cover */}
            {content.thumbnailUrl ? (
              <img
                src={content.thumbnailUrl}
                alt={content.title}
                className="w-full h-64 object-cover rounded-card mb-8 border border-outline-variant/25"
              />
            ) : (
              <div className="w-full h-52 rounded-card mb-8 relative overflow-hidden"
                style={{ background: 'linear-gradient(135deg, #F7DEDA 0%, #E8CECA 100%)' }}>
                <div className="absolute inset-0 opacity-[0.05]"
                  style={{ backgroundImage: 'radial-gradient(#8B1A1A 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
                <div className="absolute inset-0 flex items-center justify-center">
                  <span className="material-symbols-outlined text-primary/15" style={{ fontSize: '80px' }}>history_edu</span>
                </div>
              </div>
            )}

            {/* Article body */}
            <article ref={articleRef} className="prose-article">
              {paragraphs.length > 0 ? (
                paragraphs.map((p, i) => <p key={i}>{p}</p>)
              ) : (
                <p style={{ color: '#8A706D', fontStyle: 'italic', fontFamily: 'Lexend' }}>Conteúdo não disponível.</p>
              )}
            </article>

            {/* Footer nav */}
            <div className="flex justify-between items-center mt-12 pt-6 border-t border-outline-variant/25">
              <button
                onClick={() => navigate('/explorar')}
                className="btn-ghost gap-2"
              >
                <span className="material-symbols-outlined text-[18px]">arrow_back</span>
                Mais artigos
              </button>
              <button
                onClick={() => navigate('/forum')}
                className="btn-secondary gap-2"
              >
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
