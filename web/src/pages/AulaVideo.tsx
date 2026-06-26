import { useState, useEffect, useCallback, useRef } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content } from '../services/types/api.types'

function formatDuration(secs: number | null): string {
  if (!secs) return '—'
  const m = Math.floor(secs / 60)
  const s = secs % 60
  return `${m}:${String(s).padStart(2, '0')}`
}

export default function AulaVideo() {
  const navigate = useNavigate()
  const location = useLocation()
  const { user } = useAuth()
  const contentId = (location.state as { contentId?: string } | null)?.contentId

  const [content, setContent] = useState<Content | null>(null)
  const [loading, setLoading] = useState(!!contentId)
  const [error, setError] = useState('')
  const progressReported = useRef(false)

  const reportProgress = useCallback(
    (pct: number) => {
      if (!contentId || !user || progressReported.current) return
      progressReported.current = true
      contentService.updateProgress(contentId, pct).catch(() => {})
    },
    [contentId, user],
  )

  useEffect(() => {
    if (!contentId) return
    contentService
      .get(contentId)
      .then((c) => {
        setContent(c)
        reportProgress(10)
      })
      .catch((err) => setError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [contentId, reportProgress])

  if (loading) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow space-y-5">
          <div className="skeleton h-5 w-28 rounded" />
          <div className="skeleton h-10 w-2/3 rounded-lg" />
          <div className="skeleton rounded-card" style={{ aspectRatio: '16/9' }} />
          <div className="skeleton h-32 rounded-card" />
        </div>
      </AppShell>
    )
  }

  if (error) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-primary/30 text-[30px]">play_circle</span>
          </div>
          <p className="text-body-md font-body text-secondary mb-6">{error}</p>
          <button onClick={() => navigate('/explorar')} className="btn-primary mx-auto">Voltar ao Arquivo</button>
        </div>
      </AppShell>
    )
  }

  const title = content?.title ?? 'Aula em Vídeo'
  const summary = content?.summary ?? ''
  const typeLabel = content?.type === 'PODCAST' ? 'Podcast'
    : content?.type === 'AUDIO' ? 'Áudio'
    : 'Aula em Vídeo'
  const typeIcon = content?.type === 'PODCAST' || content?.type === 'AUDIO' ? 'headphones' : 'play_circle'
  const duration = content?.durationSeconds ?? null
  const mediaUrl = content?.mediaUrl

  return (
    <AppShell showSearch={false}>
      <div className="page-content-narrow animate-fade-in">
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {!contentId && !content ? (
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">play_circle</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Nenhum vídeo selecionado</p>
            <p className="text-body-md text-secondary font-body">Selecione um vídeo no arquivo para o reproduzir aqui.</p>
            <button onClick={() => navigate('/explorar')} className="btn-primary">Ir para o Arquivo</button>
          </div>
        ) : (
          <>
            {/* Meta */}
            <div className="flex items-center gap-2.5 flex-wrap mb-4">
              <span className="badge-primary flex items-center gap-1">
                <span className="material-symbols-outlined text-[12px]">{typeIcon}</span>
                {typeLabel}
              </span>
              {duration && (
                <span className="text-[12px] text-secondary font-body flex items-center gap-1">
                  <span className="material-symbols-outlined text-[13px]">schedule</span>
                  {formatDuration(duration)}
                </span>
              )}
              {content?.category && <span className="badge-outline">{content.category.name}</span>}
            </div>

            <h1 className="text-display-lg font-extrabold text-text font-sans tracking-tight leading-tight mb-2">
              {title}
            </h1>
            {content?.author && (
              <p className="text-body-md text-secondary font-body mb-7">
                Por <strong className="text-text font-sans">{content.author.name}</strong>
              </p>
            )}

            {/* Media player */}
            <div className="rounded-card overflow-hidden border border-outline-variant/20 shadow-card mb-7">
              {mediaUrl ? (
                content?.type === 'VIDEO' ? (
                  <video
                    src={mediaUrl}
                    controls
                    className="w-full aspect-video bg-black"
                    onPlay={() => reportProgress(10)}
                    onEnded={() => reportProgress(100)}
                  />
                ) : (
                  <div className="bg-[#1A0808] p-10 flex flex-col items-center gap-5">
                    <div className="w-20 h-20 rounded-2xl bg-white/8 border border-white/10 flex items-center justify-center">
                      <span className="material-symbols-outlined text-white/50 text-[40px]"
                        style={{ fontVariationSettings: "'FILL' 1" }}>headphones</span>
                    </div>
                    <audio
                      src={mediaUrl}
                      controls
                      className="w-full max-w-lg"
                      onPlay={() => reportProgress(10)}
                      onEnded={() => reportProgress(100)}
                    />
                  </div>
                )
              ) : (
                <div className="aspect-video flex items-center justify-center relative overflow-hidden"
                  style={{ background: 'linear-gradient(135deg, #1A0808 0%, #2A1010 100%)' }}>
                  <div className="absolute inset-0 opacity-[0.03]"
                    style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
                  <div className="z-10 text-center">
                    <div className="w-20 h-20 rounded-full bg-white/8 border border-white/10 flex items-center justify-center mx-auto mb-4">
                      <span className="material-symbols-outlined text-white/40 text-[40px]"
                        style={{ fontVariationSettings: "'FILL' 1" }}>play_circle</span>
                    </div>
                    <p className="text-white/40 text-sm font-body">Ficheiro de vídeo não disponível</p>
                  </div>
                </div>
              )}
            </div>

            {/* Description */}
            {summary && (
              <div className="card p-6 mb-6">
                <h2 className="text-title-lg font-bold text-text font-sans mb-3">Sobre esta Aula</h2>
                <p className="text-body-lg text-secondary font-reading leading-relaxed">{summary}</p>
              </div>
            )}

            <div className="flex gap-3">
              <button onClick={() => navigate('/forum')} className="btn-secondary">
                <span className="material-symbols-outlined text-[18px]">forum</span>
                Discutir
              </button>
              <button onClick={() => navigate('/explorar')} className="btn-primary">
                <span className="material-symbols-outlined text-[18px]">explore</span>
                Mais Conteúdos
              </button>
            </div>
          </>
        )}
      </div>
    </AppShell>
  )
}
