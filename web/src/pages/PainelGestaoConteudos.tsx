import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const articles = [
  { title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', type: 'Microtexto', status: 'Publicado', date: '12 Jan 2026', views: 1240 },
  { title: 'A Geopolítica do Diamante na Lunda Norte', type: 'Jindungo', status: 'Publicado', date: '8 Jan 2026', views: 890 },
  { title: 'Tratado de Comércio de 1891', type: 'Arquivo', status: 'Publicado', date: '3 Jan 2026', views: 456 },
  { title: 'O Ciclo do Café e a Transformação do Planalto Central', type: 'Microtexto', status: 'Em Revisão', date: '15 Jan 2026', views: 0 },
  { title: 'Estabilidade Cambial e o Passado', type: 'Microtexto', status: 'Rascunho', date: '16 Jan 2026', views: 0 },
]

const statusColor: Record<string, string> = {
  'Publicado': 'bg-green-100 text-green-800',
  'Em Revisão': 'bg-amber-100 text-amber-800',
  'Rascunho': 'bg-[#eae7e7] text-[#5d5f5d]',
}

export default function PainelGestaoConteudos() {
  const navigate = useNavigate()
  const [filter, setFilter] = useState('Todos')

  const filtered = filter === 'Todos' ? articles : articles.filter((a) => a.status === filter)

  return (
    <AppShell title="Gestão de Conteúdos" searchPlaceholder="Pesquisar artigos...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-1">Gestão de Conteúdos</h2>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>Gerencie todos os artigos e documentos da plataforma.</p>
          </div>
          <div className="flex gap-3">
            <button onClick={() => navigate('/gestao/utilizadores')}
              className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
              <span className="material-symbols-outlined text-[18px]">group</span>
              Utilizadores
            </button>
            <button onClick={() => navigate('/gestao/submeter-artigo')}
              className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold hover:opacity-90 transition-all shadow-sm">
              <span className="material-symbols-outlined">add</span>
              Novo Artigo
            </button>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          {[
            { value: '3', label: 'Publicados', color: 'text-green-600' },
            { value: '1', label: 'Em Revisão', color: 'text-amber-600' },
            { value: '1', label: 'Rascunhos', color: 'text-[#5d5f5d]' },
            { value: '2,586', label: 'Total de Visualizações', color: 'text-[#8B1A1A]' },
          ].map((s) => (
            <div key={s.label} className="bg-white rounded-xl p-5 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] text-center">
              <p className={`text-[32px] font-extrabold ${s.color}`}>{s.value}</p>
              <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Filter */}
        <div className="flex gap-2 mb-6">
          {['Todos', 'Publicado', 'Em Revisão', 'Rascunho'].map((f) => (
            <button key={f} onClick={() => setFilter(f)}
              className={`px-4 py-2 rounded-full text-xs font-semibold transition-colors ${filter === f ? 'bg-[#8B1A1A] text-white' : 'bg-white border border-[#e0bfbc] text-[#5d5f5d] hover:border-[#8B1A1A]'}`}>
              {f}
            </button>
          ))}
        </div>

        {/* Table */}
        <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] overflow-hidden">
          <table className="w-full">
            <thead className="bg-[#f6f3f2] border-b border-[#e0bfbc]">
              <tr>
                {['Título', 'Tipo', 'Estado', 'Data', 'Visualizações', 'Ações'].map((h) => (
                  <th key={h} className="text-left px-5 py-3 text-xs font-bold text-[#5d5f5d] uppercase tracking-wider">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e0bfbc]">
              {filtered.map((a) => (
                <tr key={a.title} className="hover:bg-[#f6f3f2] transition-colors">
                  <td className="px-5 py-4">
                    <button onClick={() => navigate('/leitura/microtexto')}
                      className="text-sm font-semibold text-[#1c1b1b] hover:text-[#8B1A1A] transition-colors text-left line-clamp-1 max-w-[300px]">
                      {a.title}
                    </button>
                  </td>
                  <td className="px-5 py-4">
                    <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full">{a.type}</span>
                  </td>
                  <td className="px-5 py-4">
                    <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${statusColor[a.status]}`}>{a.status}</span>
                  </td>
                  <td className="px-5 py-4 text-xs text-[#5d5f5d]">{a.date}</td>
                  <td className="px-5 py-4 text-sm font-semibold text-[#1c1b1b]">{a.views.toLocaleString()}</td>
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-2">
                      <button onClick={() => navigate('/leitura/microtexto')}
                        className="p-1.5 rounded hover:bg-[#eae7e7] transition-colors text-[#5d5f5d] hover:text-[#8B1A1A]">
                        <span className="material-symbols-outlined text-[16px]">visibility</span>
                      </button>
                      <button className="p-1.5 rounded hover:bg-[#eae7e7] transition-colors text-[#5d5f5d] hover:text-[#8B1A1A]">
                        <span className="material-symbols-outlined text-[16px]">edit</span>
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </AppShell>
  )
}
