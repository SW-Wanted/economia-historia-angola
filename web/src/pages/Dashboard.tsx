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
      <div className="px-10 py-14 max-w-[1160px] mx-auto">
        {/* Welcome */}
        <header className="mb-12">
          <h1 className="text-[44px] font-extrabold text-[#8B1A1A] mb-2 leading-tight tracking-tight font-sans">
            Olá, Carlos Tchípia
          </h1>
          <p className="text-base text-[#5d5f5d] max-w-2xl font-serif leading-relaxed">
            Bem-vindo ao seu painel de controlo. Acompanhe o seu progresso na exploração da história económica de Angola.
          </p>
        </header>

        {/* Stats grid */}
        <section className="grid grid-cols-12 gap-5 mb-12">
          {/* Points */}
          <div className="col-span-12 md:col-span-4 bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card">
            <div className="flex items-center justify-between mb-5">
              <span className="text-[11px] font-semibold text-[#8c716e] uppercase tracking-[0.08em] font-sans">Pontos de Mérito</span>
              <span className="w-8 h-8 rounded-lg bg-[#fff5f4] flex items-center justify-center">
                <span className="material-symbols-outlined text-[#8B1A1A] text-[20px]" style={{ fontVariationSettings: "'FILL' 1" }}>stars</span>
              </span>
            </div>
            <div className="text-[42px] font-bold text-[#1c1b1b] leading-none font-sans mb-2">1,250</div>
            <p className="text-xs text-[#8c716e] leading-relaxed">Top 5% de investigadores ativos este mês.</p>
          </div>

          {/* Articles */}
          <div className="col-span-12 md:col-span-4 bg-white rounded-xl p-6 border border-[#ebe5e4] shadow-card">
            <div className="flex items-center justify-between mb-5">
              <span className="text-[11px] font-semibold text-[#8c716e] uppercase tracking-[0.08em] font-sans">Artigos Lidos</span>
              <span className="w-8 h-8 rounded-lg bg-[#fff5f4] flex items-center justify-center">
                <span className="material-symbols-outlined text-[#8B1A1A] text-[20px]">library_books</span>
              </span>
            </div>
            <div className="text-[42px] font-bold text-[#1c1b1b] leading-none font-sans mb-4">42</div>
            <div className="w-full bg-[#f0eded] h-1.5 rounded-full">
              <div className="bg-[#8B1A1A] h-1.5 rounded-full w-3/4 transition-all" />
            </div>
            <p className="text-xs text-[#8c716e] mt-2">75% da colecção "Era Colonial" concluída.</p>
          </div>

          {/* Community */}
          <button
            onClick={() => navigate('/forum')}
            className="col-span-12 md:col-span-4 bg-[#8B1A1A] text-white rounded-xl p-6 shadow-card hover:shadow-md hover:-translate-y-0.5 transition-all duration-200 text-left"
          >
            <div className="flex items-center justify-between mb-5">
              <span className="text-[11px] font-semibold text-white/70 uppercase tracking-[0.08em] font-sans">Atividade na Comunidade</span>
              <span className="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center">
                <span className="material-symbols-outlined text-white text-[20px]">groups</span>
              </span>
            </div>
            <div className="flex flex-col gap-2.5 mb-4">
              {[
                { icon: 'comment', text: '12 Comentários em destaque' },
                { icon: 'thumb_up', text: '85 Reações recebidas' },
                { icon: 'share', text: '5 Contribuições para o Arquivo' },
              ].map((item) => (
                <div key={item.text} className="flex items-center gap-2.5">
                  <span className="material-symbols-outlined text-[16px] opacity-80">{item.icon}</span>
                  <span className="text-xs text-white/90">{item.text}</span>
                </div>
              ))}
            </div>
            <p className="text-xs text-white/75">Influência: <span className="font-bold text-white">Investigador Sénior</span></p>
          </button>
        </section>

        {/* Continue reading */}
        <section className="mb-12">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-bold text-[#1c1b1b] font-sans">Continuar a Ler</h2>
            <button onClick={() => navigate('/explorar')} className="text-sm font-semibold text-[#8B1A1A] flex items-center gap-1 hover:gap-2 transition-all duration-150 font-sans">
              Ver todo o arquivo
              <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
            </button>
          </div>
          <div className="grid grid-cols-12 gap-5">
            {continueReading.map((item) => (
              <article
                key={item.title}
                onClick={() => navigate(item.route)}
                className="col-span-12 md:col-span-6 bg-white rounded-xl overflow-hidden border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 cursor-pointer"
              >
                <div className="flex h-44">
                  <div className="w-1/3 h-full bg-gradient-to-br from-[#f0eded] to-[#e5e2e1] flex items-center justify-center flex-shrink-0">
                    <span className="material-symbols-outlined text-[#8B1A1A]/25" style={{ fontSize: '52px' }}>history_edu</span>
                  </div>
                  <div className="w-2/3 p-4 flex flex-col justify-between">
                    <div>
                      <div className="flex items-center gap-2 mb-2">
                        <span className="bg-[#f0eded] text-[#8c716e] text-[10px] font-bold uppercase tracking-[0.06em] px-2 py-0.5 rounded font-sans">{item.category}</span>
                        <span className="text-[#b8a5a3] text-xs">{item.time} de leitura</span>
                      </div>
                      <h3 className="text-base font-semibold text-[#1c1b1b] leading-snug font-sans">{item.title}</h3>
                    </div>
                    <div>
                      <div className="flex justify-between items-center mb-1.5">
                        <span className="text-xs text-[#8c716e]">Progresso</span>
                        <span className="text-xs font-bold text-[#8B1A1A] font-sans">{item.progress}%</span>
                      </div>
                      <div className="w-full bg-[#f0eded] h-1.5 rounded-full">
                        <div className="bg-[#8B1A1A] h-1.5 rounded-full transition-all" style={{ width: `${item.progress}%` }} />
                      </div>
                    </div>
                  </div>
                </div>
              </article>
            ))}
          </div>
        </section>

        {/* Quick nav cards */}
        <section className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-12">
          {[
            { icon: 'explore', label: 'Explorar', route: '/explorar' },
            { icon: 'quiz', label: 'Quiz', route: '/quiz' },
            { icon: 'map', label: 'Mapa', route: '/mapa' },
            { icon: 'forum', label: 'Fórum', route: '/forum' },
          ].map((item) => (
            <button
              key={item.label}
              onClick={() => navigate(item.route)}
              className="bg-white rounded-xl p-5 border border-[#ebe5e4] shadow-card hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 flex flex-col items-center gap-3 group"
            >
              <span className="w-10 h-10 rounded-xl bg-[#fff5f4] flex items-center justify-center group-hover:bg-[#8B1A1A]/10 transition-colors duration-150">
                <span className="material-symbols-outlined text-[#8B1A1A] text-[22px]">{item.icon}</span>
              </span>
              <span className="text-sm font-semibold text-[#1c1b1b] font-sans">{item.label}</span>
            </button>
          ))}
        </section>

        {/* Unlock next level */}
        <section className="bg-white rounded-xl p-7 border border-[#ebe5e4] shadow-card flex flex-col md:flex-row items-center gap-6 mb-12">
          <div className="w-12 h-12 rounded-xl bg-[#fff5f4] flex items-center justify-center flex-shrink-0">
            <span className="material-symbols-outlined text-[#8B1A1A] text-[26px]" style={{ fontVariationSettings: "'FILL' 1" }}>emoji_events</span>
          </div>
          <div className="flex-1">
            <h4 className="text-lg font-bold text-[#1c1b1b] mb-1 font-sans">Desbloqueie o Próximo Nível</h4>
            <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
              Conclua o módulo "Caminhos de Ferro de Benguela" para ganhar o emblema 'Conector da Nação' e 500 pontos extras.
            </p>
          </div>
          <button
            onClick={() => navigate('/explorar')}
            className="flex items-center gap-2 bg-[#8B1A1A] text-white font-semibold py-2.5 px-5 rounded-full hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150 text-sm whitespace-nowrap font-sans"
          >
            Explorar Colecção
            <span className="material-symbols-outlined text-[18px]">trending_up</span>
          </button>
        </section>
      </div>

      {/* Footer */}
      <footer className="bg-white border-t border-[#ebe5e4]">
        <div className="flex flex-col md:flex-row justify-between items-center px-10 py-6 max-w-[1160px] mx-auto">
          <div className="flex flex-col mb-4 md:mb-0">
            <span className="text-base font-bold text-[#8B1A1A] font-sans">Economia com História</span>
            <p className="text-xs text-[#b8a5a3]">© 2026 Economia com História – Angola. Todos os direitos reservados.</p>
          </div>
          <div className="flex gap-6">
            {['Sobre', 'Termos de Uso', 'Privacidade', 'Contacto'].map((l) => (
              <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-[#8c716e] hover:text-[#8B1A1A] transition-colors duration-150 font-sans">{l}</button>
            ))}
          </div>
        </div>
      </footer>
    </AppShell>
  )
}
