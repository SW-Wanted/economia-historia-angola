import { useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { api } from '../services/api/client'
import type { Topic } from '../services/types/api.types'

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 60) return `Há ${mins} min`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `Há ${hours} hora${hours > 1 ? 's' : ''}`
  const days = Math.floor(hours / 24)
  return `Há ${days} dia${days > 1 ? 's' : ''}`
}

export default function ForumDetalhe() {
  const navigate = useNavigate()
  const location = useLocation()
  const topic = (location.state as { topic?: Topic } | null)?.topic ?? null

  const [replyBody, setReplyBody] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [replyError, setReplyError] = useState('')
  const [replySuccess, setReplySuccess] = useState(false)

  async function handleReply(e: React.FormEvent) {
    e.preventDefault()
    if (!replyBody.trim()) { setReplyError('A resposta não pode estar vazia.'); return }
    if (!topic) { setReplyError('Tópico não identificado. Volte ao fórum e tente novamente.'); return }

    setSubmitting(true)
    setReplyError('')
    try {
      await api.post(`/forums/topics/${topic.id}/replies`, { body: replyBody.trim() })
      setReplyBody('')
      setReplySuccess(true)
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Erro ao publicar resposta. Tente novamente.'
      setReplyError(msg)
    } finally {
      setSubmitting(false)
    }
  }

  if (!topic) {
    return (
      <AppShell title="Fórum" searchPlaceholder="Pesquisar no fórum...">
        <div className="px-10 py-10 max-w-[1160px] mx-auto">
          <button
            onClick={() => navigate('/forum')}
            className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Voltar ao Fórum
          </button>
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">forum</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Tópico não encontrado. Volte ao fórum e selecione um tópico.</p>
            <button onClick={() => navigate('/forum')} className="mt-4 text-sm font-semibold text-[#8B1A1A] hover:underline font-sans">
              Ir para o Fórum
            </button>
          </div>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell title="Fórum" searchPlaceholder="Pesquisar no fórum...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        {/* Back */}
        <button
          onClick={() => navigate('/forum')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Fórum
        </button>

        {/* Topic header */}
        <div className="bg-white rounded-xl p-7 border border-[#ebe5e4] shadow-card mb-6">
          <div className="flex items-center gap-2.5 mb-4">
            {topic.category && (
              <span className="px-2 py-0.5 bg-[#fff5f4] text-[#8B1A1A] rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">{topic.category.name}</span>
            )}
            <span className="text-[#b8a5a3] text-xs">{timeAgo(topic.createdAt)}</span>
          </div>
          <h1 className="text-[28px] font-bold text-[#1c1b1b] mb-4 font-sans tracking-tight leading-tight">{topic.title}</h1>
          <p className="text-sm text-[#5d5f5d] leading-relaxed mb-6 font-serif">{topic.body}</p>
          <div className="flex items-center gap-4 flex-wrap">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-full bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border border-[#ebe5e4] flex items-center justify-center flex-shrink-0">
                <span className="text-[10px] font-bold text-[#8B1A1A] font-sans">
                  {topic.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('')}
                </span>
              </div>
              <div>
                <span className="text-sm font-bold text-[#1c1b1b] font-sans">{topic.author.name}</span>
                <p className="text-[10px] text-[#8c716e] font-sans">Investigador</p>
              </div>
            </div>
            <div className="flex items-center gap-3 ml-auto text-[#5d5f5d]">
              <div className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-sm">
                <span className="material-symbols-outlined text-[16px]">forum</span>
                <span className="text-xs font-sans font-semibold">{topic._count?.replies ?? 0} respostas</span>
              </div>
            </div>
          </div>
        </div>

        {/* Backend issue note — no GET replies endpoint available */}
        <div className="bg-[#fff8f7] border border-[#8B1A1A]/15 rounded-xl p-4 mb-6 flex items-start gap-3">
          <span className="material-symbols-outlined text-[#8B1A1A] text-[18px] mt-0.5">info</span>
          <p className="text-xs text-[#5d5f5d] font-serif">
            O carregamento das respostas existentes requer um endpoint que ainda não está disponível no servidor. Pode submeter uma nova resposta abaixo.
          </p>
        </div>

        {/* Reply box */}
        <div className="bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card">
          <h3 className="text-base font-bold text-[#1c1b1b] mb-4 font-sans">Adicionar Resposta</h3>
          {replySuccess ? (
            <div className="flex items-center gap-3 text-emerald-700 bg-emerald-50 border border-emerald-200 rounded-lg p-4">
              <span className="material-symbols-outlined text-[20px]">check_circle</span>
              <p className="text-sm font-semibold font-sans">Resposta publicada com sucesso!</p>
            </div>
          ) : (
            <form onSubmit={handleReply}>
              <textarea
                rows={4}
                placeholder="Partilhe a sua perspectiva sobre este tema..."
                value={replyBody}
                onChange={(e) => setReplyBody(e.target.value)}
                className="w-full bg-[#f8f5f4] border border-[#ebe5e4] rounded-lg p-3.5 focus:bg-white focus:border-[#8B1A1A]/40 focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 resize-none text-sm font-serif placeholder:text-[#c4b5b3]"
              />
              {replyError && (
                <p className="mt-2 text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">{replyError}</p>
              )}
              <div className="flex justify-end mt-3">
                <button
                  type="submit"
                  disabled={submitting}
                  className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 flex items-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  {submitting ? (
                    <>
                      <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                      A publicar...
                    </>
                  ) : 'Publicar Resposta'}
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </AppShell>
  )
}
