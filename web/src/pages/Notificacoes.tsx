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
    if (route && typeof route === 'string') {
      navigate(route)
      return
    }
    // Type-based fallback
    const fallbacks: Record<string, string> = {
      CONTENT: '/explorar',
      COMMENT: '/forum',
      FORUM: '/forum',
      COMMUNITY: '/forum',
      QUIZ: '/quiz',
      MODERATION: '/dashboard',
      SYSTEM: '/dashboard',
    }
    const fallback = fallbacks[notification.type]
    if (fallback) navigate(fallback)
  }

  const unreadCount = notifications.filter((n) => !n.readAt).length

  return (
    <AppShell title="Notificações" showSearch={false}>
      <div className="px-10 py-10 max-w-[760px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[32px] font-bold text-[#1c1b1b] font-sans tracking-tight">Notificações</h2>
            {unreadCount > 0 && (
              <p className="text-xs text-[#8c716e] mt-0.5 font-sans">{unreadCount} não lida{unreadCount > 1 ? 's' : ''}</p>
            )}
          </div>
          {unreadCount > 0 && (
            <button
              onClick={markAllRead}
              className="text-sm font-semibold text-[#8B1A1A] hover:text-[#7a1616] transition-colors duration-150 font-sans"
            >
              Marcar todas como lidas
            </button>
          )}
        </div>

        {loading && (
          <div className="flex flex-col gap-2.5">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="bg-white rounded-xl h-16 border border-[#ebe5e4] animate-pulse" />
            ))}
          </div>
        )}

        {!loading && error && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
            <p className="text-sm text-red-700 font-sans">{error}</p>
          </div>
        )}

        {!loading && !error && notifications.length === 0 && (
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4] text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">notifications_none</span>
            <p className="text-sm text-[#5d5f5d] font-serif">Não tem notificações de momento.</p>
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
                  className={`bg-white rounded-xl p-4 border transition-all duration-200 cursor-pointer flex items-start gap-3.5 group hover:shadow-card-hover hover:-translate-y-0.5 ${
                    isUnread ? 'border-[#8B1A1A]/20 bg-[#fff8f7]' : 'border-[#ebe5e4]'
                  }`}
                >
                  <div className={`w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 ${isUnread ? 'bg-[#8B1A1A] text-white' : 'bg-[#f0eded] text-[#5d5f5d]'}`}>
                    <span className="material-symbols-outlined text-[18px]">{icon}</span>
                  </div>
                  <div className="flex-grow min-w-0">
                    <div className="flex items-start justify-between gap-4">
                      <h3 className={`text-sm font-bold font-sans ${isUnread ? 'text-[#8B1A1A]' : 'text-[#1c1b1b]'}`}>{n.title}</h3>
                      <span className="text-[10px] text-[#b8a5a3] whitespace-nowrap font-sans">{timeAgo(n.createdAt)}</span>
                    </div>
                    <p className="text-xs text-[#5d5f5d] mt-1 font-serif leading-relaxed">{n.body}</p>
                  </div>
                  {isUnread && <div className="w-1.5 h-1.5 bg-[#8B1A1A] rounded-full mt-2 flex-shrink-0" />}
                </div>
              )
            })}
          </div>
        )}
      </div>
    </AppShell>
  )
}
