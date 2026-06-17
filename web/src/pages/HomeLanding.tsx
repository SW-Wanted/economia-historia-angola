import { useNavigate } from 'react-router-dom'

export default function HomeLanding() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen font-sans" style={{ backgroundColor: '#F2F2F0' }}>
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 h-screen w-[280px] bg-[#fcf9f8] border-r border-[#ebe5e4] flex flex-col p-5 gap-6 z-50">
        <div className="flex items-center gap-2.5 cursor-pointer px-1 pt-1" onClick={() => navigate('/dashboard')}>
          <span className="material-symbols-outlined text-[#8B1A1A] text-3xl flex-shrink-0" style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
          <span className="font-bold text-[#8B1A1A] text-base leading-tight tracking-tight">Economia com História</span>
        </div>
        <nav className="flex flex-col gap-0.5">
          {[
            { label: 'Início', icon: 'home', route: '/dashboard', active: true },
            { label: 'Explorar', icon: 'explore', route: '/explorar' },
            { label: 'Mapa Económico', icon: 'map', route: '/mapa' },
            { label: 'Fórum', icon: 'forum', route: '/forum' },
          ].map((item) => (
            <button
              key={item.label}
              onClick={() => navigate(item.route)}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-semibold font-sans transition-all duration-150 text-left ${
                item.active
                  ? 'bg-[#8B1A1A] text-white shadow-xs'
                  : 'text-[#4a4a4a] hover:bg-[#f0eded] hover:text-[#1c1b1b]'
              }`}
            >
              <span className="material-symbols-outlined flex-shrink-0">{item.icon}</span>{item.label}
            </button>
          ))}
        </nav>
        <div className="mt-auto flex flex-col gap-1.5">
          <button
            onClick={() => navigate('/login')}
            className="flex items-center gap-3 text-[#5d5f5d] px-3 py-2.5 hover:bg-[#f0eded] hover:text-[#1c1b1b] rounded-lg text-sm font-semibold font-sans transition-all duration-150"
          >
            <span className="material-symbols-outlined flex-shrink-0">login</span>Entrar
          </button>
          <button
            onClick={() => navigate('/cadastro')}
            className="flex items-center gap-3 bg-[#8B1A1A] text-white rounded-lg px-3 py-2.5 font-bold text-sm font-sans shadow-xs hover:bg-[#7a1616] transition-all duration-150"
          >
            <span className="material-symbols-outlined flex-shrink-0">person_add</span>Criar conta
          </button>
        </div>
      </aside>

      <main className="ml-[280px]">
        {/* Hero */}
        <section className="relative min-h-[80vh] flex items-center justify-center text-center px-10 overflow-hidden bg-[#8B1A1A]">
          <div className="absolute inset-0 opacity-[0.06]" style={{ backgroundImage: 'radial-gradient(white 0.5px, transparent 0.5px)', backgroundSize: '20px 20px' }} />
          <div className="relative z-10 max-w-3xl">
            <p className="text-white/60 text-xs uppercase tracking-[0.15em] mb-6 font-sans">Plataforma de História Económica</p>
            <h1 className="text-5xl font-extrabold text-white mb-6 leading-tight tracking-tight">
              Compreenda o presente de Angola através do passado
            </h1>
            <p className="text-white/80 mb-10 max-w-xl mx-auto text-base font-serif leading-relaxed">
              A primeira plataforma digital dedicada a explicar a economia angolana com rigor histórico.
            </p>
            <div className="flex flex-col sm:flex-row gap-3 justify-center">
              <button
                onClick={() => navigate('/cadastro')}
                className="bg-white text-[#8B1A1A] font-bold px-8 py-3.5 rounded-full hover:-translate-y-0.5 hover:shadow-lg transition-all duration-150 text-sm"
              >
                Criar Conta Grátis
              </button>
              <button
                onClick={() => navigate('/explorar')}
                className="border border-white/40 text-white font-bold px-8 py-3.5 rounded-full hover:bg-white/10 hover:border-white/70 transition-all duration-150 text-sm"
              >
                Explorar Temas
              </button>
            </div>
          </div>
        </section>

        {/* Features */}
        <div className="max-w-[1160px] mx-auto py-14 px-10 space-y-12">
          <section className="grid grid-cols-1 md:grid-cols-3 gap-5">
            {[
              { icon: 'description', title: 'Microtextos', desc: 'Pílulas de conhecimento rápido para ler em 5 minutos.', route: '/explorar' },
              { icon: 'nutrition', title: 'Textos Jindungo', desc: 'Análises profundas sobre a nossa herança económica.', route: '/leitura/jindungo', filled: true },
              { icon: 'map', title: 'Mapa Económico', desc: 'Navegue pelas rotas comerciais históricas de Angola.', route: '/mapa' },
            ].map((item) => (
              <button
                key={item.title}
                onClick={() => navigate(item.route)}
                className="bg-white p-7 rounded-xl shadow-card border border-[#ebe5e4] hover:shadow-card-hover hover:-translate-y-0.5 transition-all duration-200 text-left"
              >
                <div className={`w-12 h-12 rounded-xl flex items-center justify-center mb-5 ${item.filled ? 'bg-[#8B1A1A] text-white' : 'bg-[#fff5f4] text-[#8B1A1A]'}`}>
                  <span className="material-symbols-outlined text-2xl">{item.icon}</span>
                </div>
                <h3 className="text-base font-semibold mb-2 font-sans text-[#1c1b1b]">{item.title}</h3>
                <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">{item.desc}</p>
              </button>
            ))}
          </section>

          {/* Quiz CTA */}
          <section className="bg-[#8B1A1A] rounded-xl p-8 flex flex-col md:flex-row items-center justify-between gap-6">
            <div className="flex items-center gap-5">
              <div className="w-12 h-12 bg-white/15 rounded-xl flex items-center justify-center text-white flex-shrink-0">
                <span className="material-symbols-outlined text-2xl">quiz</span>
              </div>
              <div className="text-white">
                <h3 className="text-lg font-bold mb-0.5 font-sans">Quiz da Semana</h3>
                <p className="text-white/75 text-sm font-serif">O quanto sabe sobre a indústria têxtil angolana dos anos 60?</p>
              </div>
            </div>
            <button
              onClick={() => navigate('/quiz')}
              className="bg-white text-[#8B1A1A] px-7 py-3 rounded-full font-bold font-sans text-sm whitespace-nowrap hover:-translate-y-0.5 hover:shadow-md transition-all duration-150"
            >
              Participar Agora
            </button>
          </section>

          {/* CTA */}
          <section className="bg-[#fff5f4] p-12 rounded-xl text-center border border-[#8B1A1A]/10">
            <h2 className="text-3xl font-bold mb-3 font-sans tracking-tight text-[#1c1b1b]">Pronto para redescobrir a nossa história?</h2>
            <p className="text-base mb-8 text-[#5d5f5d] font-serif max-w-md mx-auto leading-relaxed">Junte-se a milhares de angolanos nesta jornada de conhecimento.</p>
            <button
              onClick={() => navigate('/cadastro')}
              className="bg-[#8B1A1A] text-white font-bold px-10 py-3.5 rounded-full font-sans text-sm hover:bg-[#7a1616] hover:shadow-lg active:scale-[0.98] transition-all duration-150"
            >
              Criar a Minha Conta Agora
            </button>
          </section>
        </div>

        <footer className="bg-white border-t border-[#ebe5e4]">
          <div className="flex justify-between items-center px-10 py-6 max-w-[1160px] mx-auto">
            <div>
              <span className="font-bold text-[#8B1A1A] text-base font-sans">Economia com História</span>
              <p className="text-xs text-[#b8a5a3] font-sans">© 2026 Economia com História – Angola.</p>
            </div>
            <div className="flex gap-6">
              {['Sobre', 'Termos', 'Privacidade', 'Contacto'].map((l) => (
                <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-[#8c716e] hover:text-[#8B1A1A] font-sans transition-colors duration-150">{l}</button>
              ))}
            </div>
          </div>
        </footer>
      </main>
    </div>
  )
}
