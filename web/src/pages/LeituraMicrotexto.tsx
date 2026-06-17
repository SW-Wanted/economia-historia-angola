import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function LeituraMicrotexto() {
  const navigate = useNavigate()
  const [bookmarked, setBookmarked] = useState(false)
  const [liked, setLiked] = useState(false)

  return (
    <AppShell showSearch={false}>
      <div className="px-10 py-8 max-w-[800px] mx-auto">
        {/* Back */}
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {/* Article header */}
        <div className="mb-8">
          <div className="flex items-center gap-3 mb-4">
            <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs font-semibold">Microtexto</span>
            <span className="text-xs text-[#5d5f5d]">8 min de leitura</span>
            <span className="text-xs text-[#5d5f5d]">•</span>
            <span className="text-xs text-[#5d5f5d]">Era Colonial</span>
          </div>
          <h1 className="text-[40px] font-extrabold text-[#1c1b1b] leading-tight mb-4">
            A Rota dos Diamantes: Da Exploração Colonial à Independência
          </h1>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-[#eae7e7] flex items-center justify-center">
                <span className="material-symbols-outlined text-[#5d5f5d]">person</span>
              </div>
              <div>
                <span className="text-sm font-bold text-[#1c1b1b]">Dr. Paulo Vunge</span>
                <p className="text-xs text-[#5d5f5d]">Historiador Sénior</p>
              </div>
            </div>
            <div className="flex items-center gap-3 ml-auto">
              <button
                onClick={() => setLiked(!liked)}
                className={`flex items-center gap-1 text-sm transition-colors ${liked ? 'text-[#8B1A1A]' : 'text-[#5d5f5d] hover:text-[#8B1A1A]'}`}
              >
                <span className="material-symbols-outlined text-[18px]" style={liked ? { fontVariationSettings: "'FILL' 1" } : undefined}>thumb_up</span>
                <span>42</span>
              </button>
              <button
                onClick={() => setBookmarked(!bookmarked)}
                className={`flex items-center gap-1 text-sm transition-colors ${bookmarked ? 'text-[#8B1A1A]' : 'text-[#5d5f5d] hover:text-[#8B1A1A]'}`}
              >
                <span className="material-symbols-outlined text-[18px]" style={bookmarked ? { fontVariationSettings: "'FILL' 1" } : undefined}>bookmark</span>
              </button>
              <button
                onClick={() => navigate('/forum/detalhe')}
                className="flex items-center gap-1 text-sm text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors"
              >
                <span className="material-symbols-outlined text-[18px]">forum</span>
                <span>Discutir</span>
              </button>
            </div>
          </div>
        </div>

        {/* Progress bar */}
        <div className="w-full bg-[#eae7e7] h-1 rounded-full mb-8">
          <div className="bg-[#8B1A1A] h-1 rounded-full w-[60%]" />
        </div>

        {/* Cover image placeholder */}
        <div className="w-full h-64 bg-[#eae7e7] rounded-xl flex items-center justify-center mb-8">
          <span className="material-symbols-outlined text-[#8B1A1A]/20" style={{ fontSize: '100px' }}>history_edu</span>
        </div>

        {/* Article body */}
        <article className="prose max-w-none" style={{ fontFamily: 'Merriweather, serif' }}>
          <p className="text-lg text-[#1c1b1b] leading-relaxed mb-6">
            A história dos diamantes em Angola é inseparável da história da própria nação. Desde as primeiras descobertas no início do século XX, as pedras preciosas da Lunda Norte e da Lunda Sul moldaram não apenas a economia, mas também a geopolítica e a identidade cultural do país.
          </p>
          <p className="text-lg text-[#5d5f5d] leading-relaxed mb-6">
            A Companhia de Diamantes de Angola (DIAMANG), fundada em 1917, tornou-se um dos pilares do sistema colonial português. Com sede em Lisboa mas operações concentradas no nordeste angolano, a empresa controlava não apenas a extração, mas também a vida social e económica das comunidades locais.
          </p>
          <blockquote className="border-l-4 border-[#8B1A1A] pl-6 my-8 italic text-[#58413f]">
            "Os diamantes da Lunda não eram apenas pedras — eram o sangue de uma nação que ainda não sabia que era nação."
            <cite className="block text-sm not-italic mt-2 text-[#5d5f5d]">— Arquivo Histórico Nacional, 1965</cite>
          </blockquote>
          <p className="text-lg text-[#5d5f5d] leading-relaxed mb-6">
            Com a independência em 1975, o controlo das minas passou para o Estado angolano através da ENDIAMA. O período que se seguiu foi marcado por tensões entre a necessidade de manter a produção e os desafios da guerra civil que assolou o país durante décadas.
          </p>
          <p className="text-lg text-[#5d5f5d] leading-relaxed mb-6">
            Hoje, Angola é o quinto maior produtor mundial de diamantes, com uma produção anual que ultrapassa os 9 milhões de quilates. A indústria representa cerca de 1,5% do PIB nacional e emprega diretamente mais de 30.000 pessoas.
          </p>
        </article>

        {/* Navigation between articles */}
        <div className="flex justify-between items-center mt-12 pt-8 border-t border-[#e0bfbc]">
          <button
            onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors text-sm font-semibold"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Artigo anterior
          </button>
          <button
            onClick={() => navigate('/leitura/jindungo')}
            className="flex items-center gap-2 text-[#8B1A1A] hover:opacity-80 transition-colors text-sm font-semibold"
          >
            Próximo artigo
            <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
          </button>
        </div>

        {/* Related */}
        <div className="mt-12">
          <h3 className="text-2xl font-bold text-[#1c1b1b] mb-6">Artigos Relacionados</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {[
              { title: 'O Ciclo do Café e a Transformação do Planalto Central', category: 'Microtexto' },
              { title: 'A Geopolítica do Diamante na Lunda Norte', category: 'Jindungo' },
            ].map((a) => (
              <button
                key={a.title}
                onClick={() => navigate('/leitura/microtexto')}
                className="bg-white rounded-xl p-4 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all text-left group"
              >
                <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full mb-2 inline-block">{a.category}</span>
                <h4 className="text-base font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors">{a.title}</h4>
              </button>
            ))}
          </div>
        </div>
      </div>
    </AppShell>
  )
}
