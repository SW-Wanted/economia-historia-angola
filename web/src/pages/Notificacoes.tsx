import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { notificationService } from '../services/api/notification.service'
import type { Notification } from '../services/types/api.types'

const TYPE_ICONS: Record<string, string> = {
  SYSTEM: 'info',
  CONTENT: 'article',
  COMMENT: 'forum',
  COMMUNITY: 'groups',
  FORUM: 'forum',
  QUIZ: 'quiz',
  MODERATION: 'admin_panel_settings',
}

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 1) return 'Agora mesmo'
  if (mins < 60) return `Há ${mins} min`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `Há ${hours} hora${hours > 1 ? 's' : ''}`
  const days = Math.floor(hours / 24)
  return `Há ${days} dia${days > 1 ? 's' : ''}`
}

export default function Notificacoes() {
  const navigate = useNavigate()
  const [notifications, setNotifications] = useState<Notification[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    notificationService
      .list()
      .then((data) => setNotifications(Array.isArray(data) ? data : []))
      .catch(() => setError('Não foi possível carregar as notificações.'))
      .finally(() => setLoading(false))
  }, [])

  async function markAllRead() {
    const unread = notifications.filter((n) => !n.readAt)
    await Promise.all(unread.map((n) => notificationService.markRead(n.id).catch(() => {})))
    setNotifications((prev) => prev.map((n) => ({ ...n, readAt: n.readAt ?? new Date().toISOString() })))
  }

  async function handleClick(notification: Notification) {
    if (!notification.readAt) {
      await notificationService.markRead(notification.id).catch(() => {})
      setNotifications((prev) =>
        prev.map((n) => n.id === notification.id ? { ...n, readAt: new Date().toISOString() } : n)
      )
    }
    const data = notification.data as { route?: string; contentId?: string } | null
    const route = data?.route
    if (route && typeof route === 'string') { navigate(route); return }
    const fallbacks: Record<string, string> = {
      CONTENT: '/explorar', COMMENT: '/forum', FORUM: '/forum',
      COMMUNITY: '/forum', QUIZ: '/quiz', MODERATION: '/dashboard', SYSTEM: '/dashboard',
    }
    const fallback = fallbacks[notification.type]
    if (fallback) navigate(fallback)
  }

  const unreadCount = notifications.filter((n) => !n.readAt).length

  return (
    <AppShell title="Notificações" showSearch={false}>
      <div className="page-content-narrow animate-fade-in">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-headline-md font-bold text-text font-sans tracking-tight">Notificações</h2>
            {unreadCount > 0 && (
              <p className="text-label-md text-outline mt-0.5 font-body">{unreadCount} não lida{unreadCount > 1 ? 's' : ''}</p>
            )}
          </div>
          {unreadCount > 0 && (
            <button
              onClick={markAllRead}
              className="text-sm font-semibold text-primary hover:text-primary-dark transition-colors duration-150 font-sans"
            >
              Marcar todas como lidas
            </button>
          )}
        </div>

        {loading && (
          <div className="flex flex-col gap-2.5">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="bg-surface rounded-card h-16 border border-outline-variant/45 animate-pulse" />
            ))}
          </div>
        )}

        {!loading && error && (
          <div className="bg-error-container/40 border border-error/20 rounded-card p-6 text-center">
            <p className="text-sm text-error font-body">{error}</p>
          </div>
        )}

        {!loading && !error && notifications.length === 0 && (
          <div className="bg-surface rounded-card p-10 border border-outline-variant/45 text-center">
            <span className="material-symbols-outlined text-primary/30 text-5xl mb-3 block">notifications_none</span>
            <p className="text-body-md font-body text-secondary">Não tem notificações de momento.</p>
          </div>
        )}

        {!loading && !error && notifications.length > 0 && (
          <div className="flex flex-col gap-2.5">
            {notifications.map((n) => {
              const isUnread = !n.readAt
              const icon = TYPE_ICONS[n.type] ?? 'notifications'
              return (
                <div
                  key={n.id}
                  onClick={() => handleClick(n)}
                  className={`rounded-card p-4 border transition-all duration-200 cursor-pointer flex items-start gap-3.5 group hover:shadow-card-hover hover:-translate-y-0.5 ${
                    isUnread
                      ? 'border-primary/20 bg-surface-warm'
                      : 'bg-surface border-outline-variant/45'
                  }`}
                >
                  <div className={`w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 ${isUnread ? 'bg-primary text-white' : 'bg-surface-container-low text-secondary'}`}>
                    <span className="material-symbols-outlined text-[18px]">{icon}</span>
                  </div>
                  <div className="flex-grow min-w-0">
                    <div className="flex items-start justify-between gap-4">
                      <h3 className={`text-sm font-bold font-sans ${isUnread ? 'text-primary' : 'text-text'}`}>{n.title}</h3>
                      <span className="text-[10px] text-outline whitespace-nowrap font-body">{timeAgo(n.createdAt)}</span>
                    </div>
                    <p className="text-body-md font-body text-secondary mt-1 leading-relaxed">{n.body}</p>
                  </div>
                  {isUnread && <div className="w-1.5 h-1.5 bg-primary rounded-full mt-2 flex-shrink-0" />}
                </div>
              )
            })}
          </div>
        )}
      </div>
    </AppShell>
  )
}
