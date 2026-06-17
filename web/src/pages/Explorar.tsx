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
      <div className="px-10 py-16 max-w-[1160px] mx-auto">
        <div className="mb-16">
          <h2 className="text-[48px] font-extrabold mb-4 leading-tight text-[#1c1b1b]">Explorar Conteúdos</h2>
          <p className="text-lg text-[#5d5f5d] max-w-2xl" style={{ fontFamily: 'Merriweather, serif' }}>
            Mergulhe na complexa tapeçaria económica de Angola através de análises profundas, dados históricos e perspectivas setoriais.
          </p>
        </div>

        {/* Filters */}
        <div className="flex flex-wrap items-center gap-4 mb-16">
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-6 py-2 rounded-full text-sm font-semibold transition-all active:scale-95 ${
                activeFilter === f
                  ? 'bg-[#8B1A1A] text-white'
                  : 'bg-white border border-[#e0bfbc] text-[#1c1b1b] hover:border-[#8B1A1A] hover:text-[#8B1A1A]'
              }`}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Grid */}
        <div className="grid grid-cols-12 gap-6">
          {cards.map((card) => (
            <article
              key={card.title}
              onClick={() => navigate(card.route)}
              className={`${card.span} bg-white rounded-xl overflow-hidden shadow-[0px_4px_20px_rgba(0,0,0,0.04)] hover:shadow-[0px_8px_30px_rgba(0,0,0,0.08)] hover:-translate-y-0.5 transition-all cursor-pointer flex ${card.type === 'featured' ? 'flex-col md:flex-row' : 'flex-col'} group`}
            >
              {card.type === 'featured' ? (
                <>
                  <div className="md:w-1/2 bg-[#eae7e7] flex items-center justify-center min-h-[200px]">
                    <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform" style={{ fontSize: '100px' }}>history_edu</span>
                  </div>
                  <div className="md:w-1/2 p-8 flex flex-col justify-center">
                    <span className="text-[#8B1A1A] text-xs font-semibold mb-2 tracking-wider uppercase">{card.category}</span>
                    <h3 className="text-2xl font-bold mb-4 text-[#1c1b1b]">{card.title}</h3>
                    <p className="text-base text-[#5d5f5d] mb-6" style={{ fontFamily: 'Merriweather, serif' }}>{card.desc}</p>
                    <div className="flex items-center gap-2">
                      <span className="material-symbols-outlined text-[#8B1A1A] text-[18px]">schedule</span>
                      <span className="text-xs text-[#5d5f5d]">{card.meta}</span>
                    </div>
                  </div>
                </>
              ) : card.type === 'archive' ? (
                <>
                  <div className="h-48 bg-[#8B1A1A] flex items-center justify-center">
                    <span className="material-symbols-outlined text-white" style={{ fontSize: '60px' }}>history_edu</span>
                  </div>
                  <div className="p-4 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2">
                      <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs">{card.category}</span>
                      <span className="text-[#5d5f5d] text-xs">{card.meta}</span>
                    </div>
                    <h3 className="text-xl font-semibold mb-2 text-[#1c1b1b]">{card.title}</h3>
                    <p className="text-base text-[#5d5f5d] line-clamp-3 flex-grow" style={{ fontFamily: 'Merriweather, serif' }}>{card.desc}</p>
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold flex items-center gap-1">
                      Ver Arquivo <span className="material-symbols-outlined text-[18px]">download</span>
                    </div>
                  </div>
                </>
              ) : card.type === 'video' ? (
                <>
                  <div className="h-48 bg-[#1c1b1b] flex items-center justify-center overflow-hidden relative">
                    <div className="absolute inset-0 bg-gradient-to-br from-[#8B1A1A]/20 to-transparent" />
                    <span className="material-symbols-outlined text-white/20 group-hover:scale-105 transition-transform" style={{ fontSize: '80px', fontVariationSettings: "'FILL' 1" }}>play_circle</span>
                  </div>
                  <div className="p-4 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2">
                      <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs">{card.category}</span>
                      <span className="text-[#5d5f5d] text-xs">{card.meta}</span>
                    </div>
                    <h3 className="text-xl font-semibold mb-2 text-[#1c1b1b]">{card.title}</h3>
                    <p className="text-base text-[#5d5f5d] line-clamp-3 flex-grow" style={{ fontFamily: 'Merriweather, serif' }}>{card.desc}</p>
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold flex items-center gap-1">
                      Ver Aula <span className="material-symbols-outlined text-[18px]">play_arrow</span>
                    </div>
                  </div>
                </>
              ) : (
                <>
                  <div className="h-48 bg-[#eae7e7] flex items-center justify-center overflow-hidden">
                    <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform" style={{ fontSize: '80px' }}>article</span>
                  </div>
                  <div className="p-4 flex flex-col flex-grow">
                    <div className="flex justify-between items-start mb-2">
                      <span className="bg-[#8B1A1A]/10 text-[#8B1A1A] px-3 py-1 rounded-full text-xs">{card.category}</span>
                      <span className="text-[#5d5f5d] text-xs">{card.meta}</span>
                    </div>
                    <h3 className="text-xl font-semibold mb-2 text-[#1c1b1b]">{card.title}</h3>
                    <p className="text-base text-[#5d5f5d] line-clamp-3 flex-grow" style={{ fontFamily: 'Merriweather, serif' }}>{card.desc}</p>
                    <div className="mt-auto pt-4 text-[#8B1A1A] text-sm font-semibold flex items-center gap-1">
                      Ler Agora <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
                    </div>
                  </div>
                </>
              )}
            </article>
          ))}

          {/* Quote card */}
          <article className="col-span-12 md:col-span-4 bg-[#8B1A1A] rounded-xl p-8 flex flex-col justify-center text-white shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
            <span className="material-symbols-outlined text-4xl mb-4" style={{ fontVariationSettings: "'FILL' 1" }}>format_quote</span>
            <blockquote className="text-lg italic mb-6 leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>
              "A economia de amanhã é construída sobre as fundações das lições que decidimos ignorar no passado."
            </blockquote>
            <cite className="text-sm not-italic opacity-80">— Análise Editorial, 2024</cite>
          </article>
        </div>
      </div>
    </AppShell>
  )
}
