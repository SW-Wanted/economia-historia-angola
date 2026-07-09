import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { contentService, type ContentStatus } from '../services/api/content.service'
import { useAuth, canCreateContent, canManageUsers, hasPermission } from '../contexts/AuthContext'
import { getErrorMessage } from '../utils/errors'
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
  const [error, setError] = useState('')
  const [actingId, setActingId] = useState<string | null>(null)
  const [confirmRemoveId, setConfirmRemoveId] = useState<string | null>(null)

  const canCreate = canCreateContent(user)
  const showUserMgmt = canManageUsers(user)
  const canApprove = hasPermission(user, 'CONTENT_APPROVE')
  const canPublish = hasPermission(user, 'CONTENT_PUBLISH')
  const canDelete = hasPermission(user, 'CONTENT_DELETE')

  useEffect(() => {
    contentService.listForManagement({ limit: 50 })
      .then((data) => {
        const items = Array.isArray(data) ? data : (data as { items?: Content[] }).items ?? []
        setContents(items)
      })
      .catch((err) => setError(getErrorMessage(err)))
      .finally(() => setLoading(false))
  }, [])

  async function applyStatus(id: string, status: ContentStatus) {
    setActingId(id)
    setError('')
    try {
      const updated = await contentService.changeStatus(id, status)
      setContents((prev) => prev.map((c) => (c.id === id ? { ...c, ...updated } : c)))
    } catch (err) {
      setError(getErrorMessage(err))
    } finally {
      setActingId(null)
    }
  }

  async function removeContent(id: string) {
    setActingId(id)
    setError('')
    try {
      await contentService.remove(id)
      setContents((prev) => prev.filter((c) => c.id !== id))
      setConfirmRemoveId(null)
    } catch (err) {
      setError(getErrorMessage(err))
    } finally {
      setActingId(null)
    }
  }

  // Ações disponíveis por estado (espelham as regras do backend; a UI só oculta o inválido).
  function actionsFor(c: Content): { label: string; icon: string; status: ContentStatus; cls: string }[] {
    const isOwner = c.author?.id === user?.id
    const list: { label: string; icon: string; status: ContentStatus; cls: string }[] = []
    const reviewer = canApprove || canPublish
    switch (c.status) {
      case 'DRAFT':
      case 'REJECTED':
        if (isOwner || reviewer) list.push({ label: 'Submeter', icon: 'send', status: 'PENDING_REVIEW', cls: 'text-primary border-primary/30 hover:bg-primary/5' })
        if (reviewer) list.push({ label: 'Publicar', icon: 'publish', status: 'PUBLISHED', cls: 'text-success border-success/30 hover:bg-success/5' })
        break
      case 'PENDING_REVIEW':
        if (reviewer) {
          list.push({ label: 'Publicar', icon: 'publish', status: 'PUBLISHED', cls: 'text-success border-success/30 hover:bg-success/5' })
          list.push({ label: 'Rejeitar', icon: 'block', status: 'REJECTED', cls: 'text-error border-error/30 hover:bg-error/5' })
        }
        if (isOwner && !reviewer) list.push({ label: 'Retirar', icon: 'undo', status: 'DRAFT', cls: 'text-secondary border-outline-variant/50 hover:bg-surface-container' })
        break
      case 'PUBLISHED':
        if (canPublish || isOwner) list.push({ label: 'Arquivar', icon: 'archive', status: 'ARCHIVED', cls: 'text-secondary border-outline-variant/50 hover:bg-surface-container' })
        break
      case 'ARCHIVED':
        if (reviewer) list.push({ label: 'Republicar', icon: 'publish', status: 'PUBLISHED', cls: 'text-success border-success/30 hover:bg-success/5' })
        break
    }
    return list
  }

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

        {error && (
          <div className="alert-error rounded-card mb-6">
            <span className="material-symbols-outlined text-error text-[18px] flex-shrink-0 mt-0.5">error_outline</span>
            <p className="text-body-md text-error font-body">{error}</p>
          </div>
        )}

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
                  {['Título', 'Tipo', 'Estado', 'Data', 'Vistas', 'Ações'].map((h) => (
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
                      <div className="flex items-center gap-1.5 flex-wrap">
                        <button
                          onClick={() => navigate(getContentRoute(c.type), { state: { contentId: c.id } })}
                          className="btn-icon"
                          title="Ver conteúdo"
                        >
                          <span className="material-symbols-outlined text-[17px]">visibility</span>
                        </button>

                        {actingId === c.id ? (
                          <span className="w-4 h-4 border-2 border-primary/30 border-t-primary rounded-full animate-spin block mx-1" />
                        ) : (
                          <>
                            {actionsFor(c).map((a) => (
                              <button
                                key={a.status + a.label}
                                onClick={() => applyStatus(c.id, a.status)}
                                title={a.label}
                                className={`inline-flex items-center gap-1 text-xs font-semibold font-sans px-2.5 py-1.5 rounded-button border transition-all ${a.cls}`}
                              >
                                <span className="material-symbols-outlined text-[15px]">{a.icon}</span>
                                {a.label}
                              </button>
                            ))}

                            {(canDelete || c.author?.id === user?.id) && (
                              confirmRemoveId === c.id ? (
                                <span className="inline-flex items-center gap-1">
                                  <button
                                    onClick={() => removeContent(c.id)}
                                    title="Confirmar remoção"
                                    className="text-xs font-bold font-sans px-2 py-1.5 rounded-button border border-error text-white bg-error hover:bg-error/90 transition-all"
                                  >
                                    Confirmar
                                  </button>
                                  <button
                                    onClick={() => setConfirmRemoveId(null)}
                                    className="text-xs font-semibold font-sans px-2 py-1.5 rounded-button border border-outline-variant/50 text-secondary hover:border-outline transition-all"
                                  >
                                    Não
                                  </button>
                                </span>
                              ) : (
                                <button
                                  onClick={() => setConfirmRemoveId(c.id)}
                                  title="Remover conteúdo"
                                  className="text-secondary hover:text-error transition-colors p-1.5 rounded-button"
                                >
                                  <span className="material-symbols-outlined text-[17px]">delete</span>
                                </button>
                              )
                            )}
                          </>
                        )}
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
