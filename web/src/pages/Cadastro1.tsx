import { useNavigate } from 'react-router-dom'

export default function Cadastro1() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <div className="mb-8 flex flex-col items-center text-center">
        <h2 className="text-2xl font-bold text-[#8B1A1A] mb-1">Economia com História</h2>
        <p className="text-xs text-[#5d5f5d] tracking-widest uppercase">Angola</p>
      </div>

      <main className="w-full max-w-[480px] bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 overflow-hidden">
        {/* Progress bar */}
        <div className="h-1.5 w-full bg-[#f0eded] flex">
          <div className="h-full bg-[#8B1A1A] transition-all duration-500" style={{ width: '33.33%' }} />
        </div>

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col gap-2">
            <span className="text-xs font-bold text-[#8B1A1A]">Passo 1 de 3</span>
            <h1 className="text-[32px] font-bold text-[#1c1b1b]">Criar Conta</h1>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Comece a sua jornada pela história económica de Angola registando os seus dados.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={(e) => { e.preventDefault(); navigate('/cadastro/2') }}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Nome Completo</label>
              <input
                type="text"
                placeholder="Ex: Manuel dos Santos"
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] focus:border-[#8B1A1A] outline-none transition-all"
                style={{ fontFamily: 'Merriweather, serif' }}
              />
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Email</label>
              <input
                type="email"
                placeholder="nome@exemplo.ao"
                className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] focus:border-[#8B1A1A] outline-none transition-all"
                style={{ fontFamily: 'Merriweather, serif' }}
              />
            </div>

            <div className="mt-2 flex flex-col gap-4">
              <button
                type="submit"
                className="w-full bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-colors active:scale-95 transform"
              >
                Continuar
              </button>
              <button
                type="button"
                onClick={() => navigate('/dashboard')}
                className="w-full flex items-center justify-center gap-3 border border-[#e0bfbc] text-[#1c1b1b] py-3.5 rounded-full text-sm font-semibold hover:bg-[#f6f3f2] transition-all"
              >
                <span className="material-symbols-outlined text-[18px]">language</span>
                Registar com Google
              </button>
            </div>
          </form>

          <footer className="pt-4 border-t border-[#e0bfbc] text-center">
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Já tem conta?{' '}
              <button onClick={() => navigate('/login')} className="text-[#8B1A1A] font-bold hover:underline">
                Iniciar Sessão
              </button>
            </p>
          </footer>
        </div>
      </main>
    </div>
  )
}
