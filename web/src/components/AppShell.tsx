import { ReactNode, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Sidebar from './Sidebar'

interface AppShellProps {
  children: ReactNode
  title?: string
  searchPlaceholder?: string
  showSearch?: boolean
}

export default function AppShell({ children, title, searchPlaceholder = 'Pesquisar arquivo...', showSearch = true }: AppShellProps) {
  const navigate = useNavigate()
  const [query, setQuery] = useState('')

  function handleSearch(e: React.FormEvent) {
    e.preventDefault()
    if (query.trim()) navigate('/pesquisa')
  }

  return (
    <div className="bg-[#F2F2F0] text-[#1c1b1b] min-h-screen" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <Sidebar />

      {/* Top bar */}
      <header className="fixed top-0 right-0 left-[280px] bg-white/80 backdrop-blur-md z-40 border-b border-[#e0bfbc]">
        <div className="flex justify-between items-center px-10 py-4 max-w-[1160px] mx-auto">
          <div className="flex items-center gap-8">
            {title && <h1 className="text-2xl font-bold text-[#8B1A1A] whitespace-nowrap">{title}</h1>}
            {showSearch && (
              <form onSubmit={handleSearch} className="relative">
                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-[#8c716e] text-[20px]">search</span>
                <input
                  type="text"
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder={searchPlaceholder}
                  className="bg-[#f6f3f2] border-none rounded-lg pl-10 pr-4 py-2 text-sm w-64 focus:ring-1 focus:ring-[#8B1A1A] outline-none"
                  style={{ fontFamily: 'Merriweather, serif' }}
                />
              </form>
            )}
          </div>
          <div className="flex items-center gap-4">
            <button
              onClick={() => navigate('/notificacoes')}
              className="text-[#5d5f5d] hover:text-[#8B1A1A] transition-all relative"
            >
              <span className="material-symbols-outlined">notifications</span>
              <span className="absolute top-0 right-0 w-2 h-2 bg-[#8B1A1A] rounded-full" />
            </button>
            <button
              onClick={() => navigate('/perfil')}
              className="w-10 h-10 rounded-full overflow-hidden border border-[#e0bfbc] bg-[#eae7e7] flex items-center justify-center hover:border-[#8B1A1A] transition-colors"
            >
              <span className="material-symbols-outlined text-[#5d5f5d]">person</span>
            </button>
          </div>
        </div>
      </header>

      {/* Content */}
      <main className="ml-[280px] pt-[72px] min-h-screen">
        {children}
      </main>
    </div>
  )
}
