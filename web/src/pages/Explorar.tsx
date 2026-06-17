import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const filters = ['Todos', 'História', 'Agricultura', 'Petróleo', 'Comércio', 'Arquivo']

const cards = [
  { type: 'featured', category: 'Categoria Especial', title: 'A Rota do Ouro Branco: O Legado do Algodão', desc: 'Uma análise profunda sobre como a produção de algodão moldou as fronteiras económicas e sociais no século XIX.', meta: '15 min de leitura', route: '/leitura/microtexto', span: 'col-span-12 md:col-span-8' },
  { type: 'card', category: 'Microtexto', title: 'Estabilidade Cambial e o Passado', desc: 'Reflexões curtas sobre as flutuações da moeda nacional comparadas ao período colonial.', meta: 'Hoje', route: '/leitura/microtexto', span: 'col-span-12 md:col-span-4' },
  { type: 'card', category: 'Microtexto', title: 'O Café de Uíge: Relevância Global', desc: 'Como a região se tornou o epicentro da exportação e o que resta dessa infraestrutura hoje.', meta: '2 dias atrás', route: '/leitura/microtexto', span: 'col-span-12 md:col-span-4' },
  { type: 'featured', category: 'Análise de Setor', title: 'Petróleo: Da Descoberta ao Futuro', desc: 'A evolução da indústria petrolífera e sua influência na balança comercial angolana desde 1950.', meta: '22 min de leitura', route: '/leitura/jindungo', span: 'col-span-12 md:col-span-8' },
  { type: 'archive', category: 'Arquivo', title: 'Tratado de Comércio de 1891', desc: 'Acesso digital exclusivo ao documento original que redefiniu as taxas alfandegárias de Luanda.', meta: 'Documento', route: '/documento/detalhe', span: 'col-span-12 md:col-span-4' },
  { type: 'card', category: 'Microtexto', title: 'Auto-suficiência Alimentar', desc: 'O paradoxo da abundância: por que a agricultura ainda luta para atingir o seu potencial histórico.', meta: '1 semana atrás', route: '/leitura/microtexto', span: 'col-span-12 md:col-span-4' },
  { type: 'video', category: 'Aula em Vídeo', title: 'Economia de Luanda Colonial: Das Feitorias ao Século XX', desc: 'Explore a evolução económica de Luanda desde as primeiras feitorias portuguesas até ao início do século XX.', meta: '45 min', route: '/aula-video', span: 'col-span-12 md:col-span-4' },
]

export default function Explorar() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos')

  return (
    <AppShell searchPlaceholder="Pesquisar por eras, setores ou eventos...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        <div className="mb-10">
          <h2 className="text-[40px] font-extrabold mb-3 leading-tight text-[#1c1b1b] tracking-tight font-sans">Explorar Conteúdos</h2>
          <p className="text-sm text-[#5d5f5d] max-w-2xl font-serif leading-relaxed">
            Mergulhe na complexa tapeçaria económica de Angola através de análises profundas, dados históricos e perspectivas setoriais.
          </p>
        </div>

        {/* Filters */}
        <div className="flex flex-wrap items-center gap-2 mb-10">
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-5 py-2 rounded-full text-sm font-semibold font-sans transition-all duration-150 active:scale-[0.98] ${
                activeFilter === f
                  ? 'bg-[#8B1A1A] text-white shadow-xs'
                  : 'bg-white border border-[#ebe5e4] text-[#4a4a4a] hover:border-[#8B1A1A]/40 hover:text-[#8B1A1A]'
              }`}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Grid */}
        <div className="grid grid-cols-12 gap-5">
          {cards.map((card) => (
            <article
              key={card.title}
              onClick={() => navigate(card.route)}
              className={`${card.span} bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer flex ${card.type === 'featured' ? 'flex-col md:flex-row' : 'flex-col'} group`}
            >
              {card.type === 'featured' ? (
                <>
                  <div className="md:w-1/2 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center min-h-[200px]">
                    <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '90px' }}>history_edu</span>
                  </div>
                  <div className="md:w-1/2 p-7 flex flex-col justify-center">
                    <span className="text-[#8B1A1A] text-[10px] font-bold mb-2 tracking-[0.1em] uppercase font-sans">{card.category}</span>
                    <h3 className="text-xl font-bold mb-3 text-[#1c1b1b] font-sans leading-snug">{card.title}</h3>
                    <p className="text-sm text-[#5d5f5d] mb-5 font-serif leading-relaxed">{card.desc}</p>
                    <div className="flex items-center gap-2">
                      <span className="material-symbols-outlined text-[#8B1A1A] text-[16px]">schedule</span>
                      <span className="text-xs text-[#8c716e]">{card.meta}</span>
                    </div>
                  </div>
                </>
              ) : card.type === 'archive' ? (
                <>
                  <div className="h-44 bg-[#8B1A1A] flex items-center justify-center">
                    <span className="material-symbols-outlined text-white/30 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '52px' }}>history_edu</span>
                  </div>
                  <div className="p-5 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2.5">
                      <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">{card.category}</span>
                      <span className="text-[#b8a5a3] text-xs">{card.meta}</span>
                    </div>
                    <h3 className="text-base font-semibold mb-2 text-[#1c1b1b] font-sans leading-snug">{card.title}</h3>
                    <p className="text-sm text-[#5d5f5d] line-clamp-3 flex-grow font-serif leading-relaxed">{card.desc}</p>
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold font-sans flex items-center gap-1">
                      Ver Arquivo <span className="material-symbols-outlined text-[16px]">download</span>
                    </div>
                  </div>
                </>
              ) : card.type === 'video' ? (
                <>
                  <div className="h-44 bg-[#1c1b1b] flex items-center justify-center overflow-hidden relative">
                    <div className="absolute inset-0 bg-gradient-to-br from-[#8B1A1A]/25 to-transparent" />
                    <span className="material-symbols-outlined text-white/25 group-hover:scale-105 transition-transform duration-300 relative z-10" style={{ fontSize: '64px', fontVariationSettings: "'FILL' 1" }}>play_circle</span>
                  </div>
                  <div className="p-5 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2.5">
                      <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">{card.category}</span>
                      <span className="text-[#b8a5a3] text-xs">{card.meta}</span>
                    </div>
                    <h3 className="text-base font-semibold mb-2 text-[#1c1b1b] font-sans leading-snug">{card.title}</h3>
                    <p className="text-sm text-[#5d5f5d] line-clamp-3 flex-grow font-serif leading-relaxed">{card.desc}</p>
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold font-sans flex items-center gap-1">
                      Ver Aula <span className="material-symbols-outlined text-[16px]">play_arrow</span>
                    </div>
                  </div>
                </>
              ) : (
                <>
                  <div className="h-44 bg-gradient-to-br from-[#f0eded] to-[#e8e2e1] flex items-center justify-center overflow-hidden">
                    <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '64px' }}>article</span>
                  </div>
                  <div className="p-5 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2.5">
                      <span className="bg-[#fff5f4] text-[#8B1A1A] px-2.5 py-0.5 rounded-full text-[10px] font-bold font-sans">{card.category}</span>
                      <span className="text-[#b8a5a3] text-xs">{card.meta}</span>
                    </div>
                    <h3 className="text-base font-semibold mb-2 text-[#1c1b1b] font-sans leading-snug">{card.title}</h3>
                    <p className="text-sm text-[#5d5f5d] line-clamp-3 flex-grow font-serif leading-relaxed">{card.desc}</p>
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold font-sans flex items-center gap-1">
                      Ler Agora <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
                    </div>
                  </div>
                </>
              )}
            </article>
          ))}

          {/* Quote card */}
          <article className="col-span-12 md:col-span-4 bg-[#8B1A1A] rounded-xl p-7 flex flex-col justify-center text-white shadow-card">
            <span className="material-symbols-outlined text-3xl mb-4 opacity-60" style={{ fontVariationSettings: "'FILL' 1" }}>format_quote</span>
            <blockquote className="text-base italic mb-5 leading-relaxed font-serif">
              "A economia de amanhã é construída sobre as fundações das lições que decidimos ignorar no passado."
            </blockquote>
            <cite className="text-xs not-italic text-white/60 font-sans">— Análise Editorial, 2024</cite>
          </article>
        </div>
      </div>
    </AppShell>
  )
}
