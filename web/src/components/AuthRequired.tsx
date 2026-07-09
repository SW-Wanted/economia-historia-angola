import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from './AppShell'

interface AuthRequiredProps {
  /** Título apresentado ao Visitante. */
  title?: string
  /** Mensagem explicativa. */
  message?: string
  /** Ícone (Material Symbols). */
  icon?: string
}

/**
 * Ecrã de "acesso reservado" apresentado a um Visitante que tenta abrir uma
 * página protegida (por deep-link ou navegação directa). Em vez de um
 * redireccionamento brusco para /login ou de uma mensagem técnica (401), mostra
 * um convite elegante e coerente com o Design System — mantendo o Sidebar de
 * Visitante para que a pessoa continue a explorar livremente.
 */
export default function AuthRequired({
  title = 'Conteúdo reservado a membros',
  message = 'Esta área está disponível apenas para utilizadores registados. Inicie sessão ou crie uma conta gratuita para continuar.',
  icon = 'lock',
}: AuthRequiredProps) {
  const navigate = useNavigate()
  const location = useLocation()

  function goLogin() {
    navigate('/login', { state: { from: location } })
  }

  function goRegister() {
    navigate('/cadastro', { state: { from: location } })
  }

  return (
    <AppShell showSearch={false}>
      <div className="page-content-narrow animate-fade-in">
        <div className="card overflow-hidden">
          {/* Cabeçalho */}
          <div
            className="relative px-8 py-12 text-center overflow-hidden"
            style={{ background: 'linear-gradient(145deg, #8B1A1A 0%, #5A1010 100%)' }}
          >
            <div
              className="absolute inset-0 opacity-[0.06]"
              style={{ backgroundImage: 'radial-gradient(white 1px, transparent 1px)', backgroundSize: '20px 20px' }}
            />
            <div className="relative z-10 flex flex-col items-center gap-4">
              <div className="w-16 h-16 rounded-2xl bg-white/12 border border-white/20 flex items-center justify-center">
                <span className="material-symbols-outlined text-white text-[32px]">{icon}</span>
              </div>
              <h1 className="text-headline-xl font-bold text-white font-sans leading-snug max-w-md">{title}</h1>
              <p className="text-body-md text-white/75 font-body leading-relaxed max-w-sm">{message}</p>
            </div>
          </div>

          {/* Acções */}
          <div className="px-8 py-8 flex flex-col items-center gap-3">
            <div className="flex flex-col sm:flex-row gap-3 w-full max-w-sm">
              <button onClick={goLogin} className="btn-primary flex-1 justify-center">
                <span className="material-symbols-outlined text-[18px]">login</span>
                Iniciar Sessão
              </button>
              <button onClick={goRegister} className="btn-secondary flex-1 justify-center">
                <span className="material-symbols-outlined text-[18px]">person_add</span>
                Criar Conta
              </button>
            </div>
            <button
              onClick={() => navigate('/home')}
              className="mt-1 text-sm font-semibold font-sans text-secondary hover:text-primary transition-colors duration-150 flex items-center gap-1.5"
            >
              <span className="material-symbols-outlined text-[16px]">explore</span>
              Continuar a explorar sem conta
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
