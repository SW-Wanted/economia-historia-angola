import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function MeusFavoritos() {
  const navigate = useNavigate()

  return (
    <AppShell searchPlaceholder="Pesquisar favoritos...">
      <div className="page-content animate-fade-in">
        <div className="section-header mb-8">
          <div>
            <h2 className="section-title">Favoritos</h2>
            <p className="section-subtitle">Os seus conteúdos guardados para leitura posterior.</p>
          </div>
          <button onClick={() => navigate('/explorar')} className="btn-primary">
            <span className="material-symbols-outlined text-[18px]">add</span>
            Explorar Arquivo
          </button>
        </div>

        <div className="alert-info rounded-card mb-7">
          <span className="material-symbols-outlined text-primary text-[18px] flex-shrink-0 mt-0.5">info</span>
          <p className="text-body-md text-secondary font-body">
            Para guardar um artigo, clique no ícone{' '}
            <span className="material-symbols-outlined text-[12px] mx-0.5 align-middle">bookmark</span>
            {' '}em qualquer conteúdo. A listagem dos seus favoritos estará disponível em breve.
          </p>
        </div>

        <div className="empty-state py-20">
          <div className="w-16 h-16 rounded-2xl bg-surface-container flex items-center justify-center">
            <span className="material-symbols-outlined text-primary/30 text-[36px]">bookmark</span>
          </div>
          <p className="text-headline-md font-bold text-text font-sans">Nenhum favorito ainda</p>
          <p className="text-body-md text-secondary font-body max-w-sm text-center leading-relaxed">
            Explore o arquivo e guarde artigos que queira reler mais tarde.
          </p>
          <button onClick={() => navigate('/explorar')} className="btn-primary">
            <span className="material-symbols-outlined text-[18px]">explore</span>
            Explorar Conteúdos
          </button>
        </div>
      </div>
    </AppShell>
  )
}
