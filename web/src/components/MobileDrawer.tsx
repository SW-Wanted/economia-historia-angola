import { SidebarContent } from './Sidebar'
import { useSidebar } from '../contexts/SidebarContext'

/**
 * Drawer lateral (off-canvas) para Tablet/Mobile — padrão de aplicações Web
 * modernas (Notion, Linear, GitHub…). Substitui a antiga barra inferior copiada
 * da Mobile. Contém a navegação completa (nada fica escondido), com overlay,
 * animação suave e fecho ao seleccionar uma opção, ao tocar fora ou com Escape.
 */
export default function MobileDrawer() {
  const { mobileOpen, closeMobile } = useSidebar()

  return (
    <div
      className={`lg:hidden fixed inset-0 z-[80] ${mobileOpen ? '' : 'pointer-events-none'}`}
      aria-hidden={!mobileOpen}
    >
      {/* Overlay */}
      <div
        onClick={closeMobile}
        className={`absolute inset-0 bg-black/45 transition-opacity duration-300 ${
          mobileOpen ? 'opacity-100' : 'opacity-0'
        }`}
      />

      {/* Painel */}
      <aside
        role="dialog"
        aria-modal="true"
        aria-label="Menu de navegação"
        className={`absolute left-0 top-0 h-full w-[284px] max-w-[85vw] bg-surface border-r border-outline-variant/25 shadow-xl flex flex-col transition-transform duration-300 ease-[cubic-bezier(0.16,1,0.3,1)] ${
          mobileOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <SidebarContent variant="drawer" onNavigate={closeMobile} />
      </aside>
    </div>
  )
}
