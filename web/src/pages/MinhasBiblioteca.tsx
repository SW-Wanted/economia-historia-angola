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
      <div className="px-10 py-10 max-w-[1160px] mx-auto">
        <div className="mb-8">
          <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-2 font-sans tracking-tight">Minha Biblioteca</h2>
          <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
            Todos os seus conteúdos guardados e em progresso.
          </p>
        </div>

        {/* Tabs */}
        <div className="border-b border-[#ebe5e4] mb-8">
          <div className="flex gap-6">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3.5 text-sm font-semibold font-sans transition-all duration-150 border-b-2 -mb-px ${
                  activeTab === tab ? 'border-[#8B1A1A] text-[#8B1A1A]' : 'border-transparent text-[#5d5f5d] hover:text-[#1c1b1b]'
                }`}
              >
                {tab}
              </button>
            ))}
          </div>
        </div>

        {/* Grid */}
        {filtered.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            {filtered.map((item) => (
              <div
                key={item.title}
                onClick={() => navigate(item.route)}
                className="bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer group"
              >
                <div className="h-36 bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center">
                  <span className="material-symbols-outlined text-[#8B1A1A]/20 group-hover:scale-105 transition-transform duration-300" style={{ fontSize: '56px' }}>
                    {item.category === 'Arquivo' ? 'description' : item.category === 'Jindungo' ? 'nutrition' : 'article'}
                  </span>
                </div>
                <div className="p-4 space-y-2">
                  <span className="bg-[#fff5f4] text-[#8B1A1A] px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">{item.category}</span>
                  <h4 className="text-sm font-semibold text-[#1c1b1b] line-clamp-2 font-sans leading-snug">{item.title}</h4>
                  <div className="w-full bg-[#f0eded] h-1.5 rounded-full overflow-hidden">
                    <div className="bg-[#8B1A1A] h-full transition-all" style={{ width: `${item.progress}%` }} />
                  </div>
                  <div className="flex justify-between items-center text-xs text-[#8c716e] font-sans">
                    <span>{item.progress}% Concluído</span>
                    <span>{item.time}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="bg-white rounded-xl border border-[#ebe5e4] shadow-card p-12 text-center">
            <span className="material-symbols-outlined text-[#8B1A1A]/15 mb-4 block" style={{ fontSize: '64px' }}>library_books</span>
            <p className="text-lg font-bold text-[#1c1b1b] mb-1 font-sans">Nenhum item aqui</p>
            <p className="text-sm text-[#5d5f5d] font-serif mb-6">Explore o arquivo e começa a ler.</p>
            <button
              onClick={() => navigate('/explorar')}
              className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold font-sans hover:bg-[#7a1616] active:scale-[0.98] transition-all duration-150"
            >
              Explorar Conteúdos
            </button>
          </div>
        )}
      </div>
    </AppShell>
  )
}
