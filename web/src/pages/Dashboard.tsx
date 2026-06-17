import { useNavigate } from 'react-router-dom'
import AppShell from '../components/AppShell'

const continueReading = [
  { category: 'Microtextos', time: '8 min', title: 'A Rota dos Diamantes: Da Exploração Colonial à Independência', progress: 60, route: '/leitura/microtexto' },
  { category: 'Arquivo', time: '12 min', title: 'O Ciclo do Café e a Transformação do Planalto Central', progress: 25, route: '/leitura/microtexto' },
]

export default function Dashboard() {
  const navigate = useNavigate()

  return (
    <AppShell searchPlaceholder="Pesquisar arquivo...">
      <div className="px-10 py-16 max-w-[1160px] mx-auto">
        {/* Welcome */}
        <header className="mb-16">
          <h1 className="text-[48px] font-extrabold text-[#8B1A1A] mb-2 leading-tight">Olá, Carlos Tchípia</h1>
          <p className="text-lg text-[#5d5f5d] max-w-2xl" style={{ fontFamily: 'Merriweather, serif' }}>
            Bem-vindo ao seu painel de controlo. Acompanhe o seu progresso na exploração da história económica de Angola.
          </p>
        </header>

        {/* Stats grid */}
        <section className="grid grid-cols-12 gap-6 mb-16">
          {/* Points */}
          <div className="col-span-12 md:col-span-4 bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
            <div className="flex items-center justify-between mb-4">
              <span className="text-xs font-semibold text-[#5d5f5d] uppercase tracking-widest">Pontos de Mérito</span>
              <span className="material-symbols-outlined text-[#8B1A1A]" style={{ fontVariationSettings: "'FILL' 1" }}>stars</span>
            </div>
            <div className="text-[48px] font-bold text-[#1c1b1b]">1,250</div>
            <p className="text-xs text-[#5d5f5d] mt-2">Você está no Top 5% de investigadores ativos este mês.</p>
          </div>

          {/* Articles */}
          <div className="col-span-12 md:col-span-4 bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)]">
            <div className="flex items-center justify-between mb-4">
              <span className="text-xs font-semibold text-[#5d5f5d] uppercase tracking-widest">Artigos Lidos</span>
              <span className="material-symbols-outlined text-[#8B1A1A]">library_books</span>
            </div>
            <div className="text-[48px] font-bold text-[#1c1b1b]">42</div>
            <div className="w-full bg-[#f0eded] h-2 rounded-full mt-4">
              <div className="bg-[#8B1A1A] h-2 rounded-full w-3/4" />
            </div>
            <p className="text-xs text-[#5d5f5d] mt-2">75% da colecção "Era Colonial" concluída.</p>
          </div>

          {/* Community */}
          <button
            onClick={() => navigate('/forum')}
            className="col-span-12 md:col-span-4 bg-[#8B1A1A] text-white rounded-xl p-8 shadow-[0px_4px_20px_rgba(0,0,0,0.04)] hover:opacity-95 transition-opacity text-left"
          >
            <div className="flex items-center justify-between mb-4">
              <span className="text-xs font-semibold text-white/80 uppercase tracking-widest">Atividade na Comunidade</span>
              <span className="material-symbols-outlined text-white">groups</span>
            </div>
            <div className="flex flex-col gap-2 mb-4">
              {[
                { icon: 'comment', text: '12 Comentários em destaque' },
                { icon: 'thumb_up', text: '85 Reações recebidas' },
                { icon: 'share', text: '5 Contribuições para o Arquivo' },
              ].map((item) => (
                <div key={item.text} className="flex items-center gap-3">
                  <span className="material-symbols-outlined text-sm">{item.icon}</span>
                  <span className="text-xs">{item.text}</span>
                </div>
              ))}
            </div>
            <p className="text-xs text-white/90">Influência: <span className="font-bold">Investigador Sénior</span></p>
          </button>
        </section>

        {/* Continue reading */}
        <section className="mb-16">
          <div className="flex items-center justify-between mb-8">
            <h2 className="text-2xl font-bold text-[#1c1b1b]">Continuar a Ler</h2>
            <button onClick={() => navigate('/explorar')} className="text-sm font-semibold text-[#8B1A1A] flex items-center gap-1 hover:underline">
              Ver todo o arquivo
              <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
            </button>
          </div>
          <div className="grid grid-cols-12 gap-6">
            {continueReading.map((item) => (
              <article
                key={item.title}
                onClick={() => navigate(item.route)}
                className="col-span-12 md:col-span-6 bg-white rounded-xl overflow-hidden border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] hover:-translate-y-1 transition-transform cursor-pointer"
              >
                <div className="flex h-48">
                  <div className="w-1/3 h-full bg-[#eae7e7] flex items-center justify-center">
                    <span className="material-symbols-outlined text-[#8B1A1A]/30" style={{ fontSize: '60px' }}>history_edu</span>
                  </div>
                  <div className="w-2/3 p-4 flex flex-col justify-between">
                    <div>
                      <div className="flex items-center gap-2 mb-2">
                        <span className="bg-[#f0eded] text-[#5d5f5d] text-[10px] font-bold uppercase tracking-widest px-2 py-1 rounded">{item.category}</span>
                        <span className="text-[#5d5f5d] text-xs">{item.time} de leitura</span>
                      </div>
                      <h3 className="text-xl font-semibold text-[#1c1b1b] leading-tight">{item.title}</h3>
                    </div>
                    <div>
                      <div className="flex justify-between items-center mb-1">
                        <span className="text-xs text-[#5d5f5d]">Progresso</span>
                        <span className="text-xs font-bold text-[#8B1A1A]">{item.progress}%</span>
                      </div>
                      <div className="w-full bg-[#f0eded] h-1 rounded-full">
                        <div className="bg-[#8B1A1A] h-1 rounded-full" style={{ width: `${item.progress}%` }} />
                      </div>
                    </div>
                  </div>
                </div>
              </article>
            ))}
          </div>
        </section>

        {/* Quick nav cards */}
        <section className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
          {[
            { icon: 'explore', label: 'Explorar', route: '/explorar' },
            { icon: 'quiz', label: 'Quiz', route: '/quiz' },
            { icon: 'map', label: 'Mapa', route: '/mapa' },
            { icon: 'forum', label: 'Fórum', route: '/forum' },
          ].map((item) => (
            <button
              key={item.label}
              onClick={() => navigate(item.route)}
              className="bg-white rounded-xl p-6 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] hover:-translate-y-1 transition-transform flex flex-col items-center gap-3"
            >
              <span className="material-symbols-outlined text-[#8B1A1A] text-4xl">{item.icon}</span>
              <span className="text-sm font-semibold text-[#1c1b1b]">{item.label}</span>
            </button>
          ))}
        </section>

        {/* Unlock next level */}
        <section className="bg-white rounded-xl p-8 border border-[#e0bfbc] shadow-[0px_4px_20px_rgba(0,0,0,0.04)] flex flex-col md:flex-row items-center gap-8">
          <div className="flex-1">
            <h4 className="text-2xl font-bold text-[#1c1b1b] mb-3">Desbloqueie o Próximo Nível</h4>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Conclua o módulo de "Caminhos de Ferro de Benguela" para ganhar o emblema de 'Conector da Nação' e 500 pontos extras.
            </p>
          </div>
          <button
            onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white font-bold py-3 px-6 rounded-full hover:opacity-90 transition-all text-sm whitespace-nowrap"
          >
            Explorar Colecção
            <span className="material-symbols-outlined">trending_up</span>
          </button>
        </section>
      </div>

      {/* Footer */}
      <footer className="bg-white border-t border-[#e0bfbc] ml-0">
        <div className="flex flex-col md:flex-row justify-between items-center px-10 py-8 max-w-[1160px] mx-auto">
          <div className="flex flex-col mb-4 md:mb-0">
            <span className="text-xl font-bold text-[#8B1A1A]">Economia com História</span>
            <p className="text-xs text-[#5d5f5d]">© 2026 Economia com História – Angola. Todos os direitos reservados.</p>
          </div>
          <div className="flex gap-8">
            {['Sobre', 'Termos de Uso', 'Privacidade', 'Contacto'].map((l) => (
              <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors">{l}</button>
            ))}
          </div>
        </div>
      </footer>
    </AppShell>
  )
}
