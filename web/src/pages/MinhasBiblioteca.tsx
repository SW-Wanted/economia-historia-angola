import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { userService } from '../services/api/user.service'
import type { Progress } from '../services/types/api.types'

const tabs = ['Em Leitura', 'Concluídos', 'Guardados', 'Descarregados']

const TYPE_LABELS: Record<string, string> = {
  VIDEO: 'Vídeo', PODCAST: 'Podcast', TEXT: 'Texto',
  MICROTEXT: 'Microtexto', PDF: 'Documento', ARTICLE: 'Jindungo', AUDIO: 'Áudio',
}

const TYPE_ICONS: Record<string, string> = {
  VIDEO: 'play_circle', PODCAST: 'play_circle', AUDIO: 'play_circle',
  PDF: 'description', ARTICLE: 'nutrition',
}

function getContentRoute(type: string): string {
  if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
  if (type === 'PDF') return '/documento/detalhe'
  if (type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

function EmptyState({ onExplore }: { onExplore: () => void }) {
  return (
    <div className="bg-white rounded-xl border border-[#ebe5e4] shadow-card p-12 text-center">
      <span className="material-symbols-outlined text-[#8B1A1A]/15 mb-4 block" style={{ fontSize: '64px' }}>library_books</span>
      <p className="text-lg font-bold text-[#1c1b1b] mb-1 font-sans">Nenhum item aqui</p>
      <p className="text-sm text-[#5d5f5d] font-serif mb-6">Explore o arquivo e começa a ler.</p>
      <button
        onClick={onExplore}
        className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] active:scale-[0.98] transition-all duration-150"
      >
        Explorar Conteúdos
      </button>
    </div>
  )
}

export default function MinhasBiblioteca() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('Em Leitura')
  const [progress, setProgress] = useState<Progress[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    userService.getMyProgress()
      .then((data) => setProgress(Array.isArray(data) ? data : []))
      .catch(() => setProgress([]))
      .finally(() => setLoading(false))
  }, [])

  const inReading = progress.filter((p) => !p.completedAt && p.percentage > 0 && p.percentage < 100)
  const completed = progress.filter((p) => p.completedAt || p.percentage === 100)

  function renderItems(items: Progress[]) {
    if (loading) {
      return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {[0, 1, 2].map((i) => (
            <div key={i} className="bg-white rounded-xl h-52 border border-[#ebe5e4] animate-pulse" />
          ))}
        </div>
      )
    }
    if (items.length === 0) return <EmptyState onExplore={() => navigate('/explorar')} />
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {items.map((item) => (
          <div
            key={item.id}
            onClick={() => navigate(getContentRoute(item.content.type), { state: { contentId: item.contentId } })}
            className="bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer group"
          >
            <div className="h-36 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center">
              <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '56px' }}>
                {TYPE_ICONS[item.content.type] ?? 'article'}
              </span>
            </div>
            <div className="p-4 space-y-2">
              <span className="bg-[#fff5f4] text-[#8B1A1A] px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">
                {TYPE_LABELS[item.content.type] ?? item.content.type}
              </span>
              <h4 className="text-sm font-semibold text-[#1c1b1b] line-clamp-2 font-sans leading-snug">{item.content.title}</h4>
              <div className="w-full bg-[#f0eded] h-1.5 rounded-full overflow-hidden">
                <div className="bg-[#8B1A1A] h-full transition-all" style={{ width: `${item.percentage}%` }} />
              </div>
              <div className="flex justify-between items-center text-xs text-[#8c716e] font-sans">
                <span>{item.percentage}% Concluído</span>
                <span>{item.completedAt ? 'Concluído' : `${100 - item.percentage}% por ler`}</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    )
  }

  function renderOfflineTab(label: string) {
    return (
      <div className="bg-white rounded-xl border border-[#ebe5e4] p-10 text-center">
        <span className="material-symbols-outlined text-[#8B1A1A]/20 text-5xl mb-3 block">cloud_off</span>
        <p className="text-base font-bold text-[#1c1b1b] mb-1 font-sans">{label}</p>
        <p className="text-sm text-[#5d5f5d] font-serif">Esta funcionalidade estará disponível em breve.</p>
      </div>
    )
  }

  return (
    <AppShell title="Minha Biblioteca" searchPlaceholder="Pesquisar na biblioteca...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2 font-sans tracking-tight">Minha Biblioteca</h2>
          <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
            Todos os seus conteúdos em progresso.
          </p>
        </div>

        {/* Tabs */}
        <div className="border-b border-[#ebe5e4] mb-8">
          <div className="flex gap-6">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3.5 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab ? 'border-[#8B1A1A] text-[#8B1A1A]' : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {activeTab === 'Em Leitura' && renderItems(inReading)}
        {activeTab === 'Concluídos' && renderItems(completed)}
        {activeTab === 'Guardados' && renderOfflineTab('Guardados')}
        {activeTab === 'Descarregados' && renderOfflineTab('Descarregados')}
      </div>
    </AppShell>
  )
}
