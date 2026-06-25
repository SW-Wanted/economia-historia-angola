import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
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
    VIDEO: 'Vídeo', PODCAST: 'Podcast', AUDIO: 'Áudio',
    TEXT: 'Microtexto', MICROTEXT: 'Microtexto', PDF: 'Arquivo', ARTICLE: 'Análise',
  }
  return labels[content.type] ?? content.type
}

export default function ConteudosProvincia() {
  const navigate = useNavigate()
  const location = useLocation()
  const province = (location.state as { province?: string } | null)?.province ?? 'Luanda'

  const [contents, setContents] = useState<Content[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    setLoading(true)
    setError('')
    contentService
      .list({ search: province, limit: 20 })
      .then((res) => setContents(extractList(res)))
      .catch(() => setError('Não foi possível carregar os conteúdos.'))
      .finally(() => setLoading(false))
  }, [province])

  const totalArticles = contents.filter((c) => !c.isJindungo && c.type !== 'PDF').length
  const totalDocs = contents.filter((c) => c.type === 'PDF').length
  const totalJindungo = contents.filter((c) => c.isJindungo).length

  return (
    <AppShell title={province} searchPlaceholder={`Pesquisar em ${province}...`}>
      <div className="px-10 py-16 max-w-[1160px] mx-auto">
        <button
          onClick={() => navigate('/mapa')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Mapa
        </button>

        <div className="flex items-center gap-4 mb-8">
          <div className="w-16 h-16 bg-[#8B1A1A] rounded-xl flex items-center justify-center flex-shrink-0">
            <span className="material-symbols-outlined text-white text-3xl">location_on</span>
          </div>
          <div>
            <h1 className="text-[40px] font-extrabold text-[#1c1b1b] font-sans">{province}</h1>
            <p className="text-base text-[#5d5f5d] font-serif">Conteúdos históricos e económicos sobre {province}</p>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-4 mb-10">
          {[
            { value: loading ? '…' : String(totalArticles), label: 'Artigos' },
            { value: loading ? '…' : String(totalDocs), label: 'Documentos de Arquivo' },
            { value: loading ? '…' : String(totalJindungo), label: 'Textos Jindungo' },
          ].map((s) => (
            <div key={s.label} className="bg-white rounded-xl p-6 border border-[#e0bfbc] text-center shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
              <p className="text-[40px] font-extrabold text-[#8B1A1A] font-sans">{s.value}</p>
              <p className="text-xs text-[#5d5f5d] uppercase tracking-wider font-sans">{s.label}</p>
            </div>
          ))}
        </div>

        <h2 className="text-2xl font-bold text-[#1c1b1b] mb-6 font-sans">Conteúdos sobre {province}</h2>

        {loading && (
          <div className="flex flex-col gap-4">
            {[0, 1, 2, 3].map((i) => (
              <div key={i} className="bg-white rounded-xl h-20 border border-[#e0bfbc] animate-pulse" />
            ))}
          </div>
        )}

        {!loading && error && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
            <p className="text-sm text-red-700 font-sans">{error}</p>
          </div>
        )}

        {!loading && !error && contents.length === 0 && (
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">search_off</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Nenhum conteúdo encontrado sobre {province}.</p>
            <button
              onClick={() => navigate('/explorar')}
              className="mt-4 text-sm font-semibold text-[#8B1A1A] font-sans hover:underline"
            >
              Explorar todos os conteúdos →
            </button>
          </div>
        )}

        {!loading && !error && contents.length > 0 && (
          <div className="flex flex-col gap-4">
            {contents.map((c) => (
              <div
                key={c.id}
                onClick={() => navigate(getContentRoute(c), { state: { contentId: c.id } })}
                className="bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer flex items-center gap-6 group"
              >
                <div className="w-12 h-12 bg-[#eae7e7] rounded-lg flex items-center justify-center flex-shrink-0">
                  <span className="material-symbols-outlined text-[#8B1A1A]">
                    {c.type === 'PDF' ? 'description' : c.isJindungo ? 'nutrition' : 'article'}
                  </span>
                </div>
                <div className="flex-grow min-w-0">
                  <div className="flex items-center gap-2 mb-1 flex-wrap">
                    <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full font-sans">
                      {getTypeLabel(c)}
                    </span>
                    {c.category && <span className="text-xs text-[#5d5f5d] font-sans">{c.category.name}</span>}
                  </div>
                  <h3 className="text-base font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors font-sans truncate">
                    {c.title}
                  </h3>
                  {c.summary && (
                    <p className="text-sm text-[#5d5f5d] font-serif line-clamp-1 mt-0.5">{c.summary}</p>
                  )}
                </div>
                <span className="material-symbols-outlined text-[#5d5f5d] group-hover:text-[#8B1A1A] transition-colors flex-shrink-0">chevron_right</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </AppShell>
  )
}
