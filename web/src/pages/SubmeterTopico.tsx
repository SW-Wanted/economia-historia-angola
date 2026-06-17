import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { forumService, slugify } from '../services/api/forum.service'
import type { Forum } from '../services/types/api.types'

const CATEGORIES = ['Microtextos', 'Economia Colonial', 'Pós-Independência', 'Arquivos Históricos', 'Jindungo']

export default function SubmeterTopico() {
  const navigate = useNavigate()
  const [forums, setForums] = useState<Forum[]>([])
  const [title, setTitle] = useState('')
  const [category, setCategory] = useState('')
  const [body, setBody] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    forumService.listForums().then((data) => {
      setForums(Array.isArray(data) ? data : [])
    }).catch(() => {})
  }, [])

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
        slug: slugify(title.trim()),
        body: body.trim(),
        visibility: 'PUBLIC',
      })
      navigate('/forum')
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Erro ao publicar tópico. Tente novamente.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <AppShell title="Novo Tópico" showSearch={false}>
      <div className="px-10 py-16 max-w-[800px] mx-auto">
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        <div className="bg-white rounded-xl p-10 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-2">Submeter Novo Tópico</h1>
          <p className="text-base text-[#5d5f5d] mb-8 font-serif">
            Partilhe a sua investigação ou inicie um debate com a comunidade.
          </p>

          <form className="space-y-6" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Título do Tópico</label>
              <input
                type="text"
                placeholder="Ex: O impacto do café na economia do Huambo..."
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all font-serif"
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Categoria</label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]"
              >
                <option value="">Selecione uma categoria</option>
                {CATEGORIES.map((c) => <option key={c}>{c}</option>)}
              </select>
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Conteúdo</label>
              <textarea
                rows={8}
                placeholder="Desenvolva o seu tópico aqui. Seja específico e fundamentado nas fontes..."
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
                onClick={() => navigate('/forum')}
                className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={loading || forums.length === 0}
                className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all active:scale-95 flex items-center justify-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {loading ? (
                  <>
                    <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    A publicar...
                  </>
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
