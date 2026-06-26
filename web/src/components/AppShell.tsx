import { ReactNode, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Sidebar from './Sidebar'
import { useAuth, getUserInitials } from '../contexts/AuthContext'

interface AppShellProps {
  children: ReactNode
  title?: string
  searchPlaceholder?: string
  showSearch?: boolean
}

export default function AppShell({ children, title, searchPlaceholder = 'Pesquisar arquivo...', showSearch = true }: AppShellProps) {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [query, setQuery] = useState('')

  function handleSearch(e: React.FormEvent) {
    e.preventDefault()
    if (query.trim()) navigate(`/pesquisa?q=${encodeURIComponent(query.trim())}`)
  }

  const initials = getUserInitials(user)

  return (
    <div className="bg-background text-text min-h-screen font-body">
      <Sidebar />

      {/* Top bar */}
      <header className="fixed top-0 right-0 left-sidebar bg-surface/95 backdrop-blur-sm z-40 border-b border-outline-variant/20">
        <div className="flex items-center justify-between px-8 h-topbar max-w-[1200px] mx-auto">

          {/* Left: title + search */}
          <div className="flex items-center gap-5">
            {title && (
              <h1 className="text-[15px] font-bold text-text font-sans tracking-tight whitespace-nowrap">{title}</h1>
            )}
            {showSearch && (
              <form onSubmit={handleSearch} className="relative">
                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline/60 text-[17px] pointer-events-none">
                  search
                </span>
                <input
                  type="text"
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder={searchPlaceholder}
                  className="bg-background border border-transparent rounded-button pl-9 pr-4 py-2 text-sm w-56 focus:w-72 focus:bg-surface focus:border-outline-variant/50 focus:ring-2 focus:ring-primary/8 outline-none transition-all duration-200 font-body placeholder:text-outline/50 text-text"
                />
              </form>
            )}
          </div>

          {/* Right: actions */}
          <div className="flex items-center gap-1">
            <button
              onClick={() => navigate('/notificacoes')}
              className="relative w-9 h-9 flex items-center justify-center rounded-lg text-text/50 hover:text-primary hover:bg-surface-container-low transition-all duration-150"
              aria-label="Notificações"
            >
              <span className="material-symbols-outlined text-[20px]">notifications</span>
              <span className="absolute top-2 right-2 w-1.5 h-1.5 bg-primary rounded-full ring-[1.5px] ring-surface" />
            </button>
            <button
              onClick={() => navigate('/perfil')}
              className="ml-1 w-8 h-8 rounded-full overflow-hidden border border-outline-variant/40 bg-gradient-to-br from-primary/15 to-primary/5 flex items-center justify-center hover:border-primary/40 hover:shadow-xs transition-all duration-150"
              aria-label="Perfil"
            >
              <span className="text-[10px] font-bold text-primary font-sans leading-none">{initials}</span>
            </button>
          </div>
        </div>
      </header>

      {/* Main content */}
      <main className="ml-sidebar pt-topbar min-h-screen">
        {children}
      </main>
    </div>
  )
}
