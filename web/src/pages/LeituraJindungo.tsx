import { useState, useEffect, useRef, useCallback } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth, hasPermission } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content } from '../services/types/api.types'

function readingMinutes(body: string | null): string {
  if (!body) return '—'
  const words = body.trim().split(/\s+/).length
  const mins = Math.max(1, Math.round(words / 200))
  return `${mins} min de leitura`
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

  // Jindungo access: PROFESSOR and WRITER have JINDUNGO_WRITE, ADMIN/SUPER_ADMIN have JINDUNGO_ACCESS
  const unlocked =
    !content?.isJindungo ||
    hasPermission(user, 'JINDUNGO_ACCESS', 'JINDUNGO_WRITE')

  const paragraphs = content?.body && unlocked
    ? content.body.split(/\n{2,}/).filter(Boolean)
    : []

  if (!loading && error) {
    return (
      <AppShell showSearch={false}>
        <div className="px-10 py-16 max-w-[760px] mx-auto text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">nutrition</span>
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
      <div className="px-10 py-8 max-w-[800px] mx-auto">
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {loading ? (
          <div className="space-y-5">
            <div className="h-8 bg-[#f0eded] rounded-lg animate-pulse w-1/2" />
            <div className="h-14 bg-[#f0eded] rounded-lg animate-pulse" />
            <div className="h-72 bg-[#f0eded] rounded-xl animate-pulse" />
            {[0, 1, 2].map((i) => (
              <div key={i} className="h-5 bg-[#f0eded] rounded animate-pulse" />
            ))}
          </div>
        ) : content ? (
          <>
            {/* Jindungo badge */}
            <div className="flex items-center gap-3 mb-4">
              <span className="bg-[#8B1A1A] text-white px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
                <span className="material-symbols-outlined text-[14px]">nutrition</span>
                Texto Jindungo
              </span>
              <span className="text-xs text-[#5d5f5d]">{readingMinutes(content.body)}</span>
              {content.category && (
                <><span className="text-xs text-[#5d5f5d]">•</span>
                <span className="text-xs text-[#5d5f5d]">{content.category.name}</span></>
              )}
            </div>

            <h1 className="text-[40px] font-extrabold text-[#1c1b1b] leading-tight mb-4">
              {content.title}
            </h1>

            {content.summary && (
              <p className="text-xl text-[#58413f] italic mb-8" style={{ fontFamily: 'Merriweather, serif' }}>
                {content.summary}
              </p>
            )}

            {content.author && (
              <div className="flex items-center gap-4 mb-8">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-full bg-[#eae7e7] flex items-center justify-center">
                    <span className="text-sm font-bold text-[#5d5f5d] font-sans">
                      {content.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
                    </span>
                  </div>
                  <div>
                    <span className="text-sm font-bold text-[#1c1b1b]">{content.author.name}</span>
                  </div>
                </div>
              </div>
            )}

            {/* Cover */}
            <div className="w-full h-72 bg-[#8B1A1A] rounded-xl flex items-center justify-center mb-8 relative overflow-hidden">
              <span className="material-symbols-outlined text-white/10" style={{ fontSize: '200px' }}>diamond</span>
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="material-symbols-outlined text-white/30" style={{ fontSize: '100px' }}>nutrition</span>
              </div>
            </div>

            {unlocked ? (
              <>
                {/* Progress bar */}
                <div className="w-full bg-[#f0eded] h-1.5 rounded-full mb-8">
                  <div
                    className="bg-[#8B1A1A] h-1.5 rounded-full transition-all duration-500"
                    style={{ width: `${scrollPct}%` }}
                  />
                </div>
                <article ref={articleRef} style={{ fontFamily: 'Merriweather, serif' }}>
                  {paragraphs.length > 0 ? (
                    paragraphs.map((p, i) => (
                      <p key={i} className="text-lg text-[#5d5f5d] leading-relaxed mb-6">{p}</p>
                    ))
                  ) : (
                    <p className="text-sm text-[#8c716e] italic">Conteúdo não disponível.</p>
                  )}
                </article>
              </>
            ) : (
              <div className="bg-[#f6f3f2] rounded-xl p-12 text-center border border-[#e0bfbc]">
                <span className="material-symbols-outlined text-[#8B1A1A]/30 mb-4" style={{ fontSize: '80px' }}>lock</span>
                <h3 className="text-2xl font-bold text-[#1c1b1b] mb-2">Conteúdo Exclusivo Jindungo</h3>
                <p className="text-base text-[#5d5f5d] mb-6" style={{ fontFamily: 'Merriweather, serif' }}>
                  Este texto Jindungo requer uma conta de escritor, professor ou administrador para acesso completo.
                </p>
                {!user && (
                  <button
                    onClick={() => navigate('/cadastro')}
                    className="bg-[#8B1A1A] text-white px-8 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all"
                  >
                    Criar Conta Grátis
                  </button>
                )}
              </div>
            )}

            <div className="flex justify-between items-center mt-12 pt-8 border-t border-[#e0bfbc]">
              <button
                onClick={() => navigate('/explorar')}
                className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors text-sm font-semibold"
              >
                <span className="material-symbols-outlined text-[18px]">arrow_back</span>
                Mais artigos
              </button>
              <button
                onClick={() => navigate('/explorar')}
                className="flex items-center gap-2 text-[#8B1A1A] hover:opacity-80 transition-colors text-sm font-semibold"
              >
                Ver mais artigos
                <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
              </button>
            </div>
          </>
        ) : null}
      </div>
    </AppShell>
  )
}
