import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { userService } from '../services/api/user.service'
import { contentService } from '../services/api/content.service'
import { getErrorMessage } from '../utils/errors'
import type { Favorite } from '../services/types/api.types'

function getContentTypeRoute(type: string): string {
  if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
  if (type === 'PDF') return '/documento/detalhe'
  if (type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

function typeLabel(type: string): string {
  const labels: Record<string, string> = {
    VIDEO: 'Vídeo', PODCAST: 'Podcast', TEXT: 'Texto', MICROTEXT: 'Microtexto',
    PDF: 'PDF', ARTICLE: 'Artigo', AUDIO: 'Áudio',
  }
  return labels[type] ?? type
}

export default function MeusFavoritos() {
  const navigate = useNavigate()
  const [favorites, setFavorites] = useState<Favorite[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [removingId, setRemovingId] = useState<string | null>(null)
  const [search, setSearch] = useState('')

  useEffect(() => {
    userService.getMyFavorites()
      .then((data) => setFavorites(Array.isArray(data) ? data : []))
      .catch((err) => setError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [])

  async function handleRemove(contentId: string, e: React.MouseEvent) {
    e.stopPropagation()
    setRemovingId(contentId)
    try {
      await contentService.favorite(contentId)
      setFavorites((prev) => prev.filter((f) => f.contentId !== contentId))
    } catch {
      // ignore
    } finally {
      setRemovingId(null)
    }
  }

  const filtered = favorites.filter((f) =>
    !search.trim() || f.content.title.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <AppShell searchPlaceholder="Pesquisar favoritos...">
      <div className="page-content animate-fade-in">
        <div className="section-header mb-8">
          <div>
            <h2 className="section-title">Favoritos</h2>
            <p className="section-subtitle">Os seus conteúdos guardados para leitura posterior.</p>
          </div>
          <button onClick={() => navigate('/explorar')} className="btn-primary">
            <span className="material-symbols-outlined text-[18px]">add</span>
            Explorar Arquivo
          </button>
        </div>

        {/* Search */}
        {!loading && favorites.length > 0 && (
          <div className="relative mb-6 max-w-sm">
            <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-outline text-[18px]">search</span>
            <input
              type="text"
              placeholder="Filtrar favoritos..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="input pl-10"
            />
          </div>
        )}

        {loading ? (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
            {[0, 1, 2, 3, 4, 5].map((i) => (
              <div key={i} className="skeleton h-56 rounded-card" />
            ))}
          </div>
        ) : error ? (
          <div className="alert-error rounded-card">
            <span className="material-symbols-outlined text-error text-[18px] flex-shrink-0"
              style={{ fontVariationSettings: "'FILL' 1" }}>error</span>
            <p className="text-body-md text-error font-body">{error}</p>
          </div>
        ) : favorites.length === 0 ? (
          <div className="empty-state py-20">
            <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/30 text-[36px]">bookmark</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Nenhum favorito ainda</p>
            <p className="text-body-md text-secondary font-body max-w-sm text-center leading-relaxed">
              Explore o arquivo e clique em{' '}
              <span className="material-symbols-outlined text-[13px] align-middle mx-0.5">bookmark</span>
              {' '}para guardar artigos para depois.
            </p>
            <button onClick={() => navigate('/explorar')} className="btn-primary">
              <span className="material-symbols-outlined text-[18px]">explore</span>
              Explorar Conteúdos
            </button>
          </div>
        ) : filtered.length === 0 ? (
          <div className="empty-state py-16">
            <span className="material-symbols-outlined text-primary/30 text-[36px]">search_off</span>
            <p className="text-headline-md font-bold text-text font-sans">Sem resultados</p>
            <p className="text-body-md text-secondary font-body">Nenhum favorito corresponde à pesquisa.</p>
            <button onClick={() => setSearch('')} className="btn-ghost">Limpar pesquisa</button>
          </div>
        ) : (
          <>
            <p className="text-sm text-secondary font-body mb-5">
              {filtered.length} {filtered.length === 1 ? 'item guardado' : 'itens guardados'}
            </p>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
              {filtered.map((fav) => (
                <div
                  key={fav.contentId}
                  onClick={() => navigate(getContentTypeRoute(fav.content.type), { state: { contentId: fav.content.id } })}
                  className="content-card group cursor-pointer"
                >
                  {/* Thumbnail */}
                  <div className="h-32 relative overflow-hidden bg-gradient-to-br from-surface-container to-surface-container-high flex items-center justify-center">
                    {fav.content.thumbnailUrl ? (
                      <img
                        src={fav.content.thumbnailUrl}
                        alt={fav.content.title}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                    ) : (
                      <span
                        className="material-symbols-outlined text-primary/20 group-hover:scale-105 transition-transform duration-300"
                        style={{ fontSize: '40px' }}
                      >
                        history_edu
                      </span>
                    )}
                    {/* Remove button */}
                    <button
                      onClick={(e) => handleRemove(fav.contentId, e)}
                      disabled={removingId === fav.contentId}
                      className="absolute top-2 right-2 w-7 h-7 rounded-full bg-surface/90 backdrop-blur-sm flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-150 hover:bg-error/10 hover:text-error text-secondary"
                      title="Remover dos favoritos"
                    >
                      {removingId === fav.contentId ? (
                        <span className="w-3 h-3 border border-current border-t-transparent rounded-full animate-spin" />
                      ) : (
                        <span className="material-symbols-outlined text-[14px]"
                          style={{ fontVariationSettings: "'FILL' 1" }}>bookmark_remove</span>
                      )}
                    </button>
                  </div>

                  <div className="p-4 flex flex-col gap-2 flex-grow">
                    <span className="badge-primary w-fit">{typeLabel(fav.content.type)}</span>
                    <h4 className="text-title-md font-semibold text-text font-sans leading-snug line-clamp-2 group-hover:text-primary transition-colors">
                      {fav.content.title}
                    </h4>
                    <p className="mt-auto text-[11px] text-secondary font-body pt-2">
                      Guardado {new Date(fav.createdAt).toLocaleDateString('pt-PT', { day: 'numeric', month: 'short' })}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </AppShell>
  )
}
