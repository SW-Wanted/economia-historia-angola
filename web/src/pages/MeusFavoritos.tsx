import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const favorites = [
  { category: 'Microtexto', title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', date: 'Guardado há 2 dias', route: '/leitura/microtexto' },
  { category: 'Jindungo', title: 'A Geopolítica do Diamante na Lunda Norte', date: 'Guardado há 1 semana', route: '/leitura/jindungo' },
  { category: 'Arquivo', title: 'Tratado de Comércio de 1891', date: 'Guardado há 2 semanas', route: '/documento/detalhe' },
  { category: 'Microtexto', title: 'O Ciclo do Café e a Transformação do Planalto Central', date: 'Guardado há 1 mês', route: '/leitura/microtexto' },
  { category: 'Fórum', title: 'O impacto da moeda Kwanza na transição econômica de 1977', date: 'Guardado há 1 mês', route: '/forum/detalhe' },
]

export default function MeusFavoritos() {
  const navigate = useNavigate()
  const [removed, setRemoved] = useState<string[]>([])

  const visible = favorites.filter((f) => !removed.includes(f.title))

  return (
    <AppShell title="Favoritos e Marcadores" searchPlaceholder="Pesquisar favoritos...">
      <div className="px-10 py-8 max-w-[1160px] mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-[40px] font-extrabold text-[#1c1b1b] mb-1">Favoritos e Marcadores</h2>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              {visible.length} itens guardados
            </p>
          </div>
          <button onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white px-6 py-2.5 rounded-full text-sm font-semibold hover:opacity-90 transition-all">
            <span className="material-symbols-outlined text-[18px]">add</span>
            Explorar mais
          </button>
        </div>

        <div className="flex flex-col gap-4">
          {visible.map((item) => (
            <div key={item.title}
              className="bg-white rounded-xl p-5 border border-[#e0bfbc] hover:shadow-md transition-all flex items-center gap-5 group">
              <div className="w-12 h-12 bg-[#eae7e7] rounded-lg flex items-center justify-center flex-shrink-0">
                <span className="material-symbols-outlined text-[#8B1A1A]">
                  {item.category === 'Arquivo' ? 'description' : item.category === 'Jindungo' ? 'nutrition' : item.category === 'Fórum' ? 'forum' : 'article'}
                </span>
              </div>
              <div className="flex-grow cursor-pointer" onClick={() => navigate(item.route)}>
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-xs font-semibold text-[#8B1A1A] bg-[#8B1A1A]/10 px-2 py-0.5 rounded-full">{item.category}</span>
                  <span className="text-xs text-[#5d5f5d]">{item.date}</span>
                </div>
                <h3 className="text-base font-semibold text-[#1c1b1b] group-hover:text-[#8B1A1A] transition-colors">{item.title}</h3>
              </div>
              <div className="flex items-center gap-2">
                <button onClick={() => navigate(item.route)}
                  className="p-2 rounded-full hover:bg-[#f0eded] transition-colors text-[#5d5f5d] hover:text-[#8B1A1A]">
                  <span className="material-symbols-outlined text-[18px]">open_in_new</span>
                </button>
                <button onClick={() => setRemoved((r) => [...r, item.title])}
                  className="p-2 rounded-full hover:bg-red-50 transition-colors text-[#5d5f5d] hover:text-red-500">
                  <span className="material-symbols-outlined text-[18px]">bookmark_remove</span>
                </button>
              </div>
            </div>
          ))}
        </div>

        {visible.length === 0 && (
          <div className="text-center py-20">
            <span className="material-symbols-outlined text-[#8B1A1A]/20 mb-4" style={{ fontSize: '80px' }}>bookmark</span>
            <p className="text-xl font-bold text-[#1c1b1b] mb-2">Nenhum favorito ainda</p>
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
