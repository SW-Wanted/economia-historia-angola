import { useEffect, useState } from 'react'
import { NavLink, useNavigate } from 'react-router-dom'
import Icon from './Icon'
import { useAuth, getUserInitials, getUserRole, canAccessContentManagement, canManageUsers } from '../contexts/AuthContext'
import { useSidebar } from '../contexts/SidebarContext'

/** True em larguras de Tablet (< lg): a sidebar mostra-se como rail reduzido. */
function useIsBelowLg(): boolean {
  const query = '(max-width: 1023px)'
  const [below, setBelow] = useState(() =>
    typeof window !== 'undefined' ? window.matchMedia(query).matches : false,
  )
  useEffect(() => {
    const mq = window.matchMedia(query)
    const onChange = () => setBelow(mq.matches)
    onChange()
    mq.addEventListener('change', onChange)
    return () => mq.removeEventListener('change', onChange)
  }, [])
  return below
}

interface NavEntry {
  to: string
  label: string
  icon: string
}

const primaryNav: NavEntry[] = [
  { to: '/dashboard', label: 'Início', icon: 'home' },
  { to: '/explorar', label: 'Explorar', icon: 'explore' },
  { to: '/mapa', label: 'Mapa Económico', icon: 'map' },
  { to: '/forum', label: 'Fórum', icon: 'forum' },
  { to: '/quiz', label: 'Quizzes', icon: 'quiz' },
]

const libraryNav: NavEntry[] = [
  { to: '/biblioteca', label: 'Biblioteca', icon: 'library_books' },
  { to: '/favoritos', label: 'Favoritos', icon: 'bookmark' },
  { to: '/estatisticas', label: 'Estatísticas', icon: 'bar_chart' },
]

const supportNav: NavEntry[] = [
  { to: '/perfil', label: 'Perfil', icon: 'person' },
  { to: '/guia-rapido', label: 'Guia Rápido', icon: 'rocket_launch' },
  { to: '/ajuda', label: 'Ajuda', icon: 'help_outline' },
]

// Navegação do Visitante — apenas áreas públicas.
const guestPrimaryNav: NavEntry[] = [
  { to: '/home', label: 'Início', icon: 'home' },
  { to: '/explorar', label: 'Explorar', icon: 'explore' },
  { to: '/mapa', label: 'Mapa Económico', icon: 'map' },
  { to: '/forum', label: 'Fórum', icon: 'forum' },
  { to: '/quiz', label: 'Quizzes', icon: 'quiz' },
]

const guestExploreNav: NavEntry[] = [
  { to: '/guia-rapido', label: 'Guia Rápido', icon: 'rocket_launch' },
  { to: '/ajuda', label: 'Ajuda', icon: 'help_outline' },
]

/** Tooltip apresentada apenas quando a sidebar está recolhida (Desktop). */
function Tooltip({ label }: { label: string }) {
  return (
    <span
      aria-hidden="true"
      className="pointer-events-none absolute left-[calc(100%+10px)] top-1/2 -translate-y-1/2 z-[70] hidden lg:block whitespace-nowrap rounded-md bg-text px-2.5 py-1.5 text-xs font-semibold font-sans text-surface shadow-md opacity-0 translate-x-[-4px] group-hover/nav:opacity-100 group-hover/nav:translate-x-0 transition-all duration-150"
    >
      {label}
    </span>
  )
}

function NavItem({ entry, collapsed, onNavigate }: { entry: NavEntry; collapsed: boolean; onNavigate?: () => void }) {
  return (
    <NavLink
      to={entry.to}
      onClick={onNavigate}
      title={collapsed ? entry.label : undefined}
      className={({ isActive }) =>
        `group/nav relative flex items-center rounded-lg text-sm font-sans transition-all duration-150 ${
          collapsed ? 'justify-center w-11 h-11 mx-auto' : 'gap-3 px-4 py-2.5'
        } ${
          isActive
            ? 'text-primary bg-primary/8 font-semibold'
            : 'text-text/55 font-medium hover:text-text hover:bg-surface-container-low/60'
        }`
      }
    >
      {({ isActive }) => (
        <>
          {isActive && <span className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-5 bg-primary rounded-r-full" />}
          <Icon
            name={entry.icon}
            filled={isActive}
            className={`text-[20px] flex-shrink-0 transition-colors duration-150 ${isActive ? 'text-primary' : 'text-outline'}`}
          />
          {!collapsed && <span className="truncate">{entry.label}</span>}
          {collapsed && <Tooltip label={entry.label} />}
        </>
      )}
    </NavLink>
  )
}

function NavGroup({
  label,
  items,
  collapsed,
  onNavigate,
}: {
  label: string
  items: NavEntry[]
  collapsed: boolean
  onNavigate?: () => void
}) {
  return (
    <div>
      {collapsed ? (
        <div className="h-px bg-outline-variant/20 mx-3 mb-1.5" />
      ) : (
        <p className="px-4 mb-1.5 text-[10px] font-bold uppercase tracking-[0.12em] text-outline/55 font-sans select-none">
          {label}
        </p>
      )}
      <nav className="flex flex-col gap-0.5">
        {items.map((item) => (
          <NavItem key={item.to} entry={item} collapsed={collapsed} onNavigate={onNavigate} />
        ))}
      </nav>
    </div>
  )
}

function Brand({ collapsed, onNavigate }: { collapsed: boolean; onNavigate?: () => void }) {
  const navigate = useNavigate()
  const { isAuthenticated } = useAuth()
  return (
    <button
      onClick={() => {
        onNavigate?.()
        navigate(isAuthenticated ? '/dashboard' : '/home')
      }}
      title={collapsed ? 'Economia com História' : undefined}
      className={`flex items-center group min-w-0 ${collapsed ? 'justify-center w-full' : 'gap-3'}`}
    >
      <div className="w-9 h-9 rounded-xl bg-primary flex items-center justify-center flex-shrink-0 shadow-sm group-hover:shadow-md transition-shadow duration-200">
        <Icon name="account_balance" filled className="text-white text-[20px]" />
      </div>
      {!collapsed && (
        <div className="min-w-0 text-left">
          <p className="text-[13px] font-bold text-text font-sans leading-tight tracking-tight truncate">
            Economia com História
          </p>
          <p className="text-[10px] font-semibold text-outline/70 uppercase tracking-[0.10em] font-sans mt-0.5">Angola</p>
        </div>
      )}
    </button>
  )
}

/**
 * Conteúdo partilhado entre a sidebar fixa (Desktop) e o drawer (Mobile/Tablet).
 * `collapsed` só é verdadeiro no modo recolhido do Desktop; no drawer é sempre
 * `false`. `onNavigate` fecha o drawer ao seleccionar uma opção.
 */
export function SidebarContent({
  variant,
  collapsed = false,
  onNavigate,
}: {
  variant: 'desktop' | 'drawer'
  collapsed?: boolean
  onNavigate?: () => void
}) {
  const navigate = useNavigate()
  const { user, isAuthenticated, logout } = useAuth()
  const { toggleCollapsed, closeMobile } = useSidebar()

  const displayName = user?.name ?? 'Utilizador'
  const initials = getUserInitials(user)
  const role = getUserRole(user)
  const canManageContent = canAccessContentManagement(user)
  const showUserMgmt = canManageUsers(user)

  async function handleLogout() {
    onNavigate?.()
    await logout()
    navigate('/home', { replace: true })
  }

  return (
    <div className="flex flex-col h-full">
      {/* Cabeçalho: marca + botão recolher (desktop) / fechar (drawer) */}
      <div className={`flex items-center flex-shrink-0 ${collapsed ? 'flex-col gap-2 px-3 pt-5 pb-3' : 'gap-2 px-5 pt-6 pb-4'}`}>
        <Brand collapsed={collapsed} onNavigate={onNavigate} />
        {variant === 'desktop' && (
          <button
            onClick={toggleCollapsed}
            title={collapsed ? 'Expandir menu' : 'Recolher menu'}
            aria-label={collapsed ? 'Expandir menu' : 'Recolher menu'}
            className={`hidden lg:flex items-center justify-center w-8 h-8 rounded-lg text-outline hover:text-primary hover:bg-surface-container-low/70 transition-all duration-150 flex-shrink-0 ${collapsed ? '' : 'ml-auto'}`}
          >
            <Icon name={collapsed ? 'chevron_right' : 'chevron_left'} className="text-[20px]" />
          </button>
        )}
        {variant === 'drawer' && (
          <button
            onClick={closeMobile}
            aria-label="Fechar menu"
            className="ml-auto flex items-center justify-center w-9 h-9 rounded-lg text-outline hover:text-primary hover:bg-surface-container-low/70 transition-all duration-150 flex-shrink-0"
          >
            <Icon name="close" className="text-[22px]" />
          </button>
        )}
      </div>

      {/* Chip do utilizador (autenticado) */}
      {isAuthenticated && (
        <div className={`flex-shrink-0 ${collapsed ? 'px-3 pb-3 flex justify-center' : 'px-3 pb-3'}`}>
          <button
            onClick={() => {
              onNavigate?.()
              navigate('/perfil')
            }}
            title={collapsed ? displayName : undefined}
            className={`group/nav relative flex items-center rounded-xl hover:bg-surface-container-low/60 transition-all duration-150 text-left ${
              collapsed ? 'justify-center w-11 h-11' : 'w-full gap-3 px-3 py-2.5'
            }`}
          >
            <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary/20 to-primary/8 border border-primary/20 flex items-center justify-center flex-shrink-0">
              <span className="text-[10px] font-bold text-primary font-sans leading-none">{initials}</span>
            </div>
            {!collapsed && (
              <>
                <div className="flex-1 min-w-0">
                  <p className="text-[13px] font-semibold text-text font-sans leading-tight truncate">{displayName}</p>
                  <p className="text-[10px] text-outline/70 font-sans uppercase tracking-[0.06em]">{role}</p>
                </div>
                <Icon name="chevron_right" className="text-[16px] text-outline/40 flex-shrink-0" />
              </>
            )}
            {collapsed && <Tooltip label={displayName} />}
          </button>
        </div>
      )}

      <div className="h-px bg-outline-variant/20 mx-5 flex-shrink-0" />

      {/* Navegação */}
      <div className="flex-1 overflow-y-auto overflow-x-hidden px-3 py-4 flex flex-col gap-5 min-h-0">
        {isAuthenticated ? (
          <>
            <NavGroup label="Principal" items={primaryNav} collapsed={collapsed} onNavigate={onNavigate} />
            <NavGroup label="Conteúdo" items={libraryNav} collapsed={collapsed} onNavigate={onNavigate} />
            <NavGroup label="Conta" items={supportNav} collapsed={collapsed} onNavigate={onNavigate} />
            {canManageContent && (
              <NavGroup
                label="Administração"
                collapsed={collapsed}
                onNavigate={onNavigate}
                items={[
                  { to: '/gestao/conteudos', label: 'Gerir Conteúdos', icon: 'admin_panel_settings' },
                  ...(showUserMgmt ? [{ to: '/gestao/utilizadores', label: 'Utilizadores', icon: 'manage_accounts' }] : []),
                ]}
              />
            )}
          </>
        ) : (
          <>
            <NavGroup label="Principal" items={guestPrimaryNav} collapsed={collapsed} onNavigate={onNavigate} />
            <NavGroup label="Descobrir" items={guestExploreNav} collapsed={collapsed} onNavigate={onNavigate} />
          </>
        )}
      </div>

      {/* Rodapé: sessão */}
      <div className="flex-shrink-0 p-3 border-t border-outline-variant/20">
        {isAuthenticated ? (
          <button
            onClick={handleLogout}
            title={collapsed ? 'Terminar Sessão' : undefined}
            className={`group/nav relative flex items-center rounded-lg text-sm font-medium font-sans text-text/45 hover:text-error hover:bg-error/5 transition-all duration-150 ${
              collapsed ? 'justify-center w-11 h-11 mx-auto' : 'w-full gap-3 px-4 py-2.5'
            }`}
          >
            <Icon name="logout" className="text-[20px] flex-shrink-0 text-outline/60" />
            {!collapsed && <span>Terminar Sessão</span>}
            {collapsed && <Tooltip label="Terminar Sessão" />}
          </button>
        ) : (
          <div className={`flex ${collapsed ? 'flex-col items-center gap-1.5' : 'flex-col gap-1.5'}`}>
            <button
              onClick={() => {
                onNavigate?.()
                navigate('/login')
              }}
              title={collapsed ? 'Entrar' : undefined}
              className={`group/nav relative flex items-center rounded-lg text-sm font-semibold font-sans text-text/60 hover:text-text hover:bg-surface-container-low/60 transition-all duration-150 ${
                collapsed ? 'justify-center w-11 h-11' : 'w-full gap-3 px-4 py-2.5'
              }`}
            >
              <Icon name="login" className="text-[20px] flex-shrink-0 text-outline" />
              {!collapsed && <span>Entrar</span>}
              {collapsed && <Tooltip label="Entrar" />}
            </button>
            <button
              onClick={() => {
                onNavigate?.()
                navigate('/cadastro')
              }}
              title={collapsed ? 'Criar Conta' : undefined}
              className={`group/nav relative flex items-center rounded-lg text-sm font-bold font-sans bg-primary text-white shadow-xs hover:bg-primary-dark transition-all duration-150 ${
                collapsed ? 'justify-center w-11 h-11' : 'w-full justify-center gap-2 px-4 py-2.5'
              }`}
            >
              <Icon name="person_add" className="text-[18px] flex-shrink-0 text-white" />
              {!collapsed && <span>Criar Conta</span>}
              {collapsed && <Tooltip label="Criar Conta" />}
            </button>
          </div>
        )}
      </div>
    </div>
  )
}

/**
 * Sidebar fixa a partir de Tablet (md). Em Desktop (lg+) é recolhível e o estado
 * é persistido; em Tablet (md–lg) apresenta-se sempre como rail reduzido (só
 * ícones), podendo expandir-se através do drawer (hamburger). Abaixo de md fica
 * oculta — a navegação vive no drawer.
 */
export default function Sidebar() {
  const { collapsed } = useSidebar()
  const isBelowLg = useIsBelowLg()
  const effectiveCollapsed = isBelowLg || collapsed
  return (
    <aside
      className={`hidden md:flex fixed left-0 top-0 h-screen bg-surface border-r border-outline-variant/25 flex-col z-50 overflow-hidden transition-[width] duration-300 ease-[cubic-bezier(0.4,0,0.2,1)] ${
        effectiveCollapsed ? 'w-sidebar-collapsed' : 'w-sidebar'
      }`}
    >
      <SidebarContent variant="desktop" collapsed={effectiveCollapsed} />
    </aside>
  )
}
