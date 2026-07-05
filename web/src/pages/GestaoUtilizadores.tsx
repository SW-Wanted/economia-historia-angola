import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth, canManageUsers, hasPermission, hasRole } from '../contexts/AuthContext'
import { userService } from '../services/api/user.service'
import {
  writerApplicationService,
  type ReviewWriterApplicationDto,
} from '../services/api/writer-application.service'
import { reportsService, type ReviewReportDto } from '../services/api/reports.service'
import { getErrorMessage } from '../utils/errors'
import type { AdminUser, WriterApplication, Report } from '../services/types/api.types'

type TabId = 'utilizadores' | 'candidaturas' | 'denuncias'

const APP_STATUS_LABEL: Record<string, string> = {
  PENDING: 'Em análise',
  APPROVED: 'Aprovada',
  REJECTED: 'Rejeitada',
  REQUEST_CHANGES: 'Revisão solicitada',
}

const REPORT_STATUS_LABEL: Record<string, string> = {
  PENDING: 'Pendente',
  REVIEWING: 'Em análise',
  RESOLVED: 'Resolvida',
  DISMISSED: 'Ignorada',
}

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const days = Math.floor(diff / 86400000)
  if (days === 0) return 'hoje'
  if (days === 1) return 'ontem'
  if (days < 30) return `há ${days} dias`
  return new Date(dateStr).toLocaleDateString('pt-PT', { day: 'numeric', month: 'short', year: 'numeric' })
}

function roleLabel(code: string): string {
  const labels: Record<string, string> = {
    USER: 'Utilizador', WRITER: 'Escritor', PROFESSOR: 'Professor',
    MODERATOR: 'Moderador', ADMIN: 'Administrador', SUPER_ADMIN: 'Super Admin',
  }
  return labels[code] ?? code
}

// Papéis atribuíveis, por ordem hierárquica. ADMIN só é oferecido a um Super Admin.
const ASSIGNABLE_ROLES = ['USER', 'WRITER', 'PROFESSOR', 'MODERATOR', 'ADMIN'] as const

// ── User row ────────────────────────────────────────────────────────────────
function UserRow({
  u,
  currentUserId,
  currentUserIsSuperAdmin,
  onStatusChange,
  onRoleChange,
  onRemoved,
}: {
  u: AdminUser
  currentUserId: string
  currentUserIsSuperAdmin: boolean
  onStatusChange: (id: string, isActive: boolean) => void
  onRoleChange: (id: string, updated: AdminUser) => void
  onRemoved: (id: string) => void
}) {
  const [toggling, setToggling] = useState(false)
  const [changingRole, setChangingRole] = useState(false)
  const [removing, setRemoving] = useState(false)
  const [confirmRemove, setConfirmRemove] = useState(false)
  const [rowError, setRowError] = useState('')
  const isSelf = u.id === currentUserId

  const targetRoles = (u.roles ?? []).map((r) => r.role.code)
  const primaryRole = targetRoles[0] ?? 'USER'
  const targetIsSuperAdmin = targetRoles.includes('SUPER_ADMIN')
  const targetIsAdmin = targetRoles.includes('ADMIN')

  // Regras (espelham o backend): nunca gerir um Super Admin; só um Super Admin
  // gere Admins. Nunca sobre a própria conta.
  const canManageTarget =
    !isSelf && !targetIsSuperAdmin && (currentUserIsSuperAdmin || !targetIsAdmin)

  // Opções de papel visíveis: ADMIN apenas para um Super Admin.
  const roleOptions = ASSIGNABLE_ROLES.filter((r) => r !== 'ADMIN' || currentUserIsSuperAdmin)

  async function toggle() {
    if (isSelf || toggling) return
    setToggling(true)
    try {
      await userService.updateStatus(u.id, !u.isActive)
      onStatusChange(u.id, !u.isActive)
    } catch {
      // ignore
    } finally {
      setToggling(false)
    }
  }

  async function changeRole(role: string) {
    if (role === primaryRole || changingRole) return
    setChangingRole(true)
    setRowError('')
    try {
      const updated = await userService.setRole(u.id, role)
      onRoleChange(u.id, updated)
    } catch (err) {
      setRowError(getErrorMessage(err))
    } finally {
      setChangingRole(false)
    }
  }

  async function remove() {
    setRemoving(true)
    setRowError('')
    try {
      await userService.remove(u.id)
      onRemoved(u.id)
    } catch (err) {
      setRowError(getErrorMessage(err))
      setRemoving(false)
      setConfirmRemove(false)
    }
  }

  return (
    <div className="flex flex-col gap-2 py-4 border-b border-outline-variant/20 last:border-0">
      <div className="flex items-center gap-4">
        <div className="w-9 h-9 rounded-full bg-primary/8 border border-primary/15 flex items-center justify-center flex-shrink-0">
          <span className="text-[11px] font-bold text-primary font-sans leading-none">
            {u.name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase()}
          </span>
        </div>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-sm font-bold text-text font-sans truncate">{u.name}</span>
            <span className={`badge text-[10px] ${primaryRole === 'USER' ? 'badge-outline' : 'badge-primary'}`}>
              {roleLabel(primaryRole)}
            </span>
            {!u.isActive && (
              <span className="badge text-[10px] text-error border-error/30 bg-error/5">Suspenso</span>
            )}
          </div>
          <p className="text-[11px] text-secondary font-body truncate">{u.email}</p>
        </div>
        <div className="flex items-center gap-2 flex-shrink-0">
          <span className="text-[11px] text-outline font-body hidden sm:block">{timeAgo(u.createdAt)}</span>

          {/* Promover / despromover — só quando o alvo é gerível. */}
          {canManageTarget && (
            <div className="relative">
              <select
                value={primaryRole}
                onChange={(e) => changeRole(e.target.value)}
                disabled={changingRole}
                title="Alterar papel"
                className="text-xs font-semibold font-sans px-2.5 py-1.5 rounded-button border border-outline-variant/50 bg-surface text-text hover:border-primary/40 transition-all disabled:opacity-40 cursor-pointer"
              >
                {/* Mostra o papel atual mesmo que não seja atribuível (ex.: já é o próprio). */}
                {!roleOptions.includes(primaryRole as typeof ASSIGNABLE_ROLES[number]) && (
                  <option value={primaryRole}>{roleLabel(primaryRole)}</option>
                )}
                {roleOptions.map((r) => (
                  <option key={r} value={r}>{roleLabel(r)}</option>
                ))}
              </select>
              {changingRole && (
                <span className="absolute -right-5 top-1/2 -translate-y-1/2 w-3 h-3 border border-primary/40 border-t-primary rounded-full animate-spin block" />
              )}
            </div>
          )}

          <button
            onClick={toggle}
            disabled={toggling || isSelf}
            title={isSelf ? 'Não pode alterar a sua própria conta' : (u.isActive ? 'Suspender conta' : 'Reativar conta')}
            className={`text-xs font-semibold font-sans px-3 py-1.5 rounded-button border transition-all duration-150 disabled:opacity-40 disabled:cursor-not-allowed ${
              u.isActive
                ? 'border-error/30 text-error hover:bg-error/5'
                : 'border-success/30 text-success hover:bg-success/5'
            }`}
          >
            {toggling ? (
              <span className="w-3 h-3 border border-current border-t-transparent rounded-full animate-spin block" />
            ) : u.isActive ? 'Suspender' : 'Reativar'}
          </button>

          {/* Remover — só quando o alvo é gerível. */}
          {canManageTarget && (
            confirmRemove ? (
              <div className="flex items-center gap-1">
                <button
                  onClick={remove}
                  disabled={removing}
                  title="Confirmar remoção"
                  className="text-xs font-bold font-sans px-2.5 py-1.5 rounded-button border border-error text-white bg-error hover:bg-error/90 transition-all disabled:opacity-50"
                >
                  {removing ? (
                    <span className="w-3 h-3 border border-white/40 border-t-white rounded-full animate-spin block" />
                  ) : 'Confirmar'}
                </button>
                <button
                  onClick={() => setConfirmRemove(false)}
                  disabled={removing}
                  className="text-xs font-semibold font-sans px-2 py-1.5 rounded-button border border-outline-variant/50 text-secondary hover:border-outline transition-all"
                >
                  Não
                </button>
              </div>
            ) : (
              <button
                onClick={() => setConfirmRemove(true)}
                title="Remover utilizador"
                className="text-secondary hover:text-error transition-colors p-1.5 rounded-button"
              >
                <span className="material-symbols-outlined text-[18px]">delete</span>
              </button>
            )
          )}
        </div>
      </div>
      {rowError && <p className="text-[11px] text-error font-body pl-1">{rowError}</p>}
    </div>
  )
}

// ── Writer Application card ──────────────────────────────────────────────────
function WriterAppCard({
  app,
  onReviewed,
}: {
  app: WriterApplication
  onReviewed: (id: string, updated: WriterApplication) => void
}) {
  const [expanded, setExpanded] = useState(false)
  const [reviewing, setReviewing] = useState(false)
  const [decision, setDecision] = useState<'APPROVED' | 'REJECTED' | 'REQUEST_CHANGES'>('APPROVED')
  const [notes, setNotes] = useState('')
  const [rejectionReason, setRejectionReason] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [reviewError, setReviewError] = useState('')

  async function handleReview(e: React.FormEvent) {
    e.preventDefault()
    setReviewError('')
    if (decision === 'REJECTED' && !rejectionReason.trim()) {
      setReviewError('Indique o motivo da rejeição.')
      return
    }
    setSubmitting(true)
    try {
      const dto: ReviewWriterApplicationDto = {
        decision,
        ...(notes.trim() ? { notes: notes.trim() } : {}),
        ...(decision === 'REJECTED' && rejectionReason.trim() ? { rejectionReason: rejectionReason.trim() } : {}),
      }
      const updated = await writerApplicationService.review(app.id, dto)
      onReviewed(app.id, updated)
      setReviewing(false)
    } catch (err) {
      setReviewError(getErrorMessage(err))
    } finally {
      setSubmitting(false)
    }
  }

  const isPending = app.status === 'PENDING'
  const statusLabel = APP_STATUS_LABEL[app.status] ?? app.status

  return (
    <div className="card p-5 flex flex-col gap-3">
      {/* Header */}
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap mb-1">
            <span className="text-sm font-bold text-text font-sans">{app.fullName}</span>
            <span className={`badge text-[10px] ${
              app.status === 'PENDING'  ? 'badge-primary' :
              app.status === 'APPROVED' ? 'text-success border-success/30 bg-success/5' :
              app.status === 'REJECTED' ? 'text-error border-error/30 bg-error/5' :
              'text-warning border-warning/30 bg-warning/5'
            }`}>
              {statusLabel}
            </span>
          </div>
          {app.user && (
            <p className="text-[11px] text-secondary font-body">{app.user.email}</p>
          )}
          <p className="text-[11px] text-outline font-body mt-0.5">{app.institution} · {app.specialization}</p>
        </div>
        <div className="flex items-center gap-2 flex-shrink-0">
          <span className="text-[11px] text-outline font-body hidden sm:block">{timeAgo(app.submittedAt)}</span>
          <button
            onClick={() => setExpanded((v) => !v)}
            className="btn-icon"
            title={expanded ? 'Recolher' : 'Ver detalhes'}
          >
            <span className="material-symbols-outlined text-[18px]">
              {expanded ? 'expand_less' : 'expand_more'}
            </span>
          </button>
        </div>
      </div>

      {/* Expanded details */}
      {expanded && (
        <div className="border-t border-outline-variant/20 pt-3 space-y-3 animate-fade-in">
          {[
            { label: 'Formação Académica', value: app.academicBackground },
            { label: 'Experiência de Investigação', value: app.researchExperience },
            { label: 'Áreas de História Económica', value: app.economicHistoryAreas },
            { label: 'Tópicos de Interesse', value: app.interestTopics },
            { label: 'Idiomas', value: app.languages },
            ...(app.biography ? [{ label: 'Biografia', value: app.biography }] : []),
            ...(app.previousPublications ? [{ label: 'Publicações Anteriores', value: app.previousPublications }] : []),
            ...(app.portfolio ? [{ label: 'Portfólio', value: app.portfolio }] : []),
          ].map(({ label, value }) => (
            <div key={label}>
              <p className="text-[10px] uppercase tracking-wider text-secondary font-sans mb-0.5">{label}</p>
              <p className="text-sm text-text font-body leading-relaxed">{value}</p>
            </div>
          ))}

          {app.reviewNotes && (
            <div className="bg-surface-container rounded-lg p-3">
              <p className="text-[10px] uppercase tracking-wider text-secondary font-sans mb-0.5">Notas do Revisor</p>
              <p className="text-sm text-text font-body">{app.reviewNotes}</p>
            </div>
          )}
          {app.rejectionReason && (
            <div className="bg-error/5 rounded-lg p-3 border border-error/15">
              <p className="text-[10px] uppercase tracking-wider text-error font-sans mb-0.5">Motivo da Rejeição</p>
              <p className="text-sm text-error font-body">{app.rejectionReason}</p>
            </div>
          )}

          {isPending && !reviewing && (
            <button
              onClick={() => setReviewing(true)}
              className="btn-primary w-full justify-center"
            >
              <span className="material-symbols-outlined text-[18px]">rate_review</span>
              Rever Candidatura
            </button>
          )}

          {isPending && reviewing && (
            <form onSubmit={handleReview} className="space-y-3 border-t border-outline-variant/20 pt-3">
              <p className="text-sm font-bold text-text font-sans">Decisão</p>
              <div className="flex gap-2 flex-wrap">
                {([
                  { value: 'APPROVED', label: 'Aprovar', cls: 'text-success border-success/30 bg-success/5' },
                  { value: 'REQUEST_CHANGES', label: 'Pedir Revisão', cls: 'text-warning border-warning/30 bg-warning/5' },
                  { value: 'REJECTED', label: 'Rejeitar', cls: 'text-error border-error/30 bg-error/5' },
                ] as const).map((opt) => (
                  <button
                    key={opt.value}
                    type="button"
                    onClick={() => setDecision(opt.value)}
                    className={`flex-1 px-3 py-2 rounded-button border text-xs font-bold font-sans transition-all ${opt.cls} ${
                      decision === opt.value ? 'ring-2 ring-current ring-offset-1' : 'opacity-60'
                    }`}
                  >
                    {opt.label}
                  </button>
                ))}
              </div>

              <div>
                <label className="block text-[10px] uppercase tracking-wider text-secondary font-sans mb-1">
                  Notas (opcional)
                </label>
                <textarea rows={2} value={notes} onChange={(e) => setNotes(e.target.value)}
                  placeholder="Comentários para o candidato..." className="input resize-none text-sm w-full" />
              </div>

              {decision === 'REJECTED' && (
                <div>
                  <label className="block text-[10px] uppercase tracking-wider text-error font-sans mb-1">
                    Motivo da Rejeição *
                  </label>
                  <textarea rows={2} value={rejectionReason} onChange={(e) => setRejectionReason(e.target.value)}
                    placeholder="Explique o motivo da rejeição..." className="input resize-none text-sm w-full border-error/40" />
                </div>
              )}

              {reviewError && <p className="text-xs text-error font-body">{reviewError}</p>}

              <div className="flex gap-2">
                <button type="button" onClick={() => setReviewing(false)} className="btn-ghost flex-1 justify-center">Cancelar</button>
                <button type="submit" disabled={submitting} className="btn-primary flex-1 justify-center">
                  {submitting ? (
                    <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  ) : 'Confirmar Decisão'}
                </button>
              </div>
            </form>
          )}
        </div>
      )}
    </div>
  )
}

// ── Report card ──────────────────────────────────────────────────────────────
function ReportCard({ report, onReviewed }: { report: Report; onReviewed: (id: string, updated: Report) => void }) {
  const [submitting, setSubmitting] = useState(false)
  const [resolution, setResolution] = useState('')
  const [expanded, setExpanded] = useState(false)

  async function handleAction(status: ReviewReportDto['status']) {
    setSubmitting(true)
    try {
      const updated = await reportsService.review(report.id, {
        status,
        ...(resolution.trim() ? { resolution: resolution.trim() } : {}),
      })
      onReviewed(report.id, updated)
    } catch {
      // ignore
    } finally {
      setSubmitting(false)
    }
  }

  const isPending = report.status === 'PENDING' || report.status === 'REVIEWING'
  const statusLabel = REPORT_STATUS_LABEL[report.status] ?? report.status
  const target = report.topicId ? 'Tópico' : report.replyId ? 'Resposta' : report.commentId ? 'Comentário' : 'Comunidade'

  return (
    <div className="card p-5 flex flex-col gap-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap mb-1">
            <span className={`badge text-[10px] ${
              report.status === 'PENDING' ? 'badge-primary' :
              report.status === 'REVIEWING' ? 'text-warning border-warning/30 bg-warning/5' :
              report.status === 'RESOLVED' ? 'badge-success' :
              'badge-outline'
            }`}>{statusLabel}</span>
            <span className="badge-outline text-[10px]">{target}</span>
          </div>
          <p className="text-sm text-text font-body leading-relaxed line-clamp-2">{report.reason}</p>
          <p className="text-[11px] text-secondary font-body mt-1">
            Por {report.reporter?.name ?? 'Utilizador'} · {timeAgo(report.createdAt)}
          </p>
        </div>
        {isPending && (
          <button onClick={() => setExpanded((v) => !v)} className="btn-icon flex-shrink-0">
            <span className="material-symbols-outlined text-[18px]">{expanded ? 'expand_less' : 'rate_review'}</span>
          </button>
        )}
      </div>

      {expanded && isPending && (
        <div className="border-t border-outline-variant/20 pt-3 space-y-3 animate-fade-in">
          <div>
            <label className="block text-[10px] uppercase tracking-wider text-secondary font-sans mb-1">
              Resolução (opcional)
            </label>
            <textarea rows={2} value={resolution} onChange={(e) => setResolution(e.target.value)}
              placeholder="Descreva a ação tomada..." className="input resize-none text-sm w-full" />
          </div>
          <div className="flex gap-2 flex-wrap">
            <button onClick={() => handleAction('REVIEWING')} disabled={submitting}
              className="flex-1 px-3 py-2 rounded-button border text-xs font-bold font-sans text-warning border-warning/30 bg-warning/5 disabled:opacity-50">
              Marcar em Análise
            </button>
            <button onClick={() => handleAction('RESOLVED')} disabled={submitting}
              className="flex-1 px-3 py-2 rounded-button border text-xs font-bold font-sans text-success border-success/30 bg-success/5 disabled:opacity-50">
              {submitting ? <span className="w-3 h-3 border border-current border-t-transparent rounded-full animate-spin block mx-auto" /> : 'Resolver'}
            </button>
            <button onClick={() => handleAction('DISMISSED')} disabled={submitting}
              className="flex-1 px-3 py-2 rounded-button border text-xs font-bold font-sans text-secondary border-outline-variant/40 disabled:opacity-50">
              Ignorar
            </button>
          </div>
        </div>
      )}

      {report.resolution && (
        <div className="bg-surface-container rounded-lg p-3">
          <p className="text-[10px] uppercase tracking-wider text-secondary font-sans mb-0.5">Resolução</p>
          <p className="text-sm text-text font-body">{report.resolution}</p>
        </div>
      )}
    </div>
  )
}

// ── Main page ────────────────────────────────────────────────────────────────
export default function GestaoUtilizadores() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const canManage = canManageUsers(user)
  const canReviewReports = hasPermission(user, 'REPORT_REVIEW')
  const currentUserIsSuperAdmin = hasRole(user, 'SUPER_ADMIN')

  // Tabs
  const tabs: { id: TabId; label: string; icon: string }[] = [
    { id: 'utilizadores', label: 'Utilizadores', icon: 'group' },
    { id: 'candidaturas', label: 'Candidaturas', icon: 'edit_note' },
    ...(canReviewReports ? [{ id: 'denuncias' as TabId, label: 'Denúncias', icon: 'flag' }] : []),
  ]
  const [activeTab, setActiveTab] = useState<TabId>('utilizadores')

  // Users state
  const [users, setUsers] = useState<AdminUser[]>([])
  const [usersTotal, setUsersTotal] = useState(0)
  const [usersPage, setUsersPage] = useState(1)
  const [usersLoading, setUsersLoading] = useState(false)
  const [usersError, setUsersError] = useState('')
  const [search, setSearch] = useState('')
  const [searchInput, setSearchInput] = useState('')
  const [filterActive, setFilterActive] = useState<boolean | undefined>(undefined)
  const USER_LIMIT = 20
  const usersLoaded = useRef(false)

  // Writer applications state
  const [apps, setApps] = useState<WriterApplication[]>([])
  const [appsTotal, setAppsTotal] = useState(0)
  const [appsPage, setAppsPage] = useState(1)
  const [appsLoading, setAppsLoading] = useState(false)
  const [appsError, setAppsError] = useState('')
  const [appsStatus, setAppsStatus] = useState('')
  const APP_LIMIT = 20
  const appsLoaded = useRef(false)

  // Reports state
  const [reports, setReports] = useState<Report[]>([])
  const [reportsTotal, setReportsTotal] = useState(0)
  const [reportsPage, setReportsPage] = useState(1)
  const [reportsLoading, setReportsLoading] = useState(false)
  const [reportsError, setReportsError] = useState('')
  const REPORT_LIMIT = 20
  const reportsLoaded = useRef(false)

  async function loadUsers(page: number, q: string, isActive: boolean | undefined) {
    setUsersLoading(true)
    setUsersError('')
    try {
      const data = await userService.listAll({ page, limit: USER_LIMIT, search: q || undefined, isActive })
      if (page === 1) {
        setUsers(data.items)
      } else {
        setUsers((prev) => [...prev, ...data.items])
      }
      setUsersTotal(data.total)
    } catch (err) {
      setUsersError(getErrorMessage(err))
    } finally {
      setUsersLoading(false)
    }
  }

  async function loadApps(page: number, status: string) {
    setAppsLoading(true)
    setAppsError('')
    try {
      const data = await writerApplicationService.listAll({ page, limit: APP_LIMIT, status: status || undefined })
      if (page === 1) {
        setApps(data.items)
      } else {
        setApps((prev) => [...prev, ...data.items])
      }
      setAppsTotal(data.total)
    } catch (err) {
      setAppsError(getErrorMessage(err))
    } finally {
      setAppsLoading(false)
    }
  }

  async function loadReports(page: number) {
    setReportsLoading(true)
    setReportsError('')
    try {
      const data = await reportsService.list({ page, limit: REPORT_LIMIT })
      const items = Array.isArray(data) ? data : (data as { items: Report[] }).items ?? []
      const total = Array.isArray(data) ? items.length : (data as { total: number }).total ?? items.length
      if (page === 1) {
        setReports(items)
      } else {
        setReports((prev) => [...prev, ...items])
      }
      setReportsTotal(total)
    } catch (err) {
      setReportsError(getErrorMessage(err))
    } finally {
      setReportsLoading(false)
    }
  }

  // Lazy load tabs
  useEffect(() => {
    if (activeTab === 'utilizadores' && !usersLoaded.current) {
      usersLoaded.current = true
      loadUsers(1, '', undefined)
    }
    if (activeTab === 'candidaturas' && !appsLoaded.current) {
      appsLoaded.current = true
      loadApps(1, '')
    }
    if (activeTab === 'denuncias' && !reportsLoaded.current) {
      reportsLoaded.current = true
      loadReports(1)
    }
  }, [activeTab])

  function handleSearch(e: React.FormEvent) {
    e.preventDefault()
    const q = searchInput.trim()
    setSearch(q)
    setUsersPage(1)
    loadUsers(1, q, filterActive)
  }

  function handleFilterActive(val: boolean | undefined) {
    setFilterActive(val)
    setUsersPage(1)
    loadUsers(1, search, val)
  }

  function loadMoreUsers() {
    const next = usersPage + 1
    setUsersPage(next)
    loadUsers(next, search, filterActive)
  }

  function handleAppsStatusChange(status: string) {
    setAppsStatus(status)
    setAppsPage(1)
    loadApps(1, status)
  }

  function loadMoreApps() {
    const next = appsPage + 1
    setAppsPage(next)
    loadApps(next, appsStatus)
  }

  function loadMoreReports() {
    const next = reportsPage + 1
    setReportsPage(next)
    loadReports(next)
  }

  if (!canManage) {
    return (
      <AppShell searchPlaceholder="Pesquisar utilizadores...">
        <div className="page-content-narrow text-center py-20">
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">lock</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Acesso Restrito</p>
            <p className="text-body-md text-secondary font-body">A gestão de utilizadores está reservada a administradores.</p>
            <button onClick={() => navigate('/dashboard')} className="btn-primary">Voltar ao Início</button>
          </div>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell searchPlaceholder="Pesquisar utilizadores...">
      <div className="page-content animate-fade-in">
        {/* Header */}
        <div className="section-header mb-6">
          <div>
            <h2 className="section-title">Gestão</h2>
            <p className="section-subtitle">Administre utilizadores, candidaturas e denúncias.</p>
          </div>
          <button onClick={() => navigate('/gestao/conteudos')} className="btn-secondary">
            <span className="material-symbols-outlined text-[18px]">article</span>
            Conteúdos
          </button>
        </div>

        {/* Tabs */}
        <div className="border-b border-outline-variant/25 mb-6">
          <div className="flex gap-1">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-1.5 px-4 py-3 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab.id
                    ? 'border-primary text-primary'
                    : 'border-transparent text-secondary hover:text-text hover:border-outline-variant/40'
                }`}
              >
                <span className="material-symbols-outlined text-[16px]">{tab.icon}</span>
                {tab.label}
              </button>
            ))}
          </div>
        </div>

        {/* ── TAB: Utilizadores ─── */}
        {activeTab === 'utilizadores' && (
          <div className="space-y-5">
            {/* Filters */}
            <div className="flex flex-wrap gap-3 items-center">
              <form onSubmit={handleSearch} className="flex gap-2 flex-1 min-w-[200px] max-w-sm">
                <div className="relative flex-1">
                  <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[16px]">search</span>
                  <input
                    value={searchInput}
                    onChange={(e) => setSearchInput(e.target.value)}
                    placeholder="Pesquisar por nome..."
                    className="input pl-9 text-sm"
                  />
                </div>
                <button type="submit" className="btn-primary text-sm">
                  {usersLoading ? <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Pesquisar'}
                </button>
              </form>
              <div className="flex gap-1.5">
                {([
                  { label: 'Todos', val: undefined },
                  { label: 'Ativos', val: true },
                  { label: 'Suspensos', val: false },
                ] as const).map(({ label, val }) => (
                  <button
                    key={label}
                    onClick={() => handleFilterActive(val)}
                    className={`px-3 py-1.5 rounded-full border text-xs font-semibold font-sans transition-all ${
                      filterActive === val
                        ? 'bg-primary text-white border-primary'
                        : 'border-outline-variant/40 text-secondary hover:border-primary/40'
                    }`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </div>

            {usersError && (
              <div className="alert-error rounded-card">
                <span className="material-symbols-outlined text-error text-[18px]">error_outline</span>
                <p className="text-body-md text-error font-body">{usersError}</p>
              </div>
            )}

            <div className="card p-5">
              {usersLoading && users.length === 0 ? (
                <div className="space-y-4">
                  {[0, 1, 2, 3, 4].map((i) => (
                    <div key={i} className="flex items-center gap-4">
                      <div className="skeleton w-9 h-9 rounded-full flex-shrink-0" />
                      <div className="flex-1 space-y-1.5">
                        <div className="skeleton h-3 w-32 rounded" />
                        <div className="skeleton h-3 w-48 rounded" />
                      </div>
                      <div className="skeleton h-8 w-20 rounded-button" />
                    </div>
                  ))}
                </div>
              ) : users.length === 0 ? (
                <div className="text-center py-10">
                  <span className="material-symbols-outlined text-primary/20 text-[36px] mb-2 block">group_off</span>
                  <p className="text-body-md text-secondary font-body">Nenhum utilizador encontrado.</p>
                </div>
              ) : (
                <>
                  <p className="text-xs text-secondary font-body mb-4">{usersTotal} utilizadores encontrados</p>
                  {users.map((u) => (
                    <UserRow
                      key={u.id}
                      u={u}
                      currentUserId={user?.id ?? ''}
                      currentUserIsSuperAdmin={currentUserIsSuperAdmin}
                      onStatusChange={(id, isActive) =>
                        setUsers((prev) => prev.map((x) => x.id === id ? { ...x, isActive } : x))
                      }
                      onRoleChange={(id, updated) =>
                        setUsers((prev) => prev.map((x) => x.id === id ? { ...x, ...updated } : x))
                      }
                      onRemoved={(id) => {
                        setUsers((prev) => prev.filter((x) => x.id !== id))
                        setUsersTotal((t) => Math.max(0, t - 1))
                      }}
                    />
                  ))}
                  {users.length < usersTotal && (
                    <div className="pt-4 flex justify-center">
                      <button onClick={loadMoreUsers} disabled={usersLoading} className="btn-ghost text-sm">
                        {usersLoading ? (
                          <span className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
                        ) : `Carregar mais (${usersTotal - users.length} restantes)`}
                      </button>
                    </div>
                  )}
                </>
              )}
            </div>
          </div>
        )}

        {/* ── TAB: Candidaturas ─── */}
        {activeTab === 'candidaturas' && (
          <div className="space-y-5">
            {/* Status filter */}
            <div className="flex gap-1.5 flex-wrap">
              {([
                { label: 'Todas', val: '' },
                { label: 'Em análise', val: 'PENDING' },
                { label: 'Aprovadas', val: 'APPROVED' },
                { label: 'Rejeitadas', val: 'REJECTED' },
                { label: 'Revisão', val: 'REQUEST_CHANGES' },
              ]).map(({ label, val }) => (
                <button
                  key={val}
                  onClick={() => handleAppsStatusChange(val)}
                  className={`px-3 py-1.5 rounded-full border text-xs font-semibold font-sans transition-all ${
                    appsStatus === val
                      ? 'bg-primary text-white border-primary'
                      : 'border-outline-variant/40 text-secondary hover:border-primary/40'
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>

            {appsError && (
              <div className="alert-error rounded-card">
                <span className="material-symbols-outlined text-error text-[18px]">error_outline</span>
                <p className="text-body-md text-error font-body">{appsError}</p>
              </div>
            )}

            {appsLoading && apps.length === 0 ? (
              <div className="space-y-4">
                {[0, 1, 2].map((i) => <div key={i} className="skeleton h-28 rounded-card" />)}
              </div>
            ) : apps.length === 0 ? (
              <div className="empty-state py-16">
                <span className="material-symbols-outlined text-primary/20 text-[36px]">edit_note</span>
                <p className="text-headline-md font-bold text-text font-sans">Nenhuma candidatura</p>
                <p className="text-body-md text-secondary font-body">Não existem candidaturas para o filtro selecionado.</p>
              </div>
            ) : (
              <>
                <p className="text-xs text-secondary font-body">{appsTotal} candidatura{appsTotal !== 1 ? 's' : ''}</p>
                <div className="space-y-4">
                  {apps.map((app) => (
                    <WriterAppCard
                      key={app.id}
                      app={app}
                      onReviewed={(id, updated) =>
                        setApps((prev) => prev.map((a) => a.id === id ? updated : a))
                      }
                    />
                  ))}
                </div>
                {apps.length < appsTotal && (
                  <div className="flex justify-center pt-2">
                    <button onClick={loadMoreApps} disabled={appsLoading} className="btn-ghost text-sm">
                      {appsLoading ? (
                        <span className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
                      ) : `Carregar mais (${appsTotal - apps.length} restantes)`}
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        )}

        {/* ── TAB: Denúncias ─── */}
        {activeTab === 'denuncias' && canReviewReports && (
          <div className="space-y-5">
            {reportsError && (
              <div className="alert-error rounded-card">
                <span className="material-symbols-outlined text-error text-[18px]">error_outline</span>
                <p className="text-body-md text-error font-body">{reportsError}</p>
              </div>
            )}

            {reportsLoading && reports.length === 0 ? (
              <div className="space-y-4">
                {[0, 1, 2].map((i) => <div key={i} className="skeleton h-24 rounded-card" />)}
              </div>
            ) : reports.length === 0 ? (
              <div className="empty-state py-16">
                <span className="material-symbols-outlined text-primary/20 text-[36px]">flag</span>
                <p className="text-headline-md font-bold text-text font-sans">Nenhuma denúncia</p>
                <p className="text-body-md text-secondary font-body">Não existem denúncias para rever.</p>
              </div>
            ) : (
              <>
                <p className="text-xs text-secondary font-body">{reportsTotal} denúncia{reportsTotal !== 1 ? 's' : ''}</p>
                <div className="space-y-4">
                  {reports.map((r) => (
                    <ReportCard
                      key={r.id}
                      report={r}
                      onReviewed={(id, updated) =>
                        setReports((prev) => prev.map((x) => x.id === id ? updated : x))
                      }
                    />
                  ))}
                </div>
                {reports.length < reportsTotal && (
                  <div className="flex justify-center pt-2">
                    <button onClick={loadMoreReports} disabled={reportsLoading} className="btn-ghost text-sm">
                      {reportsLoading ? (
                        <span className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
                      ) : `Carregar mais (${reportsTotal - reports.length} restantes)`}
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        )}
      </div>
    </AppShell>
  )
}
