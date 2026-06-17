import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const users = [
  { name: 'Carlos Tchípia', email: 'carlos@exemplo.ao', role: 'Investigador Sénior', articles: 28, joined: 'Out 2023', active: true },
  { name: 'Emanuel dos Santos', email: 'emanuel@exemplo.ao', role: 'Investigador', articles: 12, joined: 'Jan 2024', active: true },
  { name: 'Líria Bá', email: 'liria@exemplo.ao', role: 'Investigadora', articles: 8, joined: 'Mar 2024', active: true },
  { name: 'José Tala', email: 'jose@exemplo.ao', role: 'Colaborador', articles: 3, joined: 'Jun 2024', active: false },
  { name: 'Ana Ferreira', email: 'ana@exemplo.ao', role: 'Investigadora', articles: 15, joined: 'Fev 2024', active: true },
]

export default function GestaoUtilizadores() {
  const navigate = useNavigate()

  return (
    <AppShell title="Gestão de Utilizadores" searchPlaceholder="Pesquisar utilizadores...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-1">Utilizadores</h2>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>Gerencie os membros da plataforma.</p>
          </div>
          <div className="flex gap-3">
            <button onClick={() => navigate('/gestao/conteudos')}
              className="flex items-center gap-2 border border-[#e0bfbc] text-[#1c1b1b] px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all">
              <span className="material-symbols-outlined text-[18px]">article</span>
              Conteúdos
            </button>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          {[
            { value: '5', label: 'Total de Membros' },
            { value: '4', label: 'Ativos' },
            { value: '1', label: 'Inativos' },
            { value: '66', label: 'Artigos Totais' },
          ].map((s) => (
            <div key={s.label} className="bg-white rounded-xl p-5 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] text-center">
              <p className="text-[32px] font-extrabold text-[#8B1A1A]">{s.value}</p>
              <p className="text-xs text-[#5d5f5d] uppercase tracking-wider">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Table */}
        <div className="bg-white rounded-xl border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] overflow-hidden">
          <table className="w-full">
            <thead className="bg-[#f6f3f2] border-b border-[#e0bfbc]">
              <tr>
                {['Utilizador', 'Função', 'Artigos', 'Membro desde', 'Estado', 'Ações'].map((h) => (
                  <th key={h} className="text-left px-5 py-3 text-xs font-bold text-[#5d5f5d] uppercase tracking-wider">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-[#e0bfbc]">
              {users.map((u) => (
                <tr key={u.email} className="hover:bg-[#f6f3f2] transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-[#eae7e7] flex items-center justify-center flex-shrink-0">
                        <span className="material-symbols-outlined text-[#5d5f5d] text-sm">person</span>
                      </div>
                      <div>
                        <p className="text-sm font-bold text-[#1c1b1b]">{u.name}</p>
                        <p className="text-xs text-[#5d5f5d]">{u.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-5 py-4">
                    <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full">{u.role}</span>
                  </td>
                  <td className="px-5 py-4 text-sm font-semibold text-[#1c1b1b]">{u.articles}</td>
                  <td className="px-5 py-4 text-xs text-[#5d5f5d]">{u.joined}</td>
                  <td className="px-5 py-4">
                    <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${u.active ? 'bg-green-100 text-green-800' : 'bg-[#eae7e7] text-[#5d5f5d]'}`}>
                      {u.active ? 'Ativo' : 'Inativo'}
                    </span>
                  </td>
                  <td className="px-5 py-4">
                    <button onClick={() => navigate('/perfil')}
                      className="p-1.5 rounded hover:bg-[#eae7e7] transition-colors text-[#5d5f5d] hover:text-[#8B1A1A]">
                      <span className="material-symbols-outlined text-[16px]">visibility</span>
                    </button>
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
