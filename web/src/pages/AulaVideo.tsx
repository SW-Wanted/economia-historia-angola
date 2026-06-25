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
      <AppShell title="Aula em Vídeo" showSearch={false}>
        <div className="px-10 py-8 max-w-[900px] mx-auto space-y-5">
          <div className="h-8 bg-[#f0eded] rounded w-32 animate-pulse" />
          <div className="h-8 bg-[#f0eded] rounded w-2/3 animate-pulse" />
          <div className="bg-[#1c1b1b] rounded-xl aspect-video animate-pulse" />
          <div className="bg-white rounded-xl h-32 border border-[#e0bfbc] animate-pulse" />
        </div>
      </AppShell>
    )
  }

  if (error) {
    return (
      <AppShell title="Aula em Vídeo" showSearch={false}>
        <div className="px-10 py-16 max-w-[600px] mx-auto text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">play_circle</span>
          <p className="text-sm text-[#5d5f5d] font-serif mb-5">{error}</p>
          <button onClick={() => navigate('/explorar')}
            className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all">
            Voltar ao Arquivo
          </button>
        </div>
      </AppShell>
    )
  }

  const title = content?.title ?? 'Aula em Vídeo'
  const summary = content?.summary ?? ''
  const typeLabel = content?.type === 'PODCAST' ? 'Podcast'
    : content?.type === 'AUDIO' ? 'Áudio'
    : 'Aula em Vídeo'
  const duration = content?.durationSeconds ?? null
  const mediaUrl = content?.mediaUrl

  return (
    <AppShell title="Aula em Vídeo" showSearch={false}>
      <div className="px-10 py-8 max-w-[900px] mx-auto">
        <button onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold font-sans">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        <div className="flex items-center gap-3 mb-4">
          <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold font-sans flex items-center gap-1">
            <span className="material-symbols-outlined text-[14px]">play_circle</span>
            {typeLabel}
          </span>
          {duration && <span className="text-xs text-[#5d5f5d]">{formatDuration(duration)}</span>}
          {content?.category && <span className="text-xs text-[#5d5f5d]">{content.category.name}</span>}
        </div>

        <h1 className="text-[36px] font-extrabold text-[#1c1b1b] mb-4 leading-tight font-sans tracking-tight">
          {title}
        </h1>

        {content?.author && (
          <p className="text-sm text-[#8c716e] mb-6 font-sans">Por {content.author.name}</p>
        )}

        {/* Media player */}
        {mediaUrl ? (
          <div className="mb-8 rounded-xl overflow-hidden border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.08)]">
            {content?.type === 'VIDEO' ? (
              <video
                src={mediaUrl}
                controls
                className="w-full aspect-video bg-[#1c1b1b]"
                onPlay={() => reportProgress(10)}
                onEnded={() => reportProgress(100)}
              />
            ) : (
              <div className="bg-[#1c1b1b] rounded-xl p-8 flex flex-col items-center gap-4">
                <span className="material-symbols-outlined text-white/30" style={{ fontSize: '64px', fontVariationSettings: "'FILL' 1" }}>
                  {content?.type === 'AUDIO' || content?.type === 'PODCAST' ? 'headphones' : 'play_circle'}
                </span>
                <audio src={mediaUrl} controls className="w-full max-w-lg" onPlay={() => reportProgress(10)} onEnded={() => reportProgress(100)} />
              </div>
            )}
          </div>
        ) : (
          <div className="bg-[#1c1b1b] rounded-xl aspect-video flex items-center justify-center mb-8 relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-[#8B1A1A]/20 to-transparent" />
            <div className="z-10 text-center">
              <span className="material-symbols-outlined text-white/30 block mb-3" style={{ fontSize: '64px', fontVariationSettings: "'FILL' 1" }}>play_circle</span>
              <p className="text-white/60 text-sm font-sans">Ficheiro de vídeo não disponível</p>
            </div>
          </div>
        )}

        <div className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <h2 className="text-xl font-bold text-[#1c1b1b] mb-3 font-sans">Sobre esta Aula</h2>
          {summary ? (
            <p className="text-base text-[#5d5f5d] leading-relaxed font-serif">{summary}</p>
          ) : (
            <p className="text-sm text-[#8c716e] font-serif italic">Sem descrição disponível.</p>
          )}
        </div>

        {!contentId && !content && (
          <div className="bg-[#fff8f7] border border-[#8B1A1A]/15 rounded-xl p-5 mb-6 flex items-start gap-3">
            <span className="material-symbols-outlined text-[#8B1A1A] text-[18px] mt-0.5">info</span>
            <p className="text-xs text-[#5d5f5d] font-serif">
              Selecione um vídeo no arquivo para o reproduzir aqui.
            </p>
          </div>
        )}

        <div className="flex gap-4">
          <button onClick={() => navigate('/forum')}
            className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-6 py-3 rounded-full text-sm font-semibold font-sans hover:bg-[#f6f3f2] transition-all">
            <span className="material-symbols-outlined text-[18px]">forum</span>
            Discutir
          </button>
          <button onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold font-sans hover:opacity-90 transition-all">
            <span className="material-symbols-outlined text-[18px]">explore</span>
            Mais Conteúdos
          </button>
        </div>
      </div>
    </AppShell>
  )
}
