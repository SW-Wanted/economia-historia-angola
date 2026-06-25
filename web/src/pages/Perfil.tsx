import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth, getUserInitials, getUserRole, canCreateContent } from '../contexts/AuthContext'
import { userService } from '../services/api/user.service'
import { getErrorMessage } from '../utils/errors'
import type { Progress } from '../services/types/api.types'

const tabs = ['Leituras', 'Contribuições', 'Medalhas', 'Atividade']

const badges = [
  { icon: 'auto_stories', label: 'Leitor Voraz: 100 artigos lidos', unlocked: true },
  { icon: 'history_edu', label: 'Arquivista: 10 documentos enviados', unlocked: true },
  { icon: 'stars', label: 'Elite: Top 5% Contribuidores', unlocked: true },
  { icon: 'groups', label: 'Mentor: Ajude 50 novos membros', unlocked: false },
  { icon: 'quiz', label: 'Especialista em Quiz: 20 quizzes', unlocked: false },
  { icon: 'forum', label: 'Debatedor: 50 respostas no fórum', unlocked: false },
]

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

  // Inline edit state
  const [editing, setEditing] = useState(false)
  const [editName, setEditName] = useState('')
  const [editBio, setEditBio] = useState('')
  const [editRegion, setEditRegion] = useState('')
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState('')

  useEffect(() => {
    userService
      .getMyProgress()
      .then((data) => setProgress(Array.isArray(data) ? data : []))
      .catch(() => setProgress([]))
      .finally(() => setLoadingProgress(false))
  }, [])

  function startEdit() {
    setEditName(user?.name ?? '')
    setEditBio(user?.bio ?? '')
    setEditRegion(user?.region ?? '')
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

  const completedReadings = progress.filter((p) => p.completedAt)
  const inProgressReadings = progress.filter((p) => !p.completedAt && p.percentage > 0)
  const displayReadings = [...completedReadings, ...inProgressReadings].slice(0, 10)

  return (
    <AppShell title="Perfil do Investigador" showSearch={false}>
      <div className="px-10 py-10 max-w-[1160px] mx-auto space-y-8">
        {/* Hero */}
        <section className="bg-white p-7 rounded-xl shadow-card flex flex-col md:flex-row gap-7 items-start border border-[#ebe5e4]">
          <div className="relative flex-shrink-0">
            <div className="w-28 h-28 rounded-2xl bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border-4 border-white shadow-sm flex items-center justify-center">
              {user?.avatarUrl ? (
                <img src={user.avatarUrl} alt={user.name} className="w-full h-full object-cover rounded-2xl" />
              ) : (
                <span className="text-3xl font-bold text-[#8B1A1A]/40 font-sans leading-none">{initials}</span>
              )}
            </div>
            <div className="absolute -bottom-2 -right-2 bg-[#8B1A1A] text-white p-1.5 rounded-full shadow-md">
              <span className="material-symbols-outlined text-[14px]" style={{ fontVariationSettings: "'FILL' 1" }}>verified</span>
            </div>
          </div>

          {editing ? (
            <div className="flex-1 space-y-3 min-w-0">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                <div className="flex flex-col gap-1">
                  <label className="text-xs font-semibold text-[#58413f] font-sans">Nome</label>
                  <input
                    value={editName}
                    onChange={(e) => setEditName(e.target.value)}
                    className="bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg px-3 py-2 text-sm font-sans focus:ring-1 focus:ring-[#8B1A1A] outline-none"
                  />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-xs font-semibold text-[#58413f] font-sans">Região</label>
                  <input
                    value={editRegion}
                    onChange={(e) => setEditRegion(e.target.value)}
                    placeholder="ex: Luanda"
                    className="bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg px-3 py-2 text-sm font-sans focus:ring-1 focus:ring-[#8B1A1A] outline-none"
                  />
                </div>
              </div>
              <div className="flex flex-col gap-1">
                <label className="text-xs font-semibold text-[#58413f] font-sans">Bio</label>
                <textarea
                  value={editBio}
                  onChange={(e) => setEditBio(e.target.value)}
                  rows={2}
                  placeholder="Escreva uma breve bio..."
                  className="bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg px-3 py-2 text-sm font-serif focus:ring-1 focus:ring-[#8B1A1A] outline-none resize-none"
                />
              </div>
              {saveError && (
                <p className="text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">{saveError}</p>
              )}
              <div className="flex gap-2 pt-1">
                <button
                  onClick={() => setEditing(false)}
                  className="border border-[#e0bfbc] text-[#5d5f5d] px-4 py-2 rounded-full text-xs font-semibold font-sans hover:bg-[#f0eded] transition-all"
                >
                  Cancelar
                </button>
                <button
                  onClick={handleSave}
                  disabled={saving}
                  className="bg-[#8B1A1A] text-white px-5 py-2 rounded-full text-xs font-semibold font-sans hover:bg-[#7a1616] disabled:opacity-60 transition-all flex items-center gap-1.5"
                >
                  {saving && <span className="w-3 h-3 border-2 border-white border-t-transparent rounded-full animate-spin" />}
                  Guardar
                </button>
              </div>
            </div>
          ) : (
            <div className="flex-1 space-y-3 min-w-0">
              <div className="flex items-center gap-3 flex-wrap">
                <h1 className="text-[28px] font-bold text-[#1c1b1b] font-sans tracking-tight">{user?.name ?? '—'}</h1>
                <span className="bg-[#fff5f4] text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold font-sans border border-[#8B1A1A]/15">{role}</span>
              </div>
              {user?.bio ? (
                <p className="text-sm text-[#5d5f5d] max-w-2xl font-serif leading-relaxed">{user.bio}</p>
              ) : (
                <p className="text-sm text-[#8c716e] font-serif italic">Sem bio definida.</p>
              )}
              <div className="flex flex-wrap gap-5 pt-1">
                <div className="flex items-center gap-1.5 text-[#8c716e]">
                  <span className="material-symbols-outlined text-[16px]">calendar_today</span>
                  <span className="text-xs font-sans">Membro desde {memberSince}</span>
                </div>
                {user?.region && (
                  <div className="flex items-center gap-1.5 text-[#8c716e]">
                    <span className="material-symbols-outlined text-[16px]">location_on</span>
                    <span className="text-xs font-sans">{user.region}</span>
                  </div>
                )}
                {user?.email && (
                  <div className="flex items-center gap-1.5 text-[#8c716e]">
                    <span className="material-symbols-outlined text-[16px]">mail</span>
                    <span className="text-xs font-sans">{user.email}</span>
                  </div>
                )}
              </div>
            </div>
          )}

          {!editing && (
            <button
              onClick={startEdit}
              className="bg-[#8B1A1A] text-white px-5 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] active:scale-[0.98] transition-all duration-150 whitespace-nowrap"
            >
              Editar Perfil
            </button>
          )}
        </section>

        {/* Stats */}
        <section className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {[
            { icon: 'menu_book', value: String(completedReadings.length), label: 'Artigos Lidos', route: '/explorar' },
            { icon: 'auto_stories', value: String(progress.length), label: 'Conteúdos Iniciados', route: null },
            { icon: 'workspace_premium', value: String(badges.filter((b) => b.unlocked).length), label: 'Medalhas Desbloqueadas', route: null },
          ].map((stat) => (
            <button
              key={stat.label}
              onClick={() => stat.route && navigate(stat.route)}
              className={`bg-white p-6 rounded-xl shadow-card border border-[#ebe5e4] text-center ${stat.route ? 'hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer' : ''}`}
            >
              <span className="w-10 h-10 rounded-xl bg-[#fff5f4] flex items-center justify-center mx-auto mb-4">
                <span className="material-symbols-outlined text-[#8B1A1A] text-[22px]">{stat.icon}</span>
              </span>
              <h3 className="text-[40px] font-extrabold text-[#1c1b1b] leading-none font-sans mb-1">{stat.value}</h3>
              <p className="text-xs font-semibold text-[#8c716e] uppercase tracking-[0.08em] font-sans">{stat.label}</p>
            </button>
          ))}
        </section>

        {/* Tabs */}
        <div className="border-b border-[#ebe5e4]">
          <div className="flex gap-6">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3.5 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab
                    ? 'border-[#8B1A1A] text-[#8B1A1A]'
                    : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {/* Tab content */}
        {activeTab === 'Leituras' && (
          <>
            {loadingProgress ? (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                {[0, 1].map((i) => (
                  <div key={i} className="bg-white rounded-xl h-48 border border-[#ebe5e4] animate-pulse" />
                ))}
              </div>
            ) : displayReadings.length === 0 ? (
              <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
                <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">auto_stories</span>
                <p className="text-sm text-[#5d5f5d] font-serif">Ainda não iniciou nenhuma leitura.</p>
                <button onClick={() => navigate('/explorar')} className="mt-4 text-sm font-semibold text-[#8B1A1A] hover:underline font-sans">
                  Explorar conteúdos →
                </button>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                {displayReadings.map((r) => (
                  <div
                    key={r.id}
                    onClick={() => navigate(getContentTypeRoute(r.content.type), { state: { contentId: r.content.id } })}
                    className="bg-white rounded-xl overflow-hidden shadow-card border border-[#ebe5e4] hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 group cursor-pointer"
                  >
                    <div className="h-36 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center">
                      <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '64px' }}>history_edu</span>
                    </div>
                    <div className="p-4 space-y-2">
                      <span className="bg-[#fff5f4] text-[#8B1A1A] px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">{r.content.type}</span>
                      <h4 className="text-base font-semibold text-[#1c1b1b] line-clamp-2 font-sans leading-snug">{r.content.title}</h4>
                      <div className="w-full bg-[#f0eded] h-1.5 rounded-full overflow-hidden">
                        <div className="bg-[#8B1A1A] h-full transition-all" style={{ width: `${r.percentage}%` }} />
                      </div>
                      <div className="flex justify-between items-center text-[#8c716e] text-xs font-sans">
                        <span>{r.percentage}% Concluído</span>
                        {r.completedAt && <span className="text-emerald-600 font-semibold">Concluído</span>}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        )}

        {activeTab === 'Medalhas' && (
          <div className="grid grid-cols-3 md:grid-cols-6 gap-4">
            {badges.map((badge) => (
              <div
                key={badge.icon}
                className={`aspect-square rounded-2xl flex items-center justify-center group relative cursor-help ${
                  badge.unlocked ? 'bg-[#fff5f4] border border-[#8B1A1A]/15' : 'bg-[#f8f5f4] border border-[#ebe5e4] grayscale opacity-40'
                }`}
              >
                <span
                  className={`material-symbols-outlined text-3xl ${badge.unlocked ? 'text-[#8B1A1A]' : 'text-[#5d5f5d]'}`}
                  style={badge.unlocked ? { fontVariationSettings: "'FILL' 1" } : undefined}
                >
                  {badge.icon}
                </span>
                <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-36 bg-[#2a2929] text-white text-[10px] p-2 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-150 pointer-events-none z-10 text-center leading-snug">
                  {badge.label}
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'Contribuições' && (
          <div className="bg-white rounded-xl p-8 border border-[#ebe5e4] shadow-card text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 mb-3" style={{ fontSize: '64px' }}>cloud_upload</span>
            <h3 className="text-2xl font-bold text-[#1c1b1b] mb-1.5 font-sans">Contribuições</h3>
            <p className="text-sm text-[#5d5f5d] mb-6 font-serif leading-relaxed max-w-sm mx-auto">Submeta documentos históricos para o arquivo digital.</p>
            {canContribute ? (
              <button
                onClick={() => navigate('/gestao/submeter-artigo')}
                className="bg-[#8B1A1A] text-white px-7 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] active:scale-[0.98] transition-all duration-150"
              >
                Submeter Novo Documento
              </button>
            ) : (
              <p className="text-xs text-[#8c716e] font-sans">
                A submissão de documentos está disponível para escritores e professores.
              </p>
            )}
          </div>
        )}

        {activeTab === 'Atividade' && (
          <div className="bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 mb-3 block" style={{ fontSize: '64px' }}>timeline</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Histórico de atividade disponível brevemente.</p>
          </div>
        )}
      </div>
    </AppShell>
  )
}
