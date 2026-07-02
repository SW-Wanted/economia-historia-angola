import { useState, useEffect } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { extractList } from '../services/types/api.types'
import { useAuthGate } from '../contexts/AuthGateContext'
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
    VIDEO: 'Aula em Vídeo', PODCAST: 'Podcast', AUDIO: 'Áudio',
    TEXT: 'Microtexto', MICROTEXT: 'Microtexto', PDF: 'Arquivo', ARTICLE: 'Análise',
  }
  return labels[content.type] ?? content.type
}

export default function ResultadosPesquisa() {
  const navigate = useNavigate()
  const { requireAuth } = useAuthGate()
  const [searchParams] = useSearchParams()
  const query = searchParams.get('q') ?? ''

  // Visitante pode pesquisar, mas abrir um resultado exige conta.
  function openResult(content: Content) {
    const route = getContentRoute(content)
    requireAuth(() => navigate(route, { state: { contentId: content.id } }), {
      title: 'Este conteúdo é para membros',
      message: 'Inicie sessão ou crie uma conta gratuita para abrir e ler este conteúdo.',
      icon: 'menu_book',
    })
  }

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
      <div className="page-content animate-fade-in">
        <div className="mb-8">
          <h2 className="text-headline-xl font-bold text-text font-sans tracking-tight mb-1">
            {query ? `Resultados para "${query}"` : 'Pesquisa'}
          </h2>
          {!loading && !error && (
            <p className="text-body-md font-body text-secondary">
              {results.length} resultado{results.length !== 1 ? 's' : ''} encontrado{results.length !== 1 ? 's' : ''}
            </p>
          )}
        </div>

        {loading && (
          <div className="flex flex-col gap-4">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="bg-surface rounded-card h-24 border border-outline-variant/45 animate-pulse" />
            ))}
          </div>
        )}

        {!loading && error && (
          <div className="bg-error-container/40 border border-error/20 rounded-card p-6 text-center">
            <p className="text-sm text-error font-body">{error}</p>
          </div>
        )}

        {!loading && !error && results.length === 0 && query && (
          <div className="bg-surface rounded-card p-10 border border-outline-variant/45 text-center">
            <span className="material-symbols-outlined text-primary/30 text-5xl mb-3 block">search_off</span>
            <p className="text-body-md font-body text-secondary">Nenhum resultado encontrado para "{query}".</p>
            <button
              onClick={() => navigate('/explorar')}
              className="mt-4 text-sm font-semibold text-primary hover:underline font-sans"
            >
              Explorar todos os conteúdos
            </button>
          </div>
        )}

        {!loading && !error && results.length > 0 && (
          <div className="flex flex-col gap-4">
            {results.map((r) => {
              const typeLabel = getTypeLabel(r)
              return (
                <div
                  key={r.id}
                  onClick={() => openResult(r)}
                  className="card-interactive p-6 group flex items-start gap-5"
                >
                  <div className="w-12 h-12 bg-surface-container rounded-lg flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-primary">
                      {r.type === 'PDF' ? 'description' : r.isJindungo ? 'nutrition' : 'article'}
                    </span>
                  </div>
                  <div className="flex-grow min-w-0">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="text-xs font-semibold text-primary bg-surface-container px-2 py-0.5 rounded-full font-sans">
                        {typeLabel}
                      </span>
                      {r.category && (
                        <span className="text-xs text-secondary font-body">{r.category.name}</span>
                      )}
                    </div>
                    <h3 className="text-xl font-semibold text-text group-hover:text-primary transition-colors mb-1 font-sans">{r.title}</h3>
                    {r.summary && (
                      <p className="text-sm text-secondary line-clamp-2 font-body">{r.summary}</p>
                    )}
                  </div>
                  <span className="material-symbols-outlined text-secondary group-hover:text-primary transition-colors flex-shrink-0">chevron_right</span>
                </div>
              )
            })}
          </div>
        )}
      </div>
    </AppShell>
  )
}
