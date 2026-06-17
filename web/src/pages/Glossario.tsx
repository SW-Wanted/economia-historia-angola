import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const terms = [
  { term: 'Zimbo', category: 'Moeda', def: 'Moeda de troca utilizada no Reino do Kongo, constituída por conchas de ciprea moneta. Foi amplamente utilizada no comércio pré-colonial e colonial em Angola.' },
  { term: 'DIAMANG', category: 'Empresa', def: 'Companhia de Diamantes de Angola, fundada em 1917. Controlou a extração de diamantes em Angola durante o período colonial.' },
  { term: 'Kwanza', category: 'Moeda', def: 'Moeda nacional de Angola, introduzida em 1977 após a independência, em substituição do Escudo português.' },
  { term: 'ENDIAMA', category: 'Empresa', def: 'Empresa Nacional de Diamantes de Angola, criada após a independência para gerir os recursos diamantíferos do país.' },
  { term: 'Planalto Central', category: 'Geografia', def: 'Região central de Angola, historicamente importante para a produção de café e outros produtos agrícolas.' },
  { term: 'CFB', category: 'Infraestrutura', def: 'Caminho de Ferro de Benguela, linha ferroviária que ligava o porto de Benguela ao interior de Angola e ao Congo.' },
]

const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')

export default function Glossario() {
  const navigate = useNavigate()
  const [search, setSearch] = useState('')
  const [activeLetter, setActiveLetter] = useState<string | null>(null)
  const [expanded, setExpanded] = useState<string | null>('Zimbo')

  const filtered = terms.filter((t) => {
    const matchSearch = t.term.toLowerCase().includes(search.toLowerCase())
    const matchLetter = !activeLetter || t.term.startsWith(activeLetter)
    return matchSearch && matchLetter
  })

  return (
    <AppShell title="Glossário" searchPlaceholder="Pesquisar termos...">
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2 font-sans tracking-tight">Glossário Económico</h2>
          <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
            Termos e conceitos essenciais da história económica de Angola.
          </p>
        </div>

        {/* Search */}
        <div className="relative mb-5">
          <span className="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-[#b8a5a3] text-[18px] pointer-events-none">search</span>
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Pesquisar no glossário..."
            className="w-full pl-10 pr-4 py-2.5 bg-[#f0eded] border border-transparent rounded-lg focus:bg-white focus:border-[#e0bfbc] focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 text-sm font-serif placeholder:text-[#c4b5b3]"
          />
        </div>

        {/* Alphabet */}
        <div className="flex flex-wrap gap-1 mb-8">
          <button
            onClick={() => setActiveLetter(null)}
            className={`px-2.5 h-8 rounded text-xs font-bold font-sans transition-all duration-150 ${!activeLetter ? 'bg-[#8B1A1A] text-white shadow-xs' : 'bg-white border border-[#ebe5e4] text-[#5d5f5d] hover:border-[#8B1A1A]/40 hover:text-[#8B1A1A]'}`}
          >
            Todos
          </button>
          {letters.map((l) => (
            <button
              key={l}
              onClick={() => setActiveLetter(activeLetter === l ? null : l)}
              className={`w-8 h-8 rounded text-xs font-bold font-sans transition-all duration-150 ${activeLetter === l ? 'bg-[#8B1A1A] text-white shadow-xs' : 'bg-white border border-[#ebe5e4] text-[#5d5f5d] hover:border-[#8B1A1A]/40 hover:text-[#8B1A1A]'}`}
            >
              {l}
            </button>
          ))}
        </div>

        {/* Terms */}
        <div className="flex flex-col gap-2.5">
          {filtered.map((item) => (
            <div key={item.term} className="bg-white rounded-xl border border-[#ebe5e4] overflow-hidden shadow-card">
              <button
                onClick={() => setExpanded(expanded === item.term ? null : item.term)}
                className="w-full flex items-center justify-between p-5 text-left hover:bg-[#f8f5f4] transition-colors duration-150"
              >
                <div className="flex items-center gap-4">
                  <div className="w-9 h-9 bg-[#8B1A1A] rounded-lg flex items-center justify-center text-white font-bold text-base font-sans flex-shrink-0">
                    {item.term[0]}
                  </div>
                  <div>
                    <h3 className="text-base font-bold text-[#1c1b1b] font-sans">{item.term}</h3>
                    <span className="text-[10px] text-[#8B1A1A] bg-[#fff5f4] px-2 py-0.5 rounded-full font-semibold font-sans">{item.category}</span>
                  </div>
                </div>
                <span className={`material-symbols-outlined text-[#b8a5a3] text-[20px] transition-transform duration-200 flex-shrink-0 ${expanded === item.term ? 'rotate-180' : ''}`}>expand_more</span>
              </button>
              {expanded === item.term && (
                <div className="px-5 pb-5 border-t border-[#f0eded]">
                  <p className="text-sm text-[#5d5f5d] leading-relaxed font-serif pt-4">{item.def}</p>
                  <div className="flex gap-4 mt-4">
                    <button
                      onClick={() => navigate('/leitura/microtexto')}
                      className="text-xs font-semibold text-[#8B1A1A] hover:underline flex items-center gap-1 font-sans transition-colors duration-150"
                    >
                      <span className="material-symbols-outlined text-[13px]">article</span>
                      Ver artigos relacionados
                    </button>
                    <button
                      onClick={() => navigate('/forum')}
                      className="text-xs font-semibold text-[#5d5f5d] hover:text-[#8B1A1A] flex items-center gap-1 font-sans transition-colors duration-150"
                    >
                      <span className="material-symbols-outlined text-[13px]">forum</span>
                      Discutir no fórum
                    </button>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </AppShell>
  )
}
