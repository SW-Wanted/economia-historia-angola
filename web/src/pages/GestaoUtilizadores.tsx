import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth, canManageUsers } from '../contexts/AuthContext'

export default function GestaoUtilizadores() {
  const navigate = useNavigate()
  const { user } = useAuth()

  const showUserMgmt = canManageUsers(user)

  if (!showUserMgmt) {
    return (
      <AppShell searchPlaceholder="Pesquisar utilizadores...">
        <div className="page-content-narrow text-center py-20">
          <div className="empty-state">
            <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-primary/40 text-[30px]">lock</span>
            </div>
            <p className="text-headline-md font-bold text-text font-sans">Acesso Restrito</p>
            <p className="text-body-md text-secondary font-body">
              A gestão de utilizadores está reservada a administradores.
            </p>
            <button onClick={() => navigate('/dashboard')} className="btn-primary">Voltar ao Início</button>
          </div>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell searchPlaceholder="Pesquisar utilizadores...">
      <div className="page-content animate-fade-in">
        <div className="section-header mb-8">
          <div>
            <h2 className="section-title">Utilizadores</h2>
            <p className="section-subtitle">Gerencie os membros da plataforma.</p>
          </div>
          <button onClick={() => navigate('/gestao/conteudos')} className="btn-secondary">
            <span className="material-symbols-outlined text-[18px]">article</span>
            Gestão de Conteúdos
          </button>
        </div>

        <div className="alert-info rounded-card mb-6">
          <span className="material-symbols-outlined text-primary text-[18px] flex-shrink-0 mt-0.5">info</span>
          <div>
            <p className="text-sm font-bold text-text font-sans">Listagem não disponível</p>
            <p className="text-body-md text-secondary font-body mt-0.5">
              A API de listagem de utilizadores ainda não está disponível no servidor.
            </p>
          </div>
        </div>

        <div className="empty-state py-16">
          <div className="w-14 h-14 rounded-2xl bg-surface-container flex items-center justify-center">
            <span className="material-symbols-outlined text-primary/40 text-[30px]">group</span>
          </div>
          <p className="text-headline-md font-bold text-text font-sans">Nenhum utilizador para mostrar</p>
          <p className="text-body-md text-secondary font-body">
            O endpoint de listagem estará disponível em breve.
          </p>
        </div>
      </div>
    </AppShell>
  )
}
