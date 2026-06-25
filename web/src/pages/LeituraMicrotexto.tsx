import { useState, useEffect, useRef, useCallback } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content } from '../services/types/api.types'

function readingMinutes(body: string | null): string {
  if (!body) return '—'
  const words = body.trim().split(/\s+/).length
  const mins = Math.max(1, Math.round(words / 200))
  return `${mins} min de leitura`
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
    if (!contentId) {
      setError('Nenhum conteúdo selecionado. Selecione um artigo no Explorar.')
      setLoading(false)
      return
    }
    contentService
      .get(contentId)
      .then(setContent)
      .catch((err) => setError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [contentId])

  const reportProgress = useCallback(
    (pct: number) => {
      if (!contentId || !user) return
      contentService.updateProgress(contentId, pct).catch(() => {})
    },
    [contentId, user],
  )

  useEffect(() => {
    function onScroll() {
      const el = articleRef.current
      if (!el) return
      const rect = el.getBoundingClientRect()
      const total = el.scrollHeight
      const visible = window.innerHeight - Math.max(0, rect.top)
      const pct = Math.min(100, Math.round((visible / total) * 100))
      setScrollPct(pct)
    }
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  useEffect(() => {
    if (scrollPct > 0 && scrollPct % 25 === 0) {
      reportProgress(scrollPct)
    }
  }, [scrollPct, reportProgress])

  async function toggleFavorite() {
    if (!contentId || !user) return
    setBookmarkLoading(true)
    try {
      await contentService.favorite(contentId)
      setBookmarked((b) => !b)
    } catch {
      // ignore
    } finally {
      setBookmarkLoading(false)
    }
  }

  const paragraphs = content?.body
    ? content.body.split(/\n{2,}/).filter(Boolean)
    : []

  if (!loading && error) {
    return (
      <AppShell showSearch={false}>
        <div className="px-10 py-16 max-w-[760px] mx-auto text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">article</span>
          <p className="text-sm text-[#5d5f5d] font-serif mb-5">{error}</p>
          <button
            onClick={() => navigate('/explorar')}
            className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all"
          >
            Ir para Explorar
          </button>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell showSearch={false}>
      <div className="px-10 py-10 max-w-[760px] mx-auto">
        {/* Back */}
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {loading ? (
          <div className="space-y-5">
            <div className="h-8 bg-[#f0eded] rounded-lg animate-pulse w-2/3" />
            <div className="h-12 bg-[#f0eded] rounded-lg animate-pulse" />
            <div className="h-60 bg-[#f0eded] rounded-xl animate-pulse" />
            {[0, 1, 2].map((i) => (
              <div key={i} className="h-4 bg-[#f0eded] rounded animate-pulse" />
            ))}
          </div>
        ) : content ? (
          <>
            {/* Article header */}
            <div className="mb-8">
              <div className="flex items-center gap-2.5 mb-4">
                <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">
                  {content.category?.name ?? 'Microtexto'}
                </span>
                <span className="text-xs text-[#b8a5a3]">{readingMinutes(content.body)}</span>
                {content.tags.slice(0, 2).map((t) => (
                  <span key={t.tag.id} className="text-xs text-[#b8a5a3]">• {t.tag.name}</span>
                ))}
              </div>
              <h1 className="text-[36px] font-extrabold text-[#1c1b1b] leading-tight mb-5 font-sans tracking-tight">
                {content.title}
              </h1>
              {content.summary && (
                <p className="text-base text-[#5d5f5d] font-serif leading-relaxed mb-5 italic">{content.summary}</p>
              )}
              <div className="flex items-center gap-4">
                {content.author && (
                  <div className="flex items-center gap-2.5">
                    <div className="w-9 h-9 rounded-full bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border border-[#ebe5e4] flex items-center justify-center flex-shrink-0">
                      <span className="text-[11px] font-bold text-[#8B1A1A] font-sans leading-none">
                        {content.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
                      </span>
                    </div>
                    <span className="text-sm font-bold text-[#1c1b1b] font-sans">{content.author.name}</span>
                  </div>
                )}
                <div className="flex items-center gap-3 ml-auto">
                  <button
                    onClick={toggleFavorite}
                    disabled={bookmarkLoading || !user}
                    className={`p-1.5 rounded-lg transition-all duration-150 ${bookmarked ? 'text-[#8B1A1A] bg-[#fff5f4]' : 'text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded]'} disabled:opacity-40`}
                    title={user ? (bookmarked ? 'Remover dos favoritos' : 'Guardar nos favoritos') : 'Inicie sessão para guardar'}
                  >
                    <span className="material-symbols-outlined text-[18px]" style={bookmarked ? { fontVariationSettings: "'FILL' 1" } : undefined}>bookmark</span>
                  </button>
                  <button
                    onClick={() => navigate('/forum')}
                    className="flex items-center gap-1.5 text-sm text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded] px-3 py-1.5 rounded-lg transition-all duration-150"
                  >
                    <span className="material-symbols-outlined text-[18px]">forum</span>
                    <span className="font-sans font-semibold">Discutir</span>
                  </button>
                </div>
              </div>
            </div>

            {/* Progress bar */}
            <div className="w-full bg-[#f0eded] h-1.5 rounded-full mb-8">
              <div
                className="bg-[#8B1A1A] h-1.5 rounded-full transition-all duration-500"
                style={{ width: `${scrollPct}%` }}
              />
            </div>

            {/* Cover image */}
            {content.thumbnailUrl ? (
              <img
                src={content.thumbnailUrl}
                alt={content.title}
                className="w-full h-60 object-cover rounded-xl mb-8 border border-[#ebe5e4]"
              />
            ) : (
              <div className="w-full h-60 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] rounded-xl flex items-center justify-center mb-8 border border-[#ebe5e4]">
                <span className="material-symbols-outlined text-[#8B1A1A]/15" style={{ fontSize: '90px' }}>history_edu</span>
              </div>
            )}

            {/* Article body */}
            <article ref={articleRef} className="font-serif">
              {paragraphs.length > 0 ? (
                paragraphs.map((p, i) => (
                  <p key={i} className="text-base text-[#5d5f5d] leading-relaxed mb-5">{p}</p>
                ))
              ) : (
                <p className="text-sm text-[#8c716e] italic">Conteúdo não disponível.</p>
              )}
            </article>

            {/* Navigation */}
            <div className="flex justify-between items-center mt-10 pt-7 border-t border-[#ebe5e4]">
              <button
                onClick={() => navigate('/explorar')}
                className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 text-sm font-semibold font-sans"
              >
                <span className="material-symbols-outlined text-[18px]">arrow_back</span>
                Mais artigos
              </button>
              <button
                onClick={() => navigate('/explorar')}
                className="flex items-center gap-2 text-[#8B1A1A] hover:opacity-75 transition-opacity duration-150 text-sm font-semibold font-sans"
              >
                Explorar arquivo
                <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
              </button>
            </div>
          </>
        ) : null}
      </div>
    </AppShell>
  )
}
