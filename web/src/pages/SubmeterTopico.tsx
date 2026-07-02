import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { forumService, slugify } from '../services/api/forum.service'
import type { Forum } from '../services/types/api.types'
import { getErrorMessage } from '../utils/errors'

export default function SubmeterTopico() {
  const navigate = useNavigate()
  const [forums, setForums] = useState<Forum[]>([])
  const [forumsLoading, setForumsLoading] = useState(true)
  const [forumsError, setForumsError] = useState(false)
  const [title, setTitle] = useState('')
  const [body, setBody] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    setForumsLoading(true)
    setForumsError(false)
    forumService.listForums()
      .then((data) => { setForums(Array.isArray(data) ? data : []) })
      .catch(() => { setForumsError(true); setForums([]) })
      .finally(() => setForumsLoading(false))
  }, [])

  const noForumsAvailable = !forumsLoading && !forumsError && forums.length === 0

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!title.trim()) { setError('O título é obrigatório.'); return }
    if (!body.trim()) { setError('O conteúdo é obrigatório.'); return }
    if (forums.length === 0) { setError('Nenhum fórum disponível para publicar. Tente mais tarde.'); return }
    setLoading(true)
    try {
      const forumId = forums[0].id
      await forumService.createTopic(forumId, {
        title: title.trim(),
        slug: slugify(title.trim()) + '-' + Date.now().toString(36),
        body: body.trim(),
        visibility: 'PUBLIC',
      })
      navigate('/forum')
    } catch (err: unknown) {
      setError(getErrorMessage(err))
    } finally {
      setLoading(false)
    }
  }

  function reloadForums() {
    setForumsLoading(true)
    setForumsError(false)
    forumService.listForums()
      .then((data) => setForums(Array.isArray(data) ? data : []))
      .catch(() => setForumsError(true))
      .finally(() => setForumsLoading(false))
  }

  return (
    <AppShell showSearch={false}>
      <div className="page-content-narrow animate-fade-in">
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-secondary hover:text-primary transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        <div className="card p-8">
          <div className="mb-8">
            <h1 className="text-headline-xl font-bold text-text font-sans tracking-tight mb-2">Novo Tópico</h1>
            <p className="text-body-md text-secondary font-body leading-relaxed">
              Partilhe a sua investigação ou inicie um debate com a comunidade académica.
            </p>
          </div>

          {forumsLoading && (
            <div className="alert-info rounded-button mb-6">
              <span className="w-4 h-4 border-2 border-primary border-t-transparent rounded-full animate-spin flex-shrink-0" />
              <p className="text-body-md text-secondary font-body">A verificar fóruns disponíveis...</p>
            </div>
          )}

          {forumsError && (
            <div className="alert-error rounded-card mb-6">
              <span className="material-symbols-outlined text-error text-[18px] flex-shrink-0">error</span>
              <div>
                <p className="text-sm font-bold text-error font-sans">Não foi possível carregar os fóruns</p>
                <p className="text-body-md text-secondary font-body mt-0.5">Verifique a sua ligação e tente novamente.</p>
                <button onClick={reloadForums} className="mt-2 text-xs font-bold text-error hover:underline font-sans">
                  Tentar novamente
                </button>
              </div>
            </div>
          )}

          {noForumsAvailable && (
            <div className="alert-info rounded-card mb-6">
              <span className="material-symbols-outlined text-primary text-[18px] flex-shrink-0">info</span>
              <div>
                <p className="text-sm font-bold text-text font-sans">Nenhum fórum disponível</p>
                <p className="text-body-md text-secondary font-body mt-0.5">
                  Os fóruns são criados pelo administrador da plataforma. Tente mais tarde.
                </p>
              </div>
            </div>
          )}

          <form className="space-y-5" onSubmit={handleSubmit}>
            <div>
              <label className="block text-label-lg text-text-muted font-sans mb-1.5">Título do Tópico</label>
              <input
                type="text"
                placeholder="Ex: O impacto do café na economia do Huambo..."
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
                className="input"
              />
            </div>

            <div>
              <label className="block text-label-lg text-text-muted font-sans mb-1.5">Conteúdo</label>
              <textarea
                rows={8}
                placeholder="Desenvolva o seu tópico aqui. Seja específico e fundamentado nas fontes..."
                value={body}
                onChange={(e) => setBody(e.target.value)}
                required
                className="input resize-none"
              />
            </div>

            {error && (
              <div className="alert-error rounded-button">
                <span className="material-symbols-outlined text-error text-[16px]">error_outline</span>
                <p className="text-sm text-error font-body">{error}</p>
              </div>
            )}

            <div className="flex gap-3 pt-2">
              <button type="button" onClick={() => navigate('/forum')} className="btn-secondary flex-1 justify-center">
                Cancelar
              </button>
              <button
                type="submit"
                disabled={loading || forumsLoading || forums.length === 0}
                className="btn-primary flex-1 justify-center disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <>
                    Publicar Tópico
                    <span className="material-symbols-outlined text-[18px]">send</span>
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
