import { useNavigate } from 'react-router-dom'

export default function Login() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex items-center justify-center relative overflow-hidden" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(#8B1A1A 0.5px, transparent 0.5px)', backgroundSize: '24px 24px' }} />

      <main className="w-full max-w-[480px] px-4 z-10">
        <div className="bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] p-16 flex flex-col items-center">
          {/* Logo */}
          <div className="mb-8 flex flex-col items-center gap-2">
            <span className="material-symbols-outlined text-[#8B1A1A]" style={{ fontSize: '48px', fontVariationSettings: "'FILL' 1" }}>account_balance</span>
            <div className="text-center">
              <h1 className="font-bold text-[#8B1A1A] text-xl tracking-tight">Economia com História</h1>
              <p className="text-xs text-[#5d5f5d] uppercase tracking-widest">Angola</p>
            </div>
          </div>

          <div className="text-center mb-8">
            <h2 className="text-2xl font-bold text-[#1c1b1b]">Aceda à sua conta</h2>
            <p className="text-base text-[#5d5f5d] mt-2" style={{ fontFamily: 'Merriweather, serif' }}>Aceda à sua conta para continuar a ler.</p>
          </div>

          <form className="w-full space-y-4" onSubmit={(e) => { e.preventDefault(); navigate('/dashboard') }}>
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-[#58413f]">Email</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-[#5d5f5d] text-[20px]">mail</span>
                <input
                  type="email"
                  placeholder="nome@exemplo.com"
                  defaultValue="carlos@exemplo.ao"
                  className="w-full pl-12 pr-4 py-3 bg-[#fcf9f8] rounded-lg border border-[#e0bfbc] focus:border-[#8B1A1A] focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all"
                  style={{ fontFamily: 'Merriweather, serif' }}
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="block text-sm font-semibold text-[#58413f]">Palavra-passe</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-[#5d5f5d] text-[20px]">lock</span>
                <input
                  type="password"
                  placeholder="••••••••"
                  defaultValue="password"
                  className="w-full pl-12 pr-12 py-3 bg-[#fcf9f8] rounded-lg border border-[#e0bfbc] focus:border-[#8B1A1A] focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all"
                />
              </div>
            </div>

            <div className="flex items-center justify-between py-2">
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="checkbox" className="w-4 h-4 rounded border-[#e0bfbc] text-[#8B1A1A]" />
                <span className="text-sm text-[#5d5f5d]">Lembrar-me</span>
              </label>
              <button
                type="button"
                onClick={() => navigate('/recuperar-senha')}
                className="text-sm text-[#8B1A1A] hover:underline font-bold"
              >
                Esqueceu a senha?
              </button>
            </div>

            <button
              type="submit"
              className="w-full bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-all active:scale-[0.98] shadow-sm"
            >
              Entrar
            </button>
          </form>

          <div className="w-full flex items-center gap-4 my-8">
            <div className="h-px flex-grow bg-[#e0bfbc]" />
            <span className="text-xs text-[#5d5f5d] uppercase tracking-widest">ou aceder com</span>
            <div className="h-px flex-grow bg-[#e0bfbc]" />
          </div>

          <div className="w-full flex gap-4 mb-8">
            <button
              onClick={() => navigate('/dashboard')}
              className="flex-1 flex items-center justify-center gap-2 py-3 border border-[#e0bfbc] rounded-lg text-sm font-semibold text-[#1c1b1b] hover:bg-[#eae7e7] transition-colors"
            >
              <span className="material-symbols-outlined text-[18px]">language</span>
              Google
            </button>
            <button
              onClick={() => navigate('/dashboard')}
              className="flex-1 flex items-center justify-center gap-2 py-3 border border-[#e0bfbc] rounded-lg text-sm font-semibold text-[#1c1b1b] hover:bg-[#eae7e7] transition-colors"
            >
              <span className="material-symbols-outlined text-[18px]">work</span>
              LinkedIn
            </button>
          </div>

          <div className="text-center pt-4 border-t border-[#e0bfbc] w-full">
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Não tem conta?{' '}
              <button onClick={() => navigate('/cadastro')} className="text-[#8B1A1A] font-bold hover:underline ml-1">
                Criar conta grátis
              </button>
            </p>
          </div>
        </div>

        <div className="mt-8 flex justify-center gap-8">
          {['Sobre', 'Termos', 'Privacidade', 'Contacto'].map((l) => (
            <button key={l} onClick={() => navigate('/ajuda')} className="text-xs text-[#5d5f5d] hover:text-[#8B1A1A] transition-colors">
              {l}
            </button>
          ))}
        </div>
      </main>
    </div>
  )
}
