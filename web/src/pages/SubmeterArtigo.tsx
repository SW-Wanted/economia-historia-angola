import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { slugify } from '../services/api/forum.service'
import { extractList } from '../services/types/api.types'
import type { ContentType } from '../services/types/api.types'
import { getErrorMessage } from '../utils/errors'
import { useAuth, canPublishContent } from '../contexts/AuthContext'
import FileUpload from '../components/ui/FileUpload'
import {
  IMAGE_CONSTRAINTS,
  DOCUMENT_CONSTRAINTS,
  VIDEO_CONSTRAINTS,
  AUDIO_CONSTRAINTS,
  type FileConstraints,
} from '../services/api/upload.service'

type FormType = 'Microtexto' | 'Jindungo' | 'Documento de Arquivo' | 'Vídeo' | 'Podcast'

const TYPE_MAP: Record<FormType, { type: ContentType; isJindungo?: boolean }> = {
  'Microtexto': { type: 'MICROTEXT' },
  'Jindungo': { type: 'ARTICLE', isJindungo: true },
  'Documento de Arquivo': { type: 'PDF' },
  'Vídeo': { type: 'VIDEO' },
  'Podcast': { type: 'AUDIO' },
}

// Configuração do ficheiro principal exigido por cada tipo de conteúdo.
const MEDIA_CONFIG: Partial<
  Record<FormType, { label: string; hint: string; variant: 'image' | 'document'; constraints: FileConstraints }>
> = {
  'Documento de Arquivo': { label: 'Ficheiro PDF', hint: 'PDF ou Word · máx. 15 MB', variant: 'document', constraints: DOCUMENT_CONSTRAINTS },
  'Vídeo': { label: 'Ficheiro de Vídeo', hint: 'MP4, WebM ou MOV · máx. 200 MB', variant: 'document', constraints: VIDEO_CONSTRAINTS },
  'Podcast': { label: 'Ficheiro de Áudio', hint: 'MP3, WAV ou OGG · máx. 50 MB', variant: 'document', constraints: AUDIO_CONSTRAINTS },
}

// Tipos que dispensam corpo de texto (o conteúdo é o próprio ficheiro).
const MEDIA_ONLY: FormType[] = ['Vídeo', 'Podcast']

interface Category { id: string; name: string; slug: string }

export default function SubmeterArtigo() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const isPublisher = canPublishContent(user)
  const [contentType, setContentType] = useState<FormType>('Microtexto')
  const [title, setTitle] = useState('')
  const [body, setBody] = useState('')
  const [summary, setSummary] = useState('')
  const [categoryId, setCategoryId] = useState('')
  const [thumbnailUrl, setThumbnailUrl] = useState<string | null>(null)
  const [mediaUrl, setMediaUrl] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [categories, setCategories] = useState<Category[]>([])

  const mediaConfig = MEDIA_CONFIG[contentType]
  const isMediaOnly = MEDIA_ONLY.includes(contentType)

  useEffect(() => {
    contentService.list({ limit: 50 })
      .then((res) => {
        const items = extractList(res)
        const seen = new Set<string>()
        const cats: Category[] = []
        for (const item of items) {
          if (item.category && !seen.has(item.category.id)) {
            seen.add(item.category.id)
            cats.push(item.category)
          }
        }
        setCategories(cats)
      })
      .catch(() => {})
  }, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!title.trim()) { setError('O título é obrigatório.'); return }
    if (!isMediaOnly && !body.trim()) { setError('O conteúdo é obrigatório.'); return }
    if (mediaConfig && !mediaUrl) { setError(`Anexe o ${mediaConfig.label.toLowerCase()}.`); return }

    const mapped = TYPE_MAP[contentType]
    setLoading(true)
    try {
      await contentService.create({
        title: title.trim(),
        slug: slugify(title.trim()) + '-' + Date.now().toString(36),
        type: mapped.type,
        summary: summary.trim() || undefined,
        body: body.trim() || undefined,
        visibility: mapped.isJindungo ? 'AUTHENTICATED' : 'PUBLIC',
        isJindungo: mapped.isJindungo,
        categoryId: categoryId || undefined,
        thumbnailUrl: thumbnailUrl || undefined,
        mediaUrl: mediaUrl || undefined,
      })
      navigate('/confirmacao/publicacao', { state: { isPublisher } })
    } catch (err: unknown) {
      setError(getErrorMessage(err))
    } finally {
      setLoading(false)
    }
  }

  return (
    <AppShell title="Submeter Artigo" showSearch={false}>
      <div className="page-content-narrow animate-fade-in">
        <button
          onClick={() => navigate('/gestao/conteudos')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar à Gestão
        </button>

        <div className="card p-8">
          <h1 className="text-headline-md font-bold text-text mb-2 font-sans">
            {isPublisher ? 'Criar Novo Conteúdo' : 'Submeter Novo Artigo'}
          </h1>
          <p className="text-body-md font-body text-secondary mb-8">
            {isPublisher
              ? 'Crie conteúdo para o arquivo histórico. É guardado como rascunho e pode ser submetido para revisão ou publicado no painel de gestão.'
              : 'Contribua com o seu conhecimento para o arquivo histórico de Angola.'}
          </p>

          <form className="space-y-6" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-2">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Tipo de Conteúdo</label>
              <div className="flex gap-4 flex-wrap">
                {(['Microtexto', 'Jindungo', 'Documento de Arquivo', 'Vídeo', 'Podcast'] as FormType[]).map((type) => (
                  <label key={type} className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="radio"
                      name="type"
                      value={type}
                      checked={contentType === type}
                      onChange={() => { setContentType(type); setMediaUrl(null); setError('') }}
                      className="accent-primary"
                    />
                    <span className="text-sm font-semibold text-text font-sans">{type}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Título</label>
              <input
                type="text"
                placeholder="Título do artigo..."
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
                className="input"
              />
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                Resumo <span className="text-outline normal-case font-normal">(opcional)</span>
              </label>
              <input
                type="text"
                placeholder="Breve resumo do artigo..."
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
                className="input"
              />
            </div>

            {categories.length > 0 && (
              <div className="flex flex-col gap-1.5">
                <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">
                  Categoria <span className="text-outline normal-case font-normal">(opcional)</span>
                </label>
                <select
                  value={categoryId}
                  onChange={(e) => setCategoryId(e.target.value)}
                  className="input"
                >
                  <option value="">Selecionar categoria...</option>
                  {categories.map((cat) => (
                    <option key={cat.id} value={cat.id}>{cat.name}</option>
                  ))}
                </select>
              </div>
            )}

            {/* Ficheiro principal (vídeo, áudio ou documento), conforme o tipo. */}
            {mediaConfig && (
              <FileUpload
                key={contentType}
                id="content-media"
                label={mediaConfig.label}
                hint={mediaConfig.hint}
                variant={mediaConfig.variant}
                constraints={mediaConfig.constraints}
                onUploaded={(result) => setMediaUrl(result?.publicUrl ?? null)}
                disabled={loading}
              />
            )}

            {/* Imagem de capa (miniatura) — apresentada na listagem e na página do conteúdo. */}
            <FileUpload
              id="content-thumbnail"
              label="Imagem de Capa (opcional)"
              hint="JPG, PNG, WebP ou GIF · máx. 5 MB"
              variant="image"
              constraints={IMAGE_CONSTRAINTS}
              existingUrl={thumbnailUrl}
              onUploaded={(result) => setThumbnailUrl(result?.publicUrl ?? null)}
              disabled={loading}
            />

            {!isMediaOnly && (
              <div className="flex flex-col gap-1.5">
                <label className="text-label-md font-sans text-text-muted uppercase tracking-[0.05em]">Conteúdo</label>
                <textarea
                  rows={10}
                  placeholder="Escreva o conteúdo do artigo aqui..."
                  value={body}
                  onChange={(e) => setBody(e.target.value)}
                  className="input resize-none"
                />
              </div>
            )}

            {error && (
              <div className="alert-error rounded-button">
                <span className="material-symbols-outlined text-error text-[16px]">error_outline</span>
                <p className="text-sm text-error font-body">{error}</p>
              </div>
            )}

            <div className="flex gap-4 pt-4">
              <button
                type="button"
                onClick={() => navigate('/gestao/conteudos')}
                className="btn-secondary flex-1 justify-center"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={loading}
                className="btn-primary flex-1 justify-center disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <>
                    <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    A submeter...
                  </>
                ) : (
                  <>
                    {isPublisher ? 'Criar Conteúdo' : 'Submeter para Revisão'}
                    <span className="material-symbols-outlined text-[18px]">{isPublisher ? 'save' : 'send'}</span>
                  </>
                )}
              </button>
            </div>
          </form>
        </div>
      </div>
    </AppShell>
  )
}
