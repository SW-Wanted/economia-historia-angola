import { NavLink, useNavigate } from 'react-router-dom'
import Icon from './Icon'

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

interface SidebarProps {
  userName?: string
  userRole?: string
}

export default function Sidebar({ userName = 'Carlos Tchípia', userRole = 'Investigador' }: SidebarProps) {
  const navigate = useNavigate()

  return (
    <aside className="fixed left-0 top-0 h-screen w-[280px] bg-[#fcf9f8] border-r border-[#e0bfbc] flex flex-col z-50 overflow-y-auto">
      <div className="flex flex-col gap-6 p-6 flex-grow">
        {/* Brand */}
        <div className="flex flex-col gap-1">
          <button
            onClick={() => navigate('/dashboard')}
            className="flex items-center gap-2 hover:opacity-80 transition-opacity text-left"
          >
            <Icon name="account_balance" className="text-[#8B1A1A] text-3xl" filled />
            <span className="font-bold text-[#8B1A1A] text-lg leading-tight" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
              Economia com História
            </span>
          </button>
          <span className="text-xs text-[#5d5f5d] ml-9 uppercase tracking-widest" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}>Angola</span>
        </div>

        {/* User chip */}
        <button
          onClick={() => navigate('/perfil')}
          className="flex items-center gap-3 border-t border-[#e0bfbc] pt-4 hover:bg-[#eae7e7] rounded-xl px-2 py-2 transition-colors -mx-2"
        >
          <div className="w-9 h-9 rounded-full bg-[#eae7e7] border border-[#e0bfbc] flex items-center justify-center flex-shrink-0">
            <Icon name="person" className="text-[#5d5f5d] text-[18px]" />
          </div>
          <div className="flex flex-col overflow-hidden text-left">
            <span className="font-bold text-sm text-[#1c1b1b] truncate" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}>{userName}</span>
            <span className="text-[10px] uppercase tracking-wider text-[#5d5f5d] font-bold" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}>{userRole}</span>
          </div>
        </button>

        {/* Primary navigation */}
        <nav className="flex flex-col gap-1">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `flex items-center gap-3 px-3 py-2.5 rounded-xl transition-colors text-sm font-semibold ${
                  isActive ? 'bg-[#8B1A1A] text-white' : 'text-[#5d5f5d] hover:bg-[#eae7e7]'
                }`
              }
              style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
            >
              {({ isActive }) => (
                <>
                  <Icon name={item.icon} filled={isActive} />
                  {item.label}
                </>
              )}
            </NavLink>
          ))}
        </nav>

        {/* Secondary navigation */}
        <div>
          <p className="text-[10px] font-bold text-[#5d5f5d] uppercase tracking-widest px-3 mb-2" style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
            Conteúdos
          </p>
          <nav className="flex flex-col gap-1">
            {secondaryItems.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-2 rounded-xl transition-colors text-xs font-semibold ${
                    isActive ? 'bg-[#8B1A1A]/10 text-[#8B1A1A]' : 'text-[#5d5f5d] hover:bg-[#eae7e7]'
                  }`
                }
                style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
              >
                {({ isActive }) => (
                  <>
                    <Icon name={item.icon} filled={isActive} className="text-[18px]" />
                    {item.label}
                  </>
                )}
              </NavLink>
            ))}
          </nav>
        </div>
      </div>

      {/* Bottom section */}
      <div className="border-t border-[#e0bfbc] p-4 flex flex-col gap-1">
        {bottomItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `flex items-center gap-3 px-3 py-2.5 rounded-xl transition-colors text-xs font-semibold ${
                isActive ? 'bg-[#8B1A1A]/10 text-[#8B1A1A]' : 'text-[#5d5f5d] hover:bg-[#eae7e7]'
              }`
            }
            style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
          >
            {({ isActive }) => (
              <>
                <Icon name={item.icon} filled={isActive} className="text-[18px]" />
                {item.label}
              </>
            )}
          </NavLink>
        ))}
        <button
          onClick={() => navigate('/confirmacao/saida')}
          className="flex items-center gap-3 text-[#5d5f5d] px-3 py-2.5 hover:bg-[#eae7e7] transition-colors rounded-xl text-xs font-semibold w-full text-left"
          style={{ fontFamily: "'Plus Jakarta Sans', sans-serif" }}
        >
          <Icon name="logout" className="text-[18px]" />
          Sair
        </button>
      </div>
    </aside>
  )
}
