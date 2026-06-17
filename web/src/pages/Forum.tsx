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
      <div className="px-10 py-14 max-w-[1160px] mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[44px] font-extrabold text-[#8B1A1A] leading-tight tracking-tight font-sans">Comunidade</h2>
            <p className="text-sm text-[#5d5f5d] mt-1 font-serif">Debate, partilha e aprende com outros investigadores.</p>
          </div>
          <button
            onClick={() => navigate('/forum/novo-topico')}
            className="bg-[#8B1A1A] text-white px-5 py-2.5 rounded-full text-sm font-semibold flex items-center gap-2 hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 font-sans"
          >
            <span className="material-symbols-outlined text-[18px]">add</span>
            Novo Tópico
          </button>
        </div>

        {/* Filters */}
        <div className="flex gap-2 overflow-x-auto pb-1">
          {filters.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all duration-150 font-sans ${
                activeFilter === f
                  ? 'bg-[#8B1A1A] text-white shadow-xs'
                  : 'bg-white border border-[#e8e0de] text-[#5d5f5d] hover:border-[#8B1A1A]/40 hover:text-[#8B1A1A]'
              }`}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Topics */}
        <div className="flex flex-col gap-3 mt-2">
          {topics.map((topic) => (
            <div
              key={topic.id}
              onClick={() => navigate('/forum/detalhe')}
              className="bg-white px-5 py-4 rounded-xl border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 flex flex-col md:flex-row gap-4 items-start group cursor-pointer"
            >
              <div className="flex-shrink-0 w-10 h-10 rounded-lg bg-gradient-to-br from-[#f0eded] to-[#e8e0de] flex items-center justify-center">
                <span className="text-xs font-bold text-[#8B1A1A] font-sans leading-none">
                  {topic.author.split(' ').map(n => n[0]).slice(0, 2).join('')}
                </span>
              </div>
              <div className="flex-grow space-y-1.5 min-w-0">
                <div className="flex items-center gap-2.5 flex-wrap">
                  <span className="px-2 py-0.5 bg-[#fff5f4] text-[#8B1A1A] rounded text-[10px] font-bold uppercase tracking-[0.06em] font-sans">{topic.category}</span>
                  <span className="text-[#b8a5a3] text-xs">{topic.time}</span>
                </div>
                <h3 className="text-base font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors duration-150 leading-snug font-sans">{topic.title}</h3>
                <p className="text-sm text-[#5d5f5d] line-clamp-2 font-serif leading-relaxed">{topic.excerpt}</p>
                <div className="pt-1 flex items-center gap-4 text-[#8c716e] flex-wrap">
                  <span className="text-sm font-semibold text-[#1c1b1b] font-sans">{topic.author}</span>
                  <div className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-[15px]">forum</span>
                    <span className="text-xs">{topic.replies} respostas</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <span className="material-symbols-outlined text-[15px]">visibility</span>
                    <span className="text-xs">{topic.views} visualizações</span>
                  </div>
                </div>
              </div>
              <div className="self-center p-1.5 rounded-full text-[#c4b5b3] group-hover:text-[#8B1A1A] group-hover:bg-[#fff5f4] transition-all duration-150 flex-shrink-0">
                <span className="material-symbols-outlined text-[20px]">chevron_right</span>
              </div>
            </div>
          ))}
        </div>

        {/* Pagination */}
        <div className="flex justify-center items-center gap-1.5 pt-6">
          <button className="w-9 h-9 flex items-center justify-center rounded-lg border border-[#e8e0de] bg-white text-[#5d5f5d] hover:bg-[#f0eded] hover:border-[#d4c5c3] transition-all duration-150">
            <span className="material-symbols-outlined text-[18px]">chevron_left</span>
          </button>
          {[1, 2, 3].map((p) => (
            <button
              key={p}
              className={`w-9 h-9 flex items-center justify-center rounded-lg font-bold text-sm font-sans transition-all duration-150 ${
                p === 1
                  ? 'bg-[#8B1A1A] text-white shadow-xs'
                  : 'border border-[#e8e0de] bg-white text-[#5d5f5d] hover:bg-[#f0eded]'
              }`}
            >
              {p}
            </button>
          ))}
          <span className="text-[#c4b5b3] px-1 text-sm">···</span>
          <button className="w-9 h-9 flex items-center justify-center rounded-lg border border-[#e8e0de] bg-white text-[#5d5f5d] hover:bg-[#f0eded] hover:border-[#d4c5c3] transition-all duration-150">
            <span className="material-symbols-outlined text-[18px]">chevron_right</span>
          </button>
        </div>
      </div>
    </AppShell>
  )
}
