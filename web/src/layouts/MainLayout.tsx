import { Outlet, NavLink, useNavigate } from 'react-router-dom'

const navItems = [
  { to: '/dashboard', label: 'Início', icon: 'home' },
  { to: '/explorar', label: 'Explorar', icon: 'explore' },
  { to: '/mapa', label: 'Mapa Económico', icon: 'map' },
  { to: '/forum', label: 'Fórum', icon: 'forum' },
  { to: '/perfil', label: 'Perfil', icon: 'person' },
]

export default function MainLayout() {
  const navigate = useNavigate()

  return (
    <div className="bg-background text-on-background min-h-screen">
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 h-screen w-sidebar-width bg-surface border-r border-outline-variant flex flex-col p-margin-desktop gap-stack-lg z-50">
        <div className="flex flex-col gap-1">
          <div className="flex items-center gap-2">
            <span className="material-symbols-outlined text-primary text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>
              account_balance
            </span>
            <span className="font-sans font-bold text-primary text-headline-sm leading-tight">
              Economia com História
            </span>
          </div>
          <span className="font-sans text-label-sm text-secondary ml-9">Angola</span>
        </div>

        <nav className="flex flex-col gap-stack-sm flex-grow">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `flex items-center gap-stack-sm px-4 py-3 rounded-xl transition-colors font-sans font-semibold text-label-md ${
                  isActive
                    ? 'bg-primary text-on-primary'
                    : 'text-secondary hover:bg-surface-container-high'
                }`
              }
            >
              <span className="material-symbols-outlined">{item.icon}</span>
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className="mt-auto flex flex-col gap-1">
          <NavLink
            to="/definicoes"
            className="flex items-center gap-stack-sm text-secondary px-4 py-3 hover:bg-surface-container-high transition-colors rounded-xl font-sans text-label-md"
          >
            <span className="material-symbols-outlined">settings</span>
            Definições
          </NavLink>
          <button
            onClick={() => navigate('/login')}
            className="flex items-center gap-stack-sm text-secondary px-4 py-3 hover:bg-surface-container-high transition-colors rounded-xl font-sans text-label-md w-full text-left"
          >
            <span className="material-symbols-outlined">logout</span>
            Sair
          </button>
        </div>
      </aside>

      {/* Main content */}
      <div className="ml-sidebar-width min-h-screen">
        <Outlet />
      </div>
    </div>
  )
}
