import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'
import { useAuth, canManageUsers } from '../contexts/AuthContext'

export default function GestaoUtilizadores() {
  const navigate = useNavigate()
  const { user } = useAuth()

  const showUserMgmt = canManageUsers(user)

  if (!showUserMgmt) {
    return (
      <AppShell title="Gestão de Utilizadores" searchPlaceholder="Pesquisar utilizadores...">
        <div className="px-10 py-16 max-w-[600px] mx-auto text-center">
          <div className="bg-white rounded-xl p-10 border border-[#ebe5e4]">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 text-5xl mb-3 block">lock</span>
            <h2 className="text-xl font-bold text-[#1c1b1b] mb-2 font-sans">Acesso Restrito</h2>
            <p className="text-sm text-[#5d5f5d] font-serif mb-5">
              A gestão de utilizadores está reservada a administradores.
            </p>
            <button onClick={() => navigate('/dashboard')}
              className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all">
              Voltar ao Início
            </button>
          </div>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell title="Gestão de Utilizadores" searchPlaceholder="Pesquisar utilizadores...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-1 font-sans">Utilizadores</h2>
            <p className="text-base text-[#5d5f5d] font-serif">Gerencie os membros da plataforma.</p>
          </div>
          <div className="flex gap-3">
            <button onClick={() => navigate('/gestao/conteudos')}
              className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
              <span className="material-symbols-outlined text-[18px]">article</span>
              Conteúdos
            </button>
          </div>
        </div>

        {/* Backend gap notice */}
        <div className="bg-[#fff8f7] border border-[#8B1A1A]/15 rounded-xl p-5 mb-6 flex items-start gap-3">
          <span className="material-symbols-outlined text-[#8B1A1A] text-[20px] mt-0.5 flex-shrink-0">info</span>
          <div>
            <p className="text-sm font-semibold text-[#1c1b1b] font-sans mb-0.5">Listagem de utilizadores não disponível</p>
            <p className="text-xs text-[#5d5f5d] font-serif">
              A API de listagem de utilizadores ainda não está disponível no servidor. Esta página será actualizada quando o endpoint estiver implementado.
            </p>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-[#e0bfbc] p-12 text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/20 text-5xl mb-3 block">group</span>
          <p className="text-base font-bold text-[#1c1b1b] mb-1 font-sans">Nenhum utilizador para mostrar</p>
          <p className="text-sm text-[#5d5f5d] font-serif">
            O endpoint de listagem de utilizadores ainda não está disponível.
          </p>
        </div>
      </div>
    </AppShell>
  )
}
