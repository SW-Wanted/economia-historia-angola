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
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2">Glossário Económico</h2>
          <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
            Termos e conceitos essenciais da história económica de Angola.
          </p>
        </div>

        {/* Search */}
        <div className="relative mb-6">
          <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-[#5d5f5d]">search</span>
          <input type="text" value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Pesquisar no glossário..."
            className="w-full pl-12 pr-4 py-3 bg-white border border-[#e0bfbc] rounded-xl focus:ring-1 focus:ring-[#8B1A1A] outline-none text-base"
            style={{ fontFamily: 'Merriweather, serif' }} />
        </div>

        {/* Alphabet */}
        <div className="flex flex-wrap gap-1 mb-8">
          <button onClick={() => setActiveLetter(null)}
            className={`w-8 h-8 rounded text-xs font-bold transition-colors ${!activeLetter ? 'bg-[#8B1A1A] text-white' : 'bg-white border border-[#e0bfbc] text-[#5d5f5d] hover:border-[#8B1A1A]'}`}>
            Todos
          </button>
          {letters.map((l) => (
            <button key={l} onClick={() => setActiveLetter(activeLetter === l ? null : l)}
              className={`w-8 h-8 rounded text-xs font-bold transition-colors ${activeLetter === l ? 'bg-[#8B1A1A] text-white' : 'bg-white border border-[#e0bfbc] text-[#5d5f5d] hover:border-[#8B1A1A]'}`}>
              {l}
            </button>
          ))}
        </div>

        {/* Terms */}
        <div className="flex flex-col gap-3">
          {filtered.map((item) => (
            <div key={item.term} className="bg-white rounded-xl border border-[#e0bfbc] overflow-hidden shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
              <button onClick={() => setExpanded(expanded === item.term ? null : item.term)}
                className="w-full flex items-center justify-between p-5 text-left hover:bg-[#f6f3f2] transition-colors">
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 bg-[#8B1A1A] rounded-lg flex items-center justify-center text-white font-bold text-lg">
                    {item.term[0]}
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-[#1c1b1b]">{item.term}</h3>
                    <span className="text-xs text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full font-semibold">{item.category}</span>
                  </div>
                </div>
                <span className={`material-symbols-outlined text-[#5d5f5d] transition-transform ${expanded === item.term ? 'rotate-180' : ''}`}>expand_more</span>
              </button>
              {expanded === item.term && (
                <div className="px-5 pb-5">
                  <p className="text-base text-[#5d5f5d] leading-relaxed" style={{ fontFamily: 'Merriweather, serif' }}>{item.def}</p>
                  <div className="flex gap-3 mt-4">
                    <button onClick={() => navigate('/leitura/microtexto')}
                      className="text-xs font-semibold text-[#8B1A1A] hover:underline flex items-center gap-1">
                      <span className="material-symbols-outlined text-[14px]">article</span>
                      Ver artigos relacionados
                    </button>
                    <button onClick={() => navigate('/forum')}
                      className="text-xs font-semibold text-[#5d5f5d] hover:text-[#8B1A1A] flex items-center gap-1">
                      <span className="material-symbols-outlined text-[14px]">forum</span>
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
