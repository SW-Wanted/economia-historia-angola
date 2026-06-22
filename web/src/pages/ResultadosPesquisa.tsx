import { useState, useEffect } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { extractList } from '../services/types/api.types'
import type { Content } from '../services/types/api.types'

function getContentRoute(content: Content): string {
  if (content.type === 'VIDEO' || content.type === 'PODCAST' || content.type === 'AUDIO') return '/aula-video'
  if (content.type === 'PDF') return '/documento/detalhe'
  if (content.isJindungo || content.type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

function getTypeLabel(content: Content): string {
  if (content.isJindungo) return 'Jindungo'
  const labels: Record<string, string> = {
    VIDEO: 'Aula em Vídeo',
    PODCAST: 'Podcast',
    AUDIO: 'Áudio',
    TEXT: 'Microtexto',
    MICROTEXT: 'Microtexto',
    PDF: 'Arquivo',
    ARTICLE: 'Análise',
  }
  return labels[content.type] ?? content.type
}

export default function ResultadosPesquisa() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const query = searchParams.get('q') ?? ''

  const [results, setResults] = useState<Content[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    if (!query.trim()) return
    setLoading(true)
    setError('')
    contentService
      .list({ search: query.trim(), limit: 20 })
      .then((res) => setResults(extractList(res)))
      .catch(() => setError('Não foi possível carregar os resultados.'))
      .finally(() => setLoading(false))
  }, [query])

  return (
    <AppShell title="Resultados da Pesquisa" searchPlaceholder="Pesquisar arquivo...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[32px] font-bold text-[#1c1b1b] mb-1 font-sans">
            {query ? `Resultados para "${query}"` : 'Pesquisa'}
          </h2>
          {!loading && !error && (
            <p className="text-base text-[#5d5f5d] font-serif">
              {results.length} resultado{results.length !== 1 ? 's' : ''} encontrado{results.length !== 1 ? 's' : ''}
            </p>
          )}
        </div>

        {loading && (
          <div className="flex flex-col gap-4">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="bg-white rounded-xl h-24 border border-[#e0bfbc] animate-pulse" />
            ))}
          </div>
        )}

        {!loading && error && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
            <p className="text-sm text-red-700 font-sans">{error}</p>
          </div>
        )}

        {!loading && !error && results.length === 0 && query && (
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">search_off</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Nenhum resultado encontrado para "{query}".</p>
            <button
              onClick={() => navigate('/explorar')}
              className="mt-4 text-sm font-semibold text-[#8B1A1A] hover:underline font-sans"
            >
              Explorar todos os conteúdos
            </button>
          </div>
        )}

        {!loading && !error && results.length > 0 && (
          <div className="flex flex-col gap-4">
            {results.map((r) => {
              const typeLabel = getTypeLabel(r)
              const route = getContentRoute(r)
              return (
                <div
                  key={r.id}
                  onClick={() => navigate(route)}
                  className="bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer group flex items-start gap-5"
                >
                  <div className="w-12 h-12 bg-[#eae7e7] rounded-lg flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-[#8B1A1A]">
                      {r.type === 'PDF' ? 'description' : r.isJindungo ? 'nutrition' : 'article'}
                    </span>
                  </div>
                  <div className="flex-grow min-w-0">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full font-sans">
                        {typeLabel}
                      </span>
                      {r.category && (
                        <span className="text-xs text-[#5d5f5d] font-sans">{r.category.name}</span>
                      )}
                    </div>
                    <h3 className="text-xl font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors mb-1 font-sans">{r.title}</h3>
                    {r.summary && (
                      <p className="text-sm text-[#5d5f5d] line-clamp-2 font-serif">{r.summary}</p>
                    )}
                  </div>
                  <span className="material-symbols-outlined text-[#5d5f5d] group-hover:text-[#8B1A1A] transition-colors flex-shrink-0">chevron_right</span>
                </div>
              )
            })}
          </div>
        )}
      </div>
    </AppShell>
  )
}
