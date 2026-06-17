import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { forumService } from '../services/api/forum.service'
import type { Topic, Forum } from '../services/types/api.types'

const FILTERS = ['Todos os Tópicos', 'Microtextos', 'Economia Colonial', 'Pós-Independência', 'Arquivos Históricos']

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 60) return `Há ${mins} min`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `Há ${hours} hora${hours > 1 ? 's' : ''}`
  const days = Math.floor(hours / 24)
  return `Há ${days} dia${days > 1 ? 's' : ''}`
}

export default function Forum() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos os Tópicos')
  const [forums, setForums] = useState<Forum[]>([])
  const [topics, setTopics] = useState<Topic[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const PAGE_SIZE = 5

  useEffect(() => {
    async function load() {
      setLoading(true)
      setError('')
      try {
        const forumList = await forumService.listForums()
        const fList = Array.isArray(forumList) ? forumList : []
        setForums(fList)
        if (fList.length === 0) { setTopics([]); return }
        // Fetch topics from all forums concurrently (capped at 3 to avoid N+1 blowout)
        const slice = fList.slice(0, 3)
        const results = await Promise.all(slice.map((f) => forumService.listTopics(f.id).catch(() => [] as Topic[])))
        const all: Topic[] = results.flat()
        all.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
        setTopics(all)
      } catch {
        setError('Não foi possível carregar os tópicos. Tente novamente.')
      } finally {
        setLoading(false)
      }
    }
    load()
  }, [])

  const filtered = activeFilter === 'Todos os Tópicos'
    ? topics
    : topics.filter((t) =>
        t.category?.name?.toLowerCase()?.includes(activeFilter.toLowerCase()) ||
        t.tags?.some((tag) => tag.tag.name?.toLowerCase()?.includes(activeFilter.toLowerCase()))
      )

  const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE))
  const paginated = filtered.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE)

  return (
    <AppShell title="Fórum de Discussão" searchPlaceholder="Pesquisar tópicos ou autores...">
      <div className="px-10 py-14 max-w-[1160px] mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[44px] font-extrabold text-[#8B1A1A] leading-tight tracking-tight font-sans">Comunidade</h2>
            <p className="text-sm text-[#5d5f5d] mt-1 font-serif">Debate, partilha e aprende com outros investigadores.</p>
          </div>
          <button
            onClick={() => navigate('/forum/novo-topico')}
            className="bg-[#8B1A1A] text-white px-5 py-2.5 rounded-full text-sm font-semibold flex items-center gap-2 hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 font-sans"
          >
            <span className="material-symbols-outlined text-[18px]">add</span>
            Novo Tópico
          </button>
        </div>

        {/* Filters */}
        <div className="flex gap-2 overflow-x-auto pb-1">
          {FILTERS.map((f) => (
            <button
              key={f}
              onClick={() => { setActiveFilter(f); setPage(1) }}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all duration-150 font-sans ${
                activeFilter === f
                  ? 'bg-[#8B1A1A] text-white shadow-xs'
                  : 'bg-white border border-[#e8e0de] text-[#5d5f5d] hover:border-[#8B1A1A]/40 hover:text-[#8B1A1A]'
              }`}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Loading */}
        {loading && (
          <div className="flex flex-col gap-3">
            {Array.from({ length: 3 }).map((_, i) => (
              <div key={i} className="bg-white rounded-xl h-24 border border-[#ebe5e4] animate-pulse" />
            ))}
          </div>
        )}

        {/* Error */}
        {!loading && error && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
            <p className="text-sm text-red-700 font-sans">{error}</p>
          </div>
        )}

        {/* No forums */}
        {!loading && !error && forums.length === 0 && (
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">forum</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Nenhum fórum disponível de momento.</p>
          </div>
        )}

        {/* Topics */}
        {!loading && !error && forums.length > 0 && (
          <>
            {paginated.length === 0 ? (
              <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
                <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">search_off</span>
                <p className="text-sm text-[#5d5f5d] font-serif">Nenhum tópico encontrado para este filtro.</p>
              </div>
            ) : (
              <div className="flex flex-col gap-3 mt-2">
                {paginated.map((topic) => (
                  <div
                    key={topic.id}
                    onClick={() => navigate('/forum/detalhe', { state: { topic } })}
                    className="bg-white px-5 py-4 rounded-xl border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 flex flex-col md:flex-row gap-4 items-start group cursor-pointer"
                  >
                    <div className="flex-shrink-0 w-10 h-10 rounded-lg bg-gradient-to-br from-[#f0eded] to-[#e8e0de] flex items-center justify-center">
                      <span className="text-xs font-bold text-[#8B1A1A] font-sans leading-none">
                        {topic.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('')}
                      </span>
                    </div>
                    <div className="flex-grow space-y-1.5 min-w-0">
                      <div className="flex items-center gap-2.5 flex-wrap">
                        {topic.category && (
                          <span className="px-2 py-0.5 bg-[#fff5f4] text-[#8B1A1A] rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">{topic.category.name}</span>
                        )}
                        <span className="text-[#b8a5a3] text-xs">{timeAgo(topic.createdAt)}</span>
                      </div>
                      <h3 className="text-base font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors duration-150 leading-snug font-sans">{topic.title}</h3>
                      <p className="text-sm text-[#5d5f5d] line-clamp-2 font-serif leading-relaxed">{topic.body}</p>
                      <div className="pt-1 flex items-center gap-4 text-[#8c716e] flex-wrap">
                        <span className="text-sm font-semibold text-[#1c1b1b] font-sans">{topic.author.name}</span>
                        <div className="flex items-center gap-1">
                          <span className="material-symbols-outlined text-[15px]">forum</span>
                          <span className="text-xs">{topic._count?.replies ?? 0} respostas</span>
                        </div>
                      </div>
                    </div>
                    <div className="self-center p-1.5 rounded-full text-[#c4b5b3] group-hover:text-[#8B1A1A] group-hover:bg-[#fff5f4] transition-all duration-150 flex-shrink-0">
                      <span className="material-symbols-outlined text-[20px]">chevron_right</span>
                    </div>
                  </div>
                ))}
              </div>
            )}

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex justify-center items-center gap-1.5 pt-6">
                <button
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="w-9 h-9 flex items-center justify-center rounded-lg border border-[#e8e0de] bg-white text-[#5d5f5d] hover:bg-[#f0eded] hover:border-[#d4c5c3] transition-all duration-150 disabled:opacity-40 disabled:cursor-not-allowed"
                >
                  <span className="material-symbols-outlined text-[18px]">chevron_left</span>
                </button>
                {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
                  <button
                    key={p}
                    onClick={() => setPage(p)}
                    className={`w-9 h-9 flex items-center justify-center rounded-lg font-bold text-sm font-sans transition-all duration-150 ${
                      p === page
                        ? 'bg-[#8B1A1A] text-white shadow-xs'
                        : 'border border-[#e8e0de] bg-white text-[#5d5f5d] hover:bg-[#f0eded]'
                    }`}
                  >
                    {p}
                  </button>
                ))}
                <button
                  onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                  disabled={page === totalPages}
                  className="w-9 h-9 flex items-center justify-center rounded-lg border border-[#e8e0de] bg-white text-[#5d5f5d] hover:bg-[#f0eded] hover:border-[#d4c5c3] transition-all duration-150 disabled:opacity-40 disabled:cursor-not-allowed"
                >
                  <span className="material-symbols-outlined text-[18px]">chevron_right</span>
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </AppShell>
  )
}
