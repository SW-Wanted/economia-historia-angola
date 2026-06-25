import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService } from '../services/api/content.service'
import { useAuth, canCreateContent, canManageUsers } from '../contexts/AuthContext'
import type { Content } from '../services/types/api.types'

const STATUS_LABELS: Record<string, string> = {
  DRAFT: 'Rascunho', PENDING_REVIEW: 'Em Revisão',
  PUBLISHED: 'Publicado', ARCHIVED: 'Arquivado', REJECTED: 'Rejeitado',
}

const STATUS_COLORS: Record<string, string> = {
  PUBLISHED: 'bg-green-100 text-green-800',
  PENDING_REVIEW: 'bg-amber-100 text-amber-800',
  DRAFT: 'bg-[#eae7e7] text-[#5d5f5d]',
  ARCHIVED: 'bg-blue-100 text-blue-800',
  REJECTED: 'bg-red-100 text-red-800',
}

const TYPE_LABELS: Record<string, string> = {
  VIDEO: 'Vídeo', PODCAST: 'Podcast', TEXT: 'Texto',
  MICROTEXT: 'Microtexto', PDF: 'Documento', ARTICLE: 'Jindungo', AUDIO: 'Áudio',
}

const FILTER_STATUSES: Record<string, string | null> = {
  'Todos': null, 'Publicados': 'PUBLISHED', 'Em Revisão': 'PENDING_REVIEW', 'Rascunhos': 'DRAFT',
}

export default function PainelGestaoConteudos() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [filter, setFilter] = useState('Todos')
  const [contents, setContents] = useState<Content[]>([])
  const [loading, setLoading] = useState(true)

  const canCreate = canCreateContent(user)
  const showUserMgmt = canManageUsers(user)

  useEffect(() => {
    contentService.list({ limit: 50 })
      .then((data) => {
        const items = Array.isArray(data) ? data : (data as { items?: Content[] }).items ?? []
        setContents(items)
      })
      .catch(() => setContents([]))
      .finally(() => setLoading(false))
  }, [])

  const filtered = FILTER_STATUSES[filter]
    ? contents.filter((c) => c.status === FILTER_STATUSES[filter])
    : contents

  const stats = {
    published: contents.filter((c) => c.status === 'PUBLISHED').length,
    review: contents.filter((c) => c.status === 'PENDING_REVIEW').length,
    drafts: contents.filter((c) => c.status === 'DRAFT').length,
    views: contents.reduce((sum, c) => sum + (c._count?.views ?? 0), 0),
  }

  function getContentRoute(type: string): string {
    if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
    if (type === 'PDF') return '/documento/detalhe'
    if (type === 'ARTICLE') return '/leitura/jindungo'
    return '/leitura/microtexto'
  }

  return (
    <AppShell title="Gestão de Conteúdos" searchPlaceholder="Pesquisar artigos...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-1 font-sans">Gestão de Conteúdos</h2>
            <p className="text-base text-[#5d5f5d] font-serif">Gerencie todos os artigos e documentos da plataforma.</p>
          </div>
          <div className="flex gap-3">
            {showUserMgmt && (
              <button onClick={() => navigate('/gestao/utilizadores')}
                className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
                <span className="material-symbols-outlined text-[18px]">group</span>
                Utilizadores
              </button>
            )}
            {canCreate && (
              <button onClick={() => navigate('/gestao/submeter-artigo')}
                className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold hover:opacity-90 transition-all shadow-sm">
                <span className="material-symbols-outlined">add</span>
                Novo Artigo
              </button>
            )}
          </div>
        </div>

        {/* Backend notice */}
        <div className="bg-[#fff8f7] border border-[#8B1A1A]/15 rounded-xl p-4 mb-6 flex items-start gap-3">
          <span className="material-symbols-outlined text-[#8B1A1A] text-[18px] mt-0.5 flex-shrink-0">info</span>
          <p className="text-xs text-[#5d5f5d] font-serif">
            Este painel lista conteúdos públicos publicados. A gestão de rascunhos, aprovação e publicação requer endpoints administrativos que estão em desenvolvimento.
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          {[
            { value: loading ? '…' : String(stats.published), label: 'Publicados', color: 'text-green-600' },
            { value: loading ? '…' : String(stats.review), label: 'Em Revisão', color: 'text-amber-600' },
            { value: loading ? '…' : String(stats.drafts), label: 'Rascunhos', color: 'text-[#5d5f5d]' },
            { value: loading ? '…' : stats.views.toLocaleString(), label: 'Visualizações', color: 'text-[#8B1A1A]' },
          ].map((s) => (
            <div key={s.label} className="bg-white rounded-xl p-5 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] text-center">
              <p className={`text-[32px] font-extrabold font-sans ${s.color}`}>{s.value}</p>
              <p className="text-xs text-[#5d5f5d] uppercase tracking-wider font-sans">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Filter */}
        <div className="flex gap-2 mb-6">
          {Object.keys(FILTER_STATUSES).map((f) => (
            <button key={f} onClick={() => setFilter(f)}
              className={`px-4 py-2 rounded-full text-xs font-semibold font-sans transition-colors ${filter === f ? 'bg-[#8B1A1A] text-white' : 'bg-white border border-[#e0bfbc] text-[#5d5f5d] hover:border-[#8B1A1A]'}`}>
              {f}
            </button>
          ))}
        </div>

        {/* Table */}
        <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] overflow-hidden">
          {loading ? (
            <div className="p-8 space-y-3">
              {[0, 1, 2, 3].map((i) => (
                <div key={i} className="h-12 bg-[#f0eded] rounded-lg animate-pulse" />
              ))}
            </div>
          ) : filtered.length === 0 ? (
            <div className="p-12 text-center">
              <span className="material-symbols-outlined text-[#8B1A1A]/20 text-5xl mb-3 block">article</span>
              <p className="text-sm text-[#5d5f5d] font-serif">Nenhum conteúdo encontrado com este filtro.</p>
            </div>
          ) : (
            <table className="w-full">
              <thead className="bg-[#f6f3f2] border-b border-[#e0bfbc]">
                <tr>
                  {['Título', 'Tipo', 'Estado', 'Data', 'Visualizações', 'Ações'].map((h) => (
                    <th key={h} className="text-left px-5 py-3 text-xs font-bold text-[#5d5f5d] uppercase tracking-wider font-sans">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-[#e0bfbc]">
                {filtered.map((c) => (
                  <tr key={c.id} className="hover:bg-[#f6f3f2] transition-colors">
                    <td className="px-5 py-4">
                      <button onClick={() => navigate(getContentRoute(c.type))}
                        className="text-sm font-semibold text-[#1c1b1b] hover:text-[#8B1A1A] transition-colors text-left line-clamp-1 max-w-[280px] font-sans">
                        {c.title}
                      </button>
                    </td>
                    <td className="px-5 py-4">
                      <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full font-sans">
                        {TYPE_LABELS[c.type] ?? c.type}
                      </span>
                    </td>
                    <td className="px-5 py-4">
                      <span className={`text-xs font-semibold px-2 py-0.5 rounded-full font-sans ${STATUS_COLORS[c.status] ?? 'bg-[#eae7e7] text-[#5d5f5d]'}`}>
                        {STATUS_LABELS[c.status] ?? c.status}
                      </span>
                    </td>
                    <td className="px-5 py-4 text-xs text-[#5d5f5d] font-sans">
                      {new Date(c.createdAt).toLocaleDateString('pt-AO', { day: '2-digit', month: 'short', year: 'numeric' })}
                    </td>
                    <td className="px-5 py-4 text-sm font-semibold text-[#1c1b1b] font-sans">
                      {(c._count?.views ?? 0).toLocaleString()}
                    </td>
                    <td className="px-5 py-4">
                      <div className="flex items-center gap-1.5">
                        <button
                          onClick={() => navigate(getContentRoute(c.type), { state: { contentId: c.id } })}
                          className="p-1.5 rounded hover:bg-[#eae7e7] transition-colors text-[#5d5f5d] hover:text-[#8B1A1A]"
                          title="Ver conteúdo"
                        >
                          <span className="material-symbols-outlined text-[16px]">visibility</span>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </AppShell>
  )
}
