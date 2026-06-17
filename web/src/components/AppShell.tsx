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
    if (query.trim()) navigate('/pesquisa')
  }

  const initials = getUserInitials(user)

  return (
    <div className="bg-[#F2F2F0] text-[#1c1b1b] min-h-screen font-sans">
      <Sidebar />

      {/* Top bar */}
      <header className="fixed top-0 right-0 left-[280px] bg-[#fcf9f8]/95 backdrop-blur-sm z-40 border-b border-[#ebe5e4]">
        <div className="flex justify-between items-center px-10 h-[60px] max-w-[1160px] mx-auto">
          <div className="flex items-center gap-6">
            {title && (
              <h1 className="text-lg font-bold text-[#1c1b1b] whitespace-nowrap font-sans tracking-tight">{title}</h1>
            )}
            {showSearch && (
              <form onSubmit={handleSearch} className="relative">
                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-[#b8a5a3] text-[18px] pointer-events-none">search</span>
                <input
                  type="text"
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder={searchPlaceholder}
                  className="bg-[#f0eded] border border-transparent rounded-lg pl-9 pr-4 py-2 text-sm w-60 focus:w-72 focus:bg-white focus:border-[#e0bfbc] focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-200 font-serif placeholder:text-[#c4b5b3]"
                />
              </form>
            )}
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={() => navigate('/notificacoes')}
              className="w-9 h-9 flex items-center justify-center rounded-lg text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded] transition-all duration-150 relative"
              aria-label="Notificações"
            >
              <span className="material-symbols-outlined text-[22px]">notifications</span>
              <span className="absolute top-1.5 right-1.5 w-1.5 h-1.5 bg-[#8B1A1A] rounded-full ring-2 ring-[#fcf9f8]" />
            </button>
            <button
              onClick={() => navigate('/perfil')}
              className="w-9 h-9 rounded-full overflow-hidden border border-[#e0bfbc] bg-gradient-to-br from-[#8B1A1A]/15 to-[#8B1A1A]/5 flex items-center justify-center hover:border-[#8B1A1A]/60 hover:shadow-xs transition-all duration-150"
              aria-label="Perfil"
            >
              <span className="text-[11px] font-bold text-[#8B1A1A] font-sans leading-none">{initials}</span>
            </button>
          </div>
        </div>
      </header>

      {/* Content */}
      <main className="ml-[280px] pt-[60px] min-h-screen">
        {children}
      </main>
    </div>
  )
}
