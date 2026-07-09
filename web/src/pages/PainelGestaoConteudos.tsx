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
  PUBLISHED: 'badge bg-success/10 text-success',
  PENDING_REVIEW: 'badge bg-warning/10 text-warning',
  DRAFT: 'badge bg-surface-container text-secondary',
  ARCHIVED: 'badge bg-surface-container text-secondary',
  REJECTED: 'badge bg-error/10 text-error',
}

const TYPE_LABELS: Record<string, string> = {
  VIDEO: 'Vídeo', PODCAST: 'Podcast', TEXT: 'Texto',
  MICROTEXT: 'Microtexto', PDF: 'Documento', ARTICLE: 'Jindungo', AUDIO: 'Áudio',
}

const FILTERS: Record<string, string | null> = {
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

  const filtered = FILTERS[filter]
    ? contents.filter((c) => c.status === FILTERS[filter])
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
    <AppShell searchPlaceholder="Pesquisar artigos...">
      <div className="page-content animate-fade-in">
        <div className="section-header mb-8">
          <div>
            <h2 className="section-title">Gestão de Conteúdos</h2>
            <p className="section-subtitle">Gerencie artigos e documentos da plataforma.</p>
          </div>
          <div className="flex gap-3">
            {showUserMgmt && (
              <button onClick={() => navigate('/gestao/utilizadores')} className="btn-secondary">
                <span className="material-symbols-outlined text-[18px]">group</span>
                Utilizadores
              </button>
            )}
            {canCreate && (
              <button onClick={() => navigate('/gestao/submeter-artigo')} className="btn-primary">
                <span className="material-symbols-outlined text-[18px]">add</span>
                Novo Artigo
              </button>
            )}
          </div>
        </div>

        <div className="alert-info rounded-card mb-6">
          <span className="material-symbols-outlined text-primary text-[18px] flex-shrink-0 mt-0.5">info</span>
          <p className="text-body-md text-secondary font-body">
            Este painel lista conteúdos públicos publicados. A gestão de rascunhos e aprovação requer endpoints administrativos em desenvolvimento.
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          {[
            { value: loading ? '…' : String(stats.published), label: 'Publicados', color: 'text-success' },
            { value: loading ? '…' : String(stats.review), label: 'Em Revisão', color: 'text-warning' },
            { value: loading ? '…' : String(stats.drafts), label: 'Rascunhos', color: 'text-secondary' },
            { value: loading ? '…' : stats.views.toLocaleString(), label: 'Visualizações', color: 'text-primary' },
          ].map((s) => (
            <div key={s.label} className="card p-5 text-center">
              <p className={`text-[28px] font-extrabold font-sans ${s.color}`}>{s.value}</p>
              <p className="text-label-md text-secondary uppercase tracking-wider font-sans mt-1">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Filter chips */}
        <div className="flex gap-2 mb-6">
          {Object.keys(FILTERS).map((f) => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={f === filter ? 'filter-chip-active' : 'filter-chip-inactive'}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Table */}
        <div className="card overflow-hidden">
          {loading ? (
            <div className="p-8 space-y-3">
              {[0, 1, 2, 3].map((i) => (
                <div key={i} className="skeleton h-12 rounded-lg" />
              ))}
            </div>
          ) : filtered.length === 0 ? (
            <div className="empty-state py-12">
              <div className="w-12 h-12 rounded-2xl bg-surface-container flex items-center justify-center">
                <span className="material-symbols-outlined text-primary/40 text-[28px]">article</span>
              </div>
              <p className="text-body-md text-secondary font-body">Nenhum conteúdo encontrado.</p>
            </div>
          ) : (
            <table className="w-full">
              <thead className="bg-surface-container-low border-b border-outline-variant/25">
                <tr>
                  {['Título', 'Tipo', 'Estado', 'Data', 'Vistas', ''].map((h) => (
                    <th key={h} className="text-left px-5 py-3.5 text-label-md font-bold text-secondary uppercase tracking-wider font-sans">
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-outline-variant/20">
                {filtered.map((c) => (
                  <tr key={c.id} className="hover:bg-surface-container-low/50 transition-colors">
                    <td className="px-5 py-4">
                      <button
                        onClick={() => navigate(getContentRoute(c.type), { state: { contentId: c.id } })}
                        className="text-sm font-semibold text-text hover:text-primary transition-colors text-left line-clamp-1 max-w-[280px] font-sans"
                      >
                        {c.title}
                      </button>
                    </td>
                    <td className="px-5 py-4">
                      <span className="badge-primary">{TYPE_LABELS[c.type] ?? c.type}</span>
                    </td>
                    <td className="px-5 py-4">
                      <span className={STATUS_COLORS[c.status] ?? 'badge bg-surface-container text-secondary'}>
                        {STATUS_LABELS[c.status] ?? c.status}
                      </span>
                    </td>
                    <td className="px-5 py-4 text-[12px] text-secondary font-body">
                      {new Date(c.createdAt).toLocaleDateString('pt-AO', { day: '2-digit', month: 'short', year: 'numeric' })}
                    </td>
                    <td className="px-5 py-4 text-sm font-semibold text-text font-sans">
                      {(c._count?.views ?? 0).toLocaleString()}
                    </td>
                    <td className="px-5 py-4">
                      <button
                        onClick={() => navigate(getContentRoute(c.type), { state: { contentId: c.id } })}
                        className="btn-icon"
                        title="Ver conteúdo"
                      >
                        <span className="material-symbols-outlined text-[17px]">visibility</span>
                      </button>
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
