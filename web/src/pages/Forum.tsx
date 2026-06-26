import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { forumService } from '../services/api/forum.service'
import type { Topic, Forum } from '../services/types/api.types'

const FILTERS = ['Todos os Tópicos', 'Microtextos', 'Economia Colonial', 'Pós-Independência', 'Arquivos Históricos']

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 60) return `${mins}m`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours}h`
  const days = Math.floor(hours / 24)
  return `${days}d`
}

function AuthorAvatar({ name }: { name: string }) {
  const initials = name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()
  const hue = name.split('').reduce((acc, c) => acc + c.charCodeAt(0), 0) % 360
  return (
    <div
      className="w-9 h-9 rounded-full flex items-center justify-center flex-shrink-0 text-white text-[11px] font-bold font-sans"
      style={{ background: `hsl(${hue}, 35%, 45%)` }}
    >
      {initials}
    </div>
  )
}

export default function Forum() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos os Tópicos')
  const [forums, setForums] = useState<Forum[]>([])
  const [topics, setTopics] = useState<Topic[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const PAGE_SIZE = 8

  useEffect(() => {
    async function load() {
      setLoading(true)
      setError('')
      try {
        const forumList = await forumService.listForums()
        const fList = Array.isArray(forumList) ? forumList : []
        setForums(fList)
        if (fList.length === 0) { setTopics([]); return }
        const results = await Promise.all(fList.slice(0, 3).map((f) => forumService.listTopics(f.id).catch(() => [] as Topic[])))
        const all: Topic[] = results.flat()
        all.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
        setTopics(all)
      } catch {
        setError('Não foi possível carregar os tópicos.')
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
    <AppShell title="Fórum" searchPlaceholder="Pesquisar tópicos ou autores...">
      <div className="page-content animate-fade-in">

        {/* Header */}
        <div className="flex items-start justify-between mb-8">
          <div>
            <h1 className="text-display-web font-extrabold text-text font-sans tracking-tighter leading-tight">Comunidade</h1>
            <p className="text-body-lg text-secondary font-body mt-2">
              Debate, partilha e aprende com outros investigadores.
            </p>
          </div>
          <button
            onClick={() => navigate('/forum/novo-topico')}
            className="btn-primary flex-shrink-0 mt-1"
          >
            <span className="material-symbols-outlined text-[18px]">add</span>
            Novo Tópico
          </button>
        </div>

        {/* Stats row */}
        <div className="grid grid-cols-3 gap-4 mb-8">
          {[
            { icon: 'forum',   label: 'Tópicos Activos',  value: loading ? '…' : String(forums.length > 0 ? topics.length : 0) },
            { icon: 'groups',  label: 'Fóruns',            value: loading ? '…' : String(forums.length) },
            { icon: 'comment', label: 'Respostas Totais',  value: loading ? '…' : String(topics.reduce((acc, t) => acc + (t._count?.replies ?? 0), 0)) },
          ].map((s) => (
            <div key={s.label} className="card p-4 flex items-center gap-4">
              <div className="w-10 h-10 rounded-xl bg-primary/8 flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined text-primary text-[20px]">{s.icon}</span>
              </div>
              <div>
                <p className="text-headline-lg font-bold text-text font-sans leading-none">{s.value}</p>
                <p className="text-label-md uppercase tracking-wider text-secondary font-sans mt-0.5">{s.label}</p>
              </div>
            </div>
          ))}
        </div>

        {/* Filters */}
        <div className="flex gap-2 overflow-x-auto pb-1 mb-6">
          {FILTERS.map((f) => (
            <button
              key={f}
              onClick={() => { setActiveFilter(f); setPage(1) }}
              className={activeFilter === f ? 'filter-chip-active' : 'filter-chip-inactive'}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Loading */}
        {loading && (
          <div className="flex flex-col gap-3">
            {[0, 1, 2, 3].map((i) => (
              <div key={i} className="skeleton h-24 rounded-card" />
            ))}
          </div>
        )}

        {/* Error */}
        {!loading && error && (
          <div className="alert-error rounded-card p-6 text-center flex-col">
            <p className="text-sm text-error font-body">{error}</p>
          </div>
        )}

        {/* Empty */}
        {!loading && !error && forums.length === 0 && (
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">forum</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Nenhum fórum disponível</p>
            <p className="text-body-md text-secondary font-body">Os fóruns ainda estão a ser configurados.</p>
          </div>
        )}

        {/* Topics */}
        {!loading && !error && forums.length > 0 && (
          <>
            {paginated.length === 0 ? (
              <div className="empty-state">
                <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
                  <span className="material-symbols-outlined text-primary/40 text-[30px]">search_off</span>
                </div>
                <p className="text-headline-md font-bold text-text font-sans">Sem tópicos neste filtro</p>
                <button onClick={() => setActiveFilter('Todos os Tópicos')} className="btn-secondary">
                  Ver todos os tópicos
                </button>
              </div>
            ) : (
              <div className="flex flex-col gap-2.5">
                {paginated.map((topic, idx) => {
                  const replies = topic._count?.replies ?? 0
                  const isHot = replies >= 5
                  return (
                    <div
                      key={topic.id}
                      onClick={() => navigate('/forum/detalhe', { state: { topic } })}
                      className="topic-card group"
                    >
                      <div className="flex items-start gap-4">
                        <AuthorAvatar name={topic.author.name} />
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap mb-1.5">
                            {topic.category && (
                              <span className="badge-primary">{topic.category.name}</span>
                            )}
                            {isHot && (
                              <span className="badge" style={{ background: 'rgba(180,83,9,0.10)', color: '#B45309' }}>
                                <span className="material-symbols-outlined text-[10px] mr-0.5">local_fire_department</span>
                                Em destaque
                              </span>
                            )}
                            <span className="text-[11px] text-secondary font-body ml-auto flex-shrink-0">
                              {timeAgo(topic.createdAt)}
                            </span>
                          </div>
                          <h3 className="text-title-lg font-semibold text-text group-hover:text-primary transition-colors duration-150 font-sans leading-snug mb-1.5">
                            {topic.title}
                          </h3>
                          <p className="text-body-md text-secondary font-reading line-clamp-2 leading-relaxed">
                            {topic.body}
                          </p>
                          <div className="flex items-center gap-4 mt-3">
                            <span className="text-sm font-semibold text-text font-sans">{topic.author.name}</span>
                            <div className="flex items-center gap-1.5 text-secondary">
                              <span className="material-symbols-outlined text-[15px]">chat_bubble_outline</span>
                              <span className="text-[12px] font-body">
                                {replies} {replies === 1 ? 'resposta' : 'respostas'}
                              </span>
                            </div>
                            <div className="ml-auto text-secondary hover:text-primary transition-colors duration-150 opacity-0 group-hover:opacity-100">
                              <span className="material-symbols-outlined text-[18px]">chevron_right</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  )
                })}
              </div>
            )}

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex justify-center items-center gap-1.5 pt-8">
                <button
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="btn-icon disabled:opacity-40 disabled:cursor-not-allowed border border-outline-variant/40"
                >
                  <span className="material-symbols-outlined text-[18px]">chevron_left</span>
                </button>
                {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
                  <button
                    key={p}
                    onClick={() => setPage(p)}
                    className={`w-9 h-9 flex items-center justify-center rounded-lg font-bold text-sm font-sans transition-all duration-150 ${
                      p === page
                        ? 'bg-primary text-white shadow-xs'
                        : 'border border-outline-variant/40 bg-surface text-secondary hover:bg-surface-container-low'
                    }`}
                  >
                    {p}
                  </button>
                ))}
                <button
                  onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                  disabled={page === totalPages}
                  className="btn-icon disabled:opacity-40 disabled:cursor-not-allowed border border-outline-variant/40"
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
