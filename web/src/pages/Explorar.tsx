import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { extractList } from '../services/types/api.types'
import type { Content } from '../services/types/api.types'

const FILTERS = ['Todos', 'História', 'Agricultura', 'Petróleo', 'Comércio', 'Arquivo']

const TYPE_CONFIG: Record<string, { label: string; icon: string; color: string }> = {
  VIDEO:     { label: 'Aula em Vídeo', icon: 'play_circle',  color: 'navy' },
  PODCAST:   { label: 'Podcast',       icon: 'podcasts',     color: 'navy' },
  AUDIO:     { label: 'Áudio',         icon: 'headphones',   color: 'navy' },
  TEXT:      { label: 'Microtexto',    icon: 'article',      color: 'primary' },
  MICROTEXT: { label: 'Microtexto',    icon: 'article',      color: 'primary' },
  PDF:       { label: 'Arquivo',       icon: 'description',  color: 'tertiary' },
  ARTICLE:   { label: 'Análise',       icon: 'history_edu',  color: 'primary' },
}

function getContentRoute(content: Content): string {
  if (content.type === 'VIDEO' || content.type === 'PODCAST' || content.type === 'AUDIO') return '/aula-video'
  if (content.type === 'PDF') return '/documento/detalhe'
  if (content.isJindungo || content.type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

function TypeBadge({ type }: { type: string }) {
  const cfg = TYPE_CONFIG[type] ?? { label: type, icon: 'article', color: 'primary' }
  const colorClass = cfg.color === 'navy' ? 'badge-navy' : cfg.color === 'tertiary' ? 'bg-tertiary/10 text-tertiary' : 'badge-primary'
  return <span className={`badge ${colorClass}`}>{cfg.label}</span>
}

function ContentThumbnail({ content, size = 'md' }: { content: Content; size?: 'sm' | 'md' | 'lg' }) {
  const cfg = TYPE_CONFIG[content.type] ?? { icon: 'article', color: 'primary' }
  const heightClass = size === 'lg' ? 'h-56' : size === 'md' ? 'h-44' : 'h-36'
  const isVideo = content.type === 'VIDEO' || content.type === 'PODCAST' || content.type === 'AUDIO'
  const isArchive = content.type === 'PDF'

  if (content.thumbnailUrl) {
    return (
      <div className={`w-full ${heightClass} overflow-hidden`}>
        <img src={content.thumbnailUrl} alt={content.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
      </div>
    )
  }

  if (isVideo) {
    return (
      <div className={`w-full ${heightClass} bg-navy flex items-center justify-center relative overflow-hidden`}>
        <div className="absolute inset-0 opacity-20"
          style={{ backgroundImage: 'radial-gradient(circle at 30% 40%, rgba(255,255,255,0.3) 0%, transparent 60%)' }} />
        <div className="w-14 h-14 rounded-full bg-white/15 flex items-center justify-center border border-white/20 group-hover:scale-110 transition-transform duration-300">
          <span className="material-symbols-outlined text-white text-[28px]"
            style={{ fontVariationSettings: "'FILL' 1" }}>play_arrow</span>
        </div>
      </div>
    )
  }

  if (isArchive) {
    return (
      <div className={`w-full ${heightClass} flex items-center justify-center relative overflow-hidden`}
        style={{ background: 'linear-gradient(135deg, #4A2800 0%, #7A4800 100%)' }}>
        <div className="absolute inset-0 opacity-10"
          style={{ backgroundImage: 'radial-gradient(circle at 70% 30%, white 0%, transparent 50%)' }} />
        <span className="material-symbols-outlined text-white/25 group-hover:scale-105 transition-transform duration-300"
          style={{ fontSize: '52px', fontVariationSettings: "'FILL' 1" }}>description</span>
      </div>
    )
  }

  return (
    <div className={`w-full ${heightClass} relative overflow-hidden`}
      style={{ background: 'linear-gradient(135deg, #F7DEDA 0%, #E8CECA 100%)' }}>
      <div className="absolute inset-0 opacity-[0.06]"
        style={{ backgroundImage: 'radial-gradient(#8B1A1A 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
      <div className="absolute inset-0 flex items-center justify-center">
        <span className="material-symbols-outlined text-primary/20 group-hover:scale-105 transition-transform duration-300"
          style={{ fontSize: size === 'lg' ? '72px' : '52px' }}>
          {cfg.icon}
        </span>
      </div>
    </div>
  )
}

export default function Explorar() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos')
  const [contents, setContents] = useState<Content[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    setLoading(true)
    setError('')
    contentService
      .list({ limit: 24 })
      .then((res) => setContents(extractList(res)))
      .catch(() => setError('Não foi possível carregar os conteúdos. Tente novamente.'))
      .finally(() => setLoading(false))
  }, [])

  const filtered = activeFilter === 'Todos'
    ? contents
    : contents.filter((c) =>
        c.category?.name?.toLowerCase()?.includes(activeFilter.toLowerCase()) ||
        c.tags.some((t) => t.tag.name?.toLowerCase()?.includes(activeFilter.toLowerCase()))
      )

  return (
    <AppShell searchPlaceholder="Pesquisar por eras, setores ou eventos...">
      <div className="page-content animate-fade-in">

        {/* Page header */}
        <div className="mb-8">
          <h1 className="text-display-web font-extrabold text-text font-sans tracking-tighter leading-tight">
            Explorar Arquivo
          </h1>
          <p className="text-body-lg text-secondary font-body mt-2 max-w-xl leading-relaxed">
            Artigos, análises, documentos e aulas sobre a história económica de Angola.
          </p>
        </div>

        {/* Filters */}
        <div className="flex flex-wrap items-center gap-2 mb-8">
          {FILTERS.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={activeFilter === f ? 'filter-chip-active' : 'filter-chip-inactive'}
            >
              {f}
            </button>
          ))}
          <span className="ml-auto text-label-lg text-secondary font-body">
            {!loading && !error && `${filtered.length} resultado${filtered.length !== 1 ? 's' : ''}`}
          </span>
        </div>

        {/* Loading */}
        {loading && (
          <div className="grid grid-cols-12 gap-5">
            {[8, 4, 4, 4, 8].map((span, i) => (
              <div key={i} className={`col-span-12 md:col-span-${span} skeleton rounded-card`} style={{ height: i % 2 === 0 ? 280 : 240 }} />
            ))}
          </div>
        )}

        {/* Error */}
        {!loading && error && (
          <div className="alert-error rounded-card p-6 text-center flex-col">
            <span className="material-symbols-outlined text-error/60 text-4xl mb-2 block">error_outline</span>
            <p className="text-sm text-error font-body mb-3">{error}</p>
            <button
              onClick={() => { setLoading(true); contentService.list({ limit: 24 }).then((r) => setContents(extractList(r))).catch(() => setError('Erro ao carregar.')).finally(() => setLoading(false)) }}
              className="btn-secondary text-error border-error/40 hover:bg-error/5"
            >
              Tentar novamente
            </button>
          </div>
        )}

        {/* Empty */}
        {!loading && !error && filtered.length === 0 && (
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">search_off</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Nenhum resultado</p>
            <p className="text-body-md text-secondary font-body max-w-xs">
              Não encontrámos conteúdos para "{activeFilter}". Tente outro filtro.
            </p>
            <button onClick={() => setActiveFilter('Todos')} className="btn-secondary">
              Ver todos os conteúdos
            </button>
          </div>
        )}

        {/* Content grid */}
        {!loading && !error && filtered.length > 0 && (
          <div className="grid grid-cols-12 gap-5">
            {filtered.map((content, idx) => {
              const isFeatured = idx % 7 === 0
              const route = getContentRoute(content)

              if (isFeatured) {
                return (
                  <article
                    key={content.id}
                    onClick={() => navigate(route, { state: { contentId: content.id } })}
                    className="col-span-12 md:col-span-8 card overflow-hidden cursor-pointer group hover:shadow-card-hover hover:-translate-y-0.5 hover:border-outline-variant/55 transition-all duration-200 flex flex-col md:flex-row"
                  >
                    <div className="md:w-5/12 flex-shrink-0 overflow-hidden">
                      <ContentThumbnail content={content} size="lg" />
                    </div>
                    <div className="flex-1 p-7 flex flex-col justify-between">
                      <div>
                        <div className="flex items-center gap-2 mb-3">
                          <TypeBadge type={content.type} />
                          {content.category?.name && (
                            <span className="text-[11px] text-secondary font-body">{content.category.name}</span>
                          )}
                        </div>
                        <h3 className="text-headline-xl font-bold text-text font-sans leading-snug mb-3 group-hover:text-primary transition-colors duration-150">
                          {content.title}
                        </h3>
                        {content.summary && (
                          <p className="text-body-md text-secondary font-reading leading-relaxed line-clamp-3">{content.summary}</p>
                        )}
                      </div>
                      <div className="flex items-center gap-3 mt-5 pt-4 border-t border-outline-variant/20">
                        {content.author && (
                          <>
                            <div className="w-7 h-7 rounded-full bg-surface-container border border-outline-variant/40 flex items-center justify-center flex-shrink-0">
                              <span className="text-[9px] font-bold text-primary font-sans leading-none">
                                {content.author.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
                              </span>
                            </div>
                            <span className="text-sm font-semibold text-text font-sans">{content.author.name}</span>
                          </>
                        )}
                        <span className="ml-auto text-sm font-semibold text-primary font-sans flex items-center gap-1">
                          Ler agora <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
                        </span>
                      </div>
                    </div>
                  </article>
                )
              }

              return (
                <article
                  key={content.id}
                  onClick={() => navigate(route, { state: { contentId: content.id } })}
                  className="col-span-12 md:col-span-4 content-card group"
                >
                  <div className="overflow-hidden">
                    <ContentThumbnail content={content} size="md" />
                  </div>
                  <div className="p-5 flex flex-col flex-grow">
                    <div className="flex items-start justify-between gap-2 mb-3">
                      <TypeBadge type={content.type} />
                      {content.author && (
                        <span className="text-[11px] text-secondary font-body truncate">{content.author.name}</span>
                      )}
                    </div>
                    <h3 className="text-title-lg font-semibold text-text font-sans leading-snug mb-2 group-hover:text-primary transition-colors duration-150">
                      {content.title}
                    </h3>
                    {content.summary && (
                      <p className="text-body-md text-secondary font-reading line-clamp-2 flex-grow leading-relaxed">{content.summary}</p>
                    )}
                    <div className="mt-4 pt-3 border-t border-outline-variant/20 flex items-center justify-between">
                      {content.category?.name ? (
                        <span className="text-[11px] text-secondary font-body">{content.category.name}</span>
                      ) : <span />}
                      <span className="text-sm font-semibold text-primary font-sans flex items-center gap-1">
                        {content.type === 'PDF' ? 'Ver' : content.type === 'VIDEO' ? 'Assistir' : 'Ler'}
                        <span className="material-symbols-outlined text-[16px]">chevron_right</span>
                      </span>
                    </div>
                  </div>
                </article>
              )
            })}

            {/* Editorial pull quote */}
            <article className="col-span-12 md:col-span-4 rounded-card overflow-hidden flex flex-col justify-end min-h-[280px] relative"
              style={{ background: 'linear-gradient(145deg, #8B1A1A 0%, #5A1010 100%)' }}>
              <div className="absolute inset-0 opacity-[0.04]"
                style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
              <div className="relative z-10 p-7">
                <span className="material-symbols-outlined text-4xl mb-4 text-white/30 block"
                  style={{ fontVariationSettings: "'FILL' 1" }}>format_quote</span>
                <blockquote className="text-base italic leading-relaxed text-white/85 mb-4 font-reading">
                  "A economia de amanhã é construída sobre as fundações das lições que decidimos ignorar no passado."
                </blockquote>
                <cite className="text-[11px] not-italic text-white/45 font-body tracking-wide">— Análise Editorial, 2024</cite>
              </div>
            </article>
          </div>
        )}
      </div>
    </AppShell>
  )
}
