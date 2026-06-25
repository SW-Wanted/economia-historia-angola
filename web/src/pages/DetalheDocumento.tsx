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
      <AppShell title="Arquivo Digital" showSearch={false}>
        <div className="px-10 py-8 max-w-[900px] mx-auto space-y-5">
          <div className="h-8 bg-[#f0eded] rounded w-32 animate-pulse" />
          <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] h-52 animate-pulse" />
          <div className="bg-white rounded-xl border border-[#e0bfbc] h-72 animate-pulse" />
        </div>
      </AppShell>
    )
  }

  if (error) {
    return (
      <AppShell title="Arquivo Digital" showSearch={false}>
        <div className="px-10 py-16 max-w-[600px] mx-auto text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">description</span>
          <p className="text-sm text-[#5d5f5d] font-serif mb-5">{error}</p>
          <button onClick={() => navigate('/explorar')}
            className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all">
            Voltar ao Arquivo
          </button>
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
    <AppShell title="Arquivo Digital" showSearch={false}>
      <div className="px-10 py-8 max-w-[900px] mx-auto">
        <button onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {/* Document header */}
        <div className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
          <div className="flex items-start gap-6">
            <div className="w-20 h-24 bg-[#8B1A1A] rounded-lg flex items-center justify-center flex-shrink-0">
              <span className="material-symbols-outlined text-white text-4xl">description</span>
            </div>
            <div className="flex-grow">
              <div className="flex items-center gap-3 mb-3">
                <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold font-sans">
                  {categoryName ?? 'Documento Histórico'}
                </span>
                {publishedAt && <span className="text-xs text-[#5d5f5d]">{publishedAt}</span>}
              </div>
              <h1 className="text-[28px] font-bold text-[#1c1b1b] mb-3 font-sans">{title}</h1>
              {summary && (
                <p className="text-base text-[#5d5f5d] mb-4 font-serif leading-relaxed">{summary}</p>
              )}
              <div className="flex flex-wrap gap-4 text-xs text-[#5d5f5d]">
                {publishedAt && (
                  <span className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-[14px]">calendar_today</span>
                    {publishedAt}
                  </span>
                )}
                {authorName && (
                  <span className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-[14px]">person</span>
                    {authorName}
                  </span>
                )}
                {content?.tags?.slice(0, 2).map((t) => (
                  <span key={t.tag.id} className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-[14px]">label</span>
                    {t.tag.name}
                  </span>
                ))}
              </div>
            </div>
          </div>

          <div className="flex gap-3 mt-6 pt-6 border-t border-[#e0bfbc]">
            {content?.mediaUrl ? (
              <a
                href={content.mediaUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-3 rounded-full text-sm font-semibold hover:bg-[#7a1616] transition-all"
              >
                <span className="material-symbols-outlined text-[18px]">download</span>
                Descarregar PDF
              </a>
            ) : (
              <button
                disabled
                className="flex items-center gap-2 bg-[#8B1A1A]/40 text-white px-6 py-3 rounded-full text-sm font-semibold cursor-not-allowed"
                title="Ficheiro não disponível"
              >
                <span className="material-symbols-outlined text-[18px]">download</span>
                PDF Indisponível
              </button>
            )}
            <button
              onClick={toggleFavorite}
              disabled={savingFav || !user}
              className={`flex items-center gap-2 border px-6 py-3 rounded-full text-sm font-semibold transition-all ${
                saved
                  ? 'border-[#8B1A1A] text-[#8B1A1A] bg-[#8B1A1A]/5'
                  : 'border-[#e0bfbc] text-[#1c1b1b] hover:bg-[#f6f3f2]'
              } disabled:opacity-50`}
            >
              <span className="material-symbols-outlined text-[18px]" style={saved ? { fontVariationSettings: "'FILL' 1" } : undefined}>
                bookmark
              </span>
              {saved ? 'Guardado' : 'Guardar'}
            </button>
            <button
              onClick={() => navigate('/forum')}
              className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-6 py-3 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all"
            >
              <span className="material-symbols-outlined text-[18px]">forum</span>
              Discutir
            </button>
          </div>
        </div>

        {/* Document body */}
        {body && (
          <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
            <div className="p-6 border-b border-[#e0bfbc] flex items-center justify-between">
              <h2 className="text-xl font-bold text-[#1c1b1b] font-sans">Conteúdo do Documento</h2>
            </div>
            <div className="p-8 bg-[#f6f3f2]">
              <div className="bg-white w-full p-10 shadow-sm rounded font-serif">
                {body.split(/\n{2,}/).filter(Boolean).map((p, i) => (
                  <p key={i} className="text-sm text-[#5d5f5d] leading-relaxed mb-4">{p}</p>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* No contentId fallback */}
        {!contentId && !content && (
          <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] mb-6">
            <div className="p-8 bg-[#f6f3f2] min-h-[300px] flex items-center justify-center">
              <div className="text-center">
                <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">description</span>
                <p className="text-sm text-[#5d5f5d] font-serif">Selecione um documento no arquivo para o visualizar aqui.</p>
                <button
                  onClick={() => navigate('/explorar')}
                  className="mt-4 text-sm font-semibold text-[#8B1A1A] font-sans hover:underline"
                >
                  Ir para o Arquivo →
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </AppShell>
  )
}
