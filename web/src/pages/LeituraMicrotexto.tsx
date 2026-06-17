import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function LeituraMicrotexto() {
  const navigate = useNavigate()
  const [bookmarked, setBookmarked] = useState(false)
  const [liked, setLiked] = useState(false)

  return (
    <AppShell showSearch={false}>
      <div className="px-10 py-10 max-w-[760px] mx-auto">
        {/* Back */}
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 mb-8 text-sm font-semibold font-sans"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {/* Article header */}
        <div className="mb-8">
          <div className="flex items-center gap-2.5 mb-4">
            <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">Microtexto</span>
            <span className="text-xs text-[#b8a5a3]">8 min de leitura</span>
            <span className="text-[#d4c5c3]">•</span>
            <span className="text-xs text-[#b8a5a3]">Era Colonial</span>
          </div>
          <h1 className="text-[36px] font-extrabold text-[#1c1b1b] leading-tight mb-5 font-sans tracking-tight">
            A Rota dos Diamantes: Da Exploração Colonial à Independência
          </h1>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-full bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] border border-[#ebe5e4] flex items-center justify-center flex-shrink-0">
                <span className="text-[11px] font-bold text-[#8B1A1A] font-sans leading-none">PV</span>
              </div>
              <div>
                <span className="text-sm font-bold text-[#1c1b1b] font-sans">Dr. Paulo Vunge</span>
                <p className="text-[10px] text-[#8c716e] font-sans">Historiador Sénior</p>
              </div>
            </div>
            <div className="flex items-center gap-3 ml-auto">
              <button
                onClick={() => setLiked(!liked)}
                className={`flex items-center gap-1.5 text-sm transition-all duration-150 px-3 py-1.5 rounded-lg ${liked ? 'text-[#8B1A1A] bg-[#fff5f4]' : 'text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded]'}`}
              >
                <span className="material-symbols-outlined text-[18px]" style={liked ? { fontVariationSettings: "'FILL' 1" } : undefined}>thumb_up</span>
                <span className="font-sans font-semibold">42</span>
              </button>
              <button
                onClick={() => setBookmarked(!bookmarked)}
                className={`p-1.5 rounded-lg transition-all duration-150 ${bookmarked ? 'text-[#8B1A1A] bg-[#fff5f4]' : 'text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded]'}`}
              >
                <span className="material-symbols-outlined text-[18px]" style={bookmarked ? { fontVariationSettings: "'FILL' 1" } : undefined}>bookmark</span>
              </button>
              <button
                onClick={() => navigate('/forum/detalhe')}
                className="flex items-center gap-1.5 text-sm text-[#5d5f5d] hover:text-[#8B1A1A] hover:bg-[#f0eded] px-3 py-1.5 rounded-lg transition-all duration-150"
              >
                <span className="material-symbols-outlined text-[18px]">forum</span>
                <span className="font-sans font-semibold">Discutir</span>
              </button>
            </div>
          </div>
        </div>

        {/* Progress bar */}
        <div className="w-full bg-[#f0eded] h-1.5 rounded-full mb-8">
          <div className="bg-[#8B1A1A] h-1.5 rounded-full w-[60%]" />
        </div>

        {/* Cover image placeholder */}
        <div className="w-full h-60 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] rounded-xl flex items-center justify-center mb-8 border border-[#ebe5e4]">
          <span className="material-symbols-outlined text-[#8B1A1A]/15" style={{ fontSize: '90px' }}>history_edu</span>
        </div>

        {/* Article body */}
        <article className="font-serif">
          <p className="text-base text-[#1c1b1b] leading-relaxed mb-5">
            A história dos diamantes em Angola é inseparável da história da própria nação. Desde as primeiras descobertas no início do século XX, as pedras preciosas da Lunda Norte e da Lunda Sul moldaram não apenas a economia, mas também a geopolítica e a identidade cultural do país.
          </p>
          <p className="text-base text-[#5d5f5d] leading-relaxed mb-5">
            A Companhia de Diamantes de Angola (DIAMANG), fundada em 1917, tornou-se um dos pilares do sistema colonial português. Com sede em Lisboa mas operações concentradas no nordeste angolano, a empresa controlava não apenas a extração, mas também a vida social e económica das comunidades locais.
          </p>
          <blockquote className="border-l-[3px] border-[#8B1A1A] pl-5 my-8 italic text-[#58413f] text-base leading-relaxed">
            "Os diamantes da Lunda não eram apenas pedras — eram o sangue de uma nação que ainda não sabia que era nação."
            <cite className="block text-xs not-italic mt-2 text-[#8c716e] font-sans not-italic">— Arquivo Histórico Nacional, 1965</cite>
          </blockquote>
          <p className="text-base text-[#5d5f5d] leading-relaxed mb-5">
            Com a independência em 1975, o controlo das minas passou para o Estado angolano através da ENDIAMA. O período que se seguiu foi marcado por tensões entre a necessidade de manter a produção e os desafios da guerra civil que assolou o país durante décadas.
          </p>
          <p className="text-base text-[#5d5f5d] leading-relaxed mb-5">
            Hoje, Angola é o quinto maior produtor mundial de diamantes, com uma produção anual que ultrapassa os 9 milhões de quilates. A indústria representa cerca de 1,5% do PIB nacional e emprega diretamente mais de 30.000 pessoas.
          </p>
        </article>

        {/* Navigation between articles */}
        <div className="flex justify-between items-center mt-10 pt-7 border-t border-[#ebe5e4]">
          <button
            onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors duration-150 text-sm font-semibold font-sans"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Artigo anterior
          </button>
          <button
            onClick={() => navigate('/leitura/jindungo')}
            className="flex items-center gap-2 text-[#8B1A1A] hover:opacity-75 transition-opacity duration-150 text-sm font-semibold font-sans"
          >
            Próximo artigo
            <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
          </button>
        </div>

        {/* Related */}
        <div className="mt-10">
          <h3 className="text-lg font-bold text-[#1c1b1b] mb-4 font-sans">Artigos Relacionados</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            {[
              { title: 'O Ciclo do Café e a Transformação do Planalto Central', category: 'Microtexto' },
              { title: 'A Geopolítica do Diamante na Lunda Norte', category: 'Jindungo' },
            ].map((a) => (
              <button
                key={a.title}
                onClick={() => navigate('/leitura/microtexto')}
                className="bg-white rounded-xl p-4 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:border-[#8B1A1A]/30 hover:-translate-y-0.5 transition-all duration-150 text-left group"
              >
                <span className="text-[10px] font-bold text-[#8B1A1A] bg-[#fff5f4] px-2 py-0.5 rounded-full mb-2 inline-block font-sans">{a.category}</span>
                <h4 className="text-sm font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors duration-150 font-sans leading-snug">{a.title}</h4>
              </button>
            ))}
          </div>
        </div>
      </div>
    </AppShell>
  )
}
