import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const tabs = ['Em Leitura', 'Concluídos', 'Guardados', 'Descarregados']

const items = [
  { category: 'Microtextos', title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', progress: 60, time: '8 min restantes', route: '/leitura/microtexto' },
  { category: 'Arquivo', title: 'Tratados de Comércio no Reino do Kongo (1845)', progress: 30, time: '45 min restantes', route: '/documento/detalhe' },
  { category: 'Jindungo', title: 'A Geopolítica do Diamante na Lunda Norte', progress: 100, time: 'Concluído', route: '/leitura/jindungo' },
  { category: 'Microtextos', title: 'O Ciclo do Café e a Transformação do Planalto Central', progress: 60, time: '12 min restantes', route: '/leitura/microtexto' },
  { category: 'Microtextos', title: 'Estabilidade Cambial e o Passado', progress: 15, time: '20 min restantes', route: '/leitura/microtexto' },
  { category: 'Arquivo', title: 'Tratado de Comércio de 1891', progress: 100, time: 'Concluído', route: '/documento/detalhe' },
]

export default function MinhasBiblioteca() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('Em Leitura')

  const filtered = activeTab === 'Concluídos'
    ? items.filter((i) => i.progress === 100)
    : activeTab === 'Em Leitura'
    ? items.filter((i) => i.progress < 100)
    : items

  return (
    <AppShell title="Minha Biblioteca" searchPlaceholder="Pesquisar na biblioteca...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2">Minha Biblioteca</h2>
          <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
            Todos os seus conteúdos guardados e em progresso.
          </p>
        </div>

        {/* Tabs */}
        <div className="border-b border-[#e0bfbc] mb-8">
          <div className="flex gap-8">
            {tabs.map((tab) => (
              <button key={tab} onClick={() => setActiveTab(tab)}
                className={`pb-4 text-sm font-semibold transition-colors border-b-2 -mb-px ${
                  activeTab === tab ? 'border-[#8B1A1A] text-[#8B1A1A]' : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}>
                {tab}
              </button>
            ))}
          </div>
        </div>

        {/* Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filtered.map((item) => (
            <div key={item.title} onClick={() => navigate(item.route)}
              className="bg-white rounded-xl overflow-hidden border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] hover:-translate-y-1 transition-transform cursor-pointer group">
              <div className="h-40 bg-[#eae7e7] flex items-center justify-center">
                <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform" style={{ fontSize: '80px' }}>
                  {item.category === 'Arquivo' ? 'description' : item.category === 'Jindungo' ? 'nutrition' : 'article'}
                </span>
              </div>
              <div className="p-4 space-y-2">
                <span className="bg-[#f0eded] text-[#5d5f5d] px-2 py-0.5 rounded text-xs font-semibold uppercase tracking-wider">{item.category}</span>
                <h4 className="text-base font-semibold text-[#1c1b1b] line-clamp-2">{item.title}</h4>
                <div className="w-full bg-[#eae7e7] h-1.5 rounded-full overflow-hidden">
                  <div className="bg-[#8B1A1A] h-full transition-all" style={{ width: `${item.progress}%` }} />
                </div>
                <div className="flex justify-between items-center text-xs text-[#5d5f5d]">
                  <span>{item.progress}% Concluído</span>
                  <span>{item.time}</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {filtered.length === 0 && (
          <div className="text-center py-20">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 mb-4" style={{ fontSize: '80px' }}>library_books</span>
            <p className="text-xl font-bold text-[#1c1b1b] mb-2">Nenhum item aqui</p>
            <button onClick={() => navigate('/explorar')}
              className="mt-4 bg-[#8B1A1A] text-white px-8 py-3 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
              Explorar Conteúdos
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
