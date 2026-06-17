import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const filters = ['Todos os Tópicos', 'Microtextos', 'Economia Colonial', 'Pós-Independência', 'Arquivos Históricos']

const topics = [
  { id: 1, author: 'Emanuel dos Santos', category: 'Microtextos', time: 'Há 2 horas', title: 'O impacto da moeda Kwanza na transição econômica de 1977', excerpt: 'Uma análise profunda sobre a substituição do Escudo pelo Kwanza e como isso moldou as primeiras relações comerciais internacionais da Angola independente.', replies: 24, views: '1.2k' },
  { id: 2, author: 'José Tala', category: 'Arquivo', time: 'Há 5 horas', title: 'Registos inéditos da Companhia de Diamantes de Angola (DIAMANG)', excerpt: 'Descobri recentemente uma série de documentos contabilisticos de 1950 que detalham a infraestrutura logística no Nordeste de Angola.', replies: 12, views: '850' },
  { id: 3, author: 'Líria Bá', category: 'Jindungo', time: 'Há 1 dia', title: 'A evolução dos mercados informais: De Roque Santeiro ao presente', excerpt: 'Como a resiliência do comércio informal em Luanda reflete as falhas e sucessos das políticas fiscais ao longo das décadas.', replies: 45, views: '2.5k' },
  { id: 4, author: 'Ana Ferreira', category: 'Economia Colonial', time: 'Há 2 dias', title: 'O impacto da reabilitação do Caminho de Ferro de Benguela', excerpt: 'Análise comparativa entre o período colonial e os projetos de reabilitação contemporâneos, com foco no impacto económico regional.', replies: 45, views: '3.1k' },
  { id: 5, author: 'Pedro Neto', category: 'Pós-Independência', time: 'Há 3 dias', title: 'Cotas de exportação de petróleo: Lições dos anos 80', excerpt: 'Como as políticas de exportação petrolífera dos anos 80 moldaram a estrutura económica que temos hoje.', replies: 23, views: '1.8k' },
]

export default function Forum() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('Todos os Tópicos')

  return (
    <AppShell title="Fórum de Discussão" searchPlaceholder="Pesquisar tópicos ou autores...">
      <div className="px-10 py-16 max-w-[1160px] mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[48px] font-extrabold text-[#8B1A1A] leading-tight">Comunidade</h2>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>Debate, partilha e aprende com outros investigadores.</p>
          </div>
          <button
            onClick={() => navigate('/forum/novo-topico')}
            className="bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold flex items-center gap-2 hover:opacity-90 active:scale-95 transition-all shadow-sm"
          >
            <span className="material-symbols-outlined">add</span>
            Novo Tópico
          </button>
        </div>

        {/* Filters */}
        <div className="flex gap-2 overflow-x-auto pb-2">
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-colors ${
                activeFilter === f
                  ? 'bg-[#8B1A1A] text-white'
                  : 'bg-white border border-[#e0bfbc] text-[#5d5f5d] hover:border-[#8B1A1A] hover:text-[#8B1A1A]'
              }`}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Topics */}
        <div className="flex flex-col gap-6 mt-4">
          {topics.map((topic) => (
            <div
              key={topic.id}
              onClick={() => navigate('/forum/detalhe')}
              className="bg-white p-4 rounded-xl border border-[#e0bfbc] hover:shadow-lg transition-all flex flex-col md:flex-row gap-6 items-start group cursor-pointer"
            >
              <div className="flex-shrink-0 w-12 h-12 rounded-lg bg-[#eae7e7] flex items-center justify-center">
                <span className="material-symbols-outlined text-[#8B1A1A]">person</span>
              </div>
              <div className="flex-grow space-y-2">
                <div className="flex items-center gap-3">
                  <span className="px-2 py-0.5 bg-[#8B1A1A]/10 text-[#8B1A1A] rounded text-[10px] font-bold uppercase tracking-wider">{topic.category}</span>
                  <span className="text-[#5d5f5d] text-xs">{topic.time}</span>
                </div>
                <h3 className="text-xl font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors">{topic.title}</h3>
                <p className="text-[#5d5f5d] text-base line-clamp-2" style={{ fontFamily: 'Merriweather, serif' }}>{topic.excerpt}</p>
                <div className="pt-2 flex items-center gap-4 text-[#5d5f5d]">
                  <span className="text-sm font-semibold text-[#1c1b1b]">{topic.author}</span>
                  <div className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-sm">forum</span>
                    <span className="text-xs">{topic.replies} respostas</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-sm">visibility</span>
                    <span className="text-xs">{topic.views} visualizações</span>
                  </div>
                </div>
              </div>
              <button className="self-center p-2 rounded-full hover:bg-[#f0eded] transition-colors">
                <span className="material-symbols-outlined text-[#5d5f5d]">chevron_right</span>
              </button>
            </div>
          ))}
        </div>

        {/* Pagination */}
        <div className="flex justify-center items-center gap-2 pt-8">
          <button className="w-10 h-10 flex items-center justify-center rounded-lg border border-[#e0bfbc] bg-white text-[#5d5f5d] hover:bg-[#f0eded] transition-colors">
            <span className="material-symbols-outlined">chevron_left</span>
          </button>
          {[1, 2, 3].map((p) => (
            <button key={p} className={`w-10 h-10 flex items-center justify-center rounded-lg font-bold text-sm ${p === 1 ? 'bg-[#8B1A1A] text-white' : 'border border-[#e0bfbc] bg-white text-[#5d5f5d] hover:bg-[#f0eded]'}`}>{p}</button>
          ))}
          <span className="text-[#5d5f5d] px-2">...</span>
          <button className="w-10 h-10 flex items-center justify-center rounded-lg border border-[#e0bfbc] bg-white text-[#5d5f5d] hover:bg-[#f0eded] transition-colors">
            <span className="material-symbols-outlined">chevron_right</span>
          </button>
        </div>
      </div>
    </AppShell>
  )
}
