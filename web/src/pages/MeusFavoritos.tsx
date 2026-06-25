import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function MeusFavoritos() {
  const navigate = useNavigate()

  return (
    <AppShell title="Favoritos e Marcadores" searchPlaceholder="Pesquisar favoritos...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-1 font-sans">Favoritos e Marcadores</h2>
            <p className="text-base text-[#5d5f5d] font-serif">Os seus conteúdos guardados.</p>
          </div>
          <button onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
            <span className="material-symbols-outlined text-[18px]">add</span>
            Explorar mais
          </button>
        </div>

        {/* Backend gap notice */}
        <div className="bg-[#fff8f7] border border-[#8B1A1A]/15 rounded-xl p-4 mb-6 flex items-start gap-3">
          <span className="material-symbols-outlined text-[#8B1A1A] text-[18px] mt-0.5 flex-shrink-0">info</span>
          <p className="text-xs text-[#5d5f5d] font-serif">
            Para guardar um artigo nos favoritos, clique no ícone de marcador
            <span className="material-symbols-outlined text-[12px] mx-0.5 align-middle">bookmark</span>
            em qualquer artigo. A listagem dos seus favoritos estará disponível em breve.
          </p>
        </div>

        <div className="bg-white rounded-xl border border-[#ebe5e4] p-14 text-center">
          <span className="material-symbols-outlined text-[#8B1A1A]/20 mb-4 block" style={{ fontSize: '72px' }}>bookmark</span>
          <p className="text-lg font-bold text-[#1c1b1b] mb-2 font-sans">Nenhum favorito para mostrar</p>
          <p className="text-sm text-[#5d5f5d] font-serif mb-6 max-w-sm mx-auto">
            A listagem de favoritos estará disponível em breve. Entretanto, explore o arquivo e use o ícone de marcador para guardar artigos.
          </p>
          <button onClick={() => navigate('/explorar')}
            className="bg-[#8B1A1A] text-white px-8 py-3 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] transition-all">
            Explorar Conteúdos
          </button>
        </div>
      </div>
    </AppShell>
  )
}
