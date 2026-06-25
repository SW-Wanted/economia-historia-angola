import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { extractList } from '../services/types/api.types'
import type { Content } from '../services/types/api.types'

const FILTERS = ['Todos', 'História', 'Agricultura', 'Petróleo', 'Comércio', 'Arquivo']

function getContentRoute(content: Content): string {
  if (content.type === 'VIDEO' || content.type === 'PODCAST' || content.type === 'AUDIO') return '/aula-video'
  if (content.type === 'PDF') return '/documento/detalhe'
  if (content.isJindungo || content.type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

function getContentTypeLabel(type: string): string {
  const labels: Record<string, string> = {
    VIDEO: 'Aula em Vídeo',
    PODCAST: 'Podcast',
    AUDIO: 'Áudio',
    TEXT: 'Microtexto',
    MICROTEXT: 'Microtexto',
    PDF: 'Arquivo',
    ARTICLE: 'Análise',
  }
  return labels[type] ?? type
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
      .list({ limit: 20 })
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
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        <div className="mb-10">
          <h2 className="text-[40px] font-extrabold mb-3 leading-tight text-[#1c1b1b] tracking-tight font-sans">Explorar Conteúdos</h2>
          <p className="text-sm text-[#5d5f5d] max-w-2xl font-serif leading-relaxed">
            Mergulhe na complexa tapeçaria económica de Angola através de análises profundas, dados históricos e perspectivas setoriais.
          </p>
        </div>

        {/* Filters */}
        <div className="flex flex-wrap items-center gap-2 mb-10">
          {FILTERS.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-5 py-2 rounded-full text-sm font-semibold font-sans transition-all duration-150 active:scale-[0.98] ${
                activeFilter === f
                  ? 'bg-[#8B1A1A] text-white shadow-xs'
                  : 'bg-white border border-[#ebe5e4] text-[#4a4a4a] hover:border-[#8B1A1A]/40 hover:text-[#8B1A1A]'
              }`}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Loading */}
        {loading && (
          <div className="grid grid-cols-12 gap-5">
            {Array.from({ length: 6 }).map((_, i) => (
              <div key={i} className={`${i % 3 === 0 ? 'col-span-12 md:col-span-8' : 'col-span-12 md:col-span-4'} bg-white rounded-xl h-56 border border-[#ebe5e4] animate-pulse`} />
            ))}
          </div>
        )}

        {/* Error */}
        {!loading && error && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
            <span className="material-symbols-outlined text-red-400 text-3xl mb-2 block">error_outline</span>
            <p className="text-sm text-red-700 font-sans">{error}</p>
            <button
              onClick={() => { setLoading(true); contentService.list({ limit: 20 }).then((r) => setContents(extractList(r))).catch(() => setError('Erro ao carregar.')).finally(() => setLoading(false)) }}
              className="mt-3 text-xs font-semibold text-red-700 hover:underline"
            >
              Tentar novamente
            </button>
          </div>
        )}

        {/* Empty */}
        {!loading && !error && filtered.length === 0 && (
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">search_off</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Nenhum conteúdo encontrado para este filtro.</p>
          </div>
        )}

        {/* Content grid */}
        {!loading && !error && filtered.length > 0 && (
          <div className="grid grid-cols-12 gap-5">
            {filtered.map((content, idx) => {
              const isFeatured = idx % 3 === 0
              const isVideo = content.type === 'VIDEO' || content.type === 'PODCAST' || content.type === 'AUDIO'
              const isArchive = content.type === 'PDF'
              const route = getContentRoute(content)
              const typeLabel = getContentTypeLabel(content.type)
              const span = isFeatured ? 'col-span-12 md:col-span-8' : 'col-span-12 md:col-span-4'

              if (isFeatured) {
                return (
                  <article
                    key={content.id}
                    onClick={() => navigate(route, { state: { contentId: content.id } })}
                    className={`${span} bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex flex-col md:flex-row group`}
                  >
                    <div className="md:w-1/2 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center min-h-[200px]">
                      <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '90px' }}>history_edu</span>
                    </div>
                    <div className="md:w-1/2 p-7 flex flex-col justify-center">
                      <span className="text-[#8B1A1A] text-[10px] font-bold mb-2 tracking-[0.1em] uppercase font-sans">{content.category?.name ?? typeLabel}</span>
                      <h3 className="text-xl font-bold mb-3 text-[#1c1b1b] font-sans leading-snug">{content.title}</h3>
                      {content.summary && <p className="text-sm text-[#5d5f5d] mb-5 font-serif leading-relaxed line-clamp-3">{content.summary}</p>}
                      <div className="flex items-center gap-2">
                        <span className="material-symbols-outlined text-[#8B1A1A] text-[16px]">person</span>
                        <span className="text-xs text-[#8c716e]">{content.author?.name}</span>
                      </div>
                    </div>
                  </article>
                )
              }

              if (isArchive) {
                return (
                  <article
                    key={content.id}
                    onClick={() => navigate(route, { state: { contentId: content.id } })}
                    className={`${span} bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex flex-col group`}
                  >
                    <div className="h-44 bg-[#8B1A1A] flex items-center justify-center">
                      <span className="material-symbols-outlined text-white/30 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '52px' }}>history_edu</span>
                    </div>
                    <div className="p-5 flex flex-col flex-grow">
                      <div className="flex justify-between items-start mb-2.5">
                        <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">Arquivo</span>
                        <span className="text-[#b8a5a3] text-xs">{content.author?.name}</span>
                      </div>
                      <h3 className="text-base font-semibold mb-2 text-[#1c1b1b] font-sans leading-snug">{content.title}</h3>
                      {content.summary && <p className="text-sm text-[#5d5f5d] line-clamp-3 flex-grow font-serif leading-relaxed">{content.summary}</p>}
                      <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold font-sans flex items-center gap-1">
                        Ver Arquivo <span className="material-symbols-outlined text-[16px]">download</span>
                      </div>
                    </div>
                  </article>
                )
              }

              if (isVideo) {
                return (
                  <article
                    key={content.id}
                    onClick={() => navigate(route, { state: { contentId: content.id } })}
                    className={`${span} bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex flex-col group`}
                  >
                    <div className="h-44 bg-[#1c1b1b] flex items-center justify-center overflow-hidden relative">
                      <div className="absolute inset-0 bg-gradient-to-br from-[#8B1A1A]/25 to-transparent" />
                      <span className="material-symbols-outlined text-white/25 group-hover:scale-105 transition-transform duration-300 relative z-10" style={{ fontSize: '64px', fontVariationSettings: "'FILL' 1" }}>play_circle</span>
                    </div>
                    <div className="p-5 flex flex-col flex-grow">
                      <div className="flex justify-between items-start mb-2.5">
                        <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">{typeLabel}</span>
                        {content.durationSeconds && <span className="text-[#b8a5a3] text-xs">{Math.round(content.durationSeconds / 60)} min</span>}
                      </div>
                      <h3 className="text-base font-semibold mb-2 text-[#1c1b1b] font-sans leading-snug">{content.title}</h3>
                      {content.summary && <p className="text-sm text-[#5d5f5d] line-clamp-3 flex-grow font-serif leading-relaxed">{content.summary}</p>}
                      <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold font-sans flex items-center gap-1">
                        Ver Aula <span className="material-symbols-outlined text-[16px]">play_arrow</span>
                      </div>
                    </div>
                  </article>
                )
              }

              return (
                <article
                  key={content.id}
                  onClick={() => navigate(route, { state: { contentId: content.id } })}
                  className={`${span} bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex flex-col group`}
                >
                  <div className="h-44 bg-gradient-to-br from-[#f0eded] to-[#e8e2e1] flex items-center justify-center overflow-hidden">
                    <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '64px' }}>article</span>
                  </div>
                  <div className="p-5 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2.5">
                      <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">{content.category?.name ?? typeLabel}</span>
                      <span className="text-[#b8a5a3] text-xs">{content.author?.name}</span>
                    </div>
                    <h3 className="text-base font-semibold mb-2 text-[#1c1b1b] font-sans leading-snug">{content.title}</h3>
                    {content.summary && <p className="text-sm text-[#5d5f5d] line-clamp-3 flex-grow font-serif leading-relaxed">{content.summary}</p>}
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold font-sans flex items-center gap-1">
                      Ler Agora <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
                    </div>
                  </div>
                </article>
              )
            })}

            {/* Static quote card */}
            <article className="col-span-12 md:col-span-4 bg-[#8B1A1A] rounded-xl p-7 flex flex-col justify-center text-white shadow-card">
              <span className="material-symbols-outlined text-3xl mb-4 opacity-60" style={{ fontVariationSettings: "'FILL' 1" }}>format_quote</span>
              <blockquote className="text-base italic mb-5 leading-relaxed font-serif">
                "A economia de amanhã é construída sobre as fundações das lições que decidimos ignorar no passado."
              </blockquote>
              <cite className="text-xs not-italic text-white/60 font-sans">— Análise Editorial, 2024</cite>
            </article>
          </div>
        )}
      </div>
    </AppShell>
  )
}
