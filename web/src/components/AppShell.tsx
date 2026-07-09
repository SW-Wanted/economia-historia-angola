import { ReactNode, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Sidebar from './Sidebar'
import MobileDrawer from './MobileDrawer'
import Icon from './Icon'
import { useAuth, getUserInitials } from '../contexts/AuthContext'
import { SidebarProvider, useSidebar } from '../contexts/SidebarContext'

interface AppShellProps {
  children: ReactNode
  title?: string
  searchPlaceholder?: string
  showSearch?: boolean
}

function AppShellInner({ children, title, searchPlaceholder = 'Pesquisar arquivo...', showSearch = true }: AppShellProps) {
  const navigate = useNavigate()
  const { user, isAuthenticated } = useAuth()
  const { collapsed, openMobile } = useSidebar()
  const [query, setQuery] = useState('')

  function handleSearch(e: React.FormEvent) {
    e.preventDefault()
    if (query.trim()) navigate(`/pesquisa?q=${encodeURIComponent(query.trim())}`)
  }

  const initials = getUserInitials(user)

  // Offsets acompanham a sidebar: em Tablet (md) há um rail reduzido (76px); em
  // Desktop (lg) segue o estado recolhido/expandido; abaixo de md não há sidebar
  // fixa (navegação no drawer), logo sem offset.
  const asideOffset = collapsed
    ? 'md:left-sidebar-collapsed'
    : 'md:left-sidebar-collapsed lg:left-sidebar'
  const mainOffset = collapsed
    ? 'md:ml-sidebar-collapsed'
    : 'md:ml-sidebar-collapsed lg:ml-sidebar'

  return (
    <div className="bg-background text-text min-h-screen font-body">
      <Sidebar />
      <MobileDrawer />

      {/* Top bar */}
      <header className={`fixed top-0 right-0 left-0 ${asideOffset} bg-surface/95 backdrop-blur-sm z-40 border-b border-outline-variant/20 transition-[left] duration-300 ease-[cubic-bezier(0.4,0,0.2,1)]`}>
        <div className="flex items-center justify-between px-4 sm:px-6 lg:px-8 h-topbar max-w-[1200px] mx-auto">

          {/* Left: hamburger (mobile) + title + search */}
          <div className="flex items-center gap-2 sm:gap-4 min-w-0">
            {/* Hamburger — abre o drawer em Tablet/Mobile. */}
            <button
              onClick={openMobile}
              className="lg:hidden w-10 h-10 -ml-1 flex items-center justify-center rounded-lg text-text/70 hover:text-primary hover:bg-surface-container-low transition-all duration-150 flex-shrink-0"
              aria-label="Abrir menu"
            >
              <span className="material-symbols-outlined text-[24px]">menu</span>
            </button>
            {title && (
              <h1 className="text-[15px] font-bold text-text font-sans tracking-tight whitespace-nowrap truncate">{title}</h1>
            )}
            {showSearch && (
              <form onSubmit={handleSearch} className="relative hidden md:block">
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
            {showSearch && (
              <button
                onClick={() => navigate('/pesquisa')}
                className="md:hidden w-9 h-9 flex items-center justify-center rounded-lg text-text/50 hover:text-primary hover:bg-surface-container-low transition-all duration-150"
                aria-label="Pesquisar"
              >
                <span className="material-symbols-outlined text-[20px]">search</span>
              </button>
            )}

            {isAuthenticated ? (
              <>
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
              </>
            ) : (
              /* Visitante: convite a autenticar em vez de perfil/notificações. */
              <>
                <button
                  onClick={() => navigate('/login')}
                  className="px-3 h-9 hidden sm:flex items-center rounded-lg text-sm font-semibold font-sans text-secondary hover:text-primary hover:bg-surface-container-low transition-all duration-150"
                >
                  Entrar
                </button>
                <button
                  onClick={() => navigate('/cadastro')}
                  className="ml-1 px-3.5 h-9 flex items-center gap-1.5 rounded-lg text-sm font-bold font-sans bg-primary text-white shadow-xs hover:bg-primary-dark transition-all duration-150"
                >
                  <span className="material-symbols-outlined text-[18px]">person_add</span>
                  <span className="hidden sm:inline">Criar Conta</span>
                  <span className="sm:hidden">Entrar</span>
                </button>
              </>
            )}
          </div>
        </div>
      </header>

      {/* Main content */}
      <main className={`${mainOffset} pt-topbar pb-10 min-h-screen transition-[margin] duration-300 ease-[cubic-bezier(0.4,0,0.2,1)]`}>
        {children}
      </main>
    </div>
  )
}

export default function AppShell(props: AppShellProps) {
  return (
    <SidebarProvider>
      <AppShellInner {...props} />
    </SidebarProvider>
  )
}
