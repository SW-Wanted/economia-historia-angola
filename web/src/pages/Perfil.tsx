import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth, getUserInitials, getUserRole, canCreateContent } from '../contexts/AuthContext'
import { userService } from '../services/api/user.service'
import { quizService } from '../services/api/quiz.service'
import { writerApplicationService } from '../services/api/writer-application.service'
import FileUpload from '../components/ui/FileUpload'
import { IMAGE_CONSTRAINTS } from '../services/api/upload.service'
import { ApiError } from '../services/api/client'
import { getErrorMessage } from '../utils/errors'
import { extractList } from '../services/types/api.types'
import type { Progress, RankingEntry, PaginatedResponse, WriterApplication } from '../services/types/api.types'

const tabs = ['Leituras', 'Contribuições', 'Medalhas', 'Atividade']

const badges = [
  { icon: 'auto_stories',       label: 'Leitor Voraz: 100 artigos lidos',        unlocked: true },
  { icon: 'history_edu',        label: 'Arquivista: 10 documentos enviados',      unlocked: true },
  { icon: 'stars',              label: 'Elite: Top 5% Contribuidores',            unlocked: true },
  { icon: 'groups',             label: 'Mentor: Ajude 50 novos membros',          unlocked: false },
  { icon: 'quiz',               label: 'Especialista: 20 quizzes concluídos',     unlocked: false },
  { icon: 'forum',              label: 'Debatedor: 50 respostas no fórum',        unlocked: false },
]

const APP_STATUS_CONFIG: Record<string, { label: string; icon: string; cls: string; description: string }> = {
  PENDING: {
    label: 'Em análise',
    icon: 'pending',
    cls: 'bg-primary/8 border-primary/20 text-primary',
    description: 'A sua candidatura está a ser analisada pela equipa editorial.',
  },
  APPROVED: {
    label: 'Aprovada',
    icon: 'check_circle',
    cls: 'bg-success/8 border-success/20 text-success',
    description: 'Parabéns! A sua candidatura foi aprovada. Já tem acesso de escritor.',
  },
  REJECTED: {
    label: 'Rejeitada',
    icon: 'cancel',
    cls: 'bg-error/8 border-error/20 text-error',
    description: 'A sua candidatura foi rejeitada.',
  },
  REQUEST_CHANGES: {
    label: 'Revisão solicitada',
    icon: 'rate_review',
    cls: 'bg-warning/8 border-warning/20 text-warning',
    description: 'A equipa editorial solicitou que reveja a sua candidatura.',
  },
}

function getContentTypeRoute(type: string): string {
  if (type === 'VIDEO' || type === 'AUDIO' || type === 'PODCAST') return '/aula-video'
  if (type === 'PDF') return '/documento/detalhe'
  if (type === 'ARTICLE') return '/leitura/jindungo'
  return '/leitura/microtexto'
}

export default function Perfil() {
  const navigate = useNavigate()
  const { user, refreshUser } = useAuth()
  const [activeTab, setActiveTab] = useState('Leituras')
  const [progress, setProgress] = useState<Progress[]>([])
  const [loadingProgress, setLoadingProgress] = useState(true)
  const [myRank, setMyRank] = useState<RankingEntry | null>(null)
  const [rankLoading, setRankLoading] = useState(true)
  const [editing, setEditing] = useState(false)

  // Edit form state
  const [editName, setEditName] = useState('')
  const [editBio, setEditBio] = useState('')
  const [editRegion, setEditRegion] = useState('')
  const [editSchool, setEditSchool] = useState('')
  const [editCourse, setEditCourse] = useState('')
  const [editInterests, setEditInterests] = useState('')
  const [editMotivation, setEditMotivation] = useState('')
  const [editAvatarUrl, setEditAvatarUrl] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState('')

  // Writer application state
  const [writerApp, setWriterApp] = useState<WriterApplication | null>(null)

  useEffect(() => {
    userService.getMyProgress()
      .then((data) => setProgress(Array.isArray(data) ? data : []))
      .catch(() => setProgress([]))
      .finally(() => setLoadingProgress(false))
  }, [])

  useEffect(() => {
    if (!user) { setRankLoading(false); return }
    quizService.getRankings()
      .then((data) => {
        const list = extractList(data as RankingEntry[] | PaginatedResponse<RankingEntry>)
        setMyRank(list.find((r) => r.userId === user.id) ?? null)
      })
      .catch(() => {})
      .finally(() => setRankLoading(false))
  }, [user])

  useEffect(() => {
    writerApplicationService.findMine()
      .then((app) => setWriterApp(app))
      .catch((err) => {
        if (err instanceof ApiError && err.statusCode === 404) return
        // ignore other errors silently
      })
  }, [])

  function startEdit() {
    setEditName(user?.name ?? '')
    setEditBio(user?.bio ?? '')
    setEditRegion(user?.region ?? '')
    setEditSchool(user?.school ?? '')
    setEditCourse(user?.course ?? '')
    setEditInterests(user?.interests ?? '')
    setEditMotivation(user?.motivation ?? '')
    setEditAvatarUrl(user?.avatarUrl ?? null)
    setSaveError('')
    setEditing(true)
  }

  async function handleSave() {
    setSaving(true)
    setSaveError('')
    try {
      await userService.updateProfile({
        name: editName.trim() || undefined,
        bio: editBio.trim() || undefined,
        region: editRegion.trim() || undefined,
        school: editSchool.trim() || undefined,
        course: editCourse.trim() || undefined,
        interests: editInterests.trim() || undefined,
        motivation: editMotivation.trim() || undefined,
        // '' limpa o avatar no backend (removido); URL preenchida define-o.
        avatarUrl: editAvatarUrl ?? '',
      })
      await refreshUser()
      setEditing(false)
    } catch (err) {
      setSaveError(getErrorMessage(err))
    } finally {
      setSaving(false)
    }
  }

  const canContribute = canCreateContent(user)
  const initials = getUserInitials(user)
  const role = getUserRole(user)
  const memberSince = user?.createdAt
    ? new Date(user.createdAt).toLocaleDateString('pt-PT', { month: 'long', year: 'numeric' })
    : '—'

  const completed = progress.filter((p) => p.completedAt)
  const inProg = progress.filter((p) => !p.completedAt && p.percentage > 0)
  const displayReadings = [...completed, ...inProg].slice(0, 12)
  const unlockedBadges = badges.filter((b) => b.unlocked)

  return (
    <AppShell showSearch={false}>
      <div className="page-content animate-fade-in">

        {/* Profile hero */}
        <section className="card overflow-hidden mb-8">
          <div className="h-24 relative" style={{ background: 'linear-gradient(135deg, #8B1A1A 0%, #5A1010 100%)' }}>
            <div className="absolute inset-0 opacity-[0.04]"
              style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
          </div>
          <div className="px-7 pb-7 relative">
            <div className="flex items-end justify-between -mt-10 mb-5">
              <div className="relative">
                <div className="w-20 h-20 rounded-2xl bg-white border-4 border-white shadow-md flex items-center justify-center overflow-hidden">
                  {user?.avatarUrl ? (
                    <img src={user.avatarUrl} alt={user.name} className="w-full h-full object-cover" />
                  ) : (
                    <span className="text-2xl font-bold text-primary font-sans leading-none">{initials}</span>
                  )}
                </div>
                <div className="absolute -bottom-1.5 -right-1.5 bg-primary text-white w-6 h-6 rounded-full flex items-center justify-center shadow-sm">
                  <span className="material-symbols-outlined text-[13px]"
                    style={{ fontVariationSettings: "'FILL' 1" }}>verified</span>
                </div>
              </div>
              {!editing && (
                <button onClick={startEdit} className="btn-secondary mt-10">
                  <span className="material-symbols-outlined text-[17px]">edit</span>
                  Editar Perfil
                </button>
              )}
            </div>

            {editing ? (
              <div className="space-y-4">
                <FileUpload
                  id="avatar-upload"
                  label="Foto de Perfil"
                  hint="JPG, PNG, WebP ou GIF · máx. 5 MB"
                  variant="image"
                  constraints={IMAGE_CONSTRAINTS}
                  existingUrl={editAvatarUrl}
                  disabled={saving}
                  onUploaded={(result) => setEditAvatarUrl(result?.publicUrl ?? null)}
                />
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-label-lg text-text-muted font-sans mb-1.5">Nome</label>
                    <input value={editName} onChange={(e) => setEditName(e.target.value)} className="input" />
                  </div>
                  <div>
                    <label className="block text-label-lg text-text-muted font-sans mb-1.5">Região</label>
                    <input value={editRegion} onChange={(e) => setEditRegion(e.target.value)} placeholder="ex: Luanda" className="input" />
                  </div>
                  <div>
                    <label className="block text-label-lg text-text-muted font-sans mb-1.5">Escola / Instituição</label>
                    <input value={editSchool} onChange={(e) => setEditSchool(e.target.value)} placeholder="ex: Universidade Agostinho Neto" className="input" />
                  </div>
                  <div>
                    <label className="block text-label-lg text-text-muted font-sans mb-1.5">Curso</label>
                    <input value={editCourse} onChange={(e) => setEditCourse(e.target.value)} placeholder="ex: Economia" className="input" />
                  </div>
                </div>
                <div>
                  <label className="block text-label-lg text-text-muted font-sans mb-1.5">Bio</label>
                  <textarea value={editBio} onChange={(e) => setEditBio(e.target.value)} rows={2}
                    placeholder="Escreva uma breve bio..." className="input resize-none" />
                </div>
                <div>
                  <label className="block text-label-lg text-text-muted font-sans mb-1.5">
                    Áreas de Interesse
                    <span className="ml-1 text-[10px] text-outline font-body normal-case">(separadas por vírgula)</span>
                  </label>
                  <input value={editInterests} onChange={(e) => setEditInterests(e.target.value)}
                    placeholder="ex: Economia Colonial, Petróleo, Comércio" className="input" />
                </div>
                <div>
                  <label className="block text-label-lg text-text-muted font-sans mb-1.5">Motivação</label>
                  <textarea value={editMotivation} onChange={(e) => setEditMotivation(e.target.value)} rows={2}
                    placeholder="Por que estuda a história económica de Angola?" className="input resize-none" />
                </div>
                {saveError && (
                  <div className="alert-error rounded-button">
                    <p className="text-sm text-error font-body">{saveError}</p>
                  </div>
                )}
                <div className="flex gap-3">
                  <button onClick={() => setEditing(false)} className="btn-ghost">Cancelar</button>
                  <button onClick={handleSave} disabled={saving} className="btn-primary">
                    {saving && <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />}
                    Guardar
                  </button>
                </div>
              </div>
            ) : (
              <div>
                <div className="flex items-center gap-3 flex-wrap mb-2">
                  <h1 className="text-headline-xl font-bold text-text font-sans tracking-tight">{user?.name ?? '—'}</h1>
                  <span className="badge-primary">{role}</span>
                </div>
                {user?.bio ? (
                  <p className="text-body-md text-secondary font-body leading-relaxed mb-3 max-w-xl">{user.bio}</p>
                ) : (
                  <p className="text-body-md text-outline italic font-body mb-3">Adicione uma bio ao seu perfil.</p>
                )}
                <div className="flex flex-wrap gap-x-5 gap-y-1.5 text-secondary mb-3">
                  <span className="text-[12px] font-body flex items-center gap-1.5">
                    <span className="material-symbols-outlined text-[14px]">calendar_today</span>
                    Membro desde {memberSince}
                  </span>
                  {user?.region && (
                    <span className="text-[12px] font-body flex items-center gap-1.5">
                      <span className="material-symbols-outlined text-[14px]">location_on</span>
                      {user.region}
                    </span>
                  )}
                  {user?.school && (
                    <span className="text-[12px] font-body flex items-center gap-1.5">
                      <span className="material-symbols-outlined text-[14px]">school</span>
                      {user.school}{user.course ? ` · ${user.course}` : ''}
                    </span>
                  )}
                  {user?.email && (
                    <span className="text-[12px] font-body flex items-center gap-1.5">
                      <span className="material-symbols-outlined text-[14px]">mail</span>
                      {user.email}
                    </span>
                  )}
                </div>
                {user?.interests && (
                  <div className="flex flex-wrap gap-1.5">
                    {user.interests.split(',').map((i) => i.trim()).filter(Boolean).map((interest) => (
                      <span key={interest} className="badge-outline text-[11px]">{interest}</span>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        </section>

        {/* Stats */}
        <section className="grid grid-cols-3 gap-4 mb-8">
          {[
            { icon: 'menu_book',        value: String(completed.length),       label: 'Artigos Lidos',  route: '/explorar' },
            { icon: 'auto_stories',     value: String(progress.length),        label: 'Iniciados',      route: null },
            { icon: 'workspace_premium',value: String(unlockedBadges.length),  label: 'Medalhas',       route: null },
          ].map((s) => (
            <div
              key={s.label}
              onClick={() => s.route && navigate(s.route)}
              className={`stat-card text-center items-center ${s.route ? 'cursor-pointer hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200' : ''}`}
            >
              <div className="w-10 h-10 rounded-xl bg-primary/8 flex items-center justify-center mb-3">
                <span className="material-symbols-outlined text-primary text-[22px]">{s.icon}</span>
              </div>
              <p className="stat-value">{loadingProgress ? '…' : s.value}</p>
              <p className="stat-label">{s.label}</p>
            </div>
          ))}
        </section>

        {/* Writer application status */}
        {writerApp && (() => {
          const cfg = APP_STATUS_CONFIG[writerApp.status]
          if (!cfg) return null
          return (
            <section className={`rounded-card border p-5 mb-8 flex items-start gap-4 ${cfg.cls}`}>
              <span className="material-symbols-outlined text-[24px] flex-shrink-0 mt-0.5"
                style={{ fontVariationSettings: "'FILL' 1" }}>{cfg.icon}</span>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <p className="text-sm font-bold font-sans">Candidatura de Escritor · {cfg.label}</p>
                </div>
                <p className="text-sm font-body opacity-80 leading-relaxed">{cfg.description}</p>
                {writerApp.reviewNotes && (
                  <p className="text-sm font-body mt-2 opacity-80">
                    <span className="font-semibold">Nota da equipa:</span> {writerApp.reviewNotes}
                  </p>
                )}
                {writerApp.rejectionReason && (
                  <p className="text-sm font-body mt-2 opacity-80">
                    <span className="font-semibold">Motivo:</span> {writerApp.rejectionReason}
                  </p>
                )}
                {writerApp.status === 'REQUEST_CHANGES' && (
                  <p className="text-xs font-body mt-3 opacity-70">
                    Contacte a equipa editorial para resubmeter a sua candidatura com as alterações solicitadas.
                  </p>
                )}
              </div>
            </section>
          )
        })()}

        {/* Tabs */}
        <div className="border-b border-outline-variant/25 mb-7">
          <div className="flex gap-1">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`px-4 py-3 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab
                    ? 'border-primary text-primary'
                    : 'border-transparent text-secondary hover:text-text hover:border-outline-variant/40'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {/* Tab: Leituras */}
        {activeTab === 'Leituras' && (
          loadingProgress ? (
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
              {[0, 1, 2].map((i) => <div key={i} className="skeleton h-48 rounded-card" />)}
            </div>
          ) : displayReadings.length === 0 ? (
            <div className="empty-state">
              <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
                <span className="material-symbols-outlined text-primary/40 text-[30px]">auto_stories</span>
              </div>
              <p className="text-headline-md font-bold text-text font-sans">Nenhuma leitura ainda</p>
              <p className="text-body-md text-secondary font-body">Explore o arquivo e comece a sua jornada.</p>
              <button onClick={() => navigate('/explorar')} className="btn-primary">Explorar Arquivo</button>
            </div>
          ) : (
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
              {displayReadings.map((r) => (
                <div
                  key={r.id}
                  onClick={() => navigate(getContentTypeRoute(r.content.type), { state: { contentId: r.content.id } })}
                  className="content-card group"
                >
                  <div className="h-28 bg-gradient-to-br from-surface-container to-surface-container-high flex items-center justify-center overflow-hidden">
                    <span className="material-symbols-outlined text-primary/20 group-hover:scale-105 transition-transform duration-300"
                      style={{ fontSize: '48px' }}>history_edu</span>
                  </div>
                  <div className="p-4 flex flex-col gap-2 flex-grow">
                    <span className="badge-primary w-fit">{r.content.type}</span>
                    <h4 className="text-title-md font-semibold text-text font-sans leading-snug line-clamp-2 group-hover:text-primary transition-colors">
                      {r.content.title}
                    </h4>
                    <div className="mt-auto pt-2">
                      <div className="flex justify-between text-[11px] font-body text-secondary mb-1">
                        <span>{r.percentage}% concluído</span>
                        {r.completedAt && <span className="text-success font-semibold font-sans">✓ Concluído</span>}
                      </div>
                      <div className="w-full bg-surface-container h-1 rounded-full overflow-hidden">
                        <div className="h-full bg-primary transition-all" style={{ width: `${r.percentage}%` }} />
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )
        )}

        {/* Tab: Medalhas */}
        {activeTab === 'Medalhas' && (
          <div className="grid grid-cols-3 md:grid-cols-6 gap-4">
            {badges.map((badge) => (
              <div
                key={badge.icon}
                title={badge.label}
                className={`aspect-square rounded-card flex flex-col items-center justify-center gap-2 group relative cursor-help p-3 ${
                  badge.unlocked
                    ? 'bg-primary/8 border border-primary/20'
                    : 'bg-surface border border-outline-variant/30 opacity-35'
                }`}
              >
                <span className={`material-symbols-outlined text-3xl ${badge.unlocked ? 'text-primary' : 'text-secondary'}`}
                  style={badge.unlocked ? { fontVariationSettings: "'FILL' 1" } : undefined}>
                  {badge.icon}
                </span>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-36 bg-text text-white text-[10px] p-2 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-150 pointer-events-none z-10 text-center leading-snug">
                  {badge.label}
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Tab: Contribuições */}
        {activeTab === 'Contribuições' && (
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">cloud_upload</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Contribuições</p>
            <p className="text-body-md text-secondary font-body max-w-sm text-center leading-relaxed">
              Submeta documentos históricos, análises e artigos para o arquivo digital.
            </p>
            {canContribute ? (
              <button onClick={() => navigate('/gestao/submeter-artigo')} className="btn-primary">
                <span className="material-symbols-outlined text-[18px]">upload</span>
                Submeter Documento
              </button>
            ) : (
              <p className="text-[12px] text-outline font-body text-center max-w-xs">
                A submissão está disponível para escritores, professores e administradores.
              </p>
            )}
          </div>
        )}

        {/* Tab: Atividade */}
        {activeTab === 'Atividade' && (
          rankLoading ? (
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
              {[0, 1, 2].map((i) => <div key={i} className="skeleton h-28 rounded-card" />)}
            </div>
          ) : (
            <div className="space-y-5">
              <div className="card p-6">
                <div className="flex items-center gap-3 mb-5">
                  <div className="w-10 h-10 rounded-xl bg-primary/8 flex items-center justify-center">
                    <span className="material-symbols-outlined text-primary text-[22px]"
                      style={{ fontVariationSettings: "'FILL' 1" }}>quiz</span>
                  </div>
                  <div>
                    <h3 className="text-sm font-bold text-text font-sans">Desempenho em Quizzes</h3>
                    <p className="text-[11px] text-secondary font-body">Ranking global</p>
                  </div>
                  {myRank?.rank && (
                    <span className="ml-auto badge bg-primary/10 text-primary font-bold">#{myRank.rank}</span>
                  )}
                </div>
                <div className="grid grid-cols-3 gap-4">
                  {[
                    { label: 'Pontos', value: myRank ? String(myRank.score) : '0', icon: 'stars' },
                    { label: 'Quizzes', value: myRank ? String(myRank.attempts) : '0', icon: 'quiz' },
                    { label: 'Posição', value: myRank?.rank ? `#${myRank.rank}` : '—', icon: 'emoji_events' },
                  ].map((s) => (
                    <div key={s.label} className="text-center p-3 bg-surface-container rounded-xl">
                      <span className="material-symbols-outlined text-primary/60 text-[20px] mb-1 block">{s.icon}</span>
                      <p className="text-lg font-bold text-text font-sans leading-none mb-1">{s.value}</p>
                      <p className="text-[10px] text-secondary font-body uppercase tracking-wide">{s.label}</p>
                    </div>
                  ))}
                </div>
                {!myRank && (
                  <div className="mt-4 pt-4 border-t border-outline-variant/20 text-center">
                    <p className="text-sm text-secondary font-body mb-3">Complete quizzes para aparecer no ranking.</p>
                    <button onClick={() => navigate('/quiz')} className="btn-primary mx-auto text-sm">
                      <span className="material-symbols-outlined text-[16px]">quiz</span>
                      Fazer um Quiz
                    </button>
                  </div>
                )}
              </div>

              <div className="card p-6">
                <div className="flex items-center gap-3 mb-5">
                  <div className="w-10 h-10 rounded-xl bg-primary/8 flex items-center justify-center">
                    <span className="material-symbols-outlined text-primary text-[22px]">auto_stories</span>
                  </div>
                  <h3 className="text-sm font-bold text-text font-sans">Atividade de Leitura</h3>
                </div>
                <div className="grid grid-cols-3 gap-4">
                  {[
                    { label: 'Concluídos', value: loadingProgress ? '…' : String(progress.filter((p) => p.completedAt).length), icon: 'check_circle' },
                    { label: 'Em Curso',   value: loadingProgress ? '…' : String(progress.filter((p) => !p.completedAt && p.percentage > 0).length), icon: 'pending' },
                    { label: 'Total',      value: loadingProgress ? '…' : String(progress.length), icon: 'library_books' },
                  ].map((s) => (
                    <div key={s.label} className="text-center p-3 bg-surface-container rounded-xl">
                      <span className="material-symbols-outlined text-primary/60 text-[20px] mb-1 block">{s.icon}</span>
                      <p className="text-lg font-bold text-text font-sans leading-none mb-1">{s.value}</p>
                      <p className="text-[10px] text-secondary font-body uppercase tracking-wide">{s.label}</p>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )
        )}
      </div>
    </AppShell>
  )
}
