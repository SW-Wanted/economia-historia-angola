import { useState, useEffect, useCallback, useRef } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { commentsService } from '../services/api/comments.service'
import { useAuth } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content, Comment } from '../services/types/api.types'

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 2) return 'agora mesmo'
  if (mins < 60) return `há ${mins} min`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `há ${hours}h`
  return `há ${Math.floor(hours / 24)}d`
}

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

  const [comments, setComments] = useState<Comment[]>([])
  const [commentsLoading, setCommentsLoading] = useState(false)
  const [commentText, setCommentText] = useState('')
  const [commentSubmitting, setCommentSubmitting] = useState(false)
  const [commentError, setCommentError] = useState('')

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

  useEffect(() => {
    if (!contentId) return
    setCommentsLoading(true)
    commentsService.listForContent(contentId)
      .then((data) => setComments(Array.isArray(data) ? data : []))
      .catch(() => {})
      .finally(() => setCommentsLoading(false))
  }, [contentId])

  async function handleComment(e: React.FormEvent) {
    e.preventDefault()
    if (!contentId || !commentText.trim()) return
    setCommentSubmitting(true)
    setCommentError('')
    try {
      const newComment = await commentsService.create({ text: commentText.trim(), contentId, visibility: 'PUBLIC' })
      setComments((prev) => [newComment, ...prev])
      setCommentText('')
    } catch (err: unknown) {
      setCommentError(getErrorMessage(err))
    } finally {
      setCommentSubmitting(false)
    }
  }

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

            {/* Comments */}
            <section className="mt-8 card p-6">
              <h2 className="text-headline-md font-bold text-text font-sans mb-5 flex items-center gap-2">
                <span className="material-symbols-outlined text-[20px] text-primary">chat_bubble_outline</span>
                Comentários
                {!commentsLoading && comments.length > 0 && (
                  <span className="text-label-lg text-secondary font-body font-normal ml-1">({comments.length})</span>
                )}
              </h2>

              {user ? (
                <form onSubmit={handleComment} className="mb-6">
                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 rounded-full bg-gradient-to-br from-primary/20 to-primary/8 border border-primary/20 flex items-center justify-center flex-shrink-0 mt-0.5">
                      <span className="text-[10px] font-bold text-primary font-sans">
                        {user.name?.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase() ?? 'EU'}
                      </span>
                    </div>
                    <div className="flex-1 flex flex-col gap-2">
                      <textarea
                        rows={3}
                        placeholder="Partilhe a sua opinião sobre esta aula..."
                        value={commentText}
                        onChange={(e) => setCommentText(e.target.value)}
                        className="input resize-none text-sm"
                      />
                      {commentError && <p className="text-xs text-error font-body">{commentError}</p>}
                      <div className="flex justify-end">
                        <button
                          type="submit"
                          disabled={commentSubmitting || !commentText.trim()}
                          className="btn-primary text-sm disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                          {commentSubmitting ? (
                            <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                          ) : (
                            <><span className="material-symbols-outlined text-[16px]">send</span>Comentar</>
                          )}
                        </button>
                      </div>
                    </div>
                  </div>
                </form>
              ) : (
                <div className="alert-info rounded-card mb-6">
                  <span className="material-symbols-outlined text-primary text-[18px] flex-shrink-0">info</span>
                  <p className="text-body-md text-secondary font-body">
                    <button onClick={() => navigate('/entrar')} className="font-bold text-primary hover:underline">
                      Inicie sessão
                    </button>{' '}para comentar.
                  </p>
                </div>
              )}

              {commentsLoading ? (
                <div className="space-y-4">
                  {[0, 1].map((i) => (
                    <div key={i} className="flex gap-3">
                      <div className="skeleton w-9 h-9 rounded-full flex-shrink-0" />
                      <div className="flex-1 space-y-2">
                        <div className="skeleton h-3 w-28 rounded" />
                        <div className="skeleton h-4 w-full rounded" />
                      </div>
                    </div>
                  ))}
                </div>
              ) : comments.length === 0 ? (
                <div className="text-center py-8">
                  <span className="material-symbols-outlined text-primary/25 text-[36px] mb-2 block">chat_bubble_outline</span>
                  <p className="text-body-md text-secondary font-body">Seja o primeiro a comentar esta aula.</p>
                </div>
              ) : (
                <div className="flex flex-col divide-y divide-outline-variant/20">
                  {comments.map((comment) => (
                    <div key={comment.id} className="py-4 first:pt-0">
                      <div className="flex items-start gap-3">
                        <div className="w-8 h-8 rounded-full bg-surface-container border border-outline-variant/40 flex items-center justify-center flex-shrink-0">
                          <span className="text-[9px] font-bold text-primary font-sans">
                            {comment.author?.name?.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase() ?? '?'}
                          </span>
                        </div>
                        <div className="flex-1">
                          <div className="flex items-baseline gap-2 mb-1">
                            <span className="text-sm font-bold text-text font-sans">{comment.author?.name ?? 'Utilizador'}</span>
                            <span className="text-[11px] text-secondary font-body">{timeAgo(comment.createdAt)}</span>
                          </div>
                          <p className="text-body-md text-text font-reading leading-relaxed">{comment.text}</p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </section>

            <div className="flex gap-3 mt-6">
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
