import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const results = [
  { type: 'Microtexto', title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', excerpt: 'A história dos diamantes em Angola é inseparável da história da própria nação...', route: '/leitura/microtexto' },
  { type: 'Jindungo', title: 'A Geopolítica do Diamante na Lunda Norte', excerpt: 'A região da Lunda Norte encerra em si mesma uma das mais complexas narrativas...', route: '/leitura/jindungo' },
  { type: 'Arquivo', title: 'Tratado de Comércio de 1891', excerpt: 'Documento original que redefiniu as taxas alfandegárias de Luanda...', route: '/documento/detalhe' },
  { type: 'Fórum', title: 'O impacto da moeda Kwanza na transição econômica de 1977', excerpt: 'Uma análise profunda sobre a substituição do Escudo pelo Kwanza...', route: '/forum/detalhe' },
  { type: 'Glossário', title: 'Zimbo — Moeda de troca pré-colonial', excerpt: 'Moeda de troca utilizada no Reino do Kongo, constituída por conchas...', route: '/glossario' },
]

export default function ResultadosPesquisa() {
  const navigate = useNavigate()

  return (
    <AppShell title="Resultados da Pesquisa" searchPlaceholder="Pesquisar arquivo...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[32px] font-bold text-[#1c1b1b] mb-1">Resultados para "diamante"</h2>
          <p className="text-base text-[#5d5f5d]">{results.length} resultados encontrados</p>
        </div>

        {/* Filter chips */}
        <div className="flex gap-2 mb-8">
          {['Todos', 'Microtextos', 'Jindungo', 'Arquivo', 'Fórum', 'Glossário'].map((f, i) => (
            <button key={f}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold transition-colors ${i === 0 ? 'bg-[#8B1A1A] text-white' : 'bg-white border border-[#e0bfbc] text-[#5d5f5d] hover:border-[#8B1A1A]'}`}>
              {f}
            </button>
          ))}
        </div>

        <div className="flex flex-col gap-4">
          {results.map((r) => (
            <div key={r.title} onClick={() => navigate(r.route)}
              className="bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer group flex items-start gap-5">
              <div className="w-12 h-12 bg-[#eae7e7] rounded-lg flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined text-[#8B1A1A]">
                  {r.type === 'Arquivo' ? 'description' : r.type === 'Jindungo' ? 'nutrition' : r.type === 'Fórum' ? 'forum' : r.type === 'Glossário' ? 'menu_book' : 'article'}
                </span>
              </div>
              <div className="flex-grow">
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full">{r.type}</span>
                </div>
                <h3 className="text-xl font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors mb-1">{r.title}</h3>
                <p className="text-sm text-[#5d5f5d] line-clamp-2" style={{ fontFamily: 'Merriweather, serif' }}>{r.excerpt}</p>
              </div>
              <span className="material-symbols-outlined text-[#5d5f5d] group-hover:text-[#8B1A1A] transition-colors flex-shrink-0">chevron_right</span>
            </div>
          ))}
        </div>
      </div>
    </AppShell>
  )
}
