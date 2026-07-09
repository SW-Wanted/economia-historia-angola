import { useNavigate, useLocation } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function ConfirmacaoPublicacao() {
  const navigate = useNavigate()
  const location = useLocation()
  const isPublisher = (location.state as { isPublisher?: boolean } | null)?.isPublisher ?? false

  return (
    <AppShell showSearch={false}>
      <div className="page-content-narrow py-12 text-center animate-fade-in">
        <div className="card p-10">
          <div className="w-20 h-20 bg-success/10 rounded-full flex items-center justify-center mx-auto mb-6">
            <span className="material-symbols-outlined text-success" style={{ fontSize: '48px', fontVariationSettings: "'FILL' 1" }}>check_circle</span>
          </div>

          {isPublisher ? (
            <>
              <h1 className="text-[32px] font-bold text-text mb-3 font-sans tracking-tight">Conteúdo Criado!</h1>
              <p className="text-lg text-secondary mb-8 font-reading">
                O conteúdo foi guardado com sucesso como rascunho.
              </p>
              <div className="bg-surface-warm border border-primary/15 rounded-card p-4 mb-8 text-left">
                <p className="text-xs font-semibold text-primary uppercase tracking-widest mb-2 flex items-center gap-1.5 font-sans">
                  <span className="material-symbols-outlined text-[14px]">info</span>
                  Nota sobre publicação
                </p>
                <p className="text-sm text-secondary font-reading leading-relaxed">
                  A publicação directa por utilizadores com permissão <strong>CONTENT_PUBLISH</strong> requer a implementação de um endpoint de publicação no backend. O conteúdo foi guardado como rascunho — para publicar, aceda à gestão de conteúdos ou contacte o administrador do sistema.
                </p>
              </div>
            </>
          ) : (
            <>
              <h1 className="text-[32px] font-bold text-text mb-3 font-sans tracking-tight">Artigo Submetido!</h1>
              <p className="text-lg text-secondary mb-8 font-reading">
                O seu artigo foi submetido com sucesso e está a aguardar revisão editorial. Será notificado quando for publicado.
              </p>
              <div className="bg-surface-container-low rounded-card p-4 mb-8 text-left">
                <p className="text-label-md font-sans text-text-muted uppercase tracking-widest mb-1">Próximos passos</p>
                <ul className="space-y-2 text-sm text-text font-body">
                  <li className="flex items-center gap-2"><span className="material-symbols-outlined text-primary text-[16px]">schedule</span>Revisão editorial (2–5 dias úteis)</li>
                  <li className="flex items-center gap-2"><span className="material-symbols-outlined text-primary text-[16px]">notifications</span>Notificação por email</li>
                  <li className="flex items-center gap-2"><span className="material-symbols-outlined text-primary text-[16px]">public</span>Publicação no arquivo</li>
                </ul>
              </div>
            </>
          )}

          <div className="flex gap-4">
            <button onClick={() => navigate('/gestao/submeter-artigo')} className="btn-secondary flex-1 justify-center">
              {isPublisher ? 'Criar Outro' : 'Submeter Outro'}
            </button>
            <button onClick={() => navigate(isPublisher ? '/gestao/conteudos' : '/dashboard')} className="btn-primary flex-1 justify-center">
              {isPublisher ? 'Ver Gestão' : 'Ir ao Dashboard'}
              <span className="material-symbols-outlined text-[18px]">{isPublisher ? 'article' : 'home'}</span>
            </button>
          </div>
        </div>
      </div>
    </AppShell>
  )
}
