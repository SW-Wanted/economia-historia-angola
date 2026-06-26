import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
import type { Content } from '../services/types/api.types'

export default function DetalheDocumento() {
  const navigate = useNavigate()
  const location = useLocation()
  const { user } = useAuth()
  const contentId = (location.state as { contentId?: string } | null)?.contentId

  const [content, setContent] = useState<Content | null>(null)
  const [loading, setLoading] = useState(!!contentId)
  const [error, setError] = useState('')
  const [saved, setSaved] = useState(false)
  const [savingFav, setSavingFav] = useState(false)

  useEffect(() => {
    if (!contentId) return
    contentService
      .get(contentId)
      .then(setContent)
      .catch((err) => setError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [contentId])

  async function toggleFavorite() {
    if (!contentId || !user) return
    setSavingFav(true)
    try {
      await contentService.favorite(contentId)
      setSaved((s) => !s)
    } catch {
      // ignore
    } finally {
      setSavingFav(false)
    }
  }

  if (loading) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow space-y-5">
          <div className="skeleton h-5 w-28 rounded" />
          <div className="skeleton h-10 w-2/3 rounded-lg" />
          <div className="skeleton h-56 rounded-card" />
          <div className="skeleton h-72 rounded-card" />
        </div>
      </AppShell>
    )
  }

  if (error) {
    return (
      <AppShell showSearch={false}>
        <div className="page-content-narrow text-center py-20">
          <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center mx-auto mb-4">
            <span className="material-symbols-outlined text-primary/30 text-[30px]">description</span>
          </div>
          <p className="text-body-md font-body text-secondary mb-6">{error}</p>
          <button onClick={() => navigate('/explorar')} className="btn-primary mx-auto">Voltar ao Arquivo</button>
        </div>
      </AppShell>
    )
  }

  const title = content?.title ?? 'Documento Histórico'
  const summary = content?.summary ?? ''
  const body = content?.body ?? ''
  const publishedAt = content?.publishedAt
    ? new Date(content.publishedAt).getFullYear()
    : content?.createdAt
    ? new Date(content.createdAt).getFullYear()
    : null
  const authorName = content?.author?.name
  const categoryName = content?.category?.name

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
              <span className="material-symbols-outlined text-primary/40 text-[30px]">description</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Nenhum documento selecionado</p>
            <p className="text-body-md text-secondary font-body">Selecione um documento no arquivo para o visualizar aqui.</p>
            <button onClick={() => navigate('/explorar')} className="btn-primary">Ir para o Arquivo</button>
          </div>
        ) : (
          <>
            {/* Document header card */}
            <div className="card p-7 mb-6">
              <div className="flex items-start gap-6">
                {/* Document icon */}
                <div className="w-16 h-20 rounded-xl flex items-center justify-center flex-shrink-0"
                  style={{ background: 'linear-gradient(135deg, #8B1A1A 0%, #5A1010 100%)' }}>
                  <span className="material-symbols-outlined text-white text-[32px]"
                    style={{ fontVariationSettings: "'FILL' 1" }}>description</span>
                </div>
                <div className="flex-grow min-w-0">
                  <div className="flex items-center gap-2.5 flex-wrap mb-3">
                    <span className="badge-primary">{categoryName ?? 'Documento'}</span>
                    {publishedAt && (
                      <span className="text-[12px] text-secondary font-body flex items-center gap-1">
                        <span className="material-symbols-outlined text-[13px]">calendar_today</span>
                        {publishedAt}
                      </span>
                    )}
                    {content?.tags?.slice(0, 2).map((t) => (
                      <span key={t.tag.id} className="badge-outline">{t.tag.name}</span>
                    ))}
                  </div>
                  <h1 className="text-headline-xl font-bold text-text font-sans tracking-tight leading-snug mb-3">
                    {title}
                  </h1>
                  {summary && (
                    <p className="text-body-lg text-secondary font-reading leading-relaxed mb-3">{summary}</p>
                  )}
                  {authorName && (
                    <p className="text-[12px] text-secondary font-body flex items-center gap-1.5">
                      <span className="material-symbols-outlined text-[14px]">person</span>
                      {authorName}
                    </p>
                  )}
                </div>
              </div>

              <div className="flex gap-3 mt-6 pt-5 border-t border-outline-variant/20 flex-wrap">
                {content?.mediaUrl ? (
                  <a
                    href={content.mediaUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="btn-primary"
                  >
                    <span className="material-symbols-outlined text-[18px]">download</span>
                    Descarregar PDF
                  </a>
                ) : (
                  <button disabled className="btn-primary opacity-50 cursor-not-allowed">
                    <span className="material-symbols-outlined text-[18px]">download</span>
                    PDF Indisponível
                  </button>
                )}
                <button
                  onClick={toggleFavorite}
                  disabled={savingFav || !user}
                  className={`btn-secondary disabled:opacity-50 ${saved ? 'bg-primary/8 border-primary text-primary' : ''}`}
                >
                  {savingFav ? (
                    <span className="w-4 h-4 border-2 border-primary/30 border-t-primary rounded-full animate-spin" />
                  ) : (
                    <span className="material-symbols-outlined text-[18px]"
                      style={saved ? { fontVariationSettings: "'FILL' 1" } : undefined}>bookmark</span>
                  )}
                  {saved ? 'Guardado' : 'Guardar'}
                </button>
                <button onClick={() => navigate('/forum')} className="btn-ghost">
                  <span className="material-symbols-outlined text-[18px]">forum</span>
                  Discutir
                </button>
              </div>
            </div>

            {/* Document body */}
            {body ? (
              <div className="card overflow-hidden mb-6">
                <div className="px-6 py-4 border-b border-outline-variant/20 flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-primary/8 flex items-center justify-center">
                    <span className="material-symbols-outlined text-primary text-[17px]">article</span>
                  </div>
                  <h2 className="text-title-lg font-bold text-text font-sans">Conteúdo do Documento</h2>
                </div>
                <div className="p-4 bg-surface-container-low">
                  <div className="bg-surface w-full p-8 shadow-xs rounded-xl">
                    <article className="prose-article">
                      {body.split(/\n{2,}/).filter(Boolean).map((p, i) => (
                        <p key={i}>{p}</p>
                      ))}
                    </article>
                  </div>
                </div>
              </div>
            ) : (
              <div className="alert-info rounded-card mb-6">
                <span className="material-symbols-outlined text-primary text-[18px]">info</span>
                <p className="text-body-md text-secondary font-body">
                  O conteúdo completo deste documento está disponível no ficheiro PDF.
                </p>
              </div>
            )}

            <div className="flex justify-between">
              <button onClick={() => navigate('/explorar')} className="btn-ghost">
                <span className="material-symbols-outlined text-[18px]">arrow_back</span>
                Mais documentos
              </button>
              <button onClick={() => navigate('/forum')} className="btn-secondary">
                <span className="material-symbols-outlined text-[18px]">forum</span>
                Discutir no Fórum
              </button>
            </div>
          </>
        )}
      </div>
    </AppShell>
  )
}
