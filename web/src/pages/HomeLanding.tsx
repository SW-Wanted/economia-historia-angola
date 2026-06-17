import { useNavigate } from 'react-router-dom'

export default function HomeLanding() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 h-screen w-[280px] bg-[#fcf9f8] border-r border-[#e0bfbc] flex flex-col p-8 gap-8 z-50">
        <div className="flex items-center gap-2 cursor-pointer" onClick={() => navigate('/dashboard')}>
          <span className="material-symbols-outlined text-[#8B1A1A] text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>account_balance</span>
          <span className="font-bold text-[#8B1A1A] text-xl leading-tight">Economia com História</span>
        </div>
        <nav className="flex flex-col gap-2">
          {[
            { label: 'Início', icon: 'home', route: '/dashboard', active: true },
            { label: 'Explorar', icon: 'explore', route: '/explorar' },
            { label: 'Mapa Económico', icon: 'map', route: '/mapa' },
            { label: 'Fórum', icon: 'forum', route: '/forum' },
          ].map((item) => (
            <button key={item.label} onClick={() => navigate(item.route)}
              className={`flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-semibold transition-colors text-left ${item.active ? 'bg-[#8B1A1A] text-white' : 'text-[#5d5f5d] hover:bg-[#eae7e7]'}`}>
              <span className="material-symbols-outlined">{item.icon}</span>{item.label}
            </button>
          ))}
        </nav>
        <div className="mt-auto flex flex-col gap-2">
          <button onClick={() => navigate('/login')} className="flex items-center gap-3 text-[#5d5f5d] px-4 py-3 hover:bg-[#eae7e7] rounded-xl text-sm font-semibold">
            <span className="material-symbols-outlined">login</span>Entrar
          </button>
          <button onClick={() => navigate('/cadastro')} className="flex items-center gap-3 bg-[#8B1A1A] text-white rounded-xl px-4 py-3 font-bold text-sm shadow-sm">
            <span className="material-symbols-outlined">person_add</span>Criar conta
          </button>
        </div>
      </aside>

      <main className="ml-[280px]">
        {/* Hero */}
        <section className="relative min-h-[85vh] flex items-center justify-center text-center px-10 overflow-hidden bg-[#8B1A1A]">
          <div className="relative z-10 max-w-4xl">
            <h1 className="text-6xl font-extrabold text-white mb-8 leading-tight">Compreenda o presente de Angola através do passado</h1>
            <p className="text-white/90 mb-12 max-w-2xl mx-auto text-xl" style={{ fontFamily: 'Merriweather, serif' }}>
              A primeira plataforma digital dedicada a explicar a economia angolana com rigor histórico.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <button onClick={() => navigate('/cadastro')} className="bg-white text-[#8B1A1A] font-bold px-10 py-5 rounded-xl hover:bg-[#f0eded] transition-all shadow-xl text-sm">CRIAR CONTA GRÁTIS</button>
              <button onClick={() => navigate('/explorar')} className="border-2 border-white text-white font-bold px-10 py-5 rounded-xl hover:bg-white/10 transition-all text-sm">EXPLORAR TEMAS</button>
            </div>
          </div>
        </section>

        {/* Features */}
        <div className="max-w-[1160px] mx-auto py-16 px-10 space-y-16">
          <section className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              { icon: 'description', title: 'Microtextos', desc: 'Pílulas de conhecimento rápido para ler em 5 minutos.', route: '/explorar' },
              { icon: 'nutrition', title: 'Textos Jindungo', desc: 'Análises profundas sobre a nossa herança económica.', route: '/leitura/jindungo', filled: true },
              { icon: 'map', title: 'Mapa Económico', desc: 'Navegue pelas rotas comerciais históricas de Angola.', route: '/mapa' },
            ].map((item) => (
              <button key={item.title} onClick={() => navigate(item.route)}
                className="bg-white p-8 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.06)] hover:-translate-y-2 transition-transform text-left">
                <div className={`w-14 h-14 rounded-xl flex items-center justify-center mb-6 ${item.filled ? 'bg-[#8B1A1A] text-white' : 'bg-[#8B1A1A]/10 text-[#8B1A1A]'}`}>
                  <span className="material-symbols-outlined text-3xl">{item.icon}</span>
                </div>
                <h3 className="text-xl font-semibold mb-3">{item.title}</h3>
                <p className="text-[#5d5f5d] text-base" style={{ fontFamily: 'Merriweather, serif' }}>{item.desc}</p>
              </button>
            ))}
          </section>

          {/* Quiz CTA */}
          <section className="bg-[#8B1A1A] rounded-xl p-10 flex flex-col md:flex-row items-center justify-between gap-8">
            <div className="flex items-center gap-6">
              <div className="w-16 h-16 bg-white/20 rounded-xl flex items-center justify-center text-white">
                <span className="material-symbols-outlined text-4xl">quiz</span>
              </div>
              <div className="text-white">
                <h3 className="text-2xl font-bold mb-1">Quiz da Semana</h3>
                <p className="text-white/80">O quanto sabe sobre a indústria têxtil angolana dos anos 60?</p>
              </div>
            </div>
            <button onClick={() => navigate('/quiz')} className="bg-white text-[#8B1A1A] px-8 py-4 rounded-xl font-bold hover:scale-105 transition-transform text-sm whitespace-nowrap">PARTICIPAR AGORA</button>
          </section>

          {/* CTA */}
          <section className="bg-[#ffdad6] p-16 rounded-xl text-center">
            <h2 className="text-4xl font-bold mb-4">Pronto para redescobrir a nossa história?</h2>
            <p className="text-xl mb-10 text-[#5d5f5d]">Junte-se a milhares de angolanos nesta jornada de conhecimento.</p>
            <button onClick={() => navigate('/cadastro')} className="bg-[#8B1A1A] text-white font-bold px-12 py-6 rounded-xl hover:shadow-2xl transition-all text-sm">CRIAR A MINHA CONTA AGORA</button>
          </section>
        </div>

        <footer className="bg-white border-t border-[#e0bfbc]">
          <div className="flex justify-between items-center px-10 py-8 max-w-[1160px] mx-auto">
            <div>
              <span className="font-bold text-[#8B1A1A] text-xl">Economia com História</span>
              <p className="text-xs text-[#5d5f5d]">© 2026 Economia com História – Angola.</p>
            </div>
            <div className="flex gap-8">
              {['Sobre', 'Termos', 'Privacidade', 'Contacto'].map((l) => (
                <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-[#5d5f5d] hover:text-[#8B1A1A]">{l}</button>
              ))}
            </div>
          </div>
        </footer>
      </main>
    </div>
  )
}
