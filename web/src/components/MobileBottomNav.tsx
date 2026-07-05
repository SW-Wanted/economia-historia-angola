import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import Icon from './Icon'
import { useAuth, canCreateContent } from '../contexts/AuthContext'

/**
 * Barra de navegação inferior flutuante (cápsula), espelho do `BottomNavShell`
 * da app Mobile (mobile/flutter/lib/widgets/bottom_nav_shell.dart).
 *
 * Só aparece em viewports pequenos (`lg:hidden`); no Desktop a navegação vive na
 * Sidebar lateral. Mantém a mesma disposição da Mobile: 4 separadores
 * (Início · Explorar · Fórum · Perfil) e um botão central "Criar" sobreposto,
 * visível apenas para quem tem permissão de criar conteúdo.
 */

const tabs = [
  { to: '/dashboard', match: ['/dashboard'], label: 'Início', icon: 'home' },
  { to: '/explorar', match: ['/explorar', '/explorar-arquivo'], label: 'Explorar', icon: 'explore' },
  { to: '/forum', match: ['/forum'], label: 'Fórum', icon: 'forum' },
  { to: '/perfil', match: ['/perfil'], label: 'Perfil', icon: 'person' },
]

// Separadores do Visitante — só áreas públicas. O último separador convida a
// entrar em vez de abrir o Perfil.
const guestTabs = [
  { to: '/home', match: ['/home', '/home-publica', '/home-landing'], label: 'Início', icon: 'home' },
  { to: '/explorar', match: ['/explorar', '/explorar-arquivo'], label: 'Explorar', icon: 'explore' },
  { to: '/quiz', match: ['/quiz'], label: 'Quizzes', icon: 'quiz' },
  { to: '/login', match: ['/login'], label: 'Entrar', icon: 'login' },
]

// Opções do botão "Criar" — apenas rotas reais já existentes na Web.
const createActions = [
  { to: '/gestao/submeter-artigo', label: 'Novo Artigo', icon: 'article', desc: 'Submeter um artigo para revisão' },
  { to: '/forum/novo-topico', label: 'Novo Tópico', icon: 'forum', desc: 'Abrir uma discussão no fórum' },
]

function isTabActive(pathname: string, match: string[]): boolean {
  return match.some((m) => pathname === m || pathname.startsWith(m + '/'))
}

export default function MobileBottomNav() {
  const navigate = useNavigate()
  const { pathname } = useLocation()
  const { user, isAuthenticated } = useAuth()
  const [createOpen, setCreateOpen] = useState(false)

  const activeTabs = isAuthenticated ? tabs : guestTabs
  const showCreate = isAuthenticated && canCreateContent(user)

  function go(to: string) {
    setCreateOpen(false)
    navigate(to)
  }

  return (
    <>
      {/* Bottom sheet do botão "Criar" (espelha o Centro de Criação da Mobile) */}
      {createOpen && (
        <div className="lg:hidden fixed inset-0 z-[60]" role="dialog" aria-modal="true">
          <button
            aria-label="Fechar"
            onClick={() => setCreateOpen(false)}
            className="absolute inset-0 bg-black/40 animate-fade-in"
          />
          <div className="absolute bottom-0 left-0 right-0 bg-surface rounded-t-3xl p-5 pb-8 shadow-xl animate-slide-up">
            <div className="w-10 h-1 rounded-full bg-outline-variant/60 mx-auto mb-5" />
            <p className="text-headline-md font-bold text-text font-sans mb-1">Criar conteúdo</p>
            <p className="text-body-sm text-secondary mb-4">O que pretende publicar?</p>
            <div className="flex flex-col gap-2">
              {createActions.map((a) => (
                <button
                  key={a.to}
                  onClick={() => go(a.to)}
                  className="flex items-center gap-4 p-4 rounded-2xl bg-surface-container-low border border-outline-variant/40 text-left active:scale-[0.98] transition-transform duration-150"
                >
                  <span className="icon-box-primary w-11 h-11">
                    <Icon name={a.icon} filled className="text-white text-[22px]" />
                  </span>
                  <span className="min-w-0">
                    <span className="block text-title-md font-semibold text-text font-sans">{a.label}</span>
                    <span className="block text-body-sm text-secondary truncate">{a.desc}</span>
                  </span>
                </button>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Cápsula flutuante */}
      <div className="lg:hidden fixed bottom-3 left-4 right-4 z-50 h-16">
        <div className="relative h-16 bg-surface rounded-full shadow-lg border border-outline-variant/25 flex items-center px-1">
          <NavTab tab={activeTabs[0]} pathname={pathname} onSelect={go} />
          <NavTab tab={activeTabs[1]} pathname={pathname} onSelect={go} />
          {showCreate && <div className="w-16 flex-shrink-0" aria-hidden />}
          <NavTab tab={activeTabs[2]} pathname={pathname} onSelect={go} />
          <NavTab tab={activeTabs[3]} pathname={pathname} onSelect={go} />
        </div>

        {/* Botão central "Criar" sobreposto */}
        {showCreate && (
          <button
            onClick={() => setCreateOpen(true)}
            aria-label="Criar conteúdo"
            className="absolute -top-5 left-1/2 -translate-x-1/2 w-14 h-14 rounded-full flex items-center justify-center
                       bg-gradient-to-br from-primary to-primary-dark text-white
                       border-4 border-background shadow-[0_6px_16px_rgba(139,26,26,0.45)]
                       active:scale-90 transition-transform duration-150"
          >
            <Icon name="add" className="text-white text-[28px]" />
          </button>
        )}
      </div>
    </>
  )
}

function NavTab({
  tab,
  pathname,
  onSelect,
}: {
  tab: { to: string; match: string[]; label: string; icon: string }
  pathname: string
  onSelect: (to: string) => void
}) {
  const active = isTabActive(pathname, tab.match)
  return (
    <button
      onClick={() => onSelect(tab.to)}
      aria-label={tab.label}
      aria-current={active ? 'page' : undefined}
      className="flex-1 h-full flex items-center justify-center"
    >
      <span
        className={`flex items-center justify-center rounded-full transition-all duration-200 ${
          active ? 'bg-primary/12 px-4 py-2' : 'px-2.5 py-2'
        }`}
      >
        <Icon
          name={tab.icon}
          filled={active}
          className={`text-[24px] transition-colors duration-150 ${active ? 'text-primary' : 'text-secondary'}`}
        />
      </span>
    </button>
  )
}
