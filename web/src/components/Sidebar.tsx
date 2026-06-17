import { NavLink, useNavigate } from 'react-router-dom'
import Icon from './Icon'
import { useAuth, getUserInitials, getUserRole } from '../contexts/AuthContext'

const navItems = [
  { to: '/dashboard', label: 'Início', icon: 'home' },
  { to: '/explorar', label: 'Explorar', icon: 'explore' },
  { to: '/mapa', label: 'Mapa Económico', icon: 'map' },
  { to: '/forum', label: 'Fórum', icon: 'forum' },
  { to: '/quiz', label: 'Quizzes', icon: 'quiz' },
  { to: '/perfil', label: 'Perfil', icon: 'person' },
]

const secondaryItems = [
  { to: '/biblioteca', label: 'Biblioteca', icon: 'library_books' },
  { to: '/favoritos', label: 'Favoritos', icon: 'bookmark' },
  { to: '/estatisticas', label: 'Estatísticas', icon: 'bar_chart' },
  { to: '/glossario', label: 'Glossário', icon: 'menu_book' },
  { to: '/comparador', label: 'Comparador', icon: 'compare' },
]

const bottomItems = [
  { to: '/gestao/conteudos', label: 'Gestão', icon: 'admin_panel_settings' },
  { to: '/guia-rapido', label: 'Guia Rápido', icon: 'rocket_launch' },
  { to: '/guia-investigacao', label: 'Investigação', icon: 'science' },
  { to: '/ajuda', label: 'Ajuda', icon: 'help' },
]

export default function Sidebar() {
  const navigate = useNavigate()
  const { user, logout } = useAuth()

  const displayName = user?.name ?? 'Utilizador'
  const initials = getUserInitials(user)
  const role = getUserRole(user)

  async function handleLogout() {
    await logout()
    navigate('/login', { replace: true })
  }

  return (
    <aside className="fixed left-0 top-0 h-screen w-[280px] bg-[#fcf9f8] border-r border-[#ebe5e4] flex flex-col z-50 overflow-y-auto">
      <div className="flex flex-col gap-5 p-5 flex-grow">
        {/* Brand */}
        <div className="flex flex-col gap-1 px-1 pt-1">
          <button
            onClick={() => navigate('/dashboard')}
            className="flex items-center gap-2.5 hover:opacity-75 transition-opacity duration-150 text-left"
          >
            <Icon name="account_balance" className="text-[#8B1A1A] text-3xl flex-shrink-0" filled />
            <span className="font-bold text-[#8B1A1A] text-base leading-tight font-sans tracking-tight">
              Economia com História
            </span>
          </button>
          <span className="text-[10px] font-sans text-[#8c716e] ml-9 uppercase tracking-[0.12em]">Angola</span>
        </div>

        {/* User chip */}
        <button
          onClick={() => navigate('/perfil')}
          className="flex items-center gap-3 border-t border-[#ebe5e4] pt-4 mt-1 hover:bg-[#f0eded] rounded-xl px-2 py-2 transition-all duration-150 -mx-2 group"
        >
          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-[#8B1A1A]/15 to-[#8B1A1A]/5 border border-[#e0bfbc] flex items-center justify-center flex-shrink-0">
            <span className="text-[11px] font-bold text-[#8B1A1A] font-sans leading-none">{initials}</span>
          </div>
          <div className="flex flex-col overflow-hidden text-left min-w-0">
            <span className="font-semibold text-sm text-[#1c1b1b] truncate font-sans leading-snug">{displayName}</span>
            <span className="text-[10px] uppercase tracking-[0.08em] text-[#8c716e] font-sans font-semibold">{role}</span>
          </div>
          <Icon name="chevron_right" className="text-[#c4b5b3] text-[18px] ml-auto flex-shrink-0 group-hover:text-[#8B1A1A] transition-colors duration-150" />
        </button>

        {/* Primary navigation */}
        <nav className="flex flex-col gap-0.5">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-150 text-sm font-semibold font-sans ${
                  isActive
                    ? 'bg-[#8B1A1A] text-white shadow-xs'
                    : 'text-[#4a4a4a] hover:bg-[#f0eded] hover:text-[#1c1b1b]'
                }`
              }
            >
              {({ isActive }) => (
                <>
                  <Icon name={item.icon} filled={isActive} className="flex-shrink-0" />
                  {item.label}
                </>
              )}
            </NavLink>
          ))}
        </nav>

        {/* Secondary navigation */}
        <div>
          <p className="text-[10px] font-bold text-[#b8a5a3] uppercase tracking-[0.1em] px-3 mb-1.5 font-sans">
            Conteúdos
          </p>
          <nav className="flex flex-col gap-0.5">
            {secondaryItems.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-150 text-xs font-semibold font-sans ${
                    isActive
                      ? 'bg-[#8B1A1A]/8 text-[#8B1A1A]'
                      : 'text-[#5d5f5d] hover:bg-[#f0eded] hover:text-[#1c1b1b]'
                  }`
                }
              >
                {({ isActive }) => (
                  <>
                    <Icon name={item.icon} filled={isActive} className="text-[18px] flex-shrink-0" />
                    {item.label}
                  </>
                )}
              </NavLink>
            ))}
          </nav>
        </div>
      </div>

      {/* Bottom section */}
      <div className="border-t border-[#ebe5e4] p-4 flex flex-col gap-0.5">
        {bottomItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-150 text-xs font-semibold font-sans ${
                isActive
                  ? 'bg-[#8B1A1A]/8 text-[#8B1A1A]'
                  : 'text-[#5d5f5d] hover:bg-[#f0eded] hover:text-[#1c1b1b]'
              }`
            }
          >
            {({ isActive }) => (
              <>
                <Icon name={item.icon} filled={isActive} className="text-[18px] flex-shrink-0" />
                {item.label}
              </>
            )}
          </NavLink>
        ))}
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 text-[#5d5f5d] px-3 py-2 hover:bg-[#f0eded] hover:text-[#ba1a1a] transition-all duration-150 rounded-lg text-xs font-semibold font-sans w-full text-left mt-1"
        >
          <Icon name="logout" className="text-[18px] flex-shrink-0" />
          Sair
        </button>
      </div>
    </aside>
  )
}
