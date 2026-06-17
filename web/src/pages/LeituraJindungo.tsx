import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

export default function LeituraJindungo() {
  const navigate = useNavigate()
  const [unlocked] = useState(true)

  return (
    <AppShell showSearch={false}>
      <div className="px-10 py-8 max-w-[800px] mx-auto">
        <button
          onClick={() => navigate('/explorar')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Arquivo
        </button>

        {/* Jindungo badge */}
        <div className="flex items-center gap-3 mb-4">
          <span className="bg-[#8B1A1A] text-white px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
            <span className="material-symbols-outlined text-[14px]">nutrition</span>
            Texto Jindungo
          </span>
          <span className="text-xs text-[#5d5f5d]">22 min de leitura</span>
          <span className="text-xs text-[#5d5f5d]">•</span>
          <span className="text-xs text-[#5d5f5d]">Análise Profunda</span>
        </div>

        <h1 className="text-[40px] font-extrabold text-[#1c1b1b] leading-tight mb-4">
          A Geopolítica do Diamante na Lunda Norte
        </h1>

        <p className="text-xl text-[#58413f] italic mb-8" style={{ fontFamily: 'Merriweather, serif' }}>
          "Para entender o brilho de hoje, precisamos de olhar para as cicatrizes de ontem no solo da Lunda."
        </p>

        <div className="flex items-center gap-4 mb-8">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-full bg-[#eae7e7] flex items-center justify-center">
              <span className="material-symbols-outlined text-[#5d5f5d]">person</span>
            </div>
            <div>
              <span className="text-sm font-bold text-[#1c1b1b]">Dr. Paulo Vunge</span>
              <p className="text-xs text-[#5d5f5d]">Historiador Sénior</p>
            </div>
          </div>
        </div>

        {/* Cover */}
        <div className="w-full h-72 bg-[#8B1A1A] rounded-xl flex items-center justify-center mb-8 relative overflow-hidden">
          <span className="material-symbols-outlined text-white/10" style={{ fontSize: '200px' }}>diamond</span>
          <div className="absolute inset-0 flex items-center justify-center">
            <span className="material-symbols-outlined text-white/30" style={{ fontSize: '100px' }}>nutrition</span>
          </div>
        </div>

        {unlocked ? (
          <article style={{ fontFamily: 'Merriweather, serif' }}>
            <p className="text-lg text-[#1c1b1b] leading-relaxed mb-6">
              A região da Lunda Norte encerra em si mesma uma das mais complexas narrativas da história económica angolana. Aqui, a riqueza mineral coexistiu sempre com a pobreza humana — uma contradição que define não apenas o passado colonial, mas também os desafios do presente.
            </p>
            <p className="text-lg text-[#5d5f5d] leading-relaxed mb-6">
              Quando a DIAMANG estabeleceu as suas operações na região em 1917, trouxe consigo não apenas tecnologia de extração, mas um sistema completo de controlo social. Os trabalhadores eram recrutados de forma compulsória, as comunidades locais eram deslocadas, e os lucros fluíam para Lisboa e para os acionistas europeus.
            </p>
            <blockquote className="border-l-4 border-[#8B1A1A] pl-6 my-8 italic text-[#58413f]">
              "A Lunda deu ao mundo os seus diamantes. O mundo deu à Lunda as suas cicatrizes."
            </blockquote>
            <p className="text-lg text-[#5d5f5d] leading-relaxed mb-6">
              Após a independência, a ENDIAMA assumiu o controlo das operações, mas os desafios estruturais permaneceram. A guerra civil transformou as minas em fontes de financiamento para ambos os lados do conflito, perpetuando um ciclo de violência e exploração que só terminaria com o cessar-fogo de 2002.
            </p>
          </article>
        ) : (
          <div className="bg-[#f6f3f2] rounded-xl p-12 text-center border border-[#e0bfbc]">
            <span className="material-symbols-outlined text-[#8B1A1A]/30 mb-4" style={{ fontSize: '80px' }}>lock</span>
            <h3 className="text-2xl font-bold text-[#1c1b1b] mb-2">Conteúdo Exclusivo</h3>
            <p className="text-base text-[#5d5f5d] mb-6" style={{ fontFamily: 'Merriweather, serif' }}>
              Este texto Jindungo requer uma conta verificada para acesso completo.
            </p>
            <button
              onClick={() => navigate('/cadastro')}
              className="bg-[#8B1A1A] text-white px-8 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all"
            >
              Criar Conta Grátis
            </button>
          </div>
        )}

        <div className="flex justify-between items-center mt-12 pt-8 border-t border-[#e0bfbc]">
          <button
            onClick={() => navigate('/leitura/microtexto')}
            className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors text-sm font-semibold"
          >
            <span className="material-symbols-outlined text-[18px]">arrow_back</span>
            Artigo anterior
          </button>
          <button
            onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 text-[#8B1A1A] hover:opacity-80 transition-colors text-sm font-semibold"
          >
            Ver mais artigos
            <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
          </button>
        </div>
      </div>
    </AppShell>
  )
}
