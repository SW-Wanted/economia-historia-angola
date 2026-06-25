import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function ConfirmacaoPublicacao() {
  const navigate = useNavigate()
  const location = useLocation()
  const isPublisher = (location.state as { isPublisher?: boolean } | null)?.isPublisher ?? false

  return (
    <AppShell showSearch={false}>
      <div className="px-10 py-16 max-w-[600px] mx-auto text-center">
        <div className="bg-white rounded-xl p-12 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
          <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <span className="material-symbols-outlined text-green-600" style={{ fontSize: '48px', fontVariationSettings: "'FILL' 1" }}>check_circle</span>
          </div>

          {isPublisher ? (
            <>
              <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-3">Conteúdo Criado!</h1>
              <p className="text-lg text-[#5d5f5d] mb-8 font-serif">
                O conteúdo foi guardado com sucesso como rascunho.
              </p>
              <div className="bg-[#fff8f7] border border-[#8B1A1A]/15 rounded-xl p-4 mb-8 text-left">
                <p className="text-xs font-semibold text-[#8B1A1A] uppercase tracking-widest mb-2 flex items-center gap-1.5">
                  <span className="material-symbols-outlined text-[14px]">info</span>
                  Nota sobre publicação
                </p>
                <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
                  A publicação directa por utilizadores com permissão <strong>CONTENT_PUBLISH</strong> requer a implementação de um endpoint de publicação no backend. O conteúdo foi guardado como rascunho — para publicar, aceda à gestão de conteúdos ou contacte o administrador do sistema.
                </p>
              </div>
            </>
          ) : (
            <>
              <h1 className="text-[32px] font-bold text-[#1c1b1b] mb-3">Artigo Submetido!</h1>
              <p className="text-lg text-[#5d5f5d] mb-8 font-serif">
                O seu artigo foi submetido com sucesso e está a aguardar revisão editorial. Será notificado quando for publicado.
              </p>
              <div className="bg-[#f6f3f2] rounded-xl p-4 mb-8 text-left">
                <p className="text-xs font-semibold text-[#5d5f5d] uppercase tracking-widest mb-1">Próximos passos</p>
                <ul className="space-y-2 text-sm text-[#1c1b1b] font-serif">
                  <li className="flex items-center gap-2"><span className="material-symbols-outlined text-[#8B1A1A] text-[16px]">schedule</span>Revisão editorial (2–5 dias úteis)</li>
                  <li className="flex items-center gap-2"><span className="material-symbols-outlined text-[#8B1A1A] text-[16px]">notifications</span>Notificação por email</li>
                  <li className="flex items-center gap-2"><span className="material-symbols-outlined text-[#8B1A1A] text-[16px]">public</span>Publicação no arquivo</li>
                </ul>
              </div>
            </>
          )}

          <div className="flex gap-4">
            <button onClick={() => navigate('/gestao/submeter-artigo')}
              className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors">
              {isPublisher ? 'Criar Outro' : 'Submeter Outro'}
            </button>
            <button onClick={() => navigate(isPublisher ? '/gestao/conteudos' : '/dashboard')}
              className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all flex items-center justify-center gap-2">
              {isPublisher ? 'Ver Gestão' : 'Ir ao Dashboard'}
              <span className="material-symbols-outlined text-[18px]">{isPublisher ? 'article' : 'home'}</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
