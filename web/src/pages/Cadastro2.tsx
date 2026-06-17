import { useNavigate } from 'react-router-dom'

export default function Cadastro2() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6" style={{ backgroundColor: '#F2F2F0', fontFamily: "'Plus Jakarta Sans', sans-serif" }}>
      <div className="mb-8 flex flex-col items-center text-center">
        <h2 className="text-2xl font-bold text-[#8B1A1A] mb-1">Economia com História</h2>
        <p className="text-xs text-[#5d5f5d] tracking-widest uppercase">Angola</p>
      </div>

      <main className="w-full max-w-[480px] bg-white rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.04)] border border-[#e0bfbc]/30 overflow-hidden">
        <div className="h-1.5 w-full bg-[#f0eded] flex">
          <div className="h-full bg-[#8B1A1A] transition-all duration-500" style={{ width: '66.66%' }} />
        </div>

        <div className="p-10 flex flex-col gap-8">
          <header className="flex flex-col gap-2">
            <span className="text-xs font-bold text-[#8B1A1A]">Passo 2 de 3</span>
            <h1 className="text-[32px] font-bold text-[#1c1b1b]">Perfil de Investigador</h1>
            <p className="text-base text-[#5d5f5d]" style={{ fontFamily: 'Merriweather, serif' }}>
              Diga-nos um pouco mais sobre si para personalizar a sua experiência.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={(e) => { e.preventDefault(); navigate('/cadastro/3') }}>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Área de interesse</label>
              <select className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]">
                <option value="">Selecione a sua área</option>
                <option>História Económica</option>
                <option>Economia Colonial</option>
                <option>Pós-Independência</option>
                <option>Economia Contemporânea</option>
              </select>
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Perfil</label>
              <select className="w-full bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg p-4 focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all text-[#1c1b1b]">
                <option value="">Selecione o seu perfil</option>
                <option>Estudante</option>
                <option>Académico / Investigador</option>
                <option>Jornalista</option>
                <option>Curioso / Entusiasta</option>
              </select>
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-[#58413f]">Palavra-passe</label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-[#5d5f5d] text-[20px]">lock</span>
                <input
                  type="password"
                  placeholder="Mínimo 8 caracteres"
                  className="w-full pl-12 pr-4 py-4 bg-[#f6f3f2] border border-[#e0bfbc] rounded-lg focus:ring-1 focus:ring-[#8B1A1A] outline-none transition-all"
                />
              </div>
            </div>

            <div className="mt-2 flex gap-4">
              <button
                type="button"
                onClick={() => navigate('/cadastro')}
                className="flex-1 border border-[#8B1A1A] text-[#8B1A1A] text-sm font-semibold py-4 rounded-full hover:bg-[#f0eded] transition-colors"
              >
                Voltar
              </button>
              <button
                type="submit"
                className="flex-1 bg-[#8B1A1A] text-white text-sm font-semibold py-4 rounded-full hover:opacity-90 transition-colors active:scale-95"
              >
                Continuar
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  )
}
