import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const articles = [
  { category: 'Microtexto', title: 'O Porto de Luanda e o Comércio Atlântico', time: '6 min' },
  { category: 'Arquivo', title: 'Registos Alfandegários de Luanda (1890–1920)', time: 'Documento' },
  { category: 'Jindungo', title: 'A Economia Informal de Luanda: Roque Santeiro', time: '15 min' },
  { category: 'Microtexto', title: 'Industrialização de Luanda no Período Colonial', time: '8 min' },
]

export default function ConteudosProvincia() {
  const navigate = useNavigate()

  return (
    <AppShell title="Luanda" searchPlaceholder="Pesquisar em Luanda...">
      <div className="px-10 py-16 max-w-[1160px] mx-auto">
        <button
          onClick={() => navigate('/mapa')}
          className="flex items-center gap-2 text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors mb-8 text-sm font-semibold"
        >
          <span className="material-symbols-outlined text-[18px]">arrow_back</span>
          Voltar ao Mapa
        </button>

        <div className="flex items-center gap-4 mb-8">
          <div className="w-16 h-16 bg-[#8B1A1A] rounded-xl flex items-center justify-center">
            <span className="material-symbols-outlined text-white text-3xl">location_on</span>
          </div>
          <div>
            <h1 className="text-[40px] font-extrabold text-[#1c1b1b]">Luanda</h1>
            <p className="text-base text-[#5d5f5d]">Capital económica e histórica de Angola</p>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-4 mb-12">
          {[
            { value: '24', label: 'Artigos' },
            { value: '8', label: 'Documentos de Arquivo' },
            { value: '3', label: 'Textos Jindungo' },
          ].map((s) => (
            <div key={s.label} className="bg-white rounded-xl p-6 border border-[#e0bfbc] text-center shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
              <p className="text-[40px] font-extrabold text-[#8B1A1A]">{s.value}</p>
              <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Articles */}
        <h2 className="text-2xl font-bold text-[#1c1b1b] mb-6">Conteúdos sobre Luanda</h2>
        <div className="flex flex-col gap-4">
          {articles.map((a) => (
            <div
              key={a.title}
              onClick={() => navigate('/leitura/microtexto')}
              className="bg-white rounded-xl p-6 border border-[#e0bfbc] hover:border-[#8B1A1A] hover:shadow-md transition-all cursor-pointer flex items-center gap-6 group"
            >
              <div className="w-12 h-12 bg-[#eae7e7] rounded-lg flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined text-[#8B1A1A]">article</span>
              </div>
              <div className="flex-grow">
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full">{a.category}</span>
                  <span className="text-xs text-[#5d5f5d]">{a.time}</span>
                </div>
                <h3 className="text-xl font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors">{a.title}</h3>
              </div>
              <span className="material-symbols-outlined text-[#5d5f5d] group-hover:text-[#8B1A1A] transition-colors">chevron_right</span>
            </div>
          ))}
        </div>
      </div>
    </AppShell>
  )
}
