import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

export default function Cadastro1() {
  const navigate = useNavigate()
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [error, setError] = useState('')
  const [oauthInfo, setOauthInfo] = useState('')

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    if (!name.trim()) { setError('Por favor, introduza o seu nome.'); return }
    if (!email.trim()) { setError('Por favor, introduza o seu email.'); return }
    sessionStorage.setItem('reg_name', name.trim())
    sessionStorage.setItem('reg_email', email.trim())
    navigate('/cadastro/2')
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-6 font-sans" style={{ backgroundColor: '#F2F2F0' }}>
      <div className="mb-7 flex flex-col items-center text-center">
        <div className="w-10 h-10 rounded-xl bg-[#fff5f4] flex items-center justify-center mb-3">
          <span className="material-symbols-outlined text-[#8B1A1A]" style={{ fontSize: '22px', fontVariationSettings: "'FILL' 1" }}>account_balance</span>
        </div>
        <h2 className="text-base font-bold text-[#8B1A1A] font-sans tracking-tight">Economia com História</h2>
        <p className="text-[10px] text-[#8c716e] tracking-[0.12em] uppercase font-sans mt-0.5">Angola</p>
      </div>

      <main className="w-full max-w-[440px] bg-white rounded-2xl shadow-lg border border-[#ebe5e4] overflow-hidden">
        <div className="h-1 w-full bg-[#f0eded]">
          <div className="h-full bg-[#8B1A1A] transition-all duration-500" style={{ width: '33.33%' }} />
        </div>

        <div className="px-8 py-8 flex flex-col gap-6">
          <header className="flex flex-col gap-1.5">
            <span className="text-[10px] font-bold text-[#8B1A1A] uppercase tracking-[0.1em] font-sans">Passo 1 de 3</span>
            <h1 className="text-2xl font-bold text-[#1c1b1b] font-sans tracking-tight">Criar Conta</h1>
            <p className="text-sm text-[#5d5f5d] font-serif leading-relaxed">
              Comece a sua jornada pela história económica de Angola registando os seus dados.
            </p>
          </header>

          <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-[#58413f] font-sans uppercase tracking-[0.05em]">Nome Completo</label>
              <input
                type="text"
                placeholder="Ex: Manuel dos Santos"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                className="w-full bg-[#f8f5f4] border border-[#e8e0de] rounded-lg px-4 py-2.5 focus:bg-white focus:border-[#8B1A1A] focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 text-sm font-serif placeholder:text-[#c4b5b3]"
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-[#58413f] font-sans uppercase tracking-[0.05em]">Email</label>
              <input
                type="email"
                placeholder="nome@exemplo.ao"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="w-full bg-[#f8f5f4] border border-[#e8e0de] rounded-lg px-4 py-2.5 focus:bg-white focus:border-[#8B1A1A] focus:ring-2 focus:ring-[#8B1A1A]/10 outline-none transition-all duration-150 text-sm font-serif placeholder:text-[#c4b5b3]"
              />
            </div>

            {error && (
              <p className="text-xs text-red-700 bg-red-50 border border-red-200 rounded-lg px-3 py-2 font-sans">{error}</p>
            )}

            <div className="mt-1 flex flex-col gap-3">
              <button
                type="submit"
                className="w-full bg-[#8B1A1A] text-white text-sm font-semibold font-sans py-3 rounded-full hover:bg-[#7a1616] hover:shadow-md active:scale-[0.98] transition-all duration-150"
              >
                Continuar
              </button>
              <button
                type="button"
                onClick={() => setOauthInfo('O registo via Google ainda não está disponível. Por favor, preencha o formulário.')}
                className="w-full flex items-center justify-center gap-2.5 border border-[#e8e0de] text-[#8c716e] py-3 rounded-full text-sm font-semibold font-sans hover:bg-[#f8f5f4] transition-all duration-150 opacity-60 cursor-not-allowed"
              >
                <span className="material-symbols-outlined text-[18px] text-[#5d5f5d]">language</span>
                Registar com Google
              </button>
              {oauthInfo && (
                <p className="text-xs text-[#8c716e] bg-[#f8f5f4] border border-[#e8e0de] rounded-lg px-3 py-2 text-center font-sans">{oauthInfo}</p>
              )}
            </div>
          </form>

          <footer className="pt-5 border-t border-[#ebe5e4] text-center">
            <p className="text-sm text-[#5d5f5d] font-serif">
              Já tem conta?{' '}
              <button onClick={() => navigate('/login')} className="text-[#8B1A1A] font-bold hover:text-[#7a1616] font-sans transition-colors duration-150">
                Iniciar Sessão
              </button>
            </p>
          </footer>
        </div>
      </main>
    </div>
  )
}
