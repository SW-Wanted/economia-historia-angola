import { NavLink, useNavigate } from 'react-router-dom'
import Icon from './Icon'
import { useAuth, getUserInitials, getUserRole, canAccessContentManagement, canManageUsers } from '../contexts/AuthContext'

const primaryNav = [
  { to: '/dashboard', label: 'Início', icon: 'home' },
  { to: '/explorar', label: 'Explorar', icon: 'explore' },
  { to: '/mapa', label: 'Mapa Económico', icon: 'map' },
  { to: '/forum', label: 'Fórum', icon: 'forum' },
  { to: '/quiz', label: 'Quizzes', icon: 'quiz' },
]

const libraryNav = [
  { to: '/biblioteca', label: 'Biblioteca', icon: 'library_books' },
  { to: '/favoritos', label: 'Favoritos', icon: 'bookmark' },
  { to: '/glossario', label: 'Glossário', icon: 'menu_book' },
  { to: '/comparador', label: 'Comparador', icon: 'compare' },
  { to: '/estatisticas', label: 'Estatísticas', icon: 'bar_chart' },
]

const supportNav = [
  { to: '/perfil', label: 'Perfil', icon: 'person' },
  { to: '/guia-rapido', label: 'Guia Rápido', icon: 'rocket_launch' },
  { to: '/ajuda', label: 'Ajuda', icon: 'help_outline' },
]

function NavGroup({ label, items }: { label: string; items: { to: string; label: string; icon: string }[] }) {
  return (
    <div>
      <p className="px-4 mb-1.5 text-[10px] font-bold uppercase tracking-[0.12em] text-outline/55 font-sans select-none">
        {label}
      </p>
      <nav className="flex flex-col gap-0.5">
        {items.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `relative flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-sans transition-all duration-150 ${
                isActive
                  ? 'text-primary bg-primary/8 font-semibold'
                  : 'text-text/55 font-medium hover:text-text hover:bg-surface-container-low/60'
              }`
            }
          >
            {({ isActive }) => (
              <>
                {isActive && (
                  <span className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-5 bg-primary rounded-r-full" />
                )}
                <Icon
                  name={item.icon}
                  filled={isActive}
                  className={`text-[20px] flex-shrink-0 transition-colors duration-150 ${isActive ? 'text-primary' : 'text-outline'}`}
                />
                <span className="truncate">{item.label}</span>
              </>
            )}
          </NavLink>
        ))}
      </nav>
    </div>
  )
}

function AdminNavItem({ to, label, icon }: { to: string; label: string; icon: string }) {
  return (
    <NavLink
      to={to}
      className={({ isActive }) =>
        `relative flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-sans transition-all duration-150 ${
          isActive ? 'text-primary bg-primary/8 font-semibold' : 'text-text/55 font-medium hover:text-text hover:bg-surface-container-low/60'
        }`
      }
    >
      {({ isActive }) => (
        <>
          {isActive && <span className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-5 bg-primary rounded-r-full" />}
          <Icon name={icon} filled={isActive} className={`text-[20px] flex-shrink-0 ${isActive ? 'text-primary' : 'text-outline'}`} />
          <span>{label}</span>
        </>
      )}
    </NavLink>
  )
}

export default function Sidebar() {
  const navigate = useNavigate()
  const { user, logout } = useAuth()

  const displayName = user?.name ?? 'Utilizador'
  const initials = getUserInitials(user)
  const role = getUserRole(user)
  const canManageContent = canAccessContentManagement(user)
  const showUserMgmt = canManageUsers(user)

  async function handleLogout() {
    await logout()
    navigate('/login', { replace: true })
  }

  return (
    <aside className="hidden lg:flex fixed left-0 top-0 h-screen w-sidebar bg-surface border-r border-outline-variant/25 flex-col z-50 overflow-hidden">

      {/* Brand */}
      <div className="px-5 pt-6 pb-4 flex-shrink-0">
        <button
          onClick={() => navigate('/dashboard')}
          className="flex items-center gap-3 group w-full text-left"
        >
          <div className="w-9 h-9 rounded-xl bg-primary flex items-center justify-center flex-shrink-0 shadow-sm group-hover:shadow-md transition-shadow duration-200">
            <Icon name="account_balance" filled className="text-white text-[20px]" />
          </div>
          <div className="min-w-0">
            <p className="text-[13px] font-bold text-text font-sans leading-tight tracking-tight truncate">
              Economia com História
            </p>
            <p className="text-[10px] font-semibold text-outline/70 uppercase tracking-[0.10em] font-sans mt-0.5">Angola</p>
          </div>
        </button>
      </div>

      {/* User chip */}
      <div className="px-3 pb-3 flex-shrink-0">
        <button
          onClick={() => navigate('/perfil')}
          className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl hover:bg-surface-container-low/60 transition-all duration-150 group text-left"
        >
          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary/20 to-primary/8 border border-primary/20 flex items-center justify-center flex-shrink-0">
            <span className="text-[10px] font-bold text-primary font-sans leading-none">{initials}</span>
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-[13px] font-semibold text-text font-sans leading-tight truncate">{displayName}</p>
            <p className="text-[10px] text-outline/70 font-sans uppercase tracking-[0.06em]">{role}</p>
          </div>
          <Icon name="chevron_right" className="text-[16px] text-outline/40 flex-shrink-0 group-hover:text-primary/50 transition-colors duration-150" />
        </button>
      </div>

      <div className="h-px bg-outline-variant/20 mx-5 flex-shrink-0" />

      {/* Nav */}
      <div className="flex-1 overflow-y-auto px-3 py-4 flex flex-col gap-5 min-h-0">
        <NavGroup label="Principal" items={primaryNav} />
        <NavGroup label="Conteúdo" items={libraryNav} />
        <NavGroup label="Conta" items={supportNav} />

        {canManageContent && (
          <div>
            <p className="px-4 mb-1.5 text-[10px] font-bold uppercase tracking-[0.12em] text-outline/55 font-sans select-none">
              Administração
            </p>
            <nav className="flex flex-col gap-0.5">
              <AdminNavItem to="/gestao/conteudos" label="Gerir Conteúdos" icon="admin_panel_settings" />
              {showUserMgmt && <AdminNavItem to="/gestao/utilizadores" label="Utilizadores" icon="manage_accounts" />}
            </nav>
          </div>
        )}
      </div>

      {/* Logout */}
      <div className="flex-shrink-0 p-3 border-t border-outline-variant/20">
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium font-sans text-text/45 hover:text-error hover:bg-error/5 transition-all duration-150"
        >
          <Icon name="logout" className="text-[20px] flex-shrink-0 text-outline/60" />
          <span>Terminar Sessão</span>
        </button>
      </div>
    </aside>
  )
}
