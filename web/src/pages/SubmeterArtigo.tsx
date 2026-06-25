import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { slugify } from '../services/api/forum.service'
import type { ContentType } from '../services/types/api.types'
import { getErrorMessage } from '../utils/errors'
import { useAuth, canPublishContent } from '../contexts/AuthContext'

type FormType = 'Microtexto' | 'Jindungo' | 'Documento de Arquivo'

const TYPE_MAP: Record<FormType, { type: ContentType; isJindungo?: boolean }> = {
  'Microtexto': { type: 'MICROTEXT' },
  'Jindungo': { type: 'ARTICLE', isJindungo: true },
  'Documento de Arquivo': { type: 'PDF' },
}

export default function SubmeterArtigo() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const isPublisher = canPublishContent(user)
  const [contentType, setContentType] = useState<FormType>('Microtexto')
  const [title, setTitle] = useState('')
  const [body, setBody] = useState('')
  const [summary, setSummary] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!title.trim()) { setError('O título é obrigatório.'); return }
    if (!body.trim()) { setError('O conteúdo é obrigatório.'); return }

    const mapped = TYPE_MAP[contentType]
    setLoading(true)
    try {
      await contentService.create({
        title: title.trim(),
        slug: slugify(title.trim()) + '-' + Date.now().toString(36),
        type: mapped.type,
        summary: summary.trim() || undefined,
        body: body.trim(),
        // PUBLIC so content becomes visible in listings once an admin publishes it.
        // AUTHENTICATED was incorrectly filtering content out of all public endpoints.
        visibility: mapped.isJindungo ? 'AUTHENTICATED' : 'PUBLIC',
        isJindungo: mapped.isJindungo,
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
      <div className="px-10 py-8 max-w-[800px] mx-auto">
        <button onClick={() => navigate('/gestao/conteudos')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold">
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar à Gestão
        </button>

        <div className="bg-white rounded-xl p-10 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-2">
            {isPublisher ? 'Criar Novo Conteúdo' : 'Submeter Novo Artigo'}
          </h1>
          <p className="text-base text-[#5d5f5d] mb-8 font-serif">
            {isPublisher
              ? 'Crie conteúdo para o arquivo histórico. O conteúdo será guardado como rascunho — a publicação directa está em desenvolvimento.'
              : 'Contribua com o seu conhecimento para o arquivo histórico de Angola.'}
          </p>

          <form className="space-y-6" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Tipo de Conteúdo</label>
              <div className="flex gap-3">
                {(['Microtexto', 'Jindungo', 'Documento de Arquivo'] as FormType[]).map((type) => (
                  <label key={type} className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="radio"
                      name="type"
                      value={type}
                      checked={contentType === type}
                      onChange={() => setContentType(type)}
                      className="text-[#8B1A1A]"
                    />
                    <span className="text-sm font-semibold text-[#1c1b1b]">{type}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Título</label>
              <input
                type="text"
                placeholder="Título do artigo..."
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all font-serif"
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Resumo <span className="text-[#8c716e] font-normal">(opcional)</span></label>
              <input
                type="text"
                placeholder="Breve resumo do artigo..."
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all font-serif"
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Conteúdo</label>
              <textarea
                rows={10}
                placeholder="Escreva o conteúdo do artigo aqui..."
                value={body}
                onChange={(e) => setBody(e.target.value)}
                required
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all resize-none font-serif"
              />
            </div>

            {error && (
              <p className="text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">{error}</p>
            )}

            <div className="flex gap-4 pt-4">
              <button
                type="button"
                onClick={() => navigate('/gestao/conteudos')}
                className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={loading}
                className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all active:scale-95 flex items-center justify-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed"
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
